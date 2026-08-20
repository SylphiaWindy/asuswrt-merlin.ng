# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
all:
	$(MAKE) -C log_daemon
	$(MAKE) -C commands

install:
	$(MAKE) -C log_daemon install
	$(MAKE) -C commands install

clean:
	$(MAKE) -C log_daemon clean
	$(MAKE) -C commands clean
