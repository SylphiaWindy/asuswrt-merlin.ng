# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
OBJS-$(CONFIG_BLOCKDSP)                 += alpha/blockdsp_alpha.o
OBJS-$(CONFIG_ME_CMP)                   += alpha/me_cmp_alpha.o         \
                                           alpha/me_cmp_mvi_asm.o
OBJS-$(CONFIG_HPELDSP)                  += alpha/hpeldsp_alpha.o        \
                                           alpha/hpeldsp_alpha_asm.o
OBJS-$(CONFIG_IDCTDSP)                  += alpha/idctdsp_alpha.o        \
                                           alpha/idctdsp_alpha_asm.o    \
                                           alpha/simple_idct_alpha.o
OBJS-$(CONFIG_MPEGVIDEO)                += alpha/mpegvideo_alpha.o
OBJS-$(CONFIG_PIXBLOCKDSP)              += alpha/pixblockdsp_alpha.o
