-- "gamemodes\\rp_base\\gamemode\\addons\\zombie_event\\sh_net.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook('ZombieEventLoader', function()
    eventZombie.net = eventZombie.net or {}
    eventZombie.net.enums = eventZombie.net.enums or {}
    eventZombie.net.handlers = eventZombie.net.handlers or {}
    eventZombie.net.enumsBits = eventZombie.net.enumsBits or 1

    function eventZombie.net.add(num, name)
        eventZombie.net.enums[name] = num
    end

    function eventZombie.net.addHandler(enum, callback)
        eventZombie.net.handlers[enum] = callback
    end
end)