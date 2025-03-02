-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_seasonpass_additions_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local only_one_season = rp.cfg.IsFrance
local prem_back_mat = Material('premium/new_selector')

local fake_buy_sp_1
local fake_buy_sp_3
local fake_buy_all
local fake_buy
local fake_buy_ls

if only_one_season then
	fake_buy_ls = { 2.5, 6.75, 11.25, 15.5 }

else
	fake_buy_sp_1 = rp.cfg.SeasonpassPrices and rp.cfg.SeasonpassPrices.oneSeason or 369
	fake_buy_sp_3 = rp.cfg.SeasonpassPrices and rp.cfg.SeasonpassPrices.threeSeasons or 799

	fake_buy_all = rp.cfg.SeasonpassPrices and rp.cfg.SeasonpassPrices.allSeasons or 2199
	fake_buy = rp.cfg.SeasonpassPrices and rp.cfg.SeasonpassPrices.levels or { 129, 379, 639, 899 }
end


local PANEL = {}

function PANEL:CreateDepositPanel( parent_pnl, pnl, buy_seasonpass, id, cback, wide_override )
	local alignTop = true

	local pad = 1 * self.innerPadding
	local sfH = 1.33 * self.frameH

	if not self.DepositPanel then
		self.DepositPanel = vgui.Create( "Panel", parent_pnl );
		local deposit = self.DepositPanel;

		deposit:SetWide( wide_override or pnl:GetWide(pnl) );
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
			size     = sfH * 0.025,
			extended = true,
		} );

		surface.CreateFont( "DepositPanel.Small", {
			font     = "Montserrat",
			size     = sfH * 0.0178,
			weight 	 = 500,
			extended = true,
		} );

		surface.CreateFont( "DepositPanel.InputBold", {
			font      = "Montserrat",
			size      = sfH * 0.0225,
			extended  = true,
		} );

		self.DepositPanel.TopArrow = vgui.Create( "Panel", self.DepositPanel );
		local top_arr = self.DepositPanel.TopArrow;

		top_arr:Dock( TOP );
		top_arr:SetTall( 0 );
		top_arr.Paint = function( this, w, h )
			draw.NoTexture();
			surface.SetDrawColor( Color(0,0,0,232) );
			surface.DrawPoly( {{x = w, y = 0}, {x = w, y = h}, {x = w-h, y = h}} );
		end

		self.DepositPanel.Foreground = vgui.Create( "Panel", self.DepositPanel );
		self.DepositPanel.Foreground.Dock( self.DepositPanel.Foreground, TOP );
		self.DepositPanel.Foreground.Paint = function( this, w, h )
			surface.SetDrawColor( Color(0,0,0,232) );
			surface.DrawRect( 0, 0, w, h );
		end

		self.DepositPanel.BottomArrow = vgui.Create( "Panel", self.DepositPanel );
		local bot_arr = self.DepositPanel.BottomArrow;

		bot_arr:Dock( TOP );
		bot_arr:SetTall( 0 );
		bot_arr.Paint = function( this, w, h )
			draw.NoTexture();
			surface.SetDrawColor( Color(0,0,0,232) );
			surface.DrawPoly( {{x = w-h, y = 0}, {x = w, y = 0}, {x = w, y = h}} );
		end

		self.DepositPanel.LeftColumn = vgui.Create( "Panel", self.DepositPanel.Foreground );
		self.DepositPanel.LeftColumn.DockPadding( self.DepositPanel.LeftColumn, pad * 2, pad * 2, pad * 2, pad * 2 );
		self.DepositPanel.LeftColumn.SetWide( self.DepositPanel.LeftColumn, self.DepositPanel.GetWide(self.DepositPanel) );

		local right_col = self.DepositPanel.LeftColumn

		local robo_mat = Material("rpui/donatemenu/robokassa", "smooth noclamp")
		local umoney_mat = Material("rpui/donatemenu/ukassa", "smooth noclamp")
		local tebex_mat = Material("rpui/donatemenu/tebex", "smooth noclamp")
		local xsolla_mat = Material("rpui/donatemenu/xsolla", "smooth noclamp")

		local robo_desc = { "Банковская карта, QIWI", "" }
		local umoney_desc = { "Сбербанк Онлайн, Webmoney", "Альфа-Клик, Тинькофф" }
		local tebex_desc = { "Банковская карта, PayPal", "(Для оплаты за пределами РФ)" }
		local xsolla_desc = { "Банковская карта, PayPal", "(Для оплаты за пределами РФ)" }

		if not rp.cfg.IsFrance then
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
			robo_desc_1:DockMargin(0, pad * 0.1, 0, 0)
			robo_desc_1:SetFont("DepositPanel.Small");
			robo_desc_1:SetTextColor( rpui.UIColors.White );
			robo_desc_1:SetText( translates.Get(robo_desc[1]) );

			self.DepositPanel.RoboDesc2 = vgui.Create( "DLabel", right_col );
			local robo_desc_2 = self.DepositPanel.RoboDesc2
			robo_desc_2:Dock(TOP);
			robo_desc_2:SetContentAlignment( 5 );
			robo_desc_2:DockMargin(0, -pad * 0.7, 0, pad)
			robo_desc_2:SetFont("DepositPanel.Small");
			robo_desc_2:SetTextColor( rpui.UIColors.White );
			robo_desc_2:SetText( translates.Get(robo_desc[2]) );

			mon_dep:Dock( TOP );
			mon_dep:SetFont( "DepositPanel.MediumBold" );
			mon_dep:DockMargin(0, pad * 0.4, 0, 0)
			mon_dep:SetText( translates.Get("ПОПОЛНИТЬ СЧЁТ") );
			mon_dep:SizeToContentsY( pad * 1 );
			mon_dep.Paint = function( this, w, h )
				if not IsValid( self.DepositPanel ) then return end
				this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();
				local distsize  = math.sqrt( w*w + h*h );

				surface.SetAlphaMultiplier( self.DepositPanel.GetAlpha(self.DepositPanel) / 255 );
					surface.SetDrawColor(self.RainbowColor);
					surface.DrawRect( 0, 0, w, h );

					surface.SetMaterial( rpui.GradientMat );
					surface.SetDrawColor(self.RainbowRotate);
					surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

					local img_width = w

					surface.SetDrawColor(color_white)
					surface.SetMaterial(robo_mat)
					surface.DrawTexturedRect(-1, (h - 0.125 * img_width) * 0.5 + 1, img_width, 0.125 * img_width)

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
				if buy_seasonpass then
					if rp.cfg.IsTestServer then
						gui.OpenURL('https://urf.im/page/info')
						return
					end

					gui.OpenURL("https://shop.urf.im/page/seasonpass?" .. --[[id ..]] "&steamid=" .. LocalPlayer():SteamID64() .. '#buy')
				elseif cback then
					cback(true)
				end

				this.Timeout = SysTime() + 5;
				this:SetEnabled( false );
			end


			self.DepositPanel.MoneyDeposit2 = vgui.Create( "DButton", right_col );
			local mon_dep2 = self.DepositPanel.MoneyDeposit2;

			self.DepositPanel.UMonDesc1 = vgui.Create( "DLabel", right_col );
			local umon_desc_1 = self.DepositPanel.UMonDesc1
			umon_desc_1:Dock(TOP);
			umon_desc_1:SetContentAlignment( 5 );
			umon_desc_1:DockMargin(0, pad * 0.1, 0, 0)
			umon_desc_1:SetFont("DepositPanel.Small");
			umon_desc_1:SetTextColor( rpui.UIColors.White );
			umon_desc_1:SetText( translates.Get(umoney_desc[1]) );

			self.DepositPanel.UMonDesc2 = vgui.Create( "DLabel", right_col );
			local umon_desc_2 = self.DepositPanel.UMonDesc2
			umon_desc_2:Dock(TOP);
			umon_desc_2:SetContentAlignment( 5 );
			umon_desc_2:DockMargin(0, -pad * 0.7, 0, pad)
			umon_desc_2:SetFont("DepositPanel.Small");
			umon_desc_2:SetTextColor( rpui.UIColors.White );
			umon_desc_2:SetText( translates.Get(umoney_desc[2]) );

			mon_dep2:Dock( TOP );
			mon_dep2:SetFont( "DepositPanel.MediumBold" );
			mon_dep2:SetText( translates.Get("ПОПОЛНИТЬ СЧЁТ") );
			mon_dep2:SizeToContentsY( pad * 1 );
			mon_dep2.Paint = function( this, w, h )
				if not IsValid( self.DepositPanel ) then return end
				this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();
				local distsize  = math.sqrt( w*w + h*h );

				surface.SetAlphaMultiplier( self.DepositPanel.GetAlpha(self.DepositPanel) / 255 );
					surface.SetDrawColor(self.RainbowColor);
					surface.DrawRect( 0, 0, w, h );

					surface.SetMaterial( rpui.GradientMat );
					surface.SetDrawColor(self.RainbowRotate);
					surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

					local img_width2 = w

					surface.SetDrawColor(color_white)
					surface.SetMaterial(umoney_mat)
					surface.DrawTexturedRect(-1, (h - 0.125 * img_width2) * 0.5 + 1, img_width2, 0.125 * img_width2)

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
				if buy_seasonpass then
					if rp.cfg.IsTestServer then
						gui.OpenURL('https://urf.im/page/info')
						return
					end

					gui.OpenURL("https://shop.urf.im/page/seasonpass/umoney?" .. --[[id ..]] "&steamid=" .. LocalPlayer():SteamID64() .. '#buy')
				elseif cback then
					cback(false)
				end

				this.Timeout = SysTime() + 5;
				this:SetEnabled( false );
			end
		end

		self.DepositPanel.MoneyDeposit3 = vgui.Create( "DButton", right_col );
		local mon_dep3 = self.DepositPanel.MoneyDeposit3;

		self.DepositPanel.MoneyDepositDesc31 = vgui.Create( "DLabel", right_col );
		local mon_dep_desc_31 = self.DepositPanel.MoneyDepositDesc31;
		mon_dep_desc_31:Dock(TOP);
		mon_dep_desc_31:SetContentAlignment( 5 );
		mon_dep_desc_31:DockMargin(0, pad * 0.1, 0, 0)
		mon_dep_desc_31:SetFont("DepositPanel.Small");
		mon_dep_desc_31:SetTextColor( rpui.UIColors.White );
		mon_dep_desc_31:SetText( translates.Get(xsolla_desc[1]) );

		self.DepositPanel.MoneyDepositDesc32 = vgui.Create( "DLabel", right_col );
		local mon_dep_desc_32 = self.DepositPanel.MoneyDepositDesc32;
		mon_dep_desc_32:Dock(TOP);
		mon_dep_desc_32:SetContentAlignment( 5 );
		mon_dep_desc_32:DockMargin(0, -pad * 0.7, 0, 0)
		mon_dep_desc_32:SetFont("DepositPanel.Small");
		mon_dep_desc_32:SetTextColor( rpui.UIColors.White );
		mon_dep_desc_32:SetText( translates.Get(xsolla_desc[2]) );

		mon_dep3:Dock( TOP );
		mon_dep3:SetFont( "DepositPanel.MediumBold" );
		mon_dep3:SetText( translates.Get("ПОПОЛНИТЬ СЧЁТ") );
		mon_dep3:SizeToContentsY( pad * 1 );
		mon_dep3.Paint = function( this, w, h )
			if not IsValid( self.DepositPanel ) then return end
			this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();
			local distsize  = math.sqrt( w*w + h*h );

			surface.SetAlphaMultiplier( self.DepositPanel.GetAlpha(self.DepositPanel) / 255 );
				surface.SetDrawColor(self.RainbowColor);
				surface.DrawRect( 0, 0, w, h );

				surface.SetMaterial( rpui.GradientMat );
				surface.SetDrawColor(self.RainbowRotate);
				surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

				local img_width2 = w

				surface.SetDrawColor(color_white)
				surface.SetMaterial(xsolla_mat)
				surface.DrawTexturedRect(-1, (h - 0.125 * img_width2) * 0.5 + 1, img_width2, 0.125 * img_width2)

			surface.SetAlphaMultiplier( 1 );

			return true
		end
		mon_dep3.Think = function( this )
			if this.Timeout and (this.Timeout < SysTime()) then
				this:SetEnabled( true );
				this.Timeout = false;
			end
		end
		mon_dep3.DoClick = function( this )
			gui.OpenURL( string.format("https://shop.urf.im/xsolla?sid=%s&m=%s&v=%s&s=%s&l=%s", LocalPlayer():SteamID(), buy_seasonpass and "seasonpass" or "seasonpass_level", id, rp.cfg.ServerUID, rp.cfg.IsFrance and "fr" or "ru") );

			this.Timeout = SysTime() + 5;
			this:SetEnabled( false );
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

			self.DepositPanel.TopArrow.SetTall( self.DepositPanel.TopArrow, alignTop and 0 or pad * 2 );
			self.DepositPanel.BottomArrow.SetTall( self.DepositPanel.BottomArrow, alignTop and pad * 2 or 0 );

			self.DepositPanel.InvalidateLayout( self.DepositPanel, true );
			self.DepositPanel.SizeToChildren( self.DepositPanel, false, true );

			local x, y = pnl:LocalToScreen();
			local s_x, s_y = self:GetPos();

			self.DepositPanel.SetPos( self.DepositPanel, x - s_x + pnl:GetWide() - self.DepositPanel.GetWide(self.DepositPanel), y - s_y - self.DepositPanel.GetTall(self.DepositPanel) - pad * 0.5 );

			self.DepositPanel.AlphaTo( self.DepositPanel, 255, 0.25 );
		end );
	end
