# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
include ../common.mak

# Comment out line bellow if you don't want to use 
# libwrap (hosts.{allow,deny} access control)
#LIBWRAP = -lwrap
ifneq ("$(LIBWRAP)", "")
LIBWRAP += -DUSE_LIBWRAP
endif

# If you don't have it in /var/lock/subsys, uncomment and define
CFLAGS += -DLOCKFILE_DIR=\"/var/lock\"

CFLAGS += -O2  -Wall $(EXTRACFLAGS)

ifeq ($(STATIC),1)
CFLAGS += -static
endif

CFLAGS += -I$(SRCBASE) -I$(SRCBASE)/include -I. -I$(TOP)/shared

PROG = p910nd
BINDIR = /usr/sbin

$(PROG):	p910nd.c
	$(CC) -o $@ $^ $(CFLAGS) $(LIBWRAP)

strip: $(PROG)
	@$(STRIP) -s $(PROG)

install: $(PROG)
	mkdir -p $(INSTALLDIR)$(BINDIR)
	@install $(PROG) $(INSTALLDIR)$(BINDIR)
	@$(STRIP) -s $(INSTALLDIR)$(BINDIR)/$(PROG)

.PHONY: clean
clean:
	rm -f *.o $(PROG)
