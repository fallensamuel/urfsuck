-- "gamemodes\\rp_base\\gamemode\\addons\\experiences\\cl_core.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
rp.Experiences = rp.Experiences or {};
rp.Experiences.Cache = rp.Experiences.Cache or {};

----------------------------------------------------------------
function rp.Experiences:OnPlayerExperienceUpdated( id, previous, current )
    hook.Run( "PlayerExperienceUpdated", id, previous, current );
end

----------------------------------------------------------------
function rp.Experiences:SetExperience( id, amount )
    id = id or self:GetExperienceID( LocalPlayer() );
    local previous = self:GetExperience( LocalPlayer(), id );
    self.Cache[id] = amount;
    self:OnPlayerExperienceUpdated( id, previous, amount );
end

function rp.Experiences:GetExperience( ply, id )
    id = id or self:GetExperienceID( LocalPlayer() );
    return self.Cache[id] or 0;
end

----------------------------------------------------------------
local PANEL = {};

function PANEL:RebuildFonts( w, h )
    surface.CreateFont( "rpui.fonts.ExperiencePanel-Default", {
        font = "Montserrat",
        size = h * 0.0175,
        weight = 500,
        extended = true
    } );

    surface.CreateFont( "rpui.fonts.ExperiencePanel-DefaultBold", {
        font = "Montserrat",
        size = h * 0.0225,
        weight = 1000,
        extended = true
    } );

    surface.CreateFont( "rpui.fonts.ExperiencePanel-Large", {
        font = "Montserrat",
        size = h * 0.035,
        weight = 1000,
        extended = true
    } );

    surface.CreateFont( "rpui.fonts.ExperiencePanel-DefaultThin", {
        font = "Montserrat",
        size = h * 0.0175,
        weight = 0,
        extended = true
    } );
end

function PANEL:SetPadding( padding )
    self.fl_Padding = padding;
    self:InvalidateLayout();
end

function PANEL:GetPadding()
    return self.fl_Padding or 0;
end

function PANEL:SetExperienceID( id )
    self.m_ExperienceID = id;

    self:UpdateInformation();

    hook.Add( "PlayerExperienceUpdated", self, function( pnl, id, previous, current )
        if pnl.m_ExperienceID ~= id then return end
        pnl:UpdateInformation();
    end );
end

function PANEL:UpdateInformation()
    local id = self.m_ExperienceID;
    if not id then return end

    local exp = rp.Experiences:GetExperience( LocalPlayer(), id );

    local t = rp.Experiences:GetExperienceType( id );
    self.Level.Label:SetText( t:GetPrintName() or translates.Get("УРОВЕНЬ МАСТЕРСТВА:") );

    local current_level = t:ExperienceToLevel( exp );

    local min_exp = t:LevelToExperience( current_level );
    local max_exp = t:LevelToExperience( current_level + 1 );

    self.Level.Value:SetText( current_level );

    self.Experience.i_Target = exp;
    self.Experience.i_Min = min_exp;
    self.Experience.i_Max = max_exp;

    local reward_level, reward_list = t:GetNextLevelReward( current_level );

    if not reward_level then
        self.Rewards:Hide();
    else
        self.Rewards:SetText( translates.Get("Награды %d уровня", reward_level) );
        self.Rewards:Show();
    end

    self:InvalidateChildren( true );
end

