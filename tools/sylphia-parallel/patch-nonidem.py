#!/usr/bin/env python3
"""让非幂等的 recipe 变幂等。

coovachilli/src/Makefile.am:
    cmdline.c cmdline.h: cmdline.ggo cmdline.patch
            cat $(CMDLINE) | gengetopt -C
            cp cmdline.c cmdline.c.orig
            patch -p0 < cmdline.patch          ← 不带 -N，第二次必失败

GNU make 的**非模式多目标规则**语义：recipe 会为每个目标各跑一次。
串行时 make 先建 cmdline.c（recipe 产出两者），再看 cmdline.h 已最新便跳过；
-j 下两者同时启动 → recipe 跑两遍 → "Reversed (or previously applied) patch detected!"

加 -N（忽略已应用）+ -r -（不产生 .rej）+ || true。
"""
import sys, os
base = sys.argv[1]          # 树根 .../release/src-rt-5.04behnd.4916
n = 0
targets = [
    ('src/router/coovachilli/src/Makefile.am',
     'patch -p0 < cmdline.patch',
     'patch -p0 -N -r - < cmdline.patch || true'),
]
for rel, old, new in targets:
    p = os.path.join(os.path.dirname(base), rel)
    if not os.path.isfile(p):
        print(f"  跳过（不存在）: {rel}")
        continue
    s = open(p, errors='replace').read()
    if new in s:
        continue
    if old not in s:
        print(f"  ！锚点未找到: {rel}")
        continue
    open(p, 'w').write(s.replace(old, new))
    n += 1
    print(f"  已改幂等: {rel}")
print(f"  共修正 {n} 处非幂等 recipe")
