# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
MAKE = make

CFLAGS = -Wall -O2 -g  $(EXTRACFLAGS)
CFLAGS += -I$(TOP)/shared -I$(SRCBASE)/include -I$(SRCBASE)/common/include
CFLAGS += -I$(SRCBASE) -I$(SRCBASE)/include -I. -I$(TOP)/nuc029ctrl/include/

LDFLAGS += -L$(TOP_PLATFORM)/nvram$(BCMEX)${EX7} -lnvram
LDFLAGS += -L$(TOP)/shared -lshared
LDFLAGS += -L$(TOP)/nuc029ctrl/lib/ -lnuc029

LIBS = -lpthread -lm -lgcc_s

MDIRS = lib

ifeq ($(wildcard $(SRCBASE)/router/nuc029ctrl/*.c),)
all:
	-cp -f prebuild/nuc029ctrl nuc029ctrl
	-cp -f lib/prebuild/*.h lib

else
all: libnuc029.so nuc029ctrl
endif

libnuc029.so:
	set -e; for d in ${MDIRS}; do $(MAKE) -C $${d}; done

nuc029ctrl: nuc029ctrl.o

nuc029ctrl:
	$(CC) ${CFLAGS} $< -o $@ ${LDFLAGS} $(LIBS)
	$(STRIP) $@

install: all
	$(STRIP) nuc029ctrl lib/libnuc029.so
	install -D lib/libnuc029.so $(INSTALLDIR)/usr/lib/libnuc029.so
	install -D nuc029ctrl $(INSTALLDIR)/usr/sbin/nuc029ctrl

.PHONY: all clean

clean:
	set -e; for d in ${MDIRS}; do $(MAKE) -C $${d} clean; done
	rm -rf *.o nuc029ctrl


