# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
# vim:set sw=8 nosta:

BINS=generate_alias hotplug2-coldplug-2.4 hotplug2-modwrap
SUBDIRS=
DESTDIR=


all: $(BINS)

install:
	$(INSTALL_BIN) hotplug2-coldplug-2.4 hotplug2-modwrap $(DESTDIR)/sbin/
	$(INSTALL_BIN) generate_alias $(DESTDIR)/usr/sbin/


hotplug2-coldplug-2.4: hotplug2-coldplug-2.4.o ../parser_utils.o ../filemap_utils.o ../mem_utils.o ../hotplug2_utils.o
hotplug2-modwrap: hotplug2-modwrap.o ../parser_utils.o ../filemap_utils.o ../mem_utils.o
generate_alias: generate_alias.o ../parser_utils.o ../filemap_utils.o ../mem_utils.o


include ../common.mak
