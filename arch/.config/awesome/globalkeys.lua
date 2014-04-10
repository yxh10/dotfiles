local awful = require("awful")

local cycle_through_windows = function(dir)
   awful.client.focus.byidx(dir)
   if client.focus then
      client.focus:raise()
   end
end

local globalkeys = awful.util.table.join(

   awful.key({ winkey          }, "Tab", function () cycle_through_windows(1) end),
   awful.key({ winkey, "Shift" }, "Tab", function () cycle_through_windows(-1) end),

   awful.key(mash_shift, "h", function () awful.client.focus.bydirection("left") ; client.focus:raise() end),
   awful.key(mash_shift, "l", function () awful.client.focus.bydirection("right"); client.focus:raise() end),
   awful.key(mash_shift, "j", function () awful.client.focus.bydirection("down") ; client.focus:raise() end),
   awful.key(mash_shift, "k", function () awful.client.focus.bydirection("up"); client.focus:raise() end),

   awful.key({ winkey }, "e", function () awful.util.spawn_with_shell("emacsclient -nc -a '' ~/projects") end),
   awful.key({ winkey }, " ", function () awful.util.spawn_with_shell("dmenu_run") end),
   awful.key({ winkey }, "Return", function () awful.util.spawn("urxvt") end),
   awful.key({ winkey }, "w", function () awful.util.spawn("conk") end),

   awful.key({ winkey, "Shift" }, "r", awesome.restart),
   awful.key({ winkey, "Shift" }, "q", awesome.quit),

   awful.key({ winkey }, "r",
             function()
                local sel = selection()
                local result = awful.util.eval(sel)
                naughty.notify({text = result})
             end),

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

return globalkeys
