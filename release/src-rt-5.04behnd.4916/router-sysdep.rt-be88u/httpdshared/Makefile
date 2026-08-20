# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:

LIB = libhttpdshared.so

all:
	@cp -f prebuilt/$(LIB) .

install: generic_private_lib_install

clean:

dynamic: all install

include $(BUILD_DIR)/make.common
