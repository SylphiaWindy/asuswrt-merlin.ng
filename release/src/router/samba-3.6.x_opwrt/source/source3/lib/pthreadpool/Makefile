# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
all: tests

CFLAGS=-O3 -g -Wall

pthreadpool.o: pthreadpool.c pthreadpool.h
	gcc -c -O3 -o pthreadpool.o pthreadpool.c -I../../..

tests: tests.o pthreadpool.o
	gcc -o tests tests.o pthreadpool.o -lpthread