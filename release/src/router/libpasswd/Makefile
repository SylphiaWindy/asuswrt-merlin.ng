# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
include ../common.mak
include $(SRCBASE)/.config

CFLAGS += -Os -Wall $(EXTRACFLAGS) -fPIC
LDFLAGS += $(EXTRALDFLAGS) -lcrypt

INSTALL = install

OBJS = passwd.o

all: libpasswd.so

libpasswd.so: $(OBJS)
	@echo " [libpasswd] LD $@"
	@$(CC) $(LDFLAGS) -shared -o $@ $^


install: all
	@echo " [libpasswd] Installing as $(INSTALLDIR)/usr/lib/libpasswd.so"
	@install -d $(INSTALLDIR)/usr/lib
	@install -m 755 libpasswd.so $(INSTALLDIR)/usr/lib
	@$(STRIP) $(INSTALLDIR)/usr/lib/libpasswd.so

clean:
	rm -f *.o *.so *.a .*.depend *.prep

%.o: %.c .%.depend
	@echo " [libpasswd] CC $@"
	@$(CC) $(CFLAGS) -o $@ -c $<

%.o: prebuild/%.o
	@echo " [libpasswd] cp $@"
	@cp -f $< $@

.depend: $(OBJS:%.o=%.c)
	@$(CC) $(CFLAGS) -M $^ > .depend

.%.depend: %.c
	@$(CC) $(CFLAGS) -M $< > $@

%.prep: %.c
	@$(CC) $(CFLAGS) -E $< > $@

-include $(OBJS:%.o=.%.depend)

