# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
#
# Makefile
#
# Version:	$Id$
#

include ../../Make.inc

RFC	= rfc2548.txt rfc2865.txt rfc2866.txt rfc2867.txt rfc2868.txt \
	  rfc2869.txt rfc3162.txt rfc3576.txt rfc3579.txt rfc3580.txt \
	  rfc4590.txt

all:

html: refs
	./rewrite.pl $(RFC)
	./per-rfc.pl $(RFC)
	@touch .rewrite

index.html: html
	./update.sh

refs: $(RFC)
	./genref.pl $(RFC) > refs
	@echo 'rfc2865 Class' >> refs
	@echo 'rfc2865 State' >> refs

clean:
	@rm -f refs *rfc*.html *~ .rewrite index.html

.PHONY: all clean html
