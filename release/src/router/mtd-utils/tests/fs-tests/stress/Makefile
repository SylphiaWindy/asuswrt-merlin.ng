# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:

SUBDIRS = atoms

all tests: $(SUBDIRS)

clean: $(SUBDIRS)
	rm -rf run_pdf_test_file_*

.PHONY: $(SUBDIRS)
$(SUBDIRS):
	$(MAKE) -C $@ $(MAKECMDGOALS)
