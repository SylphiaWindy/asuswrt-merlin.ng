# ===== configure 目标的依赖传播（源自 make -pn 展开数据库）=====
# 上游把 configure 目标与库依赖写成并列先决条件、彼此无序，-j 下 configure 先跑。
# 两种 configure 形态都覆盖：<pkg>/<戳记> 与 <pkg>-configure。

Transmission/build/Makefile: curl-7.21.7 libevent-2.0.21 zlib
accel-pptp/stamp-h1: pppd
accel-pptpd/pptpd-1.3.3/Makefile: kernel_header pppd
avahi/Makefile: expat-2.0.1 libdaemon
avahi-0.6.31/Makefile: expat-2.0.1 libdaemon nvram shared
aws-iot/Makefile: shared
bluez-5.56/stamp-h1: cfg_mnt libdisk libwebapi
conntrack/Makefile: libmnl-1.0.4 libnetfilter_conntrack-1.0.7 libnetfilter_cttimeout-1.0.0 libnfnetlink-1.0.1
curl/Makefile: openssl
fb_wifi/stamp-h1: curl
ffmpeg/stamp-h1: zlib
flac/stamp-h1: libogg
freeradius-server-3.0.0/configure: pcre-8.31
ftpclient/stamp-h1: libiconv-1.14
gdb/Makefile: termcap
getdns/build/Makefile: libyaml openssl
inadyn/Makefile: libconfuse nvram shared
ipset-7.6/Makefile: libmnl-1.0.4
iptables-1.4.x/Makefile: libnfnetlink-1.0.1
libcodb/stamp-h1: sqlite3
libid3tag/stamp-h1: zlib
libjwt/Makefile: jansson-2.7
libnetfilter_conntrack-1.0.7/Makefile: libmnl-1.0.4 libnfnetlink-1.0.1
libnetfilter_queue/Makefile: libmnl-1.0.4 libnfnetlink-1.0.1
libssh2/Makefile: libgcrypt-1.5.1 zlib
libusb/Makefile: libusb10
lighttpd-1.4.39/stamp-h1: curl libdisk libexif libpasswd libxml2 nvram openssl pcre-8.31 samba-3.5.8 shared sqlite
lldpd-0.9.8/Makefile: jansson-2.7 json-c libevent-2.0.21
lldpd-1.0.11/Makefile: jansson-2.7 json-c libevent-2.0.21
minidlna-configure: ffmpeg flac jpeg libexif libid3tag libogg libvorbis sqlite zlib
miniupnpd/config.h: e2fsprogs iptables-1.4.x
mosquitto-1.6.8/stamp-h1: openssl
nano/Makefile: ncurses-6.3
neon/Makefile: libxml2 openssl
neon/config.h: libxml2 openssl
nfcm/stamp-h1: bridge-utils ethswctl_lib json-c libev-4.33 libmnl-1.0.4 libnetfilter_conntrack-1.0.7 libnfnetlink-1.0.1 sqlite3
nt_center/stamp-h1: curl libxml2 wb
opensync-1.4.0/stamp-h1: curl jansson-2.7 libev-4.31 libmnl-1.0.4 libpcap-1.9.1 mosquitto-1.6.8 mxml-3.1 protobuf-3.11.3 protobuf-c-1.3.2
openvpn/Makefile: libcap-ng lzo-2.10 openpam openssl shared zlib
pppd/stamp-h1: openssl
protect_srv/stamp-h1: nvram shared wlcsm
rp-l2tp/stamp-h1: pppd
rp-pppoe/src/stamp-h1: openssl pppd
sambaclient/stamp-h1: samba-3.5.8
strongswan/Makefile: openssl
tcpdump-4.4.0/Makefile: libpcap
tcpdump-4.x/Makefile: libpcap
tor/Makefile: libevent-2.0.21 openssl zlib
usbmode/stamp-h1: json-c libubox
webdav_client/stamp-h1: libxml2 neon nvram zlib
wget/Makefile: openssl zlib

# 共 51 条
# ===== 补上游未表达的依赖 =====

