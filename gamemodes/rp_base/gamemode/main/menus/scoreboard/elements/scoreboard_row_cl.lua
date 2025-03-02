-- "gamemodes\\rp_base\\gamemode\\main\\menus\\scoreboard\\elements\\scoreboard_row_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

function PANEL:Populate( hookname, parent )
    local items, ply = {}, self:GetPlayer();
    hook.Run( hookname, items );

    for k, fn in pairs( items ) do
        fn( parent, ply );
    end

    for k, child in ipairs( parent:GetChildren() ) do
        rp.Scoreboard.Utils.OptimizeDermaThink( child );
    end
end

function PANEL:PopulateComamnds()
    local items = {};
    hook.Run( "PopulateScoreboardCommands", items );

    local initiator, target = LocalPlayer(), self:GetPlayer();
    local parent = self.Content.Commands;

    for k, item in pairs( items ) do
        local button = parent:Add( "DButton" );

        button:SetFont( "rpui.Fonts.ScoreboardSmall" );
        button:SetText( "Button" );

        button.Access = item.access;

        if isfunction( item.label ) then
            button.Think = function( this )
                this:SetText( item.label(this, target) );
            end
        elseif isstring( item.label ) then
            button:SetText( item.label );
        end

        button.DoClick = function( this )
            if not item.action then return end
            if not IsValid( target ) then return end
            item.action( this, target );
        end

        button.Paint = function( this, w, h )
            if not IsValid( target ) then return end

            surface.SetDrawColor( team.GetColor(target:GetJob()) );
            surface.DrawRect( 0, 0, w, h );

            surface.SetDrawColor( rp.Scoreboard.Config.Colors.BlackTransparent );
            surface.SetMaterial( rp.Scoreboard.Utils.Material("gui/gradient_up") );
            surface.DrawTexturedRect( 0, 0, w, h );

            draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, this:GetTextColor(), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

            if this:IsHovered() then
                surface.SetDrawColor( rp.Scoreboard.Config.Colors.WhiteOpaque );
                surface.DrawRect( 0, 0, w, h );
            end

            return true;
        end
    end

    for k, child in ipairs( parent:GetChildren() ) do
        rp.Scoreboard.Utils.OptimizeDermaThink( child );
    end
end

function PANEL:SetPlayer( ply )
    self.m_Player = ply;

    local avatar = self.Columns["player"].Avatar;
    avatar:SetPlayer( self.m_Player, avatar:GetWide() );

    self:Populate( "PopulateScoreboardGeneric", self.Columns["generic"] );
    self:Populate( "PopulateScoreboardGameplay", self.Columns["gameplay"] );
    self:Populate( "PopulateScoreboardGenericActions", self.Columns["gameplay"].Actions );

    self:PopulateComamnds();
end

function PANEL:GetPlayer()
    return self.m_Player;
end

