# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
LIB = libgen_util.so


all:
	@cp -f prebuilt/$(LIB) .

install:
	mkdir -p $(INSTALL_DIR)/lib$(BCM_INSTALL_SUFFIX_DIR)
	install -m 755 $(LIB) $(INSTALL_DIR)/lib$(BCM_INSTALL_SUFFIX_DIR)
	mkdir -p $(BCM_FSBUILD_DIR)/private/lib$(BCM_INSTALL_SUFFIX_DIR)
	install -m 755 $(LIB) $(BCM_FSBUILD_DIR)/private/lib$(BCM_INSTALL_SUFFIX_DIR)

clean:

dynamic: all install

