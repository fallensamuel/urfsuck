-- "gamemodes\\rp_base\\gamemode\\addons\\zombie_event\\sh_nets.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook('ZombieEventLoader', function()
    eventZombie.net.add(0, 'START_EVENT')
    eventZombie.net.add(1, 'END_EVENT')

    eventZombie.net.enumsBits = 1
end)