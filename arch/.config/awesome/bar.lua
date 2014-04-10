local bar = {}


-- local left_layout = wibox.layout.fixed.horizontal()
-- left_layout:add(awful.widget.taglist(1, awful.widget.taglist.filter.all))

-- local right_layout = wibox.layout.fixed.horizontal()
-- right_layout:add(wibox.widget.systray())



-- tasklist_buttons = awful.util.table.join(
--    awful.button({ }, 1,
--                 function (c)
--                    client.focus = c
--                    c:raise()
--                 end))

-- local layout = wibox.layout.align.horizontal()
-- layout:set_left(left_layout)




-- local default_task_widget = wibox.layout.fixed.horizontal()
-- -- local default_task_widget_with_margins = wibox.layout.margin()
-- -- default_task_widget_with_margins:set_widget(default_task_widget)
-- -- default_task_widget_with_margins:set_left(10)
-- -- default_task_widget_with_margins:set_right(10)

-- local padding = wibox.layout.flex.horizontal()
-- local tasklistwidget = awful.widget.tasklist(1, awful.widget.tasklist.filter.currenttags, tasklist_buttons, nil, nil, default_task_widget)

-- local task_container = wibox.layout.align.horizontal()
-- task_container:set_left(tasklistwidget)
-- task_container:set_middle(padding)

-- layout:set_middle(task_container)
-- layout:set_right(right_layout)

-- mywibox = awful.wibox({ position = "top", height = 18 })
-- mywibox:set_widget(layout)





-- spanStart = '<span '
-- spanEnd = '</span>'
-- font = 'font="Terminus 8"'
-- white = 'color="#b2b2b2"'
-- red = 'color="#e54c62"'
-- blue = 'color="#00aeff"'
-- green = 'color="#1dff00"'



-- -- TODO: add widgets.wifi,
-- --       get missing icons,
-- --       add disk-free stats using: df | grep sda | awk '{print $5}'
-- --       add widgets.volume
-- --       add gmail widget using netrc and the gmail url
-- --
-- -- decoSpace = wibox.widget.textbox('  ')
-- -- right_layout:add(decoSpace)
-- --
-- -- diskwidget = wibox.widget.textbox()
-- -- vicious.register(diskwidget, vicious.contrib.dio, "${total_mb}", 3, "sda")
-- -- right_layout:add(diskwidget)



-- decoSpace = wibox.widget.textbox('  ')
-- right_layout:add(decoSpace)















-- -- Battery
-- baticon = wibox.widget.imagebox(beautiful.bat)
-- batbar = awful.widget.progressbar()
-- batbar:set_color(beautiful.fg_normal)
-- batbar:set_width(55)
-- batbar:set_ticks(true)
-- batbar:set_ticks_size(3)
-- batbar:set_background_color(beautiful.bg_normal)
-- batmargin = wibox.layout.margin(batbar, 2, 7)
-- batmargin:set_top(6)
-- batmargin:set_bottom(6)
-- -- batupd = lain.widgets.bat({
-- --     settings = function()
-- --         if bat_now.perc == "N/A" then
-- --            batbar:set_color("#55bb55")
-- --            bat_perc = 100
-- --            baticon:set_image(beautiful.ac)
-- --         else
-- --             bat_perc = tonumber(bat_now.perc)
-- --             if bat_perc > 50 then
-- --                 batbar:set_color("#55bb55")
-- --                 baticon:set_image(beautiful.bat)
-- --             elseif bat_perc > 15 then
-- --                 batbar:set_color("#bbbb55")
-- --                 baticon:set_image(beautiful.bat_low)
-- --             else
-- --                 batbar:set_color("#bb5555")
-- --                 baticon:set_image(beautiful.bat_no)

-- --             end

-- --         end
-- --         batbar:set_value(bat_perc / 100)
-- --     end
-- -- })
-- batwidget = wibox.widget.background(batmargin)
-- batwidget:set_bgimage(beautiful.widget_bg)
-- right_layout:add(baticon)
-- right_layout:add(batwidget)


