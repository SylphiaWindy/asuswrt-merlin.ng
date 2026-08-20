# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
KERNEL_DIR ?= /usr/src/linux-headers-$(shell uname -r)

obj-m += xt_coova.o

all: libxt_coova.so
	make -C ${KERNEL_DIR} M=$$PWD;

modules:
	make -C ${KERNEL_DIR} M=$$PWD $@;

modules_install:
	make -C ${KERNEL_DIR} M=$$PWD $@;

modules_clean:
	make -C ${KERNEL_DIR} M=$$PWD $@;

clean:
	rm -f *.o *~ *.ko *.mod.c Module.markers modules.order Module.symvers libxt_coova.so

lib%.so: lib%.o
	$(CC) $(CFLAGS) -shared -o $@ $^;

lib%.o: lib%.c
	$(CC) $(CFLAGS) -fPIC -O2 -Wall -I${KERNEL_DIR}/include -D_INIT=lib$*_init -c -o $@ $<;

install: modules_install libxt_coova.so
	mkdir -p $(DESTDIR)/lib/xtables/
	cp libxt_coova.so $(DESTDIR)/lib/xtables/

distdir:

distclean: clean