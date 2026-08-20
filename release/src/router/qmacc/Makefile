# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
include ../common.mak

install:
	-@install -d $(INSTALLDIR)/usr/sbin
	-@install -D $(TOP)/qmacc/qmacc_asus_monitor.sh $(INSTALLDIR)/usr/sbin/