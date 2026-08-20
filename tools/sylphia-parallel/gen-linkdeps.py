#!/usr/bin/env python3
"""一次性生成**所有**「链接了某库却不声明依赖」的边，终止一轮修一个包的低效循环。

数据源：
  1. 串行构建日志的实际链接命令 → 每个包用了哪些 -lXXX
  2. 串行构建树里 libXXX.so / libXXX.a 的所在目录 → 该库由哪个包提供
两者结合得到「消费包 → 提供包」，再与上游已声明的依赖取差，得到缺失边。

仍然定向：全局规则会因递归 $(MAKE) 造成无限递归（实测深度 1435、负载 657、OOM）。
排除提供方自身的传递闭包，防环。
"""
import re, sys, os
from collections import defaultdict
LOG, TREE, DB, OUT = sys.argv[1:5]

# --- 1. 库 → 提供包（扫源码树里的库产物）---
lib2pkg = {}
for pkg in sorted(os.listdir(TREE)):
    d = os.path.join(TREE, pkg)
    if not os.path.isdir(d) or pkg == 'arm-glibc':
        continue
    for root, dirs, files in os.walk(d):
        dirs[:] = [x for x in dirs if x not in ('.git',)]
        for fn in files:
            m = re.match(r'^lib([A-Za-z0-9_+.-]+?)\.(so|a)(\.|$)', fn)
            if m:
                lib2pkg.setdefault(m.group(1), set()).add(pkg)
# 只保留**唯一**映射：同名库文件常在多个包目录下有副本（staging 拷贝），
# 取「排序后第一个」会产生大量假边（实测 dropbear→netatalk、expat→libdaemon 等）。
# 歧义消解：优先选**包名与库名匹配**的包（库 plist-2.0 → 包 libplist-2.2.0），
# 否则丢弃。纯丢弃会漏掉真实依赖（usbmuxd 需要 -lplist-2.0，而 libplist-2.0.so
# 在多个目录有副本，落入歧义集）。
resolved, dropped = {}, 0
for k, v in lib2pkg.items():
    if len(v) == 1:
        resolved[k] = next(iter(v)); continue
    base = k.split('-')[0].split('.')[0]
    cand = [p_ for p_ in v if p_.startswith('lib' + base) or p_.startswith(base)]
    if len(cand) == 1:
        resolved[k] = cand[0]
    else:
        dropped += 1
lib2pkg = resolved
# 兜底：有些库只装进 staging（arm-glibc/stage/usr/local/lib），源码树里没有产物文件，
# 扫目录建的映射查不到（实测 libplist-2.0.so 就是，导致 usbmuxd 缺 -lplist-2.0）。
# 按包名推断：库 plist-2.0 → 包 libplist-2.2.0。
_pkgdirs = [d for d in os.listdir(TREE) if os.path.isdir(os.path.join(TREE, d))]
_named = 0
for _l in set(re.findall(r'(?<= )-l([A-Za-z0-9_+.-]+)', open(LOG, errors='replace').read())):
    if _l in lib2pkg:
        continue
    _base = _l.split('-')[0].split('.')[0]
    if len(_base) < 3:
        continue
    _cand = [d for d in _pkgdirs if d == 'lib' + _base or d.startswith('lib' + _base + '-')]
    if len(_cand) == 1:
        lib2pkg[_l] = _cand[0]; _named += 1
print(f"  名字推断补充 {_named} 项")
print(f"  库→包 映射 {len(lib2pkg)} 项（歧义无法消解丢弃 {dropped} 项）")

# --- 2. 包 → 它链接的库 ---
ent = re.compile(r"Entering directory '[^']*/router(?:-sysdep)?/([^/']+)")
# -l 前必须是空格：否则会匹配到工具链路径里的 `...gcc-10.3-linux-4.19-...`，
# 把 linux-4 / linux-gnueabi 当成库名（实测假捕获）。库名允许含点（usb-1.0）。
libre = re.compile(r'(?<= )-l([A-Za-z0-9_+.-]+)')
cur, uses = None, defaultdict(set)
for line in open(LOG, errors='replace'):
    m = ent.search(line)
    if m:
        cur = m.group(1); continue
    # 捕获所有 -lXXX，但**只保留能在库→包映射里查到的**。
    # 那个映射来自源码树里真实存在的 libXXX.so/.a，所以 linux-4 / gnueabi
    # 这类路径碎片自然被滤掉，不必再靠「行里有没有 -o / 工具链路径」判断 ——
    # 那个判据太脆：usbmuxd 经 libtool 链接就不符合，导致漏掉 -lplist-2.0。
    if cur and ' -l' in line:
        for l in libre.findall(line):
            if l in lib2pkg:
                uses[cur].add(l)

# --- 3. 上游已声明的依赖（用于取差 + 闭包）---
deps, stamps = {}, defaultdict(set)
for line in open(DB, errors='replace'):
    if line.startswith('#') or line.startswith('\t'):
        continue
    m = re.match(r'^([A-Za-z0-9._+/-]+):(?!=)\s*(.*)$', line.rstrip('\n'))
    if not m:
        continue
    t, pre = m.group(1), m.group(2).strip()
    if '/' in t:
        stamps[t.split('/')[0]].add(t)
    elif t.endswith('-configure'):
        stamps[t[:-len('-configure')]].add(t)
    if pre:
        deps.setdefault(t, set()).update(x for x in pre.split() if x != 'dummy')

# --- 4. 生成缺失边 ---
edges, skipped_cycle = defaultdict(set), 0
for pkg, libs in uses.items():
    if pkg not in deps and pkg not in stamps:
        pass                                    # 仍尝试：可能是 obj-y 里的包
    for l in libs:
        prov = lib2pkg.get(l)
        if not prov or prov == pkg:
            continue
        if prov in deps.get(pkg, ()):
            continue                            # 上游已声明
        # 防环：若 prov 反过来（传递）依赖 pkg，跳过
        seen, stack = set(), [prov]
        cyc = False
        while stack:
            n = stack.pop()
            if n == pkg:
                cyc = True; break
            if n in seen: continue
            seen.add(n)
            stack.extend(deps.get(n, ()))
        if cyc:
            skipped_cycle += 1; continue
        edges[pkg].add(prov)

print(f"  生成 {sum(len(v) for v in edges.values())} 条缺失边，覆盖 {len(edges)} 个包（防环跳过 {skipped_cycle} 条）")

with open(OUT, 'w') as f:
    f.write("\n# ===== 链接依赖补全（一次性覆盖整类）=====\n")
    f.write("# 来源：串行日志的实际 -lXXX + 源码树里 libXXX.so/.a 的所属包。\n")
    f.write("# 只写上游未声明的部分；已做传递闭包防环检查。\n")
    n = 0
    for pkg in sorted(edges):
        provs = ' '.join(sorted(edges[pkg]))
        f.write(f"{pkg}: {provs}\n"); n += 1
        for st in sorted(stamps.get(pkg, ())):
            f.write(f"{st}: {provs}\n"); n += 1
    f.write(f"\n# 共 {n} 条\n")
print(f"  写出 {n} 条 → {OUT}")
for pkg in sorted(edges)[:12]:
    print(f"    {pkg:20s} → {' '.join(sorted(edges[pkg]))[:64]}")
