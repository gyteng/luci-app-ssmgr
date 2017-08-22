module("luci.controller.ssmgr", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/ssmgr") then
		return
	end

	entry({"admin", "services", "ssmgr"}, cbi("ssmgr"), _("ssmgr"), 90).dependent = true
end
