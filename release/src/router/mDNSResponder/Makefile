# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
export MSIPK := $(MSIPK)
all:
	$(MAKE) -C mDNSPosix os=linux

install: 
	$(MAKE) -C mDNSPosix os=linux romfs

clean:
	$(MAKE) -C mDNSPosix os=linux clean

