local beautiful = require("beautiful")
local naughty = require("naughty")

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

WINDOW_MARGIN = 3

function grid.set_grid(w, grid)
   local screenRect = screen[1].workarea

   screenRect.x = screenRect.x + WINDOW_MARGIN
   screenRect.y = screenRect.y + WINDOW_MARGIN
   screenRect.width = screenRect.width - (WINDOW_MARGIN * 2)
   screenRect.height = screenRect.height - (WINDOW_MARGIN * 2)

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

   newFrame.x = newFrame.x + WINDOW_MARGIN
   newFrame.y = newFrame.y + WINDOW_MARGIN
   newFrame.width = newFrame.width - (WINDOW_MARGIN * 2)
   newFrame.height = newFrame.height - (WINDOW_MARGIN * 2)

   w:geometry(newFrame)
end

function grid.change_grid_width(n)
   GRID_WIDTH = math.max(1, GRID_WIDTH + n)
   naughty.notify({text = "grid.width = " .. GRID_WIDTH})
end

function grid.snap_to_grid(w)
   grid.set_grid(w, grid.get_grid(w))
end

return grid
