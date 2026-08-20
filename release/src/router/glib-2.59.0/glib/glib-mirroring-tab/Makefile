# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:

CFLAGS = `pkg-config --cflags glib-2.0`
LIBS = `pkg-config --libs glib-2.0`


all: gen-mirroring-tab

gen-mirroring-tab: gen-mirroring-tab.o packtab.o

clean:
	$(RM) gen-mirroring-tab *.o
