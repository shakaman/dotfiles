-- Enable mocp control
function moc_control (action)
	local moc_info,moc_state

	if action == "next" then
		io.popen("mocp --next")
	elseif action == "previous" then
		io.popen("mocp --previous")
	elseif action == "stop" then
		io.popen("mocp --stop")
	elseif action == "play_pause" then
		moc_info = io.popen("mocp -i"):read("*all")
	    moc_state = string.gsub(string.match(moc_info, "State: %a*"),"State: ","")

		if moc_state == "PLAY" then
			io.popen("mocp --pause")
		elseif moc_state == "PAUSE" then
			io.popen("mocp --unpause")
		elseif moc_state == "STOP" then
			io.popen("mocp --play")
		end
	end
end

-- Moc Widget
tb_moc = widget({ type = "textbox", align = "right" })

function hook_moc()
	moc_info = io.popen("mocp -i"):read("*all")
	moc_state = string.gsub(string.match(moc_info, "State: %a*"),"State: ","")
	if moc_state == "PLAY" or moc_state == "PAUSE" then
		moc_artist = string.gsub(string.match(moc_info, "Artist: %C*"), "Artist: ","")
		moc_title = string.gsub(string.match(moc_info, "SongTitle: %C*"), "SongTitle: ","")
		moc_curtime = string.gsub(string.match(moc_info, "CurrentTime: %d*:%d*"), "CurrentTime: ","")
		moc_totaltime = string.gsub(string.match(moc_info, "TotalTime: %d*:%d*"), "TotalTime: ","")
		if moc_artist == "" then
			moc_artist = "unknown artist"
		end
		if moc_title == "" then
			moc_title = "unknown title"
		end
		moc_string = awful.util.escape(moc_artist .. " - " .. moc_title .. "(" .. moc_curtime .. "/" .. moc_totaltime .. ")")
		if moc_state == "PAUSE" then
			moc_string = '<span color="orange">||</span> ' .. moc_string .. ''
		else
			moc_string = '<span color="green">\></span> ' .. moc_string .. ''
		end
	else
		moc_string = "-- not playing --"
	end
	return moc_string
end

-- refresh Moc widget
moc_timer = timer({timeout = 1})
moc_timer:add_signal("timeout", function() tb_moc.text = '| ' .. hook_moc() .. ' ' end)
moc_timer:start()
