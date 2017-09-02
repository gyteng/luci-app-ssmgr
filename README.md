# luci-app-ssmgr

## 编译

```
git clone https://github.com/gyteng/luci-app-ssmgr.git package/luci-app-ssmgr
pushd package/luci-app-ssmgr/tools/po2lmo
make && sudo make install
popd
# 选择要编译的包 LuCI -> 3. Applications -> luci-app-ssmgr
make menuconfig
# 开始编译
make package/luci-app-ssmgr/compile V=99
```

注意，运行的时候需要使用`curl`，如果网站用的是 https，还需要 curl 的 https 支持，编译的时候记得打包相应的东西。

## 截图

![screenshot0](https://github.com/gyteng/luci-app-ssmgr/raw/master/screenshots/screenshot0.png)

## 说明

本插件用于配合 [`shadowsocks-manager`](https://github.com/shadowsocks/shadowsocks-manager) 使用。

1. 在 `shadowsocks-manager` 里启动 macAccount 插件，详情请参考项目文档。

2. 给相应的用户添加账号，类型选“MAC地址”，并选择对应的端口和地址。

![screenshot1](https://github.com/gyteng/luci-app-ssmgr/raw/master/screenshots/screenshot1.png)

3. 在路由器上启用该插件。