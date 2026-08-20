# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
#CROSS ?= mipsel-uclibc-
CC ?= $(CROSS)gcc
STRIP ?= $(CROSS)strip

CFLAGS += -Os -Wall -I. -ffunction-sections -fdata-sections $(EXTRACFLAGS)
LDFLAGS += -Wl,--gc-sections

all: lanauth

lanauth: lanauth.o md5.o rmd160.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

srvauth: srvauth.o md5.o rmd160.o
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^

%.o: %.c
	$(CC) $(CFLAGS) -c $<

clean distclean:
	@rm -f *.o lanauth srvauth

install: lanauth
	install -D lanauth $(INSTALLDIR)/usr/sbin/lanauth
	$(STRIP) $(INSTALLDIR)/usr/sbin/lanauth
