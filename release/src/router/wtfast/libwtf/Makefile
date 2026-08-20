# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
STATIC_LIB_NAME = libwtf.a
STATIC_LIB_TARGET = src/.libs/$(STATIC_LIB_NAME)

TARGETS = $(STATIC_LIB_TARGET)

all: $(TARGETS)

clean:
	rm -f $(TARGETS) $(LIB_OBJS)

# asuswrt
include ../../common.mak
ifeq ($(RTCONFIG_BCMARM),y)
PREBUILT_ARCH := $(BCMEX)$(EX7)
endif
$(STATIC_LIB_TARGET): prebuilt$(PREBUILT_ARCH)/$(STATIC_LIB_NAME)
	mkdir -p $(dir $@)
	cp -f $< $@
