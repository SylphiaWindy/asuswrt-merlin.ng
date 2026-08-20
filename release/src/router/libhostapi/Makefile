# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
TARGET = libhostapi.so

all:
	-cp -f prebuilt/$(TARGET) $(TARGET)

clean:
	rm -f $(TARGET)
	rm -f $(INSTALLDIR)/lib/$(TARGET)

install: all
	mkdir -p $(INSTALLDIR)/lib
	install -D $(TARGET) $(INSTALLDIR)/lib/$(TARGET)
	$(STRIP) $(INSTALLDIR)/lib/$(TARGET)
