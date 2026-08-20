# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
all: LibicalWrap.so

LibicalWrap.so: LibicalWrap.o
	gcc -shared -L/usr/lib -rdynamic LibicalWrap.o ../libical/.libs/libical.a  ../libicalss/.libs/libicalss.a -o LibicalWrap.so 

LibicalWrap.o: LibicalWrap.c
	gcc -fpic -I/usr/include/php4/TSRM/ -I/usr/include/php4/ -I/usr/include/php4/Zend -I/usr/include/php4/main -c LibicalWrap.c -o LibicalWrap.o

LibicalWrap.c: LibicalWrap.i
	swig -php -o LibicalWrap.c LibicalWrap.i 

clean:
	rm LibicalWrap.so LibicalWrap.o LibicalWrap.c
