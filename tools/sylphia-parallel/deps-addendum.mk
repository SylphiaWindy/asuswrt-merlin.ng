# ===== 补上游未表达的依赖 =====

# (a) 递归 libwebapi-dep
libwebapi/stamp-h1: json-c bwdpi_source
# (b) configure 报 Package requirements (libmnl) were not met
libnetfilter_cttimeout-1.0.0/Makefile: libmnl-1.0.4 libnfnetlink-1.0.1
# (b) configure 报 No package 'libmnl' found
ethtool-6.2/Makefile: libmnl-1.0.4
# (b) 上游零声明；coovachilli 走 RADIUS/TLS 需要 openssl
coovachilli/Makefile: openssl

# 共 4 条
