local awful = require("awful")
local naughty = require("naughty")
local grid = require("sd/util/grid")

local cycle_through_windows = function(dir)
   awful.client.focus.byidx(dir)
   if client.focus then
      client.focus:raise()
   end
end

local globalkeys = awful.util.table.join(

   awful.key({ WINKEY          }, "Tab", function () cycle_through_windows(1) end),
   awful.key({ WINKEY, "Shift" }, "Tab", function () cycle_through_windows(-1) end),

   awful.key(MASH_SHIFT, "h", function () awful.client.focus.bydirection("left") ; client.focus:raise() end),
   awful.key(MASH_SHIFT, "l", function () awful.client.focus.bydirection("right"); client.focus:raise() end),
   awful.key(MASH_SHIFT, "j", function () awful.client.focus.bydirection("down") ; client.focus:raise() end),
   awful.key(MASH_SHIFT, "k", function () awful.client.focus.bydirection("up"); client.focus:raise() end),

   awful.key({ WINKEY }, "e", function () awful.util.spawn_with_shell("emacsclient -nc -a '' ~/projects") end),
   awful.key({ WINKEY }, " ", function () awful.util.spawn_with_shell("dmenu_run") end),
   awful.key({ WINKEY }, "Return", function () awful.util.spawn("urxvt") end),
   awful.key({ WINKEY }, "w", function () awful.util.spawn("conk") end),
   awful.key({ WINKEY }, "p", function () awful.util.spawn("play") end),

   awful.key({ WINKEY, "Shift" }, "r", awesome.restart),
   awful.key({ WINKEY, "Shift" }, "q", awesome.quit),

   awful.key({ WINKEY }, "Home", function() change_volume("+2") end),
   awful.key({ WINKEY }, "End",  function() change_volume("-2") end),

   awful.key({ WINKEY }, "r",
             function()
                local sel = selection()
                local result = awful.util.eval(sel)
                naughty.notify({text = result})
             end),

   awful.key({}, "XF86AudioPlay", function () awful.util.spawn_with_shell("mpc toggle") end),
   awful.key({}, "XF86AudioStop", function () awful.util.spawn_with_shell("mpc pause") end),
   awful.key({}, "XF86AudioPrev", function () awful.util.spawn_with_shell("mpc prev") end),
   awful.key({}, "XF86AudioNext", function () awful.util.spawn_with_shell("mpc next") end),

   awful.key(MASH, "'",
             function (c)
                for i, w in pairs(client.get()) do
                   grid.snap_to_grid(w)
                end
             end)

)

for i = 1, 3 do
   globalkeys = awful.util.table.join(
      globalkeys,

      -- View tag only.
      awful.key({ WINKEY }, "#" .. i + 9,
                function ()
                   local screen = mouse.screen
                   local tag = awful.tag.gettags(screen)[i]
                   if tag then
                      awful.tag.viewonly(tag)
                   end
                end),

      -- Move client to tag.
      awful.key({ WINKEY, "Shift" }, "#" .. i + 9,
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

return globalkeys