function PANEL:Init()
    self:RebuildFonts( ScrW(), ScrH() );

    self.Level = self:Add( "Panel" );
    self.Level:Dock( TOP );

    self.Level.PerformLayout = function( this, w, h )
        for k, child in ipairs( this:GetChildren() ) do
            child:SizeToContents();
        end

        this:SizeToChildren( false, true );

        this.Label:SetY( this:GetTall() - this.Label:GetTall() );
        this.Value:SetX( this:GetWide() - this.Value:GetWide() );
    end

    self.Level.Label = self.Level:Add( "DLabel" );
    self.Level.Label:SetFont( "rpui.fonts.ExperiencePanel-DefaultBold" );
    self.Level.Label:SetTextColor( color_white );
    self.Level.Label:SetText( translates.Get("УРОВЕНЬ МАСТЕРСТВА:") );

    self.Level.Value = self.Level:Add( "DLabel" );
    self.Level.Value:SetFont( "rpui.fonts.ExperiencePanel-Large" );
    self.Level.Value:SetTextColor( color_white );
    self.Level.Value:SetText( "%d" );

    self.Experience = self:Add( "Panel" );
    self.Experience:Dock( TOP );

    self.Experience.fl_Value = 0;
    self.Experience.i_Target = 0;
    self.Experience.i_Min = 0;
    self.Experience.i_Max = 0;

    self.Experience.PerformLayout = function( this, w, h )
        this.Label:SetY( 0 );
        this.Value:SetY( 0 );
        this.Progress:SetY( 0 );
        this.Progress:SetTall( 0 );

        for k, child in ipairs( this:GetChildren() ) do
            child:SizeToContents();
        end

        this:SizeToChildren( false, true );

        w, h = this:GetWide(), this:GetTall();

        surface.SetFont( "rpui.fonts.ExperiencePanel-Default" );
        local th = select( 2, surface.GetTextSize(" ") );
        this.Progress:SetSize( w, th * 0.725 );

        this.Label:SetY( h - this.Label:GetTall() );
        this.Value:SetX( w - this.Value:GetWide() );
        this.Value:SetY( h - this.Value:GetTall() );

        this.Progress:SetY( h + self:GetPadding() );

        this:SizeToChildren( false, true );
    end

    self.Experience.Label = self.Experience:Add( "DLabel" );
    self.Experience.Label:SetFont( "rpui.fonts.ExperiencePanel-Default" );
    self.Experience.Label:SetTextColor( color_white );
    self.Experience.Label:SetText( translates.Get("ОПЫТ:") );

    self.Experience.Value = self.Experience:Add( "DLabel" );
    self.Experience.Value:SetFont( "rpui.fonts.ExperiencePanel-Default" );
    self.Experience.Value:SetTextColor( color_white );
    self.Experience.Value:SetText( "%d / %d" );
    self.Experience.Value.Think = function( this )
        local p = this:GetParent();

        p.fl_Value = Lerp( RealFrameTime() * 6, p.fl_Value, p.i_Target );
        local v = math.min( math.Round(p.fl_Value), p.i_Max );

        if (p.i_VisualValue or -1) ~= v then
            p.i_VisualValue = v;

            this:SetText( string.format("%d / %d", p.i_VisualValue, p.i_Max) );
            this:SizeToContentsX();
            this:InvalidateParent( true );
        end
    end

    self.Experience.Progress = self.Experience:Add( "Panel" );
    self.Experience.Progress.Paint = function( this, w, h )
        surface.SetDrawColor( Color(0, 0, 0, 200) );
        surface.DrawRect( 0, 0, w, h );

        local p = this:GetParent();
        local dt = math.min( 1, math.Remap(p.fl_Value, p.i_Min, p.i_Max, 0, 1) );

        surface.SetDrawColor( color_white );
        surface.DrawRect( 0, 0, w * dt, h );
    end

    self.Rewards = self:Add( "DButton" );
    self.Rewards:Dock( TOP );
    self.Rewards:SetFont( "rpui.fonts.ExperiencePanel-DefaultThin" );
    self.Rewards:SetTextColor( color_white );
    self.Rewards:SetText( translates.Get("Награды %d уровня", 0) );
    self.Rewards.m_Icon = Material( "rpui/information.png", "smooth noclamp" );
    self.Rewards.Paint = function( this, w, h )
        surface.SetFont( this:GetFont() );

        local tsw, tsh = surface.GetTextSize( " " );
        local tvw, tvh = surface.GetTextSize( this:GetText() );

        local tw = tsh + tsh * 0.5 + tvw;

        local x, y = w * 0.5 - tw * 0.5, h * 0.5;

        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT );

        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );

        surface.SetMaterial( this.m_Icon );
        surface.SetDrawColor( textColor );
        surface.DrawTexturedRect( x, y - tsh * 0.5, tsh, tsh );

        draw.SimpleText( this:GetText(), this:GetFont(), x + tsh + tsh * 0.5, y, textColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );

        return true;
    end
end

function PANEL:PerformLayout( w, h )
    for k, child in ipairs( self:GetChildren() ) do
        child:DockMargin( 0, 0, 0, self:GetPadding() );
    end

    self.Rewards:SizeToContentsY( self:GetPadding() * 2 );

    self:SizeToChildren( false, true );
end

vgui.Register( "rpui.ExperiencePanel", PANEL, "EditablePanel" );
