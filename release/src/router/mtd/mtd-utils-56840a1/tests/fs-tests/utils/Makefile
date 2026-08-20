# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:

ifeq ($(origin CC),default)
CC = gcc
endif

CFLAGS := $(CFLAGS) -Wall -g -O2 -I../lib

LDFLAGS := $(LDFLAGS)

TARGETS = fstest_monitor free_space

all: $(TARGETS)

clean:
	rm -f *.o $(TARGETS)

tests: all
	./fstest_monitor
	./free_space > /dev/null
