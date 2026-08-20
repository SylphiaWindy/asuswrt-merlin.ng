#!/bin/bash
# 每 15 秒记一次容器 CPU%，直到容器退出。用于统计整段构建的并行度分布，
# 避免用瞬时采样下结论。
NAME=${1:?容器名}
OUT=${2:-/data/cpu-$NAME.tsv}
echo -e "秒\tCPU%\t日志行" > "$OUT"
T0=$(date +%s)
LOG=$(ls /data/build-*.log 2>/dev/null | head -1)
while [ "$(docker inspect -f '{{.State.Status}}' "$NAME" 2>/dev/null)" = "running" ]; do
  c=$(docker stats --no-stream --format '{{.CPUPerc}}' "$NAME" 2>/dev/null | tr -d '%')
  [ -n "$c" ] && printf "%d\t%s\t%s\n" "$(( $(date +%s) - T0 ))" "$c" "$(wc -l < /data/build-resume.log 2>/dev/null)" >> "$OUT"
  sleep 15
done
