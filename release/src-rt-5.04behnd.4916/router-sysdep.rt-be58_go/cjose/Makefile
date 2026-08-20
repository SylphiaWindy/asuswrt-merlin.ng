# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
APP = cjose
VERSION = 0.6.2.1
APP_NAME = $(APP)-$(VERSION)

ifeq ($(strip $(DESKTOP_LINUX)), y)
BCM_BLT32_FLAGS = CFLAGS='$(BCM_LD_FLAGS)'
TOOLCHAIN_PREFIX = $(PROFILE_ARCH)-none-linux
endif

check_config: $(APP_NAME).tar.gz
	@if [ ! -e $(APP)/Makefile ]; then \
	    echo "Untarring original $(APP_NAME) source and configure"; \
		mkdir -p $(APP); \
		( cd $(APP); tar --strip-components=1 -xzf ../$(APP_NAME).tar.gz; \
		./configure --prefix=$(BCM_FSBUILD_DIR)/public --host=$(TOOLCHAIN_PREFIX) \
		$(BCM_BLT32_FLAGS) ); \
	fi

install: check_config
	make -C $(APP) install;

clean:
	-[ ! -e $(APP)/Makefile ] || make -C $(APP) uninstall
	rm -rf $(APP)

