-- Get cmus PID to check if it is running
function getCmusPid()
	local fpid = io.popen("pgrep cmus")
	local pid = fpid:read("*n")
	fpid:close()

	return pid
end

-- Enable cmus control
function cmus_control (action)
	local cmus_info, cmus_state
	local cmus_run = getCmusPid()

	if cmus_run then
		cmus_info = io.popen("cmus-remote -Q"):read("*all")
	    cmus_state = string.gsub(string.match(cmus_info, "status %a*"),"status ","")

		if cmus_state ~= "stopped" then
			if action == "next" then
				io.popen("cmus-remote -n")
			elseif action == "previous" then
				io.popen("cmus-remote -r")
			elseif action == "stop" then
				io.popen("cmus-remote -s")
			end
		end
		if action == "play_pause" then
			if cmus_state == "playing" or cmus_state == "paused" then
				io.popen("cmus-remote -u")
			elseif cmus_state == "stopped" then
				io.popen("cmus-remote -p")
			end
		end
	end
end

function hook_cmus()
	local cmus_string, cmus_info, cmus_state, cmus_artist, cmus_title, cmus_curtime, cmus_curtime_formated
	local cmus_totaltime, cmus_totaltime_formated, cmus_string
	-- check if cmus is running
	local cmus_run = getCmusPid()

	if cmus_run then
		cmus_string = '<span color="green">--</span> not playing <span color="green">--</span>'
		cmus_info = io.popen("cmus-remote -Q"):read("*all")
		if cmus_info ~= nil then
			cmus_state = string.gsub(string.match(cmus_info, "status %a*") or "","status ","")
			if cmus_state == "playing" or cmus_state == "paused" then
				cmus_artist = string.gsub(string.match(cmus_info, "tag artist %C*") or "", "tag artist ","") or "unknown artist"
				cmus_title = string.gsub(string.match(cmus_info, "tag title %C*") or "", "tag title ","") or "unknown title"
				cmus_curtime = string.gsub(string.match(cmus_info, "position %d*") or "", "position ","")
				cmus_curtime_formated = math.floor(cmus_curtime/60) .. ':' .. string.format("%02d",cmus_curtime % 60)
				cmus_totaltime = string.gsub(string.match(cmus_info, "duration %d*") or "", "duration ","")
				cmus_totaltime_formated = math.floor(cmus_totaltime/60) .. ':' .. string.format("%02d",cmus_totaltime % 60)
				cmus_string = awful.util.escape(cmus_artist .. " - " .. cmus_title .. "(" .. cmus_curtime_formated .. "/" .. cmus_totaltime_formated .. ")")
				if cmus_state == "paused" then
					cmus_string = '<span color="orange">||</span> ' .. cmus_string .. ''
				else
					cmus_string = '<span color="green">\></span> ' .. cmus_string .. ''
				end
			end
		end
		return cmus_string
	else
		return '<span color="red">--</span> not running <span color="red">--</span>'
	end
end

-- Cmus Widget
tb_cmus = widget({ type = "textbox", align = "right" })
tb_cmus:buttons(awful.util.table.join(
	awful.button({ }, 1, function () cmus_control("play_pause") end),
	awful.button({ }, 3, function () cmus_control("next") end)))

-- refresh Cmus widget
cmus_timer = timer({timeout = 1})
cmus_timer:add_signal("timeout", function() tb_cmus.text = '| ' .. hook_cmus() .. ' ' end)
cmus_timer:start()
