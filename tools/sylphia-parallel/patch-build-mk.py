#!/usr/bin/env python3
"""给 build/Makefile 加顶层阶段顺序约束。

病因：kernelbuild 与 userspace 之间**没有声明任何顺序**，串行时靠先决条件的
左右次序恰好正确（实测 kernelbuild 在前）。-j 下两者并发，而它们共享
targets/96813GW/fs.install：
  - 内核侧 bcmdrivers/opensource/phy 往 fs.install/etc/fw 装固件
  - userspace → router_all → clean-build 执行 rm -rf $(TARGETDIR)/[a-z]*
目录被删后 make 仍认为 mkdir 目标已完成，cp 遂把单个文件写成名为 fw 的**文件**，
下一次 cp 报 "target '.../etc/fw' is not a directory"。
"""
import sys, re
p = sys.argv[1]
s = open(p).read()
if 'SYL_PHASE_ORDER' in s:
    print("  已打过补丁")
    sys.exit(0)
anchor = "\n.PHONY: prepare_userspace userspace\n"
if anchor not in s:
    sys.exit("找不到锚点 .PHONY: prepare_userspace userspace")
add = anchor + """
# ===== 顶层阶段顺序（自建，非上游）=====
# kernelbuild 与 userspace 共享 targets/<profile>/fs.install，且上游未声明顺序。
# -j 下并发时：内核侧 phy 往 fs.install/etc/fw 装固件，userspace 的 clean-build
# 同时 rm -rf 掉它 → cp: target '.../etc/fw' is not a directory。
# 按实测串行顺序（kernelbuild 在前）加 order-only 约束。
SYL_PHASE_ORDER := 1
userspace: | kernelbuild
"""
open(p, "w").write(s.replace(anchor, add, 1))
print("  build/Makefile 已加 userspace: | kernelbuild")
