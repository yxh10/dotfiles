require '~/projects/zephyros/libs/zephyros.rb'

mash = ["cmd", "alt", "ctrl"]
mash_shift = ["cmd", "alt", "shift"]

$window_grid_width = 4

API.bind('D', mash) { `open -a Dictionary` }

API.bind('X', mash) do
  actions = {
    'Zephyros' => -> { `open /Users/sdegutis/projects/Zephyros/Zephyros.xcodeproj` },
    'Zephyros README' => -> { `open -aemacs /Users/sdegutis/projects/Zephyros/README.md` },
    'Open email' => -> { 2.times {|i| `open https://mail.google.com/mail/u/#{i}/#inbox` } },
    'Show clipboard' => -> { API.alert API.clipboard_contents, 3 },
  }
  action_names = actions.keys

  API.choose_from action_names, 'Do Something' do |i|
    actions[action_names[i]].call if i
  end
end

class Window

  def snap_to_grid
    self.set_grid get_grid, nil if normal_window?
  end

end

def change_grid_width(by)
  $window_grid_width += by
  API.alert "grid is now #{$window_grid_width} tiles wide"
  API.visible_windows.each(&:snap_to_grid)
end

API.bind(';', mash) { API.focused_window.snap_to_grid }
API.bind("'", mash) { API.visible_windows.map(&:snap_to_grid) }

API.bind('=', mash) { change_grid_width +1 }
API.bind('-', mash) { change_grid_width -1 }

API.bind('H', mash_shift) { API.focused_window.focus_window_left }
API.bind('L', mash_shift) { API.focused_window.focus_window_right }
API.bind('K', mash_shift) { API.focused_window.focus_window_up }
API.bind('J', mash_shift) { API.focused_window.focus_window_down }

API.bind 'M', mash do
  win = API.focused_window
  f = win.screen.frame_without_dock_or_menu
  f.inset! $window_grid_margin_x, $window_grid_margin_y
  win.frame = f
end

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



wait_on_callbacks
