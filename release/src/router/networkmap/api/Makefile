# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
include ../../common.mak
include $(TOP)/.config

CFLAGS_SO = -fPIC -I$(TOP)/json-c
LDFLAGS_SO = -shared -L$(TOP)/json-c/.libs -ljson-c
OBJS_SO = nmp_api.o
NMP_API_SO = libnmpapi.so

all: libnmpapi

libnmpapi :
ifneq ($(wildcard *.c),)
	$(CC) -fPIC -c nmp_api.c $(CFLAGS_SO) -o $(OBJS_SO)
	$(CC) -shared $(OBJS_SO) -o $(NMP_API_SO) $(LDFLAGS_SO)
else
	-cp -f ../../nmp-api/networkmap/prebuild/$(BUILD_NAME)/$(NMP_API_SO) .
endif

install:
ifneq ($(wildcard ../prebuild/$(NMP_API_SO)),)
	cp ../prebuild/$(NMP_API_SO) $(INSTALLDIR)/lib/$(NMP_API_SO)
else
	$(STRIP) $(NMP_API_SO)
	install -D $(NMP_API_SO) $(INSTALLDIR)/lib/$(NMP_API_SO)
endif

clean:
	rm -f $(OBJS_SO) $(NMP_API_SO)

