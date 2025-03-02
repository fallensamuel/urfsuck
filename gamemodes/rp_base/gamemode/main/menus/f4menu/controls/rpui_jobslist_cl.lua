-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_jobslist_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local surface_CreateFont = surface.CreateFont;
local surface_SetFont = surface.SetFont;
local surface_SetDrawColor = surface.SetDrawColor;
local surface_SetMaterial = surface.SetMaterial;
local surface_GetTextSize = surface.GetTextSize;
local surface_DrawRect = surface.DrawRect;
local surface_DrawTexturedRect = surface.DrawTexturedRect;
local surface_DrawPoly = surface.DrawPoly;
local surface_DrawLine = surface.DrawLine;
local draw_NoTexture = draw.NoTexture;
local draw_SimpleText = draw.SimpleText;




local PANEL = {};


PANEL.UIBackgrounds = {};
PANEL.UIBackgrounds = table.Merge( PANEL.UIBackgrounds, (rp.cfg.JobsListBackgrounds or {}) );


PANEL.UIBackgroundsCached = {};


PANEL.TooltipList = {
    salary           = translates.Get("Зарплата"),
    armor            = translates.Get("Броня"),
    admin            = translates.Get("Нон-РП класс"),
    candisguise      = translates.Get("Может маскироваться"),
    canCapture       = translates.Get("Может грабить"),
    canOrgCapture    = translates.Get("Может захватывать точки"),
    cook             = translates.Get("Является поваром"),
    hasLicense       = translates.Get("Имеется лицензия на оружие"),
    hirable          = translates.Get("Вас может нанять другой игрок"),
    hitman           = translates.Get("Может выполнять наёмные убийства"),
    mayor            = translates.Get("Является мэром"),
    medic            = translates.Get("Является доктором"),
    canDiplomacy     = translates.Get("Может регулировать дипломатию"),
    hpRegen          = translates.Get("Имеется регенерация здоровья"),
    police           = translates.Get("Является полицейским"),
    disableRadiation = translates.Get("Защита от радиации"),
    salesman         = translates.Get("Торгует товарами"),
    upgrader         = translates.Get("Является офицером снабжения"),
    experience       = translates.Get("Может получать опыт профессии"),
};
PANEL.TooltipList = table.Merge( PANEL.TooltipList, (rp.cfg.JobsListStatsTooltips or {}) );


PANEL.UIIcons = {
    Blank = Material( "vgui/white" ),

    VIP = Material( "rpui/icons/vip" ),
    Rules = Material( "rpui/icons/hirable" ),
    Lock = Material( "rpui/icons/locked" ),

    Stats = {
        armor            = Material( "rpui/icons/armor" ),
        admin            = Material( "rpui/icons/admin" ),
        candisguise      = Material( "rpui/icons/candisguise" ),
        canCapture       = Material( "rpui/icons/cancapture" ),
        canOrgCapture    = Material( "rpui/icons/canorgcapture" ),
        cook             = Material( "rpui/icons/cook" ),
        hasLicense       = Material( "rpui/icons/haslicense" ),
        hirable          = Material( "rpui/icons/hirable" ),
        hitman           = Material( "rpui/icons/hitman" ),
        mayor            = Material( "rpui/icons/mayor" ),
        medic            = Material( "rpui/icons/medic" ),
        canDiplomacy     = Material( "rpui/icons/candiplomacy" ),
        hpRegen          = Material( "rpui/icons/hpregen" ),
        police           = Material( "rpui/icons/police" ),
        disableRadiation = Material( "rpui/icons/disableradiation" ),
        salesman         = Material( "rpui/icons/salesman" ),
        upgrader         = Material( "rpui/icons/upgrader" ),
        experience       = Material( "rpui/icons/experience" ),
    }
};
PANEL.UIIcons.Stats = table.Merge( PANEL.UIIcons.Stats, (rp.cfg.JobsListStatsIcons or {}) );


PANEL.CustomStats = {
    ["relationship"] = {
        ScalingFactor = 1.5,
        Check = function( td )
            if rp.GetRelationship then
                local r = rp.GetRelationship( td.team );
                return (not table.IsEmpty(r)) and (r.rank == RANK_TRAINER or r.rank == RANK_OFFICER or r.rank == RANK_LEADER) or false;
            else
                return false;
            end
        end,
        GetMaterial = function( td1 )
            local r = rp.GetRelationship( td1.team ).rank;

            if r == RANK_TRAINER then
                return Material( "rpui/icons/relationship_trainer" );
            elseif r == RANK_OFFICER then
                return Material( "rpui/icons/relationship_officer" );
            elseif r == RANK_LEADER then
                return Material( "rpui/icons/relationship_leader" );
            end
        end,
        GetTooltip = function( td2 )
            local r = rp.GetRelationship( td2.team ).rank;

            if r == RANK_TRAINER then
                return translates.Get("Может выдавать премию подчинённых");
            elseif r == RANK_OFFICER then
                return translates.Get("Может выдавать премию, увольнять и понижать подчинённых");
            elseif r == RANK_LEADER then
                return translates.Get("Может выдавать премию, увольнять, понижать, выгонять из фракции и репрессировать");
            end
        end,
    },

    ["health"] = {
        Check       = function(td3) return td3.health and true or false; end,
        GetMaterial = function() return Material( "rpui/icons/health" ); end,
        GetTooltip  = function(td4) return ((td4.health >= 0) and translates.Get("Увеличенное количество здоровья") or translates.Get("Уменьшенное количество здоровья")); end,
    },

    ["speed"] = {
        Check       = function(td5) return td5.speed and true or false; end,
        GetMaterial = function() return Material( "rpui/icons/speed" ); end,
        GetTooltip  = function(td6) return ((td6.speed >= 1) and translates.Get("Увеличенная скорость передвижения") or translates.Get("Уменьшенная скорость передвижения")); end,
    },

    ["build"] = {
        Check       = function(td7) return not td7.build end,
        GetMaterial = function() return Material( "rpui/icons/build" ); end,
        GetTooltip  = function() return translates.Get("Не может строить"); end,
    },
};
PANEL.CustomStats = table.Merge( PANEL.CustomStats, (rp.cfg.JobsListCustomStats or {}) );


local function CalcViewOptimization( ply, origin, angles, fov )
    local cview = { origin = origin, angles = angles, fov = fov, znear = 1, zfar = 2 };
    return cview;
end


function PANEL:GetStatIcon( name, v )
    local icon = self.UIIcons.Stats[name];
    return icon and icon or self.UIIcons.Blank;
end


function PANEL:RebuildFonts( frameW, frameH )
    frameW = frameW or ScrW();
    frameH = frameH or ScrH();

    surface_CreateFont( "rpui.Fonts.JobsList.Title", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = frameH * 0.05,
    } );

    surface_CreateFont( "rpui.Fonts.JobsList.TitleSmall", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = frameH * 0.04,
    } );

    surface_CreateFont( "rpui.Fonts.JobsList.TitleBold", {
        font     = "Montserrat",
        extended = true,
        weight = 700,
        size     = frameH * 0.055,
    } );

    surface_CreateFont( "rpui.Fonts.JobsList.Micro", {
        font     = "Montserrat",
        extended = true,
        weight = 400,
        size     = frameH * 0.0175,
    } );

    surface_CreateFont( "rpui.Fonts.JobsList.Tooltip", {
        font     = "Montserrat",
        extended = true,
        size     = frameH * 0.0175,
    } );

    surface_CreateFont( "rpui.Fonts.JobsList.Small", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = frameH * 0.02,
    } );

    surface_CreateFont( "rpui.Fonts.JobsList.SmallBold", {
        font     = "Montserrat",
        extended = true,
        weight = 700,
        size     = frameH * 0.02,
    } );

    surface_CreateFont( "rpui.Fonts.JobsList.Default", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = frameH * 0.025,
    } );

    surface_CreateFont( "rpui.Fonts.JobsList.DefaultBold", {
        font     = "Montserrat",
        extended = true,
        weight = 700,
        size     = frameH * 0.025,
    } );

    surface_CreateFont( "rpui.Fonts.JobsList.Medium", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = frameH * 0.025,
    } );

    surface_CreateFont( "rpui.Fonts.JobsList.Big", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = frameH * 0.03,
    } );

    surface_CreateFont( "rpui.Fonts.JobsList.BigBold", {
        font     = "Montserrat",
        extended = true,
        weight = 700,
        size     = frameH * 0.035,
    } );

    surface_CreateFont( "rpui.Fonts.JobsList.Huge", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = frameH * 0.0385,
    } );

    surface_CreateFont( "rpui.Fonts.JobsList.HugeBold", {
        font     = "Montserrat",
        extended = true,
        weight = 700,
        size     = frameH * 0.045,
    } );
end


function PANEL:Think()
    if not self.Closing then
        if not self.IsPopup( self ) then
            self.MakePopup( self );
        end

        g_RPUI_JobsList_HasFocus = true;
        self.MoveToFront( self );

        if (input.IsKeyDown(KEY_ESCAPE) or input.IsKeyDown(KEY_X) or !LocalPlayer():Alive()) then
            gui.HideGameUI();
            if IsValid( rpui.ESCMenu ) then rpui.ESCMenu.HideMenu(rpui.ESCMenu) end
            self.Closing = true;
            self:Close();
        end
    end
end


function PANEL:Paint( w, h )
    local bgMat;

    if self.SelectedFaction then
        bgMat = self.UIBackgroundsCached[ string.lower(self.SelectedFaction.name) ];
    end

    if not bgMat and self.UIBackgroundsCached["default"] then
        bgMat = self.UIBackgroundsCached["default"];
    end

    local bgMatWidth = 1920;
    local bgMatHeight = 1080;

    local ratio = h / bgMatHeight;
    bgMatWidth  = bgMatWidth  * ratio;
    bgMatHeight = h;

    surface_SetDrawColor( rpui.UIColors.Black );
    surface_DrawRect( 0, 0, w, h );

    surface_SetDrawColor( rpui.UIColors.White );
    surface_SetMaterial( bgMat );
    surface_DrawTexturedRect( w * 0.5 - bgMatWidth * 0.5, 0, bgMatWidth, bgMatHeight );
end


function PANEL:Close()
    hook.Remove( "CalcView", "rpui.JobsList.CalcViewOptimization" );

    if IsValid( self.ModelViewer ) then self.ModelViewer.Remove(self.ModelViewer); end
    if IsValid( self.Tooltip )     then self.Tooltip.Remove(self.Tooltip);     end

    self:AlphaTo( 0, 0.25, 0, function()
        if IsValid( self.Parent ) then self.Parent.Remove(self.Parent); end
    end );
end


TOOLTIP_OFFSET_LEFT = 0.1 + 0
TOOLTIP_OFFSET_CENTER = 0.5 + 0

function PANEL:RegisterTooltip( panel, textfunc, offset, parentwidth, posfunc )
    if not self.Tooltip then
        self.Tooltip = vgui.Create( "Panel", self );
        self.Tooltip.SetMouseInputEnabled( self.Tooltip, false );
        self.Tooltip.SetAlpha( self.Tooltip, 0 );
        self.Tooltip.ArrowHeight = 0.01 * self.frameH;
        self.Tooltip.DockPadding( self.Tooltip, self.frameW * 0.0075, self.frameH * 0.005, self.frameW * 0.0075, self.frameH * 0.005 + self.Tooltip.ArrowHeight );

        self.Tooltip.Label = vgui.Create( "DLabel", self.Tooltip );
        self.Tooltip.Label.Dock( self.Tooltip.Label, TOP );
        self.Tooltip.Label.SetWrap( self.Tooltip.Label, true );
        self.Tooltip.Label.SetAutoStretchVertical( self.Tooltip.Label, true );
        self.Tooltip.Label.SetFont( self.Tooltip.Label, "rpui.Fonts.JobsList.Tooltip" );
        self.Tooltip.Label.SetTextColor( self.Tooltip.Label, rpui.UIColors.White );
        self.Tooltip.Label.SetText( self.Tooltip.Label, "" );

        self.Tooltip.TooltipOffset = -1;
        self.Tooltip.IsActive      = false;

        self.Tooltip.Paint = function( this, w, h )
            if string.Trim(this.Label.GetText(this.Label)) ~= "" then
                surface_SetDrawColor( rpui.UIColors.Tooltip );
                surface_DrawRect( 0, 0, w, h - this.ArrowHeight );

                if this.BakedPoly then
                    draw_NoTexture();
                    surface_DrawPoly( this.BakedPoly );
                end
            end
        end

        self.Tooltip.Think = function( this )
            if IsValid( this.ActivePanel ) then
                if not this.IsActive then
                    this.IsActive = true;
                    this:Stop();
                    this:SetAlpha( 0 );

                    this:SetWide( this.ActivePanel.GetWide(this.ActivePanel) );

                    this.Label.SetText( this.Label, isfunction(this.ActivePanel.TooltipText) and this.ActivePanel.TooltipText(this.ActivePanel) or this.ActivePanel.TooltipText );
                    this.Label.SizeToContents(this.Label);

                    if not this.ActivePanel.TooltipWidth then
                        surface_SetFont( this.Label.GetFont(this.Label) );
                        local text_w, text_h = surface_GetTextSize( this.Label.GetText(this.Label) );
                        local pl, pt, pr, pb = this:GetDockPadding();
                        this:SetWide( pl + text_w + pr );
                    end

                    timer.Simple( FrameTime() * 10, function()
                        if not IsValid( self ) then return end

                        if not IsValid(this.ActivePanel) then return end

                        this:SizeToChildren( false, true );

                        local x = 0;
                        local y = 0;
                        local w = 0;
                        local h = 0;

                        if this.ActivePanel.TooltipPosFunc then
                            x, y = this.ActivePanel.TooltipPosFunc( this.ActivePanel, this );
                        else
                            x, y = this.ActivePanel.LocalToScreen( this.ActivePanel, 0, 0 );
                        end

                        w, h = this:GetSize();

                        this:AlphaTo( 255, 0.25 );

                        this.TooltipOffset = this.ActivePanel.TooltipOffset;
                        this.BakedPoly = {
                            { x = w * this.TooltipOffset - this.ArrowHeight/2, y = h - this.ArrowHeight - 1 },
                            { x = w * this.TooltipOffset + this.ArrowHeight/2, y = h - this.ArrowHeight - 1 },
                            { x = w * this.TooltipOffset,                      y = h },
                        };

                        if this.TooltipOffset == TOOLTIP_OFFSET_CENTER then
                            this.Label.SetContentAlignment( this.Label, 5 );
                            if not this.ActivePanel.TooltipPosFunc then
                                this:SetPos( x - w * 0.5 + this.ActivePanel.GetWide(this.ActivePanel) * 0.5, y - h - self.frameH * 0.0015 );
                            else
                                this:SetPos( x - w * 0.5, y - h - self.frameH * 0.0015 );
                            end
                        else
                            this.Label.SetContentAlignment( this.Label, 4 );
                            this:SetPos( x, y - h - self.frameH * 0.0015 );
                        end

                        this.PrevActivePanel = this.ActivePanel;
                    end );
                end
            else
                if this.IsActive then
                    this:AlphaTo( 0, 0.1, 0, function()
                        if IsValid( this ) then
                            this.IsActive        = false;
                            this.PrevActivePanel = nil;
                        end
                    end );
                end
            end
        end
    end

    if IsValid( panel ) then
        panel.TooltipText     = textfunc;
        panel.TooltipOffset   = offset or TOOLTIP_OFFSET_CENTER;
        panel.TooltipWidth    = parentwidth or false;
        panel.TooltipPosition = {x = 0, y = 0};
        panel.TooltipPosFunc  = posfunc or nil;

        panel._OnCursorEntered = self.OnCursorEntered;
        panel._OnCursorExited  = self.OnCursorExited;

        panel.OnCursorEntered = function( this )
            if this._OnCursorEntered then
                this._OnCursorEntered();
            end

            if IsValid( self.Tooltip ) then self.Tooltip.ActivePanel = this; end
        end

        panel.OnCursorExited = function( this )
            if this._OnCursorExited then
                this._OnCursorExited();
            end

            if IsValid( self.Tooltip ) then self.Tooltip.ActivePanel = nil; end
        end
    end
end


local lastAppearanceSelected = {}

