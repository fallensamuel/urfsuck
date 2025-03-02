-- "gamemodes\\darkrp\\gamemode\\addons\\autoevents\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if not rp.cfg.AutoEvents then return end

function rp.autoevents.ChooseCommand( command )
	net.Start( "AutoEvents::ChooseCommand" );
	net.WriteUInt( command, 8 );
	net.SendToServer();
end

-- TODO: Hud
local color_white, color_black, color_gray, color_background = Color(255,255,255), Color(0,0,0), Color(160,160,160), Color(0,0,0,175);
local color_neutral, color_ally, color_enemy = Color(100,100,100), Color(0,95,180), Color(180,45,20);

local function DrawPoly( px, py, rad, q )
    local cir = math.pi * 2;
    local p = {};

    rad = rad * 0.5;

    for i = 0, (q - 1) do
        local x, y = -math.sin( (cir / q) * i ) * rad, math.cos( (cir / q) * i ) * rad;
        table.insert( p, {x = px + x, y = py + y} );
    end

    surface.DrawPoly( p );
end

local function DrawPolySegmented( px, py, rad, q, dt )
    local cir = math.pi * 2;
    local p = {};

    rad = rad * 0.5;

    table.insert( p, {x = px, y = py} );

    for i = 0, math.Round(q * dt) do
        local x, y = -math.sin( math.pi + (cir / q) * i ) * rad, math.cos( math.pi + (cir / q) * i ) * rad;
        table.insert( p, {x = px + x, y = py + y} );

        draw.SimpleText( i, "DebugFixed", x, y );
    end

    surface.DrawPoly( p );
end

surface.CreateFont( "rp.autoevents.HUD.Default", {
	font = "Goudy Trajan Bold",
	size = ScrH() * 0.015,
	weight = 150,
	extended = true,
	shadow = true,
} );

surface.CreateFont( "rp.autoevents.HUD.Large", {
	font = "Goudy Trajan Bold",
	size = ScrH() * 0.02,
	weight = 150,
	extended = true,
	shadow = true,
} );

surface.CreateFont( "rp.autoevents.Changer.Default", {
	font = "Goudy Trajan Bold",
	size = ScrW() * 0.015,
	weight = 150,
	extended = true,
	shadow = true,
} );

surface.CreateFont( "rp.autoevents.Changer.Large", {
	font = "Goudy Trajan Bold",
	size = ScrW() * 0.025,
	weight = 150,
	extended = true,
	shadow = true,
} );

local __capture_DrawHUD;

