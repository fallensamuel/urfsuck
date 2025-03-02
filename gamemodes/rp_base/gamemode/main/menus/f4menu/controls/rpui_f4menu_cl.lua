-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_f4menu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

PANEL.Tabs = {};

PANEL.UIColors = rpui.UIColors;

function PANEL:RebuildFonts( frameW, frameH )
    surface.CreateFont( "rpui.Fonts.F4Menu.Title", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = frameH * 0.06,
    } );

    surface.CreateFont( "rpui.Fonts.F4Menu.TabButton", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = frameH * 0.03,
    } );

    surface.CreateFont( "rpui.Fonts.F4Menu.Hint1", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = frameH * 0.03,
    } );

    surface.CreateFont( "rpui.Fonts.F4Menu.Hint2", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = frameH * 0.025,
    } );

    surface.CreateFont( "rpui.Fonts.F4Menu.GoldTabButton", {
        font     = "Montserrat",
        extended = true,
        weight = 700,
        size     = frameH * 0.03,
    } );

    surface.CreateFont( "rpui.Fonts.F4Menu.TimeMultiplier", {
        font = "Montserrat",
        extended = true,
        weight = 600,
        size = frameH * 0.02,
    } );

    surface.CreateFont( "rpui.Fonts.F4Menu.Small", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = frameH * 0.025,
    } );
end


