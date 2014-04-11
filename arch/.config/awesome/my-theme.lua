local icons_dir = "~/.config/awesome/icons/"

local theme = {}

theme.font          = "DejaVu Sans 7"
theme.wallpaper     = "~/.config/awesome/wallpapers/bg2.jpg"

theme.bg_normal     = "#222222"
theme.bg_focus      = "#535d6c"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = "#444444"
theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#aaaaaa"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"

theme.border_width  = 5
theme.border_normal = "#000000"
theme.border_focus  = "#119933"
theme.border_marked = "#91231c"

-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]

theme.taglist_squares_sel   = icons_dir .. "/square_sel.png"
theme.taglist_squares_unsel = icons_dir .. "/square_unsel.png"

-- theme.widget_cpu       = icons_dir .. "/cpu.png"
-- theme.widget_music     = icons_dir .. "/note.png"
-- theme.widget_music_on  = icons_dir .. "/note_on.png"

theme.widget_volume         = icons_dir .. "/volume.png"
theme.widget_volume_low     = icons_dir .. "/volume_low.png"
theme.widget_volume_no      = icons_dir .. "/volume_no.png"
theme.widget_volume_mute    = icons_dir .. "/volume_mute.png"
theme.widget_disk           = icons_dir .. "/disk.png"
theme.widget_temp           = icons_dir .. "/temp.png"
theme.widget_memory         = icons_dir .. "/memory.png"
theme.widget_battery        = icons_dir .. "/battery.png"
theme.widget_battery_ac     = icons_dir .. "/battery_ac.png"
theme.widget_battery_low    = icons_dir .. "/battery_low.png"
theme.widget_battery_empty  = icons_dir .. "/battery_empty.png"
theme.widget_background     = icons_dir .. "/bar_background.png"
theme.widget_clock          = icons_dir .. "/clock.png"

theme.widget_yay_color = "#55bb55"
theme.widget_meh_color = "#bbbb55"
theme.widget_aww_color = "#bb5555"
theme.widget_memory_color = "#44aaaa"
theme.widget_volume_color = "#aa44aa"

theme.battery_dead_notice = {
   title = "Battery exhausted",
   text = "Shutdown imminent",
   timeout = 15,
   fg = "#ffffff",
   bg = "#660000",
   border_width = 5,
   border_color = "#660000",
   font = "Terminus 10"
}

return theme
