# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
# vim:set sw=8 nosta:

BINS=hotplug2
SUBDIRS=examples


all: $(BINS)

install:
	$(INSTALL_DIR) $(PREFIX)/sbin/
	$(INSTALL_BIN) $(BINS) $(PREFIX)/sbin/
	@for i in $(BINS); do $(STRIP) $(PREFIX)/sbin/$$i ; done


hotplug2: hotplug2.o hotplug2_utils.o childlist.o mem_utils.o rules.o filemap_utils.o
hotplug2-dnode: hotplug2-dnode.o hotplug2_utils.o mem_utils.o parser_utils.o


include common.mak
