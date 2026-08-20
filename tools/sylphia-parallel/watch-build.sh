#!/bin/bash
# 由 build-be88u.sh 通过环境变量调用；也可手动设 NAME/TREE/LOG/RES/BUILDSUB 后运行。
NAME=${NAME:-merlin-102_8_2}
TREE=${TREE:-/data/src/be88u-102.8_2}
LOG=${LOG:-/data/build-102.8_2.log}
RES=${RES:-/data/build-102.8_2.result}
BUILDSUB=${BUILDSUB:-release/src-rt-5.04behnd.4916}
JOBS=${JOBS:-?}
K=$TREE/$BUILDSUB/kernel/linux-4.19

T0=$(date +%s)
: > "$RES"
say() { echo "[+$(( ($(date +%s) - T0) / 60 ))m$(( ($(date +%s) - T0) % 60 ))s] $*" >> "$RES"; }
say "监视启动  容器=$NAME  jobs=$JOBS"

got=0
while :; do
  if [ "$got" = 0 ] && [ -f "$K/include/generated/utsrelease.h" ]; then
      rel=$(sed -n 's/.*UTS_RELEASE "\(.*\)"/\1/p' "$K/include/generated/utsrelease.h")
      [ -n "$rel" ] && { say "UTS_RELEASE=$rel"; got=1; }
  fi
  ko=$(find "$K" -name '*.ko' -type f 2>/dev/null | head -1)
  if [ -n "$ko" ]; then
      vm=$(strings "$ko" 2>/dev/null | grep -m1 '^vermagic=')
      if [ -n "$vm" ]; then
          say "★ 首个模块 $(basename "$ko")"
          say "★ $vm"
          for k in CONFIG_SMP CONFIG_PREEMPT CONFIG_MODULE_UNLOAD CONFIG_MODVERSIONS CONFIG_MODULE_SIG; do
              say "   $(grep -E "^($k=|# $k is not set)" "$K/.config" 2>/dev/null | head -1)"
          done
          break
      fi
  fi
  [ "$(docker inspect -f '{{.State.Status}}' "$NAME" 2>/dev/null)" != "running" ] && { say "容器在取到 vermagic 前退出"; break; }
  sleep 15
done

while [ "$(docker inspect -f '{{.State.Status}}' "$NAME" 2>/dev/null)" = "running" ]; do sleep 30; done
code=$(docker inspect -f '{{.State.ExitCode}}' "$NAME" 2>/dev/null)
say "构建结束 退出码=$code"
img=$(ls -1 "$TREE/$BUILDSUB"/image/*.pkgtb 2>/dev/null | head -1)
[ -n "$img" ] && say "固件: $img ($(du -h "$img" | cut -f1))" || say "无 .pkgtb 产物"
# OOM 检查：-j 高并发下最可能的失败模式
oom=$(docker inspect -f '{{.State.OOMKilled}}' "$NAME" 2>/dev/null)
say "OOMKilled=$oom"
say "日志尾部:"
tail -20 "$LOG" >> "$RES" 2>/dev/null
