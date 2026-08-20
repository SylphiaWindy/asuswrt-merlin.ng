
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
