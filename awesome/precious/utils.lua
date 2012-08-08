-- This is not a widget even though it is needed by some widgets
-- It is a collection of small utilities to reuse in widgets

--reads a file using the specified mode
function readfile(path, mode)
	local f, ret

	f = assert(io.open(path, "r"))
	ret = f:read(mode)
	f:close()

	return ret
end

-- clear a naugthy notify using its name
function clearinfo(infoname)
	if infoname ~= nil then
		naughty.destroy(infoname)
		infoname = nil
	end
end

-- gets the hostname
function gethostname()
	local hostname

	hostname = os.getenv("HOST")
	if not hostname then
		local f = io.popen("uname -n")
		hostname = string.gsub(f:read("*all"), "\n", "")
		f:close()
	end

	return hostname
end

-- gets the username
function getusername()
	local username

	username = os.getenv("USER")
	if not username then
		username = "master"
	end

	return username
end

-- speak a text (require festival to be installed)
function speak(text)
	assert(io.popen("echo " .. text .. " | festival --tts"))
end

-- get number of cpu cores of the machine and return it
function getnbcore()
	local ret, line
	local tmp = 0

	for line in io.lines("/proc/cpuinfo") do
		tmp= string.match(line, "processor%s:\ +(%d+)")
		if tmp then
			ret = tmp
		end
	end

	return ret + 1
end
