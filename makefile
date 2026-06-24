include $(TOPDIR)/rules.mk

PKG_NAME:=wstunnel
PKG_VERSION:=10.5.5
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/erebe/wstunnel.git
PKG_SOURCE_VERSION:=v$(PKG_VERSION)
PKG_MIRROR_HASH:=<请计算或忽略>

PKG_MAINTAINER:=你的名字
PKG_LICENSE:=MIT # 假设的许可证，请按实际修改

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
	SECTION:=net
	CATEGORY:=Network
	TITLE:=WSTunnel client
	DEPENDS:=+libc
	URL:=https://github.com/erebe/wstunnel
endef

define Package/$(PKG_NAME)/description
	WSTunnel is a tool for tunneling traffic over WebSocket.
endef

# 关键步骤：安装二进制文件、启动脚本和配置文件
define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/wstunnel $(1)/usr/bin/
	
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/etc/init.d/wstunnel $(1)/etc/init.d/
	
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/etc/config/wstunnel $(1)/etc/config/
endef

$(eval $(call BuildPackage,$(PKG_NAME)))