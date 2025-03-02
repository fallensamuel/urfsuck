-- "gamemodes\\rp_base\\gamemode\\addons\\zombie_event\\cl_hud.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook('ZombieEventLoader', function()
    local cfg = eventZombie.cfg
    local cfgEnums = eventZombie.cfgEnums

    local font = 'zombieevent.font'
    local color_white = color_white

    local enabled = false;

    surface.CreateFont('zombieevent.font', {
        font = 'Montserrat',
        weight = 800,
        size = ScrH() * 0.025,
        extended = true,
    })

    function eventZombie.addHUD(time, ts)
        enabled = true;

        ts = ts or CurTime();

        local genericText = translates.Get('Ивент "Заражение"')
        local iconMat = Material(cfg[cfgEnums.HUD_ICON], 'smooth')
        local endTime = ts + time

        hook.Add('HUDPaint', 'zombieEvent.hud', function()
            local CT = CurTime()
            if CT > endTime then return eventZombie.removeHUD() end

            local difftime = os.difftime(endTime, CT)
            local date = os.date('%M:%S', difftime)

            local w, h = ScrW(), ScrH()
            local x = w * 0.5
            local y = h * 0.9

            local tw, th = draw.SimpleTextOutlined( date, font, x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, color_black )
            y = y - th

            tw, th = draw.SimpleTextOutlined( genericText, font, x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, color_black )
            y = y - th

            local size = h * 0.075

            surface.SetDrawColor( color_white )
            surface.SetMaterial( iconMat )
            surface.DrawTexturedRect( x - size * 0.5, y - size, size, size )
        end)

        hook.Add('OverrideWorldFog', 'zombieEvent.fog', function()
            local options = cfg[ cfgEnums.FOG_SETTINGS ]
            if not options then return end

            if options.disabled then return end

            render.FogStart(options.fog_start)
            render.FogEnd(options.fog_end)
            render.FogColor( unpack(options.fog_color) )
            render.FogMaxDensity(options.fog_density)
            render.FogMode(MATERIAL_FOG_LINEAR)

            return true
        end)
    end

    function eventZombie.removeHUD()
        enabled = false;

        hook.Remove('HUDPaint', 'zombieEvent.hud')
        hook.Remove('OverrideWorldFog', 'zombieEvent.fog')
    end

    hook.Add('OnEventZombieSync', 'zombieEvent.sync', function( ts )
        if enabled then return end
        eventZombie.addHUD(cfg[cfgEnums.TIME_EVENT], ts)
    end)
end)