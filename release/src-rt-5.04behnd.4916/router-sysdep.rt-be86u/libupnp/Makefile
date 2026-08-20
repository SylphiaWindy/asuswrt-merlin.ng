# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:

include $(TOP)/common.mak
UPNPLIB_NAME = libupnp.so

OBJFILES = ${SRCFILES:.c=.o}

all:
	echo use prebuilt 
	cp -f ./prebuilt/$(UPNPLIB_NAME) .

install:
	install -d $(INSTALLDIR)/usr/lib
	install -m 755 $(UPNPLIB_NAME) $(INSTALLDIR)/usr/lib
	$(STRIP) $(INSTALLDIR)/usr/lib/$(UPNPLIB_NAME)

dynamic:

clean:
	rm -f $(UPNPLIB_NAME) $(OBJFILES)


