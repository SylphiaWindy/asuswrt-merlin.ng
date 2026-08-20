# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
OBJS      += arm/audio_convert_init.o \
             arm/resample_init.o


OBJS-$(CONFIG_NEON_CLOBBER_TEST) += arm/neontest.o

NEON-OBJS += arm/audio_convert_neon.o \
             arm/resample.o
