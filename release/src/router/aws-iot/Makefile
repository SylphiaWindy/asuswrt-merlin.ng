# 自建：该 Makefile 是手写的、不是 -j 安全的，却继承顶层 -j24。
# 包内串行，包间并行不受影响。
.NOTPARALLEL:

AWSIOT_DIR = ./src
AWSIOT_IPC_DIR = ./src/ipc

all:
	$(MAKE) -C $(AWSIOT_DIR)
	$(MAKE) -C $(AWSIOT_IPC_DIR)

clean:
	$(MAKE) -C $(AWSIOT_DIR) clean
	$(MAKE) -C $(AWSIOT_IPC_DIR) clean