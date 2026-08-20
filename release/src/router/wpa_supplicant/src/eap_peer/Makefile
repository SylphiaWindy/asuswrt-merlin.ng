# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
all:
	@echo Nothing to be made.

clean:
	for d in $(SUBDIRS); do make -C $$d clean; done
	rm -f *~ *.o *.so *.d

install:
	if ls *.so >/dev/null 2>&1; then \
		install -d $(DESTDIR)$(LIBDIR)/wpa_supplicant && \
		cp *.so $(DESTDIR)$(LIBDIR)/wpa_supplicant \
	; fi
