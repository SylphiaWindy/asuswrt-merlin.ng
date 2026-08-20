# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
NAME = swscale
DESC = FFmpeg image rescaling library

HEADERS = swscale.h                                                     \
          version.h                                                     \

OBJS = alphablend.o                                     \
       hscale.o                                         \
       hscale_fast_bilinear.o                           \
       gamma.o                                          \
       input.o                                          \
       options.o                                        \
       output.o                                         \
       rgb2rgb.o                                        \
       slice.o                                          \
       swscale.o                                        \
       swscale_unscaled.o                               \
       utils.o                                          \
       yuv2rgb.o                                        \
       vscale.o                                         \

OBJS-$(CONFIG_SHARED)        += log2_tab.o

# Windows resource file
SLIBOBJS-$(HAVE_GNU_WINDRES) += swscaleres.o

TESTPROGS = colorspace                                                  \
            floatimg_cmp                                                \
            pixdesc_query                                               \
            swscale                                                     \
