local weather_util = require("sd/util/weather")
local beautiful = require("sd/util/pretty")
local wibox = require("wibox")
local simpletimer = require("sd/util/simpletimer")
local naughty = require("naughty")

local weather = {}

weather.icon = wibox.widget.imagebox(beautiful.widget_temp)
weather.widget = wibox.widget.textbox()
weather.widget:set_font("Terminus 8")

local lat  = 42.32
local long = -88.45

local update_weather_widget = function()
   local result = weather_util.check(lat, long)
   weather.widget:set_markup("<span color='#00aeff'>" .. round(tonumber(result.temp)) .. "°</span>")
end
simpletimer.setup(31, update_weather_widget)

function show_weather(self)
   local result = weather_util.check(lat, long)

   naughty.notify({timeout = 30,
                   font = "Terminus 8",
                   text =
                      "      Temp: " .. round(tonumber(result.temp)) .. "°\n" ..
                      "       Low: " .. round(tonumber(result.low)) .. "°\n" ..
                      "      High: " .. round(tonumber(result.high)) .. "°\n" ..
                      "  Humidity: " .. result.humidity .. "%\n" ..
                      "Wind Speed: " .. result.speed .. " mph"})
end

weather.widget:connect_signal("mouse::enter", show_weather)

return weather
