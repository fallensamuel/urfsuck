-- "gamemodes\\rp_base\\gamemode\\addons\\zombie_event\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
eventZombie = eventZombie or {}

eventZombie.cfg = eventZombie.cfg or {}
eventZombie.cfgEnums = eventZombie.cfgEnums or {}
eventZombie.cfgEnumsBits = eventZombie.cfgEnumsBits or 1

local cfg = eventZombie.cfg
local cfgEnums = eventZombie.cfgEnums

function eventZombie.addConfig(num, name, val)
    eventZombie.cfgEnums[name] = num
    eventZombie.cfg[num] = val
end

function eventZombie.isZombie(ply)
    local plTeam = ply:Team()
    local teamZombie = cfg[ cfgEnums.TEAM_ZOMBIE ]

    return plTeam == cfg[ cfgEnums.TEAM_FIRSTZOMBIE ] or teamZombie[plTeam]
end

hook.Add('ConfigLoaded', 'eventZombie.init', function()
    if not rp.cfg.ZombieEvent then return end

    nw.Register('nwEventZombie')
        :Write(net.WriteFloat)
        :Read(net.ReadFloat)
        :SetHook('OnEventZombieSync')
        :SetGlobal()

    timer.Simple(0, function()
        hook.Run('ZombieEventLoader')

        local teamZombie = {}
        for k, _ in pairs( cfg[ cfgEnums.TEAM_ZOMBIE ] ) do
            if _G[k] then teamZombie[ _G[k] ] = true end
        end

        local teamZombieMap = {}
        for k, v in ipairs( cfg[ cfgEnums.TEAM_ZOMBIE_MAP ] ) do
            teamZombieMap[ #teamZombieMap + 1 ] = _G[v]
        end

        local ignoreFactions = {}
        for k, _ in pairs( cfg[ cfgEnums.FACTION_IGNORE_ENDEVENT ] ) do
            if _G[k] then ignoreFactions[ _G[k] ] = true end
        end

        local teamFirstZombie = _G[ cfg[ cfgEnums.TEAM_FIRSTZOMBIE ] ]

        cfg[ cfgEnums.TEAM_ZOMBIE ] = teamZombie
        cfg[ cfgEnums.TEAM_ZOMBIE_MAP ] = teamZombieMap
        cfg[ cfgEnums.TEAM_FIRSTZOMBIE ] = teamFirstZombie
        cfg[ cfgEnums.FACTION_IGNORE_ENDEVENT ] = ignoreFactions
    end)
end)