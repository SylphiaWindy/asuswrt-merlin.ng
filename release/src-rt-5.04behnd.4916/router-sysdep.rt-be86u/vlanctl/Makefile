# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:

EXE = vlanctl

all:
	@cp -f prebuilt/$(EXE) .

install: generic_exe_install
	mkdir -p $(INSTALL_DIR)/bin
	install prebuilt/rawSocketTest $(INSTALL_DIR)/bin

clean:

dynamic: all install

include $(BUILD_DIR)/make.common
