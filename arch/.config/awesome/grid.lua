local beautiful = require("beautiful")

GRID_WIDTH = 4

local grid = {}

function grid.get_grid(w)
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

function grid.set_grid(w, grid)
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

function grid.change_grid_width(n)
   GRID_WIDTH = math.max(1, GRID_WIDTH + n)
   naughty.notify({text = "grid is now " .. GRID_WIDTH})
end

function grid.snap_to_grid(w)
   grid.set_grid(w, grid.get_grid(w))
end

return grid
