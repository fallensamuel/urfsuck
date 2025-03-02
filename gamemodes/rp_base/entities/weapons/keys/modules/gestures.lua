-- "gamemodes\\rp_base\\entities\\weapons\\keys\\modules\\gestures.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile();

-- Utilities: --------------------------------------------------
local function SwitchViewmodelAnimation( wep, new )
    local owner = wep:GetOwner();
    if not IsValid( owner ) then return end

    local vm = owner:GetViewModel();
    if not IsValid( vm ) then return end

    local old = wep.m_AnimationType or "";
    wep.m_AnimationType = new;

    local seq, duration = 0, 0;

    if old ~= new then
        seq, duration = vm:LookupSequence( old .. "_holster" );
        if seq ~= -1 then
            vm:SendViewModelMatchingSequence( seq );
        end
    end

    local timer_uid = owner:SteamID64() .. "keys.animation.viewmodel";

    timer.Create( timer_uid, duration, 1, function()
        if not IsValid( vm ) then return end

        seq, duration = vm:LookupSequence( new .. "_draw" );
        if seq ~= -1 then
            vm:SendViewModelMatchingSequence( seq );

            timer.Create( timer_uid, duration, 1, function()
                if not IsValid( vm ) then return end

                seq, duration = vm:LookupSequence( new .. "_idle" );
                if seq ~= -1 then
                    vm:SendViewModelMatchingSequence( seq );
                end
            end );
        end
    end );
end

-- Holdtypes: --------------------------------------------------
wOS.AnimExtension:RegisterHoldtype( {
    Name         = "keys-handsup",
    HoldType     = "keys-handsup",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE] = "idle_handsup",
        [ACT_MP_WALK] = "walk_handsup",
        [ACT_MP_RUN] = "run_handsup",
        [ACT_MP_CROUCH_IDLE] = "cidle_handsup",
        [ACT_MP_CROUCHWALK] = "cwalk_handsup",
        [ACT_MP_JUMP] = "jump_handsup",
    }
} );

wOS.AnimExtension:RegisterHoldtype( {
    Name         = "keys-middlefinger",
    HoldType     = "keys-middlefinger",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE] = "idle_middlefinger",
        [ACT_MP_WALK] = "walk_middlefinger",
        [ACT_MP_RUN] = "run_middlefinger",
        [ACT_MP_CROUCH_IDLE] = "cidle_middlefinger",
        [ACT_MP_CROUCHWALK] = "cwalk_middlefinger",
        [ACT_MP_JUMP] = "jump_middlefinger",
    }
} );

--[[
wOS.AnimExtension:RegisterHoldtype( {
    Name         = "keys-point",
    HoldType     = "keys-point",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE] = "idle_point",
        [ACT_MP_WALK] = "walk_point",
        [ACT_MP_RUN] = "run_point",
        [ACT_MP_CROUCH_IDLE] = "cidle_point",
        [ACT_MP_CROUCHWALK] = "cwalk_point",
        [ACT_MP_JUMP] = "jump_point",
    }
} );
]]--

-- Core: -------------------------------------------------------
local Animations = {
    [1] = {
        name = translates.Get("Сдаться"),
        holdtype = "keys-handsup",
        viewmodel = "handsup",
        icon = Material( "ping_system/handsup.png" ),
    },

    [2] = {
        name = translates.Get("Показать фак"),
        holdtype = "keys-middlefinger",
        viewmodel = "middlefinger",
        icon = Material( "ping_system/middlefinger.png" ),
    },

    --[[
    [3] = {
        name = translates.Get("Указать на солнце"),
        holdtype = "keys-point",
        viewmodel = "point",
        icon = Material( "ping_system/point.png" ),
    }
    ]]--
};

