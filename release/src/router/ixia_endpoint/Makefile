# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
all:

install: all
	install -d $(INSTALLDIR)/bin
	install start_endpoint $(INSTALLDIR)/bin
	install endpoint $(INSTALLDIR)/bin
	install echr.msg $(INSTALLDIR)/bin
	install endpoint.ini $(INSTALLDIR)/bin

clean:
