-- "gamemodes\\rp_base\\gamemode\\addons\\zombie_event\\cl_handlers.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook('ZombieEventLoader', function()
    local enums = eventZombie.net.enums
    local cfg = eventZombie.cfg
    local cfgEnums = eventZombie.cfgEnums

    local vector_origin = Vector()

    eventZombie.net.addHandler(enums.START_EVENT, function()
        local sound = cfg[ cfgEnums.SOUND_START_EVENT ]
        surface.PlaySound(sound)

        local time = cfg[ cfgEnums.TIME_EVENT ]
        eventZombie.addHUD(time)

        local settings = cfg[ cfgEnums.SHAKE_SETTINGS ]

        util.ScreenShake(vector_origin, settings.amplitude, settings.frequency, settings.duration, 0)

        eventZombie.CD = CurTime() + cfg[ cfgEnums.EVENT_COOLDOWN ]
        eventZombie.Started = true
    end)

    eventZombie.net.addHandler(enums.END_EVENT, function()
        eventZombie.removeHUD()

        local sound = cfg[ cfgEnums.SOUND_END_EVENT ]
        surface.PlaySound(sound)

        eventZombie.Started = nil
    end)
end)