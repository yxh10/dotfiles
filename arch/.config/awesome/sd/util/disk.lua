local disk = {}

function disk.check()
   local raw_data = io.popen("df --output=pcent /dev/sda1 | tail -n 1"):read()
   return tonumber(string.gmatch(raw_data, "[%d]+")()) / 100
end

return disk
