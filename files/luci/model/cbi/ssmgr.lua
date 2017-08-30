local m, s, o

m = Map("ssmgr", translate("ssmgr"))

s = m:section(TypedSection, "ssmgr", translate("General Setting"))
s.anonymous   = true

o = s:option(Flag, "enable", translate("Enable"))
o.rmempty     = false

o = s:option(Value, "site", translate("Site"))
o.placeholder = "website"
o.default     = "https://wall.gyteng.com/"
o.datatype    = "string"
o.rmempty     = false

o = s:option(Value, "mac", translate("MAC address"))
o.placeholder = "mac"
o.default     = luci.sys.exec("ifconfig | grep 'eth0' | awk '{print $5}' | sed 's/\://g'")
o.datatype    = "string"
o.rmempty     = false
o.readonly    = true

o = s:option(Flag, "alloc", translate("Alloc by server"))
o.rmempty     = false

p = s:option(ListValue, "server", translate("Server"))
servers = uci.get("ssmgr", "default", "server_list")
for i,v in pairs(servers) do
	p:value(v, v)
end

p:depends("alloc", "0")

apply = luci.http.formvalue("cbi.apply")

if apply then
	site = uci.get("ssmgr", "default", "site")
	luci.sys.exec("sh /usr/share/autoGetAccount/cron.sh")
	luci.sys.exec("sh /usr/share/autoGetAccount/start.sh")
end

return m
