local awful = require("awful")
local grid = require("sd/util/grid")

return awful.util.table.join(

   awful.key(MASH, "h",
             function (c)
                local w = client.focus
                local f = grid.get_grid(w)
                f.x = math.max(f.x - 1, 0)
                grid.set_grid(w, f)
             end),

   awful.key(MASH, "l",
             function (c)
                local w = client.focus
                local f = grid.get_grid(w)
                f.x = math.min(f.x + 1, GRID_WIDTH - f.width)
                grid.set_grid(w, f)
             end),

   awful.key(MASH, "i",
             function (c)
                local w = client.focus
                local f = grid.get_grid(w)
                f.width = math.max(f.width - 1, 1)
                grid.set_grid(w, f)
             end),

   awful.key(MASH, "o",
             function (c)
                local w = client.focus
                local f = grid.get_grid(w)
                f.width = math.min(f.width + 1, GRID_WIDTH)
                grid.set_grid(w, f)
             end),

   awful.key(MASH, "j",
             function (c)
                local w = client.focus
                local f = grid.get_grid(w)
                f.y = 1
                f.height = 1
                grid.set_grid(w, f)
             end),

   awful.key(MASH, "k",
             function (c)
                local w = client.focus
                local f = grid.get_grid(w)
                f.y = 0
                f.height = 1
                grid.set_grid(w, f)
             end),

   awful.key(MASH, "u",
             function (c)
                local w = client.focus
                local f = grid.get_grid(w)
                f.y = 0
                f.height = 2
                grid.set_grid(w, f)
             end),

   awful.key(MASH, ";", function (c) grid.snap_to_grid(client.focus) end),

   awful.key(MASH, "m",
             function (c)
                local w = client.focus
                grid.set_grid(w, {x = 0, y = 0, width = GRID_WIDTH, height = 2})
             end),

   awful.key(MASH, "-", function (c) grid.change_grid_width(-1) end),
   awful.key(MASH, "=", function (c) grid.change_grid_width(1) end),

   awful.key({ WINKEY, "Shift"   }, "c", function (c) c:kill() end)

)
