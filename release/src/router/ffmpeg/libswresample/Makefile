# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
NAME = swresample
DESC = FFmpeg audio resampling library
FFLIBS = avutil

HEADERS = swresample.h                       \
          version.h                          \

OBJS = audioconvert.o                        \
       dither.o                              \
       options.o                             \
       rematrix.o                            \
       resample.o                            \
       resample_dsp.o                        \
       swresample.o                          \
       swresample_frame.o                    \

OBJS-$(CONFIG_LIBSOXR) += soxr_resample.o
OBJS-$(CONFIG_SHARED)  += log2_tab.o

# Windows resource file
SLIBOBJS-$(HAVE_GNU_WINDRES) += swresampleres.o

TESTPROGS = swresample
