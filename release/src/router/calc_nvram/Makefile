# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
include ../common.mak

CACL_FLAGS += -Wall -O

ifeq ($(RTCONFIG_JFFS_NVRAM),y)
CACL_FLAGS += -DRTCONFIG_JFFS_NVRAM
endif

all: clean run_python calc_nvram

calc_nvram: calc_nvram.o
	@echo " [calc_nvram] CC $@"
	gcc -o $@ calc_nvram.o $(EXTRALDFLAGS)
	$(TOP)/calc_nvram/calc_nvram

run_python:
	@-type -P python >/dev/null 2>&1 && python $(TOP)/calc_nvram/calc_nvram.py $(TOP)

install:

clean:
	rm -f calc_nvram *.o defaults_nv.h

%.o: %.c
	@echo " [calc_nvram] CC $@"
	gcc $(CACL_FLAGS) -o $@ -c $<