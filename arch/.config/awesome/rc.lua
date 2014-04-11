local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")


-- global vars needed for the following requires :(
WINKEY = "Mod4"
ALTKEY = "Mod1"
CTRLKEY = "Control"
MASH = { WINKEY, CTRLKEY, ALTKEY }
MASH_SHIFT = { WINKEY, ALTKEY, "Shift" }

function round (n) return math.floor(n + 0.5) end

local globalkeys = require("globalkeys")
local clientkeys = require("clientkeys")
local grid = require("grid")


if awesome.startup_errors then
   naughty.notify({ preset = naughty.config.presets.critical,
                    title = "Oops, there were errors during startup!",
                    text = awesome.startup_errors })
end

do
   local in_error = false
   awesome.connect_signal("debug::error",
                          function (err)
                             if in_error then return end
                             in_error = true

                             naughty.notify({ preset = naughty.config.presets.critical,
                                              title = "Oops, an error happened!",
                                              text = err })
                             in_error = false
                          end)
end

beautiful.init("~/.config/awesome/my-theme.lua")
gears.wallpaper.maximized(beautiful.wallpaper, nil, true)

awful.tag({1, 2, 3})































local left_side   = wibox.layout.fixed.horizontal()
local right_side  = wibox.layout.fixed.horizontal()
local whole_bar   = wibox.layout.align.horizontal()
whole_bar:set_left(left_side)
whole_bar:set_right(right_side)






local tasklist_buttons = awful.util.table.join(
   awful.button({ }, 1,
                function (c)
                   client.focus = c
                   c:raise()
                end))
local tasklist_style = { tasklist_disable_icon = true }
local tasklist_widget = awful.widget.tasklist(1, awful.widget.tasklist.filter.currenttags, tasklist_buttons, tasklist_style)

whole_bar:set_middle(tasklist_widget)









local taglist_widget = awful.widget.taglist(1, awful.widget.taglist.filter.all)
local systray_widget = wibox.widget.systray()








-- spanStart = '<span '
-- spanEnd = '</span>'
-- font = 'font="Terminus 8"'
-- white = 'color="#b2b2b2"'
-- red = 'color="#e54c62"'
-- blue = 'color="#00aeff"'
-- green = 'color="#1dff00"'



-- -- TODO: add widgets.wifi,
-- --       get missing icons,
-- --       add disk-free stats using: df --output=pcent /dev/sda1 | tail -n 1
-- --       add widgets.volume
-- --       add gmail widget using netrc and the gmail url
-- --
-- -- decoSpace = wibox.widget.textbox('  ')
-- -- right_side:add(decoSpace)
-- --
-- -- diskwidget = wibox.widget.textbox()
-- -- vicious.register(diskwidget, vicious.contrib.dio, "${total_mb}", 3, "sda")
-- -- right_side:add(diskwidget)





-- -- CPU widget
-- iconCPU = wibox.widget.imagebox()
-- iconCPU:set_image(beautiful.widget_cpu)
-- iconCPU:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(tasks, false) end)))
-- right_side:add(iconCPU)

-- widgetCPU = wibox.widget.textbox()
-- vicious.register(widgetCPU, vicious.widgets.cpu, spanStart .. font .. blue .. '>1%' .. spanEnd, 3)
-- right_side:add(widgetCPU)










iconClock = wibox.widget.imagebox()
iconClock:set_image(beautiful.clock)
widgetClock = awful.widget.textclock("<span color='#cccc44'>%a %b %d  %I:%M %p</span>")
widgetClock:set_font("Terminus 8")





local battery = require("sd/battery")
local simpletimer = require("sd/simpletimer")
local weather = require("sd/weather")
local memory = require("sd/memory")

-- Battery
battery_icon = wibox.widget.imagebox(beautiful.bat)
battery_bar = awful.widget.progressbar()
battery_bar:set_color(beautiful.fg_normal)
battery_bar:set_width(55)
battery_bar:set_ticks(true)
battery_bar:set_ticks_size(3)
battery_bar:set_background_color(beautiful.bg_normal)
battery_margin = wibox.layout.margin(battery_bar, 2, 10, 6, 6)

local update_battery_widget = function()
   local bat = battery.check()

   battery_bar:set_value(bat.percent)

   if bat.is_charging or bat.is_full then
      battery_bar:set_color(beautiful.battery_healthy_color)
      battery_icon:set_image(beautiful.ac)
      return
   end

   if bat.percent > .50 then
      battery_bar:set_color(beautiful.battery_healthy_color)
      battery_icon:set_image(beautiful.bat)
   elseif bat.percent > .15 then
      battery_bar:set_color(beautiful.battery_kindaok_color)
      battery_icon:set_image(beautiful.bat_low)
   else
      battery_bar:set_color(beautiful.battery_verylow_color)
      battery_icon:set_image(beautiful.bat_no)
   end

   if bat.percent <= .5 then
      naughty.notify(beautiful.battery_dead_notice)
   end
