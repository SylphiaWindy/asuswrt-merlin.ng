# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
asn1.pm: asn1.yp
	yapp -s asn1.yp

clean:
	rm -f asn1.pm