if SERVER then
    util.AddNetworkString( "rp.keys.animation" );

    net.Receive( "rp.keys.animation", function( len, ply )
        if (ply.fl_CanChangeGesture or 0) > CurTime() then return end
        ply.fl_CanChangeGesture = CurTime() + 0.25;

        local wep = ply:GetWeapon( "keys" );
        if not IsValid( wep ) then return end

        if ply:GetActiveWeapon() ~= wep then
            ply:SelectWeapon( "keys" );
        end

        local id = net.ReadUInt( 4 );

        local anim = Animations[id];
        if not anim then
            wep:SetHoldType( rp.Mood.HoldTypes[ply:GetNetVar("rp.mood") or PLAYER_MOOD_NORMAL][1] );
            SwitchViewmodelAnimation( wep, "reference" );
            return
        end

        wep:SetHoldType( anim.holdtype );
        SwitchViewmodelAnimation( wep, anim.viewmodel );
    end );
end

if CLIENT then
    local Menu = {};
    local Holdtypes = {};

    local function GenerateMenu()
        Menu = {};

        table.insert( Menu, {
            text = translates.Get("Сбросить анимацию"),
            material = Material( "ping_system/cancel.png" ),
            func = function()
                net.Start( "rp.keys.animation" );
                net.SendToServer();
            end,
            access = function( ply )
                local wep = ply:GetWeapon( "keys" );
                if not IsValid( wep ) then return false end

                return Holdtypes[wep:GetHoldType()];
            end,
        } );

        for id, anim in pairs( Animations ) do
            Holdtypes[anim.holdtype] = true;

            table.insert( Menu, {
                text = translates.Get(anim.name or "Неизвестная анимация"),
                material = anim.icon or Material( "ping_system/punch_door.png" ),
                func = function()
                    net.Start( "rp.keys.animation" );
                        net.WriteUInt( id, 4 );
                    net.SendToServer();
                end,
                access = function( ply )
                    local wep = ply:GetWeapon( "keys" );
                    if not IsValid( wep ) then return true end

                    return wep:GetHoldType() ~= anim.holdtype
                end,
            } );
        end

        local tbl = {}
        hook.Run( "Keys.Gesture::PrepareCustomMenu", tbl );
        table.Merge( Menu, tbl );

        return Menu
    end

    hook.Add( "OnKeysReload", "Keys::Gesture", function()
        if IsValid( menu_frame ) then return end

        if not canOpenInteractMenu() then return end

        menu_frame = _NexusPanelsFramework:Call( "Create", "PIS.Radial" );
        menu_frame.KeyCode = KEY_R;
        menu_frame:SetSize( ScrW(), ScrH() );
        menu_frame:SetPos( 0, 0 );
        menu_frame:SetCustomContents( GenerateMenu() );
    end );

    rp.AddContextCommand( translates.Get("Анимации"), translates.Get("Жесты"),
        function( parent )
            -- Base:
            local m = vgui.Create( "rpui.DropMenu" );
            m:SetBase( parent );
            m:SetFont( "Context.DermaMenu.Label" );
            m:SetSpacing( ScrH() * 0.01 );
            m.Paint = function( this, w, h ) draw.Blur( this ); end

            local wep = ply:GetWeapon( "keys" );
            local valid = IsValid( wep );

            for id, anim in pairs( Animations ) do
                local option = m:AddOption( translates.Get(anim.name or "Неизвестная анимация"), function( this )
                    if this.Selected then
                        net.Start( "rp.keys.animation" );
                        net.SendToServer();
                        this.Selected = false;
                        return
                    end

                    net.Start( "rp.keys.animation" );
                        net.WriteUInt( id, 4 );
                    net.SendToServer();

                    for k, v in ipairs( m:GetChildren() ) do v.Selected = false; end
                    this.Selected = true;
                end );

                option.Paint = function( this, w, h )
                    local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                    surface.SetDrawColor( baseColor );
                    surface.DrawRect( 0, 0, w, h );
                    draw.SimpleText( this:GetText(), this:GetFont(), this.Spacing, h * 0.5, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                    return true
                end

                if valid and anim.holdtype == wep:GetHoldType() then
                    option.Selected = true;
                end
            end

            m:Open();
        end,
    nil, "cmenu/chat" );
end