# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
all:
	@echo Nothing to compile, just run \'make install\'
	@echo \(This simply copies this directory into $(PREFIX)/etc/l7-protocols \)	
install:
	mkdir -p $(PREFIX)/etc/l7-protocols
	cp -R * $(PREFIX)/etc/l7-protocols
