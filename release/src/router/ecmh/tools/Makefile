# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
# /**************************************
#  ecmh - Easy Cast du Multi Hub
#  by Jeroen Massar <jeroen@unfix.org>
# ***************************************
# $Author: fuzzel $
# $Id: Makefile,v 1.1 2004/02/19 14:22:54 fuzzel Exp $
# $Date: 2004/02/19 14:22:54 $
# **************************************/
#
# Tools Makefile
#

all:	mtrace6

mtrace6: mtrace6/
	$(MAKE) -C mtrace6 all

clean:
	$(MAKE) -C mtrace6 clean

# Mark targets as phony
.PHONY : all clean mtrace6

