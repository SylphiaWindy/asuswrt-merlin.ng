# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
$(SUBDIR)x86/swscale_mmx.o: CFLAGS += $(NOREDZONE_FLAGS)

OBJS                            += x86/rgb2rgb.o                        \
                                   x86/swscale.o                        \
                                   x86/yuv2rgb.o                        \

MMX-OBJS                        += x86/hscale_fast_bilinear_simd.o      \

OBJS-$(CONFIG_XMM_CLOBBER_TEST) += x86/w64xmmtest.o

X86ASM-OBJS                     += x86/input.o                          \
                                   x86/output.o                         \
                                   x86/scale.o                          \
                                   x86/rgb_2_rgb.o                      \
                                   x86/yuv_2_rgb.o                      \
                                   x86/yuv2yuvX.o                       \
