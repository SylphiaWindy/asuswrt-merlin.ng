#!/usr/bin/env python3
"""
Track A v3：提供方归因改为「按文件名反查源码树」，取代不可靠的写入时间窗。

依据：staging 里的 usr/include/foo.h、usr/lib/libbar.so 必然由某个包安装；
      而那个包的源码目录里一定有同名文件。这个映射与时间无关，不受
      install 阶段错位影响（v2 里 uuid.h 被误归给 vsftpd、lzo1x.h 误归给 lz4）。
消费方仍按时间窗归因（串行构建下可靠）。
"""
import re, sys, os, datetime, bisect
from collections import defaultdict

BUILD_LOG, EVENT_LOG, ROUTER_DIR = sys.argv[1], sys.argv[2], sys.argv[3]

# ---- 1. 建立 文件名 → 包 的映射（扫源码树一次）----
name2pkg = defaultdict(set)
pkgs = [d for d in os.listdir(ROUTER_DIR) if os.path.isdir(os.path.join(ROUTER_DIR, d))]
for pkg in pkgs:
    if pkg == 'arm-glibc':
        continue
    for root, dirs, files in os.walk(os.path.join(ROUTER_DIR, pkg)):
        dirs[:] = [d for d in dirs if d not in ('.git', 'CVS')]
        for fn in files:
            if fn.endswith(('.h', '.hpp', '.la', '.pc')) or '.so' in fn or fn.endswith('.a'):
                name2pkg[fn].add(pkg)
print(f"# 源码树映射: {len(name2pkg)} 个文件名 → {len(pkgs)} 个包目录", file=sys.stderr)

# ---- 2. 消费方时间窗 ----
ts_re = re.compile(r'^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})')
ent_re = re.compile(r"Entering directory '([^']*/router/([^/']+))'")
trans = []
for line in open(BUILD_LOG, errors='replace'):
    m, e = ts_re.match(line), ent_re.search(line)
    if m and e:
        dt = datetime.datetime.strptime(m.group(1), '%Y-%m-%dT%H:%M:%S').replace(tzinfo=datetime.timezone.utc)
        trans.append((dt.timestamp(), e.group(2)))
trans.sort()
times = [t for t, _ in trans]
def pkg_at(t):
    i = bisect.bisect_right(times, t) - 1
    return trans[i][1] if i >= 0 else None

# ---- 3. 回放：提供方查映射，消费方查时间窗 ----
edges = defaultdict(lambda: [0, None])
amb = unresolved = selfdep = 0
for line in open(EVENT_LOG, errors='replace'):
    p = line.rstrip('\n').split('\t')
    if len(p) < 3 or 'ISDIR' in p[1] or 'OPEN' not in p[1]:
        continue
    path = p[2]
    if '/arm-glibc/stage/' not in path:
        continue
    try:
        t = float(p[0])
    except ValueError:
        continue
    consumer = pkg_at(t)
    if consumer is None:
        continue
    cands = name2pkg.get(os.path.basename(path), set()) - {consumer}
    if not cands:
        unresolved += 1
        continue
    if len(cands) > 1:
        amb += 1
        continue                      # 多个包都有同名文件，无法判定，宁缺勿错
    provider = next(iter(cands))
    if provider == consumer:
        selfdep += 1
        continue
    k = (consumer, provider)
    edges[k][0] += 1
    if edges[k][1] is None:
        edges[k][1] = path.split('/arm-glibc/stage/')[-1]

print(f"# 无法定位提供方: {unresolved}  同名多包(丢弃): {amb}  自依赖: {selfdep}", file=sys.stderr)
print(f"# 边数: {len(edges)}", file=sys.stderr)
print("# consumer\tprovider\t读取次数\t样例文件")
for (c, w), (n, ex) in sorted(edges.items(), key=lambda kv: -kv[1][0]):
    print(f"{c}\t{w}\t{n}\t{ex}")
