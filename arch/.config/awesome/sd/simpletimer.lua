local simpletimer = {}

function simpletimer.setup(interval, fn)
   local callback = function() fn() end
   callback()
   local new_timer = timer({timeout = interval})
   new_timer:connect_signal("timeout", callback)
   new_timer:start()
   return new_timer
end

return simpletimer
