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
