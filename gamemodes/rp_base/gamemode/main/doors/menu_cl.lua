-- "gamemodes\\rp_base\\gamemode\\main\\doors\\menu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local oldMaterial = oldMaterial or Material;
local function Material( path, ... )
    return oldMaterial( path,
        "smooth noclamp " .. table.concat( {...}, " " )
    );
end


local return_to;
local simulate_CmdNumber, simulate_InAttack = 0, nil;


-- Menus: ------------------------------------------------------
local doorOptions_admin = {
    {
        text = translates.Get( "Toggle Ownable" ),
        material = Material("ping_system/update_door.png"),
        func = function()
            rp.RunCommand( "setownable" );
        end
    },
    {
        text = translates.Get( "Toggle Locked" ),
        material = Material( "ping_system/update_door.png" ),
        func = function()
            rp.RunCommand( "setlocked" );
        end
    },
    {
        text = translates.Get( "Set Team Own" ),
        material = Material( "ping_system/update_door.png" ),
        func = function()
            local m = ui.DermaMenu();

            for k, v in ipairs( rp.teams ) do
                m:AddOption( v.name, function()
                    rp.RunCommand( "setteamown", k );
                end );
            end

            m:Open();
        end
    },
    {
        text = translates.Get( "Set Group Own" ),
        material = Material( "ping_system/update_door.png" ),
        func = function()
            local m = ui.DermaMenu();

            for k, v in pairs( rp.teamDoors ) do
                m:AddOption( k, function()
                    rp.RunCommand( "setgroupown", k );
                end );
            end

            m:Open();
        end
    },
    {
        text = translates.Get( "Вернуться назад" ),
        material = Material( "ping_system/cancel.png" ),
        func = function( ent, pnl )
            pnl:SetCustomContents( return_to );
            return false
        end,
        access = function()
            return return_to ~= nil;
        end
    }
};

