local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")

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

terminal = "urxvt"
modkey = "Mod4"

awful.tag({1})

local right_layout = wibox.layout.fixed.horizontal()
right_layout:add(wibox.widget.systray())
right_layout:add(awful.widget.textclock())

local battery_update_fn = function()
   fh = assert(io.popen("acpi | cut -d, -f 2", "r"))
   batterywidget:set_text(" |" .. fh:read("*l") .. " | ")
   fh:close()
end

batterywidget = wibox.widget.textbox()
batterywidget:set_text(" | Battery | ")
batterywidgettimer = timer({ timeout = 30 })
batterywidgettimer:connect_signal("timeout", battery_update_fn)
batterywidgettimer:start()
right_layout:add(batterywidget)

battery_update_fn()

local layout = wibox.layout.align.horizontal()
layout:set_right(right_layout)

mywibox = awful.wibox({ position = "bottom" })
mywibox:set_widget(layout)

globalkeys = awful.util.table.join(
   awful.key({ modkey, "Shift" }, "h", function () awful.client.focus.bydirection("left") ; client.focus:raise() end),
   awful.key({ modkey, "Shift" }, "l", function () awful.client.focus.bydirection("right"); client.focus:raise() end),
   awful.key({ modkey, "Shift" }, "j", function () awful.client.focus.bydirection("down") ; client.focus:raise() end),
   awful.key({ modkey, "Shift" }, "k", function () awful.client.focus.bydirection("up"); client.focus:raise() end),

   awful.key({ modkey }, "Return", function () awful.util.spawn(terminal) end),
   awful.key({ modkey }, "r", awesome.restart),
   awful.key({ modkey, "Shift" }, "q", awesome.quit),

   awful.key({ modkey }, "e", function () awful.util.spawn_with_shell("emacsclient -nc -a '' ~/projects") end),
   awful.key({ modkey }, "p", function () awful.util.spawn_with_shell("dmenu_run") end))

clientkeys = awful.util.table.join(

   awful.key({ modkey }, "i",
             function (c)
                r = screen[1].workarea
                g = c:geometry(r)
             end),

   awful.key({ modkey }, "m",
             function (c)
                r = screen[1].workarea
                g = c:geometry(r)
             end),

   awful.key({ modkey, "Shift"   }, "c", function (c) c:kill() end),
   awful.key({ modkey,           }, "m",
             function (c)
                c.maximized_horizontal = not c.maximized_horizontal
                c.maximized_vertical   = not c.maximized_vertical
             end))

clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ modkey }, 1, awful.mouse.client.move),
   awful.button({ modkey }, 3, awful.mouse.client.resize))

root.keys(globalkeys)

awful.rules.rules = {
   { rule = { },
     properties = { border_width = 3,
                    border_color = beautiful.border_normal,
                    focus = awful.client.focus.filter,
                    size_hints_honor = false,
                    raise = true,
                    keys = clientkeys,
                    buttons = clientbuttons } },
}

function manage_window (c, startup)
   c:connect_signal("mouse::enter", function(c)
                       if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
                          and awful.client.focus.filter(c) then
                       client.focus = c
                       c:raise()
                       end
                                    end)

   if not startup then
      if not c.size_hints.user_position and not c.size_hints.program_position then
         awful.placement.no_overlap(c)
         awful.placement.no_offscreen(c)
      end
   end
end

client.connect_signal("manage", manage_window)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
