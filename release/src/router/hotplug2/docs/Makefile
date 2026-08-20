# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
# vim:set sw=8 nosta:

BINS=
SUBDIRS=
MANDIR=/usr/share/man

all:

install:
	$(INSTALL) $(wildcard *.8) $(PREFIX)$(MANDIR)/man8/


include ../common.mak
MAKEDEP:=
