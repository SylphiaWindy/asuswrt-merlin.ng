# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
OBJS += ppc/cpu.o                                                       \
        ppc/float_dsp_init.o                                            \

ALTIVEC-OBJS += ppc/float_dsp_altivec.o                                 \

VSX-OBJS     += ppc/float_dsp_vsx.o                                     \