function PANEL:Init()
    for k, v in pairs(rp.cfg.UIColor) do
        self.UIColors[k] = v
    end

    self.Tabs = {};
    self:SetAlpha( 0 );

    timer.Simple( FrameTime() * 5, function()
        if not IsValid( self ) then return end

        local frameW, frameH = self:GetSize();

        self.frameW, self.frameH = frameW, frameH;
        self.innerPadding        = frameH * 0.02;

        self:RebuildFonts( frameW, frameH );

        self:DockPadding( self.innerPadding, self.innerPadding, self.innerPadding, self.innerPadding );

        self.Sidebar = vgui.Create( "Panel", self );
        self.Sidebar.Dock( self.Sidebar, LEFT );
        self.Sidebar.DockMargin( self.Sidebar, 0, 0, self.innerPadding * 2, 0 );
        self.Sidebar.SetWide( self.Sidebar, frameW * 0.2 );
        self.Sidebar.InvalidateParent( self.Sidebar, true );
        self.Sidebar.Tabs = {};

        self.Header = vgui.Create( "Panel", self );
        self.Header.Dock( self.Header, TOP );
        self.Header.SetTall( self.Header, frameH * 0.1 );
        self.Header.InvalidateParent( self.Header, true );

        self.Header.Title = vgui.Create( "DLabel", self.Header );
        self.Header.Title.Dock( self.Header.Title, LEFT );
        self.Header.Title.SetTextColor( self.Header.Title, self.UIColors.White );
        self.Header.Title.SetFont( self.Header.Title, "rpui.Fonts.F4Menu.Title" );
        self.Header.Title.SetText( self.Header.Title, translates.Get("МЕНЮ СЕРВЕРА:") );
        self.Header.Title.SizeToContentsX(self.Header.Title);
        self.Header.Title.SizeToContentsY( self.Header.Title, self.innerPadding * 2 );

        self.Header.SizeToChildren( self.Header, false, true );

        self.Header.CloseButton = vgui.Create( "DButton", self.Header );
        self.Header.CloseButton.SetFont( self.Header.CloseButton, "rpui.Fonts.F4Menu.Small" );
        self.Header.CloseButton.SetText( self.Header.CloseButton, translates.Get("ЗАКРЫТЬ") );
        self.Header.CloseButton.SizeToContentsY( self.Header.CloseButton, frameH * 0.015 );
        self.Header.CloseButton.SizeToContentsX( self.Header.CloseButton, self.Header.CloseButton.GetTall(self.Header.CloseButton) + frameW * 0.025 );
        self.Header.CloseButton.SetPos(self.Header.CloseButton,
            self.Header.GetWide(self.Header)       - self.Header.CloseButton.GetWide(self.Header.CloseButton),
            self.Header.GetTall(self.Header) * 0.5 - self.Header.CloseButton.GetTall(self.Header.CloseButton) * 0.5
        );
        self.Header.CloseButton.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );

            surface.SetDrawColor( self.UIColors.White );
            surface.DrawRect( 0, 0, h, h );

            surface.SetDrawColor( Color(0,0,0,this._grayscale or 0) );
            local p = h * 0.1;
            surface.DrawLine( h, p, h, h - p );

            draw.SimpleText( "✕", "rpui.Fonts.F4Menu.Small", h * 0.5, h * 0.5, self.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5 + h * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

            return true
        end
        self.Header.CloseButton.DoClick = function() self:Close() end;

        local time_bonus = LocalPlayer():GetTimeMultiplayer() + rp.GetTimeMultiplier();
        if time_bonus > 0 then
            self.TimeMultiplier = vgui.Create( "Panel", self );
            self.TimeMultiplier.Dock( self.TimeMultiplier, BOTTOM );
            self.TimeMultiplier.SetTall( self.TimeMultiplier, frameH * 0.035 );
            self.TimeMultiplier.DockMargin( self.TimeMultiplier, 0, self.innerPadding, 0, 0 );
            self.TimeMultiplier.Font = "rpui.Fonts.F4Menu.TimeMultiplier";
            self.TimeMultiplier.Text = "";
            self.TimeMultiplier.Think = function( this )
                local lasts      = rp.GetTimeMultiplierRemain() - os.time();
                local tb         = string.FormattedTime( (lasts > 0) and lasts or 0 );

                this.Text = translates.Get("ПОЛУЧЕНИЕ ВРЕМЕНИ УВЕЛИЧЕНО НА %s!", math.floor(time_bonus * 100) .. "%");

                if lasts > 0 then
                    this.Text = translates.Get("ПОЛУЧЕНИЕ ВРЕМЕНИ УВЕЛИЧЕНО НА %s!", math.floor(time_bonus * 100) .. "%") ..
                                translates.Get(" ОСТАЛОСЬ %s", string.format("%02i:%02i:%02i", tb.h, tb.m, tb.s));
                end
            end
            self.TimeMultiplier.Paint = function( this, w, h )
                surface.SetDrawColor( Color(250,30,78) );
                surface.DrawRect( 0, 0, w, h );

                draw.SimpleText( this.Text, this.Font, w * 0.5, h * 0.5, self.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end
        end
        if LocalPlayer():GetFreeSpinTime() > 0 or LocalPlayer():HasFreeSpin() then
            if self.TimeMultiplier then
                self.TimeMultiplier.DockMargin(self.TimeMultiplier, 0, self.innerPadding * 0.5, 0, 0)
            end

            self.FortuneTime = vgui.Create( "DButton", self );
            self.FortuneTime.SetText( self.FortuneTime, "" )
            self.FortuneTime.Dock( self.FortuneTime, BOTTOM );
            self.FortuneTime.SetTall( self.FortuneTime, frameH * 0.035 );
            self.FortuneTime.DockMargin( self.FortuneTime, 0, self.innerPadding, 0, 0 );
            self.FortuneTime.Font = "rpui.Fonts.F4Menu.TimeMultiplier";
            self.FortuneTime.Think = function( this )
                local fortuneSpinTime = LocalPlayer():GetFreeSpinTime()
                local hasFortuneSpin = LocalPlayer():HasFreeSpin()
                if hasFortuneSpin then
                    this.Text = translates.Get("БЕСПЛАТНАЯ ПРОКРУТКА КОЛЕСА ФОРТУНЫ ДОСТУПНА | НЕ ЗАБУДЬТЕ ПРОКРУТИТЬ КОЛЕСО ФОРТУНЫ")
                    this.Color = Color(40, 171, 19)
                elseif fortuneSpinTime > 0 then
                    local tb = string.FormattedTime(fortuneSpinTime)
                    this.Text = translates.Get("БЕСПЛАТНАЯ ПРОКРУТКА КОЛЕСА ФОРТУНЫ БУДЕТ ДОСТУПНА ЧЕРЕЗ: %s!", string.format("%02i:%02i:%02i", tb.h, tb.m, tb.s))
                    this.Color = Color(56, 132, 203)
                end
            end
            self.FortuneTime.Paint = function( this, w, h )
                surface.SetDrawColor( this.Color );
                surface.DrawRect( 0, 0, w, h );

                draw.SimpleText( this.Text, this.Font, w * 0.5, h * 0.5, self.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end
            self.FortuneTime.DoClick = function(this)
                ShowNearestFortuneWheel()
                self:Close()
            end
        end

        self.Content = vgui.Create( "EditablePanel", self );
        self.Content.Dock( self.Content, FILL );
        self.Content.InvalidateParent( self.Content, true );
        self.Content.Tabs = {};

        if self.OnCreated then self:OnCreated() end

        self:RebuildTabs();

        self:AlphaTo( 255, 0.25 );
    end );
end


function PANEL:AddTab( name, pnl, func, super)
    if ispanel(pnl) then pnl:SetVisible( false ); pnl.F4Menu = self; end
    table.insert( self.Tabs, {Name = string.utf8upper(string.Trim(name)), Panel = pnl, Function = func, SuperFunction = super} );
    return pnl;
end

function PANEL:AddButton( name, func )
    self:AddTab( name, func );
end


function PANEL:SetHeaderTitle( text )
    self.Header.Title.SetText( self.Header.Title, text );
    self.Header.Title.SizeToContentsX(self.Header.Title);
end


function PANEL:RebuildTabs()
    local selected = false;

    for id, TabData in pairs( self.Tabs ) do
        if isfunction(TabData.Panel) then
            TabData.Function = TabData.Panel;
            TabData.Panel    = nil;
        end

        self.Sidebar.Tabs[TabData.Name] = vgui.Create( "DButton", self.Sidebar );
        self.Sidebar.Tabs[TabData.Name].Dock( self.Sidebar.Tabs[TabData.Name], TOP );
        self.Sidebar.Tabs[TabData.Name].SetFont( self.Sidebar.Tabs[TabData.Name], "rpui.Fonts.F4Menu.TabButton" );
        self.Sidebar.Tabs[TabData.Name].SetText( self.Sidebar.Tabs[TabData.Name], TabData.Name );
        self.Sidebar.Tabs[TabData.Name].Paint = function( this, w, h )
            if IsValid(TabData.Panel) and TabData.Panel.CustomButtonPaint then
                TabData.Panel.CustomButtonPaint(this, w, h, self)
            else
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );

                draw.SimpleText( TabData.Name, "rpui.Fonts.F4Menu.TabButton", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end

            return true
        end
        self.Sidebar.Tabs[TabData.Name].DoClick = function( this )
            if this.Selected then return end

            for k, v in pairs( self.Sidebar.Tabs ) do v.Selected = false; end
            this.Selected = true;

            if self.Content.Tabs[TabData.Name] then
                self.Header.Title.SetText( self.Header.Title, TabData.Name );
                self.Header.Title.SizeToContentsX(self.Header.Title);

                if self.Content.Tabs[TabData.Name].OnTabOpened then
                    self.Content.Tabs[TabData.Name].OnTabOpened(self.Content.Tabs[TabData.Name]);
                end

                self.Content.AlphaTo( self.Content, 0, 0.25, 0, function()
                    if self.Content.SelectedTab then
                        self.Content.SelectedTab.SetVisible( self.Content.SelectedTab, false );
                    end

                    self.Content.SelectedTab = self.Content.Tabs[TabData.Name];
                    self.Content.SelectedTab.SetVisible( self.Content.SelectedTab, true );

                    self.Content.AlphaTo( self.Content, 255, 0.25, 0, function()
                    end );
                end );
            end

            if TabData.Function then
                TabData.Function( self );
            end
        end

        if TabData.Panel then
            self.Content.Tabs[TabData.Name] = TabData.Panel;
            self.Content.Tabs[TabData.Name].SetParent( self.Content.Tabs[TabData.Name], self.Content );
            self.Content.Tabs[TabData.Name].SetSize( self.Content.Tabs[TabData.Name], self.Content.GetSize(self.Content) );
            self.Content.Tabs[TabData.Name].SetVisible( self.Content.Tabs[TabData.Name], false );
            if self.Content.Tabs[TabData.Name].Initialize then
                self.Content.Tabs[TabData.Name].Initialize(self.Content.Tabs[TabData.Name]);
            end

            if self.Content.Tabs[TabData.Name].PerformLayout then
                self.Content.Tabs[TabData.Name].PerformLayout( self.Content.Tabs[TabData.Name], self.Content.Tabs[TabData.Name].GetSize(self.Content.Tabs[TabData.Name]) );
            end
        end

        if not self.Content.SelectedTab and not selected then
            self.Sidebar.Tabs[TabData.Name].DoClick(self.Sidebar.Tabs[TabData.Name]);
            selected = true;
        end

        if (TabData.SuperFunction and isfunction(TabData.SuperFunction)) then
            TabData.SuperFunction(self.Sidebar.Tabs[TabData.Name]);
        end
    end

    local tall = math.floor(self.Sidebar.GetTall(self.Sidebar) / table.Count(self.Sidebar.Tabs));
    for _, SidebarTab in pairs( self.Sidebar.Tabs ) do
        SidebarTab:SetTall( tall );
    end
end


function PANEL:Think()
    if not input.IsKeyDown(KEY_F4) then self.CanClose = true; end

    local focus = vgui.GetKeyboardFocus();
    if (input.IsKeyDown(KEY_ESCAPE) or (input.IsKeyDown(KEY_X) and (focus:GetClassName() ~= "TextEntry")) or (input.IsKeyDown(KEY_F4) and self.CanClose)) and not self.Closing then
        gui.HideGameUI();
        self:Close();
    end
end


function PANEL:Close()
    self.Closing = true;

    self:AlphaTo( 0, 0.25, 0, function()
        if IsValid( self ) then self:Remove(); end
    end );
end


function PANEL:Paint( w, h )
    draw.Blur( self );

    surface.SetDrawColor( self.UIColors.Shading );
    surface.DrawRect( 0, 0, w, h );
end


vgui.Register( "rpui.F4Menu", PANEL, "EditablePanel" );
