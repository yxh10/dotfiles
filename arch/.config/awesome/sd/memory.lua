local memory = {}

function memory.check()
   local result = {}

   for line in io.lines("/proc/meminfo") do
      for k, v in string.gmatch(line, "([%a]+):[%s]+([%d]+).+")
      do
         if     k == "MemTotal"  then result.total = math.floor(v / 1024)
         elseif k == "MemFree"   then result.free  = math.floor(v / 1024)
         elseif k == "Buffers"   then result.buf   = math.floor(v / 1024)
         elseif k == "Cached"    then result.cache = math.floor(v / 1024)
         elseif k == "SwapTotal" then result.swap  = math.floor(v / 1024)
         elseif k == "SwapFree"  then result.swapf = math.floor(v / 1024)
         end
      end
   end

   result.used = result.total - (result.free + result.buf + result.cache)
   result.swapused = result.swap - result.swapf
   result.percent_used = result.used / result.total

   return result
end

return memory