--    -- awful.key({ winkey }, "p",
--    --           function()
--    --              local bat_now = tonumber(io.lines("/sys/class/power_supply/BAT0/energy_now")())
--    --              local bat_full = tonumber(io.lines("/sys/class/power_supply/BAT0/energy_full")())
--    --              local bat = bat_now / bat_full

--    --              local bat_status = io.lines("/sys/class/power_supply/BAT0/status")()
--    --              local is_charging = bat_status == 'Charging'
--    --              local is_discharging = bat_status == 'Discharging'

--    --              if is_discharging then

--    --                 if bat <= 5 then
--    --                    local naughty = require("naughty")
--    --                    local bgcolor = "#660000"
--    --                    bat_notification_critical_preset = {
--    --                       title = "Battery exhausted",
--    --                       text = "Shutdown imminent",
--    --                       timeout = 15,
--    --                       fg = "#ffffff",
--    --                       bg = bgcolor,
--    --                       border_width = 5,
--    --                       border_color = bgcolor,
--    --                       font = "Terminus 10"
--    --                    }
--    --                    naughty.notify(bat_notification_critical_preset)
--    --                 end

--    --              end

--    --              -- naughty.notify({text = bat})
--    --           end),





















-- decoSpace = wibox.widget.textbox('  ')
-- right_layout:add(decoSpace)



-- -- CPU widget
-- iconCPU = wibox.widget.imagebox()
-- iconCPU:set_image(beautiful.widget_cpu)
-- iconCPU:buttons(awful.util.table.join(awful.button({ }, 1, function () awful.util.spawn(tasks, false) end)))
-- right_layout:add(iconCPU)

-- widgetCPU = wibox.widget.textbox()
-- vicious.register(widgetCPU, vicious.widgets.cpu, spanStart .. font .. blue .. '>1%' .. spanEnd, 3)
-- right_layout:add(widgetCPU)







-- decoSpace = wibox.widget.textbox('  ')
-- right_layout:add(decoSpace)



-- iconTemp = wibox.widget.imagebox()
-- iconTemp:set_image(beautiful.widget_temp)
-- right_layout:add(iconTemp)

-- weatherWidget = wibox.widget.textbox()
-- citycode = "4917123"
-- vicious.register(weatherWidget, vicious.contrib.openweather, spanStart .. font .. red .. ">${wind deg}°" .. spanEnd, 60, citycode)
-- right_layout:add(weatherWidget)


-- decoSpace = wibox.widget.textbox(' ')
-- right_layout:add(decoSpace)



-- -- MEM widget
-- iconMem = wibox.widget.imagebox()
-- iconMem:set_image(beautiful.widget_mem)
-- right_layout:add(iconMem)

-- widgetMem = wibox.widget.textbox()
-- vicious.register(widgetMem, vicious.widgets.mem, spanStart .. font .. blue .. '>$1% ($2gb)' .. spanEnd, 13)
-- right_layout:add(widgetMem)




-- -- iconClock = wibox.widget.imagebox()
-- -- iconClock:set_image(beautiful.widget_clock)
-- -- right_layout:add(iconClock)

-- decoSpace = wibox.widget.textbox('  ')
-- right_layout:add(decoSpace)

-- widgetClock = awful.widget.textclock(spanStart .. font .. red .. ">%a %b %d  %I:%M %p" .. spanEnd)
-- right_layout:add(widgetClock)

-- decoSpace = wibox.widget.textbox('  ')
-- right_layout:add(decoSpace)



-- -- mpdwidget = wibox.widget.textbox()
-- -- vicious.register(mpdwidget, vicious.widgets.mpd,
-- --                  function (mpdwidget, args)
-- --                     -- naughty.notify({text = args["{state}"]})
-- --                     if args["{state}"] == "Stop" then
-- --                        return " - "
-- --                     else
-- --                        return args["{Artist}"]..' - '.. args["{Title}"]
-- --                     end
-- --                  end, 10)
-- -- right_layout:add(mpdwidget)

return bar
