# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:

all:
	@echo "nmake targets:"
	@echo "   clean"
	@echo "   simple"
	@echo "   tcp"

clean:
	@call nmake /f Makefile.simple /A /NOLOGO clean
	@call nmake /f Makefile.tcp /A /NOLOGO clean

simple:
	@call nmake /f Makefile.simple /A /NOLOGO all

tcp:
	@call nmake /f Makefile.tcp /A /NOLOGO all
