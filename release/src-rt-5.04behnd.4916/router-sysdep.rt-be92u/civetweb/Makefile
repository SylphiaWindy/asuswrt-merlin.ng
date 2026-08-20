# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
SRC := civetweb

LIB_DIR := civetweb
PREFIX := $(BCM_FSBUILD_DIR)/public
HEADER_INSTALL_DIR := $(BCM_FSBUILD_DIR)/public/include

install:
	cd $(LIB_DIR) ; $(MAKE) lib && $(MAKE) install-lib PREFIX=$(PREFIX)
	cp -d $(LIB_DIR)/include/civetweb.h $(HEADER_INSTALL_DIR)

clean:
	cd $(SRC)
	rm -f *so*
	rm -f *.a
