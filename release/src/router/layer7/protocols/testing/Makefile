# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
all: randchars randprintable test_speed-kernel test_speed-userspace match_kernel

randchars: randchars.c
	gcc -O2 -o randchars randchars.c

randprintable: randprintable.c
	gcc -O2 -o randprintable randprintable.c

test_speed-kernel: test_speed-kernel.c
	gcc -o test_speed-kernel test_speed-kernel.c

test_speed-userspace: test_speed-userspace.cpp l7-parse-patterns.cpp l7-parse-patterns.h
	g++ -Wall -o test_speed-userspace test_speed-userspace.cpp l7-parse-patterns.cpp

match_kernel: match-kernel.c
	gcc -O2 -o match_kernel match-kernel.c

clean:
	rm -f randprintable randchars test_speed-kernel test_speed-userspace match_kernel
