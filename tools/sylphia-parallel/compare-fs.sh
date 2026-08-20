#!/bin/bash
# 逐文件比对两个 fs.install 根文件系统。
# 用法: compare-fs.sh <树A名> <树B名> [输出前缀]
# 报告：仅 A 有 / 仅 B 有 / 内容不同（按内容哈希，不看时间戳）
set -u
A=$1; B=$2; OUT=${3:-/tmp/cmp}
SUB=release/src-rt-5.04behnd.4916/targets/96813GW/fs.install
DA=/data/src/$A/$SUB
DB=/data/src/$B/$SUB

for d in "$DA" "$DB"; do
  if [ ! -d "$d" ]; then echo "缺少 $d"; exit 1; fi
done

hash_tree() {   # 输出 "相对路径<TAB>哈希"，符号链接记其目标
  local root=$1
  ( cd "$root" && find . \( -type f -o -type l \) -print0 | LC_ALL=C sort -z | \
    while IFS= read -r -d '' p; do
      if [ -L "$p" ]; then printf '%s\tLINK:%s\n' "$p" "$(readlink "$p")"
      else printf '%s\t%s\n' "$p" "$(md5sum "$p" | cut -d" " -f1)"
      fi
    done )
}

hash_tree "$DA" > "$OUT.a"
hash_tree "$DB" > "$OUT.b"

cut -f1 "$OUT.a" | LC_ALL=C sort > "$OUT.a.names"
cut -f1 "$OUT.b" | LC_ALL=C sort > "$OUT.b.names"
LC_ALL=C comm -23 "$OUT.a.names" "$OUT.b.names" > "$OUT.only-a"
LC_ALL=C comm -13 "$OUT.a.names" "$OUT.b.names" > "$OUT.only-b"

# 内容不同的
LC_ALL=C join -t"$(printf '\t')" <(LC_ALL=C sort "$OUT.a") <(LC_ALL=C sort "$OUT.b") \
  | awk -F'\t' '$2!=$3{print $1}' > "$OUT.differ"

printf "  A=%s  文件 %d\n" "$A" "$(wc -l < "$OUT.a")"
printf "  B=%s  文件 %d\n" "$B" "$(wc -l < "$OUT.b")"
printf "  仅 A 有:   %d\n" "$(wc -l < "$OUT.only-a")"
printf "  仅 B 有:   %d\n" "$(wc -l < "$OUT.only-b")"
printf "  内容不同:  %d\n" "$(wc -l < "$OUT.differ")"
