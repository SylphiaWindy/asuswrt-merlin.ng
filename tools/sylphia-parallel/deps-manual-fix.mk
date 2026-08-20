
# ===== 手工补边 / 修正：以实测错误信息为准 =====
# 提取器按「当前活跃目录」归因链接命令，对经 libtool 或 CMake 链接的包会漏/归错。
#
# usbmuxd-1.1.1: cannot find -lplist-2.0 → libplist-2.2.0（只装进 staging，扫源码树查不到）
usbmuxd-1.1.1: libplist-2.2.0 libusbmuxd-2.0.2
usbmuxd-1.1.1/Makefile: libplist-2.2.0 libusbmuxd-2.0.2
#
# qrencode: CMake 在 configure 时找不到 libpng → 把 PNG::PNG 解析成 PNG-NOTFOUND
# 并写进生成的 build.make。该字符串含冒号，make 当成目标模式 →
# "target pattern contains no '%'"。串行时 libpng 恰好排在前面所以不暴露；
# 并行时 qrencode 的 cmake 抢先跑就中招（第 24 轮"通过"只是碰巧 libpng 先完成）。
# 提取器抓不到是因为 qrencode 经 CMake 而非 -lpng 链接。
qrencode: libpng
qrencode/build/Makefile: libpng
#
# wpa_supplicant-2.7: ../src/crypto/tls_openssl.c 包含 router/openssl/include/openssl/engine.h，
# 而后者 include <openssl/opensslconf.h> —— 那是 openssl 的 Configure **生成**的。
# 上游只声明了 `wpa_supplicant-2.7: libnl ...`，没有 openssl。
# 提取器抓不到：它在 bcmdrivers/.../impl103 深处、经 Broadcom 自己的 build.rules 编译，
# 不在扫描范围内。手工推导里有这条（置信度 H）。
# 同时需要 Asus 基础库：libwpa_client.so 链接 -lshared。
wpa_supplicant-2.7: openssl shared nvram wlcsm
wpa_supplicant: openssl shared nvram wlcsm
#
# hostapd: sae_pk_gen 链接 -lnvram -lshared（与 wpa_supplicant 同源，都在
# bcmdrivers/.../impl103 下经 Broadcom build.rules 编译，提取器扫不到）。
hostapd: shared nvram wlcsm openssl
#
# wget: libiconv 是**未声明的、依赖时序的可选依赖**。上游只写 `wget: openssl zlib`。
# 实测串行构建的 wget 没有 libiconv（DT_NEEDED 里缺 libiconv.so.2），
# 并行构建的有 —— 因为 wget 的 configure 探测时 libiconv 恰好已建好。
# 显式声明以消除这个不确定性（选择"有 iconv"这一边，功能更全）。
wget: libiconv-1.14
wget/Makefile: libiconv-1.14
