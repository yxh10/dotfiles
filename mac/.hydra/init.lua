hydra.alert("Hi! Wanna manage some windows?")

local mash = {"cmd", "alt", "ctrl"}
local mashshift = {"cmd", "alt", "shift"}

local MARGINX = 5
local MARGINY = 5
local GRIDWIDTH = 3

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function hydra.window:getgrid()
  local winframe = self:frame()
  local screenrect = self:screen():frame_without_dock_or_menu()
  local thirdscreenwidth = screenrect.w / GRIDWIDTH
  local halfscreenheight = screenrect.h / 2
  return {
    x = round((winframe.x - screenrect.x) / thirdscreenwidth),
    y = round((winframe.y - screenrect.y) / halfscreenheight),
    w = math.max(1, round(winframe.w / thirdscreenwidth)),
    h = math.max(1, round(winframe.h / halfscreenheight)),
  }
end

function hydra.window:setgrid(grid, screen)
  local screenrect = screen:frame_without_dock_or_menu()
  local thirdscreenwidth = screenrect.w / GRIDWIDTH
  local halfscreenheight = screenrect.h / 2
  local newframe = {
    x = (grid.x * thirdscreenwidth) + screenrect.x,
    y = (grid.y * halfscreenheight) + screenrect.y,
    w = grid.w * thirdscreenwidth,
    h = grid.h * halfscreenheight,
  }

  newframe.x = newframe.x + MARGINX
  newframe.y = newframe.y + MARGINY
  newframe.w = newframe.w - (MARGINX * 2)
  newframe.h = newframe.h - (MARGINY * 2)

  self:setframe(newframe)
end

function snaptogrid(win)
  if win:isstandard() then
    win:setgrid(win:getgrid(), win:screen())
  end
end

local function adjustgridwidth(by)
  GRIDWIDTH = math.max(1, GRIDWIDTH + by)
  hydra.alert("grid is now " .. tostring(GRIDWIDTH) .. " tiles wide", 1)
  hydra.fn.map(hydra.window.visiblewindows(), snaptogrid)
end

local function adjust_focused_window(fn)
  local win = hydra.window.focusedwindow()
  local f = win:getgrid()
  fn(f)
  win:setgrid(f, win:screen())
end

local function opendictionary()
  hydra.alert("Lexicon, at your service.", 1)
  hydra.app.launchorfocus("Dictionary")
end

hydra.hotkey.bind(mash, 'D', opendictionary)

hydra.hotkey.bind(mash, ';', function() snaptogrid(hydra.window.focusedwindow()) end)
hydra.hotkey.bind(mash, "'", function() hydra.fn.map(hydra.window.focusedwindow(), snaptogrid) end)

hydra.hotkey.bind(mash, '=', function() adjustgridwidth( 1) end)
hydra.hotkey.bind(mash, '-', function() adjustgridwidth(-1) end)

hydra.hotkey.bind(mashshift, 'H', function() hydra.window.focusedwindow():focuswindow_west() end)
hydra.hotkey.bind(mashshift, 'L', function() hydra.window.focusedwindow():focuswindow_east() end)
hydra.hotkey.bind(mashshift, 'K', function() hydra.window.focusedwindow():focuswindow_north() end)
hydra.hotkey.bind(mashshift, 'J', function() hydra.window.focusedwindow():focuswindow_south() end)

local function maximize_window()
  local win = hydra.window.focusedwindow()
  local f = {x = 0, y = 0, w = GRIDWIDTH, h = 2}
  win:setgrid(f, win:screen())
end

local function pushwindow_nextscreen()
  local win = hydra.window.focusedwindow()
  win:setgrid(win:getgrid(), win:screen():next())
end

local function pushwindow_prevscreen()
  local win = hydra.window.focusedwindow()
  win:setgrid(win:getgrid(), win:screen():previous())
end

local function pushwindow_left()
  adjust_focused_window(function(f) f.x = math.max(f.x - 1, 0) end)
end

local function pushwindow_right()
  adjust_focused_window(function(f) f.x = math.min(f.x + 1, GRIDWIDTH - f.w) end)
end

local function resizewindow_wider()
  adjust_focused_window(function(f) f.w = math.min(f.w + 1, GRIDWIDTH - f.x) end)
end

local function resizewindow_thinner()
  adjust_focused_window(function(f) f.w = math.max(f.w - 1, 1) end)
end

local function pushwindow_down()
  adjust_focused_window(function(f) f.y = 1; f.h = 1 end)
end

local function pushwindow_up()
  adjust_focused_window(function(f) f.y = 0; f.h = 1 end)
end

local function resizewindow_taller()
  adjust_focused_window(function(f) f.y = 0; f.h = 2 end)
end

hydra.hotkey.bind(mash, 'M', maximize_window)
hydra.hotkey.bind(mash, 'N', pushwindow_nextscreen)
hydra.hotkey.bind(mash, 'P', pushwindow_prevscreen)

hydra.hotkey.bind(mash, 'H', pushwindow_left)
hydra.hotkey.bind(mash, 'L', pushwindow_right)
hydra.hotkey.bind(mash, 'O', resizewindow_wider)
hydra.hotkey.bind(mash, 'I', resizewindow_thinner)

hydra.hotkey.bind(mash, 'J', pushwindow_down)
hydra.hotkey.bind(mash, 'K', pushwindow_up)
hydra.hotkey.bind(mash, 'U', resizewindow_taller)