function PANEL:Init()
    self.Parent = self:GetParent();

    for k, v in pairs( self.UIBackgrounds ) do
        if not self.UIBackgroundsCached[k] then
            self.UIBackgroundsCached[k] = Material(v);
        end
    end

    self:SetAlpha( 0 );

    self:InvalidateLayout( true );
    self:InvalidateParent( true );

    hook.Add( "PostRenderVGUI", self, function( panel )
        g_RPUI_JobsList_HasFocus = false;
    end );

    timer.Simple( FrameTime() * 10, function()
        if not IsValid( self ) then return end

        self:InvalidateLayout( true );
        self:InvalidateParent( true );

        local screenW = self:GetWide();
        local screenH = self:GetTall();
        local frameW = 0.9 * screenW;
        local frameH = 0.85 * screenH;

        self.screenW = screenW;
        self.screenH = screenH;
        self.frameW = frameW;
        self.frameH = frameH;

        self:RebuildFonts( frameW, frameH );

            self.ModelViewer = vgui.Create( "DModelPanel", self );
            self.ModelViewer.SetCursor( self.ModelViewer, "arrow" );
            self.ModelViewer.SetSize( self.ModelViewer, screenW, screenH );
            self.ModelViewer.SetModel( self.ModelViewer, LocalPlayer():GetModel() );
            self.ModelViewer.SetFOV( self.ModelViewer, 55 );
            self.ModelViewer.xVelocity     = 0;
            self.ModelViewer.xOffset       = 0;
            self.ModelViewer.yVelocity     = 0;
            self.ModelViewer.ZoomingVector = Vector(0,0,0);
            self.ModelViewer.LayoutEntity = function( this, ent ) end
            self.ModelViewer.OnMousePressed = function( this, keycode )
                if IsValid( self.ModelViewer ) then
                    if keycode == MOUSE_LEFT then
                        self.ModelViewer._MousePosition = {input.GetCursorPos()};
                        self.ModelViewer.Pressed = true;
                    end
                end
            end
            self.ModelViewer.Think = function( this )
                if not input.IsMouseDown( MOUSE_LEFT ) then
                    this.Pressed = false;
                end

                this.xVelocity = 0.9 * this.xVelocity;
                this.yVelocity = 0.9 * this.yVelocity;

                if this.Pressed then
                    local mp = {input.GetCursorPos()};
                    local _mp = this._MousePosition;
                    local dx = mp[1] - _mp[1];
                    local dy = mp[2] - _mp[2];

                    this.yVelocity = this.yVelocity + (dx * 0.03);
                end

                this._MousePosition = {input.GetCursorPos()};

                this.Entity.SetAngles( this.Entity, this.Entity.GetAngles(this.Entity) + Angle( 0, this.yVelocity, 0 ) );

                this.xOffset = math.Clamp( this.xOffset + this.xVelocity, -16, 32 );
                this.Entity.SetPos( this.Entity, this.ZoomingVector * this.xOffset );
            end

            self.Foreground = vgui.Create( "Panel", self );
            self.Foreground.SetSize( self.Foreground, frameW, frameH );
            self.Foreground.Center(self.Foreground);
            self.Foreground.OnMousePressed = self.ModelViewer.OnMousePressed;

        if rpui.EnableFactionGroupsUI then
            self.SelectedGroupFaction = {};
            self.GroupSelector = vgui.Create( "Panel", self.Foreground );
            self.GroupSelector.Dock( self.GroupSelector, TOP );
            self.GroupSelector.DockMargin( self.GroupSelector, 0, 0, 0, frameH * 0.01 );
            self.GroupSelector.SetTall( self.GroupSelector, frameH * 0.055 );
            self.GroupSelector.InvalidateParent( self.GroupSelector, true );

            self.GroupSelector.Title = vgui.Create( "DLabel", self.GroupSelector );
            self.GroupSelector.Title.Dock( self.GroupSelector.Title, LEFT );
            self.GroupSelector.Title.DockMargin( self.GroupSelector.Title, 0, 0, frameW * 0.03, 0 );
            self.GroupSelector.Title.SetFont( self.GroupSelector.Title, "rpui.Fonts.JobsList.Title" );
            self.GroupSelector.Title.SetText( self.GroupSelector.Title, translates.Get("ВЫБОР ПРОФЕССИИ:") );
            self.GroupSelector.Title.SetTextColor( self.GroupSelector.Title, rpui.UIColors.White );
            self.GroupSelector.Title.SizeToContentsX(self.GroupSelector.Title);
            self.GroupSelector.Title.InvalidateParent( self.GroupSelector.Title, true );

            self.GroupSelector.Content = vgui.Create( "DHorizontalScroller", self.GroupSelector );
            self.GroupSelector.Content.Dock( self.GroupSelector.Content, FILL );
            self.GroupSelector.Content.SetOverlap( self.GroupSelector.Content, -(self.frameW * 0.03) );
            self.GroupSelector.Content.PerformLayout = function( this )
                local w = this:GetWide();
                local h = this:GetTall();

                this.pnlCanvas.SetTall( this.pnlCanvas, h );

                local x = 0;
                for k, v in pairs( this.Panels ) do
                    if ( !IsValid( v ) ) then continue end
                    if ( !v:IsVisible() ) then continue end
                    v:SetPos( x, 0 );
                    v:SetTall( h );
                    if ( v.ApplySchemeSettings ) then v:ApplySchemeSettings(); end
                    x = x + v:GetWide() - this.m_iOverlap;
                end

                this.pnlCanvas.SetWide( this.pnlCanvas, x + this.m_iOverlap );

                if w < this.pnlCanvas.GetWide(this.pnlCanvas) then
                    this.OffsetX = math.Clamp( this.OffsetX, 0, this.pnlCanvas.GetWide(this.pnlCanvas) - this:GetWide() );
                else
                    this.OffsetX = 0;
                end

                this.pnlCanvas.x = this.OffsetX * -1;

                local btnSize   = 0.7 * h;
                local btnOffset = 0.5 * (h - btnSize);

                this.btnLeft.SetSize( this.btnLeft, btnSize * 1.5, btnSize );
                this.btnLeft.SetPos( this.btnLeft, btnOffset, btnOffset );

                this.btnRight.SetSize( this.btnRight, btnSize * 1.5, btnSize );
                this.btnRight.SetPos( this.btnRight, w - this.btnRight.GetWide(this.btnRight) - btnOffset, btnOffset );

                this.btnLeft.SetVisible( this.btnLeft, this.pnlCanvas.x < 0 );
                this.btnRight.SetVisible( this.btnRight, this.pnlCanvas.x + this.pnlCanvas.GetWide(this.pnlCanvas) > this:GetWide() );
            end

            self.GroupSelector.Content.btnLeft.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( "<", "rpui.Fonts.JobsList.Title", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end

            self.GroupSelector.Content.btnRight.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( ">", "rpui.Fonts.JobsList.Title", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end

            self.GroupSelector.Buttons = {};
            self:LoadFactionGroups();
        end

            self.FactionSelector = vgui.Create( "Panel", self.Foreground );
            self.FactionSelector.Dock( self.FactionSelector, TOP );

            if rpui.EnableFactionGroupsUI then
                self.FactionSelector.DockPadding( self.FactionSelector, self.GroupSelector.Title.GetWide(self.GroupSelector.Title) + frameW * 0.03, 0, 0, 0 );
                self.FactionSelector.InvalidateParent( self.FactionSelector, true );
                self.FactionSelector.SetTall( self.FactionSelector, frameH * 0.045 );
            else
                self.FactionSelector.Title = vgui.Create( "DLabel", self.FactionSelector );
                self.FactionSelector.Title.Dock( self.FactionSelector.Title, LEFT );
                self.FactionSelector.Title.DockMargin( self.FactionSelector.Title, 0, 0, frameW * 0.03, 0 );
                self.FactionSelector.Title.SetFont( self.FactionSelector.Title, "rpui.Fonts.JobsList.Title" );
                self.FactionSelector.Title.SetText( self.FactionSelector.Title, translates.Get("ВЫБОР ПРОФЕССИИ:") );
                self.FactionSelector.Title.SetTextColor( self.FactionSelector.Title, rpui.UIColors.White );
                self.FactionSelector.Title.SizeToContents(self.FactionSelector.Title);

                self.FactionSelector.SizeToChildren( self.FactionSelector, false, true );
            end

            self.FactionSelector.Content = vgui.Create( "DHorizontalScroller", self.FactionSelector );
            self.FactionSelector.Content.Dock( self.FactionSelector.Content, FILL );
            self.FactionSelector.Content.SetOverlap( self.FactionSelector.Content, rpui.EnableFactionGroupsUI and (-self.frameW * 0.015) or (-self.frameW * 0.03) );
            self.FactionSelector.Content.PerformLayout = function( this )
                local w = this:GetWide();
                local h = this:GetTall();

                this.pnlCanvas.SetTall( this.pnlCanvas, h );

                local x = 0;
                for k, v in pairs( this.Panels ) do
                    if ( !IsValid( v ) ) then continue end
                    if ( !v:IsVisible() ) then continue end
                    v:SetPos( x, 0 );
                    v:SetTall( h );
                    if ( v.ApplySchemeSettings ) then v:ApplySchemeSettings(); end
                    x = x + v:GetWide() - this.m_iOverlap;
                end

                this.pnlCanvas.SetWide( this.pnlCanvas, x + this.m_iOverlap );

                if w < this.pnlCanvas.GetWide(this.pnlCanvas) then
                    this.OffsetX = math.Clamp( this.OffsetX, 0, this.pnlCanvas.GetWide(this.pnlCanvas) - this:GetWide() );
                else
                    this.OffsetX = 0;
                end

                this.pnlCanvas.x = this.OffsetX * -1;

                local btnSize   = 0.7 * h;
                local btnOffset = 0.5 * (h - btnSize);

                this.btnLeft.SetSize( this.btnLeft, btnSize * 1.5, btnSize );
                this.btnLeft.SetPos( this.btnLeft, btnOffset, btnOffset );

                this.btnRight.SetSize( this.btnRight, btnSize * 1.5, btnSize );
                this.btnRight.SetPos( this.btnRight, w - this.btnRight.GetWide(this.btnRight) - btnOffset, btnOffset );

                this.btnLeft.SetVisible( this.btnLeft, this.pnlCanvas.x < 0 );
                this.btnRight.SetVisible( this.btnRight, this.pnlCanvas.x + this.pnlCanvas.GetWide(this.pnlCanvas) > this:GetWide() );
            end

            self.FactionSelector.Content.btnLeft.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( "<", "rpui.Fonts.JobsList.TitleSmall", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end

            self.FactionSelector.Content.btnRight.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );
                draw.SimpleText( ">", "rpui.Fonts.JobsList.TitleSmall", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end

            self.FactionSelector.Buttons = {};

            self.Content = vgui.Create( "Panel", self.Foreground );
            self.Content.Dock( self.Content, FILL );
            if rpui.EnableFactionGroupsUI then
                self.Content.DockMargin( self.Content, 0, frameH * 0.05, 0, frameH * 0.1 );
            else
                self.Content.DockMargin( self.Content, 0, frameH * 0.1, 0, frameH * 0.15 );
            end
            self.Content.OnMousePressed = self.ModelViewer.OnMousePressed;

            self.Content.JobSelector = vgui.Create( "rpui.ScrollPanel", self.Content );
            self.Content.JobSelector.Dock( self.Content.JobSelector, LEFT );
            self.Content.JobSelector.SetWide( self.Content.JobSelector, frameW * 0.25 );
            self.Content.JobSelector.SetSpacingY( self.Content.JobSelector, frameH * 0.0075 );
            self.Content.JobSelector.SetScrollbarWidth( self.Content.JobSelector, frameH * 0.0085 );
            self.Content.JobSelector.SetScrollbarMargin( self.Content.JobSelector, frameH * 0.005 );

            self.Content.InformationPanel = vgui.Create( "Panel", self.Content );
            self.Content.InformationPanel.Dock( self.Content.InformationPanel, LEFT );
            self.Content.InformationPanel.DockMargin( self.Content.InformationPanel, frameW * 0.015, 0, 0, 0 );
            self.Content.InformationPanel.SetWide( self.Content.InformationPanel, frameW * 0.3 );

            self.Content.InformationPanel.Stats = vgui.Create( "Panel", self.Content.InformationPanel );
            self.Content.InformationPanel.Stats.Dock( self.Content.InformationPanel.Stats, TOP );
            self.Content.InformationPanel.Stats.SetTall( self.Content.InformationPanel.Stats, frameH * 0.05 );

            self.Content.InformationPanel.Stats.SalaryIcon = vgui.Create( "Panel", self.Content.InformationPanel.Stats );
            self.Content.InformationPanel.Stats.SalaryIcon.Dock( self.Content.InformationPanel.Stats.SalaryIcon, LEFT );
            self.Content.InformationPanel.Stats.SalaryIcon.SetWide( self.Content.InformationPanel.Stats.SalaryIcon, rpui.PowOfTwo(self.Content.InformationPanel.Stats.GetTall(self.Content.InformationPanel.Stats) * 0.6) );
            self.Content.InformationPanel.Stats.SalaryIcon.Paint = function( this, w, h )
                draw_SimpleText( "$", "rpui.Fonts.JobsList.HugeBold", w/2, h/2, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end
            self:RegisterTooltip( self.Content.InformationPanel.Stats.SalaryIcon, self.TooltipList["salary"], TOOLTIP_OFFSET_CENTER );

            self.Content.InformationPanel.Stats.SalaryText = vgui.Create( "DLabel", self.Content.InformationPanel.Stats );
            self.Content.InformationPanel.Stats.SalaryText.Dock( self.Content.InformationPanel.Stats.SalaryText, LEFT );
            self.Content.InformationPanel.Stats.SalaryText.DockMargin( self.Content.InformationPanel.Stats.SalaryText, frameW * 0.005, 0, frameW * 0.02, 0 );
            self.Content.InformationPanel.Stats.SalaryText.SetFont( self.Content.InformationPanel.Stats.SalaryText, "rpui.Fonts.JobsList.BigBold" );
            self.Content.InformationPanel.Stats.SalaryText.SetTextColor( self.Content.InformationPanel.Stats.SalaryText, rpui.UIColors.White );

            self.Content.InformationPanel.Stats.ArmorIcon = vgui.Create( "Panel", self.Content.InformationPanel.Stats );
            self.Content.InformationPanel.Stats.ArmorIcon.Dock( self.Content.InformationPanel.Stats.ArmorIcon, LEFT );
            self.Content.InformationPanel.Stats.ArmorIcon.SetWide( self.Content.InformationPanel.Stats.ArmorIcon, rpui.PowOfTwo(self.Content.InformationPanel.Stats.GetTall(self.Content.InformationPanel.Stats) * 0.6) );
            self.Content.InformationPanel.Stats.ArmorIcon.Material = self:GetStatIcon( "armor" );
            self.Content.InformationPanel.Stats.ArmorIcon.Paint = function( this, w, h )
                surface_SetDrawColor( rpui.UIColors.White );
                surface_SetMaterial( this.Material );
                surface_DrawTexturedRect( 0, h/2 - w/2, w, w );
            end
            self:RegisterTooltip( self.Content.InformationPanel.Stats.ArmorIcon, self.TooltipList["armor"], TOOLTIP_OFFSET_CENTER );

            self.Content.InformationPanel.Stats.ArmorText = vgui.Create( "DLabel", self.Content.InformationPanel.Stats );
            self.Content.InformationPanel.Stats.ArmorText.Dock( self.Content.InformationPanel.Stats.ArmorText, LEFT );
            self.Content.InformationPanel.Stats.ArmorText.DockMargin( self.Content.InformationPanel.Stats.ArmorText, frameW * 0.005, 0, frameW * 0.02, 0 );
            self.Content.InformationPanel.Stats.ArmorText.SetFont( self.Content.InformationPanel.Stats.ArmorText, "rpui.Fonts.JobsList.BigBold" );
            self.Content.InformationPanel.Stats.ArmorText.SetTextColor( self.Content.InformationPanel.Stats.ArmorText, rpui.UIColors.White );

            self.Content.InformationPanel.Stats.IconList = vgui.Create( "Panel", self.Content.InformationPanel.Stats );
            self.Content.InformationPanel.Stats.IconList.Dock( self.Content.InformationPanel.Stats.IconList, LEFT );

            self.Content.InformationPanel.DefaultWeaponsTitle = vgui.Create( "DLabel", self.Content.InformationPanel );
            self.Content.InformationPanel.DefaultWeaponsTitle.Dock( self.Content.InformationPanel.DefaultWeaponsTitle, TOP );
            self.Content.InformationPanel.DefaultWeaponsTitle.SetFont( self.Content.InformationPanel.DefaultWeaponsTitle, "rpui.Fonts.JobsList.DefaultBold" );
            self.Content.InformationPanel.DefaultWeaponsTitle.SetTextColor( self.Content.InformationPanel.DefaultWeaponsTitle, rpui.UIColors.White );
            self.Content.InformationPanel.DefaultWeaponsTitle.SetText( self.Content.InformationPanel.DefaultWeaponsTitle, translates.Get("Выдаваемое оружие:") );
            self.Content.InformationPanel.DefaultWeaponsTitle.SizeToContentsY(self.Content.InformationPanel.DefaultWeaponsTitle);

            self.Content.InformationPanel.DefaultWeaponsContent = vgui.Create( "Panel", self.Content.InformationPanel );
            self.Content.InformationPanel.DefaultWeaponsContent.SizeToContentsY = function( thisz1, addVal ) thisz1:SetTall( (thisz1.BakedTextHeight or 0) + (addVal or 0) ); end
            self.Content.InformationPanel.DefaultWeaponsContent.GetTextColor = function( thisz2 ) return thisz2.TextColor; end
            self.Content.InformationPanel.DefaultWeaponsContent.SetTextColor = function( thisz3, color ) thisz3.TextColor = color; end
            self.Content.InformationPanel.DefaultWeaponsContent.GetFont = function( thisz4 ) return thisz4.Font; end
            self.Content.InformationPanel.DefaultWeaponsContent.SetFont = function( thisz5, font ) thisz5.Font = font; end
            self.Content.InformationPanel.DefaultWeaponsContent.SetWeapons = function( thisz6, weps )
                local w = thisz6:GetWide();
                local h = thisz6:GetTall();

                local x = 0;
                local y = 0;

                thisz6.BakedText       = {};
                thisz6.BakedTextHeight = 0;

                surface_SetFont( thisz6:GetFont() );
                local space, font_height = surface_GetTextSize(" ");

                for k, wep in pairs( weps ) do
                   local text_data = string.Explode( " ", language.GetPhrase(wep.PrintName) .. ((k ~= #weps) and "," or "") );

                    for kstr, str in pairs( text_data ) do
                        local ignore      = false;
                        local strW, strH = surface_GetTextSize(str);

                        if (x + strW) > w then
                            x = 0;
                            y = y + font_height;

                            if kstr ~= #text_data then
                                text_data[#text_data] = str .. " " .. text_data[#text_data];
                                ignore = true;
                            end
                        else
                            if kstr ~= #text_data then
                                local nx           = x + strW + space;
                                local nstrW, nstrH = surface_GetTextSize(text_data[kstr+1]);

                                if (nx + nstrW) < w then
                                    text_data[#text_data] = str .. " " .. text_data[#text_data];
                                    ignore = true;
                                end
                            end
                        end

                        if not ignore then
                            table.insert( thisz6.BakedText, { text = str, wep = wep.ClassName, x = x, y = y, w = strW, h = strH } );
                            x = x + strW + space;
                        end

                        thisz6.BakedTextHeight = math.max( thisz6.BakedTextHeight, y + font_height );
                    end
                end
            end
            self.Content.InformationPanel.DefaultWeaponsContent.Think = function( thisz7 )
                local cursorX, cursorY = thisz7:LocalCursorPos();

                thisz7.TooltipTextQueued = "";
                for btk, bakedtext in pairs( thisz7.BakedText or {} ) do
                    if cursorX < (bakedtext.x)               then continue end
                    if cursorX > (bakedtext.x + bakedtext.w) then continue end
                    if cursorY < (bakedtext.y)               then continue end
                    if cursorY > (bakedtext.y + bakedtext.h) then continue end

                    thisz7.BakedTextKey = btk;

                    local wep = weapons.Get(bakedtext.wep);
                    local out = "";

                    if wep then
                        if wep.Instructions or wep.Purpose then
                            if #wep.Instructions > 0 then
                                out = wep.Instructions;
                                if #wep.Purpose > 0 then out = out .. "\n" end
                            end

                            if #wep.Purpose > 0 then
                                out = out .. wep.Purpose;
                            end

                            out = string.Trim(out);
                        end

                        thisz7.TooltipTextQueued = out;
                    end

                    break
                end

                local tooltip = self.Tooltip;

                if IsValid(tooltip) then
                    if tooltip.ActivePanel == thisz7 then
                        if thisz7.TooltipText ~= thisz7.TooltipTextQueued then
                            thisz7.TooltipText = thisz7.TooltipTextQueued;

                            local px, py = thisz7:LocalToScreen(0,0);
                            local bt     = thisz7.BakedText[thisz7.BakedTextKey];

                            if bt then
                                thisz7.TooltipPosition = { x = px + bt.x + (bt.w * 0.5), y = py + bt.y + self.frameH * 0.005 };
                            end

                            tooltip.IsActive = false;
                        end
                    end
                end
            end
            self.Content.InformationPanel.DefaultWeaponsContent.Paint = function( thisz8 )
                if not thisz8.BakedText then return end

                for k, v in pairs( thisz8.BakedText ) do
                    draw.SimpleText( v.text, thisz8:GetFont(), v.x, v.y, thisz8:GetTextColor() );
                end
            end
            self.Content.InformationPanel.DefaultWeaponsContent.Dock( self.Content.InformationPanel.DefaultWeaponsContent, TOP );
            self.Content.InformationPanel.DefaultWeaponsContent.InvalidateParent( self.Content.InformationPanel.DefaultWeaponsContent, true );
            self.Content.InformationPanel.DefaultWeaponsContent.SetFont( self.Content.InformationPanel.DefaultWeaponsContent, "rpui.Fonts.JobsList.Default" );
            self.Content.InformationPanel.DefaultWeaponsContent.SetTextColor( self.Content.InformationPanel.DefaultWeaponsContent, rpui.UIColors.White );
            self.Content.InformationPanel.DefaultWeaponsContent.SizeToContentsY(self.Content.InformationPanel.DefaultWeaponsContent);
            self:RegisterTooltip( self.Content.InformationPanel.DefaultWeaponsContent, "<tooltip>", TOOLTIP_OFFSET_CENTER, false, function( meas )
                return meas.TooltipPosition.x, meas.TooltipPosition.y;
            end );

            self.Content.InformationPanel.FirearmsTitle = vgui.Create( "DLabel", self.Content.InformationPanel );
            self.Content.InformationPanel.FirearmsTitle.Dock( self.Content.InformationPanel.FirearmsTitle, TOP );
            self.Content.InformationPanel.FirearmsTitle.DockMargin( self.Content.InformationPanel.FirearmsTitle, 0, frameH * 0.015, 0, frameH * 0.005 );
            self.Content.InformationPanel.FirearmsTitle.SetFont( self.Content.InformationPanel.FirearmsTitle, "rpui.Fonts.JobsList.DefaultBold" );
            self.Content.InformationPanel.FirearmsTitle.SetTextColor( self.Content.InformationPanel.FirearmsTitle, rpui.UIColors.White );
            self.Content.InformationPanel.FirearmsTitle.SetText( self.Content.InformationPanel.FirearmsTitle, translates.Get("Огнестрельное оружие:") );
            self.Content.InformationPanel.FirearmsTitle.SizeToContents(self.Content.InformationPanel.FirearmsTitle);

            local armory_list = self.Content.InformationPanel.Add(self.Content.InformationPanel, "DIconLayout")
            armory_list:Dock(TOP)
            armory_list:DockMargin(0, 0, 0, frameH * 0.0075)
            armory_list:SetTall(38)
            armory_list.NoRemove = true
            armory_list:SetSpaceX(9)
            armory_list:SetSpaceY(armory_list:GetSpaceX())
            self.Content.InformationPanel.ArmoryList = armory_list

            local status_btn = self.Content.InformationPanel.Add(self.Content.InformationPanel, "DButton")
            status_btn:SetText("")
            status_btn:SetFont("rpui.Fonts.JobsList.SmallBold")
            status_btn:Dock(TOP)
            status_btn:DockMargin(0, 0, 0, frameH * 0.0075)
            status_btn:SetTall(38)
            status_btn.Status = 0
            status_btn.StatusText = {
                [0] = translates.Get("ВЫБРАТЬ КОМПЛЕКТ"),
                [1] = translates.Get("КОМПЛЕКТ ВЫБРАН"),
                [2] = translates.Get("РАЗБЛОКИРОВАТЬ КОМПЛЕКТ ЗА ")
            }
            status_btn.Paint = function(messss, wssss, hssss)
                local baseColor, textColor = rpui.GetPaintStyle(messss, STYLE_TRANSPARENT_INVERTED)
                surface_SetDrawColor(baseColor)
                surface_DrawRect(0, 0, wssss, hssss)

                if messss.Status == 1 then
                    textColor.a = 175
                end

                draw_SimpleText(messss.StatusText[ messss.Status ] .. (messss.AddedText or ""), messss:GetFont(), wssss*0.5, hssss*0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
            end
            status_btn.DoClick = function(meaa)
				local teamData = self.SelectedJob

				local job_not_available = (teamData.vip and !LocalPlayer():IsVIP()) or (teamData.unlockTime and (teamData.unlockTime > LocalPlayer():GetPlayTime())) or (teamData.minUnlockTime and (LocalPlayer():GetCustomPlayTime(teamData.minUnlockTimeTag) < teamData.minUnlockTime)) or !LocalPlayer():TeamUnlocked( teamData ) or (teamData.customCheck and not teamData.customCheck(LocalPlayer()) and (teamData.CustomCheckFailMsgVisible or teamData.whitelisted))

				if job_not_available then
					rp.Notify(NOTIFY_ERROR, translates.Get("Нельзя выбрать комплект на недоступную профессию"))
					return
				end

                if meaa.Status == 2 and LocalPlayer():GetMoney() < self.NowSelectedArmory.price then
                    self.Content.InformationPanel.FirearmsScroll.ArmoryOver.CantAffrodBucs = rp.FormatMoney(self.NowSelectedArmory.price - LocalPlayer():GetMoney())
                    self.Content.InformationPanel.FirearmsScroll.ArmoryOver.ApplyPaint(self.Content.InformationPanel.FirearmsScroll.ArmoryOver, "CantAffroad")
                else
                    if meaa.Status == 2 then
                        self.Content.InformationPanel.FirearmsScroll.ArmoryOver.ApplyPaint(self.Content.InformationPanel.FirearmsScroll.ArmoryOver, "Buy")
                    end

                    self.NowSelectedArmory.SelectEquip(self.NowSelectedArmory)
                end
            end

            self.Content.InformationPanel.ArmoryStatusButton = status_btn

            self.Content.InformationPanel.FirearmsScroll = vgui.Create( "DPanel", self.Content.InformationPanel );
            self.Content.InformationPanel.FirearmsScroll.Dock( self.Content.InformationPanel.FirearmsScroll, TOP );
            self.Content.InformationPanel.FirearmsScroll.SetTall( self.Content.InformationPanel.FirearmsScroll, frameH * 0.175 );
            self.Content.InformationPanel.FirearmsScroll.Paint = function() end;

            self.Content.InformationPanel.FirearmsContent = vgui.Create( "rpui.ColumnView", self.Content.InformationPanel.FirearmsScroll );
            self.Content.InformationPanel.FirearmsContent.Dock( self.Content.InformationPanel.FirearmsContent, FILL );
            self.Content.InformationPanel.FirearmsContent.SetColumns( self.Content.InformationPanel.FirearmsContent, 2 );
            self.Content.InformationPanel.FirearmsContent.SetSpacingX( self.Content.InformationPanel.FirearmsContent, frameH * 0.005 );
            self.Content.InformationPanel.FirearmsContent.SetSpacingY( self.Content.InformationPanel.FirearmsContent, frameH * 0.005 );

            self.Content.InformationPanel.FirearmsScroll.ArmoryOver = self.Content.InformationPanel.FirearmsScroll.Add(self.Content.InformationPanel.FirearmsScroll, "EditablePanel")
            self.Content.InformationPanel.FirearmsScroll.ArmoryOver.Dock(self.Content.InformationPanel.FirearmsScroll.ArmoryOver, FILL)
            self.Content.InformationPanel.FirearmsScroll.ArmoryOver.SetMouseInputEnabled(self.Content.InformationPanel.FirearmsScroll.ArmoryOver, false)
            self.Content.InformationPanel.FirearmsScroll.ArmoryOver.PaintModes = {
                Buy = function(mett, wtt, htt)
                    draw.Blur(mett)

                    draw_SimpleText(translates.Get("СПАСИБО ЗА ПОКУПКУ"), "rpui.Fonts.JobsList.BigBold", wtt*0.5, htt*0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    draw_SimpleText(translates.Get("КОМПЛЕКТ РАЗБЛОКИРОВАН"), "rpui.Fonts.JobsList.BigBold", wtt*0.5, htt*0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                end,
                CantAffroad = function(meyy, wyy, hyy)
                    draw.Blur(meyy)

                    draw_SimpleText(translates.Get("НЕДОСТАТОЧНО СРЕДСТВ"), "rpui.Fonts.JobsList.BigBold", wyy*0.5, hyy*0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
                    draw_SimpleText(translates.Get("ВАМ НЕХВАТАЕТ ") .. meyy.CantAffrodBucs, "rpui.Fonts.JobsList.BigBold", wyy*0.5, hyy*0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)
                end
            }
            self.Content.InformationPanel.FirearmsScroll.ArmoryOver.ApplyPaint = function(mess, mode, time)
                if (mess.NextApplyPaint or 0) > CurTime() then return end
                mess.NextApplyPaint = CurTime() + 0.6 + (time or 5)

                mess:SetAlpha(0)
                mess:AlphaTo(255, 0.3)

                if mess.PaintModes[mode] then
                    mess.Paint = mess.PaintModes[mode]
                end

                mess:AlphaTo(0, 0.3, time or 5, function()
                    mess.Paint = function() end
                end)
            end

            self.Content.InformationPanel.Spacer = vgui.Create( "DPanel", self.Content.InformationPanel );
            self.Content.InformationPanel.Spacer.Dock( self.Content.InformationPanel.Spacer, TOP );
            self.Content.InformationPanel.Spacer.DockMargin( self.Content.InformationPanel.Spacer, 0, frameH * 0.03, 0, frameH * 0.03 );
            self.Content.InformationPanel.Spacer.SetTall( self.Content.InformationPanel.Spacer, frameH * 0.0025 );
            self.Content.InformationPanel.Spacer.Paint = function( this, w, h )
                surface_SetDrawColor( rpui.UIColors.White );
                surface_DrawRect( 0, 0, w, h );
            end

            self.Content.InformationPanel.DescriptionScroll = vgui.Create( "rpui.ScrollPanel", self.Content.InformationPanel );
            self.Content.InformationPanel.DescriptionScroll.Dock( self.Content.InformationPanel.DescriptionScroll, FILL );
            self.Content.InformationPanel.DescriptionScroll.SetScrollbarWidth( self.Content.InformationPanel.DescriptionScroll, frameH * 0.0085 );
            self.Content.InformationPanel.DescriptionScroll.SetScrollbarMargin( self.Content.InformationPanel.DescriptionScroll, frameH * 0.005 );

            self.Content.InformationPanel.Description = vgui.Create( "DLabel" );
            self.Content.InformationPanel.Description.Dock( self.Content.InformationPanel.Description, TOP );
            self.Content.InformationPanel.Description.SetWrap( self.Content.InformationPanel.Description, true );
            self.Content.InformationPanel.Description.SetAutoStretchVertical( self.Content.InformationPanel.Description, true );
            self.Content.InformationPanel.Description.SetFont( self.Content.InformationPanel.Description, "rpui.Fonts.JobsList.Default" );
            self.Content.InformationPanel.Description.SetTextColor( self.Content.InformationPanel.Description, rpui.UIColors.White );
            self.Content.InformationPanel.Description.SetText( self.Content.InformationPanel.Description, "" );
            self.Content.InformationPanel.DescriptionScroll.AddItem( self.Content.InformationPanel.DescriptionScroll, self.Content.InformationPanel.Description );

			self.Content.Appv1 = vgui.Create( "Panel", self.Content );
            self.Content.Appv1.Dock( self.Content.Appv1, RIGHT );
            self.Content.Appv1.SetWide( self.Content.Appv1, frameW * 0.185 );

            self.Content.ExperiencePanel = vgui.Create( "rpui.ExperiencePanel", self.Content.Appv1 );
            self.Content.ExperiencePanel:Dock( BOTTOM );
            self.Content.ExperiencePanel:SetPadding( frameH * 0.015 );
            self.Content.ExperiencePanel:Hide();
            self:RegisterTooltip( self.Content.ExperiencePanel.Rewards, function()
                local id = self.Content.ExperiencePanel.m_ExperienceID;

                local t = rp.Experiences:GetExperienceType( id );
                local current_level = t:ExperienceToLevel( rp.Experiences:GetExperience(LocalPlayer(), id) );

                local reward_level, reward_list = t:GetNextLevelReward( current_level );

                if reward_level then
                    return self.Content.ExperiencePanel.Rewards:GetText() .. ":\n\n" .. table.concat( reward_list, "\n" );
                end

                return "";
            end, 1, false, function( pnl, tooltip )
                return pnl:LocalToScreen( pnl:GetWide() - tooltip:GetWide(), 0 );
            end );

            --

            self.Content.Appv2 = vgui.Create( "rpui.ScrollPanel", self.Content.Appv1 );
            self.Content.Appv2.Dock( self.Content.Appv2, FILL );
			self.Content.Appv2.SetSpacingY(self.Content.Appv2, 0)
			self.Content.Appv2.SetScrollbarMargin(self.Content.Appv2, 0)

            self.Content.AppearanceSelector = vgui.Create( "Panel", self.Content.Appv2 );
            self.Content.AppearanceSelector.Dock( self.Content.AppearanceSelector, FILL );

			self.Content.Appv2.AddItem(self.Content.Appv2, self.Content.AppearanceSelector)
			self.Content.Appv2.InvalidateParent(self.Content.Appv2, true)
			self.Content.Appv2.AlwaysLayout(self.Content.Appv2, true)

            self.Content.AppearanceSelector.Model = vgui.Create( "rpui.ButtonWang", self.Content.AppearanceSelector );
            self.Content.AppearanceSelector.Model.Dock( self.Content.AppearanceSelector.Model, TOP );
            self.Content.AppearanceSelector.Model.DockMargin( self.Content.AppearanceSelector.Model, 0, 0, 0, frameH * 0.0075 );
            self.Content.AppearanceSelector.Model.SetTall( self.Content.AppearanceSelector.Model, frameH * 0.03  + frameH * 0.0125 );
            self.Content.AppearanceSelector.Model.SetFont( self.Content.AppearanceSelector.Model, "rpui.Fonts.JobsList.Big" );
            self.Content.AppearanceSelector.Model.SetText( self.Content.AppearanceSelector.Model, translates.Get("МОДЕЛЬ") );
            self.Content.AppearanceSelector.Model.NoRemove = true;
            self.Content.AppearanceSelector.Model.Paint = function( this, w, h )
                surface_SetDrawColor( rpui.UIColors.Background );
                surface_DrawRect( 0, 0, w, h );
                draw_SimpleText( this.Text, this.Font, w/2, h/2, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end
            self.Content.AppearanceSelector.Model.Prev.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_BLANKSOLID );
                surface_SetDrawColor( baseColor );
                surface_DrawRect( 0, 0, w, h );
                draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                return true
            end
            self.Content.AppearanceSelector.Model.Next.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_BLANKSOLID );
                surface_SetDrawColor( baseColor );
                surface_DrawRect( 0, 0, w, h );
                draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                return true
            end
            self.Content.AppearanceSelector.Model.OnValueChanged = function( this, value )
                self.AppearanceModel = value;
                self:SelectAppearance( self.AppearancePointers[value] );
                self:RefreshAppearanceVisuals();
            end

            self.Content.AppearanceSelector.Random = vgui.Create( "DButton", self.Content.AppearanceSelector );
            self.Content.AppearanceSelector.Random.Dock( self.Content.AppearanceSelector.Random, TOP );
            self.Content.AppearanceSelector.Random.DockMargin( self.Content.AppearanceSelector.Random, 0, 0, 0, frameH * 0.0075 );
            self.Content.AppearanceSelector.Random.SetZPos( self.Content.AppearanceSelector.Random, 228 );
            self.Content.AppearanceSelector.Random.SetFont( self.Content.AppearanceSelector.Random, "rpui.Fonts.JobsList.Big" );
            self.Content.AppearanceSelector.Random.SetText( self.Content.AppearanceSelector.Random, translates.Get("СЛУЧАЙНЫЙ ВЫБОР") );
            self.Content.AppearanceSelector.Random.SetTall( self.Content.AppearanceSelector.Random, frameH * 0.03  + frameH * 0.0125 );
            self.Content.AppearanceSelector.Random.NoRemove = true;
            self.Content.AppearanceSelector.Random.Paint = function( this, w, h )
                surface_SetDrawColor( rpui.UIColors.Background );
                surface_DrawRect( 0, 0, w, h );

                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_BLANKSOLID );
                surface_SetDrawColor( baseColor );
                surface_DrawRect( 0, 0, w, h );
                draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

                return true
            end
            self.Content.AppearanceSelector.Random.DoClick = function( this )
                for k, v in pairs( self.Content.AppearanceSelector.GetChildren(self.Content.AppearanceSelector) ) do
                    if (v:GetName() == "rpui.ButtonWang") and (v:GetTall() > 0) then v:SelectRandom(); end
                end
            end

        self.Content.ModelViewerController = vgui.Create( "Panel", self.Content );
        self.Content.ModelViewerController.Dock( self.Content.ModelViewerController, FILL );
        self.Content.ModelViewerController.OnMouseWheeled = function( this, scrollDelta )
            if IsValid(self.ModelViewer) then
                self.ModelViewer.xVelocity = (self.ModelViewer.xVelocity or 0) + (scrollDelta);
            end
        end
        self.Content.ModelViewerController.OnMousePressed = self.ModelViewer.OnMousePressed;

            self.CloseButton = vgui.Create( "DButton", self.Foreground );
            self.CloseButton.SetSize( self.CloseButton, frameH * 0.15, frameH * 0.05 );
            self.CloseButton.SetFont( self.CloseButton, "rpui.Fonts.JobsList.Small" );
            self.CloseButton.SetText( self.CloseButton, translates.Get("ЗАКРЫТЬ") );
            self.CloseButton.SizeToContentsY( self.CloseButton, frameH * 0.010 );
            self.CloseButton.SizeToContentsX( self.CloseButton, self.CloseButton.GetTall(self.CloseButton) + frameW * 0.015 );
            self.CloseButton.SetPos( self.CloseButton, 0, frameH - self.CloseButton.GetTall(self.CloseButton) );
            self.CloseButton.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this );
                surface_SetDrawColor( baseColor );
                surface_DrawRect( 0, 0, w, h );

                surface_SetDrawColor( rpui.UIColors.White );
                surface_DrawRect( 0, 0, h, h );

                surface_SetDrawColor( Color(0,0,0,this._grayscale or 0) );
                local p = 0.1 * h;
                surface_DrawLine( h, p, h, h - p );

                draw_SimpleText( "✕", "rpui.Fonts.JobsList.Small", h/2, h/2, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                draw_SimpleText( this:GetText(), this:GetFont(), w/2 + h/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

                return true
            end
            self.CloseButton.DoClick = function() self:Close() end;

            self.ActionText = vgui.Create( "DLabel", self.Foreground );
            self.ActionText.SetFont( self.ActionText, "rpui.Fonts.JobsList.Default" );
            self.ActionText.SetTextColor( self.ActionText, rpui.UIColors.White );
            self.ActionText.SetText( self.ActionText, translates.Get("СТОИМОСТЬ РАЗБЛОКИРОВКИ: %s₽", 'inf') );
            self.ActionText.SizeToContents(self.ActionText);
            self.ActionText.SetPos( self.ActionText, frameW - self.ActionText.GetWide(self.ActionText), frameH - self.ActionText.GetTall(self.ActionText) );

            self.RulesButton = vgui.Create( "DButton", self.Foreground );
            self:RegisterTooltip( self.RulesButton, translates.Get("Устав фракции"), TOOLTIP_OFFSET_CENTER );
            self.RulesButton.SetFont( self.RulesButton, "rpui.Fonts.JobsList.Huge" );
            self.RulesButton.SetText( self.RulesButton, "?" );
            self.RulesButton.SizeToContentsY( self.RulesButton, frameH * 0.010 );
            self.RulesButton.SetWide( self.RulesButton, self.RulesButton.GetTall(self.RulesButton) );
            self.RulesButton.SetPos( self.RulesButton, frameW - self.RulesButton.GetWide(self.RulesButton), frameH - self.RulesButton.GetTall(self.RulesButton) - self.ActionText.GetTall(self.ActionText) );
            self.RulesButton.PaintStyle = STYLE_SOLID;
            self.RulesButton.URL = "https://urf.im/";
            self.RulesButton.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, this.PaintStyle );
                surface_SetDrawColor( baseColor );
                surface_DrawRect( 0, 0, w, h );

                local s = h * 0.65;
                surface_SetDrawColor( textColor );
                surface_SetMaterial( self.UIIcons.Rules );
                surface_DrawTexturedRect( w * 0.5 - s * 0.5, h * 0.5 - s * 0.5, s, s );

                return true
            end
            self.RulesButton.DoClick = function( this )
                gui.OpenURL( this.URL );
            end

            self.ActionButton = vgui.Create( "DButton", self.Foreground );
            self.ActionButton.SetSize( self.ActionButton, frameH * 0.25, frameH * 0.05 );
            self.ActionButton.SetFont( self.ActionButton, "rpui.Fonts.JobsList.Huge" );
            self.ActionButton.SetText( self.ActionButton, translates.Get("РАЗБЛОКИРОВАТЬ ПРОФЕССИЮ") );
            self.ActionButton.SizeToContentsX( self.ActionButton, frameW * 0.015 );
            self.ActionButton.SizeToContentsY( self.ActionButton, frameH * 0.010 );
            self.ActionButton.SetPos( self.ActionButton, self.RulesButton.GetX(self.RulesButton) - self.RulesButton.GetWide(self.RulesButton) * 0.1 - self.ActionButton.GetWide(self.ActionButton), frameH - self.ActionButton.GetTall(self.ActionButton) - self.ActionText.GetTall(self.ActionText) );
            self.ActionButton.PaintStyle = STYLE_SOLID;
            self.ActionButton.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, this.PaintStyle );
                surface_SetDrawColor( baseColor );
                surface_DrawRect( 0, 0, w, h );
                draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2-1, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                return true
            end
            self.ActionButton.DoClick = function( this )
                local job = self.SelectedJob;

                if not LocalPlayer():CanTeam(job) then
                    if not LocalPlayer():TeamUnlocked(job) and LocalPlayer():CanAfford(job.unlockPrice) then
                            if not this.isConfirmed then
                                this:SetText( translates.Get("ПОДТВЕРДИТЕ ДЕЙСТВИЕ") );
                                this:SizeToContentsX( frameW * 0.015 );
                                this:SizeToContentsY( frameH * 0.010 );
                                this:SetPos( self.frameW - this:GetWide(), self.frameH - this:GetTall() - self.ActionText.GetTall(self.ActionText) );

                                this.isConfirmed = true;

                                timer.Create( "rpui.JobsList.ConfirmAction", 5, 1, function()
                                    if not IsValid( this ) then return end
                                    this.isConfirmed = false;

                                    this:SetText( translates.Get("РАЗБЛОКИРОВАТЬ ПРОФЕССИЮ") );
                                    this:SizeToContentsX( frameW * 0.015 );
                                    this:SizeToContentsY( frameH * 0.010 );
                                    this:SetPos( self.frameW - this:GetWide(), self.frameH - this:GetTall() - self.ActionText.GetTall(self.ActionText) );
                                end );
                            else
                                rp.UnlockTeam( job.team );
                                timer.Simple( FrameTime() * 5, function() if IsValid(self) then self:SelectJob( job ); end end );
                            end

                            return
                    end
                end

                if rpui.EnableFactionGroupsUI then
                    if LocalPlayer():IsBanned() then return end
                else
                    if
                        LocalPlayer():IsBanned() --or
						--rp.teams[job.team].faction and
						--not rp.IsValidFactionChange( LocalPlayer(), rp.teams[job.team].faction )
                    then
                        return
                    end
                end

                lastAppearanceSelected = {
                    job.team,
                    self.AppearanceModel,
                    self.AppearanceID,
                    self.AppearanceSkin,
                    self.AppearanceScale,
                    self.AppearanceBodygroups,
                    self.AppearanceCustom,
                }

                cookie.Set('jb_' .. rp.cfg.ServerUID .. job.command, util.TableToJSON(lastAppearanceSelected))

                if LocalPlayer():Team() ~= job.team then
                    rp.ChangeTeam( job.team, self.IsThroughF4 );
                    lastAppearanceSelected[8] = CurTime()
                else
                    rp.RunCommand( "model", lastAppearanceSelected[2] );

                    net.Start( "net.appearance.BodygroupData" );
                        net.WriteUInt( lastAppearanceSelected[3], 6 );
                        net.WriteUInt( lastAppearanceSelected[4] or 0, 6 );
                        net.WriteFloat( lastAppearanceSelected[5] );

                        local CustomAppearanceUID = lastAppearanceSelected[7][ lastAppearanceSelected[2] ];
                        net.WriteBool( CustomAppearanceUID and true or false );
                        net.WriteString( CustomAppearanceUID or "" );

                        local bgroups = lastAppearanceSelected[6];
                        local bgroups_keys  = table.GetKeys(bgroups);
                        local bgroups_count = table.Count(bgroups);

                        net.WriteUInt( bgroups_count, 6 );
                        for i = 1, bgroups_count do
                            local id = bgroups_keys[i];
                            net.WriteUInt( id, 6 );
                            net.WriteUInt( bgroups[id], 6 );
                        end
                    net.SendToServer();
                end

                self:Close();
            end

			self.ActionButton._OldDoClick = self.ActionButton.DoClick

            self:AlphaTo( 255, 0.5, 0, function()
                if IsValid( self ) and !self.Closing then
                    hook.Add( "CalcView", "rpui.JobsList.CalcViewOptimization", CalcViewOptimization );
                end
            end );

            if self.OnCreated then
                self:OnCreated();
            end
    end );
end

net.Receive('EmoteActions.SetupModel', function()
    if not lastAppearanceSelected[8] or CurTime() - lastAppearanceSelected[8] > 2 then return end

    rp.RunCommand( "model", lastAppearanceSelected[2] );

    net.Start( "net.appearance.BodygroupData" );
        net.WriteUInt( lastAppearanceSelected[3], 6 );
        net.WriteUInt( lastAppearanceSelected[4] or 0, 6 );
        net.WriteFloat( lastAppearanceSelected[5] );

        local CustomAppearanceUID = lastAppearanceSelected[7][ lastAppearanceSelected[2] ];
        net.WriteBool( CustomAppearanceUID and true or false );
        net.WriteString( CustomAppearanceUID or "" );

        local bgroups = lastAppearanceSelected[6];
        local bgroups_keys  = table.GetKeys(bgroups);
        local bgroups_count = table.Count(bgroups);

        net.WriteUInt( bgroups_count, 6 );
        for i = 1, bgroups_count do
            local id = bgroups_keys[i];
            net.WriteUInt( id, 6 );
            net.WriteUInt( bgroups[id], 6 );
        end
    net.SendToServer();
end)


rp.cfg.Dictionary = rp.cfg.Dictionary or {};
function PANEL:GetTranslation( str )
    local KeyTranslations = table.GetKeys( rp.cfg.Dictionary );
    local out             = str;

    for k, v in pairs( rp.cfg.Dictionary ) do
        local key = table.GetKeys( v )[1];

        if string.find( string.lower(str), string.lower(key) ) then
            out = v[key]
        end
    end

    return string.utf8upper(out);
end


function PANEL:RebuildAppearance( teamData )
    self.AppearanceID = 0;

    self.ViewZOffset = teamData.viewZ or 0
    self.ViewDepthOffset = teamData.viewDepth or 0

    self.AppearancePointers = {};
    self.AppearanceCustom   = {};
    self.AppearanceModels   = {};

    self.AppearanceModel      = "";
    self.AppearanceSkin       = 0;
    self.AppearanceScale      = 1;
    self.AppearanceBodygroups = {};

    local can_use;

    for _, uid in pairs( table.GetKeys(rp.shop.ModelsMap) ) do
        -- can_use = not (rp.shop.ModelsMap[uid][2][teamData.team] or rp.shop.ModelsMap[uid][3][teamData.faction or 0])
        can_use = false;

        if not can_use and rp.shop.ModelsMap[uid][4] then
            can_use = tobool( rp.shop.ModelsMap[uid][4][teamData.team] )
        end

        if not can_use and rp.shop.ModelsMap[uid][5] then
            can_use = tobool( rp.shop.ModelsMap[uid][5][teamData.faction or 0] )
        end

        if (not can_use) or (not LocalPlayer():HasUpgrade(uid)) then
            continue
        end

        for IIndex, MData in pairs(rp.shop.ModelsMap[uid][1]) do
            local mdl = MData;
            table.insert( self.AppearanceModels, mdl );
            self.AppearancePointers[mdl] = 0;
            self.AppearanceCustom[mdl] = uid;
        end
    end

    for k971, mdl971 in pairs(istable(teamData.model) and teamData.model or {teamData.model}) do
        table.insert( self.AppearanceModels, mdl971 );
    end

    local mdlslist = {};
    for k, v in pairs( self.AppearanceModels ) do
        if mdlslist[v] then self.AppearanceModels[k] = nil end
        mdlslist[v] = true;
    end

    if teamData.appearance then
        for appearID, appearData in pairs( teamData.appearance ) do
            local mdls = istable(appearData.mdl) and appearData.mdl or {appearData.mdl};

            for _, mdl in pairs( mdls ) do
                self.AppearancePointers[mdl] = appearID;
            end
        end
    end

    if #self.AppearanceModels > 1 then
        self.Content.AppearanceSelector.Model.DockMargin( self.Content.AppearanceSelector.Model, 0, 0, 0, self.frameH * 0.0075 );
        self.Content.AppearanceSelector.Model.SetTall( self.Content.AppearanceSelector.Model, self.frameH * 0.03  + self.frameH * 0.0125 );
        self.Content.AppearanceSelector.Model.SetValues( self.Content.AppearanceSelector.Model, self.AppearanceModels );
    else
        self.Content.AppearanceSelector.Model.DockMargin( self.Content.AppearanceSelector.Model, 0, 0, 0, 0 );
        self.Content.AppearanceSelector.Model.SetTall( self.Content.AppearanceSelector.Model, 0 );
        self.Content.AppearanceSelector.Model.OnValueChanged( self.Content.AppearanceSelector.Model, self.AppearanceModels[1] );
    end

	timer.Simple(0.3, function()
		if IsValid(self.Content) and IsValid(self.Content.AppearanceSelector) then
			self.Content.AppearanceSelector.SetTall( self.Content.AppearanceSelector, #self.Content.AppearanceSelector.GetChildren(self.Content.AppearanceSelector) * (self.frameH * 0.0075 + self.frameH * 0.03  + self.frameH * 0.0125) );
		end
	end)
end

local sequences = {
    'idle_all_02',
    'pose_standing_01',
    'pose_standing_02',
    'd1_t01_breakroom_watchbreen',
}

function PANEL:SelectAppearance( id )
    if IsValid( self.ModelViewer.Entity ) then
        self.ModelViewer.Entity.SetModel( self.ModelViewer.Entity, self.AppearanceModel );
    end

    for _, v in pairs( self.Content.AppearanceSelector.GetChildren(self.Content.AppearanceSelector) ) do
        if IsValid( v ) and !v.NoRemove then v:Remove(); end
    end

    if id == nil then return end

    self.AppearanceID = id;

    local appearance   = self.SelectedJob.appearance[self.AppearanceID] or {};
    local isRandomable = false;

    local mdlScales = {};

    if appearance.scale ~= nil then
        if (appearance.scale == false) or isnumber(appearance.scale) then
            self.AppearanceScale = appearance.scale or 1;
        else
            if istable(appearance.scale) then
                local smin = appearance.scale[1];
                local smax = appearance.scale[2];
                local step = (smax - smin) / 5;
                for i = smin, smax, step do
                    table.insert( mdlScales, math.Round(i,2) );
                end
            end
        end
    else
        local smin = rp.cfg.AppearanceScaleMin;
        local smax = rp.cfg.AppearanceScaleMax;
        local step = (smax - smin) / 5;
        for i = smin, smax, step do
            table.insert( mdlScales, math.Round(i,2) );
        end
    end

    if #mdlScales ~= 0 then
        local scaleSelector = vgui.Create( "rpui.ButtonWang", self.Content.AppearanceSelector );
        scaleSelector:Dock( TOP );
        scaleSelector:DockMargin( 0, 0, 0, self.frameH * 0.0075 );
        scaleSelector:SetFont( "rpui.Fonts.JobsList.Big" );
        scaleSelector:SetText( translates.Get("РОСТ") );
        scaleSelector:SetTall( self.frameH * 0.03  + self.frameH * 0.0125 );
        scaleSelector.Paint = function( this, w, h )
            surface_SetDrawColor( rpui.UIColors.Background );
            surface_DrawRect( 0, 0, w, h );
            draw_SimpleText( this.Text, this.Font, w/2, h/2, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        end
        scaleSelector.Prev.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_BLANKSOLID );
            surface_SetDrawColor( baseColor );
            surface_DrawRect( 0, 0, w, h );
            draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true
        end
        scaleSelector.Next.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_BLANKSOLID );
            surface_SetDrawColor( baseColor );
            surface_DrawRect( 0, 0, w, h );
            draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true
        end
        scaleSelector.OnValueChanged = function( this, value )
            self.AppearanceScale = value or 1;
            self:RefreshAppearanceVisuals();
        end

        self.AppearancePanelScale = scaleSelector;

        scaleSelector:SetValues( mdlScales );
        scaleSelector:SetPosition( math.ceil(#scaleSelector:GetValues() / 2) );
    else
        self.AppearanceScale = 1;
    end

    --if not self.AppearanceCustom[self.AppearanceModel] then
        if appearance.skins then
            if #appearance.skins > 1 then
                local skinSelector = vgui.Create( "rpui.ButtonWang", self.Content.AppearanceSelector );
                skinSelector:Dock( TOP );
                skinSelector:DockMargin( 0, 0, 0, self.frameH * 0.0075 );
                skinSelector:SetFont( "rpui.Fonts.JobsList.Big" );
                skinSelector:SetText( translates.Get("СКИН") );
                skinSelector:SetTall( self.frameH * 0.03  + self.frameH * 0.0125 );
                skinSelector.Paint = function( this, w, h )
                    surface_SetDrawColor( rpui.UIColors.Background );
                    surface_DrawRect( 0, 0, w, h );
                    draw_SimpleText( this.Text, this.Font, w/2, h/2, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                end
                skinSelector.Prev.Paint = function( this, w, h )
                    local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_BLANKSOLID );
                    surface_SetDrawColor( baseColor );
                    surface_DrawRect( 0, 0, w, h );
                    draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end
                skinSelector.Next.Paint = function( this, w, h )
                    local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_BLANKSOLID );
                    surface_SetDrawColor( baseColor );
                    surface_DrawRect( 0, 0, w, h );
                    draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end
                skinSelector.OnValueChanged = function( this, value )
                    self.AppearanceSkin = value or 0;
                    self:RefreshAppearanceVisuals();
                end
                skinSelector:SetValues( appearance.skins );
                self.AppearancePanelSkin = skinSelector;
                isRandomable = true;
            else
                self.AppearanceSkin = appearance.skins[1] or 0;
            end
        else
            local appearance_skincount = self.ModelViewer.Entity.SkinCount(self.ModelViewer.Entity);

            if appearance_skincount > 1 then
                local appearance_skins = {};
                for skin_id = 0, appearance_skincount - 1 do
                    table.insert( appearance_skins, skin_id );
                end

                local skinSelector = vgui.Create( "rpui.ButtonWang", self.Content.AppearanceSelector );
                skinSelector:Dock( TOP );
                skinSelector:DockMargin( 0, 0, 0, self.frameH * 0.0075 );
                skinSelector:SetFont( "rpui.Fonts.JobsList.Big" );
                skinSelector:SetText( translates.Get("СКИН") );
                skinSelector:SetTall( self.frameH * 0.03  + self.frameH * 0.0125 );
                skinSelector.Paint = function( this, w, h )
                    surface_SetDrawColor( rpui.UIColors.Background );
                    surface_DrawRect( 0, 0, w, h );
                    draw_SimpleText( this.Text, this.Font, w/2, h/2, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                end
                skinSelector.Prev.Paint = function( this, w, h )
                    local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_BLANKSOLID );
                    surface_SetDrawColor( baseColor );
                    surface_DrawRect( 0, 0, w, h );
                    draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end
                skinSelector.Next.Paint = function( this, w, h )
                    local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_BLANKSOLID );
                    surface_SetDrawColor( baseColor );
                    surface_DrawRect( 0, 0, w, h );
                    draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end
                skinSelector.OnValueChanged = function( this, value )
                    self.AppearanceSkin = value or 0;
                    self:RefreshAppearanceVisuals();
                end
                skinSelector:SetValues( appearance_skins );
                self.AppearancePanelSkin = skinSelector;
                isRandomable = true;
            else
                self.AppearanceSkin = 0;
            end
        end

        self.AppearancePanelBGroups = {}

        if appearance.bodygroups then
            for bgroup_id, bgroup_data in pairs( appearance.bodygroups ) do
                if isbool(bgroup_data) and bgroup_data then
                    local out = {};

                    for i = 1, self.ModelViewer.Entity.GetBodygroupCount(self.ModelViewer.Entity, bgroup_id) do
                        table.insert( out, i - 1 );
                    end

                    bgroup_data = out;
                end

                if #bgroup_data > 1 then
                    local bgroupSelector = vgui.Create( "rpui.ButtonWang", self.Content.AppearanceSelector );
                    bgroupSelector:Dock( TOP );
                    bgroupSelector:DockMargin( 0, 0, 0, self.frameH * 0.0075 );
                    bgroupSelector:SetFont( "rpui.Fonts.JobsList.Big" );
                    bgroupSelector:SetText( self:GetTranslation(self.ModelViewer.Entity.GetBodygroupName(self.ModelViewer.Entity, bgroup_id)) );
                    bgroupSelector:SetTall( self.frameH * 0.03  + self.frameH * 0.0125 );
                    bgroupSelector.Paint = function( this, w, h )
                        surface_SetDrawColor( rpui.UIColors.Background );
                        surface_DrawRect( 0, 0, w, h );
                        draw_SimpleText( this.Text, this.Font, w/2, h/2, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    end
                    bgroupSelector.Prev.Paint = function( this, w, h )
                        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_BLANKSOLID );
                        surface_SetDrawColor( baseColor );
                        surface_DrawRect( 0, 0, w, h );
                        draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                        return true
                    end
                    bgroupSelector.Next.Paint = function( this, w, h )
                        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_BLANKSOLID );
                        surface_SetDrawColor( baseColor );
                        surface_DrawRect( 0, 0, w, h );
                        draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                        return true
                    end
                    bgroupSelector.OnValueChanged = function( this, value )
                        self.AppearanceBodygroups[bgroup_id] = value or 0;
                        self:RefreshAppearanceVisuals();
                    end
                    bgroupSelector:SetValues( bgroup_data );
                    self.AppearancePanelBGroups[bgroup_id] = bgroupSelector;
                    isRandomable = true;
                else
                    self.AppearanceBodygroups[bgroup_id] = bgroup_data[1] or 0;
                end
            end
        elseif rp.cfg.JobShowAllBodygroups ~= false or self.AppearanceCustom[self.AppearanceModel] then
            for bgroup_uid, bgroup in pairs( self.ModelViewer.Entity.GetBodyGroups(self.ModelViewer.Entity) ) do
                local bgroup_id = bgroup.id;
                if bgroup_id == 1 then continue end

                local bgroup_data = table.GetKeys( bgroup.submodels );
                if #bgroup_data > 1 then
                    local bgroupSelector = vgui.Create( "rpui.ButtonWang", self.Content.AppearanceSelector );
                    bgroupSelector:Dock( TOP );
                    bgroupSelector:DockMargin( 0, 0, 0, self.frameH * 0.0075 );
                    bgroupSelector:SetFont( "rpui.Fonts.JobsList.Big" );
                    bgroupSelector:SetText( self:GetTranslation(self.ModelViewer.Entity.GetBodygroupName(self.ModelViewer.Entity, bgroup_id)) );
                    bgroupSelector:SetTall( self.frameH * 0.03  + self.frameH * 0.0125 );
                    bgroupSelector.Paint = function( this, w, h )
                        surface_SetDrawColor( rpui.UIColors.Background );
                        surface_DrawRect( 0, 0, w, h );
                        draw_SimpleText( this.Text, this.Font, w/2, h/2, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    end
                    bgroupSelector.Prev.Paint = function( this, w, h )
                        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_BLANKSOLID );
                        surface_SetDrawColor( baseColor );
                        surface_DrawRect( 0, 0, w, h );
                        draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                        return true
                    end
                    bgroupSelector.Next.Paint = function( this, w, h )
                        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_BLANKSOLID );
                        surface_SetDrawColor( baseColor );
                        surface_DrawRect( 0, 0, w, h );
                        draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                        return true
                    end
                    bgroupSelector.OnValueChanged = function( this, value )
                        self.AppearanceBodygroups[bgroup_id] = value or 0;
                        self:RefreshAppearanceVisuals();
                    end
                    bgroupSelector:SetValues( bgroup_data );
                    self.AppearancePanelBGroups[bgroup_id] = bgroupSelector;
                    isRandomable = true;
                else
                    self.AppearanceBodygroups[bgroup_id] = bgroup_data[1] or 0;
                end
            end
        end
    --end

    if self.Content.AppearanceSelector.Model.GetTall(self.Content.AppearanceSelector.Model) > 0 or isRandomable then
        self.Content.AppearanceSelector.Random.SetVisible( self.Content.AppearanceSelector.Random, true );
    else
        self.Content.AppearanceSelector.Random.SetVisible( self.Content.AppearanceSelector.Random, false );
    end

    local mdlent = self.ModelViewer.Entity;
    local seq_list = {};

    if appearance.sequences then
        local seqs = appearance.sequences;

        if isstring( appearance.sequences ) then
            seqs = { appearance.sequences };
        end

        if istable( seqs ) then
            table.Add( seq_list, seqs );

            for k, seq in ipairs( seq_list ) do
                if mdlent:LookupSequence( seq ) > 0 then continue end
                table.remove( seq_list, k );
            end
        end
    else
        table.Add( seq_list, sequences );
    end

    local seq = seq_list[math.random(#seq_list)]
    local idd = mdlent:LookupSequence(seq)

	timer.Simple(0, function()
        if (not IsValid(self)) or (not IsValid(self.Content)) then return end

		if IsValid(self.Content.AppearanceSelector) then
			self.Content.AppearanceSelector.SetTall( self.Content.AppearanceSelector, #self.Content.AppearanceSelector.GetChildren(self.Content.AppearanceSelector) * (self.frameH * 0.0075 + self.frameH * 0.03  + self.frameH * 0.0125) );
		end
	end)

    mdlent:ResetSequence( mdlent:LookupSequence(idd > 0 and seq or "idle_all_02") )

    self:BuildArmoryList()
end

function PANEL:BuildArmoryList()
    local armory_list = self.Content.InformationPanel.ArmoryList

    for k, v in pairs(armory_list:GetChildren()) do
        if IsValid(v) then v:Remove() end
    end

    local has_ar = tobool(self.SelectedJob.Armory)
    self.Content.InformationPanel.ArmoryStatusButton.SetVisible(self.Content.InformationPanel.ArmoryStatusButton, has_ar)

    if not self.SelectedJob.Armory then return end

    local jindex = self.SelectedJob.TIndex

    if not self.SelectedJob.ArmoryReceived then
        net.Start("urf.im/job_armory_info")
            net.WriteUInt(jindex, 10)
        net.SendToServer()
    end

    local first = true

    local ArmoryLink = self.SelectedJob.Armory

    local buy_txt =  translates.Get("КУПИТЬ") .." "
    local accept_txt = translates.Get("ПОДТВЕРДИТЕ")

    local white = Color(255, 255, 255)
    local black = Color(0, 0, 0)
    local white_dark = Color(200, 185, 185)
    local lock_mat = Material("cmenu/lock_weap.png", "smooth", "noclamp")

    local jtab = rp.teams[jindex]

    for k, armory in pairs(ArmoryLink) do
        local btn = armory_list:Add("DButton")
        btn:SetFont("rpui.Fonts.JobsList.Big")
        btn:SetText(armory.name)

        surface.SetFont("rpui.Fonts.JobsList.Big")
        local _txtW = surface.GetTextSize(armory.name)

        btn:SetSize(_txtW + 64, 38)
        btn:SetText("")
        btn.Txt = armory.name
        btn.price = armory.price

        local LoadArmory = false
		LoadArmory = function(ar)
            if ar.IsActive or ar.free then
                self:ParseArmory(armory.weapons)
                self.NowSelectedArmory = btn
            end
        end

        if jtab.ArmoryReceived then
            LoadArmory(jtab.Armory[k])
        else
            LoadArmory(armory)

            hook.Add("urf.im/job_armory_info", "f4menu", function(jindex_2, armorytp)
                if jindex == jindex_2 then
                    LoadArmory(armorytp)
                end
            end)
        end

        local formatedPrice = rp.FormatMoney(armory.price)

        btn.Paint = function(me11, waaat, haaat)
            local ar = jtab.Armory[k]
            local tr_style = armory.free or ar.IsBuyed == true

            surface.SetFont("rpui.Fonts.JobsList.Big")
            local _txtW = surface.GetTextSize(armory.name)
            me11:SetWide(_txtW + (tr_style and 16 or 64))
            armory_list:LayoutIcons_TOP()
            armory_list:SizeToChildren(armory_list:GetStretchWidth(), armory_list:GetStretchHeight())

            local baseColor, textColor = rpui.GetPaintStyle(me11, STYLE_TRANSPARENT_INVERTED)

            me11.IsAvailable = tr_style

            surface_SetDrawColor(self.NowSelectedArmory == me11 and white or baseColor)
            surface_DrawRect(0, 0, waaat, haaat)

            surface_SetFont(me11:GetFont())
            local tw, th = surface_GetTextSize(me11.Txt)

            local dark_col = textColor.r >= 185 and white_dark or textColor

            if not tr_style then
                surface_SetDrawColor(self.NowSelectedArmory == me11 and black or dark_col)
                surface_SetMaterial(lock_mat)
                surface_DrawTexturedRect(waaat*0.5 + tw*0.5, 8, 20, 20)
            end

            draw_SimpleText(me11.Txt, me11:GetFont(), waaat*0.5 - (tr_style and 0 or 10), haaat*0.5, self.NowSelectedArmory == me11 and black or (tr_style and textColor or dark_col), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

            if self.NowSelectedArmory == me11 then
                local link = self.Content.InformationPanel.ArmoryStatusButton
                link.Status = (ar.IsActive and 1) or (tr_style and 0) or 2
                link.AddedText = (link.Status == 2) and formatedPrice or ""
            end
        end

        btn.DoClick = function(me12)
            self:ParseArmory(armory.weapons)
            self.NowSelectedArmory = me12
        end
        btn.SelectEquip = function()
            if timer.Exists("urf.im/job_armory") then
                timer.Create("urf.im/job_armory", 1, 1, function()
                    net.Start("urf.im/job_armory")
                        net.WriteUInt(k, 4)
                        net.WriteUInt(jindex, 10)
                    net.SendToServer()
                end)
            else
                net.Start("urf.im/job_armory")
                    net.WriteUInt(k, 4)
                    net.WriteUInt(jindex, 10)
                net.SendToServer()
                timer.Create("urf.im/job_armory", 1, 1, function() end)
            end
        end
    end
end

function PANEL:ParseArmory(weps)
    local WeaponsList = {};
    local FirearmsWeapons = {};

    table.Add( WeaponsList, table.Copy(weps) );

    for _, wep_class in pairs( WeaponsList ) do
        local wep = weapons.Get( wep_class );
        if wep then
            table.insert( FirearmsWeapons, wep );
        end
    end

    self.Content.InformationPanel.FirearmsContent.Clear(self.Content.InformationPanel.FirearmsContent);

    local plr = 0.01 * self.frameH;
    local ptb = 0.005 * self.frameH;

    for k, wep in pairs( FirearmsWeapons ) do
        local weaponPnl = vgui.Create( "Panel" );
        weaponPnl:Dock( TOP );
        weaponPnl:DockPadding( plr, ptb, plr, ptb );
        weaponPnl.Paint = function( thisaaa, waaa, haaa )
            surface_SetDrawColor( rpui.UIColors.Background );
            surface_DrawRect( 0, 0, waaa, haaa );
        end
        if wep.Instructions or wep.Purpose then
            local out = "";

            if wep.Instructions and #wep.Instructions > 0 then
                out = wep.Instructions;
                if #wep.Purpose > 0 then out = out .. "\n" end
            end

            if wep.Purpose and #wep.Purpose > 0 then
                out = out .. wep.Purpose;
            end

            out = string.Trim(out);

            if out and #out ~= 0 then
                self:RegisterTooltip( weaponPnl, out, TOOLTIP_OFFSET_LEFT, true );
            end
        end

        weaponPnl.Title = vgui.Create( "DLabel", weaponPnl );
        weaponPnl.Title.Dock( weaponPnl.Title, TOP );
        weaponPnl.Title.DockMargin( weaponPnl.Title, 0, 0, 0, ptb );
        weaponPnl.Title.SetFont( weaponPnl.Title, "rpui.Fonts.JobsList.Default" );
        weaponPnl.Title.SetTextColor( weaponPnl.Title, rpui.UIColors.White );
        weaponPnl.Title.SetText( weaponPnl.Title, language.GetPhrase(wep.PrintName) );
        weaponPnl.Title.SizeToContentsY(weaponPnl.Title);
        weaponPnl.Title.InvalidateParent( weaponPnl.Title, true );

        weaponPnl.Damage = vgui.Create( "DLabel", weaponPnl );
        weaponPnl.Damage.Dock( weaponPnl.Damage, TOP );
        weaponPnl.Damage.SetFont( weaponPnl.Damage, "rpui.Fonts.JobsList.Micro" );
        weaponPnl.Damage.SetTextColor( weaponPnl.Damage, rpui.UIColors.White );
        weaponPnl.Damage.SetText( weaponPnl.Damage, translates.Get("УРОН") );
        weaponPnl.Damage.SizeToContentsY(weaponPnl.Damage);
        weaponPnl.Damage.InvalidateParent( weaponPnl.Damage, true );
        weaponPnl.Damage.BakedCircles = {};
        weaponPnl.Damage.Value = math.Round( ((wep.Primary.Damage and wep.Primary.Damage or (isnumber(wep.Damage) and wep.Damage or (wep.DamageMin and math.random(wep.DamageMin, wep.DamageMax) or 0))) / 100) * 5 );
        weaponPnl.Damage.Paint = function( thisds, wds, hds )
            local icon_size   = math.floor(hds * 0.75);
            local icon_margin = math.floor(icon_size * 0.2);

            for i = 1, 5 do
                if not thisds.BakedCircles[i] then
                    thisds.BakedCircles[i] = rpui.BakeCircle(
                        wds - (icon_size * i) - (icon_margin * (i-1)),
                        hds/2 - icon_size/2,
                        icon_size, 16
                    );
                end

                draw_NoTexture();
                surface_SetDrawColor( (5 - thisds.Value) < i and rpui.UIColors.White or rpui.UIColors.Black );
                surface_DrawPoly( thisds.BakedCircles[i] );
            end
        end

        weaponPnl.Recoil = vgui.Create( "DLabel", weaponPnl );
        weaponPnl.Recoil.Dock( weaponPnl.Recoil, TOP );
        weaponPnl.Recoil.SetFont( weaponPnl.Recoil, "rpui.Fonts.JobsList.Micro" );
        weaponPnl.Recoil.SetTextColor( weaponPnl.Recoil, rpui.UIColors.White );
        weaponPnl.Recoil.SetText( weaponPnl.Recoil, translates.Get("ОТДАЧА") );
        weaponPnl.Recoil.SizeToContentsY(weaponPnl.Recoil);
        weaponPnl.Recoil.InvalidateParent( weaponPnl.Recoil, true );
        weaponPnl.Recoil.BakedCircles = {};
        weaponPnl.Recoil.Value = 0;
        if wep.Recoil and wep.FireDelay then
            local rpm_recoil = wep.Recoil * (wep.FireDelay * 60);
            weaponPnl.Recoil.Value = math.Round( (rpm_recoil / 14) * 5 );
        end
        weaponPnl.Recoil.Paint = function( thisffd, wffd, hffd )
            local icon_size   = math.floor(hffd * 0.75);
            local icon_margin = math.floor(icon_size * 0.2);

            for i = 1, 5 do
                if not thisffd.BakedCircles[i] then
                    thisffd.BakedCircles[i] = rpui.BakeCircle(
                        wffd - (icon_size * i) - (icon_margin * (i-1)),
                        hffd/2 - icon_size/2,
                        icon_size, 16
                    );
                end

                draw_NoTexture();
                surface_SetDrawColor( (5 - thisffd.Value) < i and rpui.UIColors.White or rpui.UIColors.Black );
                surface_DrawPoly( thisffd.BakedCircles[i] );
            end
        end

        weaponPnl.RPM = vgui.Create( "DLabel", weaponPnl );
        weaponPnl.RPM.Dock( weaponPnl.RPM, TOP );
        weaponPnl.RPM.SetFont( weaponPnl.RPM, "rpui.Fonts.JobsList.Micro" );
        weaponPnl.RPM.SetTextColor( weaponPnl.RPM, rpui.UIColors.White );
        weaponPnl.RPM.SetText( weaponPnl.RPM, translates.Get("ТЕМП СТРЕЛЬБЫ") );
        weaponPnl.RPM.SizeToContentsY(weaponPnl.RPM);
        weaponPnl.RPM.InvalidateParent( weaponPnl.RPM, true );
        weaponPnl.RPM.BakedCircles = {};
        weaponPnl.RPM.Value = 0;
        if wep.FireDelay then
            weaponPnl.RPM.Value = 60 / wep.FireDelay;
        elseif wep.Primary.RPM then
            weaponPnl.RPM.Value = wep.Primary.RPM;
        end
        weaponPnl.RPM.Value = math.Round( (weaponPnl.RPM.Value / 1400) * 5 );

        weaponPnl.RPM.Paint = function( thisdsa, wdsa, hdsa )
            local icon_size   = math.floor(hdsa * 0.75);
            local icon_margin = math.floor(icon_size * 0.2);

            for i = 1, 5 do
                if not thisdsa.BakedCircles[i] then
                    thisdsa.BakedCircles[i] = rpui.BakeCircle(
                        wdsa - (icon_size * i) - (icon_margin * (i-1)),
                        hdsa/2 - icon_size/2,
                        icon_size, 16
                    );
                end

                draw_NoTexture();
                surface_SetDrawColor( (5 - thisdsa.Value) < i and rpui.UIColors.White or rpui.UIColors.Black );
                surface_DrawPoly( thisdsa.BakedCircles[i] );
            end
        end

        weaponPnl:SizeToChildren( false, true );
        weaponPnl:InvalidateParent( true );

        self.Content.InformationPanel.FirearmsContent.AddItem( self.Content.InformationPanel.FirearmsContent, weaponPnl );
    end

    self.Content.InformationPanel.FirearmsContent.PerformLayout(self.Content.InformationPanel.FirearmsContent);

    timer.Simple( FrameTime() * 5, function()
        if not IsValid( self ) then return end

            self.Content.InformationPanel.DefaultWeaponsTitle.DockMargin( self.Content.InformationPanel.DefaultWeaponsTitle, 0, 0, 0, 0 );
            self.Content.InformationPanel.DefaultWeaponsTitle.SetTall( self.Content.InformationPanel.DefaultWeaponsTitle, 0 );

            self.Content.InformationPanel.DefaultWeaponsContent.SetTall( self.Content.InformationPanel.DefaultWeaponsContent, 0 );

        self.Content.InformationPanel.FirearmsScroll.SetTall( self.Content.InformationPanel.FirearmsScroll, math.min( self.Content.InformationPanel.FirearmsContent.GetTall(self.Content.InformationPanel.FirearmsContent), self.frameH * 0.185 ) );

        if self.Content.InformationPanel.FirearmsScroll.GetTall(self.Content.InformationPanel.FirearmsScroll) > 0 then
            self.Content.InformationPanel.FirearmsTitle.DockMargin( self.Content.InformationPanel.FirearmsTitle, 0, self.frameH * 0.015, 0, self.frameH * 0.005 );
            self.Content.InformationPanel.FirearmsTitle.SizeToContentsY(self.Content.InformationPanel.FirearmsTitle);
        else
            self.Content.InformationPanel.FirearmsTitle.SetTall( self.Content.InformationPanel.FirearmsTitle, 0 );
            self.Content.InformationPanel.FirearmsTitle.DockMargin( self.Content.InformationPanel.FirearmsTitle, 0, 0, 0, 0 );
        end

        self.Content.InformationPanel.FirearmsScroll.PerformLayout(self.Content.InformationPanel.FirearmsScroll);
    end );
end


function PANEL:RefreshAppearanceVisuals()
    local mdlent = self.ModelViewer.Entity;
    if (!IsValid(mdlent)) then return end

    --mdlent:ResetSequence( mdlent:LookupSequence("idle_all_02") );

    local offZ = 0.01 * (self.ViewZOffset or 0)
    local offDepth = 0.01 * (self.ViewDepthOffset or 0)

    local mins, maxs = mdlent:GetModelBounds();
    local _mdlOrigin = Vector( 16, -20, maxs.z * (0.7 - offZ) );
    local _camOrigin = _mdlOrigin - Vector( -100, 0, 0 );
    _camOrigin = _camOrigin - (_mdlOrigin - _camOrigin) * offDepth
    self.ModelViewer.SetLookAt( self.ModelViewer, _mdlOrigin );
    self.ModelViewer.SetCamPos( self.ModelViewer, _camOrigin );
    self.ModelViewer.ZoomingVector = Vector(1,-0.15,0);
    mdlent:SetEyeTarget( _camOrigin );

    function mdlent.GetPlayerColor()
        return LocalPlayer():GetPlayerColor()
    end

    mdlent:SetSkin( self.AppearanceSkin or 0 );
    mdlent:SetModelScale( self.AppearanceScale or 1 );

    for k, v in pairs( mdlent:GetBodyGroups() ) do
        mdlent:SetBodygroup( k, 0 );
    end

    for bgroup_id, bgroup in pairs( self.AppearanceBodygroups or {} ) do
        mdlent:SetBodygroup( bgroup_id, bgroup );
    end
end


function PANEL:SetTitle( title )
    self.FactionSelector.Title.SetText( self.FactionSelector.Title, title );
    self.FactionSelector.Title.SizeToContentsX(self.FactionSelector.Title);
end


function PANEL:SetStats( salary, armor )
    self.Content.InformationPanel.Stats.SalaryText.SetText( self.Content.InformationPanel.Stats.SalaryText, salary );
    self.Content.InformationPanel.Stats.SalaryText.SizeToContentsX( self.Content.InformationPanel.Stats.SalaryText, self.frameW * 0.01 );
    self.Content.InformationPanel.Stats.ArmorText.SetText( self.Content.InformationPanel.Stats.ArmorText, armor );
    self.Content.InformationPanel.Stats.ArmorText.SizeToContentsX(self.Content.InformationPanel.Stats.ArmorText);
end


function PANEL:ParseStatsIcons( teamData )
    self.Content.InformationPanel.Stats.IconList.Clear(self.Content.InformationPanel.Stats.IconList);

    local icon_size = rpui.PowOfTwo( self.Content.InformationPanel.Stats.GetTall(self.Content.InformationPanel.Stats) * 0.65 );

    for key, mat in pairs( self.UIIcons.Stats ) do
        if TypeID(mat) ~= TYPE_MATERIAL then continue end
        if key == "armor" then continue end

        if teamData[key] then
            local b = teamData[key];

            if isnumber(b) then
                b = (b > 0) and true or false;
            end

            if not b then continue end

            local staticon = vgui.Create( "Panel", self.Content.InformationPanel.Stats.IconList );
            staticon:Dock( LEFT );
            staticon:DockMargin( 0, 0, icon_size * 0.4, 0 );
            staticon:SetWide( icon_size );
            staticon.Material = mat;
            staticon.Paint = function( this, w, h )
                surface_SetDrawColor( Color(255,255,255,255) );
                surface_SetMaterial( this.Material );
                surface_DrawTexturedRect( 0, h/2 - w/2, w, w );
            end
            staticon:InvalidateParent( true );

            self:RegisterTooltip( staticon, self.TooltipList[key] or "<"..key..">", TOOLTIP_OFFSET_CENTER, false );
        end
    end

    for k, v in pairs( self.CustomStats ) do
        if not v.Check( teamData ) then continue end

        local staticon = vgui.Create( "Panel", self.Content.InformationPanel.Stats.IconList );
        staticon:Dock( LEFT );
        staticon:DockMargin( 0, 0, icon_size * 0.4, 0 );

        local icon_size_s = icon_size;

        if v.ScalingFactor then
            icon_size_s = icon_size_s * v.ScalingFactor;
        end

        staticon:SetWide( icon_size_s );
        staticon.Material = v.GetMaterial(teamData) or self.UIIcons.Blank;
        staticon.Paint = function( this, w, h )
            surface_SetDrawColor( Color(255,255,255,255) );
            surface_SetMaterial( this.Material );
            surface_DrawTexturedRect( 0, h/2 - w/2, w, w );
        end
        staticon:InvalidateParent( true );

        self:RegisterTooltip( staticon, v.GetTooltip(teamData) or "<"..k..">", TOOLTIP_OFFSET_CENTER, false );
    end

    self.Content.InformationPanel.Stats.IconList.SizeToChildren( self.Content.InformationPanel.Stats.IconList, true, false );
end


function PANEL:ParseWeapons( weps )
    local WeaponsList = {};

    local DefaultWeapons  = {};
    local FirearmsWeapons = {};

    table.Add( WeaponsList, table.Copy(weps) );

    for _, wep_class in pairs( WeaponsList ) do
        local wep = weapons.Get( wep_class );
        if wep then
            --local ammo = wep.Primary.Ammo;
            --local isNotFirearms = (ammo == nil or ammo == "" or ammo == "none" or ammo == "XBowBolt");

            --if isNotFirearms then
                table.insert( DefaultWeapons, wep );
            --else
            --    table.insert( FirearmsWeapons, wep );
            --end
        end
    end

    self.Content.InformationPanel.FirearmsContent.Clear(self.Content.InformationPanel.FirearmsContent);

    local plr = 0.01 * self.frameH;
    local ptb = 0.005 * self.frameH;

    self.Content.InformationPanel.DefaultWeaponsContent.SetWeapons( self.Content.InformationPanel.DefaultWeaponsContent, DefaultWeapons );

    self.Content.InformationPanel.FirearmsContent.PerformLayout(self.Content.InformationPanel.FirearmsContent);

    timer.Simple( FrameTime() * 5, function()
        if not IsValid( self ) then return end

        if table.Count(DefaultWeapons) > 0 then
            self.Content.InformationPanel.DefaultWeaponsTitle.DockMargin( self.Content.InformationPanel.DefaultWeaponsTitle, 0, self.frameH * 0.015, 0, 0 );

            self.Content.InformationPanel.DefaultWeaponsTitle.SizeToContentsY(self.Content.InformationPanel.DefaultWeaponsTitle);
            self.Content.InformationPanel.DefaultWeaponsContent.SizeToContentsY(self.Content.InformationPanel.DefaultWeaponsContent);
        else
            self.Content.InformationPanel.DefaultWeaponsTitle.DockMargin( self.Content.InformationPanel.DefaultWeaponsTitle, 0, 0, 0, 0 );
            self.Content.InformationPanel.DefaultWeaponsTitle.SetTall( self.Content.InformationPanel.DefaultWeaponsTitle, 0 );

            self.Content.InformationPanel.DefaultWeaponsContent.SetTall( self.Content.InformationPanel.DefaultWeaponsContent, 0 );
        end

        self.Content.InformationPanel.FirearmsScroll.SetTall( self.Content.InformationPanel.FirearmsScroll, math.min( self.Content.InformationPanel.FirearmsContent.GetTall(self.Content.InformationPanel.FirearmsContent), self.frameH * 0.185 ) );

        if self.Content.InformationPanel.FirearmsScroll.GetTall(self.Content.InformationPanel.FirearmsScroll) > 0 then
            self.Content.InformationPanel.FirearmsTitle.DockMargin( self.Content.InformationPanel.FirearmsTitle, 0, self.frameH * 0.015, 0, self.frameH * 0.005 );
            self.Content.InformationPanel.FirearmsTitle.SizeToContentsY(self.Content.InformationPanel.FirearmsTitle);
        else
            self.Content.InformationPanel.FirearmsTitle.SetTall( self.Content.InformationPanel.FirearmsTitle, 0 );
            self.Content.InformationPanel.FirearmsTitle.DockMargin( self.Content.InformationPanel.FirearmsTitle, 0, 0, 0, 0 );
        end

        self.Content.InformationPanel.FirearmsScroll.PerformLayout(self.Content.InformationPanel.FirearmsScroll);
    end );
end


function PANEL:SetDescription( desc )
    self.Content.InformationPanel.Description.SetText( self.Content.InformationPanel.Description, string.Trim(desc or "") );
    self.Content.InformationPanel.Description.SizeToContentsY(self.Content.InformationPanel.Description);

    timer.Simple( FrameTime() * 10, function()
        if not IsValid( self ) then return end

        self.Content.InformationPanel.DescriptionScroll.SetOffset( self.Content.InformationPanel.DescriptionScroll, 0 );
        self.Content.InformationPanel.DescriptionScroll.PerformLayout(self.Content.InformationPanel.DescriptionScroll);
        self.Content.InformationPanel.DescriptionScroll.VBar.PerformLayout(self.Content.InformationPanel.DescriptionScroll.VBar);
    end );
end


function PANEL:LoadFactionGroups()
    timer.Simple(0, function()
        for id, group in pairs( rp.FactionGroups or {} ) do
            local avalibleFactions = {};
            for _, faction_id in ipairs( group.factions ) do
                local f = rp.Factions[faction_id];
                if not f or f.dontShow or (self.ForcedFaction and faction_id ~= self.ForcedFaction) then continue end

                local avalibleJobs = {};
                for t in pairs( f.jobs ) do
                    local teamData = rp.teams[t];

                    if teamData.side and rp.Sides then
                        if teamData.side ~= LocalPlayer():GetSide() then
                            continue
                        end
                    end

                    if teamData.customCheck then
                        if teamData.customCheck( LocalPlayer() ) or teamData.whitelisted and (teamData.whitelistURL or teamData.CustomCheckFailMsgVisible) then
                            table.insert( avalibleJobs, t );
                        end
                    else
                        table.insert( avalibleJobs, t );
                    end
                end

                if #avalibleJobs > 0 then
                    table.insert( avalibleFactions, faction_id );
                end
            end
            if #avalibleFactions == 0 then continue end

            local groupBtn = vgui.Create( "DButton", self.GroupSelector.Content );
            groupBtn:SetFont( "rpui.Fonts.JobsList.Title" );
            groupBtn:SetText( string.utf8upper(group.printName) );
            groupBtn:SizeToContentsX( self.frameW * 0.015 );
            groupBtn.DoClick = function( this )
                if not this.Selected then
                    for k, v in pairs( self.GroupSelector.Buttons ) do v.Selected = false; end

                    this.Selected = true;
                    self:SelectFactionGroup( id );
                end
            end

            if self.ForcedFaction then
                groupBtn.Selected = true
            end

            groupBtn.Paint = function( this, w, h )
                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                surface_SetDrawColor( baseColor );
                surface_DrawRect( 0, 0, w, h );
                draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2 - 1, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                return true
            end
            self.GroupSelector.Content.AddPanel( self.GroupSelector.Content, groupBtn );
            table.insert( self.GroupSelector.Buttons, groupBtn );

            self.SelectedGroupFaction[id] = {};
        end
    end)
end

function PANEL:SelectFactionGroup( group, faction_select )
    for k, v in pairs( self.FactionSelector.Buttons ) do
        v:Remove(); self.FactionSelector.Buttons[k] = nil;
    end

    self.SelectedGroup = group;
    self:SetFaction( rp.FactionGroups[group].factions, faction_select and faction_select or self.SelectedGroupFaction[group] );
end


function PANEL:SetFaction( faction_tbl, faction_select )
    local is_forced = isnumber(faction_tbl) and rp.cfg.ForceFaction
    if isnumber(faction_tbl) then faction_tbl = {faction_tbl} end

    if is_forced then
        self.ForcedFaction = faction_tbl[1]
    end

    if not faction_select then
        faction_select = faction_tbl[1];
    end

    if not rpui.EnableFactionGroupsUI then
        local isDefaultFactionExists = false;
        for k, v in pairs( faction_tbl ) do
            if v == rp.Factions[1].faction then
                isDefaultFactionExists = true;
            end
        end
        if not isDefaultFactionExists then
            table.insert( faction_tbl, 1, rp.Factions[1].faction );
        end
    end

    for k, v in pairs( self.FactionSelector.Buttons ) do
        v:Remove(); self.FactionSelector.Buttons[k] = nil;
    end

    local isFactionSelected = false;

    for _, faction_id in pairs( faction_tbl ) do
        local f = rp.Factions[faction_id];
        if not f then continue end

        local avalibleJobs = {};
        for t in pairs( f.jobs ) do
            local teamData = rp.teams[t];

            if teamData.side and rp.Sides then
                if teamData.side ~= LocalPlayer():GetSide() then
                    continue
                end
            end

            if teamData.customCheck then
                if teamData.customCheck( LocalPlayer() ) or teamData.whitelisted and (teamData.whitelistURL or teamData.CustomCheckFailMsgVisible) then
                    table.insert( avalibleJobs, t );
                end
            else
                table.insert( avalibleJobs, t );
            end
        end

        if #avalibleJobs == 0 then continue end

        local factionBtn = vgui.Create( "DButton", self.FactionSelector.Content );
        factionBtn:SetFont( rpui.EnableFactionGroupsUI and "rpui.Fonts.JobsList.TitleSmall" or "rpui.Fonts.JobsList.Title" );
        factionBtn:SetText( string.utf8upper(f.printName) );
        factionBtn:SizeToContentsX( self.frameW * 0.015 );
        factionBtn.DoClick = function( this )
            if not this.Selected then
                for k, v in pairs( self.FactionSelector.Buttons ) do v.Selected = false; end

                this.Selected = true;
                self:SelectFaction( f, is_forced );
            end
        end
        factionBtn.Paint = function( this, w, h )
            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
            surface_SetDrawColor( baseColor );
            surface_DrawRect( 0, 0, w, h );
            draw_SimpleText( this:GetText(), this:GetFont(), w/2, h/2 - 1, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true
        end

        if faction_select then
            if faction_id == faction_select then
                isFactionSelected = true;
                factionBtn:DoClick();
            end
        end

        self.FactionSelector.Content.AddPanel( self.FactionSelector.Content, factionBtn );
        table.insert( self.FactionSelector.Buttons, factionBtn );
    end

    if table.Count(self.FactionSelector.Buttons) == 1 then
        for k_tj, v_tj in pairs(self.FactionSelector.Buttons) do
            v_tj:SetVisible(false)
            v_tj:SetDisabled(true)
        end
    end

    if not isFactionSelected and IsValid(self.FactionSelector.Buttons[1]) then
        self.FactionSelector.Buttons[1].DoClick(self.FactionSelector.Buttons[1]);
    end
end


function PANEL:SelectFaction( f, is_forced )
    self.Content.JobSelector.ClearItems(self.Content.JobSelector);

    self.SelectedJob     = nil;
    self.SelectedFaction = f;

    if rpui.EnableFactionGroupsUI and not is_forced then
		self.SelectedGroupFaction = self.SelectedGroupFaction or {}
        self.SelectedGroupFaction[self.SelectedGroup] = self.SelectedFaction.faction;
    end

    local firstJob;

    for _, team123 in pairs( f.jobsMap ) do
        local pnl = self:AddJob( table.Copy(rp.teams[team123]) );
        if not firstJob then firstJob = pnl; end
    end

    if (not self.SelectedJob) and (firstJob) then
        firstJob:DoClick();
    end
end

function PANEL:SelectJob( teamData )
    self.SelectedJob = teamData;

    self.Content.InformationPanel.Stop(self.Content.InformationPanel);
    self.Content.InformationPanel.SetAlpha( self.Content.InformationPanel, 0 );

    self:RebuildAppearance( teamData );
    self:SetStats( teamData.salary or 0, teamData.armor or 0 );
    self:ParseStatsIcons( teamData );
    self:ParseWeapons(teamData.weapons or {} );
    self:SetDescription( teamData.description or "" );

    timer.Simple( FrameTime() * 10, function()
        if not IsValid( self ) then return end
        self.Content.InformationPanel.AlphaTo( self.Content.InformationPanel, 255, 0.25 );
    end );

    timer.Remove( "rpui.JobsList.ConfirmAction" );
    self.ActionButton.Think       = nil;
    self.ActionButton.isConfirmed = false;
    self.Content.AppearanceSelector.SetAlpha( self.Content.AppearanceSelector, 0 );
    self.ActionText.SetVisible( self.ActionText, false );

	self.ActionButton.DoClick = self.ActionButton._OldDoClick

	local real_max = team.NumNonAfkPlayers(teamData.team)

    local hasRules = self.SelectedFaction.rules;
    if hasRules then
        self.RulesButton.URL = self.SelectedFaction.rules;

        self.RulesButton.SizeToContentsY( self.RulesButton, self.frameH * 0.010 );
        self.RulesButton.SetWide( self.RulesButton, self.RulesButton.GetTall(self.RulesButton) );
    else
        self.RulesButton.SetSize( self.RulesButton, 0, 0 );
    end

    self.RulesButton.SetX( self.RulesButton, self.frameW - self.RulesButton.GetWide(self.RulesButton) );

    if teamData.vip and !LocalPlayer():IsVIP() then
        self.ActionText.SetVisible( self.ActionText, true );
        self.ActionText.SetText( self.ActionText, translates.Get("ПРИОБРЕТИТЕ VIP-СТАТУС В МАГАЗИНЕ") );
        self.ActionText.SizeToContentsX(self.ActionText);
        self.ActionText.SetPos( self.ActionText, self.frameW - self.ActionText.GetWide(self.ActionText), self.frameH - self.ActionText.GetTall(self.ActionText) );

        self.Content.AppearanceSelector.AlphaTo( self.Content.AppearanceSelector, 255, 0.25 );

        self.ActionButton.SetDisabled( self.ActionButton, true );
        self.ActionButton.SetText( self.ActionButton, translates.Get("ВЫ НЕ VIP ИГРОК") );
        self.ActionButton.PaintStyle = STYLE_ERROR;
        self.ActionButton.SizeToContentsX( self.ActionButton, self.frameW * 0.015 );
        self.ActionButton.SizeToContentsY( self.ActionButton, self.frameH * 0.010 );
        self.ActionButton.SetPos( self.ActionButton, self.frameW - self.ActionButton.GetWide(self.ActionButton) - self.RulesButton.GetWide(self.RulesButton) - (self.frameH * 0.0075 * (hasRules and 1 or 0)), self.frameH - self.ActionButton.GetTall(self.ActionButton) - self.ActionText.GetTall(self.ActionText) );
    elseif teamData.unlockTime and (teamData.unlockTime > LocalPlayer():GetPlayTime()) or teamData.minUnlockTime and (LocalPlayer():GetCustomPlayTime(teamData.minUnlockTimeTag) < teamData.minUnlockTime) then
        self.ActionButton.SetDisabled( self.ActionButton, true );
        self.ActionButton.PaintStyle = STYLE_ERROR;

        self.Content.AppearanceSelector.AlphaTo( self.Content.AppearanceSelector, 255, 0.25 );

        local time_mode1 = teamData.unlockTime and (teamData.unlockTime - LocalPlayer():GetPlayTime()) or false
        local time_mode2 = teamData.minUnlockTime and (teamData.minUnlockTime - LocalPlayer():GetCustomPlayTime(teamData.minUnlockTimeTag)) or false

        local time_mode = time_mode1 and (time_mode1 > (time_mode2 or 0))

        surface_SetFont( self.ActionButton.GetFont(self.ActionButton) );
        local tW, tH = surface_GetTextSize( translates.Get("ПРОФЕССИЯ СТАНЕТ ДОСТУПНОЙ ЧЕРЕЗ: %s", '00:00:00') );
        self.ActionButton.SetSize( self.ActionButton, tW + self.frameW * 0.015, tH + self.frameH * 0.010 );
        self.ActionButton.SetPos( self.ActionButton, self.frameW - self.ActionButton.GetWide(self.ActionButton) - self.RulesButton.GetWide(self.RulesButton) - (self.frameH * 0.0075 * (hasRules and 1 or 0)), self.frameH - self.ActionButton.GetTall(self.ActionButton) );

        self.ActionButton.Think = function( this )
            local time = time_mode and (teamData.unlockTime - LocalPlayer():GetPlayTime()) or (teamData.minUnlockTime - LocalPlayer():GetCustomPlayTime(teamData.minUnlockTimeTag))

            this:SetText( translates.Get("ПРОФЕССИЯ СТАНЕТ ДОСТУПНОЙ ЧЕРЕЗ: %s", ba.str.FormatTime(time)) );

            if time <= 0 then
                self:SelectJob( teamData );
            end
        end
    elseif rp.Experiences and teamData.unlockExperience and rp.Experiences:GetExperience(LocalPlayer(), teamData.unlockExperience.id) < teamData.unlockExperience.amount then
        local exp = rp.Experiences:GetExperienceType( teamData.unlockExperience.id );
        local v = rp.Experiences:GetExperience( LocalPlayer(), teamData.unlockExperience.id );

        local current = exp:ExperienceToLevel( v );
        local needed = exp:ExperienceToLevel( teamData.unlockExperience.amount );

        if current >= needed - 1 then
            self.ActionText.SetText( self.ActionText, translates.Get("ОСТАЛОСЬ %i ОПЫТА ДО РАЗБЛОКИРОВКИ ПРОФЕССИИ", teamData.unlockExperience.amount - v) );
        else
            self.ActionText.SetText( self.ActionText, translates.Get("ВАМ НУЖЕН %i УРОВЕНЬ ДЛЯ РАЗБЛОКИРОВКИ ПРОФЕССИИ", needed) );
        end

        self.ActionText.SetVisible( self.ActionText, true );
        self.ActionText.SizeToContentsX( self.ActionText );
        self.ActionText.SetPos( self.ActionText, self.frameW - self.ActionText.GetWide(self.ActionText), self.frameH - self.ActionText.GetTall(self.ActionText) );

        self.Content.AppearanceSelector.AlphaTo( self.Content.AppearanceSelector, 255, 0.25 );

        self.ActionButton.SetDisabled( self.ActionButton, true );
        self.ActionButton.SetText( self.ActionButton, translates.Get("У ВАС НЕДОСТАТОЧНЫЙ УРОВЕНЬ МАСТЕРСТВА") );
        self.ActionButton.PaintStyle = STYLE_ERROR;
        self.ActionButton.SizeToContentsX( self.ActionButton, self.frameW * 0.015 );
        self.ActionButton.SizeToContentsY( self.ActionButton, self.frameH * 0.010 );
        self.ActionButton.SetPos( self.ActionButton, self.frameW - self.ActionButton.GetWide(self.ActionButton) - self.RulesButton.GetWide(self.RulesButton) - (self.frameH * 0.0075 * (hasRules and 1 or 0)), self.frameH - self.ActionButton.GetTall(self.ActionButton) - self.ActionText.GetTall(self.ActionText) );
    elseif !LocalPlayer():TeamUnlocked( teamData ) then
        local SkillBonus = 0;

        self.Content.AppearanceSelector.AlphaTo( self.Content.AppearanceSelector, 255, 0.25 );

        if (LocalPlayer().GetAttributeAmount and LocalPlayer():GetAttributeAmount('jew') and teamData.unlockPrice) then
            SkillBonus = math.ceil(teamData.unlockPrice * (0.25 * LocalPlayer():GetAttributeAmount('jew') / 100));
        end

        if LocalPlayer():CanAfford( teamData.unlockPrice - SkillBonus ) then
            self.ActionText.SetVisible( self.ActionText, true );
            self.ActionText.SetText( self.ActionText, translates.Get("СТОИМОСТЬ РАЗБЛОКИРОВКИ: %s₽", rp.FormatMoney(teamData.unlockPrice - SkillBonus)) );
            self.ActionText.SizeToContentsX(self.ActionText);
            self.ActionText.SetPos( self.ActionText, self.frameW - self.ActionText.GetWide(self.ActionText), self.frameH - self.ActionText.GetTall(self.ActionText) );

            self.ActionButton.SetDisabled( self.ActionButton, false );
            self.ActionButton.SetText( self.ActionButton, translates.Get("РАЗБЛОКИРОВАТЬ ПРОФЕССИЮ") );
            self.ActionButton.PaintStyle = STYLE_SOLID;
            self.ActionButton.SizeToContentsX( self.ActionButton, self.frameW * 0.015 );
            self.ActionButton.SizeToContentsY( self.ActionButton, self.frameH * 0.010 );
            self.ActionButton.SetPos( self.ActionButton, self.frameW - self.ActionButton.GetWide(self.ActionButton) - self.RulesButton.GetWide(self.RulesButton) - (self.frameH * 0.0075 * (hasRules and 1 or 0)), self.frameH - self.ActionButton.GetTall(self.ActionButton) - self.ActionText.GetTall(self.ActionText) );
        else
            self.ActionText.SetVisible( self.ActionText, true );
            self.ActionText.SetText( self.ActionText, translates.Get("У ВАС НЕДОСТАТОЧНО СРЕДСТВ") );
            self.ActionText.SizeToContentsX(self.ActionText);
            self.ActionText.SetPos( self.ActionText, self.frameW - self.ActionText.GetWide(self.ActionText), self.frameH - self.ActionText.GetTall(self.ActionText) );

            self.ActionButton.SetDisabled( self.ActionButton, true );
            self.ActionButton.SetText( self.ActionButton, translates.Get("СТОИМОСТЬ РАЗБЛОКИРОВКИ: %s₽", rp.FormatMoney(teamData.unlockPrice - SkillBonus)) );
            self.ActionButton.PaintStyle = STYLE_ERROR;
            self.ActionButton.SizeToContentsX( self.ActionButton, self.frameW * 0.015 );
            self.ActionButton.SizeToContentsY( self.ActionButton, self.frameH * 0.010 );
            self.ActionButton.SetPos( self.ActionButton, self.frameW - self.ActionButton.GetWide(self.ActionButton) - self.RulesButton.GetWide(self.RulesButton) - (self.frameH * 0.0075 * (hasRules and 1 or 0)), self.frameH - self.ActionButton.GetTall(self.ActionButton) - self.ActionText.GetTall(self.ActionText) );
        end
    elseif LocalPlayer():GetNetVar("deathmech_t") and LocalPlayer():GetNetVar("deathmech_t") > CurTime() then
        self.Content.AppearanceSelector.AlphaTo( self.Content.AppearanceSelector, 255, 0.25 );

        self.ActionButton.SetDisabled( self.ActionButton, true );
        self.ActionButton.SetText( self.ActionButton, translates.Get("ВОЗРОДИТЕСЬ, ЧТОБЫ СМЕНИТЬ ПРОФЕССИЮ"));
        self.ActionButton.PaintStyle = STYLE_ERROR;
        self.ActionButton.SizeToContentsX( self.ActionButton, self.frameW * 0.015 );
        self.ActionButton.SizeToContentsY( self.ActionButton, self.frameH * 0.010 );
        self.ActionButton.SetPos( self.ActionButton, self.frameW - self.ActionButton.GetWide(self.ActionButton) - self.RulesButton.GetWide(self.RulesButton) - (self.frameH * 0.0075 * (hasRules and 1 or 0)), self.frameH - self.ActionButton.GetTall(self.ActionButton) - self.ActionText.GetTall(self.ActionText) );

    elseif teamData.team == LocalPlayer():Team() then
        if LocalPlayer():IsDisguised() then
            self.Content.AppearanceSelector.AlphaTo( self.Content.AppearanceSelector, 255, 0.25 );

            self.ActionButton.SetDisabled( self.ActionButton, true );
            self.ActionButton.SetText( self.ActionButton, translates.Get("НЕЛЬЗЯ ПЕРЕОДЕТЬСЯ В МАСКИРОВКЕ"));
            self.ActionButton.PaintStyle = STYLE_ERROR;
            self.ActionButton.SizeToContentsX( self.ActionButton, self.frameW * 0.015 );
            self.ActionButton.SizeToContentsY( self.ActionButton, self.frameH * 0.010 );
            self.ActionButton.SetPos( self.ActionButton, self.frameW - self.ActionButton.GetWide(self.ActionButton) - self.RulesButton.GetWide(self.RulesButton) - (self.frameH * 0.0075 * (hasRules and 1 or 0)), self.frameH - self.ActionButton.GetTall(self.ActionButton) - self.ActionText.GetTall(self.ActionText) );

        else
            self.Content.AppearanceSelector.AlphaTo( self.Content.AppearanceSelector, 255, 0.25 );

            self.ActionButton.SetDisabled( self.ActionButton, false );
            self.ActionButton.SetText( self.ActionButton, translates.Get("СМЕНИТЬ ОДЕЖДУ") );
            self.ActionButton.PaintStyle = STYLE_SOLID;
            self.ActionButton.SizeToContentsX( self.ActionButton, self.frameW * 0.015 );
            self.ActionButton.SizeToContentsY( self.ActionButton, self.frameH * 0.010 );
            self.ActionButton.SetPos( self.ActionButton, self.frameW - self.ActionButton.GetWide(self.ActionButton) - self.RulesButton.GetWide(self.RulesButton) - (self.frameH * 0.0075 * (hasRules and 1 or 0)), self.frameH - self.ActionButton.GetTall(self.ActionButton) );
        end

    elseif LocalPlayer():IsArrested() or LocalPlayer():IsWanted() then
        self.Content.AppearanceSelector.AlphaTo( self.Content.AppearanceSelector, 255, 0.25 );

        self.ActionButton.SetDisabled( self.ActionButton, true );
        self.ActionButton.SetText( self.ActionButton, translates.Get(LocalPlayer():IsWanted() and "ВЫ НАХОДИТЕСЬ В РОЗЫСКЕ" or "ВЫ АРЕСТОВАНЫ"));
        self.ActionButton.PaintStyle = STYLE_ERROR;
        self.ActionButton.SizeToContentsX( self.ActionButton, self.frameW * 0.015 );
        self.ActionButton.SizeToContentsY( self.ActionButton, self.frameH * 0.010 );
        self.ActionButton.SetPos( self.ActionButton, self.frameW - self.ActionButton.GetWide(self.ActionButton) - self.RulesButton.GetWide(self.RulesButton) - (self.frameH * 0.0075 * (hasRules and 1 or 0)), self.frameH - self.ActionButton.GetTall(self.ActionButton) - self.ActionText.GetTall(self.ActionText) );

    elseif (!(LocalPlayer():IsVIP() and teamData.max != 1 and !teamData.vip) or (teamData.forceLimit)) and
           (teamData.max ~= 0 and (teamData.max >= 1 and real_max >= teamData.max or teamData.max < 1 and (real_max + 1) / #player.GetAll() > teamData.max)) then
        self.Content.AppearanceSelector.AlphaTo( self.Content.AppearanceSelector, 255, 0.25 );

        self.ActionButton.SetDisabled( self.ActionButton, true );
        self.ActionButton.SetText( self.ActionButton, translates.Get("ДОСТИГНУТ ЛИМИТ ИГРОКОВ НА ПРОФЕССИИ"));
        self.ActionButton.PaintStyle = STYLE_ERROR;
        self.ActionButton.SizeToContentsX( self.ActionButton, self.frameW * 0.015 );
        self.ActionButton.SizeToContentsY( self.ActionButton, self.frameH * 0.010 );
        self.ActionButton.SetPos( self.ActionButton, self.frameW - self.ActionButton.GetWide(self.ActionButton) - self.RulesButton.GetWide(self.RulesButton) - (self.frameH * 0.0075 * (hasRules and 1 or 0)), self.frameH - self.ActionButton.GetTall(self.ActionButton) - self.ActionText.GetTall(self.ActionText) );

    elseif teamData.customCheck and not teamData.customCheck(LocalPlayer()) and (teamData.CustomCheckFailMsgVisible or teamData.whitelisted) then
        if teamData.whitelisted then
            if teamData.whitelistURL then
                self.ActionText.SetVisible( self.ActionText, true );
                self.ActionText.SetText( self.ActionText, translates.Get("Это whitelist профессия, для её получение необходимо заполнить заявку") );
                self.ActionText.SizeToContentsX(self.ActionText);
                self.ActionText.SetPos( self.ActionText, self.frameW - self.ActionText.GetWide(self.ActionText), self.frameH - self.ActionText.GetTall(self.ActionText) );

                self.Content.AppearanceSelector.AlphaTo( self.Content.AppearanceSelector, 255, 0.25 );

                self.ActionButton.SetDisabled( self.ActionButton, false );
                self.ActionButton.SetText( self.ActionButton, '  ' .. translates.Get("ПОДАТЬ ЗАЯВКУ") .. '  ' );
                self.ActionButton.PaintStyle = STYLE_SOLID;
                self.ActionButton.SizeToContentsX( self.ActionButton, self.frameW * 0.015 );
                self.ActionButton.SizeToContentsY( self.ActionButton, self.frameH * 0.010 );
                self.ActionButton.SetPos( self.ActionButton, self.frameW - self.ActionButton.GetWide(self.ActionButton) - self.RulesButton.GetWide(self.RulesButton) - (self.frameH * 0.0075 * (hasRules and 1 or 0)), self.frameH - self.ActionButton.GetTall(self.ActionButton) - self.ActionText.GetTall(self.ActionText) );

                self.ActionButton.DoClick = function()
                    gui.OpenURL(teamData.whitelistURL)
                end

            else
                self.ActionText.SetVisible( self.ActionText, false );

                self.Content.AppearanceSelector.AlphaTo( self.Content.AppearanceSelector, 255, 0.25 );

                self.ActionButton.SetDisabled( self.ActionButton, true );
                self.ActionButton.SetText( self.ActionButton, translates.Get("Доступно при наличие whitelist'a") );
                self.ActionButton.PaintStyle = STYLE_ERROR;
                self.ActionButton.SizeToContentsX( self.ActionButton, self.frameW * 0.015 );
                self.ActionButton.SizeToContentsY( self.ActionButton, self.frameH * 0.010 );
                self.ActionButton.SetPos( self.ActionButton, self.frameW - self.ActionButton.GetWide(self.ActionButton) - self.RulesButton.GetWide(self.RulesButton) - (self.frameH * 0.0075 * (hasRules and 1 or 0)), self.frameH - self.ActionButton.GetTall(self.ActionButton) - self.ActionText.GetTall(self.ActionText) );
            end
        else
            self.ActionText.SetVisible( self.ActionText, true );
            self.ActionText.SetText( self.ActionText, translates.Get("ПРОФЕССИЯ ВАМ НЕДОСТУПНА") );
            self.ActionText.SizeToContentsX(self.ActionText);
            self.ActionText.SetPos( self.ActionText, self.frameW - self.ActionText.GetWide(self.ActionText), self.frameH - self.ActionText.GetTall(self.ActionText) );

            self.Content.AppearanceSelector.AlphaTo( self.Content.AppearanceSelector, 255, 0.25 );

            self.ActionButton.SetDisabled( self.ActionButton, true );
            self.ActionButton.SetText( self.ActionButton, rp.Term(teamData.CustomCheckFailMsg) or teamData.CustomCheckFailMsg );
            self.ActionButton.PaintStyle = STYLE_ERROR;
            self.ActionButton.SizeToContentsX( self.ActionButton, self.frameW * 0.015 );
            self.ActionButton.SizeToContentsY( self.ActionButton, self.frameH * 0.010 );
            self.ActionButton.SetPos( self.ActionButton, self.frameW - self.ActionButton.GetWide(self.ActionButton) - self.RulesButton.GetWide(self.RulesButton) - (self.frameH * 0.0075 * (hasRules and 1 or 0)), self.frameH - self.ActionButton.GetTall(self.ActionButton) - self.ActionText.GetTall(self.ActionText) );
        end
    else
        self.Content.AppearanceSelector.AlphaTo( self.Content.AppearanceSelector, 255, 0.25 );

        self.ActionButton.SetDisabled( self.ActionButton, false );
        self.ActionButton.SetText( self.ActionButton, translates.Get("СМЕНИТЬ ПРОФЕССИЮ") );
        self.ActionButton.PaintStyle = STYLE_SOLID;
        self.ActionButton.SizeToContentsX( self.ActionButton, self.frameW * 0.015 );
        self.ActionButton.SizeToContentsY( self.ActionButton, self.frameH * 0.010 );
        self.ActionButton.SetPos( self.ActionButton, self.frameW - self.ActionButton.GetWide(self.ActionButton) - self.RulesButton.GetWide(self.RulesButton) - (self.frameH * 0.0075 * (hasRules and 1 or 0)), self.frameH - self.ActionButton.GetTall(self.ActionButton) );
    end

    self.RulesButton.SetY( self.RulesButton, self.ActionButton.GetY(self.ActionButton) );

    local temp_cookie = cookie.GetString('jb_' .. rp.cfg.ServerUID .. teamData.command)
    temp_cookie = util.JSONToTable(temp_cookie or '')

    if temp_cookie then
        if not self.AppearancePointers[ temp_cookie[2] ] then return end

        if self.SelectedJob.appearance[ temp_cookie[3] ] then
            self.AppearanceModel = temp_cookie[2]
            self.AppearanceID = temp_cookie[3]

            self:SelectAppearance(self.AppearanceID)

            self.AppearanceSkin = temp_cookie[4]

            if IsValid(self.Content.AppearanceSelector.Model) then
                self.Content.AppearanceSelector.Model.SetValue(self.Content.AppearanceSelector.Model, self.AppearanceModel)
            end

            if self.AppearancePanelBGroups and table.Count(self.AppearancePanelBGroups) > 0 then
                for k, v in pairs(self.AppearancePanelBGroups) do
                    if IsValid(v) and temp_cookie[6][k] then
                        v:SetValue(temp_cookie[6][k])

                        self.AppearanceBodygroups = self.AppearanceBodygroups or {}
                        self.AppearanceBodygroups[k] = temp_cookie[6][k]
                    end
                end
            end

            self.AppearanceScale = temp_cookie[5]

            if IsValid(self.AppearancePanelScale) then
                self.AppearancePanelScale.SetValue(self.AppearancePanelScale, self.AppearanceScale)
            end

            if IsValid(self.AppearancePanelSkin) then
                self.AppearancePanelSkin.SetValue(self.AppearancePanelSkin, self.AppearanceSkin)
            end

            self:RefreshAppearanceVisuals()
        end
    end

    self:BuildArmoryList()

	local season = LocalPlayer():GetSeason()

	if season then
		net.Start("JobsMenu::SelectJob")
			net.WriteUInt(teamData.team, 32)
		net.SendToServer()
	end

    local experience = teamData.experience and teamData.unlockExperience;

    if experience and experience.id then
        self.Content.ExperiencePanel:SetExperienceID( experience.id );
        self.Content.ExperiencePanel:SetAlpha( 0 );
        self.Content.ExperiencePanel:Show();
        self.Content.ExperiencePanel:AlphaTo( 255, 0.25 );
    else
        self.Content.ExperiencePanel:Hide();
    end
end

net.Receive('rp.PlayerDataLoaded', function()
    timer.Simple(1, function()
        hook.Run('LocalPlayerDataLoaded')
    end)
end)

hook.Add("LocalPlayerDataLoaded", "rp.Appearance.ReloadModel", function(data)
    timer.Simple(5, function()
        local temp_cookie = cookie.GetString('jb_' .. rp.cfg.ServerUID .. LocalPlayer():GetJobTable().command)
        temp_cookie = util.JSONToTable(temp_cookie or '')

        if temp_cookie then
            rp.RunCommand( "model", temp_cookie[2] );

            net.Start( "net.appearance.BodygroupData" );
                net.WriteUInt( temp_cookie[3], 6 );
                net.WriteUInt( temp_cookie[4] or 0, 6 );
                net.WriteFloat( temp_cookie[5] );

                local CustomAppearanceUID = temp_cookie[7][ temp_cookie[2] ];
                net.WriteBool( CustomAppearanceUID and true or false );
                net.WriteString( CustomAppearanceUID or "" );

                local bgroups = temp_cookie[6];
                local bgroups_keys  = table.GetKeys(bgroups);
                local bgroups_count = table.Count(bgroups);

                net.WriteUInt( bgroups_count, 6 );
                for i = 1, bgroups_count do
                    local id = bgroups_keys[i];
                    net.WriteUInt( id, 6 );
                    net.WriteUInt( bgroups[id], 6 );
                end
            net.SendToServer();
        end
    end)
end)


function PANEL:AddJob( teamData )
    if rp.Sides and teamData.side and (teamData.side ~= LocalPlayer():GetSide()) then return end
    if teamData.customCheck and !teamData.customCheck( LocalPlayer() ) and not teamData.CustomCheckFailMsgVisible and not teamData.whitelisted then return end

    local JobButton = vgui.Create( "DButton" );
    JobButton:Dock( TOP );

    self.Content.JobSelector.AddItem( self.Content.JobSelector, JobButton );
    JobButton.Parent = JobButton:GetParent();

    JobButton:InvalidateParent( true );
    JobButton:InvalidateLayout( true );

    JobButton:SetTall( self.frameH * 0.095 );
    JobButton.TitleBounds = 0.65 + 0;
    JobButton.TextPadding = 0.01 * self.frameW;

    JobButton:SetFont( "rpui.Fonts.JobsList.Medium" );
    JobButton:SetText( string.utf8upper(string.Trim(teamData.name)) );

    JobButton.TeamData = teamData;

    JobButton.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
        surface_SetDrawColor( baseColor );
        surface_DrawRect( 0, 0, w, h );

        if this.BakedText then
            for k, v in pairs( this.BakedText ) do
                if v.type == 0 then
                    draw_SimpleText( v.text, this:GetFont(), v.x, v.y + h/2 - this.BakedTextHeight/2, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
                else
                    surface_SetDrawColor( rpui.UIColors.White );
                    surface_SetMaterial( v.text );
                    surface_DrawTexturedRect( v.x, v.y + h/2 - this.BakedTextHeight/2 - v.size/2, v.size, v.size );
                end
            end
        end

        if this.TeamData.unlockTime and (this.TeamData.unlockTime > LocalPlayer():GetPlayTime()) or this.TeamData.minUnlockTime and (this.TeamData.minUnlockTime > LocalPlayer():GetCustomPlayTime(this.TeamData.minUnlockTimeTag)) then
            local time_mode1 = this.TeamData.unlockTime and (this.TeamData.unlockTime - LocalPlayer():GetPlayTime()) or false
            local time_mode2 = this.TeamData.minUnlockTime and (this.TeamData.minUnlockTime - LocalPlayer():GetCustomPlayTime(this.TeamData.minUnlockTimeTag)) or false

            local time_mode = time_mode1 and (time_mode1 > (time_mode2 or 0))

            draw_SimpleText(
                ba.str.FormatTime( time_mode and (this.TeamData.unlockTime - LocalPlayer():GetPlayTime()) or (this.TeamData.minUnlockTime - LocalPlayer():GetCustomPlayTime(this.TeamData.minUnlockTimeTag)) ),
                this:GetFont(),
                w - this.TextPadding, h/2,
                textColor,
                TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER
            );
        elseif rp.Experiences and teamData.unlockExperience and rp.Experiences:GetExperience(LocalPlayer(), teamData.unlockExperience.id) < teamData.unlockExperience.amount then
            local exp = rp.Experiences:GetExperienceType( teamData.unlockExperience.id );
            local needed = exp:ExperienceToLevel( teamData.unlockExperience.amount );

            local ih = draw.GetFontHeight( "rpui.Fonts.JobsList.Micro" ) * 1.5;
            local lx = w - this.TextPadding - ih * 0.8;

            surface.SetDrawColor( textColor );
            surface.SetMaterial( self.UIIcons.Lock );
            surface.DrawTexturedRect( lx, h * 0.5 - ih * 0.5, ih, ih );

            lx = lx - this.TextPadding * 0.25;

            draw_SimpleText(
                translates.Get("доступно"),
                "rpui.Fonts.JobsList.Micro",
                lx, h * 0.5,
                textColor,
                TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM
            );

            draw_SimpleText(
                translates.Get("с %i уровня", needed),
                "rpui.Fonts.JobsList.Micro",
                lx, h * 0.5,
                textColor,
                TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP
            );
        elseif not LocalPlayer():TeamUnlocked( this.TeamData ) then
            local SkillBonus = 0;

            if (LocalPlayer().GetAttributeAmount and LocalPlayer():GetAttributeAmount('jew') and this.TeamData.unlockPrice) then
                SkillBonus = math.ceil(this.TeamData.unlockPrice * (0.25 * LocalPlayer():GetAttributeAmount('jew') / 100));
            end

            draw_SimpleText(
                rp.FormatMoney( this.TeamData.unlockPrice - SkillBonus ),
                this:GetFont(),
                w - this.TextPadding, h/2,
                textColor,
                TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER
            );
        else
            draw_SimpleText(
                #team.GetPlayers( this.TeamData.team ) .. "/" .. ((this.TeamData.max == 0) and "∞" or this.TeamData.max),
                this:GetFont(),
                w - this.TextPadding, h/2,
                textColor,
                TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER
            );
        end

        return true
    end

    if teamData.unlockTime and (teamData.unlockTime > LocalPlayer():GetPlayTime()) or teamData.minUnlockTime and (teamData.minUnlockTime > LocalPlayer():GetCustomPlayTime(teamData.minUnlockTimeTag)) or not LocalPlayer():TeamUnlocked( teamData ) then
        JobButton.BakedTextOff = 0.85 + 0
    end

    JobButton.DoClick = function( this )
        if not this.Selected then
            for k, v in pairs( this.Parent.GetChildren(this.Parent) ) do
                v.Selected = false;
            end

            this.Selected = true;
            self:SelectJob( this.TeamData );
        end
    end

    timer.Simple( FrameTime() * 5, function()
        if not IsValid( self )      then return end
        if not IsValid( JobButton ) then return end

        local this = JobButton;

        this.BakedTextWidth  = 0;
        this.BakedTextHeight = 0;
        this.BakedText       = {};

        local w = this:GetWide();
        local h = this:GetTall();
        local x = 0;
        local y = 0;

        local vip_inserted = false;

        local xLimit = w * this.TitleBounds * (this.BakedTextOff or 1);

        local text_data   = string.Explode( " ", this:GetText() );
        local font_height = 0.0265 * self.frameH;

        surface_SetFont( this:GetFont() );
        local space = surface_GetTextSize( " " );

        for _, str in pairs( text_data ) do
            local strW, strH = surface_GetTextSize(str);

            if x + strW > xLimit then
                if this.TeamData.vip and !vip_inserted then
                    local icon_size = math.Round( self.frameH * 0.0175 );
                    if icon_size % 2 ~= 0 then icon_size = icon_size + 1 end

                    table.insert( this.BakedText, { type = 1, text = self.UIIcons.VIP, x = x + this.TextPadding + space, y = y + font_height/2, size = icon_size } );
                    vip_inserted = true;
                end

                x = 0;

                if not (#text_data == 1 and _ == 1) then
                    y = y + font_height;
                end
            end

            table.insert( this.BakedText, { type = 0, text = str, x = x + this.TextPadding, y = y } );
            x = x + strW + space;

            this.BakedTextWidth  = math.max( this.BakedTextWidth, x );
            this.BakedTextHeight = math.max( this.BakedTextHeight, y + font_height );
        end

        if this.TeamData.vip and !vip_inserted then
            local icon_size = math.Round( self.frameH * 0.0175 );
            if icon_size % 2 ~= 0 then icon_size = icon_size + 1 end

            table.insert( this.BakedText, { type = 1, text = self.UIIcons.VIP, x = x + this.TextPadding + space, y = y + font_height/2, size = icon_size } );
        end
    end );

    if teamData.team == LocalPlayer():Team() then
        JobButton:DoClick();
    end

    return JobButton;
end


vgui.Register( "rpui.JobsList", PANEL, "Panel" );
