-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_donatemenu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local surface = surface;
local draw = draw;
local math = math;
local net = net;
local table = table;
local total_donated;

if not rp.cfg.DisableRPUIMenues then
    net.Receive( "rp.CreditShop", function()
        local CreditShopData = {};

		if rp.cfg.IsFrance then
			total_donated = net.ReadUInt(16)
		end

        CreditShopData.ItemsCount       = net.ReadUInt(8);
        CreditShopData.DonateInProgress = net.ReadBool();

        CreditShopData.Categories = {};

        local ShopCategory_SALE = {
            Name     = translates and translates.Get("SALE") or "SALE",
            Upgrades = {},
        };

        if rp.cfg.PremiumConfig then
            local ShopCategory_PREMIUM = CreditShopData.Categories[ table.insert( CreditShopData.Categories, {
                Name     = translates and translates.Get("PREMIUM") or "PREMIUM",
                Upgrades = {},
            } )];
        else
            table.insert( CreditShopData.Categories, ShopCategory_SALE );
        end

        CreditShopData.Buyable    = {};
        CreditShopData.NotBuyable = {};
        CreditShopData.NotBuyableAltPrice = {};
        CreditShopData.CanRefund = {};

        local ShopTable = rp.shop.GetTable();

        for i = 1, CreditShopData.ItemsCount do
            local status = net.ReadUInt(2)
            local id = net.ReadUInt(8)

            if status == 0 then
                CreditShopData.Buyable[id] = net.ReadUInt(16);
            elseif status == 1 then
                CreditShopData.NotBuyable[id] = net.ReadString();
            elseif status == 2 then
                CreditShopData.NotBuyable[id] = {net.ReadString(), net.ReadUInt(16)};
            end

            if ShopTable[id].GetAltPrice(ShopTable[id]) then
                CreditShopData.NotBuyableAltPrice[id] = ShopTable[id].GetAltPrice(ShopTable[id]);
            end
        end

        local refund_count = net.ReadUInt(8);

        if refund_count > 0 then
            for i = 1, refund_count do
                CreditShopData.CanRefund[net.ReadUInt(8)] = true;
            end
        end

        for k, v in pairs( CreditShopData.Buyable ) do
            local ShopItem = ShopTable[k];
            if not ShopItem then return end;

            if ShopItem.Discount ~= 0 or rp.GetDiscount() ~= 0 then
                CreditShopData.Buyable[k] = {
                    Upgrade   = ShopItem,
                    Price     = v,
                    IsBuyable = true,
                };
            else
                CreditShopData.Buyable[k] = {
                    Upgrade   = ShopItem,
                    Price     = v,
                    IsBuyable = true,
                };

                if ShopItem:GetAltPrice() then
                    CreditShopData.Buyable[k].AltPrice = ShopItem:GetAltPrice();
                end
            end

            local ShopItemCategory;

            if ShopItem:GetDiscount() ~= 0 or ShopItem:GetAltPrice() then
                table.insert( ShopCategory_SALE.Upgrades, CreditShopData.Buyable[k] );
            end

            for k1, category1 in pairs( CreditShopData.Categories ) do
                if category1.Name == ShopItem:GetCat() then
                    ShopItemCategory = category1;
                    break;
                end
            end

            if ShopItem:GetCat() ~= (translates and translates.Get("SALE") or "SALE") then
                ShopItemCategory = ShopItemCategory or CreditShopData.Categories[table.insert( CreditShopData.Categories, {
                    Name     = ShopItem:GetCat(),
                    Upgrades = {},
                } )];

                table.insert( ShopItemCategory.Upgrades, CreditShopData.Buyable[k] );
            end
        end

        for k2, v2 in pairs( CreditShopData.NotBuyable ) do
            local ShopItem = ShopTable[k2];
            if not ShopItem then return end;

            local data = istable(v2) and v2 or {v2}

            CreditShopData.NotBuyable[k2] = {
                Upgrade   = ShopItem,
                Reason    = data[1],
                Price    = data[2],
                IsBuyable = false,
            };

            local ShopItemCategory;

            if ShopItem:GetDiscount() ~= 0 or ShopItem:GetAltPrice() then
                table.insert( ShopCategory_SALE.Upgrades, CreditShopData.NotBuyable[k2] );
            end

            for k3, category3 in pairs( CreditShopData.Categories ) do
                if category3.Name == ShopItem:GetCat() then
                    ShopItemCategory = category3;
                    break;
                end
            end

            if ShopItem:GetCat() ~= (translates and translates.Get("SALE") or "SALE") then
                ShopItemCategory = ShopItemCategory or CreditShopData.Categories[table.insert( CreditShopData.Categories, {
                    Name     = ShopItem:GetCat(),
                    Upgrades = {},
                } )];

                table.insert( ShopItemCategory.Upgrades, CreditShopData.NotBuyable[k2] );
            end
        end

		table.insert(CreditShopData.Categories, {
                Name     = translates and translates.Get("КЕЙСЫ") or "КЕЙСЫ",
                Upgrades = {},
         })

        if rp.cfg.PremiumConfig then
            table.insert( CreditShopData.Categories, ShopCategory_SALE );
        end

        local CategoriesMap = {};
        for k4, category4 in pairs( CreditShopData.Categories ) do
            CategoriesMap[k4] = category4.Name;
        end

        if IsValid(rpui.DonateMenu) then rpui.DonateMenu.Remove(rpui.DonateMenu); end

        rpui.DonateMenu = vgui.Create( "rpui.DonateMenu", vgui.GetWorldPanel() );
        local don_menu = rpui.DonateMenu;

        don_menu.OpenedAt = CurTime()

        don_menu:SetSize( ScrW(), ScrH() );
        don_menu:Center();
        don_menu:SetData( CreditShopData );
        don_menu:SetCategories( CategoriesMap );
        don_menu:MakePopup();
    end );
end


local disabledWeps = {};
hook.Add( "OnEntityCreated", "disabledWeps", function( ply )
    if ply == LocalPlayer() then
        local str_data = LocalPlayer():GetPData( "urf_disableddonateweps_" .. util.CRC(game.GetIPAddress()), "" );
        if not str_data then return end

        local data = string.Explode( ";", str_data );

        for _, wep in pairs(data) do
            disabledWeps[wep] = true
        end

        net.Start( "rp.CreditShop.DisableWeapon" );
            net.WriteString( table.concat(table.GetKeys(disabledWeps),";") );
        net.SendToServer();

        hook.Remove( "OnEntityCreated", "disabledWeps" );
    end
end );


local PANEL = {};

function PANEL:RebuildFonts( frameW, frameH )
    surface.CreateFont( "rpui.Fonts.DonateMenu.Title", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = math.ceil(frameH * 0.06),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.DiscountNotifier", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = math.ceil(frameH * 0.03),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.Small", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = math.ceil(frameH * 0.025),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.MenuButton", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = math.ceil(frameH * 0.03),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.MenuButtonBold", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = math.ceil(frameH * 0.0325),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.MenuButtonBigBold", {
        font     = "Montserrat",
        extended = true,
        weight = 700,
        size     = math.ceil(frameH * 0.07),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.MenuButtonBigBold2", {
        font     = "Montserrat",
        extended = true,
        weight = 700,
        size     = math.ceil(frameH * 0.055),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.MenuButtonBigBold3", {
        font     = "Montserrat",
        extended = true,
        weight = 700,
        size     = math.ceil(frameH * 0.038),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.ItemButton", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = math.ceil(frameH * 0.023),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.ItemButtonBig", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = math.ceil(frameH * 0.04),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.ItemButtonBold", {
        font     = "Montserrat",
        extended = true,
        weight = 700,
        size     = math.ceil(frameH * 0.025),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.ItemMedium", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = math.ceil(frameH * 0.035),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.ItemSmall", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = math.ceil(frameH * 0.022),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.PurchaseButton", {
        font     = "Montserrat",
        extended = true,
        weight = 700,
        size     = math.ceil(frameH * 0.0325),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.DepositButton", {
        font     = "Montserrat",
        extended = true,
        weight = 700,
        size     = math.ceil(frameH * 0.0285),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.FlirtQuote", {
        font     = "Montserrat",
        extended = true,
        weight = 700,
        size     = math.ceil(frameH * 0.02),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.FlirtQuote2", {
        font     = "Montserrat",
        extended = true,
        weight = 600,
        size     = math.ceil(frameH * 0.02),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.StatusTriangle", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = math.ceil(frameH * 0.015),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.DonateStats", {
        font     = "Montserrat",
        extended = true,
        weight = 700,
        size     = math.ceil(frameH * 0.0225),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.DonateStatsSmall", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = math.ceil(frameH * 0.02),
    } );

    surface.CreateFont( "rpui.Fonts.DonateMenu.Tooltip", {
        font     = "Montserrat",
        extended = true,
        weight = 500,
        size     = math.max(math.ceil(frameH * 0.0175), 14),
    } );
end

PANEL.FlirtQuotes = {
    translates.Get("Давай, нажми купить!"),
    translates.Get("Купи меня, давай, купи!"),
    translates.Get("Ну чего ты ждешь? Давай покупай!"),
    translates.Get("Я знаю ты хочешь ..."),

    translates.Get("Garry's Mod — значит urf.im"),
};

PANEL.QuoteElements = {};

rpui.UIColors.White = Color(255, 255, 255, 255)
local my_new_color = rpui.UIColors.White
local my_new_color2 = rpui.UIColors.BackgroundGold
local my_new_color3 = rpui.UIColors.Gold

PANEL.ParallaxElements = {
    {
        x      = 0,
        y      = 0,
        color  = my_new_color,
        mat    = Material("rpui/donatemenu/sparkles"),
        range  = -0.5,
        speed  = 1,
    },

    {
        x      = 0,
        y      = 0,
        color  = my_new_color,
        mat    = Material("rpui/donatemenu/flash_bottom"),
        range  = 0,
        speed  = 0,
    },

    {
        x      = 0,
        y      = 0,
        color  = my_new_color,
        mat    = Material("rpui/donatemenu/flash_middle"),
        range  = 0,
        speed  = 0,
    },

    {
        x      = 0,
        y      = 0,
        color  = my_new_color,
        mat    = Material("rpui/donatemenu/flash_top"),
        range  = 0,
        speed  = 0,
    },

    {
        x      = 0,
        y      = 0,
        sizew  = 1,
        sizeh  = 1,
        color  = my_new_color,
        mat    = Material("rpui/donatemenu/shards"),
        range  = 0.5,
        speed  = 1,
    },
}

local HSVToColor = HSVToColor
local hue = SysTime()*0.1 % 360
local RainbowColor = HSVToColor(hue, 0.77, 0.77)
local RainbowRotate = HSLToColor(hue, 0.70, 0.65)
local DisabledColor = HSVToColor(hue, 0.10, 0.50);
local DisabledRotate = HSVToColor(hue, 0.10, 0.45);

