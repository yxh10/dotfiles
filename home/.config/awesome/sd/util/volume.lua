local volume = {}

function volume.check()
   local raw_data = io.popen("mpc | grep volume: | cut -d: -f2"):read()
   local just_num = string.gmatch(raw_data, "[%d]+")()
   return tonumber(just_num) / 100
end

return volume
