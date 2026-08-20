# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
# SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
include ../config.mk

TARGETS :=

ifeq ($(HAVE_MNL),y)
CFLAGS += -I./include/uapi/

RDMA_OBJ = rdma.o utils.o dev.o link.o res.o res-pd.o res-mr.o res-cq.o \
	   res-cmid.o res-qp.o sys.o stat.o stat-mr.o

TARGETS += rdma
endif

all:	$(TARGETS) $(LIBS)

rdma:	$(RDMA_OBJ) $(LIBS)
	$(QUIET_LINK)$(CC) $^ $(LDFLAGS) $(LDLIBS) -o $@

install: all
	for i in $(TARGETS); \
	do install -m 0755 $$i $(DESTDIR)$(SBINDIR); \
	done

clean:
	rm -f $(RDMA_OBJ) $(TARGETS)
