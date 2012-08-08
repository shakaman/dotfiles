-- WLAN widget
function wifistatus()
	local wifion, wifistrength, f

	f = io.input("/sys/class/net/wlan0/carrier")
	wifion = io.read("*number")
	f:close()

	if wifion == 1 then
		f = io.input("/sys/class/net/wlan0/wireless/link")
		wifistrength = io.read("*number")
		f:close()

		if wifistrength > 49 then
			return '<span color = "green">' .. wifistrength .. '</span>%'
		elseif wifistrength > 39 then
			return '<span color = "yellow">' .. wifistrength .. '</span>%'
		elseif wifistrength > 29 then
			return '<span color = "orange">' .. wifistrength .. '</span>%'
		else
			return '<span color = "red">' .. wifistrength .. '</span>%'
		end
	else
		return '<span color = "red">off</span>'
	end
end

wifiinfo = widget({ type = "textbox" , name = "wifiinfo" })

-- Assign a hook to update info
wifistatus__timer = timer({timeout = 1})
wifistatus__timer:add_signal("timeout", function() wifiinfo.text = "WLAN: " .. wifistatus() .. " | " end)
wifistatus__timer:start()
