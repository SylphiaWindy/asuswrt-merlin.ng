# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
MAN3PAGES=libnetlink.3

all:

distclean: clean

clean:

install:
	$(INSTALLDIR) $(DESTDIR)$(MANDIR)/man3
	$(INSTALLMAN) $(MAN3PAGES) $(DESTDIR)$(MANDIR)/man3

.PHONY: install clean distclean
