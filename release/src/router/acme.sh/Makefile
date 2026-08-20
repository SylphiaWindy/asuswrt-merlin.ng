# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
include ../common.mak

all:

install:
	install -d $(INSTALLDIR)/usr/sbin

	install -m 0700 acme.sh $(INSTALLDIR)/usr/sbin
	install -D -m 0700 dnsapi/dns_asusapi.sh $(INSTALLDIR)/usr/sbin/dnsapi/dns_asusapi.sh

clean:

