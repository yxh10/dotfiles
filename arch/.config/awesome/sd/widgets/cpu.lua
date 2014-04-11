local cpu_util = require("sd/util/cpu")
local beautiful = require("sd/util/pretty")
local wibox = require("wibox")
local simpletimer = require("sd/util/simpletimer")
local awful = require("awful")

local cpu = {}

cpu.icon = wibox.widget.imagebox(beautiful.widget_cpu)
local cpu_bar = awful.widget.progressbar()
cpu_bar:set_color(beautiful.widget_yay_color)
cpu_bar:set_width(55)
cpu_bar:set_ticks(true)
cpu_bar:set_ticks_size(3)
cpu_bar:set_background_color(beautiful.bg_normal)
local cpu_margin = wibox.layout.margin(cpu_bar, 2, 10, 6, 6)

local update_cpu_widget = function()
   local percent = cpu_util.check()[1] / 100

   cpu_bar:set_value(percent)

   if percent < .30 then
      cpu_bar:set_color(beautiful.widget_yay_color)
   elseif percent < .75 then
      cpu_bar:set_color(beautiful.widget_meh_color)
   else
      cpu_bar:set_color(beautiful.widget_aww_color)
   end
end

simpletimer.setup(3, update_cpu_widget)

cpu.widget = wibox.widget.background(cpu_margin)
cpu.widget:set_bgimage(beautiful.widget_background)

return cpu
