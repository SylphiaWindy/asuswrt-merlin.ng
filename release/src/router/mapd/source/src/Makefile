# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
SUBDIRS=dot11_if clientDB clientMon channelMon apEstimator ApRoamAlgo steerAction utils dot11_if 1905_if topologySrv apSelection ch_planning networkoptimization mapfilter_if

all:
	for d in $(SUBDIRS); do [ -d $$d ] && $(MAKE) -C $$d; done

clean:
	for d in $(SUBDIRS); do [ -d $$d ] && $(MAKE) -C $$d clean; done
	rm -f *~ *.o *.d

install:
	for d in $(SUBDIRS); do [ -d $$d ] && $(MAKE) -C $$d install; done

