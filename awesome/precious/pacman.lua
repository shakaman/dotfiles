-- Pacman widget (remember you need a cron to update with pacman -Sy )
require("precious.utils")

showpacinfos = nil

local function dispinfo()
	local f, infos
	local avupdate = getnbupdates()
	local capi = {
		mouse = mouse,
		screen = screen
	}

	if avupdate == 0 then
		showpacinfos = naughty.notify( {
		title	= "No updates available",
		text	= "Your system is already up to date :-) ",
		timeout	= 0,
		screen	= capi.mouse.screen })
	else
		f = io.popen("pacman -Qqu")
		infos = f:read("*all")
		f:close()

		if avupdate == 1 then
			showpacinfos = naughty.notify( {
				title	= "Available update:",
				text	= infos,
				timeout	= 0,
				screen	= capi.mouse.screen })

		else
			showpacinfos = naughty.notify( {
				title	= "Available updates:",
				text	= infos,
				timeout	= 0,
				screen	= capi.mouse.screen })
		end
	end

end

function getnbupdates()
	local f, avupdate

	f = io.popen("pacman -Qu | wc -l")
	avupdate = tonumber(f:read("*all"))
	f:close()

	return avupdate
end

function pacupdate()
	local avupdate = getnbupdates()

	if avupdate == 0 then
		avupdate = '<span color="green">' .. avupdate
	elseif avupdate < 6 then
		avupdate = '<span color="yellow">' .. avupdate
	elseif avupdate < 16 then
		avupdate = '<span color="orange">' .. avupdate
	else
		avupdate = '<span color="red">' .. avupdate
	end

	return '<span color = "yellow">C</span> - <span color="turquoise">o</span>: ' .. avupdate .. '</span> '


end

pacinfo = widget({ type = "textbox" , name = "pacinfo" })
pacinfo:add_signal('mouse::enter', function () dispinfo() end)
pacinfo:add_signal('mouse::leave', function () clearinfo(showpacinfos) end)

-- Assign a hook to update info
pacinfo__timer = timer({timeout = 1})
pacinfo__timer:add_signal("timeout", function() pacinfo.text = pacupdate() end)
pacinfo__timer:start()
