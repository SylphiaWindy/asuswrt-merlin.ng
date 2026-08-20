# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
BOOST_PYTHON_LIB = -L/usr/local/boost_1_29_0/lib -lboost_python
BOOST_INCLUDES = -I/usr/local/boost_1_29_0/src
dynmoddir = `pwd`/local

CXX = g++
CXXFLAGS := -O2 -Wall
CPPFLAGS := -I/usr/include/python2.2

LIBTOOL = $(SHELL) ./libtool
LIBCXX = $(LIBTOOL) --tag=CXX --mode=compile $(CXX)
LINKCXX = $(LIBTOOL) --tag=CXX --mode=link $(CXX)
LINKCXXLIB = $(LINKCXX) -rpath $(dynmoddir)
LINKCXXMODULE = $(LINKCXXLIB) -module -avoid-version
LIBINSTALL = $(LIBTOOL) --mode=install /bin/install -c -p
INSTALL = /bin/install -c -p

TARGET = exif.la

OBJS = \
    exif_module.lo

all: $(TARGET)

install: $(TARGET)
	$(INSTALL) -d $(dynmoddir)
	$(LIBINSTALL) $(TARGET) $(dynmoddir)

$(TARGET): $(OBJS)
	$(LINKCXXMODULE) -o $(TARGET) $(OBJS) $(BOOST_PYTHON_LIB) -lexif

clean::
	rm -rf .libs *.o *.so *.lo *.ld $(TARGET)

%.o: %.cxx
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c $*.cxx

%.lo: %.cxx
	$(LIBCXX) $(CXXFLAGS) $(CPPFLAGS) -c $*.cxx

%.d: %.cxx
	@echo updating header dependencies for $*.cxx
	@rm -f $*.d
	@$(CXX) -M $(CXXFLAGS) $(CPPFLAGS) -c $*.cxx | sed "s@$*.o@$*.d $*.o@" > $*.d \
        || { rm -f $*.d; exit 1; }

%.ld: %.cxx
	@echo updating header dependencies for $*.cxx
	@rm -f $*.ld
	@$(CXX) -M $(CXXFLAGS) $(CPPFLAGS) -c $*.cxx | sed "s@$*.o@$*.ld $*.lo@" > $*.ld \
        || { rm -f $*.ld; exit 1; }

ifneq "$(MAKECMDGOALS)" "clean"
include $(patsubst %.lo, %.ld, $(OBJS))
endif
