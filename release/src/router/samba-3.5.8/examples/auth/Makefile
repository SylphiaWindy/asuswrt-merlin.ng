# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
# Makefile for samba-pdb examples
# Variables

CC = gcc
LIBTOOL = libtool

SAMBA_SRC = ../../source
SAMBA_INCL = ../../source/include
UBIQX_SRC = ../../source/ubiqx
SMBWR_SRC = ../../source/smbwrapper
CFLAGS = -I$(SAMBA_SRC) -I$(SAMBA_INCL) -I$(UBIQX_SRC) -I$(SMBWR_SRC) -Wall -g
AUTH_OBJS = auth_skel.la

# Default target

default: $(AUTH_OBJS)

# Pattern rules

%.la: %.lo
	$(LIBTOOL) --mode=link $(CC) -module -o $@ $< $(LDFLAGS)

%.lo: %.c
	$(LIBTOOL) --mode=compile $(CC) $(CPPFLAGS) $(CFLAGS) -c $<

# Misc targets

clean:
	rm -rf .libs
	rm -f core *~ *% *.bak \
		$(AUTH_OBJS) $(AUTH_OBJS:.la=.o) $(AUTH_OBJS:.la=.lo) 
