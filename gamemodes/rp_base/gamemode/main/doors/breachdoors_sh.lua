-- "gamemodes\\rp_base\\gamemode\\main\\doors\\breachdoors_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local tr = translates;

ba.logs.AddTerm('BreachStart', '#(#) started door breach', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('BreachSuccess', '#(#) successfully breached door', {
	'Name',
	'SteamID',
})

ba.logs.Create 'DoorBreach'
	:Hook('PlayerStartBreachingDoor', function(self, ply, Door)
		self:PlayerLog(ply, ba.logs.Term('BreachStart'), ply:Name(), ply:SteamID())
	end)
	:Hook('PlayerFinishBreachingDoor', function(self, ply, Door)
		self:PlayerLog(ply, ba.logs.Term('BreachSuccess'), ply:Name(), ply:SteamID())
	end)

if SERVER then
    util.AddNetworkString( "rp.DoorBreach" );

    local DoorBreachQueue = {};
	
    local DoorBreachSnds = {
        "physics/wood/wood_panel_break1.wav",
        "physics/wood/wood_plank_break1.wav",
        "physics/wood/wood_plank_break3.wav",
        "physics/wood/wood_plank_break4.wav",
    };

    local DoorBreachClasses = {
        ["prop_dynamic"] = true,
    };

    net.Receive( "rp.DoorBreach", function( _, ply )
        if (ply.__nextDoorBreachRequest or 0) > CurTime() then return end
        ply.__nextDoorBreachRequest = CurTime() + 0.5;
 
        rp.StartDoorBreach( ply, ply:GetEyeTrace().Entity );
    end );

    local function EndDoorBreach( ply, uID )
        timer.Remove( uID );
        net.Start( "rp.DoorBreach" ); net.WriteBool( false ); net.Send( ply );
        if ply:GetEmoteAction() == "__breachdoor" then ply:DropEmoteAction(); end
        ply.IsBreachingDoor = false;
    end    

    rp.StartDoorBreach = function( ply, ent )
        if not IsValid( ply ) then return end
        if not IsValid( ent ) then return end

        if not ent:IsDoor() then
            local c = ent:GetClass();
            if not DoorBreachClasses[c] then return end
        end

        if DoorBreachQueue[ply] then
            if DoorBreachQueue[ply].Target ~= ent then
                rp.Notify( ply, NOTIFY_ERROR, tr.Get("Вы уже пытаетесь выбить другую дверь!") );
                return
            end
        else
            if not ply:GetJobTable().canBreach                    then return end
            if rp.cfg.DoorBreachHunger and (ply:GetHunger() ~= 0) then return end

            DoorBreachQueue[ply] = {
                Target = ent,
                Time   = CurTime() + (rp.cfg.DoorBreachTime or 10)
            };

            ply.IsBreachingDoor = true;

            net.Start( "rp.DoorBreach" );
                net.WriteBool( true );
            net.Send( ply );

            ply:StartEmoteAction( "__breachdoor" );

            hook.Run( "PlayerStartBreachingDoor", ply, ent );

            local uID = "rp.DoorBreach::Check" .. ply:SteamID64();
            timer.Create( uID, 1, 0, function()
                if not IsValid( ply ) then
                    DoorBreachQueue[ply] = nil;
                    timer.Remove( uID );
                    return
                end

                local IsInAnimation = (ply:GetEmoteAction() == "__breachdoor");

                if not DoorBreachQueue[ply] then
                    EndDoorBreach( ply, uID );
                    return
                end


                if not IsInAnimation then
                    DoorBreachQueue[ply] = nil;
                    EndDoorBreach( ply, uID );
                    return
                end

                local BreachData = DoorBreachQueue[ply];

                if not IsValid( BreachData.Target ) then
                    DoorBreachQueue[ply] = nil;
                    EndDoorBreach( ply, uID );
                    return
                end

                if ply:GetEyeTrace().Entity ~= BreachData.Target then
                    DoorBreachQueue[ply] = nil;
                    EndDoorBreach( ply, uID );

                    rp.Notify( ply, NOTIFY_ERROR, tr.Get("Вам необходимо постоянно смотреть на дверь!") );

                    return
                end

                if ply:GetPos():DistToSqr( BreachData.Target:LocalToWorld(BreachData.Target:OBBCenter()) ) > 16384 then -- 128
                    DoorBreachQueue[ply] = nil;
                    EndDoorBreach( ply, uID );

                    rp.Notify( ply, NOTIFY_ERROR, tr.Get("Вы отошли слишком далеко от двери!") );

                    return
                end

                if CurTime() > BreachData.Time then
                    DoorBreachQueue[ply] = nil;
                    EndDoorBreach( ply, uID );

                    local Door = BreachData.Target; 
                    Door:EmitSound( DoorBreachSnds[math.random(1,#DoorBreachSnds)], 100, math.random( 90, 110 ) );

                    if Door.m_eActivator then
                        Door.m_eActivator:Fire( "PressIn" ); -- ?

                        timer.Simple( 60, function()
                            Door.m_eActivator:Fire( "PressOut" );
                        end );
                    elseif Door.m_iSearchRadius then
                        for _, v in ipairs( ents.FindInSphere(Door:GetPos(), Door.m_iSearchRadius) ) do
                            if v:GetClass() ~= "func_door" then continue end
                            
                            v:Fire( "Unlock" );
                            v:Fire( "Open" );
                            v:Fire( "Lock" );
                            
                            timer.Simple( 5, function()
                                v:Fire( "Unlock" );
                            end );
                        end
                    else
                        Door:Fire( "Unlock" );
                        Door:Fire( "Open" );
                        Door:Fire( "Lock" );
                        
                        timer.Simple( 5, function()
                            Door:Fire( "Unlock" );
                        end );
                    end

                    hook.Run( "PlayerFinishBreachingDoor", ply, Door );
					
                else
                    ply:ViewPunch(
                        Angle(
                            1 - math.random()*2,
                            1 - math.random()*2,
                            0
                        ) * 5
                    );
                end
            end );
        end
    end
end


if CLIENT then
    surface.CreateFont( "rpui.Fonts.BreachProgress", {
        font     = "Montserrat",
        size     = ScrH() * 0.025,
        weight   = 1000,
        extended = true,
    } );
    

    local BreachText = tr.Get( "Выбивание двери..." );
    local __BreachEnd, __BreachLength;


    local function rp_DoorBreach_DrawProgress()
        local x, y = ScrW() * 0.5, ScrH() * 0.75;
        local w, h = ScrW() * 0.25, 4;

        local s = 1 - math.min( (__BreachEnd - CurTime()) / __BreachLength, 1 );

        local rx, ry = x - w * 0.5, y + h + 2;

        surface.SetDrawColor( rpui.UIColors.Background );
        surface.DrawRect( rx, ry, w, h );

        surface.SetDrawColor( rpui.UIColors.White );
        surface.DrawRect( rx, ry, w * s, h );

        local a = 191 + math.sin(CurTime() * 5) * 64;
        draw.SimpleTextOutlined(
            BreachText,
            "rpui.Fonts.BreachProgress",
            rx,
            y,
            Color(255, 255, 255, a),
            TEXT_ALIGN_LEFT,
            TEXT_ALIGN_BOTTOM,
            1,
            Color(0, 0, 0, a)
        );
    end


    net.Receive( "rp.DoorBreach", function()
        local state = net.ReadBool();

        if state then
            __BreachLength = (rp.cfg.DoorBreachTime or 10);
            __BreachEnd   = CurTime() + __BreachLength;

            hook.Add( "HUDPaint", "rp.DoorBreach::ProgressBar", rp_DoorBreach_DrawProgress );
        else
            hook.Remove( "HUDPaint", "rp.DoorBreach::ProgressBar" );
        end
    end );
end