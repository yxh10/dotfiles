local disk_util = require("sd/util/disk")
local beautiful = require("sd/util/pretty")
local wibox = require("wibox")
local simpletimer = require("sd/util/simpletimer")
local awful = require("awful")

local disk = {}

disk.icon = wibox.widget.imagebox(beautiful.widget_disk)
local disk_bar = awful.widget.progressbar()
disk_bar:set_color(beautiful.fg_normal)
disk_bar:set_width(55)
disk_bar:set_ticks(true)
disk_bar:set_ticks_size(3)
disk_bar:set_background_color(beautiful.bg_normal)
local disk_margin = wibox.layout.margin(disk_bar, 2, 10, 6, 6)

local update_disk_widget = function()
   local percent = disk_util.check()

   disk_bar:set_value(percent)

   if percent < .30 then
      disk_bar:set_color(beautiful.widget_yay_color)
   elseif percent < .75 then
      disk_bar:set_color(beautiful.widget_meh_color)
   else
      disk_bar:set_color(beautiful.widget_aww_color)
   end
end

simpletimer.setup(59, update_disk_widget)

disk.widget = wibox.widget.background(disk_margin)
disk.widget:set_bgimage(beautiful.widget_background)

return disk
