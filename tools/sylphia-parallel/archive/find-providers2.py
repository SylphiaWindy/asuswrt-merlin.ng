#!/usr/bin/env python3
"""重算提供方 —— 修正一个系统性错误：归因正则原本只认 /router/<pkg>，
漏掉了在兄弟树 router-sysdep/ 下构建的一大批 obj-y 包（wlcsm、nvram、
archerctl、bcm_flashutil ...）。它们被漏掉不只影响分波，还会污染提供方检测：
router-sysdep 包构建期间「当前活跃包」停留在上一个 router 包上，写入被误归。"""
import re, sys, datetime, bisect
from collections import defaultdict
BUILD_LOG, EVENT_LOG = sys.argv[1], sys.argv[2]

ts = re.compile(r'^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})')
# 同时匹配 /router/<pkg> 与 /router-sysdep/<pkg>
ent = re.compile(r"Entering directory '([^']*/router(?:-sysdep)?/([^/']+))'")
tr = []
for line in open(BUILD_LOG, errors='replace'):
    m, e = ts.match(line), ent.search(line)
    if m and e:
        d = datetime.datetime.strptime(m.group(1), '%Y-%m-%dT%H:%M:%S').replace(tzinfo=datetime.timezone.utc)
        tr.append((d.timestamp(), e.group(2)))
tr.sort()
times = [t for t, _ in tr]
def at(t):
    i = bisect.bisect_right(times, t) - 1
    return tr[i][1] if i >= 0 else None

prov = defaultdict(int)
for line in open(EVENT_LOG, errors='replace'):
    f = line.rstrip('\n').split('\t')
    if len(f) < 3 or 'ISDIR' in f[1]:
        continue
    if not any(k in f[1] for k in ('CLOSE_WRITE', 'MOVED_TO', 'CREATE')):
        continue
    if '/arm-glibc/stage/usr/include/' not in f[2] and '/arm-glibc/stage/usr/lib/' not in f[2]:
        continue
    try:
        p = at(float(f[0]))
    except ValueError:
        continue
    if p:
        prov[p] += 1
sys.stderr.write(f"  活跃转换点 {len(tr)} 个，涉及 {len(set(p for _,p in tr))} 个包\n")
sys.stderr.write(f"  提供方 {len(prov)} 个\n")
for p in sorted(prov):
    print(p)
