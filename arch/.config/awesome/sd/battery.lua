local battery = {}

function battery.check()
   local bat_now = tonumber(io.lines("/sys/class/power_supply/BAT0/energy_now")())
   local bat_full = tonumber(io.lines("/sys/class/power_supply/BAT0/energy_full")())
   local bat_status = io.lines("/sys/class/power_supply/BAT0/status")()

   local result = {
      is_charging = bat_status == 'Charging',
      percent = bat_now / bat_full
   }
   return result
end

return battery
