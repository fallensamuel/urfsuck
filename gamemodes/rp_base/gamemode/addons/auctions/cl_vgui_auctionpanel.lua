-- "gamemodes\\rp_base\\gamemode\\addons\\auctions\\cl_vgui_auctionpanel.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {};

PANEL.s_Rules =
    "1. " .. translates.Get( "Ставки принимаются игровыми кредитами" ) .. ";\n" ..
    "2. " .. translates.Get( "Если вашу ставку перебили, то кредиты мгновенно возвращаются на счет" ) .. ";\n" ..
    "3. " .. translates.Get( "Лот разыгрывается определенное время, указанное на таймере" ) .. ";\n" ..
    "4. " .. translates.Get( "Побеждает тот, чья ставка является максимальной, к моменту окончания таймера лота" ) .. ";\n" ..
    "5. " .. translates.Get( "Если за 10 минут до окончания таймера будет поставлена новая ставка - к таймеру прибавляется 10 минут" ) .. ";\n" ..
    "6. " .. translates.Get( "Во время работы аукциона работает межсерверный чат для игроков всех серверов URF.IM" ) .. ";\n" ..
    "7. " .. translates.Get( "В межсерверном чате запрещена реклама, оскорбления, ненормативная лексика и деструктивное поведение" );

function PANEL:RebuildFonts( w, h )
    if self.b_FontsInitialized then return end
    self.b_FontsInitialized = true;

    local s = 0.525;

    surface.CreateFont( "rpui.Fonts.AuctionsLarge", {
        font = "Montserrat",
        size = h * 0.045 * s,
        weight = 800,
        extended = true
    } );

    surface.CreateFont( "rpui.Fonts.AuctionsDefault", {
        font = "Montserrat",
        size = h * 0.0325 * s,
        weight = 400,
        extended = true
    } );

    surface.CreateFont( "rpui.Fonts.AuctionsSmall", {
        font = "Montserrat",
        size = h * 0.0275 * s,
        weight = 400,
        extended = true
    } );


    surface.CreateFont( "rpui.Fonts.AuctionsMedium", {
        font = "Montserrat",
        size = h * 0.04 * s,
        weight = 600,
        extended = true
    } );

    surface.CreateFont( "rpui.Fonts.AuctionsHuge", {
        font = "Montserrat",
        size = h * 0.07 * s,
        weight = 800,
        extended = true
    } );
end

function PANEL:GetCurrency()
    return translates.Get("₽");
end

function PANEL:DebugPaint( w, h )
    local clip = DisableClipping( true );
        surface.SetDrawColor( Color(255, 0, 0) );
        surface.DrawOutlinedRect( 0, 0, w, h );
    DisableClipping( clip );
end

