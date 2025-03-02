if SERVER then return end


local PANEL = {};


function PANEL:RebuildFonts( frameW, frameH )
end


function PANEL:Show()
    self:MakePopup();
    self:SetKeyboardInputEnabled( false );

    self:SetVisible( true );
    self:SetAlpha( 0 );

    self:Stop();
    self:AlphaTo( 255, 0.25 );
end

function PANEL:Hide()
    self:SetMouseInputEnabled( false );
    self:SetKeyboardInputEnabled( false );

    self:Stop();
    self:AlphaTo( 0, 0.25, 0, function()
        self:SetVisible( false );
    end );
end


function PANEL:Init()
    self.PlayerEntries = {};

    self.TotalStaff    = 0;
    self.ActivePlayers = 0;
    self.ActiveStaff   = 0;

    self:SetSize( ScrW() * 0.5, ScrH() );
    self:Center();

    self.frameW, self.frameH = self:GetSize();
    self.frameSpacing = self.frameH * 0.04;

    self:DockPadding( self.frameSpacing, self.frameSpacing, self.frameSpacing, self.frameSpacing );

    self:RebuildFonts( self.frameW, self.frameH );

    --[[------------------------------------------------
        Header:
    ------------------------------------------------]]--
        self.Header = vgui.Create( "Panel", self );
        self.Header:Dock( TOP );
        self.Header:DockMargin( 0, 0, 0, self.frameSpacing );
        self.Header:SetTall( self.frameH * 0.05 );
        self.Header:InvalidateParent( true );

        self.Header.Logo = vgui.Create( "DPanel", self.Header );
        self.Header.Logo:Dock( LEFT );
        self.Header.Logo:DockMargin( 0, 0, self.frameSpacing * 0.5, 0 );
        self.Header.Logo:SetWide( self.Header:GetTall() * 4.24 );
        self.Header.Logo:InvalidateParent( true );

        self.Header.Hostname = vgui.Create( "DLabel", self.Header );
        self.Header.Hostname:Dock( TOP );
        self.Header.Hostname:SetTall( self.Header:GetTall() * 0.5 );
        self.Header.Hostname:InvalidateParent( true );
        self.Header.Hostname:SetContentAlignment( 1 );
        self.Header.Hostname:SetFont( "DermaDefault" );
        self.Header.Hostname:SetTextColor( Color(255,255,255) );
        self.Header.Hostname:SetText( rp.cfg.ScoreboardName );

        self.Header.Description = vgui.Create( "DLabel", self.Header );
        self.Header.Description:Dock( TOP );
        self.Header.Description:SetTall( self.Header:GetTall() * 0.5 );
        self.Header.Description:InvalidateParent( true );
        self.Header.Description:SetContentAlignment( 7 );
        self.Header.Description:SetFont( "DermaDefault" );
        self.Header.Description:SetTextColor( Color(205,205,205) );
        self.Header.Description:SetText( translates.Get("Наш Discord сервер - www.urf.im/discord") );

    --[[------------------------------------------------
        Footer:
    ------------------------------------------------]]--
        self.Footer = vgui.Create( "Panel", self );
        self.Footer:Dock( BOTTOM );
        self.Footer:DockMargin( 0, self.frameSpacing * 0.5, 0, 0 );
        self.Footer:SetTall( self.frameH * 0.035 );
        self.Footer:InvalidateParent( true );

        self.Footer.UptimeIcon = vgui.Create( "DPanel", self.Footer );
        self.Footer.UptimeIcon:Dock( LEFT );
        self.Footer.UptimeIcon:DockMargin( 0, 0, self.frameSpacing * 0.25, 0 );
        self.Footer.UptimeIcon:SetWide( self.Footer:GetTall() );

        self.Footer.UptimeText = vgui.Create( "DLabel", self.Footer );
        self.Footer.UptimeText:Dock( LEFT );
        self.Footer.UptimeText:SetFont( "DermaDefault" );
        self.Footer.UptimeText:SetTextColor( Color(255,255,255) );
        self.Footer.UptimeText.Think = function( this )
            this:SetText( translates.Get("Онлайн сервера:") .. " " .. ba.str.FormatTime(SysTime()) );
            this:SizeToContentsX();
        end

        if LocalPlayer():IsAdmin() then
            self.Footer.AdminsText = vgui.Create( "DLabel", self.Footer );
            self.Footer.AdminsText:Dock( RIGHT );
            self.Footer.AdminsText:SetFont( "DermaDefault" );
            self.Footer.AdminsText:SetTextColor( Color(255,255,255) );
            self.Footer.AdminsText.Think = function( this )
                this:SetText( translates.Get("Администраторы (онлайн):") .. " " .. self.TotalStaff .. " (" .. self.ActiveStaff .. " " .. translates.Get("активные") .. ")" );
                this:SizeToContentsX();
            end

            self.Footer.AdminsIcon = vgui.Create( "DPanel", self.Footer );
            self.Footer.AdminsIcon:Dock( RIGHT );
            self.Footer.AdminsIcon:DockMargin( self.frameSpacing * 0.5, 0, self.frameSpacing * 0.25, 0 );
            self.Footer.AdminsIcon:SetWide( self.Footer:GetTall() );
        end

        self.Footer.PlayersText = vgui.Create( "DLabel", self.Footer );
        self.Footer.PlayersText:Dock( RIGHT );
        self.Footer.PlayersText:SetFont( "DermaDefault" );
        self.Footer.PlayersText:SetTextColor( Color(255,255,255) );
        self.Footer.PlayersText.Think = function( this )
            this:SetText( translates.Get("Игроков (онлайн):") .. " " .. player.GetCount() .. " (" .. self.ActivePlayers .. " " .. translates.Get("активные") .. ")" );
            this:SizeToContentsX();
        end

        self.Footer.PlayersIcon = vgui.Create( "DPanel", self.Footer );
        self.Footer.PlayersIcon:Dock( RIGHT );
        self.Footer.PlayersIcon:DockMargin( 0, 0, self.frameSpacing * 0.25, 0 );
        self.Footer.PlayersIcon:SetWide( self.Footer:GetTall() );


    --[[------------------------------------------------
        Players:
    ------------------------------------------------]]--
        self.PlayerContainer = vgui.Create( "Panel", self );
        self.PlayerContainer:Dock( FILL );
        self.PlayerContainer:InvalidateParent( true );

        self.PlayerContainer.Header = vgui.Create( "DPanel", self.PlayerContainer );
        self.PlayerContainer.Header:Dock( TOP );
        self.PlayerContainer.Header:InvalidateParent( true );
		
		local job_txt = translates.Get("Профессия")
		local onl_txt = translates.Get("Онлайн")
		
        self.PlayerContainer.Header.Paint = function( this, w, h )
            local offset = h + self.frameSpacing * 0.5
            w = w - offset;

            if self.PlayerContainer.Scroll.VBar:IsVisible() then
                w = w - self.PlayerContainer.Scroll:GetScrollbarWidth() - rpui.PowOfTwo( self.PlayerContainer.Scroll:GetScrollbarMargin() );
            end

            draw.SimpleText( job_txt, "DermaDefault", offset + w * 0.5, h * 0.5, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

            draw.SimpleText( onl_txt, "DermaDefault", offset + w * 0.88, h * 0.5, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

            surface.SetDrawColor( Color(255,255,255) );
            surface.DrawRect( offset + w * 0.96 - h * 0.5, 0, h, h );
        end

        self.PlayerContainer.Scroll = vgui.Create( "rpui.ScrollPanel", self.PlayerContainer );
        self.PlayerContainer.Scroll:Dock( FILL );
        self.PlayerContainer.Scroll:InvalidateParent( true );
        self.PlayerContainer.Scroll:AlwaysLayout( true );
        self.PlayerContainer.Scroll:SetSpacingY( self.frameSpacing * 0.15 );
        self.PlayerContainer.Scroll:SetScrollbarMargin( self.frameSpacing * 0.1 );
end


function PANEL:Think()
    self.TotalStaff    = 0;
    self.ActivePlayers = 0;
    self.ActiveStaff   = 0;

    for _, ply in pairs( player.GetAll() ) do
        if ply:IsAdmin() then
            self.TotalStaff = self.TotalStaff + 1;
        end

        if ply:Alive() then
            self.ActivePlayers = self.ActivePlayers + 1;

            if ply:IsAdmin() then
                self.ActiveStaff = self.ActiveStaff + 1;
            end
        end

        if self.PlayerEntries[ply] then continue end

        self.PlayerEntries[ply] = vgui.Create( "rpui.VerticalDrawer" );

        local PlayerEntry = self.PlayerEntries[ply];
        self.PlayerContainer.Scroll:AddItem( PlayerEntry );

        PlayerEntry.Player = ply;

        PlayerEntry:Dock( TOP );
        PlayerEntry:InvalidateParent( true );
        PlayerEntry.Think = function( this, w, h )
            if not IsValid( ply ) then this:Remove(); end
        end
        
        PlayerEntry.Drawer:SetTall( self.PlayerContainer.Header:GetTall() );
        
        PlayerEntry.UserIcon = vgui.Create( "DImage", PlayerEntry.Drawer );
        PlayerEntry.UserIcon:Dock( LEFT );
        PlayerEntry.UserIcon:DockMargin( self.frameSpacing * 0.25, 0, self.frameSpacing * 0.25, 0 );
        PlayerEntry.UserIcon:SetWide( PlayerEntry.Drawer:GetTall() );
        PlayerEntry.UserIcon:InvalidateParent( true );
        PlayerEntry.UserIcon.Think = function( this )
            if this.Rank ~= ply:GetRankTable():GetID() then
                this.Rank = ply:GetRankTable():GetID();
                PlayerEntry.UserIcon:SetImage( "rpui/escmenu/usericons/" .. this.Rank );
            end
        end

        PlayerEntry.AvatarImage = vgui.Create( "AvatarImage", PlayerEntry.Drawer );
        PlayerEntry.AvatarImage:Dock( LEFT );
        PlayerEntry.AvatarImage:SetWide( PlayerEntry.Drawer:GetTall() );
        PlayerEntry.AvatarImage:InvalidateParent( true );
        PlayerEntry.AvatarImage:SetPlayer( ply, PlayerEntry.AvatarImage:GetTall() );

        PlayerEntry.UserFlag = vgui.Create( "DPanel", PlayerEntry.Drawer );
        PlayerEntry.UserFlag:Dock( LEFT );
        PlayerEntry.UserFlag:DockMargin( self.frameSpacing * 0.25, 0, self.frameSpacing * 0.25, 0 );
        PlayerEntry.UserFlag:SetWide( PlayerEntry.Drawer:GetTall() );
        PlayerEntry.UserFlag:InvalidateParent( true );

        PlayerEntry.Name = vgui.Create( "DLabel", PlayerEntry.Drawer );
        PlayerEntry.Name:Dock( LEFT );
        PlayerEntry.Name:DockMargin( self.frameSpacing * 0.25, 0, self.frameSpacing * 0.25, 0 );
        PlayerEntry.Name:SetFont( "DermaDefault" );
        PlayerEntry.Name:SetTextColor( Color(255,255,255) );
        PlayerEntry.Name.Think = function( this )
            if this:GetText() ~= ply:GetName() then
                this:SetText( ply:GetName() );
                this:SizeToContentsX();
            end
        end

        PlayerEntry.Drawer.FriendIcon = vgui.Create( "DPanel", PlayerEntry.Drawer );
        PlayerEntry.Drawer.FriendIcon:Dock( LEFT );
        PlayerEntry.Drawer.FriendIcon:DockMargin( self.frameSpacing * 0.25, 0, self.frameSpacing * 0.25, 0 );
        PlayerEntry.Drawer.FriendIcon:SetWide( PlayerEntry.Drawer:GetTall() );
        
        PlayerEntry.Drawer.Paint = function( this, w, h )
            surface.SetDrawColor( rpui.UIColors.Background );
            surface.DrawRect( 0, 0, w, h );

            local offset = rpui.PowOfTwo( h + self.frameSpacing * 0.5 );
            w = w - offset;

            local clr = team.GetColor(ply:Team()); clr.a = 78;
            surface.SetDrawColor( clr );
            surface.DrawRect( offset, 0, w, h );

            draw.SimpleText( team.GetName(ply:Team()), "DermaDefault", offset + w * 0.5, h * 0.5, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            draw.SimpleText( ba.str.FormatTime(ply:GetPlayTime()), "DermaDefault", offset + w * 0.88, h * 0.5, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            draw.SimpleText( ply:Ping(), "DermaDefault", offset + w * 0.96, h * 0.5, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

            return true
        end

        PlayerEntry.Container = vgui.Create( "Panel" );
        
        PlayerEntry.Container:Dock( TOP );
        PlayerEntry.Container:SetTall( self.frameH * 0.125 );
        PlayerEntry.Container:InvalidateParent( true );
        PlayerEntry.Container.Paint = function( this, w, h )
            surface.SetDrawColor( team.GetColor(ply:Team()) );
            surface.DrawRect( 0, 0, w, h );

            surface.SetTexture( surface.GetTextureID("gui/gradient_up") );
            surface.SetDrawColor( Color(0,0,0,200) );
            surface.DrawTexturedRect( 0, -h, w, h * 2 );
        end

        PlayerEntry.Container:DockMargin( self.frameSpacing * 0.5 + PlayerEntry.Drawer:GetTall(), 0, 0, 0 );
        PlayerEntry.Container:DockPadding( self.frameSpacing * 0.25, self.frameSpacing * 0.5, self.frameSpacing * 0.25, self.frameSpacing * 0.5 );
        
        PlayerEntry.Container.Avatar = vgui.Create( "AvatarImage", PlayerEntry.Container );
        PlayerEntry.Container.Avatar:Dock( LEFT );
        PlayerEntry.Container.Avatar:DockMargin( 0, 0, self.frameSpacing * 0.25, 0 );
        PlayerEntry.Container.Avatar:InvalidateParent( true );
        PlayerEntry.Container.Avatar:SetWide( PlayerEntry.Container.Avatar:GetTall() );
        PlayerEntry.Container.Avatar:SetPlayer( ply, PlayerEntry.Container.Avatar:GetTall() );

        PlayerEntry.Container.Information = vgui.Create( "Panel", PlayerEntry.Container );
        PlayerEntry.Container.Information:Dock( LEFT );
        PlayerEntry.Container.Information:DockMargin( 0, 0, self.frameSpacing * 0.5, 0 );

        PlayerEntry.Container.Information.Username = vgui.Create( "DLabel", PlayerEntry.Container.Information );
        PlayerEntry.Container.Information.Username:SetFont( "DermaLarge" );
        PlayerEntry.Container.Information.Username:SetTextColor( rpui.UIColors.White );
        PlayerEntry.Container.Information.Username.Think = function( this )
            if this:GetText() ~= ply:GetName() then
                PlayerEntry.Container.Information.Username:Dock( NODOCK );

                this:SetText( ply:GetName() );
                this:SizeToContentsX();
                this:SizeToContentsY();

                PlayerEntry.Container.Information:InvalidateLayout( true );
                PlayerEntry.Container.Information:SizeToChildren( true, false );

                PlayerEntry.Container.Information.Username:Dock( TOP );
            end
        end
        PlayerEntry.Container.Information.Username:DockMargin( 0, 0, 0, self.frameSpacing * 0.125 );

        PlayerEntry.Container.Information.TopIcons = vgui.Create( "Panel", PlayerEntry.Container.Information );
        PlayerEntry.Container.Information.TopIcons:Dock( TOP );
        PlayerEntry.Container.Information.TopIcons:SetTall( PlayerEntry.Drawer:GetTall() );
        PlayerEntry.Container.Information.TopIcons:InvalidateParent( true );

        PlayerEntry.Container.Information.TopIcons.OS = vgui.Create( "DPanel", PlayerEntry.Container.Information.TopIcons );
        PlayerEntry.Container.Information.TopIcons.OS:Dock( LEFT );
        PlayerEntry.Container.Information.TopIcons.OS:DockMargin( 0, 0, self.frameSpacing * 0.25, 0 );
        PlayerEntry.Container.Information.TopIcons.OS:InvalidateParent( true );
        PlayerEntry.Container.Information.TopIcons.OS:SetWide( PlayerEntry.Container.Information.TopIcons.OS:GetTall() );

        PlayerEntry.Container.Information.TopIcons.Country = vgui.Create( "DPanel", PlayerEntry.Container.Information.TopIcons );
        PlayerEntry.Container.Information.TopIcons.Country:Dock( LEFT );
        PlayerEntry.Container.Information.TopIcons.Country:DockMargin( 0, 0, self.frameSpacing * 0.25, 0 );
        PlayerEntry.Container.Information.TopIcons.Country:InvalidateParent( true );
        PlayerEntry.Container.Information.TopIcons.Country:SetWide( PlayerEntry.Container.Information.TopIcons.OS:GetTall() );

        PlayerEntry:AddItem( PlayerEntry.Container );
    end
end


function PANEL:Paint( w, h )
    draw.Blur( self );

    surface.SetDrawColor( rpui.UIColors.Background );
    surface.DrawRect( 0, 0, w, h );
end


vgui.Register( "rpui.Scoreboard", PANEL, "EditablePanel" );



--[[
hook.Add( "ScoreboardShow", "rpui::ScoreboardShow", function()
    if IsValid( g_Scoreboard ) then
        g_Scoreboard:Remove();
    end

    --if not IsValid( g_Scoreboard ) then
        g_Scoreboard = vgui.Create( "rpui.Scoreboard" );
    --end

    g_Scoreboard:Show();
end );


hook.Add( "ScoreboardHide", "rpui::ScoreboardHide", function()
    if IsValid( g_Scoreboard ) then
        g_Scoreboard:Hide();
    end
end );
]]--