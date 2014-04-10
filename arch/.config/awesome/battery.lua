local battery = {}

local check_battery = function(fn)
   local bat_now = tonumber(io.lines("/sys/class/power_supply/BAT0/energy_now")())
   local bat_full = tonumber(io.lines("/sys/class/power_supply/BAT0/energy_full")())
   local bat_status = io.lines("/sys/class/power_supply/BAT0/status")()

   local bat = {
      is_charging = bat_status == 'Charging',
      percent = bat_now / bat_full
   }
   fn(bat)
end

function battery.setup(interval, fn)
   local callback = function() check_battery(fn) end
   callback()
   local battery_timer = timer({timeout = interval})
   battery_timer:connect_signal("timeout", callback)
   battery_timer:start()
end

return battery
