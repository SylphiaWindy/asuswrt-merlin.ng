# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
NSHOME   =  /home/aol31

EXIFDIR  = ..

#
# Module name
#
MOD      =  nsexif.so

#
# Objects to build
#
OBJS     =  nsexif.o

#
# Installation directory for data files
#
MODDIR   =  nsexif
MODLIBS  =  -L.. -lexif

CFLAGS += -I$(EXIFDIR)

include $(NSHOME)/include/Makefile.module
