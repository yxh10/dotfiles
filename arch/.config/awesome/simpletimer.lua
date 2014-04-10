local simpletimer = {}

function simpletimer.setup(interval, fn)
   local callback = function() fn() end
   callback()
   local eternal_timer = timer({timeout = interval})
   eternal_timer:connect_signal("timeout", callback)
   eternal_timer:start()
end

return simpletimer
