# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:

OBJS = pstree.o

all: pstree

.c.o:
	$(CC) -c $*.c $(CFLAGS)

pstree: $(OBJS)
	$(CC) -o pstree $(OBJS) $(CFLAGS) $(LDFLAGS)

.PHONY: clean
clean:
	--rm -rf stamp-h1 pstree $(OBJS)
