# treats the screen like a grid, and lets you move/resize windows along it

mash = ["cmd", "alt", "ctrl"]
mash_shift = ["cmd", "alt", "shift"]

api.settings().alertAnimates = false

bind "D", mash, -> open('/Applications/Dictionary.app')

bind "=", mash, -> changeGridWidth Window.gridWidth + 1
bind "-", mash, -> changeGridWidth Window.gridWidth - 1

bind ";", mash, -> snapWindowToGrid api.focusedWindow()
bind "'", mash, -> _.each api.visibleWindows(), snapWindowToGrid

bind "H", mash_shift, -> api.focusedWindow().focusWindowLeft()
bind "L", mash_shift, -> api.focusedWindow().focusWindowRight()
bind "K", mash_shift, -> api.focusedWindow().focusWindowUp()
bind "J", mash_shift, -> api.focusedWindow().focusWindowDown()

bind "M", mash, -> maximizeWin api.focusedWindow()

bind 'S', mash, -> shell '/usr/bin/say', [api.selectedText()]
bind 'E', mash, -> alert api.selectedText()



maximizeWin = (win) -> win.setGrid {x: 0, y: 0, w: Window.gridWidth, h:2}

# center
bind "C", mash, ->
  win = api.focusedWindow()
  f = win.screen().frameWithoutDockOrMenu()
  f.size.width /= 2
  f.size.height /= 2
  f.origin.x += f.size.width / 2
  f.origin.y += f.size.height / 2
  win.setFrame f



changeGridWidth = (n) ->
  Window.gridWidth = n
  alert "Grid is now " + Window.gridWidth + " tiles wide"
  _.each api.visibleWindows(), snapWindowToGrid



# move left
bind "H", mash, ->
  win = api.focusedWindow()
  r = win.getGrid()
  r.x = Math.max(r.x - 1, 0)
  win.setGrid r

# move right
bind "L", mash, ->
  win = api.focusedWindow()
  r = win.getGrid()
  r.x = Math.min(r.x + 1, Window.gridWidth - r.w)
  win.setGrid r

# grow to right
bind "O", mash, ->
  win = api.focusedWindow()
  r = win.getGrid()
  r.w = Math.min(r.w + 1, Window.gridWidth - r.x)
  win.setGrid r

# shrink from right
bind "I", mash, ->
  win = api.focusedWindow()
  r = win.getGrid()
  r.w = Math.max(r.w - 1, 1)
  win.setGrid r

# move to upper row
bind "K", mash, ->
  win = api.focusedWindow()
  r = win.getGrid()
  r.y = 0
  r.h = 1
  win.setGrid r

# move to lower row
bind "J", mash, ->
  win = api.focusedWindow()
  r = win.getGrid()
  r.y = 1
  r.h = 1
  win.setGrid r

# fill whole vertical column
bind "U", mash, ->
  win = api.focusedWindow()
  r = win.getGrid()
  r.y = 0
  r.h = 2
  win.setGrid r

# throw to next screen
bind "N", mash, ->
  win = api.focusedWindow()
  win.setGrid win.getGrid(), win.screen().nextScreen()

# throw to previous screen (come on, who ever has more than 2 screens?)
bind "P", mash, ->
  win = api.focusedWindow()
  win.setGrid win.getGrid(), win.screen().previousScreen()


snapWindowToGrid = (win) ->
  if win.isNormalWindow()
    r = win.getGrid()
    win.setGrid r

handleNewWindows = (win) ->
  switch String(win.app().title())
    when 'Google Chrome' then maximizeWin win if win.isNormalWindow()
    when 'Emacs' then snapWindowToGrid win

listen 'window_created', (win) -> handleNewWindows win
listen 'app_launched', (app) -> _.each app.visibleWindows(), handleNewWindows




script = 'tell application "System Preferences"\n
    reveal anchor "mouseTab" of pane id "com.apple.preference.mouse"\n
end tell\n
tell application "System Events" to tell process "System Preferences"\n
    click checkbox 1 of window 1\n
end tell\n
quit application "System Preferences"'

bind "B", mash, -> shell '/usr/bin/osascript', ['-e', script], null