local doorOptions_owned = {
    {
        text = translates.Get( "Открыть" ),
        material = Material("ping_system/give_permison_door.png"),
        func = function()
            net.Start("DoorsLock"); net.SendToServer();
        end,
        access = function( ply, ent )
            return ent:DoorGetLocked();
        end
    },
    {
        text = translates.Get( "Закрыть" ),
        material = Material("ping_system/give_permison_door.png"),
        func = function()
            net.Start("DoorsLock"); net.SendToServer();
        end,
        access = function( ply, ent )
            return not ent:DoorGetLocked();
        end
    },
    {
        text = translates.Get( "Продать" ),
        material = Material( "ping_system/sell_item.png" ),
        func = function()
            rp.RunCommand( "selldoor" );
            --fr:Close()
        end
    },
    {
        text = translates.Get( "Дать ключи" ),
        material = Material("ping_system/give_permison_door.png"),
        func = function()
            ui.PlayerReuqest( function( ply )
                rp.RunCommand( "addcoowner", ply:SteamID() );
            end );
        end,
        access = function()
            return #player.GetAll() > 1
        end
    },
    {
        text = translates.Get( "Забрать ключи" ),
        material = Material( "ping_system/give_permison_door.png" ),
        func = function( ent, pnl )
            ui.PlayerReuqest( ent:DoorGetCoOwners(), function( ply )
                rp.RunCommand( "removecoowner", ply:SteamID() );
            end );
        end,
        access = function( ply, ent )
            return (ent:DoorGetCoOwners() ~= nil) and (#ent:DoorGetCoOwners() > 0)
        end
    },
    {
        text = translates.Get( "Улучшить" ),
        material = Material( "ping_system/update_door.png" ),
        func = function()
            rp.RunCommand( "doorgrade" );
        end,
        access = function( ply, ent )
            ent.Name = string.format( "%s (%s)", translates.Get("Улучшить") or "Улучшить", ply:Wealth(rp.cfg.DoorCostMin, rp.cfg.DoorCostMax) * 2 );
            return (not ent:DoorIsUpgraded()) and (not ent:IsVehicle()) and (not string.find(string.lower(ent:GetClass()),"vehicle"));
        end
    },
    {
        text = translates.Get( "Дать ключи Организации" ),
        material = Material( "ping_system/give_permison_door.png" ),
        func = function()
            rp.RunCommand( "orgown" );
        end,
        access = function( ply )
            return (#player.GetAll() > 1) and (ply:GetOrg() ~= nil)
        end
    },
    {
        text = translates.Get( "Надпись" ),
        material = Material( "ping_system/change_door_name.png" ),
        func = function()
            ui.StringRequest( translates.Get("Надпись"), translates.Get("Напишите текст который будет на двери"), "", function( title )
                rp.RunCommand( "settitle", tostring( title ) );
            end );
        end
    },
    {
        text = translates.Get( "Админ меню" ),
        material = Material( "ping_system/cfgorg.png" ),
        func = function( ent, pnl )
            return_to = doorOptions_owned;
            pnl:SetCustomContents( doorOptions_admin );
            return false
        end,
        access = function( ply )
            return ba.IsSuperAdmin( ply );
        end
    },
};

local doorOptions_unowned = {
    {
        text = translates.Get( "Арендовать" ),
        material = Material( "ping_system/give_money.png" ),
        func = function()
            rp.RunCommand( "buydoor" );
        end,
        access = function( ply, ent )
            return ent:DoorIsOwnable();
        end
    },
    {
        text = translates.Get( "Постучать" ),
        material = Material( "ping_system/punch_door.png" ),
        func = function()
            net.Start( "DoorsKnock" );
            net.SendToServer();
        end
    },
    {
        text = translates.Get( "Выбить" ),
        material = Material( "ping_system/punch_door.png" ),
        func = function()
            net.Start( "rp.DoorBreach" );
            net.SendToServer();
        end,
        access = function( ply )
            if not ply:GetJobTable().canBreach                    then return false end
            if rp.cfg.DoorBreachHunger and (ply:GetHunger() ~= 0) then return false end
            return true
        end
    },
    {
        text = translates.Get( "Взломать" ),
        material = Material( "ping_system/lock_picking_door.png" ),
        func = function( ent, pnl )
            local ply = LocalPlayer();

            local swep = ply:GetWeapon( "lockpick" );
            if not IsValid( swep ) then return end

            PIS.BlockUseDelay = CurTime() + 0.75;

            input.SelectWeapon( swep );
            
            timer.Simple( 0.15, function()
                local wep = ply:GetActiveWeapon();
                if wep:GetClass() ~= "lockpick" then return end
                simulate_InAttack = true;
            end );
        end,
        access = function( ply )
            return IsValid( ply:GetWeapon("lockpick") );
        end
    },
    {
        text = translates.Get( "Админ меню" ),
        material = Material( "ping_system/cfgorg.png" ),
        func = function( ent, pnl )
            return_to = doorOptions_unowned;
            pnl:SetCustomContents( doorOptions_admin );
            return false
        end,
        access = function( ply )
            return ba.IsSuperAdmin( ply );
        end,
    },
};
----------------------------------------------------------------


local frame;
local function keysMenu( bool, bool2 )
    if IsValid( frame ) then
        frame:Remove();
    end

    if not canOpenInteractMenu() then return end
    
    local LocalPlayer = LocalPlayer();

    local tr = LocalPlayer:GetEyeTraceNoCursor();
    local ent = tr.Entity;

    if not IsValid( ent ) then return end
    if not ent:IsDoor() then return end 

    if tr.HitPos:DistToSqr(tr.StartPos) > 13225 then return end -- 115

    local interactcircle_content;

    if ent:DoorOwnedBy( LocalPlayer ) then
        interactcircle_content = doorOptions_owned;
    else
        interactcircle_content = doorOptions_unowned;
    end

    if not interactcircle_content or #interactcircle_content < 1 then return end

    frame = _NexusPanelsFramework:Call( "Create", "PIS.Radial" );
    frame.SelectedPlayer = ent;
    frame.KeyCode = bool2 and KEY_R or (bool and KEY_E or KEY_F2)
    frame:SetSize( ScrW(), ScrH() );
    frame:SetPos( 0, 0 );
    frame:SetCustomContents( interactcircle_content );
end


net( "rp.keysMenu", function()
    keysMenu( true, true );
end );

GM.ShowTeam = function() end


local processing, processingTime, disableprocessing;
hook.Add( "CreateMove", "rp.Doors::CreateMove.KeyHandler", function( cmd )
    local buttons = cmd:GetButtons();

    if simulate_InAttack and (cmd:CommandNumber() > simulate_CmdNumber) then
        hook.Add( "StartCommand", "SimulateIN_ATTACK", function( ply, ucmd )
            if bit.band( buttons, IN_ATTACK ) ~= IN_ATTACK then
                ucmd:SetButtons( bit.bor(buttons, IN_ATTACK) );
            end

            timer.Simple( 0, function()
                hook.Remove( "StartCommand", "SimulateIN_ATTACK" );
                ucmd:SetButtons( bit.bxor(buttons, IN_ATTACK) );
                simulate_InAttack = nil;
            end );
        end );
    end
    
    if IsValid( frame ) then
        cmd:ClearButtons( bit.bxor(buttons, IN_USE) );
        return
    end

    if input.WasKeyPressed( KEY_F2 ) then
        keysMenu();
    end

    if input.IsKeyDown( KEY_E ) then
        local wep = LocalPlayer():GetActiveWeapon(); 
        if IsValid( wep ) and (wep:GetClass() == "weapon_physgun") and input.IsMouseDown( MOUSE_LEFT ) then return end

        local ent = LocalPlayer():GetEyeTrace().Entity;
        if (not IsValid(ent)) or (not ent:IsDoor()) then return end

        if disableprocessing then return end

        if processing then
            cmd:ClearButtons( bit.bxor(buttons, IN_USE) );
            return
        end

        processing, processingTime = true, CurTime() + 0.25;
        cmd:ClearButtons( bit.bxor(buttons, IN_USE) );

        hook.Add( "CreateMove", "rp.Doors.Use", function(cmd2)
            if input.IsKeyDown( KEY_E ) then
                if CurTime() >= processingTime then
                    keysMenu( true )
                    hook.Remove( "CreateMove", "rp.Doors.Use" );
                    processing, processingTime = nil, nil;
                    cmd2:ClearButtons( bit.bxor(buttons, IN_USE) );
                else
                    cmd2:ClearButtons( bit.bxor(buttons, IN_USE) );
                end
            else
                hook.Remove( "CreateMove", "rp.Doors.Use" );
                disableprocessing = true;

                if CurTime() < processingTime then
                    hook.Add( "StartCommand", "SimulateIN_USE", function( ply, ucmd )
                        ucmd:SetButtons( bit.bor(buttons, IN_USE) );
                    end );

                    timer.Simple( 0, function()
                        hook.Remove( "StartCommand", "SimulateIN_USE" );
                    end );
                end

                timer.Simple( 0.1, function()
                    processing, processingTime, disableprocessing = nil, nil, nil;
                end );
            end
        end );
    end

    simulate_CmdNumber = cmd:CommandNumber();
end );