function PANEL:Init()
    local w, h = ScrW(), ScrH();
    self.fl_Padding = h * 0.01;

    self:RebuildFonts( w, h );

    self.Footer = self:Add( "Panel" );
    self.Footer:Dock( BOTTOM );
    self.Footer:DockMargin( 0, self.fl_Padding, 0, 0 );
    self.Footer.PerformLayout = function( this, w, h )
        local childrens = this:GetChildren();
        local lastchild, count = nil, #childrens;

        local grow = 0;

        for k, child in ipairs( childrens ) do
            if not child:IsVisible() then continue end

            lastchild = child;

            child:Dock( NODOCK );
            child:InvalidateLayout( true );

            child.fl_Grow = child.fl_Grow or 1;
            grow = grow + child.fl_Grow;
        end

        this:SizeToChildren( false, true );
        w, h = this:GetSize();

        local x = 0;
        local spacing = w / grow;
        local lw = 0;

        for k, child in ipairs( childrens ) do
            if not child:IsVisible() then continue end

            child:SetX( x );

            x = x + spacing * child.fl_Grow;
            lw = child:GetX() + child:GetWide();
        end

        local margin = (w - lw) / (grow - lastchild.fl_Grow);

        local lx = 0;
        for k, child in ipairs( childrens ) do
            if not child:IsVisible() then continue end

            child:SetX( child:GetX() + lx );
            lx = lx + margin * (child.fl_Grow or 1);

            if child.b_Centered then
                child:SetY( h * 0.5 - child:GetTall() * 0.5 );
            end
        end
    end

    --
    self.Footer.Timeleft = self.Footer:Add( "Panel" );
    self.Footer.Timeleft.fl_Grow = 1.5;
    self.Footer.Timeleft.PerformLayout = function( this, w, h )
        this.Title:Dock( NODOCK );
        this.Title:SizeToContents();

        this.Content:Dock( NODOCK );
        this.Content:InvalidateLayout( true );

        this:SizeToChildren( true, false );

        this.Title:Dock( TOP );
        this.Content:Dock( TOP );

        this:SizeToChildren( false, true );
    end

    self.Footer.Timeleft.Title = self.Footer.Timeleft:Add( "DLabel" );
    self.Footer.Timeleft.Title:DockMargin( 0, 0, 0, self.fl_Padding * 0.5 );
    self.Footer.Timeleft.Title:SetFont( "rpui.Fonts.AuctionsDefault" );
    self.Footer.Timeleft.Title:SetText( translates.Get("До конца торгов:") );
    self.Footer.Timeleft.Title:SetTextColor( color_white );
    self.Footer.Timeleft.Title:SizeToContents();

    self.Footer.Timeleft.Content = self.Footer.Timeleft:Add( "Panel" );
    self.Footer.Timeleft.Content.PerformLayout = function( this, w, h )
        this.Icon:Dock( NODOCK );
        this.Icon:SetTall( 0 );

        this.Value:Dock( NODOCK );
        this.Value:InvalidateLayout( true );

        this:SizeToChildren( false, true );

        this.Icon:Dock( LEFT );
        this.Icon:SetWide( this:GetTall() );

        this.Value:Dock( LEFT );

        this:SizeToChildren( true, false );
    end

    self.Footer.Timeleft.Content.Icon = self.Footer.Timeleft.Content:Add( "DPanel" );
    self.Footer.Timeleft.Content.Icon:DockMargin( 0, 0, self.fl_Padding, 0 );
    self.Footer.Timeleft.Content.Icon.m_icon = Material( "rpui/icons/auctions/timeleft.png", "smooth noclamp" );
    self.Footer.Timeleft.Content.Icon.Paint = function( this, w, h )
        surface.SetMaterial( this.m_icon );
        surface.SetDrawColor( color_white );
        surface.DrawTexturedRect( 0, 0, w, h );
    end

    self.Footer.Timeleft.Content.Value = self.Footer.Timeleft.Content:Add( "DLabel" );
    self.Footer.Timeleft.Content.Value:SetFont( "rpui.Fonts.AuctionsLarge" );
    self.Footer.Timeleft.Content.Value:SetText( "" );
    self.Footer.Timeleft.Content.Value:SetTextColor( color_white );
    self.Footer.Timeleft.Content.Value:SizeToContents();
    self.Footer.Timeleft.Content.Value.i_TimestampEnd = auctions.utils.SyncedTime();
    self.Footer.Timeleft.Content.Value.Think = function( this )
        local t = auctions.utils.SyncedTime();
        if (this.fl_NextUpdate or 0) > t then return end
        this.fl_NextUpdate = t + 1;

        local diff = this.i_TimestampEnd - t;

        local w = this:GetWide();

        if diff < 1 then
            this:SetText( translates.Get("Торги завершены") );
            this:SizeToContentsX();

            return
        end

        this:SetText( auctions.utils.FormattedTime(diff) );
        this:SizeToContentsX();

        this:SetWide( math.max(w, this:GetWide()) );
    end

    --
    self.Footer.Player = self.Footer:Add( "Panel" );
    self.Footer.Player.fl_Grow = 2;
    self.Footer.Player.PerformLayout = function( this, w, h )
        this.Title:Dock( NODOCK );
        this.Title:SizeToContents();

        this.Content:Dock( NODOCK );
        this.Content:InvalidateLayout( true );

        this:SizeToChildren( true, false );

        this.Title:Dock( TOP );
        this.Content:Dock( TOP );

        this:SizeToChildren( false, true );
    end

    self.Footer.Player.Title = self.Footer.Player:Add( "DLabel" );
    self.Footer.Player.Title:DockMargin( 0, 0, 0, self.fl_Padding * 0.5 );
    self.Footer.Player.Title:SetFont( "rpui.Fonts.AuctionsDefault" );
    self.Footer.Player.Title:SetText( translates.Get("Последняя ставка:") );
    self.Footer.Player.Title:SetTextColor( color_white );
    self.Footer.Player.Title:SizeToContents();

    self.Footer.Player.Content = self.Footer.Player:Add( "Panel" );
    self.Footer.Player.Content.PerformLayout = function( this, w, h )
        this.Information:Dock( NODOCK );
        this.Information:InvalidateLayout( true );

        this:SizeToChildren( true, false );

        this.Information:Dock( LEFT );
        this.Avatar:Dock( LEFT );

        this:SizeToChildren( false, true );
        this.Avatar:SetWide( this:GetTall() );
    end

    self.Footer.Player.Content.Avatar = self.Footer.Player.Content:Add( "AvatarImage" );
    self.Footer.Player.Content.Avatar:DockMargin( 0, 0, self.fl_Padding, 0 );
    self.Footer.Player.Content.Avatar:SetZPos( 1 );

    self.Footer.Player.Content.Information = self.Footer.Player.Content:Add( "Panel" );
    self.Footer.Player.Content.Information:SetZPos( 2 );
    self.Footer.Player.Content.Information.PerformLayout = function( this, w, h )
        this.Name:Dock( NODOCK );
        this.Desc:Dock( NODOCK );

        this.Name:SizeToContents();
        this.Desc:SizeToContents();

        this:SizeToChildren( true, false );

        this.Name:Dock( TOP );
        this.Desc:Dock( TOP );

        this:SizeToChildren( false, true );
    end

    self.Footer.Player.Content.Information.Name = self.Footer.Player.Content.Information:Add( "DLabel" );
    self.Footer.Player.Content.Information.Name:SetFont( "rpui.Fonts.AuctionsLarge" );
    self.Footer.Player.Content.Information.Name:SetText( "Unknown Player" );
    self.Footer.Player.Content.Information.Name:SetTextColor( color_white );
    self.Footer.Player.Content.Information.Name:SetContentAlignment( 4 );

    self.Footer.Player.Content.Information.Desc = self.Footer.Player.Content.Information:Add( "DLabel" );
    self.Footer.Player.Content.Information.Desc:SetFont( "rpui.Fonts.AuctionsSmall" );
    self.Footer.Player.Content.Information.Desc:SetText( "Unknown" );
    self.Footer.Player.Content.Information.Desc:SetTextColor( color_white );
    self.Footer.Player.Content.Information.Desc:SetContentAlignment( 4 );
    self.Footer.Player.Content.Information.Desc:SetAlpha( 255 * 0.55 );

    --
    self.Footer.Amount = self.Footer:Add( "Panel" );
    self.Footer.Amount.PerformLayout = function( this, w, h )
        this.Title:Dock( NODOCK );
        this.Title:SizeToContents();

        this.Content:Dock( NODOCK );
        this.Content:InvalidateLayout( true );

        this:SizeToChildren( true, false );

        this.Title:Dock( TOP );
        this.Content:Dock( TOP );

        this:SizeToChildren( false, true );
    end

    self.Footer.Amount.Title = self.Footer.Amount:Add( "DLabel" );
    self.Footer.Amount.Title:DockMargin( 0, 0, 0, self.fl_Padding * 0.5 );
    self.Footer.Amount.Title:SetFont( "rpui.Fonts.AuctionsDefault" );
    self.Footer.Amount.Title:SetText( translates.Get("Текущая цена:") );
    self.Footer.Amount.Title:SetTextColor( color_white );
    self.Footer.Amount.Title:SizeToContents();

    self.Footer.Amount.Content = self.Footer.Amount:Add( "Panel" );
    self.Footer.Amount.Content.PerformLayout = function( this, w, h )
        this.Value:Dock( NODOCK );
        this.Value:InvalidateLayout( true );

        this:SizeToChildren( false, true );

        this.Value:Dock( LEFT );

        this:SizeToChildren( true, false );
    end

    self.Footer.Amount.Content.Value = self.Footer.Amount.Content:Add( "DLabel" );
    self.Footer.Amount.Content.Value:SetFont( "rpui.Fonts.AuctionsLarge" );
    self.Footer.Amount.Content.Value:SetText( "0" );
    self.Footer.Amount.Content.Value:SetTextColor( color_white );
    self.Footer.Amount.Content.Value:SizeToContents();
    self.Footer.Amount.Content.Value.s_Currency = self:GetCurrency();
    self.Footer.Amount.Content.Value.fl_Value = 0;
    self.Footer.Amount.Content.Value.fl_Target = 0;
    self.Footer.Amount.Content.Value.Think = function( this )
        this.fl_Value = Lerp( RealFrameTime() * 4, this.fl_Value, this.fl_Target );
        this:SetText( string.format("%s %s", math.Round(this.fl_Value), this.s_Currency) );
        this:SizeToContents();
    end

    --
    self.Footer.Balance = self.Footer:Add( "Panel" );
    self.Footer.Balance.PerformLayout = function( this, w, h )
        this.Title:Dock( NODOCK );
        this.Title:SizeToContents();

        this.Content:Dock( NODOCK );
        this.Content:InvalidateLayout( true );

        this:SizeToChildren( true, false );

        this.Title:Dock( TOP );
        this.Content:Dock( TOP );

        this:SizeToChildren( false, true );
    end

    self.Footer.Balance.Title = self.Footer.Balance:Add( "DLabel" );
    self.Footer.Balance.Title:DockMargin( 0, 0, 0, self.fl_Padding * 0.5 );
    self.Footer.Balance.Title:SetFont( "rpui.Fonts.AuctionsDefault" );
    self.Footer.Balance.Title:SetText( translates.Get("Баланс:") );
    self.Footer.Balance.Title:SetTextColor( color_white );
    self.Footer.Balance.Title:SizeToContents();

    self.Footer.Balance.Content = self.Footer.Balance:Add( "Panel" );
    self.Footer.Balance.Content.PerformLayout = function( this, w, h )
        this.Value:Dock( NODOCK );
        this.Value:InvalidateLayout( true );

        this:SizeToChildren( false, true );

        this.Value:Dock( LEFT );

        this:SizeToChildren( true, false );
    end

    self.Footer.Balance.Content.Value = self.Footer.Balance.Content:Add( "DLabel" );
    self.Footer.Balance.Content.Value:SetFont( "rpui.Fonts.AuctionsLarge" );
    self.Footer.Balance.Content.Value:SetText( "0" );
    self.Footer.Balance.Content.Value:SetTextColor( color_white );
    self.Footer.Balance.Content.Value:SizeToContents();
    self.Footer.Balance.Content.Value.s_Currency = self:GetCurrency();
    self.Footer.Balance.Content.Value.fl_Value = 0;
    self.Footer.Balance.Content.Value.fl_Target = 0;
    self.Footer.Balance.Content.Value.Think = function( this )
        this.fl_Target = LocalPlayer():GetCredits() or 0;
        this.fl_Value = Lerp( RealFrameTime() * 4, this.fl_Value, this.fl_Target );
        this:SetText( string.format("%s %s", math.Round(this.fl_Value), this.s_Currency) );
        this:SizeToContents();
    end

    --
    self.Footer.Bid = self.Footer:Add( "DButton" );
    self.Footer.Bid.fl_Grow = 2;
    self.Footer.Bid.b_Centered = true;
    self.Footer.Bid.fl_Timeout = 0;
    self.Footer.Bid:SetFont( "rpui.Fonts.AuctionsLarge" );
    self.Footer.Bid:SetText( translates.Get("СДЕЛАТЬ СТАВКУ") );
    self.Footer.Bid:SizeToContentsX( self.fl_Padding * 4 );
    self.Footer.Bid:SizeToContentsY( self.fl_Padding );

    self.Footer.Bid.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );

        if not this.b_Winner then
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );
        else
            textColor = rpui.UIColors.White;
        end

        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true
    end

    self.Footer.Bid.Think = function( this )
        local t = CurTime();

        if this.fl_Timeout > t then
            return
        end

        if not this:IsMouseInputEnabled() then
            this:SetMouseInputEnabled( true );
        end

        if not this.b_Winner then
            local price = self.Footer.Amount.Content.Value.fl_Target;
            local hasamount = LocalPlayer():GetCredits() >= price;

            if not this.b_NotEnough and not hasamount then
                this.b_NotEnough = true;
                this:SetText( translates.Get("ПОПОЛНИТЬ СЧЁТ") );
                this:SizeToContentsX( self.fl_Padding * 4 );
            elseif this.b_NotEnough and hasamount then
                this.b_NotEnough = false;
                this:SetText( translates.Get("СДЕЛАТЬ СТАВКУ") );
            end
        end
    end

    self.Footer.Bid.DoBid = function( this )
        local lot_id = self:GetLotID();
        if lot_id < 1 then return end

        auctions.networking:RequestBid( lot_id );

        this:SetMouseInputEnabled( false );
        this:SetText( translates.Get("ПОДОЖДИТЕ...") );

        this.fl_Timeout = CurTime() + 5;
    end

    self.Footer.Bid.DoDeposit = function( this )
        this:CreateDepositPanel();
    end

    self.Footer.Bid.DoClick = function( this )
        local t = CurTime();
        if this.fl_Timeout > t then return end

        if this.b_Winner then return end

        this[this.b_NotEnough and "DoDeposit" or "DoBid"]( this );
    end

    self.Footer.Bid.CreateDepositPanel = function( this )
        if IsValid( self.DepositPanel ) then
            self.DepositPanel:Close();
            return
        end

        self.DepositPanel = self:Add( "Panel" );
        self.DepositPanel:DockPadding( self.fl_Padding, self.fl_Padding, self.fl_Padding, self.fl_Padding * 2.5 );
        self.DepositPanel:SetWide( self.fl_Padding * 24 );
        self.DepositPanel:SetAlpha( 0 );
        self.DepositPanel:AlphaTo( 255, 0.25 );

        self.DepositPanel.Close = function( pnl )
            if pnl.b_Closing then return end
            pnl.b_Closing = true;

            pnl:AlphaTo( 0, 0.25, 0, function( a, p )
                p:Remove();
            end );
        end

        self.DepositPanel.Paint = function( pnl, w, h )
            local p = math.floor( self.fl_Padding * 1.5 );

            draw.NoTexture();

            surface.SetDrawColor( rpui.UIColors.Background );
            surface.DrawRect( 0, 0, w, h - p );

            if pnl.m_poly then
                surface.DrawPoly( pnl.m_poly );
            end
        end

        self.DepositPanel.PerformLayout = function( pnl, w, h )
            local lx, ly = this:LocalToScreen( this:GetWide(), 0 );

            pnl:SizeToChildren( false, true );
            w, h = pnl:GetSize();

            pnl:SetPos( self:ScreenToLocal(lx - w, ly - h - self.fl_Padding) );

            local p = math.floor( self.fl_Padding * 1.5 );
            pnl.m_poly = { {x = w - p, y = h - p}, {x = w, y = h - p}, {x = w, y = h} };
        end

        local function DonateButton()
            local btn = vgui.Create( "DButton" );
            btn:Dock( TOP );
            btn:DockMargin( 0, 0, 0, self.fl_Padding );
            btn:SetFont( "rpui.Fonts.AuctionsMedium" );
            btn:SetText( "" );
            btn:SizeToContentsY( self.fl_Padding * 2 );

            btn.Paint = function( pnl, w, h )
                local cw, ch = w * 0.5, h * 0.5;

                pnl.rotAngle = (pnl.rotAngle or 0) + 100 * FrameTime();
                local distsize = math.sqrt( w * w + h * h );

                surface.SetDrawColor( rpui.UIColors.Gold );
                surface.DrawRect( 0, 0, w, h );

                surface.SetMaterial( rpui.GradientMat );
                surface.SetDrawColor( rpui.UIColors.BackgroundGold );
                surface.DrawTexturedRectRotated( cw, ch, distsize, distsize, pnl.rotAngle );

                local iw = math.ceil( w * 0.9 );
                local ih = iw * 0.125;

                if pnl.m_Material then
                    surface.SetMaterial( pnl.m_Material );
                    surface.SetDrawColor( color_white );
                    surface.DrawTexturedRect( cw - iw * 0.5, ch - ih * 0.5 + 1, iw, ih );
                end
            end

            return btn;
        end

        self.DepositPanel.Input = self.DepositPanel:Add( "Panel" );
        self.DepositPanel.Input:Dock( TOP );
        self.DepositPanel.Input:DockMargin( 0, 0, 0, self.fl_Padding );
        self.DepositPanel.Input.PerformLayout = function( pnl, w, h )
            surface.SetFont( pnl.Entry:GetFont() );
            local th = select( 2, surface.GetTextSize(" ") );
            pnl.Entry:SetTall( th + self.fl_Padding * 2 );
            pnl:SizeToChildren( false, true );
            pnl.Entry:DockMargin( pnl:GetTall(), 0, 0, 0 );
        end

        local mat_icon = Material( "rpui/donatemenu/money" );

        self.DepositPanel.Input.Paint = function( pnl, w, h )
            local cw, ch = w * 0.5, h * 0.5;

            pnl.rotAngle = (pnl.rotAngle or 0) + 100 * FrameTime();
            local distsize = math.sqrt( w * w + h * h );

            surface.SetDrawColor( rpui.UIColors.Gold );
            surface.DrawRect( 0, 0, w, h );

            surface.SetMaterial( rpui.GradientMat );
            surface.SetDrawColor( rpui.UIColors.BackgroundGold );
            surface.DrawTexturedRectRotated( cw, ch, distsize, distsize, pnl.rotAngle );

            local s = rpui.PowOfTwo( h * 0.05 );
            local iw, ih = w - s * 2, h - s * 2;

            surface.SetDrawColor( color_white );
            surface.DrawRect( s, s, iw, ih );

            local icon_s = h * 0.6;
            local icon_p = h * 0.5 - icon_s * 0.5;

            surface.SetMaterial( mat_icon );
            surface.SetDrawColor( color_black );
            surface.DrawTexturedRect( icon_p, icon_p, icon_s, icon_s );
        end

        self.DepositPanel.Input.Entry = self.DepositPanel.Input:Add( "DTextEntry" );
        self.DepositPanel.Input.Entry:Dock( TOP );
        self.DepositPanel.Input.Entry:SetFont( "rpui.Fonts.AuctionsDefault" );
        self.DepositPanel.Input.Entry:SetPlaceholderText( translates.Get("Сумма пополнения") );
        self.DepositPanel.Input.Entry:SetDrawLanguageID( false );
        self.DepositPanel.Input.Entry:SetNumeric( true );
        self.DepositPanel.Input.Entry:SetUpdateOnType( true );
        self.DepositPanel.Input.Entry.OnValueChange = function( pnl, val )
            local caret, value = pnl:GetCaretPos(), string.gsub( val, "[" .. translates.Get("₽") .. "%s]", "" );

            local a = #value;
            value = string.gsub( value, "[%.%,%-]", "" );
            local b = #value;

            pnl:SetText( (#value > 0) and (value .. " " .. translates.Get("₽")) or "" );
            pnl:SetCaretPos( caret + (b-a) );
        end

        self.DepositPanel.Input.Entry.Paint = function( pnl, w, h )
            if #pnl:GetValue() <= 0 and not pnl:HasFocus() then
                draw.SimpleText( pnl:GetPlaceholderText(), pnl:GetFont(), 0, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                return
            end

            pnl:DrawTextEntryText( rpui.UIColors.Black, rpui.UIColors.Background, rpui.UIColors.Black );
        end

        self.DepositPanel.Buttons = {};

        local robo_mat = Material("rpui/donatemenu/robokassa", "smooth noclamp");
		local umoney_mat = Material("rpui/donatemenu/ukassa", "smooth noclamp");
		local paypal_mat = Material("rpui/donatemenu/paypal", "smooth noclamp");
        local tebex_mat = Material("rpui/donatemenu/tebex", "smooth noclamp");
        local xsolla_mat = Material("rpui/donatemenu/xsolla", "smooth noclamp");

        self.DepositPanel.Buttons[1] = self.DepositPanel:Add( DonateButton() );
        self.DepositPanel.Buttons[1].m_Material = robo_mat;
        self.DepositPanel.Buttons[1].DoClick = function( pnl )
            if rp.cfg.IsFrance then return end

            local amount = string.gsub( self.DepositPanel.Input.Entry:GetValue(), "[" .. translates.Get("₽") .. "%s]", "" );
            if #amount > 0 then
                gui.OpenURL( "https://shop.urf.im/page/robokassa?price=" .. amount .. "&sid=" .. LocalPlayer():SteamID64() .. "&s=" .. rp.cfg.ServerUID .. "#purchase" );
                return
            end

            rp.Notify( NOTIFY_ERROR, translates.Get("Введена неверная сумма") );
        end

        self.DepositPanel.Buttons[2] = self.DepositPanel:Add( DonateButton() );
        self.DepositPanel.Buttons[2].m_Material = umoney_mat;
        self.DepositPanel.Buttons[2].DoClick = function( pnl )
            if rp.cfg.IsFrance then return end

            local amount = string.gsub( self.DepositPanel.Input.Entry:GetValue(), "[" .. translates.Get("₽") .. "%s]", "" );
            if #amount > 0 then
                gui.OpenURL( "https://shop.urf.im/page/umoney?price=" .. amount .. "&sid=" .. LocalPlayer():SteamID64() .. "&s=" .. rp.cfg.ServerUID .. "#purchase" );
                return
            end

            rp.Notify( NOTIFY_ERROR, translates.Get("Введена неверная сумма") );
        end

        self.DepositPanel.Buttons[3] = self.DepositPanel:Add( DonateButton() );
        self.DepositPanel.Buttons[3].m_Material = xsolla_mat;
        self.DepositPanel.Buttons[3].DoClick = function( pnl )
            if rp.cfg.IsFrance then return end

            local amount = string.gsub( self.DepositPanel.Input.Entry:GetValue(), "[" .. translates.Get("₽") .. "%s]", "" );
            if #amount > 0 then
                gui.OpenURL( string.format("https://shop.urf.im/xsolla?sid=%s&m=points&v=%i&s=%s&l=%s", LocalPlayer():SteamID(), amount, rp.cfg.ServerUID, rp.cfg.IsFrance and "fr" or "ru") );
                return
            end

            rp.Notify( NOTIFY_ERROR, translates.Get("Введена неверная сумма") );
        end
    end

    self.Footer.Spacer = self.Footer:Add( "Panel" );
    self.Footer.Spacer:SetVisible( false );
    self.Footer.Spacer:SetWide( 0 );

    self.Content = self:Add( "Panel" );
    self.Content:Dock( FILL );

    self.Content.PerformLayout = function( this, w, h )
        this.Desc:SetWide( w * 0.375 );
    end

    self.Content.Help = self.Content:Add( "DButton" );
    self.Content.Help.Selected = false;
    self.Content.Help:SetFont( "rpui.Fonts.AuctionsLarge" );
    self.Content.Help:SetText( "?" );
    self.Content.Help:SetTextColor( color_white );
    self.Content.Help:SizeToContentsY( self.fl_Padding );
    self.Content.Help:SetWide( self.Content.Help:GetTall() );

    self.Content.Help.ShowHelp = function( this )
        this.Content = self:Add( "Panel" );
        this.Content:SetAlpha( 0 );

        local sx = this:LocalToScreen( this:GetWide() + self.fl_Padding );
        this.Content:SetX( self:ScreenToLocal(sx) );
        this.Content:AlphaTo( 255, 0.25 );
        this.Content:SetWide( self.fl_Padding * 36 );
        this.Content:DockPadding( self.fl_Padding * 3, self.fl_Padding, self.fl_Padding, self.fl_Padding );

        this.Content.PerformLayout = function( pnl, w, h )
            pnl:SizeToChildren( false, true );
        end

        this.Content.Paint = function( pnl, w, h )
            local p = math.floor( self.fl_Padding * 1.5 );

            if not pnl.m_poly then
                pnl.m_poly = { {x = 0, y = 0}, {x = p, y = 0}, {x = p, y = p} };
            end

            draw.NoTexture();

            surface.SetDrawColor( rpui.UIColors.Background );
            surface.DrawRect( p, 0, w - p, h );
            surface.DrawPoly( pnl.m_poly );
        end

        this.Content.Title = this.Content:Add( "DLabel" );
        this.Content.Title:Dock( TOP );
        this.Content.Title:DockMargin( 0, 0, 0, self.fl_Padding );
        this.Content.Title:SetFont( "rpui.Fonts.AuctionsMedium" );
        this.Content.Title:SetText( translates.Get("Правила аукциона:") );
        this.Content.Title:SetTextColor( color_white );

        this.Content.Text = this.Content:Add( "DLabel" );
        this.Content.Text:Dock( TOP );
        this.Content.Text:SetFont( "rpui.Fonts.AuctionsDefault" );
        this.Content.Text:SetText( self.s_Rules );
        this.Content.Text:SetTextColor( color_white );
        this.Content.Text:SetWrap( true );
        this.Content.Text:SetAutoStretchVertical( true );
    end

    self.Content.Help.HideHelp = function( this )
        if not IsValid( this.Content ) then
            return
        end

        this.Content:Stop();
        this.Content:AlphaTo( 0, 0.25, 0, function( anim, pnl )
            pnl:Remove();
        end );
    end

    self.Content.Help.Think = function( this )
        this.Selected = IsValid( this.Content );
    end

    self.Content.Help.DoClick = function( this, w, h )
        this[this.Selected and "HideHelp" or "ShowHelp"]( this );
    end

    self.Content.Help.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true;
    end

    self.Content.Title = self.Content:Add( "DLabel" );
    self.Content.Title:Dock( TOP );
    self.Content.Title:DockMargin( 0, 0, 0, self.fl_Padding * 0.5 );
    self.Content.Title:SetContentAlignment( 5 );
    self.Content.Title:SetFont( "rpui.Fonts.AuctionsHuge" );
    self.Content.Title:SetText( "upgrade_id" );
    self.Content.Title:SetTextColor( color_white );
    self.Content.Title:SizeToContentsY();

    self.Content.Desc = self.Content:Add( "DLabel" );
    self.Content.Desc:Dock( RIGHT );
    self.Content.Desc:DockMargin( self.fl_Padding, 0, 0, 0 );
    self.Content.Desc:SetFont( "rpui.Fonts.AuctionsMedium" );
    self.Content.Desc:SetText( "Upgrade description" );
    self.Content.Desc:SetTextColor( color_white );
    self.Content.Desc:SetWrap( true );
    self.Content.Desc:SetContentAlignment( 5 );

    self.Content.Visuals = self.Content:Add( "DModelPanel" );
    self.Content.Visuals:Dock( FILL );
    self.Content.Visuals:SetModel( "models/error.mdl" );
    self.Content.Visuals:SetMouseInputEnabled( false );
    self.Content.Visuals.a_Rotation = Angle( 0, 0, 0 );
    self.Content.Visuals.LayoutEntity = function( this, ent )
        local mins, maxs = ent:GetModelRenderBounds();

        local center = (maxs + mins) * 0.5;
        local radius = (ent:GetModelRadius() or 0) * 2;

        this.a_Rotation.yaw = this.a_Rotation.yaw + RealFrameTime() * 15;

        this:SetLookAt( center );
        this:SetCamPos( center - this.a_Rotation:Forward() * radius );

        return
    end

    self:SetAlpha( 0 );
    self:AlphaTo( 255, 0.25 );
end

function PANEL:GetLotID()
    return self.i_LotID or -1;
end

function PANEL:SetLotID( lot_id )
    local lot = auctions.lots:GetByID( lot_id );
    self.i_LotID = lot_id;
end

function PANEL:SetPrice( price )
    self.Footer.Amount.Content.Value.fl_Target = price;
end

function PANEL:SetTimeEnd( ts_end )
    self.Footer.Timeleft.Content.Value.i_TimestampEnd = ts_end;
end

function PANEL:SetUpgrade( upgrade_id )
    local upgrade = rp.shop.GetByUID( upgrade_id );

    if not upgrade then
        self.Content.Title:SetText( upgrade_id );
        self.Content.Desc:SetText( "ERROR! Unknown upgrade_id." );
        self.Content.Visuals:SetModel( "models/error.mdl" );
        return
    end

    self.Content.Title:SetText( upgrade:GetName() );
    self.Content.Desc:SetText( upgrade:GetDesc() );

    local mdl = upgrade:GetIcon() or "";
    self.Content.Visuals:SetModel( util.IsValidModel(mdl) and mdl or "models/items/hl2_gift.mdl" );
end

function PANEL:SetPlayerInfo( steamid64, name, server )
    local pnl = self.Footer.Player.Content;

    local empty = false;

    if #name < 1 then
        empty = true;
        name = translates.Get("Ставок нет");
        server = translates.Get("Будьте первым, кто сделает ставку!");
    end

    local p_avatar, p_name = pnl.Avatar, pnl.Information.Name;
    p_avatar:SetSteamID( steamid64, p_avatar:GetWide() );
    p_name:SetText( name );
    p_name:SizeToContents();

    if empty then
        if pnl.Avatar:IsVisible() then
            pnl.Avatar:SetVisible( false );
        end
    else
        if not pnl.Avatar:IsVisible() then
            pnl.Avatar:SetVisible( true );
        end

        local p_bid = self.Footer.Bid;
        p_bid.b_Winner = steamid64 == LocalPlayer():SteamID64();
        p_bid.b_NotEnough = nil;
        p_bid:SetText( translates.Get(p_bid.b_Winner and "ВАША СТАВКА ЛИДИРУЕТ" or "СДЕЛАТЬ СТАВКУ") );
        p_bid:SetMouseInputEnabled( not p_bid.b_Winner );
        p_bid:SizeToContentsX( self.fl_Padding * 4 );
    end

    if server then
        local p_desc = pnl.Information.Desc;
        p_desc:SetText( server );
        p_desc:SizeToContents();
    end
end

function PANEL:SetBettingActive( status )
    if status then
        self.Footer.Amount:SetVisible( true );
        self.Footer.Balance:SetVisible( true );
        self.Footer.Bid:SetVisible( true );
        self.Footer.Spacer:SetVisible( false );

        return
    end

    self.Footer.Amount:SetVisible( false );
    self.Footer.Balance:SetVisible( false );
    self.Footer.Bid:SetVisible( false );
    self.Footer.Spacer:SetVisible( true );
end

function PANEL:UpdateLotInfo( lot )
    if not lot then return end

    self.Footer:Stop();
    self.Footer:AlphaTo( 0, 0.1, 0, function( anim, pnl )
        if not IsValid( pnl ) then return end

        self:SetBettingActive( lot.active );
        self:SetTimeEnd( lot.ts_end );
        self:SetPlayerInfo( lot.steamid, lot.name, auctions.utils.GetServerName(lot.server_id) );
        self:SetPrice( lot.amount + lot.step );

        pnl:AlphaTo( 255, 0.1 );
    end );
end

function PANEL:SetAuctionLot( lot_id )
    local lot = auctions.lots:GetByID( lot_id );
    if not lot then return end

    self:SetLotID( lot.id );
    self:SetUpgrade( lot.upgrade_id );

    self:UpdateLotInfo( lot );

    hook.Add( "OnAuctionLotReceived", self, function( pnl, lot )
        if lot.id ~= pnl:GetLotID() then return end
        pnl:UpdateLotInfo( lot );
    end );
end

vgui.Register( "AuctionPanel", PANEL, "EditablePanel" );