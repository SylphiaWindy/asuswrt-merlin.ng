# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
INSTALL=install
INSTALLDIR=install -m 0755 -d
INSTALLMAN=install -m 0644

SUBDIRS = man3 man7 man8

all clean install:
	@for subdir in $(SUBDIRS); do $(MAKE) -C $$subdir $@ || exit $$?; done

distclean: clean

.PHONY: install clean distclean

.EXPORT_ALL_VARIABLES:
