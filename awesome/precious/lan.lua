-- LAN widget
function lanstatus()
	local lanon, f

	f = io.input("/sys/class/net/eth0/carrier")
	lanon = io.read("*number")
	f:close()

	if lanon == 1 then
		return '<span color = "green">on</span>'
	else
		return '<span color = "red">off</span>'
	end
end

laninfo = widget({ type = "textbox" , name = "laninfo" })

-- Assign a hook to update info
lanstatus__timer = timer({timeout = 1})
lanstatus__timer:add_signal("timeout", function() laninfo.text = " LAN: " .. lanstatus() .. " | " end)
lanstatus__timer:start()
