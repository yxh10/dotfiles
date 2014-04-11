local memory_util = require("sd/util/memory")
local beautiful = require("sd/util/pretty")
local wibox = require("wibox")
local simpletimer = require("sd/util/simpletimer")
local awful = require("awful")

local memory = {}

memory.icon = wibox.widget.imagebox(beautiful.widget_memory)
local memory_bar = awful.widget.progressbar()
memory_bar:set_color(beautiful.widget_memory_color)
memory_bar:set_width(55)
memory_bar:set_ticks(true)
memory_bar:set_ticks_size(3)
memory_bar:set_background_color(beautiful.bg_normal)
local memory_margin = wibox.layout.margin(memory_bar, 2, 10, 6, 6)

local update_memory_widget = function()
   local mem = memory_util.check()

   memory_bar:set_value(mem.percent_used)

   if mem.percent_used < .30 then
      memory_bar:set_color(beautiful.widget_memory_color)
   elseif mem.percent_used < .75 then
      memory_bar:set_color(beautiful.widget_meh_color)
   else
      memory_bar:set_color(beautiful.widget_aww_color)
   end
end

simpletimer.setup(3, update_memory_widget)

memory.widget = wibox.widget.background(memory_margin)
memory.widget:set_bgimage(beautiful.widget_background)

return memory
