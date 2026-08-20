#!/usr/bin/env python3
"""用 make -pn 展开的依赖数据库，把上游已声明的库依赖传播到 configure 目标。

上游把 configure 目标与库依赖写成**并列**先决条件、彼此无序：
    minidlna: zlib sqlite ffmpeg ... minidlna-configure dummy
串行时靠列表顺序恰好正确，-j 下 configure 先跑 →
    configure: error: libavutil headers not found or not usable   （libavutil 属 ffmpeg）

configure 目标有**两种形态**，必须都处理：
    斜杠式  <pkg>/Makefile、<pkg>/stamp-h1、<pkg>/config.h、<pkg>/build/Makefile ...
    短横线式 <pkg>-configure                                    ← 之前漏了这种
"""
import re, sys
DB, OUT = sys.argv[1], sys.argv[2]

rule = re.compile(r'^([A-Za-z0-9._+/-]+):(?!=)\s*(.*)$')
rules = {}
for line in open(DB, errors='replace'):
    if line.startswith('#') or line.startswith('\t'):
        continue
    m = rule.match(line.rstrip('\n'))
    if not m:
        continue
    t, pre = m.group(1), m.group(2).strip()
    if pre:
        rules.setdefault(t, set()).update(pre.split())

emitted = []
for t, deps in sorted(rules.items()):
    if '/' in t or t.endswith('-configure'):
        continue                                   # 只处理包级规则
    stamps = [d for d in deps
              if d.startswith(t + '/') or d == t + '-configure']
    if not stamps:
        continue
    others = sorted(d for d in deps
                    if d not in stamps and d != t
                    and not d.startswith(t + '/') and d != 'dummy')
    if not others:
        continue
    for st in stamps:
        emitted.append((st, others))

with open(OUT, 'w') as f:
    f.write("# ===== configure 目标的依赖传播（源自 make -pn 展开数据库）=====\n")
    f.write("# 上游把 configure 目标与库依赖写成并列先决条件、彼此无序，-j 下 configure 先跑。\n")
    f.write("# 两种 configure 形态都覆盖：<pkg>/<戳记> 与 <pkg>-configure。\n\n")
    for st, deps in emitted:
        f.write(f"{st}: {' '.join(deps)}\n")
    f.write(f"\n# 共 {len(emitted)} 条\n")

slash = sum(1 for s, _ in emitted if '/' in s)
dash = len(emitted) - slash
print(f"  生成 {len(emitted)} 条（斜杠式 {slash} + 短横线式 {dash}）")
for st, d in emitted:
    if st.endswith('-configure'):
        print(f"    {st}: {' '.join(d)[:72]}")
