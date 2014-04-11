local gears = require("gears")
local wibox = require("wibox")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local naughty = require("naughty")


-- global vars needed for the following requires :(
WINKEY = "Mod4"
ALTKEY = "Mod1"
CTRLKEY = "Control"
MASH = { WINKEY, CTRLKEY, ALTKEY }
MASH_SHIFT = { WINKEY, ALTKEY, "Shift" }

function round (n) return math.floor(n + 0.5) end

local globalkeys = require("sd/core/globalkeys")
local clientkeys = require("sd/core/clientkeys")
local grid = require("sd/util/grid")


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


local beautiful = require("sd/util/pretty")
gears.wallpaper.maximized(beautiful.wallpaper, nil, true)

awful.tag({1, 2, 3})

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

local battery = require("sd/widgets/battery")
local weather = require("sd/widgets/weather")
local memory  = require("sd/widgets/memory")
local clock   = require("sd/widgets/clock")
local misc    = require("sd/widgets/misc")

local left_side   = wibox.layout.fixed.horizontal()
local right_side  = wibox.layout.fixed.horizontal()
local top_bar     = wibox.layout.align.horizontal()

top_bar:set_left(left_side)
top_bar:set_right(right_side)





left_side:add(misc.taglist)
right_side:add(misc.systray)
right_side:add(wibox.layout.margin(weather.icon,   10,  nil))
right_side:add(wibox.layout.margin(weather.widget, nil, 10))
right_side:add(battery.icon)
right_side:add(battery.widget)
right_side:add(memory.icon)
right_side:add(memory.widget)

right_side:add(clock.icon)
right_side:add(wibox.layout.margin(clock.widget, nil, 10))








local top_wibox = awful.wibox({ position = "top", height = 18 })
top_wibox:set_widget(top_bar)

local bottom_wibox = awful.wibox({ position = "bottom", height = 18 })
bottom_wibox:set_widget(misc.tasklist)











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
local simpletimer = require("sd/util/simpletimer")
fix_window_positions_timer = simpletimer.setup(0, fix_window_positions)
