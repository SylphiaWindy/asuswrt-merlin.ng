# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
# SPDX-License-Identifier: GPL-2.0
MAN7PAGES = $(wildcard *.7)

all:

distclean: clean

clean:

install:
	$(INSTALLDIR) $(DESTDIR)$(MANDIR)/man7
	$(INSTALLMAN) $(MAN7PAGES) $(DESTDIR)$(MANDIR)/man7

check:
	@for page in $(MAN7PAGES); do test 0 -eq $$($(MAN_CHECK) $$page \
		$(MAN_REDIRECT)) || { echo "Error in $$page"; exit 1; }; done

.PHONY: install clean distclean check
