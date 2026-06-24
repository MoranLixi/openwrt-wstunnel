include $(TOPDIR)/rules.mk

PKG_NAME:=wstunnel
PKG_VERSION:=10.5.5
PKG_RELEASE:=1

# 不再需要 git 源码相关变量，改为直接下载预编译文件
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
# 注意：这里需要根据你的目标架构调整下载 URL，下面的示例是 x86_64
# 其他架构需要修改 PKG_SOURCE_URL 中的文件名
PKG_SOURCE_URL:=https://github.com/erebe/wstunnel/releases/download/v$(PKG_VERSION)/
PKG_HASH:=skip
PKG_MAINTAINER:=MoranLixi
PKG_LICENSE:=BSD 3-Clause License

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=WSTunnel Server
	DEPENDS:=+libc
	URL:=https://github.com/erebe/wstunnel
endef

define Package/$(PKG_NAME)/description
	WSTunnel is a tool for tunneling traffic over WebSocket.
endef

# 关键修改：下载预编译二进制文件
define Build/Prepare
    mkdir -p $(PKG_BUILD_DIR)
    # 下载 arm64 架构的 tar.gz 包
    wget -O $(PKG_BUILD_DIR)/wstunnel_$(PKG_VERSION)_linux_arm64.tar.gz \
        https://github.com/erebe/wstunnel/releases/download/v$(PKG_VERSION)/wstunnel_$(PKG_VERSION)_linux_arm64.tar.gz
    # 解压到构建目录，解压后通常得到一个名为 wstunnel 的二进制文件
    tar -xzf $(PKG_BUILD_DIR)/wstunnel_$(PKG_VERSION)_linux_arm64.tar.gz -C $(PKG_BUILD_DIR)/
    # 确保二进制文件有执行权限
    chmod +x $(PKG_BUILD_DIR)/wstunnel
endef

# 不需要 Build/Compile，因为我们已经下载了预编译的二进制文件
define Build/Compile
	# 空操作，不进行编译
endef

# 安装步骤保持不变
define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/wstunnel $(1)/usr/bin/
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/wstunnel $(1)/etc/init.d/
	
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/wstunnel $(1)/etc/config/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))