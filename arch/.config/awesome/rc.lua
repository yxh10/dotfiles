local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local vicious = require("vicious")

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

winkey = "Mod4"
altkey = "Mod1"
ctrlkey = "Control"
mash = { winkey, ctrlkey, altkey }
mash_shift = { winkey, altkey, "Shift" }

awful.tag({1, 2, 3})

local left_layout = wibox.layout.fixed.horizontal()
left_layout:add(awful.widget.taglist(1, awful.widget.taglist.filter.all))

local right_layout = wibox.layout.fixed.horizontal()
right_layout:add(wibox.widget.systray())



tasklist_buttons = awful.util.table.join(
   awful.button({ }, 1,
                function (c)
                   client.focus = c
                   c:raise()
                end))

local layout = wibox.layout.align.horizontal()
layout:set_left(left_layout)
layout:set_middle(awful.widget.tasklist(1, awful.widget.tasklist.filter.currenttags, tasklist_buttons))
layout:set_right(right_layout)

mywibox = awful.wibox({ position = "bottom" })
mywibox:set_widget(layout)






function make_battery_widget()
   local background_color = "#494B4F" -- "#000000"
   local red = "#AECF96"
   local yellow = "#88A175"
   local green = "#FF5656"

   -- red = "#00ff00"
   -- yellow = "#ffff00"
   -- green = "#ff0000"

   batwidget = awful.widget.progressbar()
   batwidget:set_width(8)
   batwidget:set_height(20)
   batwidget:set_vertical(true)
   batwidget:set_background_color(background_color)
   batwidget:set_border_color(nil)
   batwidget:set_color({type = "linear",
                        from = { 0, 0 },
                        to = { 0, 20 },
                        stops = { { 0,   red },
                                  { 0.5, yellow },
                                  { 1,   green }}})
   vicious.register(batwidget, vicious.widgets.bat, "$2", 61, "BAT0")

   local marge = wibox.layout.margin()
   marge:set_widget(batwidget)
   marge:set_left(5)
   marge:set_right(5)

   -- local sidebar_layout = wibox.layout.flex.vertical()
   -- local battery_wibox = awful.wibox({ position = "right", width = 10 })
   -- sidebar_layout:add(batwidget)
   -- battery_wibox:set_widget(sidebar_layout)
   right_layout:add(marge)
end

make_battery_widget()

datewidget = wibox.widget.textbox()
vicious.register(datewidget, vicious.widgets.date, "%a  /  %b %e  /  %r")
right_layout:add(datewidget)


-- mpdwidget = wibox.widget.textbox()
-- vicious.register(mpdwidget, vicious.widgets.mpd,
--                  function (mpdwidget, args)
--                     -- naughty.notify({text = args["{state}"]})
--                     if args["{state}"] == "Stop" then
--                        return " - "
--                     else
--                        return args["{Artist}"]..' - '.. args["{Title}"]
--                     end
--                  end, 10)
-- right_layout:add(mpdwidget)













function focus_window(dir)
   awful.client.focus.byidx(dir)
   if client.focus then
      client.focus:raise()
   end
end

globalkeys = awful.util.table.join(

   awful.key({ winkey          }, "Tab", function () focus_window(1) end),
   awful.key({ winkey, "Shift" }, "Tab", function () focus_window(-1) end),

   awful.key(mash_shift, "h", function () awful.client.focus.bydirection("left") ; client.focus:raise() end),
   awful.key(mash_shift, "l", function () awful.client.focus.bydirection("right"); client.focus:raise() end),
   awful.key(mash_shift, "j", function () awful.client.focus.bydirection("down") ; client.focus:raise() end),
   awful.key(mash_shift, "k", function () awful.client.focus.bydirection("up"); client.focus:raise() end),

   awful.key({ winkey }, "e", function () awful.util.spawn_with_shell("emacsclient -nc -a '' ~/projects") end),
   awful.key({ winkey }, " ", function () awful.util.spawn_with_shell("dmenu_run") end),
   awful.key({ winkey }, "Return", function () awful.util.spawn("urxvt") end),
   awful.key({ winkey }, "w", function () awful.util.spawn("luakit") end),

   awful.key({ winkey, "Shift" }, "r", awesome.restart),
   awful.key({ winkey, "Shift" }, "q", awesome.quit),

   awful.key({}, "XF86AudioPlay", function () awful.util.spawn_with_shell("mpc toggle") end),
   awful.key({}, "XF86AudioStop", function () awful.util.spawn_with_shell("mpc pause") end),
   awful.key({}, "XF86AudioPrev", function () awful.util.spawn_with_shell("mpc prev") end),
   awful.key({}, "XF86AudioNext", function () awful.util.spawn_with_shell("mpc next") end)

                                  )

