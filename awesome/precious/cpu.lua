-- needed in order to get the number of CPU cores
require("precious.utils")

-- Create a CPU widget
jiffies = {}
function activecpu(nbcores)
	local res, str

	for line in io.lines("/proc/stat") do
		local cpu,newjiffies = string.match(line, "(cpu)\ +(%d+)")
		if cpu and newjiffies then
			if not jiffies[cpu] then
				jiffies[cpu] = newjiffies
			end
			-- The string.format prevents your task list from jumping around
			-- When CPU usage goes above/below 10%
			str = string.format("%02d", (newjiffies-jiffies[cpu])/nbcores)
			if str < "31" then
				str = '<span color="green">' .. str .. '</span>'
			elseif str < "51" then
				str = '<span color="yellow">' .. str .. '</span>'
			elseif str < "70" then
				str = '<span color="orange">' .. str .. '</span>'
			else
				str = '<span color="red">' .. str .. '</span>'
			end

			res = ' CPU: ' .. str .. '% '
			jiffies[cpu] = newjiffies
		end
	end

	return res
end

cpuinfo = widget({ type = "textbox", name = "cpuinfo" })

-- register the hook to update the display
cpuinfo_timer = timer({timeout = 1})
cpuinfo_timer:add_signal("timeout", function() cpuinfo.text = activecpu(getnbcore()) end)
cpuinfo_timer:start()


-- Create CPU Temp Widget
function activecputemp()
	local temp, f

	f = io.input("/sys/bus/acpi/devices/LNXTHERM\:00/thermal_zone/temp")
	temp = io.read("*number")/1000
	f:close()

	if temp < 46 then
		temp = '<span color="turquoise">' .. temp .. '</span>'
	elseif	temp < 61 then
		temp = '<span color="yellow">' .. temp .. '</span>'
	elseif  temp < 76 then
		temp = '<span color="orange">' .. temp .. '</span>'
	else
		temp = '<span color="red">' .. temp .. '</span>'
	end

	return temp
end

cputemp = widget({ type = "textbox" , name = "cputemp" })

-- Assign a hook to update temperature
cputemp_timer = timer({timeout = 1})
cputemp_timer:add_signal("timeout", function() cputemp.text = "@ " .. activecputemp() .. "°C | RAM: " end)
cputemp_timer:start()
