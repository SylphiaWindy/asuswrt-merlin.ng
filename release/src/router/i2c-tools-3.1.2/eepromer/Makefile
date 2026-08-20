# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
#eepromer  Makefile

CFLAGS = -O2 -I../include -Wall

all:  eepromer eeprom eeprog

eepromer:  eepromer.o

eeprom:  eeprom.o

eeprog: eeprog.o 24cXX.o

clean:
	rm -rf *~ *.o eepromer eeprom eeprog
