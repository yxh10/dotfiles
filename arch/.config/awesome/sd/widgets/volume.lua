local volume_util = require("sd/util/volume")
local beautiful = require("sd/util/pretty")
local wibox = require("wibox")
local simpletimer = require("sd/util/simpletimer")
local awful = require("awful")

local volume = {}

volume.icon = wibox.widget.imagebox(beautiful.widget_volume)
local volume_bar = awful.widget.progressbar()
volume_bar:set_color(beautiful.widget_volume_color)
volume_bar:set_width(55)
volume_bar:set_ticks(true)
volume_bar:set_ticks_size(3)
volume_bar:set_background_color(beautiful.bg_normal)
local volume_margin = wibox.layout.margin(volume_bar, 2, 10, 6, 6)

function volume.update()
   local percent = volume_util.check()
   volume_bar:set_value(percent)
end

simpletimer.setup(193, volume.update)

volume.widget = wibox.widget.background(volume_margin)
volume.widget:set_bgimage(beautiful.widget_background)

return volume
