-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_referralpanel_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL_PROMOCODEINPUT = {};
PANEL_PROMOCODEINPUT.color_white = Color(255, 255, 255);
PANEL_PROMOCODEINPUT.color_black = Color(0, 0, 0);
PANEL_PROMOCODEINPUT.color_transparent = Color(0, 0, 0, 245);
PANEL_PROMOCODEINPUT.color_highlight = Color(255, 150, 0);
PANEL_PROMOCODEINPUT.color_success = Color(46, 204, 113);
PANEL_PROMOCODEINPUT.color_failure = Color(231, 76, 60);
PANEL_PROMOCODEINPUT.material_edit = Material("rpui/misc/edit.png", "smooth noclamp");
PANEL_PROMOCODEINPUT.material_save = Material("rpui/misc/save.png", "smooth noclamp");
PANEL_PROMOCODEINPUT.material_cancel = Material("rpui/misc/cancel.png", "smooth noclamp");

function PANEL_PROMOCODEINPUT:PowerOfTwo( val )
    return val + (val % 2);
end

function PANEL_PROMOCODEINPUT:Init()
    -- TextEntry: `Code` -------------------------------------------
    self.Code = vgui.Create( "DTextEntry", self );
    self.Code:Dock( LEFT );
    self.Code:SetText( LocalPlayer():GetReferralCode() );

    self.Code.m_Font = "DermaLarge";
    self.Code.m_FontSmall = "DermaDefault";
    self.Code.m_FontTooltip = "DermaDefault";

    self.Code.m_Filter = {
        {
            text = translates.Get("Промокод должен быть больше 5 символов"),
            check = function( val ) return #val > 3; end
        },

        {
            text = translates.Get("Промокод должен быть меньше 13 символов"),
            check = function( val ) return #val < 11; end
        },

        {
            text = translates.Get("Только латиница и цифры"),
            check = function( val )
                local status = #val > 0;

                for c in string.gmatch( val, "[^a-z0-9]" ) do
                    status = false; break;
                end

                return status
            end
        },
    };

    self.Code.OnEnter = function( this )
        self.Action:DoClick();
    end

    self.Code.AllowInput = function( this, char )
        if #this:GetText() > 13 then return true end
    end

    self.Code.Paint = function( this, w, h )
        surface.SetDrawColor( self.color_black );
        surface.DrawRect( 0, 0, w, h );

        local value = this:GetValue();
        local text = this.b_WaitingUpdate and translates.Get("ПОДОЖДИТЕ...") or string.upper( (this.b_IsEditing and "g-" or "") .. value );

        local font = this.m_Font;
        surface.SetFont( font );
        local text_bounds_w = surface.GetTextSize( text );
        if text_bounds_w > w * 0.9 then
            font = this.m_FontSmall;
        end

        this.fl_AnimColor = Lerp( RealFrameTime() * 6, this.fl_AnimColor or 0, this.b_CursorHovered and 1 or 0 );
        local color_text = LerpVector( this.fl_AnimColor, self.color_white:ToVector(), self.color_highlight:ToVector() ):ToColor();

        local text_w, text_h = draw.SimpleText( text, font, w * 0.5, h * 0.5, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

        this.fl_AnimTooltip = Lerp( RealFrameTime() * 12, this.fl_AnimTooltip or 0, this.b_IsEditing and 1 or 0 );
        if this.fl_AnimTooltip > 0.01 then
            if this.b_IsEditing then
                surface.SetFont( font );

                local text_caret_w, text_caret_h = surface.GetTextSize( utf8.sub(text, 0, this:GetCaretPos() + 2) );
                surface.SetDrawColor( ColorAlpha(self.color_white, 128 + math.sin(SysTime() * 6) * 127) );

                do
                    local x, y = w * 0.5 - text_w * 0.5 + text_caret_w, h * 0.5;
                    surface.DrawLine( x, y - text_h * 0.45, x, y + text_h * 0.45 );
                end

                this.b_IsEditing_Filtered = true;
            end

            do local oldClip = DisableClipping( true );
                local surf_alpha = surface.GetAlphaMultiplier();
                surface.SetAlphaMultiplier( surf_alpha * this.fl_AnimTooltip );

                local padding = self:PowerOfTwo( h * 0.2 );

                local x, y = 0, -padding * 1.5;

                if this.b_TooltipCalculated then
                    x = -this.fl_TooltipWidth * 0.5 + w * 0.5;

                    surface.SetDrawColor( self.color_transparent );
                    surface.DrawRect( x, y - this.fl_TooltipHeight, this.fl_TooltipWidth, this.fl_TooltipHeight );

                    if not this.m_TooltipHinge then
                        local px, py = x + this.fl_TooltipWidth * 0.5, y;

                        this.m_TooltipHinge = {
                            { x = px - padding, y = py },
                            { x = px + padding, y = py },
                            { x = px, y = py + padding },
                        }
                    end

                    draw.NoTexture();
                    surface.DrawPoly( this.m_TooltipHinge );
                end

                x, y = x + padding * 2, y - padding;

                local tw, th, val = 0, 0, string.lower( value );
                for i = #this.m_Filter, 1, -1 do
                    local filter = this.m_Filter[i];

                    if this.b_IsEditing then
                        this["m_Filtered" .. i] = filter.check( val );

                        if this.b_IsEditing_Filtered and (not this["m_Filtered" .. i]) then
                            this.b_IsEditing_Filtered = false;
                        end
                    end

                    local color_status = this["m_Filtered" .. i] and self.color_success or self.color_failure;

                    tw, th = draw.SimpleText( filter.text, this.m_FontTooltip, x, y, color_status, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
                    y = y - th;

                    if not this.b_TooltipCalculated then
                        this.fl_TooltipWidth = math.max( this.fl_TooltipWidth or 0, tw );
                        this.fl_TooltipHeight = (this.fl_TooltipHeight or 0) + th;
                    end
                end

                if not this.b_TooltipCalculated then
                    this.fl_TooltipWidth, this.fl_TooltipHeight = this.fl_TooltipWidth + padding * 4, this.fl_TooltipHeight + padding * 2;
                    this.b_TooltipCalculated = true;
                end

                surface.SetAlphaMultiplier( surf_alpha );
            DisableClipping( oldClip ); end
        end
    end

    hook.Add( "OnReferralPromocodeUpdate", self, function( panel, code )
        panel.Code:SetText( code );

        panel.Code.b_WaitingUpdate = false;
        panel.Action:SetMouseInputEnabled( true );
    end );

    -- Button: `Code.Copy` -----------------------------------------
    self.Code.Copy = vgui.Create( "DButton", self.Code );

    self.Code.Copy.PerformLayout = function( this )
        this:SetSize( this:GetParent():GetSize() );
    end

    self.Code.Copy.DoClick = function( this )
        rp.Notify( NOTIFY_GENERIC, translates.Get("Промокод скопирован!") );
        SetClipboardText( string.upper(this:GetParent():GetValue()) );
    end

    self.Code.Copy.OnCursorEntered = function( this, w, h )
        this:GetParent().b_CursorHovered = true;
    end

    self.Code.Copy.OnCursorExited = function( this, w, h )
        this:GetParent().b_CursorHovered = false;
    end

    self.Code.Copy.Paint = function( this, w, h )
        return true
    end

    -- Button: `Action` --------------------------------------------
    self.Action = vgui.Create( "DButton", self );
    self.Action:Dock( LEFT );
    self.Action.m_ControlPanel = self.Code;
    self.Action.fl_IconSize = 0.45;

    self.Action.DoClick = function( this )
        this.m_ControlPanel.b_IsEditing = not this.m_ControlPanel.b_IsEditing;

        this.m_ControlPanel.Copy[this.m_ControlPanel.b_IsEditing and "Hide" or "Show"]( this.m_ControlPanel.Copy );

        if this.m_ControlPanel.b_IsEditing then
            this.m_ControlPanel.m_OldValue = this.m_ControlPanel:GetText();
            this.m_ControlPanel:SetText( "" );

            this.m_ControlPanel:RequestFocus();
            return
        end

        this.m_ControlPanel.b_WaitingUpdate = true;
        this:SetMouseInputEnabled( false );

        timer.Simple( 5, function()
            if IsValid( this ) and IsValid( this.m_ControlPanel ) and this.m_ControlPanel.b_WaitingUpdate then
                this.m_ControlPanel:SetText( this.m_ControlPanel.m_OldValue );
                this.m_ControlPanel.b_WaitingUpdate = false;
                this:SetMouseInputEnabled( true );
            end
        end );

        local val = string.lower( this.m_ControlPanel:GetText() );
        for k, filter in ipairs( this.m_ControlPanel.m_Filter ) do
            if not filter.check( val ) then
                this.m_ControlPanel:SetText( this.m_ControlPanel.m_OldValue );
                this.m_ControlPanel.b_WaitingUpdate = false;
                this:SetMouseInputEnabled( true );
                return
            end
        end

        net.Start( "rp.Referrals::UpdateCode" );
            net.WriteString( this.m_ControlPanel:GetText() );
        net.SendToServer();
    end

    self.Action.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_SOLID );

        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );

        local size = math.min( w, h ) * this.fl_IconSize;
        local halfsize = size * 0.5;

        surface.SetDrawColor( textColor );
        surface.SetMaterial( this.m_ControlPanel.b_IsEditing and (this.m_ControlPanel.b_IsEditing_Filtered and self.material_save or self.material_cancel) or self.material_edit );
        surface.DrawTexturedRect( w * 0.5 - halfsize, h * 0.5 - halfsize, size, size );

        return true
    end