# (a) 递归 libwebapi-dep
libwebapi/stamp-h1: json-c bwdpi_source
# (b) configure 报 Package requirements (libmnl) were not met
libnetfilter_cttimeout-1.0.0/Makefile: libmnl-1.0.4 libnfnetlink-1.0.1
# (b) configure 报 No package 'libmnl' found
ethtool-6.2/Makefile: libmnl-1.0.4
# (b) 上游零声明；coovachilli 走 RADIUS/TLS 需要 openssl
coovachilli/Makefile: openssl

# 共 4 条

# ===== 基础库定向依赖（24 个包，源自串行日志的实际链接命令）=====
# 上游对这些包只写 `<pkg>: dummy`，但它们链接 -lshared/-lnvram/-lwlcsm。
# 定向而非全局：全局规则会因递归 $(MAKE) 造成无限递归（实测深度 1435、
# openssl 重建 4511 次、宿主负载 657、OOM 刷 144GB 日志）。
LPRng: nvram shared wlcsm
accel-pptpd: wlcsm
accel-pptpd/pptpd-1.3.3/Makefile: wlcsm
aws-iot: nvram shared wlcsm
aws-iot/Makefile: nvram shared wlcsm
coovachilli: nvram shared
coovachilli-configure: nvram shared
coovachilli/Makefile: nvram shared
dropbear: nvram shared wlcsm
dropbear/config.h: nvram shared wlcsm
dropbear/config.h.in: nvram shared wlcsm
e2fsprogs: wlcsm
e2fsprogs-configure: wlcsm
e2fsprogs/Makefile: wlcsm
e2fsprogs/Makefile.in: wlcsm
httpd: nvram shared wlcsm
inadyn: nvram shared wlcsm
inadyn/Makefile: nvram shared wlcsm
inadyn/configure: nvram shared wlcsm
infosvr: nvram shared wlcsm
libcodb: shared
libcodb/stamp-h1: shared
libconfuse: nvram shared wlcsm
libconfuse/Makefile: nvram shared wlcsm
libdisk: nvram shared wlcsm
libogg: wlcsm
libogg/stamp-h1: wlcsm
libwebapi: shared
libwebapi/stamp-h1: shared
lighttpd-1.4.39: nvram shared wlcsm
lighttpd-1.4.39/Makefile: nvram shared wlcsm
lighttpd-1.4.39/stamp-h1: nvram shared wlcsm
lltdc: nvram shared wlcsm
miniupnpd: wlcsm
miniupnpd/config.h: wlcsm
miniupnpd-igdv2: wlcsm
net-snmp: nvram shared
phddns: nvram shared wlcsm
phddns/stamp-h1: nvram shared wlcsm
rc: nvram shared
rstats: nvram shared wlcsm
vsftpd-3.x: nvram shared wlcsm
wget: nvram shared wlcsm
wget/Makefile: nvram shared wlcsm
wget/Makefile.am: nvram shared wlcsm
wget/Makefile.in: nvram shared wlcsm

# 共 46 条

