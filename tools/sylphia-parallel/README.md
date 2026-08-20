# sylphia-parallel — 并行构建的工具与依赖数据

这些脚本产出了 `be88u-parallel-build` 分支上那两个 commit 的内容。
**日常构建不需要它们** —— 分支已自足，直接：

```sh
make -j24 --output-sync=target rt-be88u
```

`--output-sync=target` 必须带。不带的话并发 configure 的输出会交错，
报错无法归因（上游在 `release/src/userspace/Makefile:8` 把这行注释掉了）。

## 什么时候需要这些工具

**把改动搬到新版上游时。** 依赖数据是绑定源码版本的（当前：`3006.102.8_2`），
换版本后要重新生成。

## 目录内容

### 打补丁（重新套到新上游）

| 脚本 | 作用 |
| --- | --- |
| `apply-patch.py <router/Makefile>` | 顺序声明 + `-include deps.mk` + per-package 锁 + `clean-build` 空操作 + net-snmp `-j1` |
| `patch-build-mk.py <build/Makefile>` | `userspace: \| kernelbuild` |
| `patch-nonidem.py <release/src-rt-*>` | coovachilli 的 `patch` 步骤改幂等 |
| `patch-sysdep.py <release/src-rt-*> <repo>` | 给 git 跟踪的手写 Makefile 加 `.NOTPARALLEL` |

`patch-sysdep.py` **必须用二进制模式读写** —— 树里有 4 个 Makefile 是 CRLF
（`lltdc`、`libpasswd`、`lltdc/src`、`lldt/src`），文本模式会把行尾改掉，
把 3 行的 diff 撑成 51 行。

### 生成 `release/src/router/deps.mk`

```sh
# 1. 从 make 自己导出展开后的依赖数据库（关键：不要去解析 Makefile 文本）
docker run --rm -v <tree>:/build asus-merlin-builder:local bash -lc \
  'source ~/envs/bcm-hnd-ax-4.19be.sh && cd /build/release/src-rt-5.04behnd.4916/router \
   && make -pn 2>/dev/null | sed -n "/^# Files/,/^# Finished/p"' > make-db.txt

# 2. 生成各部分
python3 gen-from-db.py   make-db.txt deps-db.mk          # 上游已声明的依赖 → configure 目标
python3 gen-addendum.py  <router/Makefile> make-db.txt deps-addendum.mk
python3 gen-baselib.py   make-db.txt baselib-users.tsv deps-baselib.mk
python3 gen-linkdeps.py  <串行构建日志> <router 目录> make-db.txt deps-link.mk

# 3. 拼成 deps.mk（deps-manual-fix.mk 是手工补的，见文件内注释）
cat deps-db.mk deps-addendum.mk deps-baselib.mk deps-link.mk deps-manual-fix.mk \
  > <tree>/release/src/router/deps.mk
```

`deps-manual-fix.mk` 里每条边都注明了为什么提取器抓不到（经 CMake、经 libtool、
在 `bcmdrivers` 深处经 Broadcom 自己的 `build.rules` 等）。

### 构建与监控

| 脚本 | 作用 |
| --- | --- |
| `parbuild.sh <jobs>` | 干净 clone → 打补丁 → 构建 → 挂看门狗（用于**未提交**改动的树） |
| `build-be88u.sh <ref> [jobs]` | 串行一键构建（`KEEP_TREE=1` 增量） |
| `watchdog.sh <容器> <日志> <输出>` | **五重护栏**：超时 90 分 / 日志 40 万行 / **make 递归深度 40** / 宿主负载 200 / CPU 停滞 |
| `cpusample.sh <容器> <tsv>` | 每 15 秒记 CPU，用于算并行度分布 |

看门狗的多指标不是过度设计。实测踩过一次无限递归：make 递归 1435 层、
openssl 重建 4511 次、宿主负载 657、OOM 把 `syslog` 与 `kern.log` 各刷到 72 GB、
跑了 383 分钟没被拦住 —— 因为当时只检测「CPU 低」，而失控是 **CPU 1187%**。
（清那种日志要用 `truncate` 而非 `rm`，rsyslog 持有句柄。）

### 验收

```sh
compare-fs.sh <树A> <树B> [输出前缀]
```

逐文件比对 `targets/<profile>/fs.install`，按内容哈希、忽略时间戳。

**基线**：两次独立串行构建产出 3411 个文件、集合完全一致、仅 12 个内容不同
（`busybox`/`libcrypto.so.1.1`/`libshared.so`/`lighttpd`/`socat`/`stubby`/`motd`
等嵌构建时间戳的二进制）。判据因此是硬的：并行产物的文件集合必须一致、
内容差异不超出那 12 个。

比解包 `.pkgtb` 比 md5 靠谱得多 —— 镜像级 md5 每次都不同。

### archive/

不再用于日常构建，但记录了「依赖是怎么测出来的」：`depcapture.sh` 做插桩构建
（宿主 inotify 盯三个 staging 目录 + `docker logs --timestamps`），
`depgraph*.py` 按包活跃时间窗把文件读写归因到包。

**这条路后来被证明是弯路** —— 对上游已声明依赖的包，它没有添加任何新信息；
只在上游零声明处（3 条）有价值。而且 pkg-config / linker 会扫描整个 staging 的
`lib/`、`pkgconfig/`，把所有 `.pc`/`.so` 都 open 一遍，产生大量假阳性、制造了 6 个环。
**先用 `make -pn` 拿依赖图**，别先搭插桩。

## 已知粗糙处

脚本里的路径硬编码到构建机的 `/data/...`（`parbuild.sh`、`compare-fs.sh`
以及 README 里的示例）。当时是为了尽快跑通、没做参数化。改的时候注意
这些脚本是逐轮验证过的，动之前先跑一遍 `compare-fs.sh` 对照。
