local battery_util = require("sd/util/battery")
local beautiful = require("sd/util/pretty")
local wibox = require("wibox")
local simpletimer = require("sd/util/simpletimer")
local naughty = require("naughty")
local awful = require("awful")

local battery = {}

battery.icon = wibox.widget.imagebox(beautiful.widget_battery)
local battery_bar = awful.widget.progressbar()
battery_bar:set_color(beautiful.fg_normal)
battery_bar:set_width(55)
battery_bar:set_ticks(true)
battery_bar:set_ticks_size(3)
battery_bar:set_background_color(beautiful.bg_normal)
local battery_margin = wibox.layout.margin(battery_bar, 2, 10, 6, 6)

local function update_battery_widget()
   local bat = battery_util.check()

   battery_bar:set_value(bat.percent)

   if bat.is_charging or bat.is_full then
      battery_bar:set_color(beautiful.widget_yay_color)
      battery.icon:set_image(beautiful.widget_battery_ac)
      return
   end

   if bat.percent > .50 then
      battery_bar:set_color(beautiful.widget_yay_color)
      battery.icon:set_image(beautiful.widget_battery)
   elseif bat.percent > .15 then
      battery_bar:set_color(beautiful.widget_meh_color)
      battery.icon:set_image(beautiful.widget_battery_low)
   else
      battery_bar:set_color(beautiful.widget_aww_color)
      battery.icon:set_image(beautiful.widget_battery_empty)
   end

   if bat.percent <= .05 then
      naughty.notify(beautiful.battery_dead_notice)
   end
end

simpletimer.setup(29, update_battery_widget)

battery.widget = wibox.widget.background(battery_margin)
battery.widget:set_bgimage(beautiful.widget_background)

return battery
