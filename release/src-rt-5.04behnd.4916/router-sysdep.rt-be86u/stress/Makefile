# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:

EXE = stress

all:
	@cp -f prebuilt/$(EXE) .

install: generic_exe_install
	rm -f $(INSTALL_DIR)/opt/scripts/stress-xdslupdown.sh
	rm -f $(INSTALL_DIR)/opt/scripts/stress-proc.sh
	rm -f $(INSTALL_DIR)/opt/scripts/stress-fs.sh
	rm -f $(INSTALL_DIR)/opt/scripts/stress-fs-flist.txt
	-rm -rf $(INSTALL_DIR)/opt
	-mkdir -p $(INSTALL_DIR)/opt/scripts
	install -m 755 scripts/stress-xdslupdown.sh $(INSTALL_DIR)/opt/scripts
	install -m 755 scripts/stress-proc.sh $(INSTALL_DIR)/opt/scripts
	install -m 755 scripts/stress-fs.sh $(INSTALL_DIR)/opt/scripts
	install -m 755 scripts/stress-fs-flist.txt $(INSTALL_DIR)/opt/scripts

clean:

dynamic: all install

include $(BUILD_DIR)/make.common
