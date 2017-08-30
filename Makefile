include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-ssmgr
PKG_VERSION=1.0.0
PKG_RELEASE:=1

PKG_LICENSE:=GPLv3
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Gyteng <igyteng@gmail.com>

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-ssmgr
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=LuCI Support for shadowsocks-manager
	PKGARCH:=all
endef

define Package/luci-app-ssmgr/description
	This package contains LuCI configuration pages for shadowsocks-manager.
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/files/luci/i18n/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
	#!/bin/sh
	chmod +x ./files/root/usr/share/autoGetAccount/*.sh
	exit 0
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-ssmgr/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/usr/share/autoGetAccount
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	
	$(INSTALL_DATA) ./files/luci/model/cbi/ssmgr.lua $(1)/usr/lib/lua/luci/model/cbi/ssmgr.lua
	$(INSTALL_DATA) ./files/luci/controller/ssmgr.lua $(1)/usr/lib/lua/luci/controller/ssmgr.lua
	$(INSTALL_DATA) ./files/root/etc/config/ssmgr $(1)/etc/config/ssmgr
	$(INSTALL_DATA) ./files/root/usr/share/autoGetAccount/cron.sh $(1)/usr/share/autoGetAccount/cron.sh
	$(INSTALL_DATA) ./files/root/usr/share/autoGetAccount/JSON.sh $(1)/usr/share/autoGetAccount/JSON.sh
	$(INSTALL_DATA) ./files/root/usr/share/autoGetAccount/start.sh $(1)/usr/share/autoGetAccount/start.sh
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/ssmgr.*.lmo $(1)/usr/lib/lua/luci/i18n/
endef

$(eval $(call BuildPackage,luci-app-ssmgr))