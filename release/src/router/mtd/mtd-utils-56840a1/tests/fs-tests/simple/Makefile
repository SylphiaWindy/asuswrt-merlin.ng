# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:

ifeq ($(origin CC),default)
CC = gcc
endif

CFLAGS := $(CFLAGS) -Wall -g -O2 -I../lib

LDFLAGS := $(LDFLAGS)

TARGETS = test_1 \
	test_2 \
	ftrunc \
	orph \
	perf

all: $(TARGETS)

$(TARGETS): ../lib/tests.o

../lib/tests.o: ../lib/tests.h

clean:
	rm -f *.o $(TARGETS)

tests: all
	./test_1 --sync
	./test_2 --sync
	./ftrunc
	./orph --sync
	./perf
