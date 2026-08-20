# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:

all: pkg

INSTROOT=`pwd`/tmp
PKGNAME=bonnie++

../Makefile:
	( cd .. ; ./configure --prefix=/usr --mandir=`pwd`/sun/tmp/usr/share/man )

pkg: ../Makefile
	make -C .. WFLAGS="-Wall -W -Wshadow -Wpointer-arith -Wwrite-strings"
	make -C .. prefix=${INSTROOT}/usr install
	pkgmk -o -r ${INSTROOT}
	pkgtrans -s spool ${PKGNAME}.pkg ${PKGNAME}
	@echo
	@echo "/var/spool/pkg/${PKGNAME}.pkg complete!"
	@echo
