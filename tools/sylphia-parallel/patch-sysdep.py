#!/usr/bin/env python3
"""给「git 里就有的手写 Makefile」加 .NOTPARALLEL。

判别依据（有原则，不是逐包试错）：
  git 跟踪的 Makefile  = Asus/Broadcom 手写，大多不 -j 安全（实测 ethctl、asusnatnl、
                          ipaddr 同类：同包内 A 需要 B 产出的库，两者却并发）
  configure/cmake 生成 = autotools/CMake 产物，通常 -j 安全，**不动**
                          （第 29 轮用 $(obj-y): MAKEFLAGS := -j1 一刀切，波及 libpng
                           的 CMake → pnglibconf.out Error 1，日志深度 60809→38305）

**必须用二进制模式读写**：树里有 4 个 Makefile 是 CRLF 行尾
（lltdc、libpasswd、lltdc/src、lldt/src），文本模式会把 \\r\\n 转成 \\n，
把本该 3 行的 diff 撑成 51 行，属于未经请求的源码改动。
"""
import sys, os, glob, subprocess

BASE = sys.argv[1]          # 树根 .../release/src-rt-5.04behnd.4916
SRC = sys.argv[2]           # 仓库根（取 git 跟踪清单）

HDR = ("# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。\n"
       "# 包内串行，包间并行不受影响。\n"
       ".NOTPARALLEL:\n").encode('utf-8')

def patch(mk):
    if not os.path.isfile(mk):
        return 0
    s = open(mk, 'rb').read()
    if b'.NOTPARALLEL' in s:
        return 0
    open(mk, 'wb').write(HDR + s)
    return 1

n = 0
# 1. router-sysdep.*（型号目录，git 里就有）
for sysdep in sorted(glob.glob(os.path.join(BASE, 'router-sysdep.*'))):
    for mk in sorted(glob.glob(os.path.join(sysdep, '*', 'Makefile'))):
        n += patch(mk)

# 2. release/src/router 下所有 git 跟踪的 Makefile
try:
    out = subprocess.run(['git', '-C', SRC, 'ls-files', 'release/src/router'],
                         capture_output=True, text=True, timeout=180).stdout
except Exception as e:
    out = ''
    print(f"  ！取 git 清单失败: {e}")
cnt2 = 0
for rel in out.splitlines():
    if not rel.endswith('/Makefile'):
        continue
    mk = os.path.join(os.path.dirname(BASE), 'src', 'router',
                      rel.split('release/src/router/', 1)[1])
    d = patch(mk)
    n += d; cnt2 += d
print(f"  加了 .NOTPARALLEL 共 {n} 个（其中 git 手写 Makefile {cnt2} 个）")
