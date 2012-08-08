-- WLAN widget
function wifistatus()
	-- local iwconfig, iw, wifistrength, f

  -- Get data from iwconfig where available
  local iwconfig = "/sbin/iwconfig"
  local f = io.open(iwconfig, "rb")
  if not f then
  	iwconfig = "/usr/sbin/iwconfig"
  else
  	f:close()
  end

  local f = io.popen(iwconfig .." 2>&1")
  local iw = f:read("*all")
  f:close()

  local wifistrength = tonumber(string.match(iw, "Signal level[=:]([%-]?[%d]+)") or 0)


	if wifistrength < -49 then
		return '<span color="green">' .. wifistrength .. '</span>%'
	elseif wifistrength < -39 then
		return '<span color="yellow">' .. wifistrength .. '</span>%'
	elseif wifistrength < -29 then
		return '<span color="orange">' .. wifistrength .. '</span>%'
	else
		return '<span color="red">' .. wifistrength .. '</span>%'
	end
end

wifiinfo = widget({ type = "textbox" , name = "wifiinfo" })
wifiinfo:buttons({
	button({ }, 1, function () awful.util.spawn("wicd-client") end)
})

-- Assign a hook to update info
wifistatus__timer = timer({timeout = 1})
wifistatus__timer:add_signal("timeout", function() wifiinfo.text = "WLAN: " .. wifistatus() .. " | " end)
wifistatus__timer:start()
