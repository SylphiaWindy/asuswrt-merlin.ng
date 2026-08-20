
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
