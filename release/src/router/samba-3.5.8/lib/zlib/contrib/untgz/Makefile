# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
CC=cc
CFLAGS=-g

untgz: untgz.o ../../libz.a
	$(CC) $(CFLAGS) -o untgz untgz.o -L../.. -lz

untgz.o: untgz.c ../../zlib.h
	$(CC) $(CFLAGS) -c -I../.. untgz.c

../../libz.a:
	cd ../..; ./configure; make

clean:
	rm -f untgz untgz.o *~
