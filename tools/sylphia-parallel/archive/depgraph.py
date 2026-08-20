#!/usr/bin/env python3
"""
从插桩构建的两份数据推导包依赖图（Track A）。

输入:
  depcap-build.log   docker logs --timestamps 输出，每行前缀 RFC3339
  depcap-events.log  inotifywait 输出: <epoch>\t<EVENTS>\t<path>

原理:
  包 P 活跃期间写入 staging 目录的文件 → P 提供(provides)该文件
  包 C 活跃期间打开该文件               → C 消费(consumes)
  若 provider != consumer，则得到一条边 C → provider

局限（必须写进报告，不能当成完备结果）:
  - 归因靠「时间窗」，前提是串行构建（本次是串行，成立）
  - install/reinstall 阶段的活跃目录可能不是包目录，那段归因不可靠
  - 只覆盖经由三个 staging 目录交换的依赖；靠源码树内相对路径直接 #include
    对方头文件的耦合抓不到
"""
import re, sys, datetime
from collections import defaultdict

BUILD_LOG, EVENT_LOG = sys.argv[1], sys.argv[2]

# ---- 1. 从构建日志建立「时刻 → 活跃包」的转换点 ----
ts_re = re.compile(r'^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2})\.(\d+)?Z?')
ent_re = re.compile(r"Entering directory '([^']*/router/([^/']+))'")

transitions = []          # [(epoch, pkg)]
with open(BUILD_LOG, errors='replace') as f:
    for line in f:
        m = ts_re.match(line)
        if not m:
            continue
        e = ent_re.search(line)
        if not e:
            continue
        dt = datetime.datetime.strptime(m.group(1), '%Y-%m-%dT%H:%M:%S')
        dt = dt.replace(tzinfo=datetime.timezone.utc)
        transitions.append((dt.timestamp(), e.group(2)))

transitions.sort(key=lambda x: x[0])
print(f"# 包活跃转换点: {len(transitions)} 个, 涉及 {len(set(p for _,p in transitions))} 个包",
      file=sys.stderr)
if not transitions:
    sys.exit("没有解析到任何 Entering directory，检查日志时间戳格式")

times = [t for t, _ in transitions]
import bisect
def pkg_at(t):
    i = bisect.bisect_right(times, t) - 1
    return transitions[i][1] if i >= 0 else None

# ---- 2. 回放事件流 ----
writer = {}                                   # path -> 写它的包
edges = defaultdict(lambda: [0, None])        # (consumer, provider) -> [次数, 样例文件]
self_writes = skipped_nowriter = 0

with open(EVENT_LOG, errors='replace') as f:
    for line in f:
        parts = line.rstrip('\n').split('\t')
        if len(parts) < 3:
            continue
        try:
            t = float(parts[0])
        except ValueError:
            continue
        events, path = parts[1], parts[2]
        if 'ISDIR' in events:
            continue
        # 只保留 arm-glibc/stage/ —— 头文件与库的真实交换点。
        # fs.install 是固件根文件系统组装(打包)，fs.build 是中间产物，
        # 在那里的读写不代表构建期依赖，实测证明它们会主导并污染结果。
        if '/arm-glibc/stage/' not in path:
            continue
        p = pkg_at(t)
        if p is None:
            continue
        if ('CLOSE_WRITE' in events) or ('MOVED_TO' in events) or ('CREATE' in events):
            writer[path] = p                  # 后写覆盖前写：取最后一次写入者
        if 'OPEN' in events:
            w = writer.get(path)
            if w is None:
                skipped_nowriter += 1         # 构建前就存在的文件，不构成依赖
            elif w == p:
                self_writes += 1              # 自己写自己读
            else:
                k = (p, w)
                edges[k][0] += 1
                if edges[k][1] is None:
                    edges[k][1] = path

print(f"# 自读自写(已排除): {self_writes}  无写入者的读(已排除): {skipped_nowriter}",
      file=sys.stderr)
print(f"# 推导出边: {len(edges)}", file=sys.stderr)

# ---- 3. 输出 ----
print("# Track A（实测）推导的依赖边")
print("# consumer\tprovider\t读取次数\t样例文件")
for (c, w), (n, ex) in sorted(edges.items(), key=lambda kv: -kv[1][0]):
    short = ex.split('/router/')[-1] if ex and '/router/' in ex else (ex or '')
    print(f"{c}\t{w}\t{n}\t{short}")
