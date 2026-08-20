# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
SRCROOT = ..
VERSION = $(shell cat ../version)

-include ../MCONFIG
include ../MRULES

OBJS = tftpsubs.$(O)
LIB  = libcommon.a

all: $(LIB)

$(LIB): $(OBJS)
	-rm -f $(LIB)
	$(AR) $(LIB) $(OBJS)
	$(RANLIB) $(LIB)

$(OBJS): tftpsubs.h

install:

clean:
	rm -f *.o *.obj *.exe $(LIB)

distclean: clean
	rm -f *~
