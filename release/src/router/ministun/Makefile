# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
CCFLAGS+=-Os -Wall -I. -Wno-pointer-sign -fomit-frame-pointer $(EXTRACFLAGS)
LDFLAGS+=-s
LIBS=

PACKAGE=ministun
OBJS=$(PACKAGE).o

all: $(PACKAGE)

$(PACKAGE): $(PACKAGE).o $(LIBS)
	$(CC) $(CCFLAGS) $(LDFLAGS) $(OBJS) -o $(PACKAGE) $(LIBS)

%.o: %.c %.h
	$(CC) $(CCFLAGS) -c $<

install: all
	$(STRIP) $(PACKAGE)
	install -D $(PACKAGE) $(INSTALLDIR)/usr/sbin/$(PACKAGE)

clean:
	rm -f *.o $(PACKAGE)
