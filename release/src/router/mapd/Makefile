# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
all:

install: all
	install -D prebuild/bs20 $(INSTALLDIR)/bin/bs20
	$(STRIP) $(INSTALLDIR)/bin/bs20
	chmod 0500 $(INSTALLDIR)/bin/bs20
	install -D prebuild/mapd_cli $(INSTALLDIR)/bin/mapd_cli
	$(STRIP) $(INSTALLDIR)/bin/mapd_cli
	chmod 0500 $(INSTALLDIR)/bin/mapd_cli
	install -D -m 755 prebuild/libmapd_interface_client.so $(INSTALLDIR)/usr/lib/libmapd_interface_client.so
	$(STRIP) $(INSTALLDIR)/usr/lib/libmapd_interface_client.so

clean:
	-rm -f $(EXEC) *.elf *.gdb *.o
