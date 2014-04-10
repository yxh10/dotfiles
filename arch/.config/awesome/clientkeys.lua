local awful = require("awful")
local beautiful = require("beautiful")
local grid = require("grid")

return awful.util.table.join(

   awful.key(mash, "h",
             function (c)
                local w = client.focus
                local f = grid.get_grid(w)
                f.x = math.max(f.x - 1, 0)
                grid.set_grid(w, f)
             end),

   awful.key(mash, "l",
             function (c)
                local w = client.focus
                local f = grid.get_grid(w)
                f.x = math.min(f.x + 1, GRID_WIDTH - f.width)
                grid.set_grid(w, f)
             end),

   awful.key(mash, "i",
             function (c)
                local w = client.focus
                local f = grid.get_grid(w)
                f.width = math.max(f.width - 1, 1)
                grid.set_grid(w, f)
             end),

   awful.key(mash, "o",
             function (c)
                local w = client.focus
                local f = grid.get_grid(w)
                f.width = math.min(f.width + 1, GRID_WIDTH)
                grid.set_grid(w, f)
             end),

   awful.key(mash, "j",
             function (c)
                local w = client.focus
                local f = grid.get_grid(w)
                f.y = 1
                f.height = 1
                grid.set_grid(w, f)
             end),

   awful.key(mash, "k",
             function (c)
                local w = client.focus
                local f = grid.get_grid(w)
                f.y = 0
                f.height = 1
                grid.set_grid(w, f)
             end),

   awful.key(mash, "u",
             function (c)
                local w = client.focus
                local f = grid.get_grid(w)
                f.y = 0
                f.height = 2
                grid.set_grid(w, f)
             end),

   awful.key(mash, ";", function (c) grid.snap_to_grid(client.focus) end),
   awful.key(mash, "'",
             function (c)
                for i, w in pairs(client.get()) do
                   grid.snap_to_grid(w)
                end
             end),

   awful.key(mash, "m",
             function (c)
                local w = client.focus
                grid.set_grid(w, {x = 0, y = 0, width = GRID_WIDTH, height = 2})
             end),

   awful.key(mash, "-", function (c) grid.change_grid_width(-1) end),
   awful.key(mash, "=", function (c) grid.change_grid_width(1) end),

   awful.key({ winkey, "Shift"   }, "c", function (c) c:kill() end)

                            )
