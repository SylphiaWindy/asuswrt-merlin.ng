#!/bin/bash
# 依赖抓取：干净构建 + inotify 监视三个 staging 目录 + 带时间戳的构建日志。
# 事后由 depgraph.awk 按「包活跃时间窗」把文件读写归因到包，推出依赖边。
set -euo pipefail

REF=3006.102.8_2
SLUG=depcap
TREE=/data/src/be88u-$SLUG
NAME=merlin-$SLUG
LOG=/data/depcap-build.log          # 带 RFC3339 时间戳
EV=/data/depcap-events.log          # inotify 事件流
BUILDSUB=release/src-rt-5.04behnd.4916
ROUTER=$BUILDSUB/bcmdrivers/broadcom/net/wl/bcm96813/main/src/router

docker rm -f "$NAME" >/dev/null 2>&1 || true
pkill -x inotifywait 2>/dev/null || true      # -x 精确匹配进程名，不匹配命令行，无自伤风险
if [ -d "$TREE" ]; then rm -rf "$TREE"; fi

echo "clone $REF ..."
git clone --quiet --branch "$REF" /data/src/asuswrt-merlin.ng "$TREE"

# 预创建被监视目录：inotifywait 不能监视不存在的路径；
# 监视 targets/96813GW 这个「父目录」而非 fs.build/fs.install 本身，
# 因为 clean-build 会 rm -rf 它们，直接盯会丢 watch。
mkdir -p "$TREE/$ROUTER/arm-glibc" "$TREE/$BUILDSUB/targets/96813GW"

: > "$EV"
setsid nohup inotifywait -m -r \
  -e close_write -e moved_to -e create -e open \
  --timefmt '%s' --format '%T	%e	%w%f' \
  "$TREE/$ROUTER/arm-glibc" "$TREE/$BUILDSUB/targets/96813GW" \
  >> "$EV" 2>/dev/null &
sleep 3
echo "inotifywait PID=$(pgrep -x inotifywait | head -1)  事件流=$EV"

CID=$(docker run -d --name "$NAME" -m 48g -v "$TREE:/build" \
        asus-merlin-builder:local \
        bash -lc "source ~/envs/bcm-hnd-ax-4.19be.sh && cd /build/$BUILDSUB && yes '' | make rt-be88u")
echo "容器=$(printf '%s' "$CID" | cut -c1-12)"

# --timestamps 让每行带 RFC3339，用于和 inotify 事件对齐
setsid nohup sh -c "docker logs -f --timestamps $NAME > $LOG 2>&1" >/dev/null 2>&1 &
setsid nohup /data/cpusample.sh "$NAME" /data/cpu-depcap.tsv >/dev/null 2>&1 &
echo "构建日志=$LOG（带时间戳）"
echo "开始: $(date -u +%FT%TZ)"
