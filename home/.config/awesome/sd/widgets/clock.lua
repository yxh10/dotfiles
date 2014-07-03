local wibox = require("wibox")
local beautiful = require("sd/util/pretty")
local awful = require("awful")

local clock = {}

clock.icon = wibox.widget.imagebox()
clock.icon:set_image(beautiful.widget_clock)
clock.widget = awful.widget.textclock("<span color='#cccc44'>%a %b %d  %I:%M %p</span>")
clock.widget:set_font("Terminus 8")

return clock
