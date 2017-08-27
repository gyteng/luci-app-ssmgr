local m, s, o

if luci.sys.call("pidof ssmgr > /dev/null") == 0 then
	m = Map("ssmgr", translate("ssmgr"), "%s - %s" %{translate("ssmgr"), translate("RUNNING")})
else
	m = Map("ssmgr", translate("ssmgr"), "%s - %s" %{translate("ssmgr"), translate("NOT RUNNING")})
end

s = m:section(TypedSection, "ssmgr", translate("General Setting"))
s.anonymous   = true

o = s:option(Flag, "enable", translate("Enable"))
o.rmempty     = false

o = s:option(Value, "site", translate("Site"))
o.placeholder = "website"
o.default     = "https://wall.gyteng.com/"
o.datatype    = "string"
o.rmempty     = false

o = s:option(Flag, "alloc", translate("Alloc by server"))
o.rmempty     = false

apply = luci.http.formvalue("cbi.apply")

if apply then
	site = uci.get("ssmgr", "default", "site")
	luci.sys.exec("echo "..site.." > /usr/share/autoGetAccount/website.txt")
	luci.sys.exec("sh /usr/share/autoGetAccount/cron.sh")
	luci.sys.exec("sh /usr/share/autoGetAccount/start.sh")
end

return m
