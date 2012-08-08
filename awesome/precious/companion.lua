-- Companion widget
--
-- NOTE: requires the following packages in order to work:
-- * scrot (for screenshots)
-- * slock (for screen lock)
-- * festival (for text-to-speech)

-- utils for widgets
require("precious.utils")

local hostname = gethostname()
local user = getusername()

-- folder where to save screenshots
local location = os.getenv("HOME") .. "/Pictures/Screenshots/"

function disp(t)
	naughty.notify( {
		title	= "Companion",
		text	= t,
		timeout	= 5 })
end

function takescreenshot()
	local f, t, date, name, text

	t = os.date("*t")
	date = t.day .. "-" .. t.month .. "-" .. t.year .. "-" .. t.hour .. t.min .. t.sec

	name = "screenshot-" .. hostname .. "-" .. date .. ".png"

	io.popen("scrot -d 5 " .. location .. name)

	disp("Taking screenshot in this location:\n" .. location .. name)
	speak("Taking screenshot in 5 seconds.")
end

function lockscreen()
	speak("Locking screen.")
	os.execute("slock")
end

function greet()
	local text = "Yes " .. user .. " ?"

	speak(text)
end

function disturb()
	speak("Please, " .. user .. " do not scratch my head!")
end

function iam()
	speak("I am " .. hostname)
end

companion = widget({ type = "textbox" , name = "companion" })
companion.text = ' <span color="cyan">*</span><span color="red">_</span><span color="cyan">*</span> |'

companion:add_signal('mouse::enter', function () greet() end)
companion:buttons(awful.util.table.join(
	awful.button({ }, 1, function () lockscreen() end),
	awful.button({ }, 3, function () takescreenshot() end),
	awful.button({ }, 4, function () disturb() end),
	awful.button({ }, 5, function () iam() end)))

