-- "gamemodes\\rp_base\\gamemode\\main\\menus\\scoreboard\\init_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add( "OnGamemodeLoaded", "rp.Scoreboard::Initialize", function()
    if IsValid( rp_Scoreboard ) then rp_Scoreboard:Remove(); end

    local padding = draw.GetFontHeight( "rpui.Fonts.ScoreboardDefault" );

    rp_Scoreboard = vgui.Create( "EditablePanel" );
    rp_Scoreboard:SetSize( ScrW() * 0.5, ScrH() );
    rp_Scoreboard:DockPadding( padding, padding * 4, padding, padding );
    rp_Scoreboard:Center();
    rp_Scoreboard:SetAlpha( 0 );
    rp_Scoreboard.Paint = function( this, w, h )
        draw.Blur( this );
        surface.SetDrawColor( rp.Scoreboard.Config.Colors.Shading );
        surface.DrawRect( 0, 0, w, h );
    end

    rp_Scoreboard.Header = rp_Scoreboard:Add( "Panel" );
    rp_Scoreboard.Header:Dock( TOP );
    rp_Scoreboard.Header:DockMargin( 0, 0, 0, padding );
    rp_Scoreboard.Header.PerformLayout = function( this, w, h )
        this.Branding:SetWide( h * 4.25 );
        this.Socials:SetTall( this.Title:GetTall() );
        this:SizeToContents( false, true );
    end

    rp_Scoreboard.Header.Branding = rp_Scoreboard.Header:Add( "Panel" );
    rp_Scoreboard.Header.Branding:Dock( LEFT );
    rp_Scoreboard.Header.Branding:DockMargin( 0, 0, padding, 0 );
    rp_Scoreboard.Header.Branding.m_Logo = rp.Scoreboard.Utils.Material( "rpui/scoreboard/logo-ru.png", "smooth noclamp" );
    rp_Scoreboard.Header.Branding.Paint = function( this, w, h )
        surface.SetDrawColor( color_white );
        surface.SetMaterial( this.m_Logo );
        surface.DrawTexturedRect( 0, 0, w, h );
    end

    rp_Scoreboard.Header.Title = rp_Scoreboard.Header:Add( "DLabel" );
    rp_Scoreboard.Header.Title:Dock( TOP );
    rp_Scoreboard.Header.Title:DockMargin( 0, 0, 0, padding * 0.5 );
    rp_Scoreboard.Header.Title:SetFont( "rpui.Fonts.ScoreboardHuge" );
    rp_Scoreboard.Header.Title:SetText( rp.Scoreboard.Config.Title or GetHostName() );
    rp_Scoreboard.Header.Title:SetTextColor( rp.Scoreboard.Config.Colors.Golden );
    rp_Scoreboard.Header.Title:SizeToContentsY();

    rp_Scoreboard.Header.Socials = rp_Scoreboard.Header:Add( "Panel" );
    rp_Scoreboard.Header.Socials:Dock( TOP );

    rp_Scoreboard.Header.Socials.PerformLayout = function( this )
        local x = 0;

        for k, child in ipairs( this:GetChildren() ) do
            child:SetX( x );
            x = x + child:GetWide() + padding * 0.5;
        end
    end

    for k, info in pairs( rp.Scoreboard.Config["Socials"] ) do
        if not info then continue end

        local social = rp_Scoreboard.Header.Socials:Add( "rpui.IconLabel" );

        social:SetTall( rp_Scoreboard.Header.Socials:GetTall() );
        social:SetIcon( rp.Scoreboard.Utils.Material("rpui/scoreboard/" .. info.icon .. ".png", "smooth noclamp") );
        social:SetIconInset( 0.75 );
        social:SetFont( "rpui.Fonts.ScoreboardDefault" );
        social:SetText( info.label or "?" );
        social:SizeToContentsX();
        social:SetCursor( "hand" );

        social.LegacyPaint = social.Paint;

        social.DoClick = function( this )
            gui.OpenURL( info.url );
        end

        social.Think = function( this )
            local hovered = this:IsHovered();
            this.fl_Expanded = Lerp( RealFrameTime() * 6, this.fl_Expanded or 0, hovered and 1 or 0 );

            local h = this:GetTall();

            local cw, ch = this:GetContentSize();
            cw = cw - (math.max(h, ch) - ch) + ch;
            cw = cw - h;

            this:SetWide( h + cw * this.fl_Expanded );
        end

        social.Paint = function( this, w, h )
            local dt = this.fl_Expanded;

            local surf_alpha = surface.GetAlphaMultiplier();
            local surf_alpha_dt = surf_alpha * dt;

            surface.SetAlphaMultiplier( surf_alpha_dt );
                surface.SetDrawColor( rp.Scoreboard.Utils.ColorAlpha(info.color, 32) );
                surface.DrawRect( 0, 0, w, h );

                surface.SetDrawColor( info.color );
                surface.DrawRect( 0, 0, h * dt + 1, h );
            surface.SetAlphaMultiplier( surf_alpha );

            this:LegacyPaint( w, h );

            surface.SetAlphaMultiplier( surf_alpha * dt );
                surface.SetDrawColor( info.color );
                surface.DrawOutlinedRect( 0, 0, w, h );
            surface.SetAlphaMultiplier( surf_alpha );
        end
    end

    rp_Scoreboard.Header:InvalidateLayout( true );
    rp_Scoreboard.Header:SizeToChildren( false, true );

    rp_Scoreboard.Footer = rp_Scoreboard:Add( "Panel" );
    rp_Scoreboard.Footer:Dock( BOTTOM );
    rp_Scoreboard.Footer:DockMargin( 0, padding, 0, 0 );

    rp_Scoreboard.Footer.Think = function( this )
        if not rp.Scoreboard.Utils.RefreshTime() then return end

        if not (LocalPlayer().GetTimeMultiplayer and rp.GetTimeMultiplier) then return end

        local tm = LocalPlayer():GetTimeMultiplayer() + rp.GetTimeMultiplier();

        if not this.TimeMultiplier:IsVisible() and tm > 0 then
            this.TimeMultiplier:Show();
            this:InvalidateLayout();
        elseif this.TimeMultiplier:IsVisible() and tm < 1 then
            this.TimeMultiplier:Hide();
            this:InvalidateLayout();
        end
    end

    rp_Scoreboard.Footer.PerformLayout = function( this, w, h )
        this:SizeToChildren( false, true );
    end

    rp_Scoreboard.Footer.Stats = rp_Scoreboard.Footer:Add( "Panel" );
    rp_Scoreboard.Footer.Stats:Dock( TOP );
    rp_Scoreboard.Footer.Stats:DockMargin( 0, 0, 0, padding * 0.5 );
    rp_Scoreboard.Footer.Stats:SetZPos( 1 );

    rp_Scoreboard.Footer.Stats.Uptime = rp_Scoreboard.Footer.Stats:Add( "rpui.IconLabel" );
    rp_Scoreboard.Footer.Stats.Uptime:SetIcon( rp.Scoreboard.Utils.Material("rpui/scoreboard/uptime.png", "smooth noclamp") );
    rp_Scoreboard.Footer.Stats.Uptime:SetFont( "rpui.Fonts.ScoreboardDefault" );
    rp_Scoreboard.Footer.Stats.Uptime:SetText( translates.Get("Онлайн сервера: %s", "?") );
    rp_Scoreboard.Footer.Stats.Uptime:SizeToContents();

    rp_Scoreboard.Footer.Stats.Players = rp_Scoreboard.Footer.Stats:Add( "rpui.IconLabel" );
    rp_Scoreboard.Footer.Stats.Players:SetIcon( rp.Scoreboard.Utils.Material("rpui/scoreboard/user.png", "smooth noclamp") );
    rp_Scoreboard.Footer.Stats.Players:SetFont( "rpui.Fonts.ScoreboardDefault" );
    rp_Scoreboard.Footer.Stats.Players:SetText( translates.Get("Игроки: %i (активные: %i)", 0, 0) );
    rp_Scoreboard.Footer.Stats.Players:SizeToContents();

    rp_Scoreboard.Footer.Stats.Admins = rp_Scoreboard.Footer.Stats:Add( "rpui.IconLabel" );
    rp_Scoreboard.Footer.Stats.Admins:SetIcon( rp.Scoreboard.Utils.Material("rpui/scoreboard/admin.png", "smooth noclamp") );
    rp_Scoreboard.Footer.Stats.Admins:SetFont( "rpui.Fonts.ScoreboardDefault" );
    rp_Scoreboard.Footer.Stats.Admins:SetText( translates.Get("Администраторы: %i (активные: %i)", 0, 0) );
    rp_Scoreboard.Footer.Stats.Admins:SizeToContents();

    rp_Scoreboard.Footer.Stats.Think = function( this )
        if not rp.Scoreboard.Utils.RefreshTime() then return end

        this.Uptime:SetText( translates.Get("Онлайн сервера: %s", rp.Scoreboard.Utils.FormattedTime(CurTime(), true)) );
        this.Uptime:SizeToContentsX();

        local players, players_active = 0, 0;
        local admins, admins_active = 0, 0;

        for k, ply in ipairs( player.GetAll() ) do
            players = players + 1;

            local admin, afk = ply:IsAdmin(), ply:GetNetVar( "IsAFK" );

            if admin then
                admins = admins + 1;
            end

            if not afk then
                players_active = players_active + 1;

                if admin then
                    admins_active = admins_active + 1;
                end
            end
        end

        this.Players:SetText( translates.Get("Игроки: %i (активные: %i)", players, players_active) );
        this.Players:SizeToContentsX();

        this.Admins:SetText( translates.Get("Администраторы: %i (активные: %i)", admins, admins_active) );
        this.Admins:SizeToContentsX();
    end

    rp_Scoreboard.Footer.Stats.PerformLayout = function( this, w )
        this:SizeToChildren( false, true );

        local childs = this:GetChildren();
        local count = #childs - 1;

        local spacing = w / count;

        for k = 0, count do
            local child = childs[k + 1];

            local offset = k == 0 and 0 or (k == count and 1 or 0.5);
            child:SetX( spacing * k - child:GetWide() * offset );
        end
    end

    rp_Scoreboard.Footer.TimeData = rp_Scoreboard.Footer:Add( "Panel" );
    rp_Scoreboard.Footer.TimeData:Dock( TOP );
    rp_Scoreboard.Footer.TimeData:DockMargin( 0, 0, 0, padding * 0.5 );
    rp_Scoreboard.Footer.TimeData:SetZPos( 2 );

    rp_Scoreboard.Footer.TimeData.ServerTime = rp_Scoreboard.Footer.TimeData:Add( "rpui.IconLabel" );
    rp_Scoreboard.Footer.TimeData.ServerTime:SetIcon( rp.Scoreboard.Utils.Material("rpui/scoreboard/clock.png", "smooth noclamp") );
    rp_Scoreboard.Footer.TimeData.ServerTime:SetFont( "rpui.Fonts.ScoreboardDefault" );
    rp_Scoreboard.Footer.TimeData.ServerTime:SetText( translates.Get("Серверное время: %s", "?") );
    rp_Scoreboard.Footer.TimeData.ServerTime:SizeToContents();

    rp_Scoreboard.Footer.TimeData.Date = rp_Scoreboard.Footer.TimeData:Add( "rpui.IconLabel" );
    rp_Scoreboard.Footer.TimeData.Date:SetIcon( rp.Scoreboard.Utils.Material("rpui/scoreboard/calendar.png", "smooth noclamp") );
    rp_Scoreboard.Footer.TimeData.Date:SetFont( "rpui.Fonts.ScoreboardDefault" );
    rp_Scoreboard.Footer.TimeData.Date:SetText( translates.Get("Текущий день: %s", "?") );
    rp_Scoreboard.Footer.TimeData.Date:SizeToContents();

    rp_Scoreboard.Footer.TimeData.PerformLayout = function( this, w )
        this:SizeToChildren( false, true );

        local childs = this:GetChildren();
        local count = #childs - 1;

        local spacing = w / count;

        for k = 0, count do
            local child = childs[k + 1];

            local offset = k == 0 and 0 or (k == count and 1 or 0.5);
            child:SetX( spacing * k - child:GetWide() * offset );
        end
    end

    rp_Scoreboard.Footer.TimeData.Think = function( this )
        if not rp.Scoreboard.Utils.RefreshTime() then return end

        local tz = os.date( "%z" );
        local tz_h = tonumber( tz[2] .. tz[3] );
        local tz_m = tonumber( tz[4] .. tz[5] );

        local time = os.time();

        local servertime = time - (tz_h * 3600 + tz_m * 60) * ((tz[1] == "+") and 1 or -1) + rp.Scoreboard.Utils.GetServerTimezone();
        this.ServerTime:SetText( translates.Get("Серверное время: %s", os.date("%X", servertime)) );
        this.ServerTime:SizeToContentsX();

        local date = string.Explode( ",", os.date("%A,%d,%B,%Y", time) );
        this.Date:SetText( string.format("%s, %i %s %i", translates.Get(date[1]), date[2], translates.Get(date[3]), date[4]) );
        this.Date:SizeToContentsX();
    end

    rp_Scoreboard.Footer.TimeMultiplier = rp_Scoreboard.Footer:Add( "Panel" );
    rp_Scoreboard.Footer.TimeMultiplier:Dock( TOP );
    rp_Scoreboard.Footer.TimeMultiplier:DockMargin( 0, 0, 0, padding );
    rp_Scoreboard.Footer.TimeMultiplier:SetZPos( 0 );
    rp_Scoreboard.Footer.TimeMultiplier:Hide();
    rp_Scoreboard.Footer.TimeMultiplier.PerformLayout = function( this )
        this:SizeToChildren( false, true );
    end

    rp_Scoreboard.Footer.TimeMultiplier.Information = rp_Scoreboard.Footer.TimeMultiplier:Add( "DLabel" );
    rp_Scoreboard.Footer.TimeMultiplier.Information:Dock( TOP );
    rp_Scoreboard.Footer.TimeMultiplier.Information:SetFont( "rpui.Fonts.ScoreboardLarge" );
    rp_Scoreboard.Footer.TimeMultiplier.Information:SetText( translates.Get("Получение времени увеличено на %s!", "?") );
    rp_Scoreboard.Footer.TimeMultiplier.Information:SetContentAlignment( 5 );
    rp_Scoreboard.Footer.TimeMultiplier.Information:SizeToContentsY();

    rp_Scoreboard.Footer.TimeMultiplier.Remain = rp_Scoreboard.Footer.TimeMultiplier:Add( "DLabel" );
    rp_Scoreboard.Footer.TimeMultiplier.Remain:Dock( TOP );
    rp_Scoreboard.Footer.TimeMultiplier.Remain:SetFont( "rpui.Fonts.ScoreboardDefault" );
    rp_Scoreboard.Footer.TimeMultiplier.Remain:SetText( translates.Get("осталось: %s", "?") );
    rp_Scoreboard.Footer.TimeMultiplier.Remain:SetContentAlignment( 5 );
    rp_Scoreboard.Footer.TimeMultiplier.Remain:SizeToContentsY();

    rp_Scoreboard.Footer.TimeMultiplier.Think = function( this, w, h )
        if not rp.Scoreboard.Utils.RefreshTime() then return end

        do
            local old = this.fl_TimeMultiplier;
            local new = LocalPlayer():GetTimeMultiplayer() + rp.GetTimeMultiplier();

            if old ~= new then
                this.Information:SetText( translates.Get("Получение времени увеличено на") .. " " .. math.floor(new * 100) .. "%!" );
                this.fl_TimeMultiplier = new;
            end
        end

        do
            local remain = rp.GetTimeMultiplierRemain() - os.time();

            if remain > 0 then
                this.Remain:SetText( translates.Get("Осталось:") .. " " .. rp.Scoreboard.Utils.FormattedTime(remain) );
            end
        end
    end

    rp_Scoreboard.List = rp_Scoreboard:Add( "rpui.ScoreboardList" );
    rp_Scoreboard.List:Dock( FILL );

    local columns = {};
    hook.Run( "PopulateScoreboardColumns", columns );

    for key, data in SortedPairsByMemberValue( columns, "order", false ) do
        if data.hidden then continue end
        rp_Scoreboard.List:AddColumn( key, data );
    end

    hook.Add( "ScoreboardShow", rp_Scoreboard, function( pnl )
        gui.EnableScreenClicker( true );
        pnl:SetMouseInputEnabled( true );
        pnl:Show();
        pnl:Stop();
        pnl:AlphaTo( 255, 0.25 );
        return true;
    end );

    hook.Add( "ScoreboardHide", rp_Scoreboard, function( pnl )
        gui.EnableScreenClicker( false );
        pnl:SetMouseInputEnabled( false );
        pnl:Stop();
        pnl:AlphaTo( 0, 0.25, 0, function( anim, this ) this:Hide(); end );
        return true;
    end );
end );