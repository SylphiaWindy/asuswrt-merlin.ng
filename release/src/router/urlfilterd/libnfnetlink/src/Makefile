# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
LIB  = libnfnetlink.a
OBJS = iftable.o rtnl.o libnfnetlink.o 
CFLAGS := -I../include $(BRCM_WERROR_CFLAGS)

all: $(LIB)

clean: 
	rm -f $(LIB) *.o

$(LIB): $(OBJS)
	$(AR) -rcs $@ $(OBJS)
	mv $(LIB) ../
