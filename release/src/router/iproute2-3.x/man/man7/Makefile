# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
MAN7PAGES = tc-hfsc.7

all:

distclean: clean

clean:

install:
	$(INSTALLDIR) $(DESTDIR)$(MANDIR)/man7
	$(INSTALLMAN) $(MAN7PAGES) $(DESTDIR)$(MANDIR)/man7

.PHONY: install clean distclean
