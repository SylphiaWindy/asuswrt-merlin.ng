#!/bin/bash
# 构建看门狗：多重护栏，任一触发即杀容器并记录原因。
# 装在机器上而不是留在轮询循环里 —— 上一次失控（make 递归 1435 层、388 万行日志、
# 负载 657、跑了 383 分钟）之所以没被拦住，是因为我的检测只看「CPU < 5%」，
# 而失控是**高 CPU**。单一指标不够。
NAME=${1:-merlin-par}
LOG=${2:-/data/build-par.log}
OUT=${3:-/data/watchdog.log}

MAX_MIN=${MAX_MIN:-90}          # 总时长上限（成功构建约 50 分钟）
MAX_LINES=${MAX_LINES:-400000}  # 日志行数上限（正常约 3 万）
MAX_DEPTH=${MAX_DEPTH:-40}      # make 递归深度上限（正常约 6）
STALL_MAX=${STALL_MAX:-8}       # CPU 连续低于 5% 的次数

: > "$OUT"
say(){ echo "[$(date -u +%H:%M:%S)] $*" >> "$OUT"; }
kill_it(){ say "!! 触发护栏: $1 —— 杀容器"; docker kill "$NAME" >/dev/null 2>&1; exit 1; }

T0=$(date +%s); stall=0
say "看门狗启动 name=$NAME 上限: ${MAX_MIN}分/${MAX_LINES}行/深度${MAX_DEPTH}"
while [ "$(docker inspect -f '{{.State.Status}}' "$NAME" 2>/dev/null)" = "running" ]; do
  el=$(( ( $(date +%s) - T0 ) / 60 ))
  [ "$el" -gt "$MAX_MIN" ] && kill_it "超时 ${el} 分钟"

  lines=$(wc -l < "$LOG" 2>/dev/null || echo 0)
  [ "$lines" -gt "$MAX_LINES" ] && kill_it "日志失控 ${lines} 行"

  # make 递归深度：只看日志尾部，避免扫全文件
  depth=$(tail -3000 "$LOG" 2>/dev/null | grep -oE 'make\[[0-9]+\]' | grep -oE '[0-9]+' | sort -rn | head -1)
  [ -n "$depth" ] && [ "$depth" -gt "$MAX_DEPTH" ] && kill_it "make 递归深度 $depth（疑似无限递归）"

  load=$(cut -d' ' -f1 /proc/loadavg | cut -d. -f1)
  [ "$load" -gt 200 ] && kill_it "宿主负载 $load"

  cpu=$(docker stats --no-stream --format '{{.CPUPerc}}' "$NAME" 2>/dev/null | tr -d '%' | cut -d. -f1)
  if [ -n "$cpu" ] && [ "$cpu" -lt 5 ]; then stall=$((stall+1)); else stall=0; fi
  [ "$stall" -ge "$STALL_MAX" ] && kill_it "CPU 连续 ${stall} 次 <5%（疑似死锁）"

  say "ok ${el}分 ${lines}行 深度${depth:-?} 负载${load} CPU${cpu:-?}%"
  sleep 60
done
say "容器自行结束，退出码=$(docker inspect -f '{{.State.ExitCode}}' "$NAME" 2>/dev/null)"
