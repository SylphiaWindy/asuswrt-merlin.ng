# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
OBJS        += arm/swscale.o                    \
               arm/swscale_unscaled.o           \

NEON-OBJS   += arm/rgb2yuv_neon_32.o
NEON-OBJS   += arm/rgb2yuv_neon_16.o
NEON-OBJS   += arm/hscale.o                     \
               arm/output.o                     \
               arm/yuv2rgb_neon.o               \
