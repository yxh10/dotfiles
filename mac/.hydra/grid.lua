api.ext.grid = {}

api.ext.grid.MARGINX = 5
api.ext.grid.MARGINY = 5
api.ext.grid.GRIDWIDTH = 3

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function api.ext.grid.get(win)
  local winframe = win:frame()
  local screenrect = win:screen():frame_without_dock_or_menu()
  local thirdscreenwidth = screenrect.w / api.ext.grid.GRIDWIDTH
  local halfscreenheight = screenrect.h / 2
  return {
    x = round((winframe.x - screenrect.x) / thirdscreenwidth),
    y = round((winframe.y - screenrect.y) / halfscreenheight),
    w = math.max(1, round(winframe.w / thirdscreenwidth)),
    h = math.max(1, round(winframe.h / halfscreenheight)),
  }
end

function api.ext.grid.set(win, grid, screen)
  local screenrect = screen:frame_without_dock_or_menu()
  local thirdscreenwidth = screenrect.w / api.ext.grid.GRIDWIDTH
  local halfscreenheight = screenrect.h / 2
  local newframe = {
    x = (grid.x * thirdscreenwidth) + screenrect.x,
    y = (grid.y * halfscreenheight) + screenrect.y,
    w = grid.w * thirdscreenwidth,
    h = grid.h * halfscreenheight,
  }

  newframe.x = newframe.x + api.ext.grid.MARGINX
  newframe.y = newframe.y + api.ext.grid.MARGINY
  newframe.w = newframe.w - (api.ext.grid.MARGINX * 2)
  newframe.h = newframe.h - (api.ext.grid.MARGINY * 2)

  win:setframe(newframe)
end

function api.ext.grid.snap(win)
  if win:isstandard() then
    api.ext.grid.set(win, api.ext.grid.get(win), win:screen())
  end
end

function api.ext.grid.adjustwidth(by)
  api.ext.grid.GRIDWIDTH = math.max(1, api.ext.grid.GRIDWIDTH + by)
  api.alert("grid is now " .. tostring(api.ext.grid.GRIDWIDTH) .. " tiles wide", 1)
  api.fn.map(api.window.visiblewindows(), api.ext.grid.snap)
end

function api.ext.grid.adjust_focused_window(fn)
  local win = api.window.focusedwindow()
  local f = api.ext.grid.get(win)
  fn(f)
  api.ext.grid.set(win, f, win:screen())
end

function api.ext.grid.maximize_window()
  local win = api.window.focusedwindow()
  local f = {x = 0, y = 0, w = api.ext.grid.GRIDWIDTH, h = 2}
  api.ext.grid.set(win, f, win:screen())
end

function api.ext.grid.pushwindow_nextscreen()
  local win = api.window.focusedwindow()
  api.ext.grid.set(win, api.ext.grid.get(win), win:screen():next())
end

function api.ext.grid.pushwindow_prevscreen()
  local win = api.window.focusedwindow()
  api.ext.grid.set(win, api.ext.grid.get(win), win:screen():previous())
end

function api.ext.grid.pushwindow_left()
  api.ext.grid.adjust_focused_window(function(f) f.x = math.max(f.x - 1, 0) end)
end

function api.ext.grid.pushwindow_right()
  api.ext.grid.adjust_focused_window(function(f) f.x = math.min(f.x + 1, api.ext.grid.GRIDWIDTH - f.w) end)
end

function api.ext.grid.resizewindow_wider()
  api.ext.grid.adjust_focused_window(function(f) f.w = math.min(f.w + 1, api.ext.grid.GRIDWIDTH - f.x) end)
end

function api.ext.grid.resizewindow_thinner()
  api.ext.grid.adjust_focused_window(function(f) f.w = math.max(f.w - 1, 1) end)
end

function api.ext.grid.pushwindow_down()
  api.ext.grid.adjust_focused_window(function(f) f.y = 1; f.h = 1 end)
end

function api.ext.grid.pushwindow_up()
  api.ext.grid.adjust_focused_window(function(f) f.y = 0; f.h = 1 end)
end

function api.ext.grid.resizewindow_taller()
  api.ext.grid.adjust_focused_window(function(f) f.y = 0; f.h = 2 end)
end
