# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
include ../common.mak
include $(SRCBASE)/.config

OBJS = ifenslave.o
PROGS = ifenslave

CFLAGS += $(EXTRACFLAGS)
ifneq ($(HND_ROUTER),y)
CFLAGS += -Wall -Wstrict-prototypes -Os -I$(LINUXDIR)/include
endif


all: $(PROGS)


$(PROGS): ifenslave.c
	$(CC) $(CFLAGS) $^ -o $@

install: all
	$(STRIP) $(PROGS)
	install -D $(PROGS) $(INSTALLDIR)/bin/$(PROGS)

clean:
	rm -f *.o $(PROGS)
