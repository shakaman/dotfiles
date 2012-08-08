-- Create GPU Temp Widget ("nouveau driver version")
function activegputemp()
	local temp, f
	f = io.input("/sys/devices/pci0000:00/0000:00:1f.3/i2c-0/0-0019/temp1_input")
	temp = io.read("*number")/1000
	f:close()

	if temp < 60 then
		temp = '<span color="turquoise">' .. temp .. '</span>'
	elseif	temp < 70 then
		temp = '<span color="yellow">' .. temp .. '</span>'
	elseif  temp < 80 then
		temp = '<span color="orange">' .. temp .. '</span>'
	elseif temp < 100 then
		temp = '<span color="red">' .. temp .. '</span>'
	else
		temp = '<span color="red">CRITICAL</span>'
	end

	return temp
end

gputemp = widget({ type = "textbox" , name = "gputemp" })

-- Assign a hook to update temperature
gputemp_timer = timer({timeout = 1})
gputemp_timer:add_signal("timeout", function() gputemp.text = "| GPU: " .. activegputemp() .. "°C " end)
gputemp_timer:start()

-- Create GPU Temp Widget ("nvidia driver version")
function activegputemp()
	local temp, f

	f = io.popen("nvidia-settings -q GPUCoreTemp -t")
	temp = tonumber(f:read("*all"))
	f:close()

	if temp < 60 then
		temp = '<span color="turquoise">' .. temp .. '</span>'
	elseif	temp < 70 then
		temp = '<span color="yellow">' .. temp .. '</span>'
	elseif  temp < 80 then
		temp = '<span color="orange">' .. temp .. '</span>'
	elseif temp < 100 then
		temp = '<span color="red">' .. temp .. '</span>'
	else
		temp = '<span color="red">CRITICAL</span>'
	end

	return temp
end

gputemp = widget({ type = "textbox" , name = "gputemp" })

-- Assign a hook to update temperature
gputemp_timer = timer({timeout = 1})
gputemp_timer:add_signal("timeout", function() gputemp.text = "| GPU: " .. activegputemp() .. "°C " end)
gputemp_timer:start()
