# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
CFLAGS?= -O2 -Wall -W

all: dhcp_release dhcp_release6 dhcp_lease_time

clean:
	rm -f *~ *.o core dhcp_release dhcp_release6 dhcp_lease_time
