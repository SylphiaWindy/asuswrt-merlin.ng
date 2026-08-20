# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
OBJS += ppc/swscale_altivec.o                                           \
        ppc/yuv2rgb_altivec.o                                           \
        ppc/yuv2yuv_altivec.o                                           \
        ppc/swscale_vsx.o
