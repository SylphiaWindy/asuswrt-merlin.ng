# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
puff: puff.c puff.h
	cc -DTEST -o puff puff.c

test: puff
	puff zeros.raw

clean:
	rm -f puff puff.o