function PANEL:Init()
    self.fl_Padding = draw.GetFontHeight( "rpui.Fonts.ScoreboardDefault" ) * 0.5;

    self.Content = self:Add( "Panel" );
    self.Content:Dock( TOP );

    self.Content.PerformLayout = function( this, w, h )
        local width = w * 0.5;

        this.Information:SetWide( width );

        this.Commands:SetPos( width, 0 );
        this.Commands:SetWide( w - width );

        this:SizeToChildren( false, true );
    end

    self.Content.Information = self.Content:Add( "Panel" );

    self.Content.Information.PerformLayout = function( this, w, h )
        local childs = this:GetChildren();
        local count = #childs;

        local x, p = 0, self.fl_Padding;

        for k, child in ipairs( childs ) do
            child:SetX( x );

            if k == count then
                child:SetWide( w - x - p );
                break
            end

            x = x + child:GetWide() + p;
        end

        this:SizeToChildren( false, true );
    end

    self.Columns = {};
    local col;

    -- Avatar:
    self.Columns["player"] = self.Content.Information:Add( "Panel" );

    col = self.Columns["player"];
    col:SetWide( draw.GetFontHeight("rpui.Fonts.ScoreboardMedium") * 4 - 6 );

    col.PerformLayout = function( this, w, h )
        local icon = w * 0.5;
        this.Avatar:SetTall( w );
        -- this.System:SetSize( icon, icon );
        -- this.Flag:SetSize( icon, icon );
        this:SizeToChildren( false, true );
    end

    col.Avatar = col:Add( "AvatarImage" );
    col.Avatar:Dock( TOP );

    --[[
    col.System = col:Add( "Panel" );
    col.System:Dock( LEFT );
    col.System.Paint = function( this, w, h )
        local t = CurTime();

        if (this.fl_NextUpdate or 0) < t then
            this.fl_NextUpdate = t + 1;

            if self.m_Player and self.m_Player.GetOS then
                this.m_Material = rp.Scoreboard.Utils.Material( "rpui/scoreboard/" .. self.m_Player:GetOS() .. ".png", "smooth noclamp" );
            end
        end

        if this.m_Material then
            local icon_size = h * 0.5;
            surface.SetDrawColor( color_white );
            surface.SetMaterial( this.m_Material );
            surface.DrawTexturedRect( w * 0.5 - icon_size * 0.5, h - icon_size * 1.25, icon_size, icon_size );
        end
    end

    col.Flag = col:Add( "Panel" );
    col.Flag:Dock( LEFT );
    col.Flag.Paint = function( this, w, h )
        local t = CurTime();

        if (this.fl_NextUpdate or 0) < t then
            this.fl_NextUpdate = t + 1;

            if self.m_Player and self.m_Player.GetCountry then
                this.m_Material = rp.Scoreboard.Utils.Material( "flags16/" .. self.m_Player:GetCountry() .. ".png", "noclamp" );
            end
        end

        if this.m_Material then
            local icon_size = h * 0.5;
            local aspect = icon_size * 1.454;
            surface.SetDrawColor( color_white );
            surface.SetMaterial( this.m_Material );
            surface.DrawTexturedRect( w * 0.5 - aspect * 0.5, h - icon_size * 1.25, aspect, icon_size );
        end
    end
    ]]--

    -- Generic:
    self.Columns["generic"] = self.Content.Information:Add( "Panel" );

    col = self.Columns["generic"];

    col.PerformLayout = function( this, w, h )
        this:SizeToChildren( true, true );

        for k, child in ipairs( this:GetChildren() ) do
            child:Dock( TOP );

            if not child.b_NoPadding then
                child:DockMargin( 0, 0, 0, self.fl_Padding );
            end
        end
    end

    -- Gameplay:
    self.Columns["gameplay"] = self.Content.Information:Add( "Panel" );

    col = self.Columns["gameplay"];
    col:SetY( (draw.GetFontHeight("rpui.Fonts.ScoreboardLarge") - draw.GetFontHeight("rpui.Fonts.ScoreboardDefault")) * 0.85 );

    col.Think = function( this )
        if not rp.Scoreboard.Utils.RefreshTime() then return end

        for k, child in ipairs( this:GetChildren() ) do
            if not child.Access then continue end

            local status = IsValid( self.m_Player );
            if status then
                status = child:Access( self.m_Player );
            end

            child[status and "Show" or "Hide"]( child );
        end

        this:InvalidateLayout( true );
    end

    col.PerformLayout = function( this )
        this:SizeToChildren( true, true );

        for k, child in ipairs( this:GetChildren() ) do
            child:Dock( TOP );

            if not child.b_NoPadding then
                child:DockMargin( 0, 0, 0, self.fl_Padding );
            end
        end
    end

    col.Actions = col:Add( "Panel" );
    col.Actions:Dock( TOP );
    col.Actions:SetZPos( 32767 );

    col.Actions.PerformLayout = function( this, w, h )
        local x, y, t, p = 0, 0, 0, self.fl_Padding;

        for k, child in ipairs( this:GetChildren() ) do
            local nx = x + child:GetWide();

            if nx > w then
                x = 0;
                y = y + t + p;
                t = 0;
            end

            child:SetPos( x, y );
            x = nx + p;
            t = math.max( t, child:GetTall() );
        end

        this:SizeToChildren( false, true );
    end

    -- Commands:
    self.Content.Commands = self.Content:Add( "Panel" );

    self.Content.Commands.Think = function( this )
        if not rp.Scoreboard.Utils.RefreshTime() then return end

        for k, child in ipairs( this:GetChildren() ) do
            if not child.Access then continue end

            local status = IsValid( self.m_Player );
            if status then
                status = child:Access( self.m_Player );
            end

            child[status and "Show" or "Hide"]( child );
        end

        this:InvalidateLayout( true );
    end

    self.Content.Commands.PerformLayout = function( this, tw, th )
        local x, y, t, p = 0, 0, 0, self.fl_Padding * 0.5;
        local cw = ((tw - p * 2) / 3);

        for k, child in ipairs( this:GetChildren() ) do
            if not child:IsVisible() then continue end

            child:SetWide( cw );

            local nx = x + child:GetWide();

            if nx > tw then
                x = 0;
                nx = child:GetWide();
                y = y + t + p;
                t = 0;
            end

            child:SetPos( x, y );
            x = nx + p;
            t = math.max( t, child:GetTall() );
        end

        this:SizeToChildren( false, true );
    end
end

function PANEL:PerformLayout( w, h )
    self:SizeToChildren( false, true );
end

vgui.Register( "rpui.ScoreboardRow", PANEL, "EditablePanel" );