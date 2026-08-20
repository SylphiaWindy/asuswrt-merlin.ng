# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
#
# Extra functions which may not be available everywhere
#

SRCROOT = ..

-include ../MCONFIG
include ../MRULES

ifeq ($(LIBOBJS),)
all:
else
all:	libxtra.a
endif

install:

clean:
	-rm -f *.a *.o *.obj *.exe

distclean: clean
	-rm -f *~

libxtra.a: $(LIBOBJS)
	-rm -f libxtra.a
	$(AR) libxtra.a $(LIBOBJS)
	$(RANLIB) libxtra.a


