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
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-ssmgr/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/usr/share/ssmgr
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n
	
	$(INSTALL_DATA) ./files/luci/model/cbi/ssmgr.lua $(1)/usr/lib/lua/luci/model/cbi/ssmgr.lua
	$(INSTALL_DATA) ./files/luci/controller/ssmgr.lua $(1)/usr/lib/lua/luci/controller/ssmgr.lua
	$(INSTALL_DATA) ./files/root/etc/config/ssmgr $(1)/etc/config/ssmgr
	$(INSTALL_BIN) ./files/root/usr/share/ssmgr/cron.sh $(1)/usr/share/ssmgr/cron.sh
	$(INSTALL_BIN) ./files/root/usr/share/ssmgr/JSON.sh $(1)/usr/share/ssmgr/JSON.sh
	$(INSTALL_BIN) ./files/root/usr/share/ssmgr/start.sh $(1)/usr/share/ssmgr/start.sh
	$(INSTALL_BIN) ./files/root/usr/share/ssmgr/apply.sh $(1)/usr/share/ssmgr/apply.sh
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/ssmgr.*.lmo $(1)/usr/lib/lua/luci/i18n/
endef

$(eval $(call BuildPackage,luci-app-ssmgr))