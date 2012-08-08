-- Battery status widget
-- This widget is especially written for thinkpad computers
-- NOTE: needs the "tp_smapi" module loaded (and installed)
-- NOTE: currently not finished!! do not use yet.

local tmp, bat0_present, bat1_present

local path = "/sys/devices/platform/smapi/"
local bat0 = path .. "BAT0"
local bat1 = path .. "BAT1"

-- retrieve needed informations
tmp = readfile(path .. bat0, "*number")
bat0_present = ((tmp == 1) and true or false)
tmp = readfile(path .. bat1, "*number")
bat1_present = ((tmp == 1) and true or false)

showbatinfos = nil
lock = false
pluglock = false

function readfile(path, mode)
	local f, ret

	f = assert(io.open(path, "r"))
	ret = f:read(mode)
	f:close()

	return ret
end

function clearinfo()
	if showbatinfos ~= nil then
		naughty.destroy(showbatinfos)
		showbatinfos = nil
	end
end

function dispinfo(path)
	local f, infos, status, present, brand, model, techno, serial, cycles, voltmin
	local voltnow, chfd, chf, uptime, tmp, up_h, up_m, up_s, upbat_h, upbat_m, upbat
	local capi = {
		mouse = mouse,
		screen = screen
	}

	-- do not try to do something if there is no battery...
	present = readfile(path .. "present", "*number")
	if (present == 0) then
		return
	end

	-- get and calculate uptime
	for tmp in string.gmatch(readfile("/proc/uptime", "*all"), "([%d]+).") do
		up_h = math.floor(tmp / 3600)
		up_m = string.format("%02d", (tmp % 3600) / 60)
		up_s = tmp
		break
	end
	if (up_h > 0) then
		uptime = up_h .. "h" .. up_m
	else
		if (up_m < "10") then
			up_m = string.format("%01d", up_m)
		end
		uptime = up_m .. "mn"
	end

	status	= readfile(path .. "status", "*all")
	brand	= readfile(path .. "manufacturer", "*all")
	model	= readfile(path .. "model_name", "*all")
	techno	= readfile(path .. "technology", "*all")
	serial	= readfile(path .."serial_number", "*all")
	cycles	= readfile(path .. "cycle_count", "*all")
	voltmin	= readfile(path .. "voltage_min_design", "*number")
	voltnow	= readfile(path .. "voltage_now", "*number")

	f = io.open(path .. "charge_full_design", "r")
	if not f then
		f = assert(io.open(path .. "energy_full_design", "r"))
	end
	chfd = f:read("*number")
	f:close()

	f = io.open(path .. "charge_full", "r")
	if not f then
		f = assert(io.open(path .. "energy_full", "r"))
	end
	chf = f:read("*number")
	f:close()

	health = string.format("%.2f", (chf / chfd) * 100)

	if (voltnow < voltmin) then
		naughty.notify( {
			preset	= naughty.config.presets.critical,
			title	= "Battery is being killed!",
			text	= "Your battery does not support such a low voltage. Unplug your laptop immediately!!" })
	end

	infos = "Brand: " .. brand ..
			"Model: " .. model ..
			"Technology: " .. techno ..
			"Serial Number: " .. serial ..
			"Cycle Count: " .. cycles ..
			"Health: " .. health .. "%" ..
			"\nVoltage (min design): " .. voltmin ..
			"\nVoltage now: " .. voltnow ..
			"\n\nUptime: " .. uptime

	if (status == 'Discharging\n') then
		-- calculate how long it has been on battery
		tmp = up_s - unplugtime
		upbat_h = math.floor(tmp / 3600)
		upbat_m = string.format("%02d", (tmp % 3600) / 60)
		if (upbat_h > 0) then
			upbat = upbat_h .. "h" .. upbat_m
		else
			if (upbat_m < "10") then
				upbat_m = string.format("%01d", upbat_m)
			end
			upbat = upbat_m .. "mn"
		end
		infos = infos .. "\nUp on battery: " .. upbat
	end

	showbatinfos = naughty.notify( {
		title		= "Battery Informations:",
		text		= infos,
		timeout		= 0,
		screen		= capi.mouse.screen })
end

function activebat(path)
	local perct, res, batime_h, batime_m, batime, f, tmp
	-- files we read from
	local charge_full, charge_now, current_now, present, status

	present = readfile(path .. "present", "*number")
	if (present == 0) then
		return '<span color="red">no</span>'
	end

	status = readfile(path .. "status", "*all")
	if (status == 'Full\n') then
		-- not discharging so unlock
		pluglock = false
		return '<span color="green">↯</span>'
	end

	f = io.open(path .. "charge_now", "r")
	if not f then
		f = assert(io.open(path .. "energy_now", "r"))
	end
	charge_now = f:read("*number")
	f:close()

	f = io.open(path .. "charge_full", "r")
	if not f then
		f = assert(io.open(path .. "energy_full", "r"))
	end
	charge_full = f:read("*number")
	f:close()

	perct = (charge_now/charge_full) * 100
	res = string.format("%.2f", perct)

	-- use a lock to avoid displaying the popup multiple times
	if perct >= 15 then
		lock = false
	end

	if perct < 15 then
		res = '<span color="red">' .. res .. '</span>'
		if not lock then
			lock = true
			naughty.notify( {
				bg		= "#ff0000",
				fg		= "#ffffff",
				title	= "Battery reached a low level",
				text	= "You should plug in your laptop!",
				timeout	= 5 })
		end
	elseif	perct < 25 then
		res = '<span color="orange">' .. res .. '</span>'
	elseif  perct < 35 then
		res = '<span color="yellow">' .. res .. '</span>'
	else
		res = '<span color="green">' .. res .. '</span>'
	end

	if (status == 'Discharging\n') then
		-- stuff for up on battery
		if (not pluglock) then
			for tmp in string.gmatch(readfile("/proc/uptime", "*all"), "([%d]+).") do
				unplugtime = tmp
				break
			end
			pluglock = true
		end

		-- get remaining time
		f = io.open(path .. "current_now", "r")
		if not f then
			f = assert(io.open(path .. "power_now", "r"))
		end
		current_now = f:read("*number")
		f:close()

		batime = math.floor((charge_now / current_now) * 60)
		batime_h = math.floor(batime / 60)
		batime_m = string.format("%02d", batime % 60)
		if (batime_h > 0) then
			batime = ' (' .. batime_h .. "h" .. batime_m .. ')'
			batime = ' (' .. batime_h .. "h" .. batime_m .. ')'
		else
			if (batime_m < "10") then
				batime_m = string.format("%01d", batime_m)
			end
			batime = ' (' .. batime_m .. 'mn)'
		end

		status = '<span color="red">-</span>'
	else
		-- not discharging so unlock
		pluglock = false

		status = '<span color="green">+</span>'
		batime = ''
	end

	res = res .. '% ' .. status .. batime

	return res
end

batinfo = widget({ type = "textbox" , name = "batinfo" })
batinfo:add_signal('mouse::enter', function () dispinfo(bat0) end)
batinfo:add_signal('mouse::leave', function () clearinfo() end)

-- Assign a hook to update info
activebat_timer = timer({timeout = 1})
activebat_timer:add_signal("timeout", function ()
batinfo.text = "BAT: " .. activebat(bat0) .. " |" end)
activebat_timer:start()
