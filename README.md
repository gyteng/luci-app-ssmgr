# luci-app-ssmgr

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
