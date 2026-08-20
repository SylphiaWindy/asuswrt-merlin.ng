# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
X86ASM-OBJS                     += x86/audio_convert.o\
                                   x86/rematrix.o\
                                   x86/resample.o\

OBJS                            += x86/audio_convert_init.o\
                                   x86/rematrix_init.o\
                                   x86/resample_init.o\

OBJS-$(CONFIG_XMM_CLOBBER_TEST) += x86/w64xmmtest.o
