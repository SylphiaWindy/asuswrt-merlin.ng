# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:

EXE := blogctl

FINAL_EXE_INSTALL_DIR := $(INSTALL_DIR)/bin

all:
	@cp -f prebuilt/$(EXE) .

install: all
#	mkdir -p $(EXE_INSTALL_DIR)
#	install -p -m 755 -t $(EXE_INSTALL_DIR) $(EXE)
	mkdir -p $(INSTALLDIR)/bin
	install -p -m 755 -t $(FINAL_EXE_INSTALL_DIR) $(EXE)
	(cd $(FINAL_EXE_INSTALL_DIR); ln -sf $(EXE) blog)

clean:
	rm -f *.o *.d $(EXE)
	rm -f $(EXE_INSTALL_DIR)/$(EXE)
