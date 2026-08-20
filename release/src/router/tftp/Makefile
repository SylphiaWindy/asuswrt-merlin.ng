# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
CFLAGS = -Os -Wall $(EXTRACFLAGS)

all: tftpc tftpd

tftpc: tftpc.c
	$(CC) $(CFLAGS) -o tftpc tftpc.c

tftpd: tftpd.c
	$(CC) $(CFLAGS) -o tftpd tftpd.c

clean:
	rm -f tftpd tftpc

strip:
	strip tftpd tftpc

