# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
CFLAGS ?= -O3 -march=native
CFLAGS += -std=gnu99
CFLAGS += -Wall
CFLAGS += -MMD -MP

highlight: highlight.o highlighter.o

fuzz: CC := clang
fuzz: CFLAGS += -fsanitize=fuzzer
fuzz: fuzz.c highlighter.c

gui/Makefile: gui/highlight.pro
	cd gui && qmake
gui: gui/Makefile
	@$(MAKE) -C gui

clean:
	rm -f highlight fuzz *.o *.d
	@if [ -f gui/Makefile ]; then $(MAKE) -C gui distclean; fi

.PHONY: clean gui
.DEFAULT_GOAL: highlight
MAKEFLAGS += --no-print-directory

-include *.d