end

function PANEL_PROMOCODEINPUT:PerformLayout( w, h )
    self.Code:SetWide( h * 5 );
    self.Action:SetWide( h );

    self:SizeToChildren( true, false );
end

PANEL_PROMOCODEINPUT = vgui.RegisterTable( PANEL_PROMOCODEINPUT, "EditablePanel" );


local PANEL = {};

local color_defaultrarity_top, color_defaultrarity_bottom = Color(170, 200, 235), Color(80, 110, 145);

function PANEL:WrapText( text, font, size )
    local id = text .. size;

    self.WrappedTexts = self.WrappedTexts or {};
    if self.WrappedTexts[id] then
        return self.WrappedTexts[id];
    end

    local ret, x, y, space = {}, 0, 1, false;

    surface.SetFont( font );
    text = string.Explode( " ", text );
    for k, str in ipairs( text ) do
        local tw = surface.GetTextSize( str );
        x = x + tw;

        if x >= size then
            x, y, space = 0, y + 1, false;
        end

        ret[y], space = (ret[y] or "") .. (space and " " or "") .. str, true;
    end

    self.WrappedTexts[id] = ret;
    return ret;
end

function PANEL:GenerateRoundedRect( x, y, w, h, r, q )
    local id = x .. y .. w .. h .. r .. q;

    self.GeneratedRects = self.GeneratedRects or {};
    if self.GeneratedRects[id] then
        return self.GeneratedRects[id]
    end

    local p = {};

    table.insert( p, { x = x, y = y } );
    table.insert( p, { x = x+w, y = y } );

    for i = 0, q do
        local a = math.rad( 90 - (i/q) * 90 );

        local out = {
            x = x + w - r + math.sin(a) * r,
            y = y + h - r + math.cos(a) * r
        }

        table.insert( p, out );
    end

    for i = 0, q do
        local a = math.rad( (i/q) * -90 );

        local out = {
            x = x + r + math.sin(a) * r,
            y = y + h - r + math.cos(a) * r
        }

        table.insert( p, out );
    end

    for k, v in pairs( p ) do
        local x_, y_ = v.x - x, v.y - y;
        v.u = x_ / w; v.v = y_ / h + 0.0025;
    end

    self.GeneratedRects[id] = p;
    return p;
