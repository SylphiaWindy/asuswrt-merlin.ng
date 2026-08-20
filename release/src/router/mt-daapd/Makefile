# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
export MSIPK
export SRCDIR
export CURRENT
all:
	$(MAKE) -C src

install:
ifneq ($(MSIPK),y)
	$(MAKE) -C src romfs
	install -d $(INSTALLDIR)/rom/etc
	rm -rf $(INSTALLDIR)/rom/etc/web
	cp -rf admin-root $(INSTALLDIR)/rom/etc/web 
	find $(INSTALLDIR)/rom/etc/web -name 'Makefile*' -exec rm -rf {} +
else
	install -D $(SRCDIR)/mt-daapd/src/mt-daapd $(CURRENT)/opt/sbin/mt-daapd 
	cp -f $(CURRENT)/opt/sbin/mt-daapd $(CURRENT)/mediaserver/opt/tmp/bin/
endif

clean:
	$(MAKE) -C src clean
