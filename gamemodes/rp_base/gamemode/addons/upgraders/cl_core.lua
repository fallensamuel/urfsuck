-- "gamemodes\\rp_base\\gamemode\\addons\\upgraders\\cl_core.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.Upgraders = rp.Upgraders or {};

rp.Upgraders.Networking = {
    [NET_UPGRADERS_ACTION_DATA] = function()
        local ply = LocalPlayer();
        ply.m_Abilities = ply.m_Abilities or {};
        
        local upgrader_id = net.ReadUInt( 4 );
        ply.m_Abilities[upgrader_id] = ply.m_Abilities[upgrader_id] or {};
        ply.m_Abilities[upgrader_id].StartTime = net.ReadFloat();
        ply.m_Abilities[upgrader_id].Length = net.ReadFloat();
    end,

    [NET_UPGRADERS_ACTION_EFFECT] = function()
        local upgrader_id = net.ReadUInt( 4 );
        local ability_id = net.ReadUInt( 4 );
        
        local ability = rp.Upgraders.Abilities.Map[ability_id];
        if not ability then return end

        local status = net.ReadBool();

        surface.PlaySound( "upgraders/" .. (status and "on" or "off") .. ".mp3" );
        ability["OnEffect" .. (status and "Start" or "End")]( ability );
    end,

    [NET_UPGRADERS_ACTION_GESTURE] = function()
        local target = net.ReadEntity();
        if not IsValid( target ) then return end

        local act = net.ReadUInt( 12 );
        target:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, act, true );
    end
};

net.Receive( "rp.Upgraders.netchan", function()
    local action = net.ReadUInt( 2 );
    
    if rp.Upgraders.Networking[action] then
        rp.Upgraders.Networking[action]();
    end
end );

local color_transparent = Color( 0, 0, 0, 200 );

rp.Upgraders.CachedTable, rp.Upgraders.Keybinds = nil, nil;

hook.Add( "PlayerButtonUp", "rp.Upgraders::SendCommand", function( ply, key )
    if (ply ~= LocalPlayer()) or (not IsFirstTimePredicted()) then return end

    local upgrader_tbl = ply:GetUpgraderTable();

    if rp.Upgraders.CachedTable then
        if not upgrader_tbl then
            rp.Upgraders.CachedTable, rp.Upgraders.Keybinds = nil, nil;
            return
        end
    end

    if upgrader_tbl and (rp.Upgraders.CachedTable ~= upgrader_tbl) then
        rp.Upgraders.CachedTable, rp.Upgraders.Keybinds = upgrader_tbl, {};

        for upgrader_uid, status in pairs( upgrader_tbl ) do
            if not status then continue end

            local upgrader = (rp.Upgraders.List or {})[upgrader_uid];
            if not upgrader then continue end

            for ability_uid, status in pairs( upgrader:GetAbilities() or {} ) do
                if not status then continue end

                local abilities = rp.Upgraders.Abilities or {};

                local ability = (abilities.List or {})[ability_uid];
                if not ability then continue end

                for _, KEY in ipairs( ability:GetKeybindings() ) do
                    if rp.Upgraders.Keybinds[KEY] then continue end
                    rp.Upgraders.Keybinds[KEY] = {uid = upgrader.id, aid = ability.id, key = string.format("[%s]", string.upper(input.GetKeyName(KEY)))};
                    break
                end
            end
        end
    end

    local keybind = (rp.Upgraders.Keybinds or {})[key];
    if not keybind then return end

    net.Start( "rp.Upgraders.netchan" );
        net.WriteUInt( NET_UPGRADERS_ACTION_RUN, 2 );
        net.WriteUInt( keybind.uid, 4 );
        net.WriteUInt( keybind.aid, 4 );
    net.SendToServer();
end );

surface.CreateFont( "rpui.Fonts.Upgraders-Bold", {
    font = "Montserrat",
    size = ScrW() * 0.05 * 0.35,
    weight = 1000,
    extended = true,
} );

surface.CreateFont( "rpui.Fonts.Upgraders-Small", {
    font = "Montserrat",
    size = ScrW() * 0.05 * 0.15,
    weight = 400,
    extended = true,
} );

hook.Add( "HUDPaint", "rp.Upgraders::BindsDisplay", function()
    if not rp.Upgraders.Keybinds then return end

    local w, h = ScrW(), ScrH();
    
    local size = w * 0.05;
    local halfsize = size * 0.5;
    local padding = size * 0.35;
    local qpadding = padding * 0.25;

    local x, y = w * 0.5, h * 0.875;

    local count = table.Count( rp.Upgraders.Keybinds );
    x = x - ((size * count) + (padding * (count - 1))) * 0.5;

    for KEY, keybind in pairs( rp.Upgraders.Keybinds ) do
        local ability = rp.Upgraders.Abilities.Map[keybind.aid];

        local cd_data = (LocalPlayer().m_Abilities or {})[keybind.uid] or {};
        local dt = (CurTime() - (cd_data.StartTime or 0)) / (cd_data.Length or 0);

        local icon_y = y - size;

        surface.SetMaterial( ability:GetIcon() );

        if dt < 1 then
            surface.SetDrawColor( color_transparent );
            surface.DrawTexturedRect( x, icon_y, size, size );

            render.SetScissorRect( x, icon_y + size * (1 - dt), x + size, icon_y + size, true );
                surface.SetDrawColor( color_white );
                surface.DrawTexturedRect( x, icon_y, size, size );
            render.SetScissorRect( 0, 0, 0, 0, false );
        else
            surface.SetDrawColor( color_white );
            surface.DrawTexturedRect( x, icon_y, size, size );
        end

        draw.SimpleTextOutlined( keybind.key, "rpui.Fonts.Upgraders-Bold", x + halfsize, y - size - qpadding, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 2, color_black );
        draw.SimpleTextOutlined( ability:GetName(), "rpui.Fonts.Upgraders-Small", x + halfsize, y + qpadding, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 2, color_black );

        x = x + size + padding;
    end
end );