function PANEL:Paint( w, h )
    surface.SetDrawColor( rpui.UIColors.Black );
    surface.DrawRect( 0, 0, w, h );

    local mX, mY = self:LocalCursorPos();

    mX = mX - 0.5 * w;
    mY = mY - 0.5 * h;

    hue = SysTime()*0.1 % 360
    RainbowColor = HSVToColor(hue, 0.77, 0.77)
    RainbowRotate = HSLToColor(hue, 0.90, 0.40)

    for _, e in pairs( self.ParallaxElements ) do
        e.x = Lerp( 0.005 * e.speed, e.x, mX * e.range );
        e.y = Lerp( 0.005 * e.speed, e.y, mY * e.range );

        local sw = w * (e.sizew or 1);
        local sh = h * (e.sizeh or 1);

        surface.SetDrawColor(HSVToColor(hue, 0.8, 0.73))
        surface.SetMaterial(e.mat);
        surface.DrawTexturedRect(e.x + w * 0.5 - sw * 0.5, e.y + h * 0.5 - sh * 0.5, sw, sh);
    end

    if self.OpenedAt and self.OpenedAt + 120 < CurTime() then
        if #self.QuoteElements < 6 then
            local QuoteElement = {
                x = math.Rand(0.1,0.9),
                y = math.Rand(0.1,0.9),
                str = self.FlirtQuotes[math.random(1,#self.FlirtQuotes)],
                velx = math.Rand(-1,1),
                vely = math.Rand(-1,1),
                alpha = 0,
                lifetime = SysTime() + math.random(3,10),
            };

            table.insert( self.QuoteElements, QuoteElement );
        end

        for k5, e5 in ipairs( self.QuoteElements ) do
            if (e5.lifetime - SysTime()) > 1 then
                e5.alpha = math.Approach( e5.alpha, 64, 0.25 );
            else
                e5.alpha = math.Approach( e5.alpha, 0, 0.5 );
            end

            e5.x = e5.x + e5.velx * 0.05 * FrameTime();
            e5.y = e5.y + e5.vely * 0.05 * FrameTime();

            e5.velx = e5.velx + math.Rand(-0.01,0.01);
            e5.vely = e5.vely + math.Rand(-0.01,0.01);

            draw.SimpleText( e5.str, "rpui.Fonts.DonateMenu.FlirtQuote", w * e5.x, h * e5.y, Color(255,255,255,e5.alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

            if e5.lifetime < SysTime() then
                table.remove( self.QuoteElements, k5 );
            end
        end
    end
end


TOOLTIP_OFFSET_LEFT = 0.1 * 1;
TOOLTIP_OFFSET_CENTER = 0.5 * 1;
function PANEL:RegisterTooltip( panel, textfunc, offset, parentwidth, posfunc )
    if not self.Tooltip then
        self.Tooltip = vgui.Create( "Panel", self );
        local tooltip = self.Tooltip;

        tooltip:SetMouseInputEnabled( false );
        tooltip:SetAlpha( 0 );
        tooltip.ArrowHeight = 0.01 * self.frameH;
        tooltip:DockPadding( self.frameW * 0.0075, self.frameH * 0.005, self.frameW * 0.0075, self.frameH * 0.005 + self.Tooltip.ArrowHeight );

        self.Tooltip.Label = vgui.Create( "DLabel", self.Tooltip );
        local label = self.Tooltip.Label;

        label:Dock( TOP );
        label:SetWrap( true );
        label:SetAutoStretchVertical( true );
        label:SetFont( "rpui.Fonts.DonateMenu.Tooltip" );
        label:SetTextColor( rpui.UIColors.White );
        label:SetText( "" );

        self.Tooltip.TooltipOffset = -1;
        self.Tooltip.IsActive      = false;

        self.Tooltip.Paint = function( this, w, h )
            if string.Trim(this.Label.GetText(this.Label)) ~= "" then
                surface.SetDrawColor( rpui.UIColors.Tooltip );
                surface.DrawRect( 0, 0, w, h - this.ArrowHeight );

                if this.BakedPoly then
                    draw.NoTexture();
                    surface.DrawPoly( this.BakedPoly );
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
                        surface.SetFont( this.Label.GetFont(this.Label) );
                        local text_w, text_h = surface.GetTextSize( this.Label.GetText(this.Label) );
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
                            x, y = this.ActivePanel.TooltipPosFunc(this.ActivePanel);
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


function PANEL:CreateDepositPanel( pnl, alignTop )
    if not self.DepositPanel then
        self.DepositPanel = vgui.Create( "Panel", self );
        local deposit = self.DepositPanel;

        deposit:SetWide( self.Header.Balance and 1.2 * self.Header.Balance.GetWide(self.Header.Balance) or self.frameW * 0.15 );
        deposit:SetAlpha( 1 );
        deposit.RetardAlert = 0;
        deposit.Close = function( this )
            this.Closing = true;
            this:Stop();
            this:AlphaTo( 0, 0.25, 0, function()
                if IsValid( this ) then this:Remove(); end
                self.DepositPanel = nil;
                self.DepositPanelOpener = nil;
            end );
        end
        self.DepositPanel.Think = function( this )
            if input.IsMouseDown(MOUSE_LEFT) and self:IsChildHovered() and not this.Closing then
                if (not this:IsHovered() and not this:IsChildHovered()) then
                    this:Close();
                end
            end

            if this.RetardAlert > 0 then
                this.RetardAlert = math.Approach( this.RetardAlert, 0, FrameTime() );
            end
        end

        surface.CreateFont( "DepositPanel.MediumBold", {
            font     = "Montserrat",
            size     = self.frameH * 0.025,
            extended = true,
        } );

        surface.CreateFont( "DepositPanel.Small", {
            font     = "Montserrat",
            size     = self.frameH * 0.0175,
            extended = true,
        } );

        surface.CreateFont( "DepositPanel.InputBold", {
            font      = "Montserrat",
            size      = self.frameH * 0.0225,
            extended  = true,
        } );

        self.DepositPanel.TopArrow = vgui.Create( "Panel", self.DepositPanel );
        local top_arr = self.DepositPanel.TopArrow;

        top_arr:Dock( TOP );
        top_arr:SetTall( 0 );
        top_arr.Paint = function( this, w, h )
            draw.NoTexture();
            surface.SetDrawColor( Color(0,0,0,200) );
            surface.DrawPoly( {{x = w, y = 0}, {x = w, y = h}, {x = w-h, y = h}} );
        end

        self.DepositPanel.Foreground = vgui.Create( "Panel", self.DepositPanel );
        self.DepositPanel.Foreground.Dock( self.DepositPanel.Foreground, TOP );
        self.DepositPanel.Foreground.Paint = function( this, w, h )
            surface.SetDrawColor( Color(0,0,0,200) );
            surface.DrawRect( 0, 0, w, h );
        end

        self.DepositPanel.BottomArrow = vgui.Create( "Panel", self.DepositPanel );
        local bot_arr = self.DepositPanel.BottomArrow;

        bot_arr:Dock( TOP );
        bot_arr:SetTall( 0 );
        bot_arr.Paint = function( this, w, h )
            draw.NoTexture();
            surface.SetDrawColor( Color(0,0,0,200) );
            surface.DrawPoly( {{x = w-h, y = 0}, {x = w, y = 0}, {x = w, y = h}} );
        end

        self.DepositPanel.LeftColumn = vgui.Create( "Panel", self.DepositPanel.Foreground );
        self.DepositPanel.LeftColumn.DockPadding( self.DepositPanel.LeftColumn, self.innerPadding * 2, self.innerPadding * 2, self.innerPadding * 2, self.innerPadding * 2 );
        self.DepositPanel.LeftColumn.SetWide( self.DepositPanel.LeftColumn, self.DepositPanel.GetWide(self.DepositPanel) );

        local right_col = self.DepositPanel.LeftColumn

        self.DepositPanel.DepositContainer = vgui.Create( "Panel", right_col );
        local dep_cont = self.DepositPanel.DepositContainer;

        dep_cont:Dock( TOP );
        dep_cont:DockMargin( 0, 0, 0, self.innerPadding * 2 - 4 );
        dep_cont:SetTall( self.innerPadding * 10.5 + 4 );

        self.DepositPanel.DepositContainer.InputContainer = vgui.Create( "Panel", self.DepositPanel.DepositContainer );
        local inp_cont = self.DepositPanel.DepositContainer.InputContainer;

        inp_cont:Dock( TOP );
        inp_cont:DockMargin( 0, 0, 0, self.innerPadding );
        inp_cont:DockPadding( 0, self.innerPadding * 0.5, 0, self.innerPadding * 0.5 );
        inp_cont:SetTall( self.frameH * 0.04 );
        inp_cont:InvalidateParent( true );
        inp_cont.Paint = function( this, w, h )
            surface.SetDrawColor( rpui.UIColors.White );
            surface.DrawRect( 0, 0, w, h );
        end
        self.DepositPanel.DepositContainer.InputContainer.PaintOver = function( this, w, h )
            if not IsValid( self.DepositPanel ) then return end
            -- HERE!!!
            local shakeAmount = self.DepositPanel.RetardAlert;
            this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();

            if shakeAmount > 0 then
                rpui.DrawStencilBorder( this, 0, 0, w, h, 0.06, rpui.UIColors.Pink, rpui.UIColors.Pink, self.DepositPanel.GetAlpha(self.DepositPanel) / 255 );
            else
                rpui.DrawStencilBorder( this, 0, 0, w, h, 0.06, RainbowColor, RainbowRotate, self.DepositPanel.GetAlpha(self.DepositPanel) / 255 );
            end
        end


        self.DepositPanel.DepositContainer.DescriptionButton = vgui.Create( "DButton", self.DepositPanel.DepositContainer );
        local dep_btn = self.DepositPanel.DepositContainer.DescriptionButton

        dep_btn.Paint = function( this, w, h )

        end
        dep_btn:SetText('')
        dep_btn.DoClick = function()
            gui.OpenURL( rp.cfg.ConsultUrl );
        end


        self.DepositPanel.DepositContainer.DescriptionT = vgui.Create( "DLabel", self.DepositPanel.DepositContainer );
        local dep_desc = self.DepositPanel.DepositContainer.DescriptionT;

        dep_desc:Dock( TOP );
        dep_desc:DockMargin( 0, self.innerPadding * 0.3, 0, -self.innerPadding * 0.2 );
        dep_desc:SetContentAlignment( 5 );
        dep_desc:SetFont( "DepositPanel.Small" );
        dep_desc:SetTextColor( rpui.UIColors.White );
        dep_desc:SetText( rp.cfg.DonateInfo and rp.cfg.DonateInfo[1] or translates.Get("Введите сумму пополнения в") );
        dep_desc:SizeToContentsY();
        dep_desc.Paint = function( this, w, h )
            if IsValid(self.DepositPanel) then
                local shakeAmount = 0;
                local shakeOffset = 0;

                if shakeAmount > 0 then
                    shakeOffset = math.sin( SysTime() * 50 ) * self.innerPadding * shakeAmount;
                end

                if this.UpdateInfo then
                    this:SetText((#this.UpdateInfo > 0) and "" or (rp.cfg.DonateInfo and rp.cfg.DonateInfo[1]) or translates.Get("Введите сумму пополнения в") )
                    this.UpdateInfo = nil
                end

                draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5 + shakeOffset, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end

            return true;
        end

        self.DepositPanel.DepositContainer.DescriptionB = vgui.Create( "DLabel", self.DepositPanel.DepositContainer );
        local dep_desc2 = self.DepositPanel.DepositContainer.DescriptionB;

        dep_desc2:Dock( TOP );
        dep_desc2:DockMargin( 0, 0, 0, -self.innerPadding * 0.2 );
        dep_desc2:SetContentAlignment( 5 );
        dep_desc2:SetFont( "DepositPanel.Small" );
        dep_desc2:SetTextColor( rpui.UIColors.White );
        dep_desc2:SetText( rp.cfg.DonateInfo and rp.cfg.DonateInfo[2] or translates.Get("форму выше.") );
        dep_desc2:SizeToContentsY();
        dep_desc2.Paint = function( this, w, h )
            if IsValid(self.DepositPanel) then
                local shakeAmount = 0;
                local shakeOffset = 0;

                if shakeAmount > 0 then
                    shakeOffset = math.sin( SysTime() * 50 ) * self.innerPadding * shakeAmount;
                end

                if this.UpdateInfo then
                    this:SetText((#this.UpdateInfo > 0) and ("Vous recevrez " .. this.UpdateInfo .. " crédits") or (rp.cfg.DonateInfo and rp.cfg.DonateInfo[2]) or translates.Get("форму выше.") )
                    this.UpdateInfo = nil
                end

                draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5 + shakeOffset, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end

            return true;
        end

        self.DepositPanel.DepositContainer.DescriptionG = vgui.Create( "DLabel", self.DepositPanel.DepositContainer );
        local dep_desc3 = self.DepositPanel.DepositContainer.DescriptionG;

        dep_desc3:Dock( TOP );
        dep_desc3:SetContentAlignment( 5 );
        dep_desc3:DockMargin( 0, 0, 0, -self.innerPadding * 0.1 );
        dep_desc3:SetFont( "DepositPanel.Small" );
        dep_desc3:SetTextColor( rpui.UIColors.White );
        dep_desc3:SetText( rp.cfg.DonateInfo and rp.cfg.DonateInfo[3] or "" );
        dep_desc3:SizeToContentsY();
        dep_desc3.Paint = function( this, w, h )
            if IsValid(self.DepositPanel) then
                local shakeAmount = 0;
                local shakeOffset = 0;

                if shakeAmount > 0 then
                    shakeOffset = math.sin( SysTime() * 50 ) * self.innerPadding * shakeAmount;
                end

                if this.UpdateInfo then
                    this:SetText((#this.UpdateInfo > 0) and "" or (rp.cfg.DonateInfo and rp.cfg.DonateInfo[3]) or "" )
                    this.UpdateInfo = nil
                end

                draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5 + shakeOffset, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end

            return true;
        end

        self.DepositPanel.DepositContainer.Delimiter = vgui.Create( "DPanel", self.DepositPanel.DepositContainer );
        local dep_delimiter = self.DepositPanel.DepositContainer.Delimiter;

        dep_delimiter:Dock( TOP );
        dep_delimiter:DockMargin( 0, self.innerPadding * 0.7, 0, 0 );
        dep_delimiter:SetTall(2)
        dep_delimiter.Paint = function( this, w, h )
            surface.SetDrawColor(RainbowColor)
			surface.DrawRect(0, 0, w, h)
        end

        timer.Simple(0, function()
            if IsValid(dep_btn) and IsValid(self) then
                dep_btn:SetPos(dep_desc:GetPos())
                dep_btn:SetSize(self.frameW * 0.35, dep_desc:GetTall() + dep_desc2:GetTall() + dep_desc3:GetTall() + 8)
            end
        end)

        self.DepositPanel.DepositContainer.InputContainer.Icon = vgui.Create( "Panel", self.DepositPanel.DepositContainer.InputContainer );
        local dep_icon = self.DepositPanel.DepositContainer.InputContainer.Icon;

        dep_icon:Dock( LEFT );
        dep_icon:DockMargin( self.innerPadding, 0, self.innerPadding, 0 );
        dep_icon:InvalidateParent( true );
        dep_icon:SetWide( self.DepositPanel.DepositContainer.InputContainer.Icon.GetTall(self.DepositPanel.DepositContainer.InputContainer.Icon) );
        dep_icon.Material = Material( "rpui/donatemenu/money" );
        dep_icon.Paint = function( this, w, h )
            local shakeAmount = 0;
            if IsValid( self.DepositPanel ) then
                shakeAmount = self.DepositPanel.RetardAlert;
            end

            surface.SetDrawColor( shakeAmount > 0 and rpui.UIColors.Pink or rpui.UIColors.Black );
            surface.SetMaterial( this.Material );
            surface.DrawTexturedRect( 0, 0, w, h );
        end

        self.DepositPanel.DepositContainer.InputContainer.Input = vgui.Create( "DTextEntry", self.DepositPanel.DepositContainer.InputContainer );
        local dep_inp = self.DepositPanel.DepositContainer.InputContainer.Input;

        dep_inp:Dock( FILL );
        dep_inp:DockMargin( 0, 0, self.innerPadding * 0.5, 0 );
        dep_inp:SetDrawLanguageID( false );
        dep_inp:SetNumeric( true );
        dep_inp:SetFont( "DepositPanel.InputBold" );
        dep_inp:SetPlaceholderText( translates.Get("Сумма пополнения") );
        dep_inp:SetUpdateOnType( true );
        dep_inp.OnValueChange = function( this, value1 )
            local caret, value = this:GetCaretPos(), string.gsub( value1, "[" .. translates.Get("₽") .. "%s]", "" );

            local a = #value;
            value = string.gsub( value, "[%.%,%-]", "" );
            local b = #value;

            local mult = (rp.GetDonateMultiplayer and rp.GetDonateMultiplayer() or 0)
            local personal = LocalPlayer().GetPersonalDonateMultiplayer and LocalPlayer():GetPersonalDonateMultiplayer() or 0
            local is_personal = false
            if personal > mult then
                mult = personal
                is_personal = true
            end

			local function check_present_case()
				local case_present = nw.GetGlobal('donate_case_present') or '[]'
				case_present = util.JSONToTable(case_present)

				if case_present and case_present.time_until and case_present.time_until > os.time() then
					local user_input = tonumber( value1:match('%d[%d.,]*') )

					if user_input and case_present.amount_until and case_present.amount_until <= user_input then
						self.SetMultiplayerText(translates.Get("Вы получите %s", rp.lootbox.Map[case_present.present_id].name), translates.Get("благодаря бонусу на пополнение."))
					else
						self.SetMultiplayerText("", "")
					end
				else
					self.SetMultiplayerText("", "")
				end
			end

            local CT = os.time()
            if mult > 1 and (is_personal and LocalPlayer():GetPersonalDonateMultiplayerTime() > CT or rp.GetDonateMultiplayerTime() > CT) then
                local user_input = tonumber( value1:match('%d[%d.,]*') )

                if user_input then
                    local min = rp.GetDonateMultiplayerMinimum()
                    if min > 0 then
                        if user_input >= min then
                            self.SetMultiplayerText(translates.Get("Вы получите %s рублей", user_input * mult), translates.Get("благодаря бонусу на пополнение."))
                        else
                            check_present_case()
                        end
                    else
                        self.SetMultiplayerText(translates.Get("Вы получите %s рублей", user_input * mult), translates.Get("благодаря бонусу на пополнение."))
                    end
                else
                    check_present_case()
                end
            else
                check_present_case()
            end

            if rp.cfg.DonateCustomDescription then
                dep_desc.UpdateInfo = value
                dep_desc2.UpdateInfo = value
                dep_desc3.UpdateInfo = value
                self.DepositPanel.MoneyDeposit.UpdateInfo = value
            end

            this:SetText( (#value > 0) and (value .. " " .. translates.Get("₽")) or "" );
            this:SetCaretPos( caret + (b-a) );
        end
        self.DepositPanel.DepositContainer.InputContainer.Input.Paint = function( this, w, h )
            if #this:GetValue() <= 0 and !this:HasFocus() then
                local shakeAmount = 0;
                local shakeOffset = 0;

                if IsValid( self.DepositPanel ) then
                    shakeAmount = self.DepositPanel.RetardAlert;

                    if shakeAmount > 0 then
                        shakeOffset = math.sin( SysTime() * 50 ) * self.innerPadding * shakeAmount;
                    end
                end

                local oldClipping = DisableClipping( true );
                    draw.SimpleText( this:GetPlaceholderText(), this:GetFont(), shakeOffset, h * 0.5, shakeAmount > 0 and rpui.UIColors.Pink or rpui.UIColors.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                DisableClipping( oldClipping );
            else
                this:DrawTextEntryText( rpui.UIColors.Black, rpui.UIColors.Black, rpui.UIColors.Black );
            end
        end

		local robo_mat = Material("rpui/donatemenu/robokassa", "smooth noclamp");
		local umoney_mat = Material("rpui/donatemenu/ukassa", "smooth noclamp");
		local paypal_mat = Material("rpui/donatemenu/paypal", "smooth noclamp");
        local tebex_mat = Material("rpui/donatemenu/tebex", "smooth noclamp");
        local xsolla_mat = Material("rpui/donatemenu/xsolla", "smooth noclamp");

		local robo_desc = { "Банковская карта, QIWI", "" }
		local umoney_desc = { "Сбербанк Онлайн, Webmoney", "Альфа-Клик, Тинькофф" }
		local paypal_desc = { "Оплата через PayPal", "(временно отключена из-за санкций)" }
        local tebex_desc = { "Банковская карта, PayPal", "(Для оплаты за пределами РФ)" }
        local xsolla_desc = { "Банковская карта, PayPal", "(Для оплаты за пределами РФ)" }

        local isForeign = rp.cfg.IsFrance or rp.cfg.IsUkraine;

        if isForeign then
            --[[
            self.DepositPanel.XsollaDeposit = vgui.Create( "DButton", right_col );
            self.DepositPanel.XsollaDeposit:Dock( TOP );
            self.DepositPanel.XsollaDeposit:SetFont( "DepositPanel.MediumBold" );
            self.DepositPanel.XsollaDeposit:SetText( "" );
            self.DepositPanel.XsollaDeposit:SizeToContentsY( self.innerPadding * 2 );
            self.DepositPanel.XsollaDeposit:DockMargin( 0, self.innerPadding * 0.4, 0, 0 );
            self.DepositPanel.XsollaDeposit.Think = function( this )
                if this.Timeout and (this.Timeout < SysTime()) then
                    this:SetEnabled( true );
                    this.Timeout = false;
                end
            end
            self.DepositPanel.XsollaDeposit.Paint = function( this, w, h )
                if not IsValid( self.DepositPanel ) then return end
                this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();
                local distsize  = math.sqrt( w*w + h*h );

                surface.SetAlphaMultiplier( self.DepositPanel.GetAlpha(self.DepositPanel) / 255 );
                    surface.SetDrawColor( RainbowColor );
                    surface.DrawRect( 0, 0, w, h );

                    surface.SetMaterial( rpui.GradientMat );
                    surface.SetDrawColor( RainbowRotate );
                    surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

                    local img_width = 0.9 * w;

                    surface.SetDrawColor( color_white );
                    surface.SetMaterial( xsolla_mat )
                    surface.DrawTexturedRect( w * 0.05 - 1, (h - 0.125 * img_width) * 0.5 + 1, img_width, 0.125 * img_width );

                surface.SetAlphaMultiplier( 1 );

                return true
            end
            self.DepositPanel.XsollaDeposit.DoClick = function( this )
                local amount = string.gsub( self.DepositPanel.DepositContainer.InputContainer.Input:GetValue(), "[" .. translates.Get("₽") .. "%s]", "" );

                if #amount > 0 then
                    if tonumber(amount) < 10 or tonumber(amount) < 20 and total_donated and total_donated > 0 then
                        return rp.Notify(NOTIFY_ERROR, translates.Get("Сумма доната не может быть меньше #€"), total_donated and total_donated > 0 and 2 or 1)
                    end
                else
                    rp.Notify( NOTIFY_ERROR, translates.Get("Введена неверная сумма") );
                    return
                end

                local donation = donations.get( "points" );
                donations.getMethodByName("xsolla").onClick( donations.getMethodByName("xsolla"), donation, nil, amount );
                this.Timeout = SysTime() + 5;
                this:SetEnabled( false );
            end

            self.DepositPanel.XsollaDesc1 = vgui.Create( "DLabel", right_col );
            self.DepositPanel.XsollaDesc1:Dock(TOP);
            self.DepositPanel.XsollaDesc1:SetContentAlignment( 5 );
            self.DepositPanel.XsollaDesc1:DockMargin(0, self.innerPadding * 0.1, 0, 0)
            self.DepositPanel.XsollaDesc1:SetFont("DepositPanel.Small");
            self.DepositPanel.XsollaDesc1:SetTextColor( rpui.UIColors.White );
            self.DepositPanel.XsollaDesc1:SetText( translates.Get(xsolla_desc[1]) );

            self.DepositPanel.XsollaDesc2 = vgui.Create( "DLabel", right_col );
            self.DepositPanel.XsollaDesc2:Dock(TOP);
            self.DepositPanel.XsollaDesc2:SetContentAlignment( 5 );
            self.DepositPanel.XsollaDesc2:DockMargin(0, -self.innerPadding * 0.7, 0, 0)
            self.DepositPanel.XsollaDesc2:SetFont("DepositPanel.Small");
            self.DepositPanel.XsollaDesc2:SetTextColor( rpui.UIColors.White );
            self.DepositPanel.XsollaDesc2:SetText( translates.Get(xsolla_desc[2]) );
            ]]--
        end

        self.DepositPanel.MoneyDeposit3 = vgui.Create( "DButton", right_col );
        self.DepositPanel.MoneyDeposit3:Dock( TOP );
        self.DepositPanel.MoneyDeposit3:SetFont( "DepositPanel.MediumBold" );
        self.DepositPanel.MoneyDeposit3:SetText( "" );
        self.DepositPanel.MoneyDeposit3:SizeToContentsY( self.innerPadding * 2 );
        self.DepositPanel.MoneyDeposit3:DockMargin( 0, self.innerPadding * 0.0, 0, 0 );
        self.DepositPanel.MoneyDeposit3.Think = function( this )
            if this.Timeout and (this.Timeout < SysTime()) then
                this:SetEnabled( true );
                this.Timeout = false;
            end
        end
        self.DepositPanel.MoneyDeposit3.Paint = function( this, w, h )
            if not IsValid( self.DepositPanel ) then return end
            this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();
            local distsize  = math.sqrt( w * w + h * h );

            surface.SetAlphaMultiplier( self.DepositPanel.GetAlpha(self.DepositPanel) / 255 );
                surface.SetDrawColor( RainbowColor );
                surface.DrawRect( 0, 0, w, h );

                surface.SetMaterial( rpui.GradientMat );
                surface.SetDrawColor( RainbowRotate );
                surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, this.rotAngle or 0 );

                local img_width = 0.9 * w;

                surface.SetDrawColor( color_white );
                surface.SetMaterial( xsolla_mat )
                surface.DrawTexturedRect( w * 0.05 - 1, (h - 0.125 * img_width) * 0.5 + 1, img_width, 0.125 * img_width );

            surface.SetAlphaMultiplier( 1 );

            return true
        end
        self.DepositPanel.MoneyDeposit3.DoClick = function( this )
            self.DepositPanel.RetardAlert = 1;

            local amount = string.gsub(self.DepositPanel.DepositContainer.InputContainer.Input.GetValue(self.DepositPanel.DepositContainer.InputContainer.Input), "[" .. translates.Get("₽") .. "%s]", "");
            if #amount > 0 then
                gui.OpenURL( string.format("https://shop.urf.im/xsolla?sid=%s&m=points&v=%i&s=%s&l=%s", LocalPlayer():SteamID(), amount, rp.cfg.ServerUID, rp.cfg.IsFrance and "fr" or "ru") );

                this.Timeout = SysTime() + 5;
                this:SetEnabled( false );
            else
                self.DepositPanel.RetardAlert = 1;
            end
        end

        self.DepositPanel.MoneyDepositDesc31 = vgui.Create( "DLabel", right_col );
        self.DepositPanel.MoneyDepositDesc31:Dock(TOP);
        self.DepositPanel.MoneyDepositDesc31:SetContentAlignment( 5 );
        self.DepositPanel.MoneyDepositDesc31:DockMargin(0, self.innerPadding * 0.0, 0, 0)
        self.DepositPanel.MoneyDepositDesc31:SetFont("DepositPanel.Small");
        self.DepositPanel.MoneyDepositDesc31:SetTextColor( rpui.UIColors.White );
        self.DepositPanel.MoneyDepositDesc31:SetText( translates.Get(tebex_desc[1]) );

        self.DepositPanel.MoneyDepositDesc32 = vgui.Create( "DLabel", right_col );
        self.DepositPanel.MoneyDepositDesc32:Dock(TOP);
        self.DepositPanel.MoneyDepositDesc32:SetContentAlignment( 5 );
        self.DepositPanel.MoneyDepositDesc32:DockMargin(0, -self.innerPadding * 0.7, 0, self.innerPadding)
        self.DepositPanel.MoneyDepositDesc32:SetFont("DepositPanel.Small");
        self.DepositPanel.MoneyDepositDesc32:SetTextColor( rpui.UIColors.White );
        self.DepositPanel.MoneyDepositDesc32:SetText( translates.Get(tebex_desc[2]) );

        if not isForeign then
            self.DepositPanel.MoneyDeposit3:SetZPos( 100 );
            self.DepositPanel.MoneyDepositDesc31:SetZPos( 101 );
            self.DepositPanel.MoneyDepositDesc32:SetZPos( 102 );
        end

        self.DepositPanel.MoneyDeposit = vgui.Create( "DButton", right_col );
        local mon_dep = self.DepositPanel.MoneyDeposit;

        self.DepositPanel.MoneyDepositDESC = vgui.Create( "DLabel", right_col );
        self.DepositPanel.MoneyDepositDESC2 = vgui.Create( "DLabel", right_col );
        local deposit_des = self.DepositPanel.MoneyDepositDESC
        local deposit_des_2 = self.DepositPanel.MoneyDepositDESC2

        deposit_des:Dock(TOP);
        deposit_des:SetContentAlignment( 5 );
        deposit_des:SetFont("DepositPanel.Small");
        deposit_des:SetTextColor( rpui.UIColors.White );

        deposit_des_2:Dock(TOP);
        deposit_des_2:SetContentAlignment( 5 );
        deposit_des_2:SetFont("DepositPanel.Small");
        deposit_des_2:SetTextColor( rpui.UIColors.White );

        self.SetMultiplayerText = function(str1, str2)
            deposit_des:SetText(str1);
            deposit_des:SizeToContentsY();
            deposit_des_2:SetText(str2);
            deposit_des_2:SizeToContentsY();

			deposit_des:SetTall(0)
			deposit_des_2:SetTall(0)
        end

        self.SetMultiplayerText("", "")



        self.DepositPanel.RoboDesc1 = vgui.Create( "DLabel", right_col );
        local robo_desc_1 = self.DepositPanel.RoboDesc1
        robo_desc_1:Dock(TOP);
        robo_desc_1:SetContentAlignment( 5 );
        robo_desc_1:DockMargin(0, self.innerPadding * 0.0, 0, 0)
        robo_desc_1:SetFont("DepositPanel.Small");
        robo_desc_1:SetTextColor( rpui.UIColors.White );
        robo_desc_1:SetText( isForeign and translates.Get(paypal_desc[1]) or robo_desc[1] );

        self.DepositPanel.RoboDesc2 = vgui.Create( "DLabel", right_col );
        local robo_desc_2 = self.DepositPanel.RoboDesc2
        robo_desc_2:Dock(TOP);
        robo_desc_2:SetContentAlignment( 5 );
        robo_desc_2:DockMargin(0, -self.innerPadding * 0.7, 0, self.innerPadding)
        robo_desc_2:SetFont("DepositPanel.Small");
        robo_desc_2:SetTextColor( rpui.UIColors.White );
        robo_desc_2:SetText( isForeign and translates.Get(paypal_desc[2]) or robo_desc[2] );


        mon_dep:Dock( TOP );
        mon_dep:SetFont( "DepositPanel.MediumBold" );
        mon_dep:DockMargin(0, self.innerPadding * 0.0, 0, 0)
        mon_dep:SetText( translates.Get("ПОПОЛНИТЬ СЧЁТ") );
        mon_dep:SizeToContentsY( self.innerPadding * 2 );

        mon_dep.Paint = function( this, w, h )
            if not IsValid( self.DepositPanel ) then return end
            this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();
            local distsize  = math.sqrt( w*w + h*h );

            local rc, rr = isForeign and DisabledColor or RainbowColor, isForeign and DisabledRotate or RainbowRotate;
            surface.SetAlphaMultiplier( self.DepositPanel.GetAlpha(self.DepositPanel) / 255 );
                surface.SetDrawColor( rc );
                surface.DrawRect( 0, 0, w, h );

                surface.SetMaterial( rpui.GradientMat );
                surface.SetDrawColor( rr );
                surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

				local img_width = 0.9 * w

				surface.SetDrawColor(Color(255, 255, 255))
				surface.SetMaterial(isForeign and paypal_mat or robo_mat)
				surface.DrawTexturedRect(w * 0.05 - 1, (h - 0.125 * img_width) * 0.5 + 1, img_width, 0.125 * img_width)

            surface.SetAlphaMultiplier( 1 );

            return true
        end
        self.DepositPanel.MoneyDeposit.Think = function( this )
            if this.Timeout and (this.Timeout < SysTime()) then
                this:SetEnabled( true );
                this.Timeout = false;
            end
        end
        self.DepositPanel.MoneyDeposit.DoClick = function( this )
            if rp.cfg.IsFrance then return end

            local amount = string.gsub(self.DepositPanel.DepositContainer.InputContainer.Input.GetValue(self.DepositPanel.DepositContainer.InputContainer.Input), "[" .. translates.Get("₽") .. "%s]", "");

            if #amount > 0 then
				if rp.cfg.IsFrance then
					if tonumber(amount) < 10 or tonumber(amount) < 20 and total_donated and total_donated > 0 then
						return rp.Notify(NOTIFY_ERROR, translates.Get("Сумма доната не может быть меньше #€"), total_donated and total_donated > 0 and 2 or 1)
					end

					local donation = donations.get( "points" );
					donations.getMethodByName("robokassa").onClick( donations.getMethodByName("robokassa"), donation, nil, amount );
				else
					gui.OpenURL("https://shop.urf.im/page/robokassa?price=" .. amount .. "&sid=" .. LocalPlayer():SteamID64() .. "&s=" .. rp.cfg.ServerUID .. "#purchase")
				end

                this.Timeout = SysTime() + 5;
                this:SetEnabled( false );
            else
				if rp.cfg.IsFrance then
					rp.Notify(NOTIFY_ERROR, translates.Get("Введена неверная сумма"))

				else
					self.DepositPanel.RetardAlert = 1;
				end
            end
        end


        self.DepositPanel.MoneyDeposit2 = vgui.Create( "DButton", right_col );
        local mon_dep2 = self.DepositPanel.MoneyDeposit2;

        self.DepositPanel.UMonDesc1 = vgui.Create( "DLabel", right_col );
        local umon_desc_1 = self.DepositPanel.UMonDesc1
        umon_desc_1:Dock(TOP);
        umon_desc_1:SetContentAlignment( 5 );
        umon_desc_1:DockMargin(0, self.innerPadding * 0.0, 0, 0)
        umon_desc_1:SetFont("DepositPanel.Small");
        umon_desc_1:SetTextColor( rpui.UIColors.White );
        umon_desc_1:SetText( isForeign and translates.Get(robo_desc[1]) or umoney_desc[1] );

        self.DepositPanel.UMonDesc2 = vgui.Create( "DLabel", right_col );
        local umon_desc_2 = self.DepositPanel.UMonDesc2
        umon_desc_2:Dock(TOP);
        umon_desc_2:SetContentAlignment( 5 );
        umon_desc_2:DockMargin(0, -self.innerPadding * 0.7, 0, self.innerPadding)
        umon_desc_2:SetFont("DepositPanel.Small");
        umon_desc_2:SetTextColor( rpui.UIColors.White );
        umon_desc_2:SetText( isForeign and translates.Get(robo_desc[2]) or umoney_desc[2] );


        mon_dep2:Dock( TOP );
        mon_dep2:SetFont( "DepositPanel.MediumBold" );
        mon_dep2:SetText( translates.Get("ПОПОЛНИТЬ СЧЁТ") );
        mon_dep2:SizeToContentsY( self.innerPadding * 2 );
        mon_dep2:SetMouseInputEnabled( not isForeign ); -- DISABLED!
        mon_dep2.Paint = function( this, w, h )
            if not IsValid( self.DepositPanel ) then return end
            this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();
            local distsize  = math.sqrt( w*w + h*h );

            local rc, rr = isForeign and DisabledColor or RainbowColor, isForeign and DisabledRotate or RainbowRotate;
            surface.SetAlphaMultiplier( self.DepositPanel.GetAlpha(self.DepositPanel) / 255 );
                surface.SetDrawColor(rc);
                surface.DrawRect( 0, 0, w, h );

                surface.SetMaterial( rpui.GradientMat );
                surface.SetDrawColor(rr);
                surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

				local img_width2 = 0.9 * w

				surface.SetDrawColor(Color(255, 255, 255))
				surface.SetMaterial(isForeign and robo_mat or umoney_mat)
				surface.DrawTexturedRect(w * 0.05 - 1, (h - 0.125 * img_width2) * 0.5 + 1, img_width2, 0.125 * img_width2)

            surface.SetAlphaMultiplier( 1 );

            return true
        end
        mon_dep2.Think = function( this )
            if this.Timeout and (this.Timeout < SysTime()) then
                this:SetEnabled( true );
                this.Timeout = false;
            end
        end
        mon_dep2.DoClick = function( this )
            if rp.cfg.IsFrance then return end

            local amount = string.gsub(self.DepositPanel.DepositContainer.InputContainer.Input.GetValue(self.DepositPanel.DepositContainer.InputContainer.Input), "[" .. translates.Get("₽") .. "%s]", "");

            if #amount > 0 then
				if rp.cfg.IsFrance then
					if tonumber(amount) < 10 or tonumber(amount) < 20 and total_donated and total_donated > 0 then
						return rp.Notify(NOTIFY_ERROR, translates.Get("Сумма доната не может быть меньше #€"), total_donated and total_donated > 0 and 2 or 1)
					end

					gui.OpenURL("https://urfim.fr/page/robokassa?price=" .. amount .. "&sid=" .. LocalPlayer():SteamID64() .. "&s=" .. (rp.cfg.ServerRealUID or rp.cfg.ServerUID) .. "#purchase")
				else
					gui.OpenURL("https://shop.urf.im/page/umoney?price=" .. amount .. "&sid=" .. LocalPlayer():SteamID64() .. "&s=" .. rp.cfg.ServerUID .. "#purchase")
				end

                this.Timeout = SysTime() + 5;
                this:SetEnabled( false );
            else
				if rp.cfg.IsFrance then
					rp.Notify(NOTIFY_ERROR, translates.Get("Введена неверная сумма"))
				else
					self.DepositPanel.RetardAlert = 1;
				end
            end
        end

        self.DepositPanel.LeftColumn.InvalidateLayout( self.DepositPanel.LeftColumn, true );
        self.DepositPanel.LeftColumn.SizeToChildren( self.DepositPanel.LeftColumn, false, true );

        self.DepositPanel.Foreground.InvalidateLayout( self.DepositPanel.Foreground, true );
        self.DepositPanel.Foreground.SizeToChildren( self.DepositPanel.Foreground, false, true );

        self.DepositPanel.InvalidateLayout( self.DepositPanel, true );
        self.DepositPanel.SizeToChildren( self.DepositPanel, false, true );
    end

    if self.DepositPanelOpener and pnl == self.DepositPanelOpener then
        self.DepositPanel.Close(self.DepositPanel);
    else
        self.DepositPanelOpener = pnl;
        self.DepositPanel.Closing = false;
        self.DepositPanel.Stop(self.DepositPanel);
        self.DepositPanel.AlphaTo( self.DepositPanel, 0, 0, 0, function()
            if not IsValid(self.DepositPanel) then return end

            self.DepositPanel.TopArrow.SetTall( self.DepositPanel.TopArrow, alignTop and 0 or self.innerPadding * 2 );
            self.DepositPanel.BottomArrow.SetTall( self.DepositPanel.BottomArrow, alignTop and self.innerPadding * 2 or 0 );

            self.DepositPanel.InvalidateLayout( self.DepositPanel, true );
            self.DepositPanel.SizeToChildren( self.DepositPanel, false, true );

            local x, y = pnl:LocalToScreen();
            self.DepositPanel.SetPos( self.DepositPanel, x - self.DepositPanel.GetWide(self.DepositPanel) + pnl:GetWide(), y + (alignTop and -self.DepositPanel.GetTall(self.DepositPanel) - 0.5 * self.innerPadding or pnl:GetTall() + self.innerPadding * 0.5) );

            self.DepositPanel.AlphaTo( self.DepositPanel, 255, 0.25 );
        end );
    end
end

local weapon_table = {
            LayoutInformation = function( frame )
                local BtnDisableWep = vgui.Create( "DButton", frame );
                BtnDisableWep:Dock( TOP );
                BtnDisableWep:SetFont( "rpui.Fonts.DonateMenu.PurchaseButton" );
                BtnDisableWep.Paint = function( this, w, h )
                    local baseColor666, textColor666 = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
                    surface.SetDrawColor( baseColor666 );
                    surface.DrawRect( 0, 0, w, h );
                    draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor666, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end

                BtnDisableWep.UpdateInformation = function( this, ItemInfo )
                    if (not ItemInfo.IsBuyable) and ItemInfo.Reason == translates.Get("Это у вас уже куплено!") then
                        this:SetTall( rpui.DonateMenu.frameH * 0.085 );
                    else
                        this:SetTall( 0 );
                    end

                    this:SetEnabled( true );
                    this.Timeout = nil;

                    this:SetText( disabledWeps[ItemInfo.Upgrade.UID] and translates.Get("ВКЛЮЧИТЬ ВЫДАЧУ ОРУЖИЯ") or translates.Get("ВЫКЛЮЧИТЬ ВЫДАЧУ ОРУЖИЯ") );

                    this.DoClick = function( this1 )
                        if not this1.Timeout then
                            disabledWeps[ItemInfo.Upgrade.UID] = !disabledWeps[ItemInfo.Upgrade.UID];

                            local pdata_disabledWeps = {};
                            for wepclass, wep in pairs( disabledWeps ) do
                                if wep then
                                    table.insert( pdata_disabledWeps, wepclass );
                                end
                            end
                            LocalPlayer():SetPData( "urf_disableddonateweps_" .. util.CRC(game.GetIPAddress()), table.concat(pdata_disabledWeps,";") );

                            this1:SetEnabled( false );
                            this1.Timeout = SysTime() + 3;

                            net.Start( "rp.CreditShop.DisableWeapon" );
                                net.WriteString( ItemInfo.Upgrade.UID );
                                net.WriteBool( disabledWeps[ItemInfo.Upgrade.UID] );
                            net.SendToServer();

                            this1:SetText( translates.Get("СОХРАНЕНИЕ...") );
                        end
                    end

                    this.Think = function( this2 )
                        if this2.Timeout and SysTime() > this2.Timeout then
                            this2:SetEnabled( true );
                            this2.Timeout = nil;

                            this2:SetText( disabledWeps[ItemInfo.Upgrade.UID] and translates.Get("ВКЛЮЧИТЬ ВЫДАЧУ ОРУЖИЯ") or translates.Get("ВЫКЛЮЧИТЬ ВЫДАЧУ ОРУЖИЯ") );
                        end
                    end
                end

                BtnDisableWep:InvalidateLayout( true );
            end
        }

function PANEL:Init()
    net.Receive( "donations.url", function()
        local url = net.ReadString();
        gui.OpenURL( url );
        hook.Run( "donations.GotUrl", url );
    end );

    self.categoryCreationFuncs = {
        [translates and translates.Get("SALE") or "SALE"] = {
            MenuPaint = function( this, w, h )
                this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();

                surface.SetDrawColor( Color(0,0,0) );
                surface.DrawRect( 0, 0, w, h );

                rpui.GetPaintStyle( this, STYLE_GOLDEN );

                local distsize  = math.sqrt( w*w + h*h );

                local parentalpha = this.Base.GetAlpha(this.Base) / 255;
                local alphamult   = this._alpha / 255;

                surface.SetAlphaMultiplier( parentalpha * alphamult );
                    surface.SetDrawColor( RainbowColor );
                    surface.DrawRect( 0, 0, w, h );

                    surface.SetMaterial( rpui.GradientMat );
                    surface.SetDrawColor( RainbowRotate );
                    surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

                    draw.SimpleText( this:GetText(), "rpui.Fonts.DonateMenu.MenuButtonBigBold", w * 0.5, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                surface.SetAlphaMultiplier( parentalpha * (1 - alphamult) );
                    draw.SimpleText( this:GetText(), "rpui.Fonts.DonateMenu.MenuButtonBigBold", w * 0.5, h * 0.5, RainbowColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                surface.SetAlphaMultiplier( 1 );

                return true
            end,

            MenuPaintOver = function( this, w, h )
                if this.Base.GetAlpha(this.Base) == 255 then
                    rpui.DrawStencilBorder( this, 0, 0, w, h, 0.06, RainbowColor, RainbowRotate );
                end
            end
        },

        [translates and translates.Get("PREMIUM") or "PREMIUM"] = include('rp_base/gamemode/main/menus/f4menu/controls/rpui_premium_cl.lua'),
        [translates and translates.Get("КЕЙСЫ") or "КЕЙСЫ"] = include('rp_base/gamemode/main/menus/f4menu/controls/rpui_cases_cl.lua'),

        [translates.Get("Оружие")] = weapon_table,
        [translates.Get("Особое оружие")] = weapon_table,
        [translates.Get("Огнестрельное оружие")] = weapon_table,

        [translates.Get("Время")] = {
            HideRefund = true,
        },
        [translates.Get("Валюта")] = {
            HideRefund = true,
        },
        [translates.Get("Привелегии")] = {
            HideRefund = true,
        },
        [translates.Get("Ивенты")] = {
            HideRefund = true,
        },

        [translates.Get("Особые услуги")] = {
            HidePrice = true,
            HideRefund = true,

            PurchaseButton = {
                Real = function( upgrade, btn )
                    btn:SetText( translates.Get("ОБРАТИТЬСЯ К КОНСУЛЬТАНТУ") );
                    btn.Think = nil;
                    btn.DoClick = function()
                        gui.OpenURL( rp.cfg.ConsultUrl );
                    end
                end
            }
        }
    };

    self:SetSize( ScrW(), ScrH() );

    self:InvalidateLayout( true );
    self:InvalidateParent( true );

    self.frameW, self.frameH = self:GetSize();
    self.innerPadding        = self.frameH / 100;

    self:DockPadding( self.innerPadding * 2, self.innerPadding * 2, self.innerPadding * 2, self.innerPadding * 2 );

    self:RebuildFonts( self.frameW, self.frameH );

    self.Foreground = vgui.Create( "Panel", self );
    self.Foreground.SetSize( self.Foreground, self:GetSize() );
    self.Foreground.SetZPos( self.Foreground, -228 );

    self.MenuContainer = vgui.Create( "Panel", self );
    local menu_cont = self.MenuContainer;

    menu_cont:Dock( LEFT );
    menu_cont:DockMargin( 0, 0, self.innerPadding * 4, 0 );
    menu_cont:SetWide( self.frameW * 0.2 );
    menu_cont:InvalidateParent( true );
    menu_cont.Buttons = {};

    self.Header = vgui.Create( "Panel", self );
    local header = self.Header;

    header:Dock( TOP );
    header:DockMargin( 0, 0, 0, self.innerPadding );
    header:SetTall( self.frameH * 0.1 );
    header:InvalidateParent( true );


    self.Header.Title = vgui.Create( "DLabel", self.Header );
    local h_title = self.Header.Title;

    h_title:Dock( LEFT );
    h_title:SetFont( "rpui.Fonts.DonateMenu.Title" );
    h_title:SetTextColor( rpui.UIColors.White );
    h_title:SetText( translates.Get("ДОНАТ") );
    h_title:SizeToContentsX();

    self.Header.CloseButton = vgui.Create( "DButton", self.Header );
    local h_close = self.Header.CloseButton;

    h_close:Dock( RIGHT );
    h_close:DockMargin( self.innerPadding * 2, self.innerPadding * 3, 0, self.innerPadding * 3 );
    h_close:InvalidateParent( true );
    h_close:SetFont( "rpui.Fonts.DonateMenu.Small" );
    h_close:SetText( translates.Get("ЗАКРЫТЬ") );
    h_close:SizeToContentsX( self.innerPadding * 3 + h_close:GetTall(h_close) );
    h_close.Paint = function( this, w, h )
        local baseColor999, textColor999 = rpui.GetPaintStyle( this );
        surface.SetDrawColor( baseColor999 );
        surface.DrawRect( 0, 0, w, h );

        surface.SetDrawColor( rpui.UIColors.White );
        surface.DrawRect( 0, 0, h, h );

        surface.SetDrawColor( Color(0,0,0,this._grayscale or 0) );
        local p = h / 10;
        surface.DrawLine( h, p, h, h - p );

        draw.SimpleText( "✕", "rpui.Fonts.DonateMenu.Small", h * 0.5, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5 + h * 0.5, h * 0.5, textColor999, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

        return true
    end
    self.Header.CloseButton.DoClick = function( this )
        self:Close();
    end

    self.Header.Promocode = vgui.Create( "DButton", self.Header );
    local h_promo = self.Header.Promocode;

    h_promo:Dock( RIGHT );
    h_promo:DockMargin( self.innerPadding * 2, self.innerPadding * 3, 0, self.innerPadding * 3 );
    h_promo:SetFont( "rpui.Fonts.DonateMenu.ItemButtonBold" );
    h_promo:SetText( translates.Get("ВВЕСТИ ПРОМОКОД") );
    h_promo:SizeToContentsX( self.innerPadding * 4 );
    h_promo.DoClick = function()
        if not self.PromocodePanel then
            self.PromocodePanel = vgui.Create( "Panel", self );
            local p_pan = self.PromocodePanel;

            p_pan:SetWide( self.Header.Promocode.GetWide(self.Header.Promocode) );
            local x, y = self.Header.Promocode.LocalToScreen(self.Header.Promocode);
            p_pan:SetPos( x, y + self.Header.Promocode.GetTall(self.Header.Promocode) + self.innerPadding * 0.5 );
            p_pan:SetAlpha( 0 );
            p_pan:AlphaTo( 255, 0.25 );
            p_pan.RetardAlert = 0;
            p_pan.Close = function()
                p_pan.Closing = true;
                p_pan:Stop();
                p_pan:AlphaTo( 0, 0.25, 0, function()
                    if IsValid( p_pan ) then p_pan:Remove(); end
                    self.PromocodePanel = nil;
                end );
            end
            self.PromocodePanel.Think = function( this )
                if input.IsMouseDown(MOUSE_LEFT) and self:IsChildHovered() and not this.Closing then
                    if (not this:IsHovered() and not this:IsChildHovered()) then
                        this:Close();
                    end
                end

                if this.RetardAlert > 0 then
                    this.RetardAlert = math.Approach( this.RetardAlert, 0, FrameTime() );
                end
            end
            self.PromocodePanel.TopArrow = vgui.Create( "Panel", self.PromocodePanel );
            local p_topa = self.PromocodePanel.TopArrow;

            p_topa:Dock( TOP );
            p_topa:SetTall( self.innerPadding * 2 );
            p_topa.Paint = function( this, w, h )
                draw.NoTexture();
                surface.SetDrawColor( Color(0,0,0,200) );
                surface.DrawPoly( {{x = w * 0.5 - h * 0.5, y = h}, {x = w * 0.5, y = 0}, {x = w * 0.5 + h * 0.5, y = h}} );
            end

            self.PromocodePanel.Foreground = vgui.Create( "Panel", self.PromocodePanel );
            local p_fog = self.PromocodePanel.Foreground;

            p_fog:Dock( TOP );
            p_fog:DockPadding( self.innerPadding * 2, self.innerPadding * 2, self.innerPadding * 2, self.innerPadding * 2 );
            p_fog.Paint = function( this, w, h )
                surface.SetDrawColor( Color(0,0,0,200) );
                surface.DrawRect( 0, 0, w, h );
            end

            surface.CreateFont( "self.PromocodePanel.MediumBold", {
                font     = "Montserrat",
                size     = self.frameH * 0.025,
                extended = true,
            } );

            surface.CreateFont( "self.PromocodePanel.Small", {
                font     = "Montserrat",
                size     = self.frameH * 0.0175,
                extended = true,
            } );

            surface.CreateFont( "self.PromocodePanel.InputBold", {
                font      = "Montserrat",
                size      = self.frameH * 0.02,
                extended  = true,
            } );

            self.PromocodePanel.InputContainer = vgui.Create( "EditablePanel", self.PromocodePanel.Foreground );
            local p_inp = self.PromocodePanel.InputContainer;

            p_inp:Dock( TOP );
            p_inp:DockMargin( 0, 0, 0, self.innerPadding );
            p_inp:DockPadding( 0, self.innerPadding * 0.5, 0, self.innerPadding * 0.5 );
            p_inp:SetTall( self.frameH * 0.04 );
            p_inp:InvalidateParent( true );
            p_inp.Paint = function( this, w, h )
                surface.SetDrawColor( rpui.UIColors.White );
                surface.DrawRect( 0, 0, w, h );
            end
            self.PromocodePanel.InputContainer.PaintOver = function( this, w, h )
                if not IsValid( self.PromocodePanel ) then return end
                this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();
                rpui.DrawStencilBorder( this, 0, 0, w, h, 0.06, RainbowColor, RainbowRotate, self.PromocodePanel.GetAlpha(self.PromocodePanel) / 255 );
            end

            self.PromocodePanel.InputContainer.Icon = vgui.Create( "Panel", self.PromocodePanel.InputContainer );
            local p_icon = self.PromocodePanel.InputContainer.Icon;

            p_icon:Dock( LEFT );
            p_icon:DockMargin( self.innerPadding, 0, self.innerPadding, 0 );
            p_icon:InvalidateParent( true );
            p_icon:SetWide( p_icon:GetTall() );
            p_icon.Material = Material( "rpui/donatemenu/promo" );
            p_icon.Paint = function( this, w, h )
                surface.SetDrawColor( rpui.UIColors.Black );
                surface.SetMaterial( this.Material );
                surface.DrawTexturedRect( 0, 0, w, h );
            end

            self.PromocodePanel.InputContainer.Input = vgui.Create( "DTextEntry", self.PromocodePanel.InputContainer );
            local p_inp_input = self.PromocodePanel.InputContainer.Input;

            p_inp_input:Dock( FILL );
            p_inp_input:DockMargin( 0, 0, self.innerPadding * 0.5, 0 );
            p_inp_input:SetDrawLanguageID( false );
            p_inp_input:SetFont( "self.PromocodePanel.InputBold" );
            p_inp_input:SetPlaceholderText( translates.Get("Введите промокод") );
            p_inp_input.Paint = function( this, w, h )
                if #this:GetValue() <= 0 and !this:HasFocus() then
                    draw.SimpleText( this:GetPlaceholderText(), this:GetFont(), 0, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
                else
                    this:DrawTextEntryText( rpui.UIColors.Black, rpui.UIColors.Black, rpui.UIColors.Black );
                end
            end

            self.PromocodePanel.DescriptionT = vgui.Create( "DLabel", self.PromocodePanel.Foreground );
            local p_des_t = self.PromocodePanel.DescriptionT;

            p_des_t:Dock( TOP );
            p_des_t:SetContentAlignment( 5 );
            p_des_t:SetFont( "self.PromocodePanel.Small" );
            p_des_t:SetTextColor( rpui.UIColors.White );
            p_des_t:SetText( translates.Get("Введите промокод в") );
            p_des_t.Paint = function( this, w, h )
                if IsValid(self.PromocodePanel) then
                    local shakeAmount = self.PromocodePanel.RetardAlert;
                    local shakeOffset = 0;

                    if shakeAmount > 0 then
                        shakeOffset = math.sin( SysTime() * 50 ) * self.innerPadding * shakeAmount;
                    end

                    draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5 + shakeOffset, h * 0.5, (shakeAmount > 0) and Color(255,28,55) or rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                end

                return true;
            end

            self.PromocodePanel.DescriptionB = vgui.Create( "DLabel", self.PromocodePanel.Foreground );
            local p_des_b = self.PromocodePanel.DescriptionB;

            p_des_b:Dock( TOP );
            p_des_b:DockMargin( 0, 0, 0, self.innerPadding * 2 );
            p_des_b:SetContentAlignment( 5 );
            p_des_b:SetFont( "self.PromocodePanel.Small" );
            p_des_b:SetTextColor( rpui.UIColors.White );
            p_des_b:SetText( translates.Get("форму выше.") );
            p_des_b.Paint = function( this, w, h )
                if IsValid(self.PromocodePanel) then
                    local shakeAmount = self.PromocodePanel.RetardAlert;
                    local shakeOffset = 0;

                    if shakeAmount > 0 then
                        shakeOffset = math.sin( SysTime() * 50 ) * self.innerPadding * shakeAmount;
                    end

                    draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5 + shakeOffset, h * 0.5, (shakeAmount > 0) and Color(255,28,55) or rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                end

                return true;
            end

            self.PromocodePanel.ActivateBtn = vgui.Create( "DButton", self.PromocodePanel.Foreground );
            local p_act_btn = self.PromocodePanel.ActivateBtn;

            p_act_btn:Dock( TOP );
            p_act_btn:SetFont( "self.PromocodePanel.MediumBold" );
            p_act_btn:SetText( translates.Get("АКТИВИРОВАТЬ") );
            p_act_btn:SizeToContentsY( self.innerPadding * 2 );
            p_act_btn.Paint = function( this, w, h )
                if not IsValid( self.PromocodePanel ) then return end

                this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();
                local distsize  = math.sqrt( w*w + h*h );

                surface.SetAlphaMultiplier( self.PromocodePanel.GetAlpha(self.PromocodePanel) / 255 );
                    surface.SetDrawColor(RainbowColor);
                    surface.DrawRect( 0, 0, w, h );

                    surface.SetMaterial( rpui.GradientMat );
                    surface.SetDrawColor(RainbowRotate);
                    surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

                    draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                surface.SetAlphaMultiplier( 1 );

                return true
            end
            self.PromocodePanel.ActivateBtn.DoClick = function( this, w, h )
                if #self.PromocodePanel.InputContainer.Input.GetValue(self.PromocodePanel.InputContainer.Input) > 0 then
                    rp.RunCommand( "usepromocode", string.Trim(self.PromocodePanel.InputContainer.Input.GetValue(self.PromocodePanel.InputContainer.Input)) );

                else
                    self.PromocodePanel.RetardAlert = 1;
                end
            end

            self.PromocodePanel.Foreground.InvalidateLayout( self.PromocodePanel.Foreground, true );
            self.PromocodePanel.Foreground.SizeToChildren( self.PromocodePanel.Foreground, false, true );

            self.PromocodePanel.InvalidateLayout( self.PromocodePanel, true );
            self.PromocodePanel.SizeToChildren( self.PromocodePanel, false, true );
        end
    end
    self.Header.Promocode.Paint = function( this, w, h )
        surface.SetDrawColor( rpui.UIColors.White );
        surface.DrawRect( 0, 0, w, h );
        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true
    end

    self.Header.Balance = vgui.Create( "DButton", self.Header );
    local h_bal = self.Header.Balance;

    self.Header.Balance.SavedBalance = LocalPlayer():GetCredits()

    h_bal:Dock( RIGHT );
    h_bal:DockMargin( self.innerPadding * 2, self.innerPadding * 3, 0, self.innerPadding * 3 );
    h_bal:SetFont( "rpui.Fonts.DonateMenu.ItemButtonBold" );
    h_bal:SetText( translates.Get("БАЛАНС: %s РУБЛЕЙ", string.Comma(LocalPlayer():GetCredits())) );
    h_bal:SizeToContentsX( self.innerPadding * 4 );
    h_bal:InvalidateLayout( true );
    h_bal.Paint = function( this, w, h )
        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );

        draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        return true
    end
    self.Header.Balance.DoClick = function( this )
        self:CreateDepositPanel( this );
    end

    self.DiscountNotifier = vgui.Create( "DLabel", self );
    local dis_not = self.DiscountNotifier;

    dis_not:Dock( BOTTOM );
    dis_not:DockMargin( 0, self.innerPadding, 0, 0 );
    dis_not:SetVisible( false );
    dis_not:SetTall( 0 );
    dis_not:SetFont( "rpui.Fonts.DonateMenu.DiscountNotifier" );
    dis_not:SetTextColor( rpui.UIColors.White );
    dis_not:SetText( "пашол на хуй" );
    dis_not:SetContentAlignment( 5 );
    dis_not.Paint = function( this, w, h )
        surface.SetDrawColor( HSVToColor(346 + math.sin(SysTime()) * 3, 0.88, 0.98) );
        surface.DrawRect( 0, 0, w, h );
    end

    local os_time = os.time()
    local DiscountText = {}

	DiscountText.txt = ''
	DiscountText.remain = 0

    local _LocalPlayer = LocalPlayer()

	local prem_sale_data = util.JSONToTable(nw.GetGlobal('prem_sale') or '[]') or {}
	local is_prem_sale = prem_sale_data.duration and prem_sale_data.duration > os.time()
	local prem_discount = tonumber(prem_sale_data.discount or 0)
    local is_sale = rp.GetDiscountTime() > os_time
    local is_skinsmult = rp.GetSkinsDonateMultiplayerTime and rp.GetSkinsDonateMultiplayerTime() > os_time
    local is_globalmult = rp.GetDonateMultiplayerTime and rp.GetDonateMultiplayerTime() > os_time
    local is_personalmult = _LocalPlayer.GetPersonalDonateMultiplayerTime and _LocalPlayer:GetPersonalDonateMultiplayerTime() > os_time
    local is_personaldiscount = _LocalPlayer:GetPersonalDiscountTime() > os_time

    local is_something = is_sale or is_skinsmult or is_globalmult or is_personalmult or is_prem_sale

    if is_something then
        if is_prem_sale then
            DiscountText.txt = translates.Get("Скидка на премиум %s", prem_discount) .. "%!";
            DiscountText.remain = prem_sale_data.duration

        elseif is_sale then
            DiscountText.txt = translates.Get("Скидка %s", rp.GetDiscount() * 100) .. "%!";
            DiscountText.remain = rp.GetDiscountTime()
        elseif is_skinsmult then
            DiscountText.txt = translates.Get("БОНУС %s", rp.GetSkinsDonateMultiplayer() * 100) .. "% " .. translates.Get("НА ПОПОЛНЕНИЯ СКИНАМИ!");
            DiscountText.remain = rp.GetSkinsDonateMultiplayerTime()
        elseif is_globalmult then
            DiscountText.txt = translates.Get("БОНУС %s", rp.GetDonateMultiplayer() * 100) .. "% " .. translates.Get("НА ПОПОЛНЕНИЯ!");
            DiscountText.remain = rp.GetDonateMultiplayerTime()

            local min = rp.GetDonateMultiplayerMinimum()
            if min > 0 then
                DiscountText.txt = DiscountText.txt.sub(DiscountText.txt, 1, #DiscountText.txt - 1) .." ".. translates.Get('при пожертвовании от %s руб', min) .."!"
            end
        elseif is_personalmult then
            DiscountText.txt = translates.Get("ПЕРСОНАЛЬНЫЙ БОНУС %s", _LocalPlayer:GetPersonalDonateMultiplayer() * 100) .. "% " .. translates.Get("НА ПОПОЛНЕНИЯ!");
            DiscountText.remain = _LocalPlayer:GetPersonalDonateMultiplayerTime()
        elseif is_personaldiscount then
            DiscountText.txt = translates.Get("ПЕРСОНАЛЬНАЯ СКДИКА %s", _LocalPlayer:GetPersonalDiscount() * 100) .. "%!";
            DiscountText.remain = _LocalPlayer:GetPersonalDiscountTime()
        end

        is_something = DiscountText.remain > os_time
    end

    local sale = nw.GetGlobal("rp.shop.settings");
    if is_something then
        if not self.DiscountNotifier.IsVisible(self.DiscountNotifier) then
            self.DiscountNotifier.SetVisible( self.DiscountNotifier, true );
            self.DiscountNotifier.SizeToContentsY( self.DiscountNotifier, self.innerPadding * 0.5 );
        end

        self.DiscountNotifier.time_until = DiscountText.remain;
        self.DiscountNotifier.text       = DiscountText.txt;

        self.DiscountNotifier.Think = function( this )
            local lasts = this.time_until - os.time();
            local tb    = string.FormattedTime( (lasts > 0) and lasts or 0 );

            this:SetText( this.text .. ' ' .. translates.Get('Осталось:') .. ' ' .. string.format("%02i:%02i:%02i", tb["h"], tb["m"], tb["s"]));

            if lasts <= 0 then
                self.Header.Balance.DoClick(self.Header.Balance);
            end
        end
    elseif sale and sale.item and rp.shop.Mapping[sale.item] then
    end

    self.RMDepositBtn = vgui.Create( "DButton", self );
    local rmd_btn = self.RMDepositBtn;

    rmd_btn:SetFont( "rpui.Fonts.DonateMenu.DepositButton" );
    rmd_btn:SetText( translates.Get("ПОПОЛНИТЬ СЧЁТ") );
    rmd_btn:SizeToContentsX( self.innerPadding * 3 );
    rmd_btn:SizeToContentsY( self.innerPadding * 2 );
    rmd_btn:SetPos( self:GetWide() - self.innerPadding * 2 - rmd_btn:GetWide(), self:GetTall() - rmd_btn:GetTall() - self.innerPadding * (self.DiscountNotifier.IsVisible(self.DiscountNotifier) and 4 or 2) - self.DiscountNotifier.GetTall(self.DiscountNotifier) );
    rmd_btn:SetZPos( 1 );
    rmd_btn.Paint = function( this, w, h )
        this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();

        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_GOLDEN );

        surface.SetDrawColor( Color(0,0,0) );
        surface.DrawRect( 0, 0, w, h );

        local distsize  = math.sqrt( w*w + h*h );

        local parentalpha = self:GetAlpha() / 255;
        local alphamult   = this._alpha / 255;

        surface.SetAlphaMultiplier( parentalpha * alphamult );
            surface.SetDrawColor( RainbowColor );
            surface.DrawRect( 0, 0, w, h );

            surface.SetMaterial( rpui.GradientMat );
            surface.SetDrawColor( RainbowRotate );
            surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

            draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        surface.SetAlphaMultiplier( parentalpha * (1 - alphamult) );
            draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, RainbowRotate, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        surface.SetAlphaMultiplier( 1 );

        return true
    end
    self.RMDepositBtn.PaintOver = function( this, w, h )
        rpui.DrawStencilBorder( this, 0, 0, w, h, 0.06, RainbowColor, RainbowRotate, self:GetAlpha() / 255 );
    end
    self.RMDepositBtn.DoClick = function( this )
        self:CreateDepositPanel( this, true );
    end

    self.SMDepositBtn = vgui.Create( "DButton", self );
    local smd_btn = self.SMDepositBtn;

    smd_btn:SetFont( "rpui.Fonts.DonateMenu.DepositButton" );
    smd_btn:SetText( translates.Get("ПОПОЛНИТЬ СКИНАМИ") );
    smd_btn:SizeToContentsX( self.innerPadding * 3 );
    smd_btn:SizeToContentsY( self.innerPadding * 2 );
    smd_btn:SetPos( self:GetWide() - self.innerPadding * 2 - rmd_btn:GetWide() - self.innerPadding - smd_btn:GetWide(), self:GetTall() - smd_btn:GetTall() - self.innerPadding * (self.DiscountNotifier.IsVisible(self.DiscountNotifier) and 4 or 2) - self.DiscountNotifier.GetTall(self.DiscountNotifier) );
    smd_btn:SetZPos( 1 );
    smd_btn.Paint = function( this, w, h )
        this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();

        local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_GOLDEN );

        surface.SetDrawColor( Color(0,0,0) );
        surface.DrawRect( 0, 0, w, h );

        local distsize  = math.sqrt( w*w + h*h );

        local parentalpha = self:GetAlpha() / 255;
        local alphamult   = this._alpha / 255;

        surface.SetAlphaMultiplier( parentalpha * alphamult );
            surface.SetDrawColor( RainbowColor );
            surface.DrawRect( 0, 0, w, h );

            surface.SetMaterial( rpui.GradientMat );
            surface.SetDrawColor( RainbowRotate );
            surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

            draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        surface.SetAlphaMultiplier( parentalpha * (1 - alphamult) );
            draw.SimpleText( this:GetText(), this:GetFont(), w * 0.5, h * 0.5, RainbowRotate, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
        surface.SetAlphaMultiplier( 1 );

        return true
    end
    self.SMDepositBtn.Think = function( this )
        if this.Timeout and (this.Timeout < SysTime()) then
            this:SetEnabled( true );
            this.Timeout = nil;
        end
    end
    self.SMDepositBtn.PaintOver = function( this, w, h )
        rpui.DrawStencilBorder( this, 0, 0, w, h, 0.06, RainbowColor, RainbowRotate, self:GetAlpha() / 255 );
    end
    self.SMDepositBtn.DoClick = function( this )
        this.Timeout = SysTime() + 5;
        this:SetEnabled( false );

        net.Start( "donations.buy" );
            net.WriteString( "points" );
            net.WriteInt( donations.getMethodByName("skins").id, 8 );
        net.SendToServer();
    end
    self:RegisterTooltip(
        self.SMDepositBtn,
        translates.Get("Есть скины CS:GO, Dota 2, Rust?") .. "\n" .. translates.Get("Пополни ими счёт в пару кликов!"),
        TOOLTIP_OFFSET_CENTER
    );

    self.ContentContainer = vgui.Create( "Panel", self );
    local cont_cont = self.ContentContainer;

    cont_cont:Dock( FILL );
    cont_cont:InvalidateParent( true );
    cont_cont.Frames = {};

    timer.Simple( FrameTime() * 5, function()
        if not IsValid(self) then return end

        if not self.OpenedCategory then
			if LocalPlayer().donateLastCatName and self.CategoriesMap[LocalPlayer().donateLastCatName] then
				self:OpenCategory( self.CategoriesMap[LocalPlayer().donateLastCatName] );
            elseif LocalPlayer().donateLastCategory then
                self:OpenCategory( LocalPlayer().donateLastCategory );
            else
                self:OpenCategory( 1 );
            end
        end
    end );


    self.DonateStats = vgui.Create( "Panel", self );
    local don_stats = self.DonateStats;

	don_stats:SetPos(self:GetWide() - self.frameW * 0.175 * 2 - self.innerPadding * 4, self.Header.GetTall(self.Header) + self.innerPadding * 2)
	don_stats:SetWide(self:GetWide())

    don_stats:SetTall( self.frameH * 0.085 );
    don_stats:SetAlpha( 0 );
    don_stats:InvalidateParent( true );

    self.DonateStats.TopDonators = vgui.Create( "Panel", self.DonateStats );
    local top_dons = self.DonateStats.TopDonators;

    top_dons:Dock( LEFT );
    top_dons:DockMargin( 0, 0, self.innerPadding * 2, 0 );
    top_dons:SetWide( self.frameW * 0.175 );
    top_dons:InvalidateParent( true );

    self.DonateStats.TopDonators.Label = vgui.Create( "DLabel", self.DonateStats.TopDonators );
    local top_dons_lab = self.DonateStats.TopDonators.Label;

    top_dons_lab:Dock( TOP );
    top_dons_lab:DockMargin( 0, 0, 0, self.innerPadding * 0.5 );
    top_dons_lab:SetTextColor( rpui.UIColors.White );
	top_dons_lab:SetContentAlignment(9)
    top_dons_lab:SetText( translates.Get("КОРОЛИ МЕСЯЦА") );
    top_dons_lab:SetFont( "rpui.Fonts.DonateMenu.DonateStats" );
    top_dons_lab:SizeToContentsY();
    top_dons_lab:InvalidateParent( true );

    self.DonateStats.TopDonators.Panel = vgui.Create( "DButton", self.DonateStats.TopDonators );
    local top_dons_pan = self.DonateStats.TopDonators.Panel;

    top_dons_pan:Dock( FILL );
    top_dons_pan:DockPadding( self.innerPadding, self.innerPadding, self.innerPadding, self.innerPadding );
    top_dons_pan:InvalidateParent( true );
    top_dons_pan.SwitchDelay  = 10;
    top_dons_pan.SwitchLength = 1 / 2;
    top_dons_pan.Think = function( this )
        if not rpui.DonateStats then return end

        if this.ID and (not this.SwitchTimeout) then
            local data = rpui.DonateStats["top_donators"][this.ID];
            if not data then return end

            this.Avatar.SetSteamID( this.Avatar, data["steamid64"], this.Avatar.GetTall(this.Avatar) );
            this.Amount.SetText( this.Amount, data["amount"] .. " " .. translates.Get("₽") );
            this.Amount.SizeToContentsX(this.Amount);
            this.Name.SetText( this.Name, string.utf8upper(data["rpname"]) );

            this.SwitchTimeout = SysTime() + this.SwitchDelay;
            this:AlphaTo( 0, this.SwitchLength, this.SwitchDelay - this.SwitchLength, function()
                if not IsValid(self) then return end

                this.Avatar.SetSteamID( this.Avatar, "" );

                this.ID            = (this.ID % #rpui.DonateStats["top_donators"]) + 1;
                this.SwitchTimeout = nil;

                this:AlphaTo( 255, this.SwitchLength );
            end );
        end
    end
    self.DonateStats.TopDonators.Panel.DoClick = function( this )
        self.Header.Balance.DoClick(self.Header.Balance);
    end
    self.DonateStats.TopDonators.Panel.Paint = function( this, w, h )
        local baseColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );

        if IsValid(this.Avatar) then
            if not this.BakedCircle then
                this.BakedCircle = rpui.BakeCircle( this.Avatar.x, this.Avatar.y, this.Avatar.GetTall(this.Avatar), 32 );
            end

            render.SetStencilWriteMask( 255 );
            render.SetStencilTestMask( 255 );
            render.SetStencilReferenceValue( 0 );
            render.SetStencilPassOperation( STENCIL_KEEP );
            render.SetStencilZFailOperation( STENCIL_KEEP );
            render.ClearStencil();
            render.SetStencilEnable( true );
            render.SetStencilReferenceValue( 1 );
            render.SetStencilCompareFunction( STENCIL_NEVER );
            render.SetStencilFailOperation( STENCIL_REPLACE );
                draw.NoTexture();
                surface.SetDrawColor( rpui.UIColors.White );
                surface.DrawPoly( this.BakedCircle );
            render.SetStencilCompareFunction( STENCIL_EQUAL );
            render.SetStencilFailOperation( STENCIL_KEEP );
                this.Avatar.PaintManual(this.Avatar);
            render.SetStencilEnable( false );
        end

        return true
    end

    self.DonateStats.TopDonators.Panel.Avatar = vgui.Create( "AvatarImage", self.DonateStats.TopDonators.Panel );
    local pan_ava = self.DonateStats.TopDonators.Panel.Avatar;

    pan_ava:Dock( LEFT );
    pan_ava:DockMargin( 0, 0, self.innerPadding, 0 );
    pan_ava:InvalidateParent( true );
    pan_ava:SetMouseInputEnabled( false );
    pan_ava:SetWide( pan_ava:GetTall() );
    pan_ava:SetPaintedManually( true );

    self.DonateStats.TopDonators.Panel.Amount = vgui.Create( "DLabel", self.DonateStats.TopDonators.Panel );
    local pan_amt = self.DonateStats.TopDonators.Panel.Amount;

    pan_amt:Dock( RIGHT );
    pan_amt:DockMargin( self.innerPadding, 0, 0, 0 );
    pan_amt:InvalidateParent( true );
    pan_amt:SetMouseInputEnabled( false );
    pan_amt:SetContentAlignment( 6 );
    pan_amt:SetTextColor( rpui.UIColors.White );
    pan_amt:SetText( ";p" );
    pan_amt:SetFont( "rpui.Fonts.DonateMenu.DonateStatsSmall" );
    pan_amt:SizeToContentsX();

    self.DonateStats.TopDonators.Panel.Name = vgui.Create( "DLabel", self.DonateStats.TopDonators.Panel );
    local pan_name = self.DonateStats.TopDonators.Panel.Name;

    pan_name:Dock( FILL );
    pan_name:InvalidateParent( true );
    pan_name:SetMouseInputEnabled( false );
    pan_name:SetContentAlignment( 5 );
    pan_name:SetTextColor( rpui.UIColors.White );
    pan_name:SetText( "" );
    pan_name:SetFont( "rpui.Fonts.DonateMenu.DonateStatsSmall" );

    self.DonateStats.LastPurchased = vgui.Create( "Panel", self.DonateStats );
    local don_last_p = self.DonateStats.LastPurchased;

    don_last_p:Dock( LEFT );
    don_last_p:SetWide( self.frameW * 0.175 );
    don_last_p:InvalidateParent( true );

    self.DonateStats.LastPurchased.Label = vgui.Create( "DLabel", self.DonateStats.LastPurchased );
    local last_p_lab = self.DonateStats.LastPurchased.Label;

    last_p_lab:Dock( TOP );
    last_p_lab:DockMargin( 0, 0, 0, self.innerPadding * 0.5 );
    last_p_lab:SetTextColor( rpui.UIColors.White );
    last_p_lab:SetText( translates.Get("ПОСЛЕДНИЕ ПОКУПКИ") );
	last_p_lab:SetContentAlignment(9)
    last_p_lab:SetFont( "rpui.Fonts.DonateMenu.DonateStats" );
    last_p_lab:SizeToContentsY();
    last_p_lab:InvalidateParent( true );

    self.DonateStats.LastPurchased.Panel = vgui.Create( "DButton", self.DonateStats.LastPurchased );
    local last_p_pan = self.DonateStats.LastPurchased.Panel;

    last_p_pan:Dock( FILL );
    last_p_pan:DockPadding( self.innerPadding, self.innerPadding, self.innerPadding, self.innerPadding );
    last_p_pan:InvalidateParent( true );
    last_p_pan.SwitchDelay  = 5;
    last_p_pan.SwitchLength = 1 / 2;
    last_p_pan.Think = function( this )
        if not rpui.DonateStats then return end

        if this.ID and (not this.SwitchTimeout) then
            local data = rpui.DonateStats["last_purchases"][this.ID];

            if not data then
                if IsValid(last_p_lab) then
                    last_p_lab:Remove()
                end

                this:Remove()
                return
            end

            this.Avatar.SetSteamID( this.Avatar, data["steamid64"], this.Avatar.GetTall(this.Avatar) );
            this.Name.SetText( this.Name, string.utf8upper(data["rpname"]) .. " " .. translates.Get("КУПИЛ") .. ":" );
            this.Upgrade.SetText( this.Upgrade, string.utf8upper( (rp.shop.GetByUID(data["upgrade"]) or {}).Name or "??") );

            this.SwitchTimeout = SysTime() + this.SwitchDelay;
            this:AlphaTo( 0, this.SwitchLength, this.SwitchDelay - this.SwitchLength, function()
                if not IsValid(self) then return end

                this.ID            = (this.ID % #rpui.DonateStats["last_purchases"]) + 1;
                this.SwitchTimeout = nil;

                this:AlphaTo( 255, this.SwitchLength );
            end );
        end
    end
    self.DonateStats.LastPurchased.Panel.DoClick = function( this )
        if this.ID then
            self:FindUpgrade( rpui.DonateStats["last_purchases"][this.ID]["upgrade"] );
        end
    end
    self.DonateStats.LastPurchased.Panel.Paint = function( this, w, h )
        local baseColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
        surface.SetDrawColor( baseColor );
        surface.DrawRect( 0, 0, w, h );

        if IsValid(this.Avatar) then
            if not this.BakedCircle then
                this.BakedCircle = rpui.BakeCircle( this.Avatar.x, this.Avatar.y, this.Avatar.GetTall(this.Avatar), 32 );
            end

            render.SetStencilWriteMask( 255 );
            render.SetStencilTestMask( 255 );
            render.SetStencilReferenceValue( 0 );
            render.SetStencilPassOperation( STENCIL_KEEP );
            render.SetStencilZFailOperation( STENCIL_KEEP );
            render.ClearStencil();
            render.SetStencilEnable( true );
            render.SetStencilReferenceValue( 1 );
            render.SetStencilCompareFunction( STENCIL_NEVER );
            render.SetStencilFailOperation( STENCIL_REPLACE );
                draw.NoTexture();
                surface.SetDrawColor( rpui.UIColors.White );
                surface.DrawPoly( this.BakedCircle );
            render.SetStencilCompareFunction( STENCIL_EQUAL );
            render.SetStencilFailOperation( STENCIL_KEEP );
                this.Avatar.PaintManual(this.Avatar);
            render.SetStencilEnable( false );
        end

        return true
    end

    self.DonateStats.LastPurchased.Panel.Avatar = vgui.Create( "AvatarImage", self.DonateStats.LastPurchased.Panel );
    local last_p_ava = self.DonateStats.LastPurchased.Panel.Avatar;

    last_p_ava:Dock( LEFT );
    last_p_ava:DockMargin( 0, 0, self.innerPadding, 0 );
    last_p_ava:InvalidateParent( true );
    last_p_ava:SetMouseInputEnabled( false );
    last_p_ava:SetWide( last_p_ava:GetTall() );
    last_p_ava:SetPaintedManually( true );

    self.DonateStats.LastPurchased.Panel.Name = vgui.Create( "DLabel", self.DonateStats.LastPurchased.Panel );
    local last_p_name = self.DonateStats.LastPurchased.Panel.Name;

    last_p_name:Dock( TOP );
    last_p_name:InvalidateParent( true );
    last_p_name:SetTall( last_p_ava:GetTall() * 0.5 );
    last_p_name:SetMouseInputEnabled( false );
    last_p_name:SetContentAlignment( 1 );
    last_p_name:SetTextColor( rpui.UIColors.White );
    last_p_name:SetText( "" );
    last_p_name:SetFont( "rpui.Fonts.DonateMenu.DonateStatsSmall" );

    self.DonateStats.LastPurchased.Panel.Upgrade = vgui.Create( "DLabel", self.DonateStats.LastPurchased.Panel );
    local last_p_upg = self.DonateStats.LastPurchased.Panel.Upgrade;

    last_p_upg:Dock( TOP );
    last_p_upg:InvalidateParent( true );
    last_p_upg:SetTall( last_p_ava:GetTall() * 0.5 );
    last_p_upg:SetMouseInputEnabled( false );
    last_p_upg:SetContentAlignment( 7 );
    last_p_upg:SetTextColor( rpui.UIColors.White );
    last_p_upg:SetText( "" );
    last_p_upg:SetFont( "rpui.Fonts.DonateMenu.DonateStatsSmall" );
    last_p_upg:SizeToContentsX();

    http.Fetch( "http://api.urf.im/handler/menu/donate_stats.php?server=" .. rp.cfg.ServerUID,
        function( body )
            rpui.DonateStats = util.JSONToTable(body);
            if not IsValid(self) then return end

            if not rpui.DonateStats then
                self.DonateStats.SetTall( self.DonateStats, 0 );
                self.DonateStats.DockMargin( self.DonateStats, 0, 0, 0, self.innerPadding );

                return
            end

            local new_last_purchases = {}

            for k, v in pairs(rpui.DonateStats["last_purchases"]) do
                if (rp.shop.GetByUID(v["upgrade"]) or {}).Name then
                    table.insert(new_last_purchases, v)
                end
            end

            rpui.DonateStats["last_purchases"] = new_last_purchases

            self.DonateStats.TopDonators.Panel.ID   = 1;
            self.DonateStats.LastPurchased.Panel.ID = 1;

            self.DonateStats.AlphaTo( self.DonateStats, 255, 0.25 );
        end
    );
end

net.Receive('Promocode::UseResult', function()
    local result = net.ReadUInt(4)

    if not IsValid(rpui.DonateMenu) or not IsValid(rpui.DonateMenu.PromocodePanel) then
        return
    end

    if result == 3 then
        rpui.DonateMenu.PromocodePanel.Close(rpui.DonateMenu.PromocodePanel);
    else
        rpui.DonateMenu.PromocodePanel.RetardAlert = 1;

        if result == 0 then
            rpui.DonateMenu.PromocodePanel.DescriptionT.SetText(rpui.DonateMenu.PromocodePanel.DescriptionT, translates and translates.Get("Пожалуйста, подождите") or "Пожалуйста, подождите")
            rpui.DonateMenu.PromocodePanel.DescriptionB.SetText(rpui.DonateMenu.PromocodePanel.DescriptionB, translates and translates.Get("Выполняется транзакция") or "Выполняется транзакция")

        elseif result == 1 then
            rpui.DonateMenu.PromocodePanel.DescriptionT.SetText(rpui.DonateMenu.PromocodePanel.DescriptionT, translates and translates.Get("Данный промокод только") or "Данный промокод только")
            rpui.DonateMenu.PromocodePanel.DescriptionB.SetText(rpui.DonateMenu.PromocodePanel.DescriptionB, translates and translates.Get("для новых игроков") or "для новых игроков")

        elseif result == 2 then
            rpui.DonateMenu.PromocodePanel.DescriptionT.SetText(rpui.DonateMenu.PromocodePanel.DescriptionT, translates and translates.Get("Техническая ошибка") or "Техническая ошибка")
            rpui.DonateMenu.PromocodePanel.DescriptionB.SetText(rpui.DonateMenu.PromocodePanel.DescriptionB, translates and translates.Get("Свяжитесь с менеджером") or "Свяжитесь с менеджером")

        elseif result == 4 then
            rpui.DonateMenu.PromocodePanel.DescriptionT.SetText(rpui.DonateMenu.PromocodePanel.DescriptionT, translates and translates.Get("Вы уже использовали") or "Вы уже использовали")
            rpui.DonateMenu.PromocodePanel.DescriptionB.SetText(rpui.DonateMenu.PromocodePanel.DescriptionB, translates and translates.Get("промо для новичков") or "промо для новичков")

        elseif result == 5 then
            rpui.DonateMenu.PromocodePanel.DescriptionT.SetText(rpui.DonateMenu.PromocodePanel.DescriptionT, translates and translates.Get("Вы уже использовали") or "Вы уже использовали")
            rpui.DonateMenu.PromocodePanel.DescriptionB.SetText(rpui.DonateMenu.PromocodePanel.DescriptionB, translates and translates.Get("этот промокод") or "этот промокод")

        elseif result == 6 then
            rpui.DonateMenu.PromocodePanel.DescriptionT.SetText(rpui.DonateMenu.PromocodePanel.DescriptionT, translates and translates.Get("Данный промокод") or "Данный промокод")
            rpui.DonateMenu.PromocodePanel.DescriptionB.SetText(rpui.DonateMenu.PromocodePanel.DescriptionB, translates and translates.Get("не существует!") or "не существует!")

        elseif result == 7 then
            rpui.DonateMenu.PromocodePanel.DescriptionT.SetText(rpui.DonateMenu.PromocodePanel.DescriptionT, translates and translates.Get("Кол-во активаций") or "Кол-во активаций")
            rpui.DonateMenu.PromocodePanel.DescriptionB.SetText(rpui.DonateMenu.PromocodePanel.DescriptionB, translates and translates.Get("промокода истекло") or "промокода истекло")

        elseif result == 8 then
            rpui.DonateMenu.PromocodePanel.DescriptionT.SetText(rpui.DonateMenu.PromocodePanel.DescriptionT, translates and translates.Get("Данный промокод") or "Данный промокод")
            rpui.DonateMenu.PromocodePanel.DescriptionB.SetText(rpui.DonateMenu.PromocodePanel.DescriptionB, translates and translates.Get("более недействителен") or "более недействителен")
        end
    end
end)

function PANEL:Think()
    if not input.IsKeyDown(KEY_F4) then self.CanClose = true; end

    if self.Header.Balance.SavedBalance and self.Header.Balance.SavedBalance ~= LocalPlayer():GetCredits() then
        self.Header.Balance.SavedBalance = LocalPlayer():GetCredits()
        rp.RunCommand("upgrades")
    end

    if (input.IsKeyDown(KEY_ESCAPE) or ((input.IsKeyDown(KEY_F4) or (input.IsKeyDown(KEY_X) and not (IsValid(self.PromocodePanel) and IsValid(self.PromocodePanel.InputContainer.Input) and self.PromocodePanel.InputContainer.Input.HasFocus(self.PromocodePanel.InputContainer.Input)))) and self.CanClose)) and !self.Closing then
        gui.HideGameUI();
        if IsValid( rpui.ESCMenu ) then rpui.ESCMenu.HideMenu(rpui.ESCMenu); end
        self:Close();
    end
end


function PANEL:Close()
    if not self.Closing then
        self.Closing = true;

        if self.OpenedCategory and IsValid(self.OpenedCategory.IconViewer) then
            self.OpenedCategory.IconViewer.Remove(self.OpenedCategory.IconViewer);
        end

        self:AlphaTo( 0, 0.25, 0, function()
            if IsValid( self ) then self:Remove(); end
        end );
    end
end


function PANEL:SetData( data_tbl )
    self.ShopData = data_tbl;
end


function PANEL:SetCategories( categories_tbl )
    self.Categories    = categories_tbl;

    self.CategoriesMap = {};
    for k6, v6 in pairs( self.Categories ) do self.CategoriesMap[v6] = k6; end

    local buttonHeight = math.floor(self.MenuContainer.GetTall(self.MenuContainer) / #self.Categories);

    for k7, v7 in ipairs( self.Categories ) do
        self.categoryCreationFuncs[v7] = self.categoryCreationFuncs[v7] or {};

        self.MenuContainer.Buttons[k7] = vgui.Create( "DButton", self.MenuContainer );
        self.MenuContainer.Buttons[k7].Base = self;
        local btn = self.MenuContainer.Buttons[k7]

        btn:Dock( TOP );
        btn:DockMargin( 0, 0, 0, 0 );
        btn:SetTall( buttonHeight );
        btn:SetFont( "rpui.Fonts.DonateMenu.MenuButton" );
        btn:SetText( string.utf8upper(v7) );
        btn.Paint = function( this, w, h )
            if self.categoryCreationFuncs[v7] then
                if self.categoryCreationFuncs[v7].MenuPaint then
                    self.categoryCreationFuncs[v7].MenuPaint( this, w, h );
                    return true
                end
            end

            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE_INVERTED );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );

            draw.SimpleText( this:GetText(), this.Selected and "rpui.Fonts.DonateMenu.MenuButtonBold" or "rpui.Fonts.DonateMenu.MenuButton", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            return true
        end
        self.MenuContainer.Buttons[k7].PaintOver = function( this, w, h )
            if self.categoryCreationFuncs[v7] then
                if self.categoryCreationFuncs[v7].MenuPaintOver then
                    self.categoryCreationFuncs[v7].MenuPaintOver( this, w, h );
                    return true
                end
            end
        end
        self.MenuContainer.Buttons[k7].DoClick = function( this )
            if this.Selected then return end

            for k8, v8 in pairs( self.MenuContainer.Buttons ) do v8.Selected = false; end
            this.Selected = true;

            self:OpenCategory( k7 );
        end

        self.ContentContainer.Frames[k7] = vgui.Create( "Panel", self.ContentContainer );
        local fr = self.ContentContainer.Frames[k7];

        fr:SetSize( self.ContentContainer.GetSize(self.ContentContainer) );
        fr:SetVisible( false );
        fr:SetAlpha( 0 );

        local frame    = self.ContentContainer.Frames[k7];
        local frW, frH = frame:GetSize();

        if self.categoryCreationFuncs[v7].FrameCreation then
            self.categoryCreationFuncs[v7].FrameCreation(frame, frW, frH, self.MenuContainer.Buttons[k7]);
            continue
        end

        frame.Items = vgui.Create( "rpui.ScrollPanel", frame );
        local items = frame.Items;

        items:Dock( LEFT );
        items:SetWide( frW * 0.25 );
        items:SetScrollbarMargin( self.innerPadding * 0.8 );
        items:InvalidateParent( true );
        items.Buttons = {};

        frame.Information = vgui.Create( "Panel", frame );
        local info = frame.Information;

        info:Dock( RIGHT );
        info:SetWide( frW * 0.4 );
        info:SetAlpha( 0 );
        info:InvalidateParent( true );

        frame.Information.Data = vgui.Create( "Panel", frame.Information );
        local data = frame.Information.Data;

        data:SetWide( info:GetWide() );
        data:InvalidateParent( true );

        frame.Information.Data.Name = vgui.Create( "DLabel", frame.Information.Data );
        local data_name = frame.Information.Data.Name;

        data_name:Dock( TOP );
        data_name:DockMargin( 0, 0, 0, self.innerPadding * 0.1 );
        data_name:SetWrap( true );
        data_name:SetFont( "rpui.Fonts.DonateMenu.ItemMedium" );
        data_name:SetTextColor( rpui.UIColors.White );
        data_name:SetText( "ItemInfo.Upgrade.Name" );
        data_name:InvalidateParent( true );

        frame.Information.Data.PriceContainer = vgui.Create( "Panel", frame.Information.Data );
        local price = frame.Information.Data.PriceContainer;

        price:Dock( TOP );
        price:DockMargin( 0, 0, 0, self.innerPadding );
        price:InvalidateParent( true );

        frame.Information.Data.PriceContainer.OldPrice = vgui.Create( "DLabel", frame.Information.Data.PriceContainer );
        local old_pr = frame.Information.Data.PriceContainer.OldPrice;

        old_pr:Dock( LEFT );
        old_pr:DockMargin( 0, 0, self.innerPadding, 0 );
        old_pr:SetFont( "rpui.Fonts.DonateMenu.ItemSmall" );
        old_pr:SetTextColor( rpui.UIColors.White );
        old_pr:SetText( "999 РУБ" );
        old_pr:SizeToContentsX();
        old_pr:InvalidateParent( true );
        old_pr.PaintOver = function( this, w, h )
            surface.SetDrawColor( rpui.UIColors.White );
            surface.DrawRect( 0, h * 0.5 - h * 0.025, w, h * 0.05 );
        end

        frame.Information.Data.PriceContainer.NewPrice = vgui.Create( "DLabel", frame.Information.Data.PriceContainer );
        local new_pr = frame.Information.Data.PriceContainer.NewPrice;

        new_pr:Dock( LEFT );
        new_pr:SetWrap( true );
        new_pr:SetFont( "rpui.Fonts.DonateMenu.ItemMedium" );
        new_pr:SetTextColor( rpui.UIColors.White );
        new_pr:SetText( "999 РУБ" );
        new_pr:SizeToContentsX();
        new_pr:InvalidateParent( true );

        price:SizeToChildren( false, true );

        frame.Information.Data.Description = vgui.Create( "DLabel", frame.Information.Data );
        local dat_desc = frame.Information.Data.Description;

        dat_desc:Dock( TOP );
        dat_desc:DockMargin( 0, 0, 0, self.innerPadding );
        dat_desc:SetWrap( true );
        dat_desc:SetFont( "rpui.Fonts.DonateMenu.ItemSmall" );
        dat_desc:SetTextColor( rpui.UIColors.White );
        dat_desc:SetText( "ItemInfo.Upgrade.Desc" );
        dat_desc:InvalidateParent( true );

        frame.Information.Data.PurchaseContainer = vgui.Create( "Panel", frame.Information.Data );
        local purch = frame.Information.Data.PurchaseContainer;

        purch:Dock( TOP );
        purch:SetTall( self.frameH * 0.085 );
        purch:InvalidateParent( true );

        frame.Information.Data.PurchaseContainer.Real = vgui.Create( "DButton", frame.Information.Data.PurchaseContainer );
        local purch_real = frame.Information.Data.PurchaseContainer.Real;

        purch_real:Dock( LEFT );
        purch_real:SetWide( purch:GetWide() * 0.5 - self.innerPadding * 0.5 );
        purch_real:SetFont( "rpui.Fonts.DonateMenu.PurchaseButton" );
        purch_real:SetText( translates.Get("КУПИТЬ") );
        purch_real.Paint = function( this, w, h )
            surface.SetFont( this:GetFont() );
            local tW, tH = surface.GetTextSize(" ");

            this.WrappedText = string.Wrap( this:GetFont(), this:GetText(), w - self.innerPadding * 2 );

            this.TextHeight        = tH;
            this.WrappedTextHeight = #this.WrappedText * tH;

            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );

            for k9, text9 in ipairs( this.WrappedText ) do
                draw.SimpleText( text9, this:GetFont(), w * 0.5, h * 0.5 - this.WrappedTextHeight * 0.5 + (k9-1) * this.TextHeight, textColor, TEXT_ALIGN_CENTER );
            end
            return true
        end
        frame.Information.Data.PurchaseContainer.Real.DoClick = function( this, w, h )
            if frame.Information.Data.PurchaseContainer.CantBuyMode then
                self:CreateDepositPanel( self.Header.Balance );
                return
            end

            if not this.Timeout then
                this.Timeout = SysTime() + 5;
                this:SetText( translates.Get("ПОДТВЕРДИТЕ") );
                frame.Information.Data.PurchaseContainer.InGame.Timeout = 0;
            else
                rp.RunCommand( "buyupgrade", tostring(frame.Information.Data.PurchaseContainer.UpgradeID) );
                this:SetText( translates.Get("ПОКУПКА...") );
                this:SetDisabled( true );
                self.Foreground.SetZPos( self.Foreground, 228 );
                self.Header.CloseButton.MoveToFront(self.Header.CloseButton);
            end
        end
        frame.Information.Data.PurchaseContainer.Real.Think = function( this, w, h )
            if not frame.Information.Data.PurchaseContainer.CantBuyMode and this.Timeout and (this.Timeout < SysTime()) then
                this:SetText( translates.Get("КУПИТЬ") );
                this.Timeout = nil;
            end
        end

        frame.Information.Data.PurchaseContainer.InGame = vgui.Create( "DButton", frame.Information.Data.PurchaseContainer );
        local ingame = frame.Information.Data.PurchaseContainer.InGame;

        ingame:Dock( RIGHT );
        ingame:SetWide( purch:GetWide() * 0.5 - self.innerPadding * 0.5 );
        ingame:SetFont( "rpui.Fonts.DonateMenu.PurchaseButton" );
        ingame:SetText( translates.Get("КУПИТЬ ЗА\n%s", rp.FormatMoney(0)) );
        ingame.Paint = function( this, w, h )
            surface.SetFont( this:GetFont() );
            local tW, tH = surface.GetTextSize(" ");

            this.WrappedText = string.Wrap( this:GetFont(), this:GetText(), w - self.innerPadding * 2 );

            this.TextHeight        = tH;
            this.WrappedTextHeight = #this.WrappedText * tH;

            local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_INVERTED );
            surface.SetDrawColor( baseColor );
            surface.DrawRect( 0, 0, w, h );

            for k0, text0 in ipairs( this.WrappedText ) do
                draw.SimpleText( text0, this:GetFont(), w * 0.5, h * 0.5 - this.WrappedTextHeight * 0.5 + (k0-1) * this.TextHeight, textColor, TEXT_ALIGN_CENTER );
            end
            return true
        end
        frame.Information.Data.PurchaseContainer.InGame.DoClick = function( this, w, h )
            if not this.Timeout then
                this.Timeout = SysTime() + 5;
                this:SetText( translates.Get("ПОДТВЕРДИТЕ") );
                frame.Information.Data.PurchaseContainer.Real.Timeout = 0;
            else
                rp.RunCommand( "altbuyupgrade", tostring(frame.Information.Data.PurchaseContainer.UpgradeID) );
                this:SetText( translates.Get("ПОКУПКА...") );
                this:SetDisabled( true );
                self.Foreground.SetZPos( self.Foreground, 228 );
            end
        end
        frame.Information.Data.PurchaseContainer.InGame.Think = function( this, w, h )
            if this.Timeout and (this.Timeout < SysTime()) then
                this:SetText( this.Text );
                this.Timeout = nil;
            end
        end

        if self.categoryCreationFuncs[v7] and self.categoryCreationFuncs[v7].LayoutInformation then
            self.categoryCreationFuncs[v7].LayoutInformation( frame.Information.Data );

		elseif self.categoryCreationFuncs[translates.Get(v7)] and self.categoryCreationFuncs[translates.Get(v7)].LayoutInformation then
            self.categoryCreationFuncs[translates.Get(v7)].LayoutInformation( frame.Information.Data );
        end

        frame.Information.RefundInfo = vgui.Create( "DButton", frame.Information );
        local refund = frame.Information.RefundInfo;

        refund:SetFont( "rpui.Fonts.DonateMenu.ItemSmall" );
        refund:SetTextColor( rpui.UIColors.White );
        refund:SetText( translates.Get("ПЕРЕДУМАЛИ? МОЖНО ВЕРНУТЬ!") );
        refund:SizeToContents();
        refund.Paint = function( this, w, h )
            this._alpha = math.Approach( this._alpha or 0, this:IsHovered() and 255 or 69, FrameTime() * 768 );
            draw.SimpleText( this:GetText(), this:GetFont(), 0, 0, Color(255,255,255,this._alpha) );
            return true
        end
        frame.Information.RefundInfo.DoClick = function( this )
            gui.OpenURL( rp.cfg.ConsultUrl );
        end
        self:RegisterTooltip(
            frame.Information.RefundInfo,
            translates.Get("Передумали? Мы вернём Вам кредиты в\nтечение 48 часов с момента покупки!\n\nНажмите на этот текст, чтобы обратиться\nк консультанту."),
            TOOLTIP_OFFSET_CENTER
        );

        frame.IconViewer = vgui.Create( "DModelPanel", frame );
        local icon_v = frame.IconViewer;

        icon_v:SetSize(
            frame:GetWide() - (frame:GetWide() - (self.MenuContainer.GetWide(self.MenuContainer) + frame.Information.Data.GetWide(frame.Information.Data))) * 0.5,
            frame:GetTall()
        );
        icon_v:SetPos( 0, 0 );
        icon_v:SetModel( "models/error.mdl" );
        icon_v:SetZPos( -1 );
        icon_v:SetFOV( 45 );
        icon_v:SetVisible( false );
        icon_v.CamAngles = Angle( 0, 0, 0 );
        icon_v.xVelocity = 0;
        icon_v.rDistance = 0;
        icon_v.LayoutEntity = function( this, ent )
            if not IsValid(ent) then return end

            local mins, maxs = ent:GetModelBounds();
            local r = (-mins + maxs):Length();

            local depth = this.viewDepthoffset and this.viewDepthoffset / 100 or 0

            this.xVelocity = 0.95 * this.xVelocity;
            this.rDistance = math.Clamp( this.rDistance + this.xVelocity, r * 1.65, r * 2.5 );

            local offset = this.viewZoffset and this.viewZoffset / 100 or 0
            local obbCenter = Vector( (mins.x + maxs.x) * 0.5, (mins.y + maxs.y) * 0.5, (mins.z + maxs.z) * 0.55  - maxs.z * offset );

            this.CamAngles.yaw = this.CamAngles.yaw + (25 * FrameTime());

            this:SetCamPos( obbCenter + this.CamAngles.Forward(this.CamAngles) * this.rDistance * (1 + depth) );
            this:SetLookAt( obbCenter );

            return
        end

        icon_v.DrawModel = function(iconv)
            iconv.Entity.DrawModel(iconv.Entity)

            if iconv.Hat then
                rp.hats.Render(iconv.Entity, iconv.Hat)
            end
        end

        frame.IconViewer.Controller = vgui.Create( "Panel", frame );
        local icon_cont = frame.IconViewer.Controller;

        icon_cont:Dock( FILL );
        icon_cont.OnMouseWheeled = function( this, scrollDelta )
            frame.IconViewer.xVelocity = frame.IconViewer.xVelocity - (scrollDelta);
        end

        local ItemsContent = vgui.Create( "Panel", frame.Items );
        ItemsContent:Dock( TOP );
        ItemsContent:InvalidateParent( true );
        for _, ItemInfo in pairs( self.ShopData.Categories[k7].Upgrades ) do
            local ItemButton = vgui.Create( "DButton", ItemsContent );
            ItemButton:Dock( TOP );
            ItemButton:DockMargin( 0, 0, 0, self.innerPadding );
            ItemButton:SetTall( frH * 0.085 );
            ItemButton:SetFont( "rpui.Fonts.DonateMenu.ItemButton" );
            ItemButton:SetText( string.utf8upper(ItemInfo.Upgrade.Name) );
            ItemButton.UpgradeID = ItemInfo.Upgrade.ID;
            ItemButton.DoClick = function( this )
                if frame.Items.Selected == this then return end
                for k11, v11 in pairs( frame.Items.Buttons ) do v11.Selected = false; end

                frame.Items.Selected = this;
                this.Selected        = true;

                frame.Information.Stop(frame.Information);
                frame.Information.SetAlpha( frame.Information, 0 );
                frame.Information.AlphaTo( frame.Information, 255, 0.5 );

                frame.Information.Data.Name.SetText( frame.Information.Data.Name, string.utf8upper(string.Trim(ItemInfo.Upgrade.Name)) );
                frame.Information.Data.Name.InvalidateLayout( frame.Information.Data.Name, true );
                frame.Information.Data.Name.SizeToContentsY(frame.Information.Data.Name);

                if self.categoryCreationFuncs[v7].HidePrice then
                    frame.Information.Data.PriceContainer.SetVisible( frame.Information.Data.PriceContainer, false );
                else
                    frame.Information.Data.PriceContainer.SetVisible( frame.Information.Data.PriceContainer, true );
                end

                if self.categoryCreationFuncs[v7].HideRefund or not (ItemInfo.IsBuyable and (LocalPlayer():GetCredits() >= ItemInfo.Price) or self.ShopData.CanRefund[ItemInfo.Upgrade.ID]) then
                    frame.Information.RefundInfo.SetVisible( frame.Information.RefundInfo, false );
                else
                    frame.Information.RefundInfo.SetVisible( frame.Information.RefundInfo, not rp.cfg.DonateRefundsDisabled );
                end

                frame.Information.Data.PriceContainer.OldPrice.SetWide( frame.Information.Data.PriceContainer.OldPrice, 0 );
                frame.Information.Data.PriceContainer.OldPrice.DockMargin( frame.Information.Data.PriceContainer.OldPrice, 0, 0, 0, 0 );

                frame.Information.Data.PurchaseContainer.SetVisible( frame.Information.Data.PurchaseContainer, false );
                frame.Information.Data.PurchaseContainer.UpgradeID = ItemInfo.Upgrade.ID;
                frame.Information.Data.PurchaseContainer.CantBuyMode = utf8.find(ItemInfo.Reason, "Вы не можете купить");

                if ItemInfo.IsBuyable or frame.Information.Data.PurchaseContainer.CantBuyMode then
                    if ItemInfo.Upgrade.Price then
                        if ItemInfo.Price ~= ItemInfo.Upgrade.Price then
                            local current_discount = math.max(rp.GetDiscount() or 0, ItemInfo.Upgrade.Discount or 0)
                            local default_price

                            if current_discount > 0 then
                                default_price = math.floor(ItemInfo.Price / (1 - current_discount))
                            else
                                default_price = ItemInfo.Upgrade.Price
                            end

                            if default_price > ItemInfo.Price then
                                local old_pri = frame.Information.Data.PriceContainer.OldPrice;
                                old_pri:SetText( default_price .. " " .. translates.Get("РУБ") );
                                old_pri:SizeToContentsX();
                                old_pri:DockMargin( 0, 0, self.innerPadding, 0 );
                            end
                        end
                    end

                    local new_pri = frame.Information.Data.PriceContainer.NewPrice;

                    new_pri:Dock( LEFT );
                    new_pri:SetWrap( false );
                    new_pri:SetText( (ItemInfo.Price or "N/A") .. " " .. translates.Get("РУБ") );
                    new_pri:SizeToContentsX();

                    frame.Information.Data.PurchaseContainer.SetVisible( frame.Information.Data.PurchaseContainer, true );
                    frame.Information.Data.PurchaseContainer.Real.SetText( frame.Information.Data.PurchaseContainer.Real, frame.Information.Data.PurchaseContainer.CantBuyMode and translates.Get("ПОПОЛНИТЬ СЧЁТ") or translates.Get("КУПИТЬ") );
                else
                    local new_pri = frame.Information.Data.PriceContainer.NewPrice;

                    new_pri:Dock( NODOCK );
                    new_pri:SetPos( 0, 0 );
                    new_pri:SetWrap( true );
                    new_pri:SetText( ItemInfo.Reason );
                    new_pri:SetWide( frame.Information.Data.PriceContainer.GetWide(frame.Information.Data.PriceContainer) );
                    new_pri:InvalidateLayout( true );
                    new_pri:SizeToContentsY();
                end

                frame.Information.Data.PriceContainer.InvalidateParent( frame.Information.Data.PriceContainer, true );
                frame.Information.Data.PriceContainer.SizeToChildren( frame.Information.Data.PriceContainer, false, true );

                frame.Information.Data.PurchaseContainer.Real.Timeout   = 0;
                frame.Information.Data.PurchaseContainer.InGame.Timeout = 0;

                frame.Information.Data.Description.SetText( frame.Information.Data.Description, string.utf8upper(string.Trim(ItemInfo.Upgrade.Desc)) );
                frame.Information.Data.Description.InvalidateLayout( frame.Information.Data.Description, true );
                frame.Information.Data.Description.SizeToContentsY(frame.Information.Data.Description);

                local alt_pr = ItemInfo.AltPrice or self.ShopData.NotBuyableAltPrice[ItemInfo.Upgrade.ID]

                if alt_pr then
                    frame.Information.Data.Description.SetText( frame.Information.Data.Description, frame.Information.Data.Description.GetText(frame.Information.Data.Description) .. '\n\n' .. translates.Get("АЛЬТЕРНАТИВНАЯ ЦЕНА: %s", rp.FormatMoney(alt_pr)) );
                    frame.Information.Data.Description.InvalidateLayout( frame.Information.Data.Description, true );
                    frame.Information.Data.Description.SizeToContentsY(frame.Information.Data.Description);
                end

                if alt_pr and alt_pr <= LocalPlayer():GetMoney() then
                    local show_purchase = ItemInfo.Price and ItemInfo.Price <= LocalPlayer():GetCredits()

                    frame.Information.Data.PurchaseContainer.Real.SetWide( frame.Information.Data.PurchaseContainer.Real, show_purchase and (frame.Information.Data.PurchaseContainer.GetWide(frame.Information.Data.PurchaseContainer) * 0.5 - self.innerPadding * 0.5) or 0 );

                    frame.Information.Data.PurchaseContainer.InGame.Text = translates.Get("КУПИТЬ ЗА\n%s", rp.FormatMoney(alt_pr));
                    frame.Information.Data.PurchaseContainer.InGame.SetText( frame.Information.Data.PurchaseContainer.InGame, frame.Information.Data.PurchaseContainer.InGame.Text );
                    frame.Information.Data.PurchaseContainer.InGame.Show(frame.Information.Data.PurchaseContainer.InGame);
                    frame.Information.Data.PurchaseContainer.InGame.SetWide(frame.Information.Data.PurchaseContainer.InGame, show_purchase and (frame.Information.Data.PurchaseContainer.GetWide(frame.Information.Data.PurchaseContainer) * 0.5 - self.innerPadding * 0.5) or frame.Information.Data.PurchaseContainer.GetWide(frame.Information.Data.PurchaseContainer) );
                else
                    frame.Information.Data.PurchaseContainer.Real.SetWide( frame.Information.Data.PurchaseContainer.Real, frame.Information.Data.PurchaseContainer.GetWide(frame.Information.Data.PurchaseContainer) );
                    frame.Information.Data.PurchaseContainer.InGame.Hide(frame.Information.Data.PurchaseContainer.InGame);
                end

                if self.categoryCreationFuncs[v7].PurchaseButton then
                    if self.categoryCreationFuncs[v7].PurchaseButton.Real then
                        self.categoryCreationFuncs[v7].PurchaseButton.Real( ItemInfo, frame.Information.Data.PurchaseContainer.Real );
                    end

                    if self.categoryCreationFuncs[v7].PurchaseButton.InGame then
                        self.categoryCreationFuncs[v7].PurchaseButton.InGame( ItemInfo, frame.Information.Data.PurchaseContainer.InGame );
                    end
                end

                if IsValid(frame.IconViewer) then
                    if ItemInfo.Upgrade.Icon or ItemInfo.Upgrade.Hat then

                        frame.IconViewer.Hat = ItemInfo.Upgrade.Hat;
                        frame.IconViewer.SetModel( frame.IconViewer, ItemInfo.Upgrade.Icon or LocalPlayer():GetModel() );

						frame.IconViewer.viewZoffset = nil
						frame.IconViewer.viewDepthoffset = nil

                        if ItemInfo.Upgrade.Team then
							if rp.teams[ItemInfo.Upgrade.Team].viewZ then
								frame.IconViewer.viewZoffset = rp.teams[ItemInfo.Upgrade.Team].viewZ
							end

							if rp.teams[ItemInfo.Upgrade.Team].viewDepth then
								frame.IconViewer.viewDepthoffset = rp.teams[ItemInfo.Upgrade.Team].viewDepth
							end
                        end

                        if IsValid( frame.IconViewer.Entity ) then
                            if ItemInfo.Upgrade.GetMaterial(ItemInfo.Upgrade) then
                                frame.IconViewer.Entity.SetMaterial( frame.IconViewer.Entity, ItemInfo.Upgrade.GetMaterial(ItemInfo.Upgrade) );
                            end
                        end

                        frame.IconViewer.SetVisible( frame.IconViewer, true );
                    else
                        frame.IconViewer.SetVisible( frame.IconViewer, false );
                    end
                end

                for _, pnl in pairs( frame.Information.Data.GetChildren(frame.Information.Data) ) do
                    if pnl.UpdateInformation then
                        pnl:UpdateInformation( ItemInfo );
                    end
                end

                frame.Information.Data.InvalidateLayout( frame.Information.Data, true );
                frame.Information.Data.SizeToChildren( frame.Information.Data, false, true );

                local shitOffset = rpui.DonateStats and -self.RMDepositBtn.GetTall(self.RMDepositBtn) or 0;

                frame.Information.Data.SetPos( frame.Information.Data, 0, shitOffset + frame.Information.GetTall(frame.Information) * 0.5 - frame.Information.Data.GetTall(frame.Information.Data) * 0.5 );

                frame.Information.RefundInfo.SetPos( frame.Information.RefundInfo,
                    frame.Information.GetWide(frame.Information) - frame.Information.RefundInfo.GetWide(frame.Information.RefundInfo),
                    shitOffset + frame.Information.GetTall(frame.Information) * 0.5 + frame.Information.Data.GetTall(frame.Information.Data) * 0.5 + self.innerPadding
                );
            end
            ItemButton._alpha = 127;
            ItemButton.PurchasedReasons = {
                [translates.Get("Это у вас уже куплено!")] = true,
                [translates.Get("Лимит достигнут")]        = true,
                [translates.Get("Круче некуда.")]          = true,
            };
            ItemButton.Paint = function( this, w, h )
                surface.SetFont( this:GetFont() );
                local tW, tH = surface.GetTextSize(" ");

                this.WrappedText = string.Wrap( this:GetFont(), this:GetText(), w - self.innerPadding * 2 );

                this.TextHeight        = tH;
                this.WrappedTextHeight = #this.WrappedText * tH;

                local baseColor, textColor = rpui.GetPaintStyle( this, STYLE_TRANSPARENT_SELECTABLE );
                surface.SetDrawColor( baseColor );
                surface.DrawRect( 0, 0, w, h );

                if ItemInfo.Reason and this.PurchasedReasons[ItemInfo.Reason] and this:IsVisible() then
                    local ts = 0.45 * h;

                    if not this.StatusTriangle then
                        this.StatusTriangle = {
                            { x = w - ts, y = 0,  u = 0, v = 0 },
                            { x = w,      y = 0,  u = 1, v = 0 },
                            { x = w,      y = ts, u = 1, v = 1 }
                        };
                    end

                    draw.NoTexture();
                    if not disabledWeps[ItemInfo.Upgrade.UID] then
                        surface.SetDrawColor( rpui.UIColors.BackgroundDonateBuyed );
                        surface.DrawPoly( this.StatusTriangle );

                        surface.SetMaterial( rpui.GradientDownMat );
                        surface.SetDrawColor( rpui.UIColors.DonateBuyed );
                        surface.DrawPoly( this.StatusTriangle );

                        draw.SimpleText( "✔", "rpui.Fonts.DonateMenu.StatusTriangle", w - ts * 0.3, ts * 0.3, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    else
                        surface.SetDrawColor( rpui.UIColors.BackgroundDonateDisabled );
                        surface.DrawPoly( this.StatusTriangle );

                        surface.SetMaterial( rpui.GradientDownMat );
                        surface.SetDrawColor( rpui.UIColors.DonateDisabled );
                        surface.DrawPoly( this.StatusTriangle );

                        draw.SimpleText( "✘", "rpui.Fonts.DonateMenu.StatusTriangle", w - ts * 0.3, ts * 0.3, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    end
                end

                for k12, text12 in ipairs( this.WrappedText ) do
                    draw.SimpleText( text12, this:GetFont(), w * 0.5, h * 0.5 - this.WrappedTextHeight * 0.5 + (k12-1) * this.TextHeight, textColor, TEXT_ALIGN_CENTER );
                end
                return true
            end
            ItemsContent:InvalidateLayout( true );
            ItemsContent:SizeToChildren( false, true );
            frame.Items.AddItem( frame.Items, ItemsContent );
            table.insert( frame.Items.Buttons, ItemButton );
        end
    end
end


function PANEL:OpenCategory( cat, uid )
	self.Header.Title.SetText(self.Header.Title, self.categoryCreationFuncs[ self.Categories[cat] ].CustomTitle or translates.Get("ДОНАТ"))

	if self.OpenedCategory then
        if self.DonateStats.IsVisible(self.DonateStats) and (self.categoryCreationFuncs[ self.Categories[cat] ].HeaderInvisible or self.categoryCreationFuncs[ self.Categories[cat] ].TopsInvisible) then
			self.DonateStats.AlphaTo( self.DonateStats, 0, 0.25, 0, function()
                self.DonateStats.SetVisible(self.DonateStats, false)

				local p_x, p_y = self.Header.GetPos(self.Header)
				local par = self.ContentContainer.Frames[cat].GetParent(self.ContentContainer.Frames[cat])
				par:SetPos(p_x, p_y)
            end)
		end

		if self.Header.Title.IsVisible(self.Header.Title) and self.categoryCreationFuncs[ self.Categories[cat] ].TitleInvisible then
			self.Header.Title.AlphaTo( self.Header.Title, 0, 0.25, 0, function()
				self.Header.Title.SetVisible(self.Header.Title, false)
			end)
		end

        if self.Header.IsVisible(self.Header) then
			if self.categoryCreationFuncs[ self.Categories[cat] ].HeaderInvisible then
				self.RMDepositBtn.AlphaTo( self.RMDepositBtn, 0, 0.25, 0, function()
					self.RMDepositBtn.SetVisible(self.RMDepositBtn, false)
				end)

                self.SMDepositBtn.AlphaTo( self.SMDepositBtn, 0, 0.25, 0, function()
					self.SMDepositBtn.SetVisible(self.SMDepositBtn, false)
				end)

				self.Header.AlphaTo( self.Header, 0, 0.25, 0, function()
					self.Header.SetVisible(self.Header, false)
				end)
			end
        end

        self.OpenedCategory.AlphaTo( self.OpenedCategory, 0, 0.25, 0, function()
            self.OpenedCategory.SetVisible( self.OpenedCategory, false );

            self.OpenedCategory = self.ContentContainer.Frames[cat];
            local open_cat = self.OpenedCategory;

            open_cat:SetVisible( true );
            open_cat:AlphaTo( 255, 0.25 );

			if not self.DonateStats.IsVisible(self.DonateStats) and not (self.categoryCreationFuncs[ self.Categories[cat] ].HeaderInvisible or self.categoryCreationFuncs[ self.Categories[cat] ].TopsInvisible) then
				self.DonateStats.SetVisible(self.DonateStats, true)

                self.DonateStats.SetAlpha(self.DonateStats, 0)
                self.DonateStats.AlphaTo( self.DonateStats, 255, 0.25 )
			end

			if not self.Header.Title.IsVisible(self.Header.Title) and not self.categoryCreationFuncs[ self.Categories[cat] ].TitleInvisible then
				self.Header.Title.SetVisible(self.Header.Title, true)

                self.Header.Title.SetAlpha(self.Header.Title, 0)
                self.Header.Title.AlphaTo(self.Header.Title, 255, 0.25)
			end

            if not self.Header.IsVisible(self.Header) and not self.categoryCreationFuncs[ self.Categories[cat] ].HeaderInvisible then
                self.Header.SetVisible(self.Header, true)
                self.RMDepositBtn.SetVisible(self.RMDepositBtn, true)
                self.SMDepositBtn.SetVisible(self.SMDepositBtn, true)

                self.Header.SetAlpha(self.Header, 0)
                self.Header.AlphaTo( self.Header, 255, 0.25 )

                self.DonateStats.SetAlpha(self.DonateStats, 0)
                self.DonateStats.AlphaTo( self.DonateStats, 255, 0.25 )

                self.RMDepositBtn.SetAlpha(self.RMDepositBtn, 0)
                self.RMDepositBtn.AlphaTo( self.RMDepositBtn, 255, 0.25 )
                self.SMDepositBtn.SetAlpha(self.SMDepositBtn, 0)
                self.SMDepositBtn.AlphaTo( self.SMDepositBtn, 255, 0.25 )
            end

            if self.categoryCreationFuncs[ self.Categories[cat] ].FrameOpen then
                self.categoryCreationFuncs[ self.Categories[cat] ].FrameOpen( open_cat )
            end

            for k13, v13 in pairs( self.MenuContainer.Buttons ) do v13.Selected = false; end
            self.MenuContainer.Buttons[cat].Selected = true;

            local notSelected = true;
            if uid then
                local UpgradeData = rp.shop.GetByUID(uid);

                for _, ItemButton in pairs( IsValid(self.OpenedCategory.Items) and self.OpenedCategory.Items.Buttons or {} ) do
                    if ItemButton.UpgradeID == UpgradeData.ID then
                        timer.Simple( FrameTime() * 5, function()
                            if not IsValid(self) then return end
                            ItemButton:DoClick();
                        end );

                        notSelected = false;
                        break
                    end
                end
            end

            if IsValid(self.OpenedCategory.Items) and not self.OpenedCategory.Items.Selected and notSelected then
                timer.Simple( FrameTime() * 5, function()
                    if not IsValid(self) then return end

                    if self.OpenedCategory.Items.Buttons[1] then
                        self.OpenedCategory.Items.Buttons[1].DoClick(self.OpenedCategory.Items.Buttons[1]);
                        self.OpenedCategory.Items.Buttons[1]._grayscale = 255;
                    end
                end );
            end
        end );

    else
        if self.categoryCreationFuncs[ self.Categories[cat] ].TitleInvisible then
			self.Header.Title.SetVisible(self.Header.Title, false)
		end

        if self.categoryCreationFuncs[ self.Categories[cat] ].HeaderInvisible or self.categoryCreationFuncs[ self.Categories[cat] ].TopsInvisible then
			self.DonateStats.SetVisible(self.DonateStats, false)
		end

        if self.categoryCreationFuncs[ self.Categories[cat] ].HeaderInvisible then
            self.RMDepositBtn.SetVisible(self.RMDepositBtn, false)
            self.SMDepositBtn.SetVisible(self.SMDepositBtn, false)

            self.Header.SetVisible(self.Header, false)

            local p_x, p_y = self.Header.GetPos(self.Header)
            local par = self.ContentContainer.Frames[cat].GetParent(self.ContentContainer.Frames[cat])
            par:SetPos(p_x, p_y)
        end

        self.OpenedCategory = self.ContentContainer.Frames[cat];
        self.OpenedCategory.SetVisible( self.OpenedCategory, true );
        self.OpenedCategory.AlphaTo( self.OpenedCategory, 255, 0.25 );

        if self.categoryCreationFuncs[ self.Categories[cat] ].FrameOpen then
            self.categoryCreationFuncs[ self.Categories[cat] ].FrameOpen( self.OpenedCategory )
        end

        for k14, v14 in pairs( self.MenuContainer.Buttons ) do v14.Selected = false; end
        self.MenuContainer.Buttons[cat].Selected = true;

        local notSelected = true;
        if uid then
            local UpgradeData = rp.shop.GetByUID(uid);

            for _, ItemButton in pairs( self.OpenedCategory.Items.Buttons ) do
                if ItemButton.UpgradeID == UpgradeData.ID then
                    timer.Simple( FrameTime() * 5, function()
                        if not IsValid(self) then return end
                        ItemButton:DoClick();
                    end );

                    notSelected = false;
                    break
                end
            end
        end

        if IsValid(self.OpenedCategory.Items) and not self.OpenedCategory.Items.Selected and notSelected then
            timer.Simple( FrameTime() * 5, function()
                if not IsValid(self) then return end

                if IsValid(self.OpenedCategory.Items) and self.OpenedCategory.Items.Buttons[1] then
                    self.OpenedCategory.Items.Buttons[1].DoClick(self.OpenedCategory.Items.Buttons[1]);
                end
            end );
        end
    end

    LocalPlayer().donateLastCategory = cat;
end


function PANEL:FindUpgrade( uid )
    local UpgradeData = rp.shop.GetByUID(uid);

    if UpgradeData then
        local needleCategory = self.CategoriesMap[UpgradeData.Cat];

        if needleCategory then
            if self.OpenedCategory == self.ContentContainer.Frames[needleCategory] then
                for _, ItemButton15 in pairs( self.OpenedCategory.Items.Buttons ) do
                    if ItemButton15.UpgradeID == UpgradeData.ID then
                        ItemButton15:DoClick();
                        break
                    end
                end
            else
                self:OpenCategory( needleCategory, uid );
            end
        end
    end
end

vgui.Register( "rpui.DonateMenu", PANEL, "EditablePanel" );
