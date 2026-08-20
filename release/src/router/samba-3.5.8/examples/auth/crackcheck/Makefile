# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
# C compiler
#CC=cc
CC=gcc

# Uncomment the following to add symbols to the code for debugging
#DEBUG=-g -Wall

# Optimization for the compiler
#OPTIMIZE=
OPTIMIZE=-O2

CFLAGS= $(DEBUG) $(OPTIMIZE)

OBJS = crackcheck.o
LIBS = -lcrack

crackcheck: $(OBJS)
	$(CC) $(CFLAGS) $(LIBS) -o crackcheck $(OBJS)

clean:
	rm -f core *.o crackcheck

install: crackcheck
	install -m 555 crackcheck $(PREFIX)/sbin/crackcheck

