-- Create a RAM widget giving the MB used by the RAM
require("precious.utils")

showraminfo = nil

local function dispinfo()
	local f, infos
	local capi = {
		mouse = mouse,
		screen = screen
	}

	f = io.popen("ps -e o comm,%mem --sort -rss | head -n 20")
	infos = f:read("*all")
	f:close()

	showraminfo = naughty.notify( {
		title	= "Memory consumption details",
		text	= infos,
		timeout	= 0,
		screen	= capi.mouse.screen })

end

function activeram()
	local memtot, memfree, membuf, memcached, memused, ramusg, ramusg_str, res

	-- using procfs
	for line in io.lines("/proc/meminfo") do
		for key , value in string.gmatch(line, "([%a]+):[%s]+([%d]+).+") do
			if key == "MemTotal" then
				memtot = math.floor(value/1024)
			elseif key == "MemFree" then
				memfree = math.floor(value/1024)
			elseif key == "Buffers" then
				membuf = math.floor(value/1024)
			elseif key == "Cached" then
				memcached = math.floor(value/1024)
			end
		end
	end

	memused = memtot - memfree - membuf - memcached

--[[
	--using sysfs
	for line in io.lines("/sys/devices/system/node/node0/meminfo") do
		for key , value in string.gmatch(line, "([%a]+):[%s]+([%d]+).+") do
			if key == "MemTotal" then
				memtot = math.floor(value/1024)
			elseif key == "Active" then
				memused = math.floor(value/1024)
			end
		end
	end
--]]

	ramusg = (memused / memtot) * 100
	ramusg_str = string.format("%.2f", ramusg)

	res = memused

	if ramusg < 51 then
		res = '<span color="green">' .. res .. '</span>MB (<span color="green">' .. ramusg_str .. '</span>%)'
	elseif	ramusg < 71 then
		res = '<span color="yellow">' .. res .. '</span>MB (<span color="yellow">' .. ramusg_str .. '</span>%)'
	elseif  ramusg < 86 then
		res = '<span color="orange">' .. res .. '</span>MB (<span color="orange">' .. ramusg_str .. '</span>%)'
	else
		res = '<span color="red">' .. res .. '</span>MB (<span color="red">' .. ramusg_str .. '</span>%)'
	end

	return res
end

meminfo = widget({ type = "textbox", name = "meminfo" })
meminfo:add_signal('mouse::enter', function () dispinfo() end)
meminfo:add_signal('mouse::leave', function () clearinfo(showraminfo) end)

-- Assign a hook to update info
meminfo_timer = timer({timeout = 1})
meminfo_timer:add_signal("timeout", function() meminfo.text = activeram() .. " | "  end)
meminfo_timer:start()
