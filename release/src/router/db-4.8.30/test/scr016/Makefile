# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:
TESTCLASSES=\
    ./src/com/sleepycat/db/test/*.java

all: dbtest.jar

dbtest.jar: classesdir
	# Compile the tests and build the test jar
	javac -classpath "${DB_JAR}${CP_SEP}${REQUIRED_JARS}" \
		-d ./classes ${TESTCLASSES}
	jar cf ./dbtest.jar -C ./classes ./com/sleepycat

classesdir:
	[ -d ./classes ] || (mkdir ./classes)

clean:
	[ -d ./classes ] && rm -rf ./classes
	[ -f ./dbtest.jar ] && rm ./dbtest.jar

