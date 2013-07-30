mash = ["cmd", "alt", "ctrl"]

API.bind 'H', mash do
  win = API.focused_window
  r = win.get_grid
  r.x = [r.x - 1, 0].max
  win.set_grid r, nil
end

API.bind 'L', mash do
  win = API.focused_window
  r = win.get_grid
  r.x = [r.x + 1, $window_grid_width - r.w].min
  win.set_grid r, nil
end

API.bind 'O', mash do
  win = API.focused_window
  r = win.get_grid
  r.w = [r.w + 1, $window_grid_width - r.x].min
  win.set_grid r, nil
end

API.bind 'I', mash do
  win = API.focused_window
  r = win.get_grid
  r.w = [r.w - 1, 1].max
  win.set_grid r, nil
end

API.bind 'J', mash do
  win = API.focused_window
  r = win.get_grid
  r.y = 1
  r.h = 1
  win.set_grid r, nil
end

API.bind 'K', mash do
  win = API.focused_window
  r = win.get_grid
  r.y = 0
  r.h = 1
  win.set_grid r, nil
end

API.bind 'U', mash do
  win = API.focused_window
  r = win.get_grid
  r.y = 0
  r.h = 2
  win.set_grid r, nil
end


API.bind "D", mash do

  # win = API.focused_window
  # f = win.top_left
  # p f.x
  # f.w += 7
  # p f.w
  # p f.h
  # puts
  # f.w += 10

  # win.size = f

  point = Rect.new
  p point.w
  point.w = 2.3
  p point.w
  p point.integral!.w
  p point.w

end
