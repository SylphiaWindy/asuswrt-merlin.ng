# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
LIB  = libnetfilter_queue.a
OBJS = libnetfilter_queue.o 
CFLAGS := -I../include\
          -I../../libnfnetlink/include

all: $(LIB)

clean: 
	rm -f $(LIB) *.o

$(LIB): $(OBJS)
	$(AR) -rcs $@ $(OBJS)
	mv $(LIB) ../