hook.Add( "HUDPaint", "rp.autoevents::HUDPaint", function()
	if not LocalPlayer():Alive() then return end

    local ev = rp.autoevents.GetCurrentEvent() or {};
    local ev_scores = nw.GetGlobal( "AutoEventScore" ) or {};
    local command = LocalPlayer():GetNetVar( "AutoEventCommand" );

    if table.IsEmpty(ev) or table.IsEmpty(ev_scores) then
        if not hook.GetTable()["HUDPaint"]["rp.Capture.DrawHud"] and __capture_DrawHUD then
            hook.Add( "HUDPaint", "rp.Capture.DrawHud", __capture_DrawHUD );
        end

        return
    else
        if hook.GetTable()["HUDPaint"]["rp.Capture.DrawHud"] then
            __capture_DrawHUD = __capture_DrawHUD or hook.GetTable()["HUDPaint"]["rp.Capture.DrawHud"];
            hook.Remove( "HUDPaint", "rp.Capture.DrawHud" );
        end
    end

    if (not command) or (command <= 0) then
        if not IsValid( g_EventCommandChooser ) then
            local vec_sel, vec_white = Vector(1,0.75,0), Vector(1,1,1);

            g_EventCommandChooser = vgui.Create( "DPanel" );
            g_EventCommandChooser:SetSize( ScrW(), ScrH() );
            g_EventCommandChooser:Center();
            g_EventCommandChooser:MakePopup();
            g_EventCommandChooser:SetAlpha( 0 );
            g_EventCommandChooser:AlphaTo( 255, 0.5 );
            g_EventCommandChooser.players = {}
            g_EventCommandChooser.Close = function( this )
                this:AlphaTo( 0, 0.25, 0, function()
                    if IsValid(this) then this:Remove(); end
                end );
            end

            g_EventCommandChooser.Paint = function( this, w, h )
                draw.Blur( this );
            end

            g_EventCommandChooser.Think = function( this )
                local ev = rp.autoevents.GetCurrentEvent() or {};
                if table.IsEmpty( ev ) then this:Remove(); end

                this.players = {};

                for k, v in ipairs( player.GetAll() ) do
                    local cmd = v:GetNetVar( "AutoEventCommand" ) or -1;
                    this.players[cmd] = (this.players[cmd] or 0) + 1;
                end
            end

            local m = {
                background = Material( "stalker/cmdbg.png", "smooth noclamp" );
            };

            g_EventCommandChooser.Left = vgui.Create( "DButton", g_EventCommandChooser );
            g_EventCommandChooser.Left:Dock( LEFT );
            g_EventCommandChooser.Left:SetSize( g_EventCommandChooser:GetWide() * 0.49 );
            g_EventCommandChooser.Left.dtHovered = 0;
            g_EventCommandChooser.Left.Paint = function( this, w, h )
                this.dtHovered = Lerp( RealFrameTime() * 6, this.dtHovered, this:IsHovered() and 1 or 0 );

                local tex = m.background:GetTexture( "$basetexture" );
                local tex_w, tex_h = tex:GetMappingWidth(), tex:GetMappingHeight();

                local s = 0.75 + this.dtHovered * 0.05;
                local aspect = tex_h / tex_w;

                surface.SetDrawColor( color_white );
                surface.SetMaterial( m.background );
                surface.DrawTexturedRectUV( w - (w * s), h * 0.5 - (w * s * aspect) * 0.5, w * s, w * s * aspect, 0, 0, 1, 1 );

                local clr = LerpVector( this.dtHovered, vec_white, vec_sel ):ToColor();
                surface.SetDrawColor( clr );

                local size = w * 0.2;
                surface.SetMaterial( ev.commands[1].img );
                surface.DrawTexturedRect( w - size * 1.35, h * 0.5 - size * 0.5, size, size );

                local tw, th = draw.SimpleText( ev.commands[1].name, "rp.autoevents.Changer.Large", w - size * 1.45, h * 0.5, clr, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
                draw.SimpleText( (g_EventCommandChooser.players[1] or 0) .. " / 45 ИГРОКОВ", "rp.autoevents.Changer.Default", w - size * 1.45, h * 0.5 + th * 0.5, clr, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP );

                return true
            end
            g_EventCommandChooser.Left.DoClick = function( this )
                rp.autoevents.ChooseCommand( 1 );
                g_EventCommandChooser:Close();
            end

            g_EventCommandChooser.Right = vgui.Create( "DButton", g_EventCommandChooser );
            g_EventCommandChooser.Right:Dock( RIGHT );
            g_EventCommandChooser.Right:SetSize( g_EventCommandChooser:GetWide() * 0.49 );
            g_EventCommandChooser.Right.dtHovered = 0;
            g_EventCommandChooser.Right.Paint = function( this, w, h )
                this.dtHovered = Lerp( RealFrameTime() * 6, this.dtHovered, this:IsHovered() and 1 or 0 );

                local tex = m.background:GetTexture( "$basetexture" );
                local tex_w, tex_h = tex:GetMappingWidth(), tex:GetMappingHeight();

                local s = 0.75 + this.dtHovered * 0.05;
                local aspect = tex_h / tex_w;

                surface.SetDrawColor( color_white );
                surface.SetMaterial( m.background );
                surface.DrawTexturedRectUV( 0, h * 0.5 - (w * s * aspect) * 0.5, w * s, w * s * aspect, 1, 0, 0, 1 );

                local clr = LerpVector( this.dtHovered, vec_white, vec_sel ):ToColor();
                surface.SetDrawColor( clr );

                local size = w * 0.2;
                surface.SetMaterial( ev.commands[2].img );
                surface.DrawTexturedRect( size * 0.35, h * 0.5 - size * 0.5, size, size );

                local tw, th = draw.SimpleText( ev.commands[2].name, "rp.autoevents.Changer.Large", size * 1.45, h * 0.5, clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                draw.SimpleText( (g_EventCommandChooser.players[2] or 0) .. " / 45 ИГРОКОВ", "rp.autoevents.Changer.Default", size * 1.45, h * 0.5 + th * 0.5, clr, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );

                return true
            end
            g_EventCommandChooser.Right.DoClick = function( this )
                rp.autoevents.ChooseCommand( 2 );
                g_EventCommandChooser:Close();
            end
        end

        return
    end

    local w, h, p = ScrW(), ScrH(), math.Round(ScrH() * 0.025);
    local x, y;

    x, y = w * 0.5, p * 2;

    do
        local _w, _h = h * 0.04 * 3.5, h * 0.04;

        local dt;

        -- Team:1
        dt, dt_h = ev_scores[1] / ev.start_score, 0;

        surface.SetDrawColor( color_background );
        surface.DrawRect( x - _w - p * 2, y - _h * 0.5, _w, _h );

        dt_h = math.Round(_w * dt);
        surface.SetDrawColor( (command == 1) and color_ally or color_enemy );
        surface.DrawRect( x - _w - p * 2, y - _h * 0.5, dt_h, _h );

        surface.SetDrawColor( color_gray );
        surface.DrawOutlinedRect( x - _w - p * 2, y - _h * 0.5, _w + 1, _h, 2 );
        draw.SimpleText( string.format("%d / %d", ev_scores[1], ev.start_score), "rp.autoevents.HUD.Default", x - _w - p * 1.5, y + 2, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );

        -- Team:2
        dt = ev_scores[2] / ev.start_score;

        surface.SetDrawColor( color_background );
        surface.DrawRect( x + p * 2, y - _h * 0.5, _w, _h );

        dt_h = math.Round(_w * dt);
        surface.SetDrawColor( (command == 2) and color_ally or color_enemy );
        surface.DrawRect( x + p * 2 + _w + (1 - dt_h), y - _h * 0.5, dt_h, _h );

        surface.SetDrawColor( color_gray );
        surface.DrawOutlinedRect( x + p * 2, y - _h * 0.5, _w + 1, _h, 2 );
        draw.SimpleText( string.format("%d / %d", ev_scores[2], ev.start_score), "rp.autoevents.HUD.Default", x + p * 1.5 + _w, y + 2, color_white, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );


        -- Team:Icons
        _h = h * 0.045;

        surface.SetDrawColor( color_white );

        surface.SetMaterial( ev.commands[1].img );
        surface.DrawTexturedRect( x - _w - p * 2 - _h - p * 0.5, y - _h * 0.5, _h, _h );

        surface.SetMaterial( ev.commands[2].img );
        surface.DrawTexturedRect( x + p * 2 + _w + p * 0.5, y - _h * 0.5, _h, _h );
    end

    do
        local _w, _h = h * 0.04, h * 0.05;
        surface.SetDrawColor( color_white );
        surface.SetMaterial( Material("rpui/misc/flag.png") );
        surface.DrawTexturedRect( x - _w * 0.5, y - _h * 0.5, _w, _h );

        y = y + _h + p * 0.5;
    end

    local c = 0;
    local _s = ScrH() * 0.04;

    for k, v in pairs( rp.Capture.Points ) do
        if v.isOrg or not v.owner then
            continue
        end

        x = ScrW() * 0.5 + (_s * 0.75 + p) * (c - #rp.Capture.Points * 0.5 + 0.5);
        local neutral = ev.default_points_owner();
        local own = ev.commands[command].alliance();

        draw.NoTexture();
        surface.SetDrawColor( color_background );
        DrawPoly( x, y, _s * 1.25, 6 );

        local alpha, dt = 1;

        for _, act in pairs( rp.Capture.ActiveCaptures ) do
            if not act.point then continue end
            local point = act.point;

            if act.point.id == v.id then
                if not point.flag_ent then continue end

                local dt = point.flag_ent.Progress * math.max(0, ((point.flag_ent.TimeRemain or 0) - CurTime()) / (point.flag_ent.TimeDone or -1));
                dt = (dt <= 1) and dt or act.Progress;
                dt = act.IsGoingDown and 0.5 - dt * 0.5 or 0.5 + (1 - dt) * 0.5;
                dt = (v.owner == own) and 1 - dt or dt;

                render.SetStencilWriteMask( 0xFF )
                render.SetStencilTestMask( 0xFF )
                render.SetStencilReferenceValue( 0 )
                render.SetStencilPassOperation( STENCIL_KEEP )
                render.SetStencilZFailOperation( STENCIL_KEEP )
                render.ClearStencil()

                render.SetStencilEnable( true )
                render.SetStencilReferenceValue( 1 )
                render.SetStencilCompareFunction( STENCIL_NEVER )
                render.SetStencilFailOperation( STENCIL_REPLACE )

                draw.NoTexture();
                surface.SetDrawColor( color_white );
                DrawPolySegmented( x, y, _s * 1.25, 32, dt );

                render.SetStencilCompareFunction( STENCIL_EQUAL )
                render.SetStencilFailOperation( STENCIL_KEEP )

                draw.NoTexture();
                surface.SetDrawColor( color_white );
                DrawPoly( x, y, _s * 1.25, 6 );

                render.SetStencilEnable( false );

                alpha = 0.5 + math.sin(CurTime() * 3) * 0.5;
            end
        end

        draw.NoTexture();
        local vec_neutral, vec_ally, vec_enemy = color_neutral:ToVector(), color_ally:ToVector(), color_enemy:ToVector();
        surface.SetDrawColor(
            (v.owner == neutral) and LerpVector(alpha, vec_neutral * 0.75, vec_neutral):ToColor() or (
                (v.owner == own) and LerpVector(alpha, vec_ally * 0.75, vec_ally):ToColor() or LerpVector(alpha, vec_enemy * 0.75, vec_enemy):ToColor()
            )
        );
        DrawPoly( x, y, _s, 6 );

        draw.SimpleText( string.char(65 + c), "rp.autoevents.HUD.Large", x, y + 2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

        c = c + 1;
    end
end );