end

function PANEL:PaintRewards( pnl, w, h, key )
    local rewards = (rp.cfg.ReferralRewards or {})[key];
    if not rewards then return end

    local count = math.min(2, #rewards);

    local padding = self.Padding * 2;

    local truesize = w / count - padding * 0.5;
    if h < truesize then
        truesize = h;
    end

    local totalsize = truesize * count + padding * (count - 1);
    local size = totalsize / count;

    local clip = DisableClipping( true );
    for i = 1, count do
        local reward = rewards[i];

        local x, y = rpui.PowOfTwo( (w * 0.5 - totalsize * 0.5) + (i - 1) * truesize + padding * (i - 1) ), h * 0.5 - truesize * 0.5;

        local rb = self:GenerateRoundedRect(
            x,
            h * 0.5 + truesize * 0.15,
            truesize,
            rpui.PowOfTwo(truesize * 0.35),
            16,
            4
        );

        local icon_height = rpui.PowOfTwo(truesize * 0.65) + 1;
        local icon_size = icon_height * 0.95;

        local colors = reward.colors or {};
        draw.RoundedBoxEx( 16, x, y, truesize, icon_height, Color(255,255,255,75), true, true, false, false );

        draw.NoTexture();
        surface.SetDrawColor( colors[1] or color_defaultrarity_top );
        surface.DrawPoly( rb );

        surface.SetMaterial( Material("gui/gradient_up") );
        surface.SetDrawColor( colors[2] or color_defaultrarity_bottom );
        surface.DrawPoly( rb );

        if reward.icon then
            surface.SetDrawColor( color_white );
            surface.SetMaterial( reward.icon );
            surface.DrawTexturedRect( x + truesize * 0.5 - icon_size * 0.5, y + icon_height * 0.5 - icon_size * 0.5, icon_size, icon_size );
        end

        surface.SetFont( "rpui.Fonts.ReferralPanel-Small" );
        local sw, sh = surface.GetTextSize( " " );
        local wrap = self:WrapText( reward.name or translates.Get("Неизвестная награда"), "rpui.Fonts.ReferralPanel-Small", truesize - self.Padding * 2 );
        for k, v in ipairs( wrap ) do
            draw.SimpleText( v, "rpui.Fonts.ReferralPanel-Small", x + truesize * 0.5, y + truesize * 0.65 + truesize * 0.35 * 0.5 - #wrap * sh * 0.5 + (k - 1) * sh, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP );
        end
    end
    DisableClipping( clip );
end

function PANEL:Init()
    self.Opacity = 0;

    self.Content = vgui.Create( "Panel", self );
    self.Content:Dock( FILL );
    self.Content.Paint = function( this, w, h )
        local pl, pt, pr, pb = this:GetDockPadding();

        surface.SetDrawColor( Color(0, 0, 0, self.Opacity * 127) );
        surface.DrawRect( pl, pt, w - pl - pr, h - pt - pb );
    end

    self.Content.ReferrerRewards = vgui.Create( "Panel", self.Content );
    self.Content.ReferrerRewards:Dock( RIGHT );

    self.Content.ReferrerRewards.Label = vgui.Create( "DLabel", self.Content.ReferrerRewards );
    self.Content.ReferrerRewards.Label:Dock( TOP );
    self.Content.ReferrerRewards.Label:SetContentAlignment( 5 );
    self.Content.ReferrerRewards.Label:SetFont( "DermaDefault" );
    self.Content.ReferrerRewards.Label:SetText( translates.Get("Ваша награда:") );

    self.Content.ReferrerRewards.Content = vgui.Create( "Panel", self.Content.ReferrerRewards );
    self.Content.ReferrerRewards.Content:Dock( FILL );
    self.Content.ReferrerRewards.Content.Paint = function( this, w, h )
        self:PaintRewards( this, w, h, "Referrer" );
    end

    self.Content.RefereeRewards = vgui.Create( "Panel", self.Content );
    self.Content.RefereeRewards:Dock( RIGHT );

    self.Content.RefereeRewards.Label = vgui.Create( "DLabel", self.Content.RefereeRewards );
    self.Content.RefereeRewards.Label:Dock( TOP );
    self.Content.RefereeRewards.Label:SetContentAlignment( 5 );
    self.Content.RefereeRewards.Label:SetFont( "DermaDefault" );
    self.Content.RefereeRewards.Label:SetText( translates.Get("По промокоду друг получит:") );

    self.Content.RefereeRewards.Content = vgui.Create( "Panel", self.Content.RefereeRewards );
    self.Content.RefereeRewards.Content:Dock( FILL );
    self.Content.RefereeRewards.Content.Paint = function( this, w, h )
        self:PaintRewards( this, w, h, "Referee" );
    end

    self.Content.Information = vgui.Create( "Panel", self.Content );
    self.Content.Information:Dock( FILL );
    self.Content.Information.PerformLayout = function( this, w, h )
        this.Points:PerformLayout( w, h );
        this.Points:Center();
    end

    self.Content.Information.Points = vgui.Create( "Panel", self.Content.Information );
    self.Content.Information.Points.PerformLayout = function( this, w, h )
        this:SetWide( w );

        for k, item in ipairs( this.Items or {} ) do
            item:PerformLayout();
        end

        this:SizeToChildren( false, true );
    end

    self.Content.Information.Points.ClearPoints = function( this )
        for k, pnl in ipairs( this.Items or {} ) do
            pnl:Remove();
        end

        this.Items = {};
    end

    self.Content.Information.Points.AddPoint = function( this, id, font, text )
        this.Items = this.Items or {};

        local panel = vgui.Create( "Panel", this );
        panel:Dock( TOP );
        panel.PerformLayout = function( me, w, h )
            me.id:SetTall( me.text:GetTall() );
            me:SizeToChildren( true, true );
        end

        panel.id = vgui.Create( "DLabel", panel );
        panel.id:SetContentAlignment( 7 );
        panel.id:SetFont( font );
        panel.id:SetText( id or "" );
        panel.id:SizeToContentsX();

        panel.text = vgui.Create( "DLabel", panel );
        panel.text:SetWrap( true );
        panel.text:SetAutoStretchVertical( true );
        panel.text:SetContentAlignment( 7 );
        panel.text:SetFont( font );
        panel.text:SetText( text );

        table.insert( this.Items, panel );

        panel.id:Dock( LEFT );
        panel.text:Dock( TOP );

        local max_w = 0;
        for k, pnl in ipairs( this.Items ) do
            if not pnl or not pnl.id then continue end
            max_w = math.max( max_w, pnl.id:GetWide() );
        end

        for k, pnl in ipairs( this.Items ) do
            if not pnl or not pnl.id then continue end
            if id == nil then pnl.id:Hide(); continue end
            pnl.id:SetWide( max_w );
        end

        return panel
    end

    self.Footer = vgui.Create( "Panel", self );
    self.Footer:Dock( BOTTOM );
    self.Footer.Paint = function( this, w, h )
        surface.SetDrawColor( Color(0, 0, 0, (1 - self.Opacity) * 255) );
        surface.DrawRect( 0, 0, w, h );
    end

    self.Footer.LabelInvited = vgui.Create( "DLabel", self.Footer );
    self.Footer.LabelInvited:Dock( LEFT );
    self.Footer.LabelInvited:SetFont( "DermaDefault" );
    self.Footer.LabelInvited:SetText( translates.Get("Друзей приглашено:") );
    self.Footer.LabelInvited:SizeToContentsX();

    self.Footer.Invited = vgui.Create( "DLabel", self.Footer );
    self.Footer.Invited:Dock( LEFT );
    self.Footer.Invited:SetFont( "DermaLarge" );
    self.Footer.Invited:SetText( "0" );
    self.Footer.Invited.RefereeCount = 0
    self.Footer.Invited.Think = function( this )
        if (this.fl_LastUpdated or 0) > SysTime() then return end
        this.fl_LastUpdated = SysTime() + 1;

        this.RefereeCount = LocalPlayer():GetRefereeCount()

        this:SetText( this.RefereeCount > 100 and 0 or this.RefereeCount );
        this:SizeToContentsX();
    end

    self.Footer.Promocode = vgui.CreateFromTable( PANEL_PROMOCODEINPUT, self.Footer, "PromocodeInput" );
    self.Footer.Promocode:Dock( RIGHT );

    self.Footer.LabelPromocode = vgui.Create( "DLabel", self.Footer );
    self.Footer.LabelPromocode:Dock( RIGHT );
    self.Footer.LabelPromocode:SetFont( "DermaDefault" );
    self.Footer.LabelPromocode:SetText( translates.Get("Промокод:") );
    self.Footer.LabelPromocode:SizeToContentsX();
end

function PANEL:RebuildFonts( w, h )
    surface.CreateFont( "rpui.Fonts.ReferralPanel-Default", {
        font = "Montserrat Medium",
        size = w * 0.02,
        weight = 600,
        extended = true,
    } );

    surface.CreateFont( "rpui.Fonts.ReferralPanel-DefaultBold", {
        font = "Montserrat Bold",
        size = w * 0.02,
        weight = 1000,
        extended = true,
    } );

    surface.CreateFont( "rpui.Fonts.ReferralPanel-Bold", {
        font = "Montserrat Bold",
        size = w * 0.025,
        weight = 1000,
        extended = true,
    } );

    surface.CreateFont( "rpui.Fonts.ReferralPanel-LargeBold", {
        font = "Montserrat Bold",
        size = w * 0.03,
        weight = 1000,
        extended = true,
    } );

    surface.CreateFont( "rpui.Fonts.ReferralPanel-Small", {
        font = "Montserrat Medium",
        size = w * 0.0175,
        weight = 600,
        extended = true,
    } );

    self.Footer.LabelInvited:SetFont( "rpui.Fonts.ReferralPanel-Default" );
    self.Footer.LabelInvited:SizeToContentsX();

    self.Footer.LabelPromocode:SetFont( "rpui.Fonts.ReferralPanel-Default" );
    self.Footer.LabelPromocode:SizeToContentsX();

    self.Footer.Invited:SetFont( "rpui.Fonts.ReferralPanel-Bold" );
    self.Footer.Invited:SizeToContentsX();

    self.Footer.Promocode.Code.m_Font = "rpui.Fonts.ReferralPanel-Bold";
    self.Footer.Promocode.Code.m_FontSmall = "rpui.Fonts.ReferralPanel-DefaultBold";
    self.Footer.Promocode.Code.m_FontTooltip = "rpui.Fonts.ReferralPanel-Small";

    self.Content.ReferrerRewards.Label:SetFont( "rpui.Fonts.ReferralPanel-DefaultBold" );
    self.Content.ReferrerRewards.Label:SizeToContentsY();

    self.Content.RefereeRewards.Label:SetFont( "rpui.Fonts.ReferralPanel-DefaultBold" );
    self.Content.RefereeRewards.Label:SizeToContentsY();

    self.Content.Information.Points:ClearPoints();
    self.Content.Information.Points:AddPoint( nil, "rpui.Fonts.ReferralPanel-LargeBold", translates.Get("ПРИГЛАСИ ДРУГА И ПОЛУЧИ ПОДАРОК") );
    self.Content.Information.Points:AddPoint( "1.", "rpui.Fonts.ReferralPanel-Default", translates.Get("Отправь другу промокод") .. ";" );
    self.Content.Information.Points:AddPoint( "2.", "rpui.Fonts.ReferralPanel-Default", translates.Get("После 4 часов игры вы и ваш друг получите награды") .. ";" );
end

function PANEL:PerformLayout( w, h )
    self:RebuildFonts( w, h );

    self.Padding = w * 0.005;

    self.Footer:SetTall( w * 0.05 );
    self.Footer:DockPadding( self.Padding * 8, self.Padding, self.Padding * 8, self.Padding );

    self.Footer.LabelInvited:DockMargin( 0, 0, self.Padding * 2, 0 );
    self.Footer.LabelPromocode:DockMargin( 0, 0, self.Padding * 2, 0 );

    self.Content.ReferrerRewards:SetWide( w * 0.3 );
    self.Content.RefereeRewards:SetWide( w * 0.3 );

    self.Content:DockPadding( self.Padding, self.Padding, self.Padding, 0 );
    self.Content.Information:DockMargin( self.Padding * 5, 0, self.Padding * 5, 0 );

    self.Content.ReferrerRewards:DockMargin( self.Padding * 2, self.Padding, self.Padding * 7, self.Padding );
    self.Content.ReferrerRewards.Label:DockMargin( 0, 0, 0, self.Padding );
    self.Content.ReferrerRewards.Content:DockMargin( 0, self.Padding, 0, self.Padding );

    self.Content.RefereeRewards:DockMargin( 0, self.Padding, 0, self.Padding );
    self.Content.RefereeRewards.Label:DockMargin( 0, 0, 0, self.Padding );
    self.Content.RefereeRewards.Content:DockMargin( 0, self.Padding, 0, self.Padding );
end

function PANEL:Paint( w, h )
    self.rotAngle = SysTime() * -32;
    local distsize = math.sqrt( w*w + h*h );

    local surf_alpha = surface.GetAlphaMultiplier();
    surface.SetAlphaMultiplier( surf_alpha * (self:GetAlpha() / 255) );
        surface.SetDrawColor( rpui.UIColors.TextGold );
        surface.DrawRect( 0, 0, w, h );

        surface.SetMaterial( rpui.GradientMat );
        surface.SetDrawColor( rpui.UIColors.Gold );
        surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (self.rotAngle or 0) );
    surface.SetAlphaMultiplier( surf_alpha );
end

vgui.IsPanelHovered = function( panel )
    local target = vgui.GetHoveredPanel();
    if not IsValid( target ) then return end

    if target == panel then
        return true
    end

    local prev = target:GetParent();

    while IsValid( prev ) do
        if prev == panel then return true end
        prev = prev:GetParent();
    end

    return false
end

function PANEL:Think()
    self.b_Hovered = vgui.IsPanelHovered( self );
    self.Opacity = Lerp( RealFrameTime() * 6, self.Opacity, self.b_Hovered and 1 or 0 );

    self:SetAlpha( 127 + self.Opacity * 128 );
end

vgui.Register( "rpui.ReferralPanel", PANEL, "DPanel" );