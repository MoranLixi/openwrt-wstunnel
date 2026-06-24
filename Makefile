include $(TOPDIR)/rules.mk

PKG_NAME:=wstunnel
PKG_VERSION:=10.5.5
PKG_RELEASE:=1

# 直接指定正确的文件名
PKG_SOURCE:=wstunnel_$(PKG_VERSION)_linux_arm64.tar.gz
PKG_SOURCE_URL:=https://github.com/erebe/wstunnel/releases/download/v$(PKG_VERSION)/
PKG_HASH:=skip

PKG_MAINTAINER:=MoranLixi
PKG_LICENSE:=BSD-3-Clause

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=WSTunnel Server
	DEPENDS:=+libc
	URL:=https://github.com/erebe/wstunnel
	PKGARCH:=aarch64_cortex-a53          # 强制指定为你路由器的架构
endef

define Package/$(PKG_NAME)/description
	WSTunnel is a tool for tunneling traffic over WebSocket.
endef

# 由于 OpenWrt 会自动下载和解压，Build/Prepare 可以简化
define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	tar -xzf $(DL_DIR)/$(PKG_SOURCE) -C $(PKG_BUILD_DIR)/
	chmod +x $(PKG_BUILD_DIR)/wstunnel
endef

define Build/Compile
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/wstunnel $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/wstunnel $(1)/etc/init.d/
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/wstunnel $(1)/etc/config/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))