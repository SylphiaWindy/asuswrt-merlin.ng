#!/usr/bin/env python3
"""给 router/Makefile 打并行构建补丁。"""
import sys, re
p = sys.argv[1]
s = open(p).read()

anchor = "$(obj-y) $(obj-n) $(obj-clean) $(obj-install): dummy"
if anchor not in s:
    sys.exit("找不到锚点 obj-y ... : dummy")

# 需要加 per-package 锁的目标：戳记（斜杠式）+ 包目标本身。
#
# 为什么包目标也要锁：qrencode 的戳记 recipe 会 `rm -rf qrencode/build` 再跑 cmake，
# 而包目标的 recipe 是 `$(MAKE) -C qrencode/build`。只锁戳记时两者能并发，
# 构建目录在 sub-make 脚下被删 → 读到残缺的 CMake build.make →
# "target pattern contains no '%'"。同一个包的 configure 与 build 本来就该互斥，
# 不同包用不同锁，不损失并行度。
#
# 不锁短横线式 <pkg>-configure：它由戳记 recipe 用 $(MAKE) 调起，
# 而戳记已持同一把锁 → 父子互等死锁（实测 8 进程卡死、CPU 0%、32 分钟）。
stamp_re = re.compile(r'^([A-Za-z0-9._+\-]+/[A-Za-z0-9._+\-/]*(?:stamp-h1|Makefile|configure|config\.h))\s*:(?!=)', re.M)
stamps = sorted(set(stamp_re.findall(s)))
pkgs = sorted({t.split('/')[0] for t in stamps})

shell_lines = [f"{t}: SHELL := flock $(TOP)/.syl-conf-{t.split('/')[0]}.lock /bin/sh"
               for t in stamps]
shell_lines += [f"{p_}: SHELL := flock $(TOP)/.syl-conf-{p_}.lock /bin/sh" for p_ in pkgs]

add = anchor + r"""

# ===== 并行构建支持（自建，非上游）=====
# 准备阶段内部顺序：原 all: clean-build kernel_header version fsbuild $(obj-y)
# 五者并列无序，-j 下 clean-build 删 staging 与 fsbuild 建目录并发。
# clean-build 变空操作。
#
# 它的原始 recipe 是 `rm -rf $(TARGETDIR)/[a-z]*` + `rm -rf $(BCM_FSBUILD_DIR)`，
# 而 clean-build 是 phony（永远"过期"），**递归 make 的每个实例都会重跑一次**。
# 于是实例 A 的 fsbuild 刚建好 fs.install/lib、wlcsm 正在往里 install，
# 实例 B 的 clean-build 又把整个 fs.install 删掉：
#   install: cannot create regular file '.../fs.install/lib': No such file or directory
# 顺序约束（$(obj-y): | clean-build ...）只在**单实例内**有效，跨实例无效 ——
# 这也是第 1 轮 "Directory not empty" 和第 16 轮 "etc/fw is not a directory" 的同一根源。
#
# 我们总是从干净 clone 构建，没有旧产物需要清理，所以让它空转是安全的。
clean-build: ;

kernel_header version fsbuild: | clean-build
$(obj-y): | clean-build kernel_header version fsbuild

# install 阶段的目标同样要等 fsbuild —— 它创建 fs.install/{bin,sbin,usr/lib,...}。
# 上游把 obj-install 与 obj-y 并列声明（`$(obj-y) ... $(obj-install): dummy`），
# 我先前只约束了 obj-y，结果 install 阶段报
# "install: failed to access '.../fs.install/bin': No such file or directory"。
$(obj-install): | clean-build kernel_header version fsbuild

# install 的先决条件同样是「写了次序但没声明顺序」：
#   install package: $(obj-install) $(LINUXDIR)/.config gen_kernelrelease gen_target gen_gpl_excludes_router
# gen_target 需要 fs.install/usr/lib，而那是各包 install 时创建的（fsbuild 不建它）。
# -j 下并发 → chmod: cannot access '.../fs.install/usr/lib'。
# 按上游的书写次序把顺序显式化。
gen_kernelrelease gen_target gen_gpl_excludes_router: | $(obj-install)

-include deps.mk

# net-snmp 包内并行竞态：agent 子目录链接 -lnetsnmpagent（同包产出）时它还没好。
# 危险之处是**错误被容忍、没有向上传播** —— router_all 报成功，
# 直到顶层 libcreduction 检查库清单才发现 "Missing 32-bit libraries: libnetsnmpmibs.so.35"。
# 它的 Makefile 是 configure 生成的，.NOTPARALLEL 覆盖不到，改用**定向** MAKEFLAGS。
# 不用全局版：第 29 轮 $(obj-y): MAKEFLAGS := -j1 波及 libpng 的 CMake，
# 日志深度从 60809 退到 38305。net-snmp 是 autotools，单独定向安全。
net-snmp-5.7.2: MAKEFLAGS := -j1
# install 目标同样要串行：真实失败在 libtool 的 install 阶段 relink ——
#   libtool: install: warning: relinking `libnetsnmpmibs.la'
#   ld: cannot find -lnetsnmpagent
# libtool 安装 .la 时按**已安装位置**重链，libnetsnmpmibs 依赖 libnetsnmpagent，
# 并行下后者还没装好。上一轮只给构建目标加了 -j1，漏了 install。
net-snmp-5.7.2-install: MAKEFLAGS := -j1

# ----- per-package configure/build 互斥锁（目标专属 SHELL）-----
""" + "\n".join(shell_lines) + "\n"
s = s.replace(anchor, add, 1)
print(f"  加锁：{len(stamps)} 个戳记 + {len(pkgs)} 个包目标")
open(p, "w").write(s)
print("Makefile 补丁已应用")
