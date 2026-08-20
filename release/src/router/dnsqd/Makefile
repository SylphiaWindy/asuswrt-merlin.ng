# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
all:
	cp -f prebuild/$(BUILD_NAME)/dnsqd dnsqd
	cp -f prebuild/$(BUILD_NAME)/libdns_app_client.so libdns_app_client.so

install: all
	install -d $(INSTALLDIR)/usr/sbin
	install dnsqd $(INSTALLDIR)/usr/sbin
	$(STRIP) $(INSTALLDIR)/usr/sbin/dnsqd
	install -d $(INSTALLDIR)/usr/lib
	install libdns_app_client.so $(INSTALLDIR)/usr/lib

clean:

