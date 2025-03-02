-- "gamemodes\\rp_base\\gamemode\\addons\\zombie_event\\cl_net.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook('ZombieEventLoader', function()
    local handlers = eventZombie.net.handlers
    local bits = eventZombie.net.enumsBits

    net.Receive('zombieEvent', function()
        local enum = net.ReadUInt(bits)
        local handler = handlers[enum]
        if not handler then return end

        handler()
    end)
end)