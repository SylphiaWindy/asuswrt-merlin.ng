# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
# $Id: Makefile,v 1.2 2009/08/20 09:31:10 nanard Exp $
CC=gcc
CFLAGS=-Wall -g -I.
RM=rm -f

all: testipfwrdr

clean:
	$(RM) *.o testipfwrdr

testipfwrdr: testipfwrdr.o ipfwrdr.o ipfwaux.o
	$(CC) -o $@ $^

ipfwrdr.o: ipfwrdr.c ipfwaux.c

testipfwrdr.o: testipfwrdr.c

