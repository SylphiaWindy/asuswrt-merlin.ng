#!/bin/bash
# RT-BE88U 固件构建（Docker + gnuton 工具链）
#
# 用法:
#   build-be88u.sh <git-ref> [jobs]
#     jobs 省略        → 纯 `make rt-be88u`（默认，已验证可产出固件，约 100 分钟）
#     jobs=N           → 两段式 `make -jN || make`。**收益很小**：并行只对内核有效
#                        （首个 .ko 3m3s vs 9m20s），用户态 router_all 必然因生成头文件
#                        竞态失败并回落串行。实测总耗时 99 分钟，与纯串行差别在噪声内。
#   KEEP_TREE=1 build-be88u.sh <ref>
#                      → 复用已有树增量构建。改几行代码重编时用这个，别每次全新 clone。
#   MEMCAP=48g         → 容器内存上限（默认 48g）
#
# 实测数据（2026-08-19, Xeon E5-2697 v2 24T）：整段构建平均 CPU 仅 171%（满载 2400%），
# 只有 9% 的时间超过 200%。瓶颈是 autotools/逐包 configure 等固有串行环节，加核心无解。
set -euo pipefail

REF=${1:?用法: $0 <git-ref> [jobs]}
JOBS=${2:-}
MEMCAP=${MEMCAP:-48g}
KEEP_TREE=${KEEP_TREE:-0}

SRC=/data/src/asuswrt-merlin.ng
SLUG=$(printf '%s' "$REF" | tr './ ' '___')
TREE=/data/src/be88u-$SLUG
NAME=merlin-$SLUG
LOG=/data/build-$SLUG.log
RES=/data/build-$SLUG.result
BUILDSUB=release/src-rt-5.04behnd.4916

echo "ref=$REF  jobs=${JOBS:-串行}  内存上限=$MEMCAP  复用树=$KEEP_TREE"
echo "树=$TREE  容器=$NAME"

docker rm -f "$NAME" >/dev/null 2>&1 || true
# 无需 kill 旧监视器：容器被删后 docker inspect 返回空，其循环自行结束

if [ "$KEEP_TREE" = 1 ] && [ -d "$TREE" ]; then
  echo "复用已有树（增量构建）"
else
  [ -d "$TREE" ] && { echo "删除旧树..."; rm -rf "$TREE"; }
  echo "clone $REF ..."
  git clone --quiet --branch "$REF" "$SRC" "$TREE"
fi
cd "$TREE"
echo "HEAD=$(git rev-parse --short HEAD)  describe=$(git describe --tags 2>/dev/null || echo -)"

# 构建命令：给了 jobs 就两段式，否则纯串行
if [ -n "$JOBS" ]; then
  MK="yes '' | make -j$JOBS rt-be88u || yes '' | make rt-be88u"
else
  MK="yes '' | make rt-be88u"
fi

: > "$LOG"
CID=$(docker run -d --name "$NAME" -m "$MEMCAP" -v "$TREE:/build" \
        asus-merlin-builder:local \
        bash -lc "source ~/envs/bcm-hnd-ax-4.19be.sh && cd /build/$BUILDSUB && $MK")
echo "容器 ID=$(printf '%s' "$CID" | cut -c1-12)"

setsid nohup sh -c "docker logs -f $NAME > $LOG 2>&1" >/dev/null 2>&1 &
setsid nohup env NAME="$NAME" TREE="$TREE" LOG="$LOG" RES="$RES" BUILDSUB="$BUILDSUB" JOBS="${JOBS:-串行}" \
  /data/watch-build.sh >/dev/null 2>&1 &

echo "日志: tail -f $LOG"
echo "结果: cat $RES"
