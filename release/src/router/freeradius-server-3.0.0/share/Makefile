# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
#
#	Scripts to format dictionary files.
#
#	$Id$
#
.PHONY: format

#
#  This should only be run by hand, and then sanity checked by hand!
#
format: dictionary*
	@for x in dictionary* ; do \
		cat $$x | ./format.pl > tmp; \
		mv tmp $$x; \
	done
