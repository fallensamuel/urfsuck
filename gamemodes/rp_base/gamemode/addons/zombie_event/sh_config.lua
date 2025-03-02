-- "gamemodes\\rp_base\\gamemode\\addons\\zombie_event\\sh_config.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- Профессии указывайте в кавычках!
hook('ZombieEventLoader', function()
    eventZombie = eventZombie or {}

    eventZombie.addConfig(0, 'TEAM_FIRSTZOMBIE', 'TEAM_TEST1')

    eventZombie.addConfig(1, 'TEAM_ZOMBIE', {
        ['TEAM_TEST2'] = true,
        ['TEAM_TEST3'] = true,
    })

    eventZombie.addConfig(2, 'TEAM_ZOMBIE_MAP', {
        'TEAM_TEST2',
        'TEAM_TEST3',
    })

    eventZombie.addConfig(3, 'KILL_ZOMBIE_REWARD', 15)
    eventZombie.addConfig(4, 'INFECT_REWARD', 50)

    eventZombie.addConfig(5, 'TIME_EVENT', 135)
    eventZombie.addConfig(6, 'EVENT_COOLDOWN', 60)

    eventZombie.addConfig(7, 'SOUND_START_EVENT', 'ambient/creatures/town_zombie_call1.wav')
    eventZombie.addConfig(8, 'SOUND_END_EVENT', 'ambient/creatures/town_zombie_call1.wav')

    eventZombie.addConfig(9, 'FOG_SETTINGS', {
        fog_start = 500,
        fog_end = 2000,
        fog_density = 0.5,
        fog_color = {50, 255, 50},
    })

    eventZombie.addConfig(10, 'SHAKE_SETTINGS', {
        amplitude = 5,
        frequency = 5,
        duration = 5,
    })

    eventZombie.addConfig(11, 'FACTION_IGNORE_ENDEVENT', {
        ['FACTION_TEST'] = true,
    })

    eventZombie.addConfig(12, 'HUD_ICON', 'zombieevent_icons/icon_skull.png');

    eventZombie.cfgEnumsBits = 4

    local config_map = {
        [0] = "FirstZombie",
        [1] = "Zombies",
        [2] = "ZombiesMap",
        [3] = "KillReward",
        [4] = "InfectReward",
        [5] = "Duration",
        [6] = "Cooldown",
        [7] = "SoundStart",
        [8] = "SoundEnd",
        [9] = "Fog",
        [10] = "Shake",
        [11] = "EndFactionsIgnore",
        [12] = "HUDIcon"
    };

    local config = rp.cfg.ZombieEvent;
    if not config then return end

    for cfg_id, key in pairs( config_map ) do
        if config[key] then
            eventZombie.cfg[cfg_id] = config[key];
        end
    end
end)