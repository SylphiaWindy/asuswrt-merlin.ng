# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
BROBJ = bridge.o fdb.o monitor.o link.o mdb.o vlan.o

include ../Config

ifeq ($(IP_CONFIG_SETNS),y)
	CFLAGS += -DHAVE_SETNS
endif

all: bridge

bridge: $(BROBJ) $(LIBNETLINK) 

install: all
	install -m 0755 bridge $(DESTDIR)$(SBINDIR)

clean:
	rm -f $(BROBJ) bridge

