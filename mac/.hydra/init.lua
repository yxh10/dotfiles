require("grid")

api.alert("Hydra, at your service.")

api.pathwatcher.new(os.getenv("HOME") .. "/.hydra/", api.reload):start()
api.autolaunch.set(true)

api.menu.show(function()
    return {
      {title = "About Hydra", fn = api.showabout},
      {title = "-"},
      {title = "Quit", fn = os.exit},
    }
end)

local mash = {"cmd", "alt", "ctrl"}
local mashshift = {"cmd", "alt", "shift"}

local function opendictionary()
  api.alert("Lexicon, at your service.", 0.75)
  api.app.launchorfocus("Dictionary")
end

api.hotkey.bind(mash, 'D', opendictionary)

api.hotkey.bind(mash, ';', function() api.ext.grid.snap(api.window.focusedwindow()) end)
api.hotkey.bind(mash, "'", function() api.fn.map(api.window.visiblewindows(), api.ext.grid.snap) end)

api.hotkey.bind(mash, '=', function() api.ext.grid.adjustwidth( 1) end)
api.hotkey.bind(mash, '-', function() api.ext.grid.adjustwidth(-1) end)

api.hotkey.bind(mashshift, 'H', function() api.window.focusedwindow():focuswindow_west() end)
api.hotkey.bind(mashshift, 'L', function() api.window.focusedwindow():focuswindow_east() end)
api.hotkey.bind(mashshift, 'K', function() api.window.focusedwindow():focuswindow_north() end)
api.hotkey.bind(mashshift, 'J', function() api.window.focusedwindow():focuswindow_south() end)

api.hotkey.bind(mash, 'M', api.ext.grid.maximize_window)

api.hotkey.bind(mash, 'N', api.ext.grid.pushwindow_nextscreen)
api.hotkey.bind(mash, 'P', api.ext.grid.pushwindow_prevscreen)

api.hotkey.bind(mash, 'J', api.ext.grid.pushwindow_down)
api.hotkey.bind(mash, 'K', api.ext.grid.pushwindow_up)
api.hotkey.bind(mash, 'H', api.ext.grid.pushwindow_left)
api.hotkey.bind(mash, 'L', api.ext.grid.pushwindow_right)

api.hotkey.bind(mash, 'U', api.ext.grid.resizewindow_taller)
api.hotkey.bind(mash, 'O', api.ext.grid.resizewindow_wider)
api.hotkey.bind(mash, 'I', api.ext.grid.resizewindow_thinner)

api.hotkey.bind(mash, 'X', api.log.show)
api.hotkey.bind(mash, "R", api.repl.open)

api.updates.check()

-- api.log.rawprint(api.jsondocs())

-- s = "dog!🐶"
-- api.alert(s)

-- for i, v in ipairs(api.utf8.chars(s)) do
--   api.alert(v, 5)
-- end

-- s2 = table.concat(api.utf8.chars(s))
-- api.alert(s2)
-- api.alert(api.utf8.count(s2))
