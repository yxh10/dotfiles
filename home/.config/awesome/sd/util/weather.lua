local json = require("sd/util/json")

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

return weather
