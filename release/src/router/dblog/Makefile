# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
all:
	$(MAKE) -C daemon
	$(MAKE) -C commands
	$(MAKE) -C colog

install:
	$(MAKE) -C daemon install
	$(MAKE) -C commands install
	$(MAKE) -C colog install

clean:
	$(MAKE) -C daemon clean
	$(MAKE) -C commands clean
	$(MAKE) -C colog clean
