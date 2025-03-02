-- "gamemodes\\rp_base\\gamemode\\main\\events\\events_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

PANEL.m_Time = {
    { k = "д.", v = 86400, h = true },
    { k = "ч.", v = 3600, h = true },
    { k = "м.", v = 60, h = true },
    { k = "с.", v = 1 }
};

PANEL.color_front = Color( 24, 167, 28 );
PANEL.color_back = Color( 0, 0, 0, 205 );

surface.CreateFont( "rpui.Fonts.EventsInfoLarge", {
    font = "Montserrat",
    size = ScrH() * 0.02,
    weight = 1000,
    extended = true,
} );

surface.CreateFont( "rpui.Fonts.EventsInfoDefault", {
    font = "Montserrat",
    size = ScrH() * 0.0175,
    weight = 600,
    extended = true,
} );

surface.CreateFont( "rpui.Fonts.EventsInfoSmall", {
    font = "Montserrat",
    size = ScrH() * 0.015,
    weight = 500,
    extended = true,
} );

function PANEL:Init()
end

function PANEL:DoClick()
    LocalPlayer().donateLastCatName = translates.Get( "ИВЕНТЫ" );
    RunConsoleCommand( "say", "/upgrades" );
end

function PANEL:BeautifulTime( ts )
    ts = math.max( ts, 0 );

    local out = {};

    for k, time in ipairs( self.m_Time ) do
        local v = math.floor( ts / time.v );
        if v < 1 and time.h then continue end
        ts = ts - v * time.v;
        out[#out + 1] = v .. " " .. translates.Get( time.k );
    end

    return table.concat( out, " " );
end

function PANEL:Think()
    local t = SysTime();

    if (self.fl_NextUpdate or 0) > t then
        return
    end

    self.fl_NextUpdate = t + 0.5;
    self:Update();
end

function PANEL:Paint( w, h )
    if self.b_Disabled then return end

    local cw, ch = w * 0.5, h * 0.5;
    local distsize = math.sqrt( w * w + h * h );

    self.rotAngle = (self.rotAngle or 0) + 100 * FrameTime();

    surface.SetDrawColor( self.color_front );
    surface.DrawRect( 0, 0, w, h );
    surface.SetMaterial( rpui.GradientMat );
    surface.SetDrawColor( self.color_back );
    surface.DrawTexturedRectRotated( cw, ch, distsize, distsize, self.rotAngle );

    local bx, by = cw - self.fl_BlockWidth * 0.5, ch - self.fl_BlockHeight * 0.5;

    draw.SimpleText( translates.Get("АКТИВНЫЕ ИВЕНТЫ:"), "rpui.Fonts.EventsInfoLarge", cw, by, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );

    for k, event in ipairs( self.m_Events or {} ) do
        local x = bx + event.x + event.w * 0.5;
        local y = by + event.y;

        draw.SimpleText( event.name, "rpui.Fonts.EventsInfoDefault", x, y, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
        draw.SimpleText( event.duration, "rpui.Fonts.EventsInfoSmall", x, y + event.h, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );
    end

    return true;
end

function PANEL:Update()
    local scr_w, scr_h = ScrW(), ScrH();

    self.fl_Padding = scr_h * 0.01;

    local events, ts = {}, CurTime();

    for event_id, event_ts in pairs( nw.GetGlobal("EventsRunning") or {} ) do
        local event = rp.Events[event_id];
        if not event then continue end

        events[#events + 1] = {
            name = event.NiceName,
            duration = "(" .. self:BeautifulTime( (event_ts or 0) - ts ) .. ")"
        };
    end

    local events_count = #events;

    if events_count < 1 then
        self.b_Disabled = true;
        return
    end

    self.b_Disabled = false;
    self.m_Events = events;

    local x, y, w, h = 0, 0, 0, 0;

    surface.SetFont( "rpui.Fonts.EventsInfoLarge" );
    local tw, th = surface.GetTextSize( "АКТИВНЫЕ ИВЕНТЫ:" );

    y = y + th + self.fl_Padding * 0.25;

    for k, event in ipairs( self.m_Events ) do
        surface.SetFont( "rpui.Fonts.EventsInfoDefault" );
        local nw, nh = surface.GetTextSize( event.name );

        surface.SetFont( "rpui.Fonts.EventsInfoSmall" );
        local dw, dh = surface.GetTextSize( event.duration );

        event.x = x;
        event.y = y;

        event.w = math.max( nw, dw );
        event.h = nh + dh;

        x = x + event.w + (k < events_count and self.fl_Padding * 2 or 0);
        w, h = x, h + ((y + event.h) - h);
    end

    local diff = (w - tw) * 0.5;

    if diff < 0 then
        for k, event in ipairs( self.m_Events ) do
            event.x = event.x - diff;
        end
    end

    self.fl_BlockWidth = math.max( tw, w );
    self.fl_BlockHeight = h;

    self:SetSize( self.fl_BlockWidth + self.fl_Padding * 2, self.fl_BlockHeight + self.fl_Padding * 2 );

    local parent = self:GetParent();

    if IsValid( parent.DonateInfo ) and not (parent.DonateInfo.DisabledNow) then
        self:SetPos(
            self.OffsetByHeight
                and (parent:GetX() + parent:GetWide() - self:GetWide() - 10)
                 or (parent.DonateInfo:GetX() - self:GetWide() - 10),

            self.OffsetByHeight
                and (parent.DonateInfo:GetY() - self:GetTall() - 10)
                 or (parent:GetTall() - self:GetTall() - 10)
        );
    else
        self:SetPos(
            parent:GetX() + parent:GetWide() - self:GetWide() - 10,
            parent:GetY() + parent:GetTall() - self:GetTall() - 10
        );
    end
end

vgui.Register( "urf.im/eventsinfo", PANEL, "DButton" );


--


hook.Add( "OnContextMenuOpen", "EventsInfo", function()
    if IsValid( g_ContextMenu.EventsInfo ) then
        g_ContextMenu.EventsInfo:Update();
        return
    end

    g_ContextMenu.EventsInfo = g_ContextMenu:Add( "urf.im/eventsinfo" );
    g_ContextMenu.EventsInfo.OffsetByHeight = true;
end );


hook.Add( "RefreshContextMenu", "EventsInfo", function()
    if IsValid( g_ContextMenu.EventsInfo ) then
        g_ContextMenu.EventsInfo:Update();
    end
end );


hook.Add( "SpawnMenuOpen", "EventsInfo", function()
    if IsValid( g_SpawnMenu.EventsInfo ) then
        g_SpawnMenu.EventsInfo:Update();
        return
    end

    g_SpawnMenu.EventsInfo = g_SpawnMenu:Add( "urf.im/eventsinfo" );
end );