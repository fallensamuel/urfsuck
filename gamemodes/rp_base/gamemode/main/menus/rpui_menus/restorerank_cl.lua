-- "gamemodes\\rp_base\\gamemode\\main\\menus\\rpui_menus\\restorerank_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

AccessorFunc( PANEL, "m_SteamID64", "SteamID64", FORCE_STRING );
AccessorFunc( PANEL, "m_RankID", "RankID", FORCE_NUMBER );

local paint_button = function( btn, w, h )
    local baseColor, textColor = rpui.GetPaintStyle( btn, STYLE_TRANSPARENT );
    surface.SetDrawColor( baseColor );
    surface.DrawRect( 0, 0, w, h );
    draw.SimpleText( btn:GetText(), btn:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
    return true
end

----------------------------------------------------------------
local SetSteamID64, SetRankID = PANEL.SetSteamID64, PANEL.SetRankID;

function PANEL:SetSteamID64( sid64 )
    SetSteamID64( self, sid64 ); self.b_PreRendered = false;
end

function PANEL:SetRankID( id )
    SetRankID( self, id ); self.b_PreRendered = false;
end

----------------------------------------------------------------
surface.CreateFont( "rpui.fonts.RestoreRank.Button", {
    font = "Montserrat",
    size = 22,
    weight = 400,
    extended = true
} );

surface.CreateFont( "rpui.fonts.RestoreRank.Default", {
    font = "Montserrat",
    size = 18,
    weight = 400,
    extended = true
} );

surface.CreateFont( "rpui.fonts.RestoreRank.Bold", {
    font = "Roboto",
    size = 36,
    weight = 500,
    extended = true
} );

function PANEL:Answer( status )
    if self.b_Answered then return end
    self.b_Answered = true;

    net.Start( "ba.setgroup.restorerank" );
        net.WriteString( self:GetSteamID64() );
        net.WriteBool( status );
    net.SendToServer();
end

function PANEL:Close()
    self:Answer( false );
    self.BaseClass.Close( self );
end

function PANEL:Init()
    self.BaseClass.Init( self );

    self.header:SetIcon( "scoreboard/usergroups/ug_1.png" );
    self.header:SetTitle( translates.Get("Восстановление привилегии") );
    self.header:SetFont( "rpui.playerselect.title" );

    self.accept = vgui.Create( "DButton", self.workspace );
    self.accept:SetFont( "rpui.fonts.RestoreRank.Button" );
    self.accept:SetText( translates.Get("ВОССТАНОВИТЬ") );
    self.accept.Paint = paint_button;
    self.accept.DoClick = function( this ) self:Answer( true ); self:Close(); end

    self.reject = vgui.Create( "DButton", self.workspace );
    self.reject:SetFont( "rpui.fonts.RestoreRank.Button" );
    self.reject:SetText( translates.Get("ЗАКРЫТЬ") );
    self.reject.Paint = paint_button;
    self.reject.DoClick = function( this ) self:Close(); end

    self.workspace.Paint = function( this, w, h )
        if not self.b_PreRendered then
            this.lines = {};
            local rank = ba.ranks.Get( self:GetRankID() or 1 );

            local ply = player.GetBySteamID64( self:GetSteamID64() );

            this.title, this.rank = translates.Get("Предыдущая донатная привилегия игрока %s:", (ply and string.format("%s (%s)", ply:Name(), ply:SteamID()) or self:GetSteamID64())), rank.NiceName;
            this.rank_mat = Material( "rpui/escmenu/usericons/" .. rank.ID );
            this._padding = 6;

            surface.SetFont( "rpui.fonts.RestoreRank.Default" );
            local title_width, title_height = surface.GetTextSize( this.title );

            surface.SetFont( "rpui.fonts.RestoreRank.Bold" );
            local rank_width, rank_height = surface.GetTextSize( this.rank );

            this.lines[1] = {title_width, title_height + this._padding};
            this.lines[2] = {rank_height + this._padding + rank_width, rank_height};

            this._width, this._height = math.max(this.lines[1][1], this.lines[2][1]), this.lines[1][2] + this.lines[2][2];

            self.b_PreRendered = true;
        end

        local x, y = w * 0.5 - this._width * 0.5, (h - self.header:GetTall() * 0.75 - 16) * 0.5 - this._height * 0.5;
        draw.SimpleText( this.title, "rpui.fonts.RestoreRank.Default", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );

        x, y = x + this._width * 0.5 - this.lines[2][1] * 0.5, y + this._padding + this.lines[1][2];
        surface.SetDrawColor( color_white );
        surface.SetMaterial( this.rank_mat );
        surface.DrawTexturedRect( x, y, this.lines[2][2], this.lines[2][2] );

        x = x + this.lines[2][2] + this._padding;
        draw.SimpleText( this.rank, "rpui.fonts.RestoreRank.Bold", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
    end

    timer.Simple( 30, function()
        if IsValid( self ) then self:Close(); end
    end );
end

function PANEL:PostPerformLayout()
    local btn_width = (self:GetWide() - 16 - 8) * 0.5;
    local btn_height = self.header:GetTall() * 0.75;

    self.accept:SetSize( btn_width, btn_height );
    self.reject:SetSize( btn_width, btn_height );

    self.accept:SetPos( 8, self.workspace:GetTall() - self.accept:GetTall() - 8 );
    self.reject:SetPos( self.workspace:GetWide() - self.accept:GetWide() - 8, self.workspace:GetTall() - self.accept:GetTall() - 8 );
end

vgui.Register( "rpui.popup.RestoreRank", PANEL, "urf.im/rpui/menus/blank" );