local gears = require("gears")
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

local globalkeys = require("globalkeys")
local clientkeys = require("clientkeys")
local grid = require("grid")
local bar = require("bar")


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

bar.setup_bar()

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

-- for i, w in pairs(client.get()) do
--    grid.snap_to_grid(w)
-- end
