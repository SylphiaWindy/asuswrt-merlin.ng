# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
OBJS += arm/cpu.o                                                       \
        arm/float_dsp_init_arm.o                                        \

VFP-OBJS += arm/float_dsp_init_vfp.o                                    \
            arm/float_dsp_vfp.o                                         \

NEON-OBJS += arm/float_dsp_init_neon.o                                  \
             arm/float_dsp_neon.o                                       \
