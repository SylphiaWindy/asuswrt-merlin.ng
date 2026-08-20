#!/usr/bin/env python3
"""从串行构建日志找出**所有**链接 -lshared/-lnvram/-lwlcsm 的包。

之前只扫各包 config.log，漏掉不用 autoconf 的包（lltdc 就没有 config.log）。
构建日志里的实际链接命令是完整的数据源。
按「当前活跃目录」归因，同时匹配 router/ 与 router-sysdep/。
不能用全局规则：那会因递归 $(MAKE) 造成无限递归（实测递归 1435 层、负载 657）。
"""
import re, sys
from collections import defaultdict
LOG = sys.argv[1]

ent = re.compile(r"Entering directory '[^']*/router(?:-sysdep)?/([^/']+)")
lib = re.compile(r'-l(shared|nvram|wlcsm)\b')

cur, need = None, defaultdict(set)
for line in open(LOG, errors='replace'):
    m = ent.search(line)
    if m:
        cur = m.group(1)
        continue
    if cur:
        for l in lib.findall(line):
            need[cur].add(l)

print(f"# 共 {len(need)} 个包链接了基础库")
for pkg in sorted(need):
    print(f"{pkg}\t{' '.join(sorted(need[pkg]))}")
