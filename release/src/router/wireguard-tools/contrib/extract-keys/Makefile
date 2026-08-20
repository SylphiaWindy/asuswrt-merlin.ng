# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
ifeq ($(KERNELRELEASE),)
KERNELDIR ?= /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)
CFLAGS ?= -O3 -march=native
CFLAGS += -Wall -pedantic -std=gnu11

extract-keys: extract-keys.c config.h
	$(CC) $(CFLAGS) $(CPPFLAGS) -D_FILE_OFFSET_BITS=64 -o $@ -lresolv $<

config.o: config.c
	$(MAKE) -C $(KERNELDIR) M=$(PWD) $@
	objcopy -j '.rodata*' $@ $@

config: config.c config.o
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ $^

config.h: config
	./$< > $@

clean:
	rm -f extract-keys config config.h
	$(MAKE) -C $(KERNELDIR) M=$(PWD) clean

.PHONY: clean
else
obj-m := config.o
endif
