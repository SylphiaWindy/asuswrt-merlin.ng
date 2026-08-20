# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
# makefile template

#include MakeInclude

CROSS =
CC = $(CROSS)gcc
AR = $(CROSS)ar
STRIP = $(CROSS)strip
#DOSTATIC = true

ifeq ($(PLATFORM),ppc)
CCFLAGS = -g -O2 -D_GNU_SOURCE -Wall -I../../linuxppc/linux-2.4.19-rc3/include
else
CCFLAGS = -g -O2 -D_GNU_SOURCE -Wall -I$(LINUXDIR)/include
endif

ifeq ($(strip $(DOSTATIC)),true)
    LDFLAGS += --static
endif


LDLIBS =  

VLAN_OBJS = vconfig.o

ALL_OBJS = ${VLAN_OBJS}

VCONFIG = vconfig                  #program to be created


all: ${VCONFIG}


#This is pretty silly..
vconfig.h: Makefile
	touch vconfig.h


$(VCONFIG): $(VLAN_OBJS)
	$(CC) $(CCFLAGS) $(LDFLAGS) -o $(VCONFIG) $(VLAN_OBJS) $(LDLIBS)
	$(STRIP) $(VCONFIG)


install: $(VCONFIG)
	install -d $(INSTALLDIR)/usr/sbin
	install -m 755 vconfig $(INSTALLDIR)/usr/sbin
	$(STRIP) $(INSTALLDIR)/usr/sbin/vconfig

$(ALL_OBJS): %.o: %.c %.h
	@echo " "
	@echo "Making $<"
	$(CC) $(CCFLAGS) -c $<

clean:
	rm -f *.o

purge: clean
	rm -f *.flc ${VCONFIG} vconfig.h
	rm -f *~
