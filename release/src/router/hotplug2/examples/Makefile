# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
# vim:set sw=8 nosta:

BINS=
SUBDIRS=

KERNELVER ?= `uname -r`

all:

install:
	$(INSTALL_DIR) $(PREFIX)/etc
	case "$(KERNELVER)" in \
		2.4.*) \
		$(INSTALL) hotplug2.rules-2.4kernel $(PREFIX)/etc/hotplug2.rules \
		;; \
		*) \
		$(INSTALL) hotplug2.rules-2.6kernel $(PREFIX)/etc/hotplug2.rules \
		;; \
	esac
	# remove comments, compress whitespace
	@sed -i 's/#.*//g;s/[ \t]\+/ /g;s/^[ \t]*//;s/[ \t]*$$//;/^$$/d' $(PREFIX)/etc/hotplug2.rules

include ../common.mak
MAKEDEP:=
