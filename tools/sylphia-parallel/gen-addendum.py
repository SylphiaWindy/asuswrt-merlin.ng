#!/usr/bin/env python3
"""补两类上游没表达好的依赖：

(a) `<x>-dep` 模式：戳记 recipe 里 `$(MAKE) <x>-dep` 用**递归 make** 去建别的包
    （libwebapi/stamp-h1 → $(MAKE) libwebapi-dep → json-c bwdpi_source）。
    跨 make 实例没有序列化，外层可能同时在建 json-c → 冲突。
    把 <x>-dep 的先决条件提升成戳记的真实先决条件，内层递归即变 no-op。

(b) 上游对若干包**一条库依赖都没声明**（数据库里只有戳记 + dummy），
    实测 configure 明确报缺什么，据此补。
"""
import re, sys
MK, DB, OUT = sys.argv[1], sys.argv[2], sys.argv[3]

mk = open(MK, errors='replace').read()
db = open(DB, errors='replace').read()

lines = []

# (a) 找 recipe 里调 $(MAKE) <x>-dep 的目标
dep_targets = {}
for m in re.finditer(r'^([A-Za-z0-9._+/-]+):(?!=)[^\n]*\n((?:\t[^\n]*\n)+)', mk, re.M):
    tgt, recipe = m.group(1), m.group(2)
    for d in re.findall(r'\$\(MAKE\)\s+([A-Za-z0-9._+-]+-dep)\b', recipe):
        dep_targets[tgt] = d
for tgt, dep in sorted(dep_targets.items()):
    m = re.search(r'^%s:\s*(.*)$' % re.escape(dep), db, re.M)
    if m and m.group(1).strip():
        pre = [x for x in m.group(1).split() if x != 'dummy']
        if pre:
            lines.append(("(a) 递归 %s" % dep, "%s: %s" % (tgt, " ".join(pre))))

# (b) 上游完全没声明库依赖、而实测 configure 明确报缺的
KNOWN_GAPS = [
    ("libnetfilter_cttimeout-1.0.0/Makefile", "libmnl-1.0.4 libnfnetlink-1.0.1",
     "configure 报 Package requirements (libmnl) were not met"),
    ("ethtool-6.2/Makefile", "libmnl-1.0.4",
     "configure 报 No package 'libmnl' found"),
    ("coovachilli/Makefile", "openssl",
     "上游零声明；coovachilli 走 RADIUS/TLS 需要 openssl"),
]
for t, d, why in KNOWN_GAPS:
    lines.append(("(b) %s" % why, "%s: %s" % (t, d)))

with open(OUT, 'w') as f:
    f.write("# ===== 补上游未表达的依赖 =====\n\n")
    for why, l in lines:
        f.write("# %s\n%s\n" % (why, l))
    f.write("\n# 共 %d 条\n" % len(lines))
for why, l in lines:
    print("  %-58s  # %s" % (l, why))
