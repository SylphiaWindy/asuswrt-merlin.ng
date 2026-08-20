# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
# ==========================================================================
# Build system
# ==========================================================================

# -mpreferred-stack-boundary=2 is essential in preventing gcc 4.2.x
# from aligning stack to 16 bytes. (Which is gcc's way of supporting SSE).
CFLAGS += $(call cc-option,-march=i386 -mpreferred-stack-boundary=2,)
