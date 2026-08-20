# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:


ASM1042_DIR = $(INSTALLDIR)/asm1042
ASM1042_TOOL= 104xfwdl
ASM1042_BIN = 130125_00_02_00.bin


all clean:

install: $(ASM1042_TOOL) $(ASM1042_BIN)
	@install -d $(ASM1042_DIR)
	@install -m 755 $(ASM1042_TOOL) $(ASM1042_DIR)
	@$(STRIP) $(ASM1042_DIR)/$(ASM1042_TOOL)
	@install $(ASM1042_BIN) $(ASM1042_DIR)

.PHONY: all clean install