for i = 1, 3 do
   globalkeys = awful.util.table.join(
      globalkeys,
      -- View tag only.
      awful.key({ winkey }, "#" .. i + 9,
                function ()
                   local screen = mouse.screen
                   local tag = awful.tag.gettags(screen)[i]
                   if tag then
                      awful.tag.viewonly(tag)
                   end
                end),
      -- Move client to tag.
      awful.key({ winkey, "Shift" }, "#" .. i + 9,
                function ()
                   if client.focus then
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if tag then
                         awful.client.movetotag(tag)
                         awful.tag.viewonly(tag)
                      end
                   end
                end))
end

GRID_WIDTH = 4

function round (n) return math.floor(n + 0.5) end

function get_grid(w)
   local winFrame = w:geometry(r)
   local screenRect = screen[1].workarea

   local thirdScreenWidth = screenRect.width / GRID_WIDTH
   local halfScreenHeight = screenRect.height / 2

   local g = {
      x = round((winFrame.x - screenRect.x) / thirdScreenWidth),
      y = round((winFrame.y - screenRect.y) / halfScreenHeight),
      width  = round(math.max(1, winFrame.width / thirdScreenWidth)),
      height = round(math.max(1, winFrame.height / halfScreenHeight)),
   }

   return g
end

function set_grid(w, grid)
   local screenRect = screen[1].workarea
   local thirdScreenWidth = screenRect.width / GRID_WIDTH
   local halfScreenHeight = screenRect.height / 2

   local newFrame = {
      x = (grid.x * thirdScreenWidth) + screenRect.x,
      y = (grid.y * halfScreenHeight) + screenRect.y,
      width = grid.width * thirdScreenWidth,
      height = grid.height * halfScreenHeight,
   }

   newFrame.width = newFrame.width - (beautiful.border_width * 2)
   newFrame.height = newFrame.height - (beautiful.border_width * 2)

   local margin = 0
   newFrame.x = newFrame.x + margin
   newFrame.y = newFrame.y + margin
   newFrame.width = newFrame.width - (margin * 2)
   newFrame.height = newFrame.height - (margin * 2)

   w:geometry(newFrame)
end

function changeGridWidth(n)
   GRID_WIDTH = math.max(1, GRID_WIDTH + n)
   naughty.notify({text = "grid is now " .. GRID_WIDTH})
end

function snap_to_grid(w)
   set_grid(w, get_grid(w))
end

clientkeys = awful.util.table.join(

   awful.key(mash, "h",
             function (c)
                local w = client.focus
                local f = get_grid(w)
                f.x = math.max(f.x - 1, 0)
                set_grid(w, f)
             end),

   awful.key(mash, "l",
             function (c)
                local w = client.focus
                local f = get_grid(w)
                f.x = math.min(f.x + 1, GRID_WIDTH - f.width)
                set_grid(w, f)
             end),

   awful.key(mash, "i",
             function (c)
                local w = client.focus
                local f = get_grid(w)
                f.width = math.max(f.width - 1, 1)
                set_grid(w, f)
             end),

   awful.key(mash, "o",
             function (c)
                local w = client.focus
                local f = get_grid(w)
                f.width = math.min(f.width + 1, GRID_WIDTH)
                set_grid(w, f)
             end),

   awful.key(mash, "j",
             function (c)
                local w = client.focus
                local f = get_grid(w)
                f.y = 1
                f.height = 1
                set_grid(w, f)
             end),

   awful.key(mash, "k",
             function (c)
                local w = client.focus
                local f = get_grid(w)
                f.y = 0
                f.height = 1
                set_grid(w, f)
             end),

   awful.key(mash, "u",
             function (c)
                local w = client.focus
                local f = get_grid(w)
                f.y = 0
                f.height = 2
                set_grid(w, f)
             end),

   awful.key(mash, ";", function (c) snap_to_grid(client.focus) end),
   awful.key(mash, "'", function (c) for i, w in pairs(client.get()) do snap_to_grid(w) end end),

   awful.key(mash, "m",
             function (c)
                local w = client.focus
                set_grid(w, {x = 0, y = 0, width = GRID_WIDTH, height = 2})
             end),

   awful.key(mash, "-", function (c) changeGridWidth(-1) end),
   awful.key(mash, "=", function (c) changeGridWidth(1) end),

   awful.key({ winkey, "Shift"   }, "c", function (c) c:kill() end))

clientbuttons = awful.util.table.join(
   awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
   awful.button({ winkey }, 1, awful.mouse.client.move),
   awful.button({ winkey }, 3, awful.mouse.client.resize))

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

      snap_to_grid(c)
   end
end

client.connect_signal("manage", manage_window)

client.connect_signal("focus",   function(c) c.border_color = beautiful.border_focus  end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- for i, w in pairs(client.get()) do
--    snap_to_grid(w)
-- end