# ===== 链接依赖补全（一次性覆盖整类）=====
# 来源：串行日志的实际 -lXXX + 源码树里 libXXX.so/.a 的所属包。
# 只写上游未声明的部分；已做传递闭包防环检查。
LPRng: shared
accel-pptpd: e2fsprogs iptables-1.4.x netatalk-3.0.5
accel-pptpd/pptpd-1.3.3/Makefile: e2fsprogs iptables-1.4.x netatalk-3.0.5
aws-iot: bwdpi_source cfg_mnt json-c libdisk libwebapi mssl sqlite
aws-iot/Makefile: bwdpi_source cfg_mnt json-c libdisk libwebapi mssl sqlite
config: ncurses-6.3
config/conf: ncurses-6.3
config/mconf: ncurses-6.3
coovachilli: shared
coovachilli-configure: shared
coovachilli/Makefile: shared
db-4.8.30: libgcrypt-1.5.1 libgpg-error-1.10
db-4.8.30/build_unix/stamp-h1: libgcrypt-1.5.1 libgpg-error-1.10
dropbear: netatalk-3.0.5 protect_srv shared
dropbear/config.h: netatalk-3.0.5 protect_srv shared
dropbear/config.h.in: netatalk-3.0.5 protect_srv shared
e2fsprogs: iptables-1.4.x
e2fsprogs-configure: iptables-1.4.x
e2fsprogs/Makefile: iptables-1.4.x
e2fsprogs/Makefile.in: iptables-1.4.x
email-3.1.3: nt_center sqlite
email-3.1.3/Makefile: nt_center sqlite
ethtool-6.2: libmnl-1.0.4
ethtool-6.2/Makefile: libmnl-1.0.4
ethtool-6.2/configure: libmnl-1.0.4
expat-2.0.1: libdaemon
expat-2.0.1/stamp-h1: libdaemon
haveged: libcap-ng libevent-2.0.21
haveged/Makefile: libcap-ng libevent-2.0.21
httpd: libasuslog libcodb libletsencrypt libovpn nt_center sqlite
hub-ctrl: libusb10
infosvr: amas-utils jansson-2.7 json-c lldpd-0.9.8
jpeg: ffmpeg flac libexif libid3tag libogg libvorbis sqlite zlib
jpeg/stamp-h1: ffmpeg flac libexif libid3tag libogg libvorbis sqlite zlib
libcodb: json-c shared sqlite
libcodb/stamp-h1: json-c shared sqlite
libconfuse: shared
libconfuse/Makefile: shared
libdisk: shared
libevent-2.0.21: db-4.8.30 libgcrypt-1.5.1 libgpg-error-1.10
libevent-2.0.21/Makefile: db-4.8.30 libgcrypt-1.5.1 libgpg-error-1.10
libgcrypt-1.5.1: libgpg-error-1.10
libgcrypt-1.5.1/stamp-h1: libgpg-error-1.10
libimobiledevice-1.3.0: libplist-2.2.0 libusb10
libimobiledevice-1.3.0-configure: libplist-2.2.0 libusb10
libimobiledevice-1.3.0/Makefile: libplist-2.2.0 libusb10
libmnl-1.0.4: libnfnetlink-1.0.1
libmnl-1.0.4-configure: libnfnetlink-1.0.1
libmnl-1.0.4/Makefile: libnfnetlink-1.0.1
libnetfilter_cttimeout-1.0.0: libmnl-1.0.4 libnfnetlink-1.0.1
libnetfilter_cttimeout-1.0.0-configure: libmnl-1.0.4 libnfnetlink-1.0.1
libnetfilter_cttimeout-1.0.0/Makefile: libmnl-1.0.4 libnfnetlink-1.0.1
libnss-mdns: libpcap
libnss-mdns/Makefile: libpcap
libnss-mdns/configure: libpcap
libusbmuxd-2.0.2: libplist-2.2.0
libusbmuxd-2.0.2-configure: libplist-2.2.0
libusbmuxd-2.0.2/Makefile: libplist-2.2.0
libvorbis: ffmpeg flac libexif libid3tag libogg sqlite zlib
libvorbis/stamp-h1: ffmpeg flac libexif libid3tag libogg sqlite zlib
libwebapi: bwdpi_source json-c shared sqlite
libwebapi/stamp-h1: bwdpi_source json-c shared sqlite
lltdc: shared
miniupnpd-igdv2: e2fsprogs iptables-1.4.x
mssl: libmnl-1.0.4 libnfnetlink-1.0.1
net-snmp: libpcap shared
nt_center: sqlite
nt_center/stamp-h1: sqlite
openpam: libcap-ng lz4 lzo-2.10 zlib
openpam/Makefile: libcap-ng lz4 lzo-2.10 zlib
phddns: shared
phddns/stamp-h1: shared
rstats: libmnl-1.0.4
socat: netatalk-3.0.5
socat/Makefile: netatalk-3.0.5
urlfilterd: libnetfilter_queue libnfnetlink-1.0.1
usbmuxd-1.1.1: libusb10
usbmuxd-1.1.1-configure: libusb10
usbmuxd-1.1.1/Makefile: libusb10
vsftpd-3.x: json-c
wget: e2fsprogs netatalk-3.0.5 pcre-8.31 shared
wget/Makefile: e2fsprogs netatalk-3.0.5 pcre-8.31 shared
wget/Makefile.am: e2fsprogs netatalk-3.0.5 pcre-8.31 shared
wget/Makefile.in: e2fsprogs netatalk-3.0.5 pcre-8.31 shared
wireguard-tools: zlib
wpa_supplicant: e2fsprogs pcre-8.31 zlib

# 共 86 条

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