end

function PANEL:OpenBuyMenu()
	if not IsValid(self.BuyMenu) then
		self:CreateBuyMenu()
	end

	if IsValid(self.ThanksMenu) and self.ThanksMenu.IsVisible(self.ThanksMenu) and self.ThanksMenu.GetAlpha(self.ThanksMenu) > 0 then
		self.ThanksMenu.AlphaTo(self.ThanksMenu, 0, 0.2, 0, function()
			self.ThanksMenu.SetVisible(self.ThanksMenu, false)
		end)
	end

	if IsValid(self.LevelsBuyMenu) and self.LevelsBuyMenu.IsVisible(self.LevelsBuyMenu) and self.LevelsBuyMenu.GetAlpha(self.LevelsBuyMenu) > 0 then
		self.LevelsBuyMenu.AlphaTo(self.LevelsBuyMenu, 0, 0.2, 0, function()
			self.LevelsBuyMenu.SetVisible(self.LevelsBuyMenu, false)
		end)
	end

	self.BuyMenu.SetAlpha(self.BuyMenu, 0)
	self.BuyMenu.SetVisible(self.BuyMenu, true)

	self.BuyMenu.AlphaTo(self.BuyMenu, 255, 0.2, 0)
end

function PANEL:OpenThanksMenu()
	if not IsValid(self.ThanksMenu) then
		self:CreateThanksMenu()
	end

	if IsValid(self.BuyMenu) and self.BuyMenu.IsVisible(self.BuyMenu) and self.BuyMenu.GetAlpha(self.BuyMenu) > 0 then
		self.BuyMenu.AlphaTo(self.BuyMenu, 0, 0.2, 0, function()
			self.BuyMenu.SetVisible(self.BuyMenu, false)
		end)
	end

	if IsValid(self.LevelsBuyMenu) and self.LevelsBuyMenu.IsVisible(self.LevelsBuyMenu) and self.LevelsBuyMenu.GetAlpha(self.LevelsBuyMenu) > 0 then
		self.LevelsBuyMenu.AlphaTo(self.LevelsBuyMenu, 0, 0.2, 0, function()
			self.LevelsBuyMenu.SetVisible(self.LevelsBuyMenu, false)
		end)
	end

	self.ThanksMenu.SetAlpha(self.ThanksMenu, 0)
	self.ThanksMenu.SetVisible(self.ThanksMenu, true)

	self.ThanksMenu.AlphaTo(self.ThanksMenu, 255, 0.2, 0)
end

