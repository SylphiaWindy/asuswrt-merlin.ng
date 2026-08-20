# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
NAME = postproc
DESC = FFmpeg postprocessing library
FFLIBS = avutil

HEADERS = postprocess.h        \
          version.h            \

OBJS = postprocess.o

# Windows resource file
SLIBOBJS-$(HAVE_GNU_WINDRES) += postprocres.o
