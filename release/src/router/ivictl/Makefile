# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
CFLAGS = -s -Os -fomit-frame-pointer
CFLAGS += $(BRCM_WERROR_CFLAGS)

EXE = ivictl
OBJS = $(EXE).o

all dynamic install: conditional_build

clean:
	-rm -f $(EXE) *.o
	-rm -f $(INSTALL_DIR)/bin/$(EXE)

conditional_build: $(EXE)
	install -m 755 $(EXE) $(INSTALL_DIR)/bin
	$(STRIP) $(INSTALL_DIR)/bin/$(EXE)

ifeq ($(wildcard $(SRCBASE)/router/$(EXE)/*.c),)
$(EXE):
	-cp -f $(SRCBASE)/router/$(EXE)/prebuilt/$(EXE) $(EXE)
else
$(EXE): $(OBJS)
	$(CC) -o $@ $(OBJS)
endif


