# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
SUBDIRS := $(filter-out Makefile,$(wildcard *))
.PHONY: all configure clean distclean show $(SUBDIRS)

all: configure
	@for dir in $(SUBDIRS); do \
		echo "Entering $$dir" && cd $$dir && $(MAKE) && cd ..; \
	done

link:
	@if [ ! -L iproute2-this ]; then \
		ln -s ../.. iproute2-this; \
	fi

configure: link
	@for dir in $(SUBDIRS); do \
		echo "Entering $$dir" && cd $$dir && if [ -f configure ]; then ./configure; fi && cd ..; \
	done

clean: link
	@for dir in $(SUBDIRS); do \
		echo "Entering $$dir" && cd $$dir && $(MAKE) clean && cd ..; \
	done

distclean: clean
	@for dir in $(SUBDIRS); do \
		echo "Entering $$dir" && cd $$dir && $(MAKE) distclean && cd ..; \
	done

show: link
	@echo "$(SUBDIRS)"

$(SUBDIRS):
	cd $@ && $(MAKE)
