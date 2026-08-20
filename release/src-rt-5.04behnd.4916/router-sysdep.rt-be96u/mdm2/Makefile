# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
LIB := libmdm2.so

SAVED := $(LIB)_$(ARCH).shipped

all: $(LIB)


# Set VPATH so we can compile in a seperate dir than source.
name := $(lastword $(MAKEFILE_LIST))
mdir := $(realpath $(dir $(name)))
VPATH=$(mdir)


ifneq ($(wildcard $(mdir)/Makefile.fullsrc),)

include $(mdir)/Makefile.fullsrc

else

$(LIB): $(SAVED)
	cat $< > $@

save_binaries:

delete_source:

endif


install: all
	mkdir -p $(LIB_INSTALL_DIR)
	install -p -m 755 -t $(LIB_INSTALL_DIR) $(LIB)


clean:
	rm -f *.d *.o $(LIB)
	rm -f $(LIB_INSTALL_DIR)/$(LIB)