function PANEL:CreateThanksMenu()
    local dframeW, dframeH = self:GetSize()
	local season = rp.seasonpass.GetSeason()

	if IsValid(self.ThanksMenu) then
		self.ThanksMenu.Remove(self.ThanksMenu)
	end

	self.ThanksMenu = vgui.Create('DPanel', self)
	local thanks_menu = self.ThanksMenu
	thanks_menu:SetSize(dframeW, dframeH)
	thanks_menu.Paint = function(sbp, sbp_w, sbp_h)
		draw.Blur(sbp)

		surface.SetDrawColor(sbp.Shading)
		surface.DrawRect(0, 0, sbp_w, sbp_h)
	end
	thanks_menu.Shading = Color(0, 0, 0, 210)
	thanks_menu:DockPadding(self.innerPadding, self.innerPadding, self.innerPadding, self.innerPadding)

    thanks_menu.Header = vgui.Create("Panel", thanks_menu)
	local thanks_menu_header = thanks_menu.Header
    thanks_menu_header:Dock(TOP)
    thanks_menu_header:DockMargin(self.innerPadding * 2, self.innerPadding * 1.4, self.innerPadding * 2, 0)
    thanks_menu_header:SetTall(dframeH * 0.1)
    thanks_menu_header:InvalidateParent(true)

    thanks_menu_header.Title = vgui.Create("DLabel", thanks_menu_header)
	local thanks_menu_header_title = thanks_menu_header.Title
    thanks_menu_header_title:Dock(LEFT)
    thanks_menu_header_title:SetTextColor(self.UIColors.White or rpui.UIColors.White)
    thanks_menu_header_title:SetFont("rpui.Fonts.Seasonpass.TitlePremium")
    thanks_menu_header_title:SetText(translates.Get("ГЛОБАЛЬНЫЙ RP ПРОПУСК"))
    thanks_menu_header_title:SizeToContentsX()
    thanks_menu_header_title:SizeToContentsY()

    thanks_menu_header:SizeToChildren(false, true)

    thanks_menu.CloseButton = vgui.Create("DButton", thanks_menu)
	local thanks_menu_closebutton = thanks_menu.CloseButton
    thanks_menu_closebutton:SetFont("rpui.Fonts.Seasonpass.Small")
    thanks_menu_closebutton:SetText(translates.Get("ЗАКРЫТЬ"))
    thanks_menu_closebutton:SizeToContentsY(dframeH * 0.015)
    thanks_menu_closebutton:SizeToContentsX(thanks_menu_closebutton:GetTall() + dframeW * 0.025)
    thanks_menu_closebutton:SetPos(self:GetChildPosition(self.Header.CloseButton))
    thanks_menu_closebutton.Paint = function(this_cb, this_cbw, this_cbh)
        local baseColor, textColor = self.GetPaintStyle(this_cb)
        surface.SetDrawColor(baseColor)
        surface.DrawRect(0, 0, this_cbw, this_cbh)

        surface.SetDrawColor(self.UIColors.White or rpui.UIColors.White)
        surface.DrawRect(0, 0, this_cbh, this_cbh)

        surface.SetDrawColor(Color(0,0,0,this_cb._grayscale or 0))
        local p = 0.1 * this_cbh
        surface.DrawLine(this_cbh, p, this_cbh, this_cbh - p)

        draw.SimpleText("✕", "rpui.Fonts.Seasonpass.Small", this_cbh/2, this_cbh/2, self.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(this_cb:GetText(), this_cb:GetFont(), this_cbw/2 + this_cbh/2, this_cbh/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        return true
    end
    thanks_menu_closebutton.DoClick = function()
		thanks_menu:AlphaTo(0, 0.2, 0, function()
			thanks_menu:SetVisible(false)
		end)
	end

    thanks_menu.Mainholder = vgui.Create("Panel", thanks_menu)
	local thanks_menu_mainholder = thanks_menu.Mainholder
    thanks_menu_mainholder:Dock(FILL)
    thanks_menu_mainholder:DockMargin(self.innerPadding * 2, self.innerPadding, self.innerPadding * 2, 0)
    thanks_menu_mainholder:InvalidateParent(true)

    thanks_menu_mainholder.Center = vgui.Create("Panel", thanks_menu_mainholder)
	local thanks_menu_mainholder_center = thanks_menu_mainholder.Center
    thanks_menu_mainholder_center:Dock(FILL)
    thanks_menu_mainholder_center:DockMargin(dframeW * 0.2, 0, dframeW * 0.2, dframeH * 0.1 + self.innerPadding * 0.5)
    thanks_menu_mainholder_center:SetWide(dframeW * 0.32)
    thanks_menu_mainholder_center:InvalidateParent(true)

	thanks_menu_mainholder_center.Button = vgui.Create("DButton", thanks_menu_mainholder_center)
	local thanks_menu_mainholder_center_button = thanks_menu_mainholder_center.Button
	thanks_menu_mainholder_center_button:Dock(BOTTOM)
	thanks_menu_mainholder_center_button:DockMargin(dframeW * 0.05, 0, dframeW * 0.05, 0)
	thanks_menu_mainholder_center_button:SetTall(dframeH * 0.07)
	thanks_menu_mainholder_center_button:SetText("")
	thanks_menu_mainholder_center_button.Paint = function(sbml, sbml_w, sbml_h)
		surface.SetDrawColor(Color(0, 0, 0, 100))
		surface.DrawRect(0, 0, sbml_w, sbml_h)

		sbml.rotAngle = (sbml.rotAngle or 0) + 100 * FrameTime()

		local hovered = sbml:IsHovered()

		sbml._alpha = math.Approach(sbml._alpha or 0, (hovered or sbml.Selected) and 255 or 0, 768 * FrameTime())

		local vecClrGold  = Vector(rpui.UIColors.BackgroundGold.r, rpui.UIColors.BackgroundGold.g, rpui.UIColors.BackgroundGold.b)
		local vecClrBlack = Vector(0, 0, 0)

		local vecTextColor = Lerp(768 * FrameTime(), sbml._veccolor or vecClrBlack, hovered and vecClrBlack or vecClrGold)

		textColor = Color(vecTextColor.x, vecTextColor.y, vecTextColor.z)

		local distsize  = math.sqrt(sbml_w * sbml_w + sbml_h * sbml_h)
		local parentalpha = thanks_menu:GetAlpha() / 255
		local alphamult   = sbml._alpha / 255

		surface.SetAlphaMultiplier(parentalpha * alphamult)
			surface.SetDrawColor(rpui.UIColors.BackgroundGold)
			surface.DrawRect(0, 0, sbml_w, sbml_h)

			surface.SetMaterial(rpui.GradientMat)
			surface.SetDrawColor(rpui.UIColors.Gold)
			surface.DrawTexturedRectRotated(sbml_w * 0.5, sbml_h * 0.5, distsize, distsize, sbml.rotAngle or 0)

		surface.SetAlphaMultiplier(parentalpha)
			draw.SimpleText(translates.Get("К НАГРАДАМ!"), "rpui.Fonts.Seasonpass.PremiumButton" or sbml:GetFont(), sbml_w * 0.5, sbml_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		surface.SetAlphaMultiplier(1)
	end
	thanks_menu_mainholder_center_button.PaintOver = function(sbmlo, sbmlo_w, sbmlo_h)
		rpui.DrawStencilBorder(sbmlo, 0, 0, sbmlo_w, sbmlo_h, 0.06, ColorAlpha(self.RainbowRotate, thanks_menu:GetAlpha()), ColorAlpha(self.RainbowColor, thanks_menu:GetAlpha()))
    end
	thanks_menu_mainholder_center_button.DoClick = function()
		thanks_menu_closebutton.DoClick()
	end

    thanks_menu_mainholder_center.Label1 = vgui.Create("DLabel", thanks_menu_mainholder_center)
	local thanks_menu_mainholder_center_label1 = thanks_menu_mainholder_center.Label1
    thanks_menu_mainholder_center_label1:Dock(BOTTOM)
    thanks_menu_mainholder_center_label1:DockMargin(0, 0, 0, dframeH * 0.25)
    thanks_menu_mainholder_center_label1:SetTextColor(rpui.UIColors.White)
    thanks_menu_mainholder_center_label1:SetFont("rpui.Fonts.Seasonpass.TitlePremium")
    thanks_menu_mainholder_center_label1:SetText(translates.Get("RP ПРОПУСК открыт"))
    thanks_menu_mainholder_center_label1:SetContentAlignment(5)
	thanks_menu_mainholder_center_label1:SizeToContentsY()
    thanks_menu_mainholder_center_label1:InvalidateParent(true)

    thanks_menu_mainholder_center.Label2 = vgui.Create("DLabel", thanks_menu_mainholder_center)
	local thanks_menu_mainholder_center_label2 = thanks_menu_mainholder_center.Label2
    thanks_menu_mainholder_center_label2:Dock(BOTTOM)
    thanks_menu_mainholder_center_label2:DockMargin(0, 0, 0, 0)
    thanks_menu_mainholder_center_label2:SetTextColor(rpui.UIColors.White)
    thanks_menu_mainholder_center_label2:SetFont("rpui.Fonts.Seasonpass.TitlePremium")
    thanks_menu_mainholder_center_label2:SetText(translates.Get("Спасибо за покупку!"))
    thanks_menu_mainholder_center_label2:SetContentAlignment(5)
	thanks_menu_mainholder_center_label2:SizeToContentsY()
    thanks_menu_mainholder_center_label2:InvalidateParent(true)
end

function PANEL:CreateBuyMenu()
    local dframeW, dframeH = self:GetSize()
	local season = rp.seasonpass.GetSeason()

	if IsValid(self.BuyMenu) then
		self.BuyMenu.Remove(self.BuyMenu)
	end

	self.BuyMenu = vgui.Create('DPanel', self)
	local buy_menu = self.BuyMenu
	buy_menu:SetSize(dframeW, dframeH)
	buy_menu.Paint = function(sbp, sbp_w, sbp_h)
		draw.Blur(sbp)

		surface.SetDrawColor(sbp.Shading)
		surface.DrawRect(0, 0, sbp_w, sbp_h)
	end
	buy_menu.Shading = Color(0, 0, 0, 210)
	buy_menu:DockPadding(self.innerPadding, self.innerPadding, self.innerPadding, self.innerPadding)

    buy_menu.Header = vgui.Create("Panel", buy_menu)
	local buy_menu_header = buy_menu.Header
    buy_menu_header:Dock(TOP)
    buy_menu_header:DockMargin(self.innerPadding * 2, self.innerPadding * 1.4, self.innerPadding * 2, 0)
    buy_menu_header:SetTall(dframeH * 0.1)
    buy_menu_header:InvalidateParent(true)

    buy_menu_header.Title = vgui.Create("DLabel", buy_menu_header)
	local buy_menu_header_title = buy_menu_header.Title
    buy_menu_header_title:Dock(LEFT)
    buy_menu_header_title:SetTextColor(self.UIColors.White or rpui.UIColors.White)
    buy_menu_header_title:SetFont("rpui.Fonts.Seasonpass.TitlePremium")
    buy_menu_header_title:SetText(translates.Get("ГЛОБАЛЬНЫЙ RP ПРОПУСК"))
    buy_menu_header_title:SizeToContentsX()
    buy_menu_header_title:SizeToContentsY()

    buy_menu_header:SizeToChildren(false, true)

    buy_menu.CloseButton = vgui.Create("DButton", buy_menu)
	local buy_menu_closebutton = buy_menu.CloseButton
    buy_menu_closebutton:SetFont("rpui.Fonts.Seasonpass.Small")
    buy_menu_closebutton:SetText(translates.Get("ЗАКРЫТЬ"))
    buy_menu_closebutton:SizeToContentsY(dframeH * 0.015)
    buy_menu_closebutton:SizeToContentsX(self.BuyMenu.CloseButton.GetTall(self.BuyMenu.CloseButton) + dframeW * 0.025)
    buy_menu_closebutton:SetPos(self.GetChildPosition(self, self.Header.CloseButton))
    buy_menu_closebutton.Paint = function(this_cb, this_cbw, this_cbh)
        local baseColor, textColor = self.GetPaintStyle(this_cb)
        surface.SetDrawColor(baseColor)
        surface.DrawRect(0, 0, this_cbw, this_cbh)

        surface.SetDrawColor(self.UIColors.White or rpui.UIColors.White)
        surface.DrawRect(0, 0, this_cbh, this_cbh)

        surface.SetDrawColor(Color(0,0,0,this_cb._grayscale or 0))
        local p = 0.1 * this_cbh
        surface.DrawLine(this_cbh, p, this_cbh, this_cbh - p)

        draw.SimpleText("✕", "rpui.Fonts.Seasonpass.Small", this_cbh/2, this_cbh/2, self.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(this_cb:GetText(), this_cb:GetFont(), this_cbw/2 + this_cbh/2, this_cbh/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        return true
    end
    buy_menu_closebutton.DoClick = function()
		buy_menu:AlphaTo(0, 0.2, 0, function()
			buy_menu:SetVisible(false)
		end)
	end


    buy_menu.Mainholder = vgui.Create("Panel", buy_menu)
	local buy_menu_mainholder = buy_menu.Mainholder
    buy_menu_mainholder:Dock(FILL)
    buy_menu_mainholder:DockMargin(self.innerPadding * 2, self.innerPadding, self.innerPadding * 2, 0)
    buy_menu_mainholder:InvalidateParent(true)

    buy_menu_mainholder.Left = vgui.Create("Panel", buy_menu_mainholder)
	local buy_menu_mainholder_left = buy_menu_mainholder.Left
    buy_menu_mainholder_left:Dock(LEFT)
    buy_menu_mainholder_left:DockMargin(only_one_season and (dframeW * 0.34) or dframeW * 0.1, 0, 0, self.innerPadding * 0.5)
    buy_menu_mainholder_left:SetWide(dframeW * 0.32)
    buy_menu_mainholder_left:InvalidateParent(true)

	buy_menu_mainholder_left.Button = vgui.Create("DButton", buy_menu_mainholder_left)
	local buy_menu_mainholder_left_button = buy_menu_mainholder_left.Button
	buy_menu_mainholder_left_button:Dock(BOTTOM)
	buy_menu_mainholder_left_button:DockMargin(dframeW * 0.05, 0, dframeW * 0.05, 0)
	buy_menu_mainholder_left_button:SetTall(dframeH * 0.07)
	buy_menu_mainholder_left_button:SetText("")
	buy_menu_mainholder_left_button.Paint = function(sbml, sbml_w, sbml_h)
		surface.SetDrawColor(Color(0, 0, 0, 100))
		surface.DrawRect(0, 0, sbml_w, sbml_h)

		sbml.rotAngle = (sbml.rotAngle or 0) + 100 * FrameTime()

		local hovered = sbml:IsHovered()

		sbml._alpha = math.Approach(sbml._alpha or 0, (hovered or sbml.Selected) and 255 or 0, 768 * FrameTime())

		local vecClrGold  = Vector(rpui.UIColors.BackgroundGold.r, rpui.UIColors.BackgroundGold.g, rpui.UIColors.BackgroundGold.b)
		local vecClrBlack = Vector(0, 0, 0)

		local vecTextColor = Lerp(768 * FrameTime(), sbml._veccolor or vecClrBlack, hovered and vecClrBlack or vecClrGold)

		textColor = Color(vecTextColor.x, vecTextColor.y, vecTextColor.z)

		local distsize  = math.sqrt(sbml_w * sbml_w + sbml_h * sbml_h)
		local parentalpha = buy_menu:GetAlpha() / 255
		local alphamult   = sbml._alpha / 255

		surface.SetAlphaMultiplier(parentalpha * alphamult)
			surface.SetDrawColor(rpui.UIColors.BackgroundGold)
			surface.DrawRect(0, 0, sbml_w, sbml_h)

			surface.SetMaterial(rpui.GradientMat)
			surface.SetDrawColor(rpui.UIColors.Gold)
			surface.DrawTexturedRectRotated(sbml_w * 0.5, sbml_h * 0.5, distsize, distsize, sbml.rotAngle or 0)

		surface.SetAlphaMultiplier(parentalpha)
			draw.SimpleText(self.BuyingPass and self.BuyingPass > CurTime() and translates.Get("ПОДОЖДИТЕ...") or translates.Get("КУПИТЬ"), "rpui.Fonts.Seasonpass.PremiumButton" or sbml:GetFont(), sbml_w * 0.5, sbml_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		surface.SetAlphaMultiplier(1)
	end
	buy_menu_mainholder_left_button.PaintOver = function(sbmlo, sbmlo_w, sbmlo_h)
		rpui.DrawStencilBorder(sbmlo, 0, 0, sbmlo_w, sbmlo_h, 0.06, ColorAlpha(self.RainbowRotate, buy_menu:GetAlpha()), ColorAlpha(self.RainbowColor, buy_menu:GetAlpha()))
    end
	buy_menu_mainholder_left_button.DoClick = function()
		if self.BuyingPass and self.BuyingPass > CurTime() then
			return
		end

		self:CreateDepositPanel(self.BuyMenu, buy_menu_mainholder_left_button, true, "single")
		self.BuyingPass = CurTime() + 3
	end

    buy_menu_mainholder_left.Priceholder = vgui.Create("DPanel", buy_menu_mainholder_left)
	local buy_menu_mainholder_left_priceholder = buy_menu_mainholder_left.Priceholder
    buy_menu_mainholder_left_priceholder:Dock(BOTTOM)
    buy_menu_mainholder_left_priceholder:DockMargin(0, 0, 0, self.innerPadding)
    buy_menu_mainholder_left_priceholder:InvalidateParent(true)

	local text_by = translates.Get("за")
	local text_price = translates.Get("%s₽", season.PremiumCost or 590)
	local text_r_price = text_price
	local off_x_4
	local off_x_5
	local text_fake_1

	if fake_buy_sp_1 then
		surface.SetFont("rpui.Fonts.Seasonpass.TitlePremium")
		off_x_4 = surface.GetTextSize(text_price .. ' ')
		off_x_5 = surface.GetTextSize(text_price)

		text_fake_1 = translates.Get("%s₽", fake_buy_sp_1)

		text_price = text_price .. ' ' .. text_fake_1
	end

	surface.SetFont("rpui.Fonts.Seasonpass.QuestTitle")
	local off_x_1 = surface.GetTextSize(text_by)
	surface.SetFont("rpui.Fonts.Seasonpass.TitlePremium")
	local off_x_2 = surface.GetTextSize(text_price)

    buy_menu_mainholder_left_priceholder.Paint = function(sbmp, sbmp_w, sbmp_h)
		draw.SimpleText(text_by .. " ", "rpui.Fonts.Seasonpass.QuestTitle", sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5 + self.innerPadding * 0.2, rpui.UIColors.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

		if fake_buy_sp_1 then
			draw.SimpleText(text_r_price, "rpui.Fonts.Seasonpass.TitlePremium", sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5, Color(150, 150, 150, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			surface.SetDrawColor(190, 190, 190, 255)
			surface.DrawRect(sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5, off_x_5, 3)

			draw.SimpleText(text_fake_1, "rpui.Fonts.Seasonpass.TitlePremium", sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + self.innerPadding * 0.2 + off_x_4, sbmp_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

		else
			draw.SimpleText(text_r_price, "rpui.Fonts.Seasonpass.TitlePremium", sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
		end
	end
	buy_menu_mainholder_left_priceholder:SizeToContentsY(4)

    buy_menu_mainholder_left.Seasons = vgui.Create("DLabel", buy_menu_mainholder_left)
	local buy_menu_mainholder_left_seasons = buy_menu_mainholder_left.Seasons
    buy_menu_mainholder_left_seasons:Dock(BOTTOM)
    buy_menu_mainholder_left_seasons:DockMargin(0, 0, 0, self.innerPadding * 0.8)
    buy_menu_mainholder_left_seasons:SetTextColor(rpui.UIColors.White)
    buy_menu_mainholder_left_seasons:SetFont("rpui.Fonts.Seasonpass.QuestTitle")
    buy_menu_mainholder_left_seasons:SetText(translates.Get("на 1 сезон"))
    buy_menu_mainholder_left_seasons:SetContentAlignment(5)
	buy_menu_mainholder_left_seasons:SizeToContentsY()
    buy_menu_mainholder_left_seasons:InvalidateParent(true)

    buy_menu_mainholder_left.PassText = vgui.Create("DLabel", buy_menu_mainholder_left)
	local buy_menu_mainholder_left_passtext = buy_menu_mainholder_left.PassText
    buy_menu_mainholder_left_passtext:Dock(BOTTOM)
    buy_menu_mainholder_left_passtext:DockMargin(0, 0, 0, self.innerPadding * -0.4)
    buy_menu_mainholder_left_passtext:SetTextColor(rpui.UIColors.White)
    buy_menu_mainholder_left_passtext:SetFont("rpui.Fonts.Seasonpass.QuestTitle")
    buy_menu_mainholder_left_passtext:SetText(translates.Get("RP ПРОПУСК"))
    buy_menu_mainholder_left_passtext:SetContentAlignment(5)
	buy_menu_mainholder_left_passtext:SizeToContentsY()
    buy_menu_mainholder_left_passtext:InvalidateParent(true)

    buy_menu_mainholder_left.Image = vgui.Create("DPanel", buy_menu_mainholder_left)
	local buy_menu_mainholder_left_image = buy_menu_mainholder_left.Image
    buy_menu_mainholder_left_image:Dock(FILL)
    buy_menu_mainholder_left_image:DockMargin(0, 0, 0, self.innerPadding)
    buy_menu_mainholder_left_image:InvalidateParent(true)
	buy_menu_mainholder_left_image.Paint = function(sbmli, sbmli_w, sbmli_h)
		local r_wide
		local r_tall

		if sbmli_w > sbmli_h then
			r_tall = 0.45 * dframeH
			r_wide = 0.55 * r_tall

		else
			r_wide = 0.65 * sbmli_w
			r_tall = 1.8 * r_wide
		end

		surface.SetDrawColor(season.BackBuyPremColorLeft or Color(110, 40, 170, 255))
		surface.SetMaterial(prem_back_mat)
		surface.DrawTexturedRect((sbmli_w - r_wide) / 2, sbmli_h - r_tall * 0.96, r_wide, r_tall)

		surface.SetDrawColor(Color(255, 255, 255, 255))
		surface.SetMaterial(season.BackBuyPremImageLeft)
		surface.DrawTexturedRect((sbmli_w - r_tall) / 2, sbmli_h - r_tall, r_tall, r_tall)
	end


	if not only_one_season then
		buy_menu_mainholder.Right = vgui.Create("Panel", buy_menu_mainholder)
		local buy_menu_mainholder_right = buy_menu_mainholder.Right
		buy_menu_mainholder_right:Dock(RIGHT)
		buy_menu_mainholder_right:DockMargin(0, 0, dframeW * 0.1, self.innerPadding * 0.5)
		buy_menu_mainholder_right:SetWide(dframeW * 0.32)
		buy_menu_mainholder_right:InvalidateParent(true)

		local color_prem_1 = table.Copy(season.PremiumHeadBackColor)
		local color_prem_2 = table.Copy(season.PremiumHeadBackColor)

		color_prem_1.r = color_prem_1.r
		color_prem_1.g = color_prem_1.g
		color_prem_1.b = color_prem_1.b

		color_prem_2.r = 0.6 * color_prem_2.r
		color_prem_2.g = 0.6 * color_prem_2.g
		color_prem_2.b = 0.6 * color_prem_2.b

		buy_menu_mainholder_right.Button = vgui.Create("DButton", buy_menu_mainholder_right)
		local buy_menu_mainholder_right_button = buy_menu_mainholder_right.Button
		buy_menu_mainholder_right_button:Dock(BOTTOM)
		buy_menu_mainholder_right_button:DockMargin(dframeW * 0.05, 0, dframeW * 0.05, 0)
		buy_menu_mainholder_right_button:SetTall(dframeH * 0.07)
		buy_menu_mainholder_right_button:SetText("")
		buy_menu_mainholder_right_button.Paint = function(sbmr, sbmr_w, sbmr_h)
			if self.BuyingPass and self.BuyingPass < CurTime() then
				self.BuyingPass = nil
			end

			surface.SetDrawColor(Color(0, 0, 0, 100))
			surface.DrawRect(0, 0, sbmr_w, sbmr_h)

			sbmr.rotAngle = (sbmr.rotAngle or 0) + 100 * FrameTime()

			local hovered = sbmr:IsHovered()

			sbmr._alpha = math.Approach(sbmr._alpha or 0, (hovered or sbmr.Selected) and 255 or 0, 768 * FrameTime())

			local vecClrGold  = Vector(rpui.UIColors.BackgroundGold.r, rpui.UIColors.BackgroundGold.g, rpui.UIColors.BackgroundGold.b)
			local vecClrBlack = Vector(0, 0, 0)

			local vecTextColor = Lerp(768 * FrameTime(), sbmr._veccolor or vecClrBlack, hovered and vecClrBlack or vecClrGold)

			textColor = Color(vecTextColor.x, vecTextColor.y, vecTextColor.z)

			local distsize  = math.sqrt(sbmr_w * sbmr_w + sbmr_h * sbmr_h)
			local parentalpha = buy_menu:GetAlpha() / 255
			local alphamult   = sbmr._alpha / 255

			surface.SetAlphaMultiplier(parentalpha * alphamult)
				surface.SetDrawColor(color_prem_1)
				surface.DrawRect(0, 0, sbmr_w, sbmr_h)

				surface.SetMaterial(rpui.GradientMat)
				surface.SetDrawColor(color_prem_2)
				surface.DrawTexturedRectRotated(sbmr_w * 0.5, sbmr_h * 0.5, distsize, distsize, sbmr.rotAngle or 0)

			surface.SetAlphaMultiplier(parentalpha)
				draw.SimpleText(self.BuyingPass and self.BuyingPass > CurTime() and translates.Get("ПОДОЖДИТЕ...") or translates.Get("КУПИТЬ"), "rpui.Fonts.Seasonpass.PremiumButton" or sbmr:GetFont(), sbmr_w * 0.5, sbmr_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetAlphaMultiplier(1)
		end
		buy_menu_mainholder_right_button.PaintOver = function(sbmro, sbmro_w, sbmro_h)
			rpui.DrawStencilBorder(sbmro, 0, 0, sbmro_w, sbmro_h, 0.06, ColorAlpha(color_prem_1, buy_menu:GetAlpha()), ColorAlpha(color_prem_2, buy_menu:GetAlpha()))
		end
		buy_menu_mainholder_right_button.DoClick = function()
			if self.BuyingPass and self.BuyingPass > CurTime() then
				return
			end

			self:CreateDepositPanel(self.BuyMenu, buy_menu_mainholder_right_button, true, "triple")
			self.BuyingPass = CurTime() + 3
		end

		buy_menu_mainholder_right.Priceholder = vgui.Create("DPanel", buy_menu_mainholder_right)
		local buy_menu_mainholder_right_priceholder = buy_menu_mainholder_right.Priceholder
		buy_menu_mainholder_right_priceholder:Dock(BOTTOM)
		buy_menu_mainholder_right_priceholder:DockMargin(0, 0, 0, self.innerPadding)
		buy_menu_mainholder_right_priceholder:InvalidateParent(true)

		local text_price_triple = translates.Get("%s₽", season.TriplePremiumCost or 1490)
		local text_r_price_triple = text_price_triple
		local off_x_6
		local off_x_7
		local text_fake_2

		if fake_buy_sp_3 then
			surface.SetFont("rpui.Fonts.Seasonpass.TitlePremium")
			off_x_6 = surface.GetTextSize(text_price_triple .. ' ')
			off_x_7 = surface.GetTextSize(text_price_triple)

			text_fake_2 = translates.Get("%s₽", fake_buy_sp_3)

			text_price_triple = text_price_triple .. ' ' .. text_fake_2
		end

		surface.SetFont("rpui.Fonts.Seasonpass.TitlePremium")
		local off_x_3 = surface.GetTextSize(text_price_triple)

		buy_menu_mainholder_right_priceholder.Paint = function(sbmp, sbmp_w, sbmp_h)
			draw.SimpleText(text_by .. " ", "rpui.Fonts.Seasonpass.QuestTitle", sbmp_w / 2 - (off_x_3 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5 + self.innerPadding * 0.2, rpui.UIColors.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

			if fake_buy_sp_1 then
				draw.SimpleText(text_r_price_triple, "rpui.Fonts.Seasonpass.TitlePremium", sbmp_w / 2 - (off_x_3 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5, Color(150, 150, 150, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				surface.SetDrawColor(190, 190, 190, 255)
				surface.DrawRect(sbmp_w / 2 - (off_x_3 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5, off_x_7, 3)

				draw.SimpleText(text_fake_2, "rpui.Fonts.Seasonpass.TitlePremium", sbmp_w / 2 - (off_x_3 - off_x_1) / 2 + self.innerPadding * 0.2 + off_x_6, sbmp_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			else
				draw.SimpleText(text_r_price_triple, "rpui.Fonts.Seasonpass.TitlePremium", sbmp_w / 2 - (off_x_3 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		end
		buy_menu_mainholder_right_priceholder:SizeToContentsY(4)

		buy_menu_mainholder_right.Seasons = vgui.Create("DLabel", buy_menu_mainholder_right)
		local buy_menu_mainholder_right_seasons = buy_menu_mainholder_right.Seasons
		buy_menu_mainholder_right_seasons:Dock(BOTTOM)
		buy_menu_mainholder_right_seasons:DockMargin(0, 0, 0, self.innerPadding * 0.8)
		buy_menu_mainholder_right_seasons:SetTextColor(rpui.UIColors.White)
		buy_menu_mainholder_right_seasons:SetFont("rpui.Fonts.Seasonpass.QuestTitle")
		buy_menu_mainholder_right_seasons:SetText(translates.Get("на 3 сезона"))
		buy_menu_mainholder_right_seasons:SetContentAlignment(5)
		buy_menu_mainholder_right_seasons:SizeToContentsY()
		buy_menu_mainholder_right_seasons:InvalidateParent(true)

		buy_menu_mainholder_right.PassText = vgui.Create("DLabel", buy_menu_mainholder_right)
		local buy_menu_mainholder_right_passtext = buy_menu_mainholder_right.PassText
		buy_menu_mainholder_right_passtext:Dock(BOTTOM)
		buy_menu_mainholder_right_passtext:DockMargin(0, 0, 0, self.innerPadding * -0.4)
		buy_menu_mainholder_right_passtext:SetTextColor(rpui.UIColors.White)
		buy_menu_mainholder_right_passtext:SetFont("rpui.Fonts.Seasonpass.QuestTitle")
		buy_menu_mainholder_right_passtext:SetText(translates.Get("RP ПРОПУСК"))
		buy_menu_mainholder_right_passtext:SetContentAlignment(5)
		buy_menu_mainholder_right_passtext:SizeToContentsY()
		buy_menu_mainholder_right_passtext:InvalidateParent(true)

		buy_menu_mainholder_right.Image = vgui.Create("DPanel", buy_menu_mainholder_right)
		local buy_menu_mainholder_right_image = buy_menu_mainholder_right.Image
		buy_menu_mainholder_right_image:Dock(FILL)
		buy_menu_mainholder_right_image:DockMargin(0, 0, 0, self.innerPadding)
		buy_menu_mainholder_right_image:InvalidateParent(true)
		buy_menu_mainholder_right_image.Paint = function(sbmri, sbmri_w, sbmri_h)
			local l_wide
			local l_tall

			if sbmri_w > sbmri_h then
				l_tall = 0.45 * dframeH
				l_wide = 0.55 * l_tall

			else
				l_wide = 0.65 * sbmri_w
				l_tall = 1.8 * l_wide
			end

			surface.SetDrawColor(season.BackBuyPremColorRight or Color(110, 40, 170, 255))
			surface.SetMaterial(prem_back_mat)
			surface.DrawTexturedRect((sbmri_w - l_wide) / 2, sbmri_h - l_tall * 0.96, l_wide, l_tall)

			surface.SetDrawColor(Color(255, 255, 255, 255))
			surface.SetMaterial(season.BackBuyPremImageRight)
			surface.DrawTexturedRect((sbmri_w - l_tall) / 2, sbmri_h - l_tall, l_tall, l_tall)
		end
	end


    buy_menu.Footer = vgui.Create("Panel", buy_menu)
	local buy_menu_footer = buy_menu.Footer
    buy_menu_footer:Dock(BOTTOM)
    buy_menu_footer:DockMargin(self.innerPadding * 2, self.innerPadding, self.innerPadding * 2, self.innerPadding)
    buy_menu_footer:SetTall(dframeH * 0.08)
    buy_menu_footer:InvalidateParent(true)

    buy_menu_footer.Line1 = vgui.Create("DLabel", buy_menu_footer)
	local buy_menu_footer_line1 = buy_menu_footer.Line1
    buy_menu_footer_line1:Dock(TOP)
    buy_menu_footer_line1:SetTextColor(self.UIColors.White or rpui.UIColors.White)
    buy_menu_footer_line1:SetFont("rpui.Fonts.Seasonpass.QuestTitle")
    buy_menu_footer_line1:SetText(translates.Get("RP ПРОПУСК позволит вам получать больше наград!"))
    buy_menu_footer_line1:SetContentAlignment(5)
	buy_menu_footer_line1:SizeToContentsY()
	buy_menu_footer_line1:SizeToContentsX()

    buy_menu_footer.Line2 = vgui.Create("DLabel", buy_menu_footer)
	local buy_menu_footer_line2 = buy_menu_footer.Line2
    buy_menu_footer_line2:Dock(TOP)
    buy_menu_footer_line2:SetTextColor(self.UIColors.White or rpui.UIColors.White)
    buy_menu_footer_line2:SetFont("rpui.Fonts.Seasonpass.QuestTitle")
    buy_menu_footer_line2:SetText(translates.Get("Покупая пропуск вы получаете его возможности на всех серверах."))
    buy_menu_footer_line2:SetContentAlignment(5)
	buy_menu_footer_line2:SizeToContentsY()
	buy_menu_footer_line2:SizeToContentsX()

	timer.Simple(0, function()
		buy_menu_footer:SizeToChildren(false, true)
	end)

	buy_menu:SetAlpha(0)
	buy_menu:SetVisible(false)
end


function PANEL:OpenLevelsBuyMenu()
	if not IsValid(self.LevelsBuyMenu) then
		self:CreateLevelsBuyMenu()
	end

	if IsValid(self.ThanksMenu) and self.ThanksMenu.IsVisible(self.ThanksMenu) and self.ThanksMenu.GetAlpha(self.ThanksMenu) > 0 then
		self.ThanksMenu.AlphaTo(self.ThanksMenu, 0, 0.2, 0, function()
			self.ThanksMenu.SetVisible(self.ThanksMenu, false)
		end)
	end

	if IsValid(self.BuyMenu) and self.BuyMenu.IsVisible(self.BuyMenu) and self.BuyMenu.GetAlpha(self.BuyMenu) > 0 then
		self.BuyMenu.AlphaTo(self.BuyMenu, 0, 0.2, 0, function()
			self.BuyMenu.SetVisible(self.BuyMenu, false)
		end)
	end

	self.LevelsBuyMenu.SetAlpha(self.LevelsBuyMenu, 0)
	self.LevelsBuyMenu.SetVisible(self.LevelsBuyMenu, true)

	self.LevelsBuyMenu.AlphaTo(self.LevelsBuyMenu, 255, 0.2, 0)
end


function PANEL:CreateLevelsBuyMenu()
    local dframeW, dframeH = self:GetSize()
	local season = rp.seasonpass.GetSeason()
	local levels = season.PaidLevels or {}
	local unlock_one_cost = season.OneLevelCost or 35
	local unlock_all_cost = season.UnlockAllCost or 1199

	if IsValid(self.LevelsBuyMenu) then
		self.LevelsBuyMenu.Remove(self.LevelsBuyMenu)
	end

	local discount = math.ceil(260 - 10 * LocalPlayer():SeasonGetLevel() / season.MaxLevel) / 10

	self.LevelsBuyMenu = vgui.Create('DPanel', self)
	local buy_menu = self.LevelsBuyMenu
	buy_menu:SetSize(dframeW, dframeH)
	buy_menu.Paint = function(sbp, sbp_w, sbp_h)
		draw.Blur(sbp)

		surface.SetDrawColor(sbp.Shading)
		surface.DrawRect(0, 0, sbp_w, sbp_h)
	end
	buy_menu.Shading = Color(0, 0, 0, 210)
	buy_menu:DockPadding(self.innerPadding, self.innerPadding, self.innerPadding, self.innerPadding)

    buy_menu.Header = vgui.Create("Panel", buy_menu)
	local buy_menu_header = buy_menu.Header
    buy_menu_header:Dock(TOP)
    buy_menu_header:DockMargin(self.innerPadding * 2, self.innerPadding * 1.4, self.innerPadding * 2, 0)
    buy_menu_header:SetTall(dframeH * 0.1)
    buy_menu_header:InvalidateParent(true)

    buy_menu_header.Title = vgui.Create("DLabel", buy_menu_header)
	local buy_menu_header_title = buy_menu_header.Title
    buy_menu_header_title:Dock(LEFT)
    buy_menu_header_title:SetTextColor(self.UIColors.White or rpui.UIColors.White)
    buy_menu_header_title:SetFont("rpui.Fonts.Seasonpass.TitlePremium")
    buy_menu_header_title:SetText(translates.Get("ОТКРЫТЬ УРОВНИ"))
    buy_menu_header_title:SizeToContentsX()
    buy_menu_header_title:SizeToContentsY()

    buy_menu_header:SizeToChildren(false, true)

    buy_menu.CloseButton = vgui.Create("DButton", buy_menu)
	local buy_menu_closebutton = buy_menu.CloseButton
    buy_menu_closebutton:SetFont("rpui.Fonts.Seasonpass.Small")
    buy_menu_closebutton:SetText(translates.Get("ЗАКРЫТЬ"))
    buy_menu_closebutton:SizeToContentsY(dframeH * 0.015)
    buy_menu_closebutton:SizeToContentsX(buy_menu_closebutton:GetTall() + dframeW * 0.025)
    buy_menu_closebutton:SetPos(self.GetChildPosition(self, self.Header.CloseButton))
    buy_menu_closebutton.Paint = function(this_cb, this_cbw, this_cbh)
        local baseColor, textColor = self.GetPaintStyle(this_cb)
        surface.SetDrawColor(baseColor)
        surface.DrawRect(0, 0, this_cbw, this_cbh)

        surface.SetDrawColor(self.UIColors.White or rpui.UIColors.White)
        surface.DrawRect(0, 0, this_cbh, this_cbh)

        surface.SetDrawColor(Color(0,0,0,this_cb._grayscale or 0))
        local p = 0.1 * this_cbh
        surface.DrawLine(this_cbh, p, this_cbh, this_cbh - p)

        draw.SimpleText("✕", "rpui.Fonts.Seasonpass.Small", this_cbh/2, this_cbh/2, self.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
        draw.SimpleText(this_cb:GetText(), this_cb:GetFont(), this_cbw/2 + this_cbh/2, this_cbh/2, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

        return true
    end
    buy_menu_closebutton.DoClick = function()
		buy_menu:AlphaTo(0, 0.2, 0, function()
			buy_menu:SetVisible(false)
		end)
	end


    buy_menu.Mainholder = vgui.Create("Panel", buy_menu)
	local buy_menu_mainholder = buy_menu.Mainholder
    buy_menu_mainholder:Dock(FILL)
    buy_menu_mainholder:DockMargin(self.innerPadding * 2, self.innerPadding, self.innerPadding * 2, 0)
    buy_menu_mainholder:InvalidateParent(true)

	buy_menu_mainholder.Left = vgui.Create("Panel", buy_menu_mainholder)
		local buy_menu_mainholder_left = buy_menu_mainholder.Left
		buy_menu_mainholder_left:Dock(LEFT)
		buy_menu_mainholder_left:DockMargin(dframeW * 0.04, 0, dframeW * 0.07, self.innerPadding * 2)
		buy_menu_mainholder_left:SetWide(dframeW * 0.22)
		buy_menu_mainholder_left:InvalidateParent(true)

		buy_menu_mainholder_left.Button = vgui.Create("DButton", buy_menu_mainholder_left)
		local buy_menu_mainholder_left_button = buy_menu_mainholder_left.Button
		buy_menu_mainholder_left_button:Dock(BOTTOM)
		buy_menu_mainholder_left_button:DockMargin(dframeW * 0.22 * 0.05, 0, dframeW * 0.22 * 0.05, 0)
		buy_menu_mainholder_left_button:SetTall(dframeH * 0.06)
		buy_menu_mainholder_left_button:SetText("")

		local color_la_1 = season.UnlockAllColor or Color(235, 75, 75)
		local color_la_2 = Color(color_la_1.r * 0.7, color_la_1.g * 0.7, color_la_1.b * 0.7)

		buy_menu_mainholder_left_button.Paint = function(sbml, sbml_w, sbml_h)
			surface.SetDrawColor(Color(0, 0, 0, 100))
			surface.DrawRect(0, 0, sbml_w, sbml_h)

			local hovered = sbml:IsHovered()

			sbml.rotAngle = (sbml.rotAngle or 0) + 100 * FrameTime()
			sbml._alpha = math.Approach(sbml._alpha or 0, (hovered or sbml.Selected) and 255 or 0, 768 * FrameTime())

			local distsize  = math.sqrt(sbml_w * sbml_w + sbml_h * sbml_h)
			local parentalpha = buy_menu:GetAlpha() / 255
			local alphamult   = sbml._alpha / 255

			surface.SetAlphaMultiplier(parentalpha * alphamult)
				surface.SetDrawColor(color_la_1)
				surface.DrawRect(0, 0, sbml_w, sbml_h)

				surface.SetMaterial(rpui.GradientMat)
				surface.SetDrawColor(color_la_2)
				surface.DrawTexturedRectRotated(sbml_w * 0.5, sbml_h * 0.5, distsize, distsize, sbml.rotAngle or 0)

			surface.SetAlphaMultiplier(parentalpha)
				draw.SimpleText(self.BuyingPass and self.BuyingPass > CurTime() and translates.Get("ПОДОЖДИТЕ...") or translates.Get("КУПИТЬ"), "rpui.Fonts.Seasonpass.PremiumButton" or sbml:GetFont(), sbml_w * 0.5, sbml_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetAlphaMultiplier(1)
		end
		buy_menu_mainholder_left_button.PaintOver = function(sbmlo, sbmlo_w, sbmlo_h)
			rpui.DrawStencilBorder(sbmlo, 0, 0, sbmlo_w, sbmlo_h, 0.06, ColorAlpha(color_la_1, buy_menu:GetAlpha()), ColorAlpha(color_la_2, buy_menu:GetAlpha()))
		end
		buy_menu_mainholder_left_button.DoClick = function(spt)
			if self.BuyingPass and self.BuyingPass > CurTime() then
				return
			end

			self:CreateDepositPanel(self.LevelsBuyMenu, spt, false, 0, function(is_robo)
				if not IsValid(self) then return end

				net.Start("Seasonpass::BuyLevels")
					net.WriteBool(is_robo)
					net.WriteUInt(0, 8)
				net.SendToServer()

				self.BuyingPass = CurTime() + 3
			end, buy_menu_mainholder_left.Button.GetWide(buy_menu_mainholder_left.Button))

			self.BuyingPass = CurTime() + 3
		end

		buy_menu_mainholder_left.Priceholder = vgui.Create("DPanel", buy_menu_mainholder_left)
		local buy_menu_mainholder_left_priceholder = buy_menu_mainholder_left.Priceholder
		buy_menu_mainholder_left_priceholder:Dock(BOTTOM)
		buy_menu_mainholder_left_priceholder:DockMargin(0, 0, 0, self.innerPadding)
		buy_menu_mainholder_left_priceholder:InvalidateParent(true)

		local text_by = translates.Get("за")
		local text_price = translates.Get("%s₽", unlock_all_cost)
		local text_r_price = text_price
		local off_x_4
		local off_x_5
		local text_fake_1

		if fake_buy_all then
			surface.SetFont("rpui.Fonts.Seasonpass.TitlePremium")
			off_x_4 = surface.GetTextSize(text_price .. ' ')
			off_x_5 = surface.GetTextSize(text_price)

			text_fake_1 = translates.Get("%s₽", fake_buy_all)

			text_price = text_price .. ' ' .. text_fake_1
		end

		surface.SetFont("rpui.Fonts.Seasonpass.QuestTitle")
		local off_x_1 = surface.GetTextSize(text_by)
		surface.SetFont("rpui.Fonts.Seasonpass.TitlePremium")
		local off_x_2 = surface.GetTextSize(text_price)

		buy_menu_mainholder_left_priceholder.Paint = function(sbmp, sbmp_w, sbmp_h)
			draw.SimpleText(text_by .. " ", "rpui.Fonts.Seasonpass.QuestTitle", sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5 + self.innerPadding * 0.2, rpui.UIColors.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

			if fake_buy_all then
				draw.SimpleText(text_r_price, "rpui.Fonts.Seasonpass.TitlePremium", sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5, Color(150, 150, 150, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				surface.SetDrawColor(190, 190, 190, 255)
				surface.DrawRect(sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5, off_x_5, 3)

				draw.SimpleText(text_fake_1, "rpui.Fonts.Seasonpass.TitlePremium", sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + self.innerPadding * 0.2 + off_x_4, sbmp_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			else
				draw.SimpleText(text_r_price, "rpui.Fonts.Seasonpass.TitlePremium", sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		end
		buy_menu_mainholder_left_priceholder:SizeToContentsY(4)

		buy_menu_mainholder_left.Image = vgui.Create("DPanel", buy_menu_mainholder_left)
		local buy_menu_mainholder_left_image = buy_menu_mainholder_left.Image
		buy_menu_mainholder_left_image:Dock(FILL)
		buy_menu_mainholder_left_image:DockMargin(0, 0, 0, self.innerPadding * 0.1)
		buy_menu_mainholder_left_image:InvalidateParent(true)
		buy_menu_mainholder_left_image.CreatedAt = CurTime() + 0.5
		buy_menu_mainholder_left_image.Paint = function(sbmli, sbmli_w, sbmli_h)
			local r_wide
			local r_tall

			if sbmli_w > sbmli_h then
				r_tall = 0.45 * dframeH
				r_wide = 0.55 * r_tall

			else
				r_wide = 0.65 * sbmli_w
				r_tall = 1.8 * r_wide
			end

			r_tall = r_tall * 1.2

			surface.SetDrawColor(color_la_1)
			surface.SetMaterial(prem_back_mat)
			surface.DrawTexturedRect((sbmli_w - r_wide) / 2, sbmli_h - r_tall * 0.96, r_wide, r_tall)

			draw.Blur(sbmli)

			surface.SetDrawColor(ColorAlpha(color_la_1, 150))
			surface.SetMaterial(prem_back_mat)
			surface.DrawTexturedRect((sbmli_w - r_wide) / 2, sbmli_h - r_tall * 0.96, r_wide, r_tall)


			draw.SimpleText(rp.cfg.IsFrance and translates.Get("term.deblock") or translates.Get("Открыть"), "rpui.Fonts.Seasonpass.TitlePremium", sbmli_w / 2, sbmli_h * 0.38 - self.innerPadding * 4, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			draw.SimpleText(translates.Get("ВСЁ"), "rpui.Fonts.Seasonpass.TitleBuyLevel", sbmli_w / 2, sbmli_h * 0.38, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			draw.SimpleText("+", "rpui.Fonts.Seasonpass.TitleBuyLevel", sbmli_w / 2, sbmli_h * 0.38 + self.innerPadding * 5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			draw.SimpleText(translates.Get("ГЛОБАЛЬНЫЙ"), "rpui.Fonts.Seasonpass.HeadTitleUsual", sbmli_w / 2, sbmli_h * 0.38 + self.innerPadding * 9, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			draw.SimpleText(translates.Get("RP ПРОПУСК"), "rpui.Fonts.Seasonpass.QuestTitle", sbmli_w / 2, sbmli_h * 0.38 + self.innerPadding * 10.8, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)


			local cir_pos_x = (sbmli_w - r_wide) / 2 + r_wide - sbmli_w * 0.26 * 0.66
			local cir_pos_y = sbmli_h - r_tall * 0.96 - sbmli_w * 0.26 * 0.34
			local cir_radius = sbmli_w * 0.13

			cir_pos_x = cir_pos_x + cir_radius
			cir_pos_y = cir_pos_y + cir_radius

			if not sbmli.BakedCircle then
				if sbmli.CreatedAt > CurTime() then return end

				cir_radius = cir_radius * 0.96
				local cir = {}

				table.insert( cir, { x = cir_pos_x, y = cir_pos_y } )
				for i = 0, 20 do
					local a = math.rad( ( i / 20 ) * -360 )
					table.insert( cir, { x = cir_pos_x + math.sin( a ) * cir_radius, y = cir_pos_y + math.cos( a ) * cir_radius } )
				end

				local ab = math.rad( 0 )
				table.insert( cir, { x = cir_pos_x + math.sin( ab ) * cir_radius, y = cir_pos_y + math.cos( ab ) * cir_radius } )

				sbmli.BakedCircle = cir

			else
				sbmli.AlphaToDiscount = (sbmli.AlphaToDiscount or 0) + (255 - (sbmli.AlphaToDiscount or 0)) * 7 * FrameTime()

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

					draw.NoTexture()
					surface.SetDrawColor(rpui.UIColors.White)
					surface.DrawPoly( sbmli.BakedCircle )

					render.SetStencilCompareFunction( STENCIL_EQUAL );
					render.SetStencilFailOperation( STENCIL_KEEP );

					render.SetStencilReferenceValue( 1 );

					sbmli.rotAngle = (sbmli.rotAngle or 0) + 100 * FrameTime();

					local distsize  = math.sqrt( cir_radius*cir_radius*4 + cir_radius*cir_radius*4 );
					local parentalpha = self.GetAlpha(self) / 255;
					local bs = rpui.PowOfTwo(cir_radius * 2 * 0.03);

					surface.SetDrawColor( ColorAlpha(self.RainbowColor, sbmli.AlphaToDiscount) );
					surface.DrawRect( cir_pos_x - cir_radius, cir_pos_y - cir_radius, cir_radius * 2, cir_radius * 2 );

					surface.SetMaterial( rpui.GradientMat );
					surface.SetDrawColor( ColorAlpha(self.RainbowRotate, sbmli.AlphaToDiscount) );
					surface.DrawTexturedRectRotated( cir_pos_x, cir_pos_y, distsize, distsize, (sbmli.rotAngle or 0) );

					draw.SimpleText(translates.Get("ВЫГОДА"), "rpui.Fonts.Seasonpass.HeadTitlePremium2", cir_pos_x, cir_pos_y, ColorAlpha(rpui.UIColors.White, sbmli.AlphaToDiscount), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM)
					draw.SimpleText(discount .. "%", "rpui.Fonts.Seasonpass.QuestTitle", cir_pos_x, cir_pos_y - self.innerPadding * 0.4, ColorAlpha(rpui.UIColors.White, sbmli.AlphaToDiscount), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

				render.SetStencilEnable(false)
			end
		end

	for k, v in pairs(levels) do
		if LocalPlayer():SeasonGetLevel() > (season.MaxLevel - v.levels) then
			continue
		end

		buy_menu_mainholder.Right = vgui.Create("Panel", buy_menu_mainholder)
		buy_menu_mainholder_leftb = buy_menu_mainholder.Right
		buy_menu_mainholder_leftb:Dock(LEFT)
		buy_menu_mainholder_leftb:DockMargin(-dframeW * 0.07, 0, 0, self.innerPadding * 2)
		buy_menu_mainholder_leftb:SetWide(dframeW * 0.22)
		buy_menu_mainholder_leftb:InvalidateParent(true)

		buy_menu_mainholder_leftb.ButtonAdditional = vgui.Create("DButton", buy_menu_mainholder_leftb)
		buy_menu_mainholder_left_button = buy_menu_mainholder_leftb.ButtonAdditional
		buy_menu_mainholder_left_button:Dock(BOTTOM)
		buy_menu_mainholder_left_button:DockMargin((dframeW * 0.22 - dframeH * 0.25) / 2, 0, (dframeW * 0.22 - dframeH * 0.25) / 2, 0)
		buy_menu_mainholder_left_button:SetTall(dframeH * 0.06)
		buy_menu_mainholder_left_button:SetText("")

		local color_l_1 = v.color
		local color_l_2 = Color(color_l_1.r * 0.7, color_l_1.g * 0.7, color_l_1.b * 0.7)

		buy_menu_mainholder_left_button.Paint = function(sbml, sbml_w, sbml_h)
			surface.SetDrawColor(Color(0, 0, 0, 100))
			surface.DrawRect(0, 0, sbml_w, sbml_h)

			local hovered = sbml:IsHovered()

			sbml.rotAngle = (sbml.rotAngle or 0) + 100 * FrameTime()
			sbml._alpha = math.Approach(sbml._alpha or 0, (hovered or sbml.Selected) and 255 or 0, 768 * FrameTime())

			local distsize  = math.sqrt(sbml_w * sbml_w + sbml_h * sbml_h)
			local parentalpha = buy_menu:GetAlpha() / 255
			local alphamult   = sbml._alpha / 255

			surface.SetAlphaMultiplier(parentalpha * alphamult)
				surface.SetDrawColor(color_l_1)
				surface.DrawRect(0, 0, sbml_w, sbml_h)

				surface.SetMaterial(rpui.GradientMat)
				surface.SetDrawColor(color_l_2)
				surface.DrawTexturedRectRotated(sbml_w * 0.5, sbml_h * 0.5, distsize, distsize, sbml.rotAngle or 0)

			surface.SetAlphaMultiplier(parentalpha)
				draw.SimpleText(self.BuyingPass and self.BuyingPass > CurTime() and translates.Get("ПОДОЖДИТЕ...") or translates.Get("КУПИТЬ"), "rpui.Fonts.Seasonpass.PremiumButton" or sbml:GetFont(), sbml_w * 0.5, sbml_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			surface.SetAlphaMultiplier(1)
		end
		buy_menu_mainholder_left_button.PaintOver = function(sbmlo, sbmlo_w, sbmlo_h)
			rpui.DrawStencilBorder(sbmlo, 0, 0, sbmlo_w, sbmlo_h, 0.06, ColorAlpha(color_l_1, buy_menu:GetAlpha()), ColorAlpha(color_l_2, buy_menu:GetAlpha()))
		end
		buy_menu_mainholder_left_button.DoClick = function(spk)
			if self.BuyingPass and self.BuyingPass > CurTime() then
				return
			end

			self:CreateDepositPanel(self.LevelsBuyMenu, spk, false, k, function(is_robo)
				if not IsValid(self) then return end

				net.Start("Seasonpass::BuyLevels")
					net.WriteBool(is_robo)
					net.WriteUInt(k, 8)
				net.SendToServer()

				self.BuyingPass = CurTime() + 3
			end, buy_menu_mainholder_left.Button.GetWide(buy_menu_mainholder_left.Button))

			self.BuyingPass = CurTime() + 3
		end

		buy_menu_mainholder_leftb.Priceholder = vgui.Create("DPanel", buy_menu_mainholder_leftb)
		buy_menu_mainholder_left_priceholder = buy_menu_mainholder_leftb.Priceholder
		buy_menu_mainholder_left_priceholder:Dock(BOTTOM)
		buy_menu_mainholder_left_priceholder:DockMargin(0, 0, 0, self.innerPadding)
		buy_menu_mainholder_left_priceholder:InvalidateParent(true)

		local text_by = translates.Get("за")
		local text_price = translates.Get("%s₽", fake_buy_ls and fake_buy_ls[k] or v.levels * unlock_one_cost)
		local text_r_price = text_price
		local off_x_4
		local off_x_5
		local text_fake_1

		if fake_buy and fake_buy[k] then
			surface.SetFont("rpui.Fonts.Seasonpass.TitlePremium")
			off_x_4 = surface.GetTextSize(text_price .. ' ')
			off_x_5 = surface.GetTextSize(text_price)

			text_fake_1 = translates.Get("%s₽", fake_buy[k])

			text_price = text_price .. ' ' .. text_fake_1
		end


		surface.SetFont("rpui.Fonts.Seasonpass.QuestTitle")
		local off_x_1 = surface.GetTextSize(text_by)
		surface.SetFont("rpui.Fonts.Seasonpass.TitlePremium")
		local off_x_2 = surface.GetTextSize(text_price)

		buy_menu_mainholder_left_priceholder.Paint = function(sbmp, sbmp_w, sbmp_h)
			draw.SimpleText(text_by .. " ", "rpui.Fonts.Seasonpass.QuestTitle", sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5 + self.innerPadding * 0.2, rpui.UIColors.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER)

			if fake_buy and fake_buy[k] then
				draw.SimpleText(text_r_price, "rpui.Fonts.Seasonpass.TitlePremium", sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5, Color(150, 150, 150, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

				surface.SetDrawColor(190, 190, 190, 255)
				surface.DrawRect(sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5, off_x_5, 3)

				draw.SimpleText(text_fake_1, "rpui.Fonts.Seasonpass.TitlePremium", sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + off_x_4, sbmp_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)

			else
				draw.SimpleText(text_r_price, "rpui.Fonts.Seasonpass.TitlePremium", sbmp_w / 2 - (off_x_2 - off_x_1) / 2 + self.innerPadding * 0.2, sbmp_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER)
			end
		end
		buy_menu_mainholder_left_priceholder:SizeToContentsY(4)

		buy_menu_mainholder_leftb.Image = vgui.Create("DPanel", buy_menu_mainholder_leftb)
		buy_menu_mainholder_left_image = buy_menu_mainholder_leftb.Image
		buy_menu_mainholder_left_image:Dock(FILL)
		buy_menu_mainholder_left_image:DockMargin(0, 0, 0, self.innerPadding * 2)
		buy_menu_mainholder_left_image:InvalidateParent(true)
		buy_menu_mainholder_left_image.Paint = function(sbmli, sbmli_w, sbmli_h)
			local r_wide
			local r_tall

			if sbmli_w > sbmli_h then
				r_tall = 0.45 * dframeH
				r_wide = 0.55 * r_tall

			else
				r_wide = 0.65 * sbmli_w
				r_tall = 1.8 * r_wide
			end

			surface.SetDrawColor(v.color or Color(110, 40, 170, 255))
			surface.SetMaterial(prem_back_mat)
			surface.DrawTexturedRect((sbmli_w - r_wide) / 2, sbmli_h - r_tall * 0.96, r_wide, r_tall)

			draw.SimpleText("+" .. v.levels, "rpui.Fonts.Seasonpass.TitleBuyLevel", sbmli_w / 2, sbmli_h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)

			draw.SimpleText(translates.Get("УРОВНЕЙ"), "rpui.Fonts.Seasonpass.TitlePremium", sbmli_w / 2, sbmli_h * 0.5 + self.innerPadding * 4, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
	end

    buy_menu.Footer = vgui.Create("Panel", buy_menu)
	buy_menu_footer = buy_menu.Footer
    buy_menu_footer:Dock(BOTTOM)
    buy_menu_footer:DockMargin(self.innerPadding * 2, self.innerPadding * 2, self.innerPadding * 2, self.innerPadding)
    buy_menu_footer:SetTall(dframeH * 0.08)
    buy_menu_footer:InvalidateParent(true)

    buy_menu_footer.Line1 = vgui.Create("DLabel", buy_menu_footer)
	buy_menu_footer_line1 = buy_menu_footer.Line1
    buy_menu_footer_line1:Dock(TOP)
    buy_menu_footer_line1:SetTextColor(self.UIColors.White or rpui.UIColors.White)
    buy_menu_footer_line1:SetFont("rpui.Fonts.Seasonpass.QuestTitle")
    buy_menu_footer_line1:SetText(translates.Get("Вы можете мгновенно открыть уровни и получить награды"))
    buy_menu_footer_line1:SetContentAlignment(5)
	buy_menu_footer_line1:SizeToContentsY()
	buy_menu_footer_line1:SizeToContentsX()

	timer.Simple(0, function()
		buy_menu_footer:SizeToChildren(false, true)
	end)

	buy_menu:SetAlpha(0)
	buy_menu:SetVisible(false)
end

return PANEL