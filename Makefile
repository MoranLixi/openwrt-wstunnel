include $(TOPDIR)/rules.mk

PKG_NAME:=wstunnel
PKG_VERSION:=10.5.5
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
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
endef

define Package/$(PKG_NAME)/description
	WSTunnel is a tool for tunneling traffic over WebSocket.
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	wget -O $(PKG_BUILD_DIR)/wstunnel_$(PKG_VERSION)_linux_arm64.tar.gz \
		https://github.com/erebe/wstunnel/releases/download/v$(PKG_VERSION)/wstunnel_$(PKG_VERSION)_linux_arm64.tar.gz
	tar -xzf $(PKG_BUILD_DIR)/wstunnel_$(PKG_VERSION)_linux_arm64.tar.gz -C $(PKG_BUILD_DIR)/
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