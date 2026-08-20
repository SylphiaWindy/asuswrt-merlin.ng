#!/usr/bin/env python3
"""基础库定向依赖 v3：覆盖串行日志里**所有** 24 个链接 -lshared/-lnvram/-lwlcsm 的包。

v2 只有 6 个（从 config.log 扫的，漏掉不用 autoconf 的包，如 lltdc）。
数据源改为串行构建日志里的实际链接命令，完整。

仍然定向而非全局：全局规则会因递归 $(MAKE) 造成无限递归
（实测 make 深度 1435、openssl 重建 4511 次、负载 657、OOM 刷 144GB 日志）。
排除基础库自身的传递闭包，否则成环。
"""
import re, sys
DB, USERS, OUT = sys.argv[1], sys.argv[2], sys.argv[3]

deps, stamps = {}, {}
for line in open(DB, errors='replace'):
    if line.startswith('#') or line.startswith('\t'):
        continue
    m = re.match(r'^([A-Za-z0-9._+/-]+):(?!=)\s*(.*)$', line.rstrip('\n'))
    if not m:
        continue
    t, pre = m.group(1), m.group(2).strip()
    if '/' in t:
        stamps.setdefault(t.split('/')[0], set()).add(t)
    elif t.endswith('-configure'):
        stamps.setdefault(t[:-len('-configure')], set()).add(t)
    if pre:
        deps.setdefault(t, set()).update(x for x in pre.split() if x != 'dummy')

BASE = ['shared', 'nvram', 'wlcsm']
closure, stack = set(BASE), list(BASE)
while stack:
    n = stack.pop()
    for d in deps.get(n, ()):
        if d not in closure:
            closure.add(d); stack.append(d)
closure |= {c.split('/')[0] for c in closure if '/' in c}

users = {}
for line in open(USERS):
    if line.startswith('#') or not line.strip():
        continue
    p = line.rstrip('\n').split('\t')
    if len(p) == 2:
        users[p[0]] = p[1].split()

skipped = [p for p in users if p in closure]
emit = {p: l for p, l in users.items() if p not in closure}
print(f"  链接基础库的包 {len(users)} 个；排除闭包内 {len(skipped)} 个 → 生成 {len(emit)} 个")
if skipped:
    print(f"    排除: {' '.join(sorted(skipped))}")

with open(OUT, 'w') as f:
    f.write("\n# ===== 基础库定向依赖（24 个包，源自串行日志的实际链接命令）=====\n")
    f.write("# 上游对这些包只写 `<pkg>: dummy`，但它们链接 -lshared/-lnvram/-lwlcsm。\n")
    f.write("# 定向而非全局：全局规则会因递归 $(MAKE) 造成无限递归（实测深度 1435、\n")
    f.write("# openssl 重建 4511 次、宿主负载 657、OOM 刷 144GB 日志）。\n")
    n = 0
    for pkg in sorted(emit):
        libs = ' '.join(emit[pkg])
        f.write(f"{pkg}: {libs}\n"); n += 1
        for st in sorted(stamps.get(pkg, ())):
            f.write(f"{st}: {libs}\n"); n += 1
    f.write(f"\n# 共 {n} 条\n")
print(f"  写出 {n} 条 → {OUT}")
