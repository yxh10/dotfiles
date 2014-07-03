local awful = require("awful")
local wibox = require("wibox")

local misc = {}

local tasklist_buttons = awful.util.table.join(
   awful.button({ }, 1,
                function (c)
                   client.focus = c
                   c:raise()
                end))
local tasklist_style = { tasklist_disable_icon = true }

misc.tasklist = awful.widget.tasklist(1, awful.widget.tasklist.filter.currenttags, tasklist_buttons, tasklist_style)
misc.taglist = awful.widget.taglist(1, awful.widget.taglist.filter.all)
misc.systray = wibox.widget.systray()

return misc
