# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
OBJS                             += aarch64/audio_convert_init.o \
                                    aarch64/resample_init.o

OBJS-$(CONFIG_NEON_CLOBBER_TEST) += aarch64/neontest.o

NEON-OBJS                        += aarch64/audio_convert_neon.o \
                                    aarch64/resample.o
