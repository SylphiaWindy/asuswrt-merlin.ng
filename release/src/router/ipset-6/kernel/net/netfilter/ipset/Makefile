# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
ifndef IP_SET_MAX
$(error "Use the toplevel Makefile, not the ones in the kernel/ subdirectory")
endif

ifneq ($(KERNELRELEASE),)
include Kbuild
else
KERNELDIR := /lib/modules/`uname -r`/build
all::
	$(MAKE) -C $(KERNELDIR) M=`pwd` $@
endif
