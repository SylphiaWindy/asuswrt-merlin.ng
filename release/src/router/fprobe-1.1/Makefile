# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
#include ../.config

CFLAGS  += -I. -I$(TOP)/libpcap -Dlinux -pthread
LDFLAGS = -L$(TOP)/libpcap -lpcap -lpthread

all: fprobe

clean:
	rm -f *.o fprobe

install: all
	echo $(INSTALLDIR)
	install -d $(INSTALLDIR)/usr/sbin
	$(STRIP) fprobe
	install fprobe $(INSTALLDIR)/usr/sbin


fprobe: fprobe.c hash.c mem.c my_getopt.c my_log.c netflow.c
	$(CC) -o $@ $^ $(LDFLAGS) $(CFLAGS)
	$(STRIP) $@
