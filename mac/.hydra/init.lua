api.alert("Hi! Wanna manage some windows?")

api.timer.once(function()
    api.pathwatcher(os.getenv("HOME") .. "/.hydra/", api.reload):start()
end)


api.autolaunch.set(true)

local function menufn()
  return {
    {title = "About Hydra", fn = api.showabout},
    {title = "-"},
    {title = "Quit", fn = os.exit},
  }
end

api.menu.show(menufn)

local mash = {"cmd", "alt", "ctrl"}
local mashshift = {"cmd", "alt", "shift"}

local MARGINX = 5
local MARGINY = 5
local GRIDWIDTH = 3

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function api.window:getgrid()
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

function api.window:setgrid(grid, screen)
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
  api.alert("grid is now " .. tostring(GRIDWIDTH) .. " tiles wide", 1)
  api.fn.map(api.window.visiblewindows(), snaptogrid)
end

local function adjust_focused_window(fn)
  local win = api.window.focusedwindow()
  local f = win:getgrid()
  fn(f)
  win:setgrid(f, win:screen())
end

local function opendictionary()
  api.alert("Lexicon, at your service.", 1)
  api.app.launchorfocus("Dictionary")
end

api.hotkey.bind(mash, 'D', opendictionary)

api.hotkey.bind(mash, ';', function() snaptogrid(api.window.focusedwindow()) end)
api.hotkey.bind(mash, "'", function() api.fn.map(api.window.focusedwindow(), snaptogrid) end)

api.hotkey.bind(mash, '=', function() adjustgridwidth( 1) end)
api.hotkey.bind(mash, '-', function() adjustgridwidth(-1) end)

api.hotkey.bind(mashshift, 'H', function() api.window.focusedwindow():focuswindow_west() end)
api.hotkey.bind(mashshift, 'L', function() api.window.focusedwindow():focuswindow_east() end)
api.hotkey.bind(mashshift, 'K', function() api.window.focusedwindow():focuswindow_north() end)
api.hotkey.bind(mashshift, 'J', function() api.window.focusedwindow():focuswindow_south() end)

local function maximize_window()
  local win = api.window.focusedwindow()
  local f = {x = 0, y = 0, w = GRIDWIDTH, h = 2}
  win:setgrid(f, win:screen())
end

local function pushwindow_nextscreen()
  local win = api.window.focusedwindow()
  win:setgrid(win:getgrid(), win:screen():next())
end

local function pushwindow_prevscreen()
  local win = api.window.focusedwindow()
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

api.hotkey.bind(mash, 'M', maximize_window)
api.hotkey.bind(mash, 'N', pushwindow_nextscreen)
api.hotkey.bind(mash, 'P', pushwindow_prevscreen)

api.hotkey.bind(mash, 'H', pushwindow_left)
api.hotkey.bind(mash, 'L', pushwindow_right)
api.hotkey.bind(mash, 'O', resizewindow_wider)
api.hotkey.bind(mash, 'I', resizewindow_thinner)

api.hotkey.bind(mash, 'J', pushwindow_down)
api.hotkey.bind(mash, 'K', pushwindow_up)
api.hotkey.bind(mash, 'U', resizewindow_taller)
