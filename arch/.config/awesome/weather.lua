local json = require("json")

local weather = {}

function weather.check(lat, long)
   local raw_data = io.popen("curl 'http://api.openweathermap.org/data/2.5/weather?lat=" .. lat .. "&lon=" .. long .. "&units=imperial'")
   local json_data = json.decode(raw_data:read())

   local result = {
      temp = json_data.main.temp,
      low = json_data.main.temp_min,
      high = json_data.main.temp_max,
      humidity = json_data.main.humidity,
      speed = json_data.wind.speed
   }
   return result
end

function weather.setup(interval, lat, long, fn)
   local callback = function() fn(weather.check(lat, long)) end
   callback()
   local a_timer = timer({timeout = interval})
   a_timer:connect_signal("timeout", callback)
   a_timer:start()
end

return weather
