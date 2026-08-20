# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
DISTGEN = maketable normal pareto paretonormal
DISTDATA = normal.dist pareto.dist paretonormal.dist experimental.dist

HOSTCC ?= $(CC)
CCOPTS  = $(CBUILD_CFLAGS)
LDLIBS += -lm 

all: $(DISTGEN) $(DISTDATA)

$(DISTGEN):
	$(HOSTCC) $(CCOPTS) -I../include -o $@ $@.c -lm

%.dist: %
	./$* > $@

experimental.dist: maketable experimental.dat
	./maketable experimental.dat > experimental.dist

stats: stats.c
	$(HOSTCC) $(CCOPTS) -I../include -o $@ $@.c -lm

install: all
	mkdir -p $(DESTDIR)$(LIBDIR)/tc
	for i in $(DISTDATA); \
	do install -m 644 $$i $(DESTDIR)$(LIBDIR)/tc; \
	done

clean:
	rm -f $(DISTDATA) $(DISTGEN)
