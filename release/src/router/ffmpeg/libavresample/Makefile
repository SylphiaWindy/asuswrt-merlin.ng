# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
NAME = avresample
DESC = Libav audio resampling library

HEADERS = avresample.h                                                  \
          version.h                                                     \

OBJS = audio_convert.o                                                  \
       audio_data.o                                                     \
       audio_mix.o                                                      \
       audio_mix_matrix.o                                               \
       dither.o                                                         \
       options.o                                                        \
       resample.o                                                       \
       utils.o                                                          \

# Windows resource file
SLIBOBJS-$(HAVE_GNU_WINDRES) += avresampleres.o

TESTPROGS = avresample
