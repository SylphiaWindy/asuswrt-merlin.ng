# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
LIB  = libnetfilter_queue.a
SRC_DIR = src

.PHONY : $(SRC_DIR)
	all : $(SRC_DIR)

src: 
	$(MAKE) -C $@

clean: 
	rm -f $(LIB) ./src/*.o

