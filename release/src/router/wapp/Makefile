# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
all:

install: all
	install -D prebuild/wapp $(INSTALLDIR)/bin/wapp
	install -D prebuild/wappctrl $(INSTALLDIR)/bin/wappctrl
	$(STRIP) $(INSTALLDIR)/bin/wapp
	$(STRIP) $(INSTALLDIR)/bin/wappctrl
	chmod 0500 $(INSTALLDIR)/bin/wapp
	chmod 0500 $(INSTALLDIR)/bin/wappctrl
	install -D -m 755 prebuild/libkvcutil.so  $(INSTALLDIR)/usr/lib/libkvcutil.so
	$(STRIP) $(INSTALLDIR)/usr/lib/libkvcutil.so
	@cd $(INSTALLDIR)/usr/lib && ln -sf libkvcutil.so libkvcutil.so.1

clean:
	-rm -f $(EXEC) *.elf *.gdb *.o