end

simpletimer.setup(29, update_battery_widget)

battery_widget = wibox.widget.background(battery_margin)
battery_widget:set_bgimage(beautiful.widget_bg)





-- Memory
memory_icon = wibox.widget.imagebox(beautiful.widget_mem)
memory_bar = awful.widget.progressbar()
memory_bar:set_color(beautiful.fg_normal)
memory_bar:set_width(55)
memory_bar:set_ticks(true)
memory_bar:set_ticks_size(3)
memory_bar:set_background_color(beautiful.bg_normal)
memory_margin = wibox.layout.margin(memory_bar, 2, 10, 6, 6)

local update_memory_widget = function()
   local mem = memory.check()

   memory_bar:set_value(mem.percent_used)

   if mem.percent_used < .30 then
      memory_bar:set_color(beautiful.memory_healthy_color)
   elseif mem.percent_used < .75 then
      memory_bar:set_color(beautiful.memory_kindaok_color)
   else
      memory_bar:set_color(beautiful.memory_verylow_color)
   end
end

simpletimer.setup(3, update_memory_widget)

memory_widget = wibox.widget.background(memory_margin)
memory_widget:set_bgimage(beautiful.widget_bg)







weather_icon = wibox.widget.imagebox(beautiful.widget_temp)
weather_widget = wibox.widget.textbox()
weather_widget:set_font("Terminus 8")

local lat  = 42.32
local long = -88.45

local update_weather_widget = function()
   local result = weather.check(lat, long)
   weather_widget:set_markup("<span color='#00aeff'>" .. round(tonumber(result.temp)) .. "°</span>")
end
simpletimer.setup(31, update_weather_widget)

function show_weather(self)
   local result = weather.check(lat, long)

   naughty.notify({timeout = 30,
                   font = "Terminus 8",
                   text =
                      "      Temp: " .. round(tonumber(result.temp)) .. "°\n" ..
                      "       Low: " .. round(tonumber(result.low)) .. "°\n" ..
                      "      High: " .. round(tonumber(result.high)) .. "°\n" ..
                      "  Humidity: " .. result.humidity .. "%\n" ..
                      "Wind Speed: " .. result.speed .. " mph"})
end

weather_widget:connect_signal("mouse::enter", show_weather)

weather_combined = wibox.layout.fixed.horizontal()
weather_combined:add(weather_widget)











left_side:add(taglist_widget)
right_side:add(systray_widget)
right_side:add(wibox.layout.margin(weather_icon,     10,  nil))
right_side:add(wibox.layout.margin(weather_combined, nil, 10))
right_side:add(battery_icon)
right_side:add(battery_widget)
right_side:add(memory_icon)
right_side:add(memory_widget)

right_side:add(iconClock)
right_side:add(wibox.layout.margin(widgetClock, nil, 10))








local my_wibox = awful.wibox({ position = "top", height = 18 })
my_wibox:set_widget(whole_bar)











clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ WINKEY }, 1, awful.mouse.client.move),
   awful.button({ WINKEY }, 3, awful.mouse.client.resize))

root.keys(globalkeys)

awful.rules.rules = {
   { rule = { },
     properties = { border_width = beautiful.border_width,
                    border_color = beautiful.border_normal,
                    focus = awful.client.focus.filter,
                    size_hints_honor = false,
                    raise = true,
                    keys = clientkeys,
                    buttons = clientbuttons } },
}

function manage_window (c, startup)
   if not startup then
      if not c.size_hints.user_position and not c.size_hints.program_position then
         awful.placement.no_overlap(c)
         awful.placement.no_offscreen(c)
      end

      grid.snap_to_grid(c)
   end
end

client.connect_signal("manage", manage_window)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)



local fix_window_positions = function()
   if fix_window_positions_timer then
      fix_window_positions_timer:stop()
      for i, client in pairs(client.get()) do
         local g = client:geometry()
         g.x = g.x - beautiful.border_width
         g.y = g.y - beautiful.border_width
         client:geometry(g)
      end
      -- local c = client.focus
      -- client.focus = c
      -- c:raise()
   end
end
fix_window_positions_timer = simpletimer.setup(0, fix_window_positions)
