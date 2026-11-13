# wstunnel for OpenWrt (aarch64)

为 OpenWrt 打包的 wstunnel 服务端 IPK，目标架构 aarch64_cortex-a53。

本仓库通过 GitHub Actions 自动跟踪上游 erebe/wstunnel 的最新 Release，自动更新版本号、编译 IPK 并发布到 Releases。

## 特性

- 基于 OpenWrt 23.05.5 SDK 编译，aarch64_cortex-a53 架构
- 提供 procd 风格的 init.d 启动脚本（/etc/init.d/wstunnel）
- 提供 UCI 配置文件（/etc/config/wstunnel）
- CI 每天检查上游版本，有新版本时自动更新 PKG_VERSION 并重新编译发布
- 也可手动触发编译

## 目录结构

```text
.
├── Makefile
├── files/
│   └── etc/
│       ├── config/
│       │   └── wstunnel
│       └── init.d/
│           └── wstunnel
└── .github/
    └── workflows/
        └── build.yml
```

## 安装

1. 打开本仓库的 Releases 页面。
2. 下载最新的 wstunnel_*_aarch64_cortex-a53.ipk。
3. 上传到路由器并安装：
```
scp wstunnel_*.ipk root@192.168.1.1:/tmp/
ssh root@192.168.1.1
opkg install /tmp/wstunnel_*.ipk
```
## 配置

配置文件位于 /etc/config/wstunnel：
```
config wstunnel 'server'
    option enabled '1'
    option listen_addr 'wss://0.0.0.0:443'
    option secret 'secret'
    option restrict_to 'localhost:51820'
    option log_level 'INFO'
    # option tls_certificate '/etc/wstunnel/server.crt'
    # option tls_private_key '/etc/wstunnel/server.key'
```
修改后重启服务：
```
/etc/init.d/wstunnel restart
```
查看日志：
```
logread -e wstunnel
```
## 服务管理
```
/etc/init.d/wstunnel start
/etc/init.d/wstunnel stop
/etc/init.d/wstunnel restart
/etc/init.d/wstunnel enable
/etc/init.d/wstunnel disable
```
## 自动编译与发布

- push 到 main/master：立即编译并发布
- 每天 06:00 (UTC) 定时检查上游最新 tag，有变化则自动更新并编译发布
- 手动触发：Actions 页面 Run workflow

发布时以 v<版本号> 作为 tag 创建 GitHub Release，并附带编译好的 IPK。

## 手动编译

在 GitHub Actions 中：Actions  Build OpenWrt IPK for wstunnel (aarch64)  Run workflow。

本地编译需要 Linux 环境和 OpenWrt SDK：
```
wget https://downloads.openwrt.org/releases/23.05.5/targets/sunxi/cortexa53/openwrt-sdk-23.05.5-sunxi-cortexa53_gcc-12.3.0_musl.Linux-x86_64.tar.xz
mkdir sdk && tar -xJf openwrt-sdk-*.tar.xz -C sdk --strip-components=1
mkdir -p sdk/package/wstunnel
cp Makefile sdk/package/wstunnel/
cp -r files sdk/package/wstunnel/
cd sdk
./scripts/feeds update -a
./scripts/feeds install -a
make defconfig
make package/wstunnel/compile V=99
```
生成的 IPK 位于 sdk/bin/packages/*/*/wstunnel*.ipk。

## 注意事项

- 本包使用上游预编译的 linux_arm64 二进制，PKG_HASH 当前为 skip。
- 默认监听 wss://0.0.0.0:443，需要开放对应端口。
- secret 会作为 WebSocket 升级路径前缀，请务必修改为强随机值。

## 相关链接

- 上游项目：https://github.com/erebe/wstunnel
- 上游文档：https://github.com/erebe/wstunnel#readme
- OpenWrt：https://openwrt.org/

## License

本仓库的打包脚本和配置文件遵循 BSD-3-Clause；wstunnel 本身遵循其上游许可证（BSD-3-Clause）。
