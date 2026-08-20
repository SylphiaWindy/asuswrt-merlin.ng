#!/bin/bash
# 并行构建验证 v2：干净树 + 准备阶段顺序修复 + 无环 deps.mk，然后 make -jN。
# 不带 `|| make` 兜底 —— 失败本身是要观测的信号。
set -uo pipefail
REF=3006.102.8_2
TREE=/data/src/be88u-par
NAME=merlin-par
LOG=/data/build-par.log
BUILDSUB=release/src-rt-5.04behnd.4916
JOBS=${1:-24}

docker rm -f "$NAME" >/dev/null 2>&1
if [ -d "$TREE" ]; then echo "删除旧树..."; rm -rf "$TREE"; fi
echo "clone $REF ..."
git clone --quiet --branch "$REF" /data/src/asuswrt-merlin.ng "$TREE"
if [ ! -f "$TREE/$BUILDSUB/router/Makefile" ]; then
  echo "clone 失败或树不完整，中止" >&2
  exit 1
fi

R="$TREE/$BUILDSUB/router"
cp /data/deps-final5.mk "$R/deps.mk"
echo "deps.mk 就位: $(grep -c '^[a-z]' "$R/deps.mk") 条边（已去环）"

python3 /data/apply-patch.py "$R/Makefile" || exit 1
python3 /data/patch-build-mk.py "$TREE/$BUILDSUB/build/Makefile" || exit 1
python3 /data/patch-sysdep.py "$TREE/$BUILDSUB" /data/src/asuswrt-merlin.ng || exit 1
python3 /data/patch-nonidem.py "$TREE/$BUILDSUB" || exit 1

: > "$LOG"
CID=$(docker run -d --name "$NAME" -m 48g -v "$TREE:/build" \
        asus-merlin-builder:local \
        bash -lc "source ~/envs/bcm-hnd-ax-4.19be.sh && cd /build/$BUILDSUB && yes '' | make -j$JOBS --output-sync=target rt-be88u")
echo "容器=$(printf '%s' "$CID" | cut -c1-12)  jobs=$JOBS"
setsid nohup sh -c "docker logs -f $NAME > $LOG 2>&1" >/dev/null 2>&1 &
setsid nohup /data/cpusample.sh "$NAME" /data/cpu-par.tsv >/dev/null 2>&1 &
# 看门狗：多重护栏（超时 / 日志行数 / make 递归深度 / 宿主负载 / CPU 停滞），
# 任一触发即杀容器。装在机器上而非轮询循环里 —— 上次失控（递归 1435 层、
# 388 万行日志、负载 657、383 分钟）就是因为检测只看「CPU 低」，而失控是高 CPU。
setsid nohup /data/watchdog.sh "$NAME" "$LOG" /data/watchdog.log >/dev/null 2>&1 &
echo "日志: tail -f $LOG"
