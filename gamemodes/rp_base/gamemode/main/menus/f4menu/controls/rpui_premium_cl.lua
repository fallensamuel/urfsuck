-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_premium_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

rpui.UIColors.White = Color(255, 255, 255, 255)
local my_new_color = rpui.UIColors.White
local my_new_color2 = rpui.UIColors.BackgroundGold
local my_new_color3 = rpui.UIColors.Gold

local hue = SysTime()*0.1 % 360
local RainbowColor = HSVToColor(hue, 0.77, 0.77)
local RainbowRotate = HSLToColor(hue, 0.90, 0.40)

local net_in_progress = false

net.Receive('Donate::GetPremiumID', function()
	if rp.cfg.IsTestServer then
		gui.OpenURL('https://urf.im/page/info')
		return
	end

	if rp.cfg.IsFrance then
		gui.OpenURL('https://urfim.fr/page/premium?id=' .. net.ReadUInt(32) .. '#subscribe')
	end

	net_in_progress = false
end)

return {
            MenuPaint = function( this15, w, h )
                this15.rotAngle = (this15.rotAngle or 0) + 100 * FrameTime();

                surface.SetDrawColor( Color(0,0,0) );
                surface.DrawRect( 0, 0, w, h );

				hue = SysTime()*0.1 % 360
				RainbowColor = HSVToColor(hue, 0.77, 0.77)
				RainbowRotate = HSLToColor(hue, 0.90, 0.40)

				rpui.GetPaintStyle( this15, STYLE_GOLDEN );

                local distsize  = math.sqrt( w*w + h*h );

                local parentalpha = this15.Base.GetAlpha(this15.Base) / 255;
                local alphamult   = this15._alpha / 255;

                surface.SetAlphaMultiplier( parentalpha * alphamult );
                    surface.SetDrawColor( RainbowColor );
                    surface.DrawRect( 0, 0, w, h );

                    surface.SetMaterial( rpui.GradientMat );
                    surface.SetDrawColor( RainbowRotate );
                    surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this15.rotAngle or 0) );

                    draw.SimpleText( this15:GetText(), "rpui.Fonts.DonateMenu.MenuButtonBigBold2", w * 0.5, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                surface.SetAlphaMultiplier( parentalpha * (1 - alphamult) );
                    draw.SimpleText( this15:GetText(), "rpui.Fonts.DonateMenu.MenuButtonBigBold2", w * 0.5, h * 0.5, RainbowColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                surface.SetAlphaMultiplier( 1 );

                return true
            end,

            MenuPaintOver = function( this14, w, h )
                if this14.Base.GetAlpha(this14.Base) == 255 then
                    rpui.DrawStencilBorder( this14, 0, 0, w, h, 0.06, RainbowColor, RainbowRotate );
                end
            end,

			FrameCreation = function( this, w, h, menu_btn )
				this:Dock(FILL)

				local pad = rpui.DonateMenu.innerPadding

				function this:CreateDepositPanel( pnl )
					local alignTop = true

					if not self.DepositPanel then
						self.DepositPanel = vgui.Create( "Panel", rpui.DonateMenu );
						local deposit = self.DepositPanel;

						deposit:SetWide( pnl:GetWide(pnl) );
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
							size     = rpui.DonateMenu.frameH * 0.025,
							extended = true,
						} );

						surface.CreateFont( "DepositPanel.Small", {
							font     = "Montserrat",
							size     = rpui.DonateMenu.frameH * 0.0175,
							extended = true,
						} );

						surface.CreateFont( "DepositPanel.InputBold", {
							font      = "Montserrat",
							size      = rpui.DonateMenu.frameH * 0.0225,
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
						self.DepositPanel.LeftColumn.DockPadding( self.DepositPanel.LeftColumn, pad * 2, pad * 2, pad * 2, pad * 2 );
						self.DepositPanel.LeftColumn.SetWide( self.DepositPanel.LeftColumn, self.DepositPanel.GetWide(self.DepositPanel) );

						local right_col = self.DepositPanel.LeftColumn

						--self.DepositPanel.DepositContainer = vgui.Create( "Panel", right_col );
						--local dep_cont = self.DepositPanel.DepositContainer;

						--dep_cont:Dock( TOP );
						--dep_cont:DockMargin( 0, 0, 0, pad * 2 - 4 );
						--dep_cont:SetTall( pad * 10.5 + 4 );

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
							mon_dep:SizeToContentsY( pad * 2 );
							mon_dep.Paint = function( this, w, h )
								if not IsValid( self.DepositPanel ) then return end
								this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();
								local distsize  = math.sqrt( w*w + h*h );

								surface.SetAlphaMultiplier( self.DepositPanel.GetAlpha(self.DepositPanel) / 255 );
									surface.SetDrawColor(RainbowColor);
									surface.DrawRect( 0, 0, w, h );

									surface.SetMaterial( rpui.GradientMat );
									surface.SetDrawColor(RainbowRotate);
									surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

									local img_width = w * 0.9

									surface.SetDrawColor(color_white)
									surface.SetMaterial(robo_mat)
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
								gui.OpenURL('https://shop.urf.im/page/premium?steamid=' .. LocalPlayer():SteamID64() .. '&y=1#subscribe')

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
							mon_dep2:SizeToContentsY( pad * 2 );
							mon_dep2.Paint = function( this, w, h )
								if not IsValid( self.DepositPanel ) then return end
								this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();
								local distsize  = math.sqrt( w*w + h*h );

								surface.SetAlphaMultiplier( self.DepositPanel.GetAlpha(self.DepositPanel) / 255 );
									surface.SetDrawColor(RainbowColor);
									surface.DrawRect( 0, 0, w, h );

									surface.SetMaterial( rpui.GradientMat );
									surface.SetDrawColor(RainbowRotate);
									surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

									local img_width2 = w * 0.9

									surface.SetDrawColor(color_white)
									surface.SetMaterial(umoney_mat)
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
								gui.OpenURL('https://shop.urf.im/page/premium/umoney?steamid=' .. LocalPlayer():SteamID64() .. '&y=1#purchase')

								this.Timeout = SysTime() + 5;
								this:SetEnabled( false );
							end
						end

                        self.DepositPanel.MoneyDeposit3 = vgui.Create( "DButton", right_col );
						local mon_dep3 = self.DepositPanel.MoneyDeposit3;

						self.DepositPanel.MoneyDepositDesc31 = vgui.Create( "DLabel", right_col );
						local mon_dep_desc_31 = self.DepositPanel.MoneyDepositDesc31
						mon_dep_desc_31:Dock(TOP);
						mon_dep_desc_31:SetContentAlignment( 5 );
						mon_dep_desc_31:DockMargin(0, pad * 0.1, 0, 0)
						mon_dep_desc_31:SetFont("DepositPanel.Small");
						mon_dep_desc_31:SetTextColor( rpui.UIColors.White );
						mon_dep_desc_31:SetText( translates.Get(xsolla_desc[1]) );

						self.DepositPanel.MoneyDepositDesc32 = vgui.Create( "DLabel", right_col );
						local mon_dep_desc_32 = self.DepositPanel.MoneyDepositDesc32
						mon_dep_desc_32:Dock(TOP);
						mon_dep_desc_32:SetContentAlignment( 5 );
						mon_dep_desc_32:DockMargin(0, -pad * 0.7, 0, 0)
						mon_dep_desc_32:SetFont("DepositPanel.Small");
						mon_dep_desc_32:SetTextColor( rpui.UIColors.White );
						mon_dep_desc_32:SetText( translates.Get(xsolla_desc[2]) );

						mon_dep3:Dock( TOP );
						mon_dep3:SetFont( "DepositPanel.MediumBold" );
						mon_dep3:SetText( translates.Get("ПОПОЛНИТЬ СЧЁТ") );
						mon_dep3:SizeToContentsY( pad * 2 );
						mon_dep3.Paint = function( this, w, h )
							if not IsValid( self.DepositPanel ) then return end
							this.rotAngle = (this.rotAngle or 0) + 100 * FrameTime();
							local distsize  = math.sqrt( w*w + h*h );

							surface.SetAlphaMultiplier( self.DepositPanel.GetAlpha(self.DepositPanel) / 255 );
								surface.SetDrawColor(RainbowColor);
								surface.DrawRect( 0, 0, w, h );

								surface.SetMaterial( rpui.GradientMat );
								surface.SetDrawColor(RainbowRotate);
								surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this.rotAngle or 0) );

								local img_width2 = w * 0.9

								surface.SetDrawColor(color_white)
								surface.SetMaterial(xsolla_mat)
								surface.DrawTexturedRect(w * 0.05 - 1, (h - 0.125 * img_width2) * 0.5 + 1, img_width2, 0.125 * img_width2)

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
                            gui.OpenURL( string.format("https://shop.urf.im/xsolla?sid=%s&m=premium&v=%s&s=%s&l=%s", LocalPlayer():SteamID(), pnl.annual and "annual" or "nil", rp.cfg.ServerUID, rp.cfg.IsFrance and "fr" or "ru") );

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
							self.DepositPanel.SetPos( self.DepositPanel, x, y - self.DepositPanel.GetTall(self.DepositPanel) - pad * 0.5 );

							self.DepositPanel.AlphaTo( self.DepositPanel, 255, 0.25 );
						end );
					end
				end


				local pad2 = math.floor(pad / 2)
				local inner_width = rpui.DonateMenu.frameW * 0.8 - pad * 7 - 8
				local inner_height = rpui.DonateMenu.frameH - pad * 3

				local my_new_col = RainbowColor
				local bg_col = Color(0, 0, 0, 197)

				local selector_mat = Material('premium/new_selector')
				local urpass_mat = Material('premium/urpass')

				local header_tall = math.floor(rpui.DonateMenu.MenuContainer.GetTall(rpui.DonateMenu.MenuContainer) / #rpui.DonateMenu.Categories)
				local wh_bg = 0.77 * ScrH()
				local wh_bg2 = 0.58 * inner_width
				local wh_bg4 = 0.6 * inner_height
				local wh_bg3 = math.max(0.25 * 1.25 * wh_bg4, (wh_bg2 - pad * 3) / 4 - pad * 0.3)
				local wh_bg5 = math.max(wh_bg4 * 0.66, (wh_bg2 / 4) / 0.48 - pad * 2.3)


				-- PARENT
				this.p = vgui.Create( "DPanel", this );
				local p = this.p
				p:Dock(FILL)
				p:InvalidateLayout( true );
				p:InvalidateParent( true );
				p.Paint = function() end
				p.selected = 1
				p.cur_selected = p.selected


				-- HEADER
				local header = vgui.Create( "DPanel", p )
				header:SetSize(inner_width, header_tall)

				header.Paint = function( th, ww, hh )
					th.rotAngle = (th.rotAngle or 0) + 100 * FrameTime();

					surface.SetDrawColor( Color(0,0,0) );
					surface.DrawRect( 0, 0, ww, hh );

					local distsize  = math.sqrt( ww*ww + hh*hh );

					local parentalpha = rpui.DonateMenu.GetAlpha(rpui.DonateMenu) / 255;
					local alphamult   = 255;

					surface.SetAlphaMultiplier( parentalpha * alphamult );
						surface.SetDrawColor( RainbowColor );
						surface.DrawRect( 0, 0, ww, hh );

						surface.SetMaterial( rpui.GradientMat );
						surface.SetDrawColor( RainbowRotate );
						surface.DrawTexturedRectRotated( ww * 0.5, hh * 0.5, distsize, distsize, (th.rotAngle or 0) );

						draw.SimpleText( translates.Get('МАКСИМУМ УДОВОЛЬСТВИЯ ОТ ИГРЫ'), 'rpui.Fonts.DonateMenu.MenuButtonBigBold2', hh * 0.25, hh * 0.5, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_CENTER );
					surface.SetAlphaMultiplier( 1 );

					return true
				end

				local h_close = vgui.Create( "DButton", p );

				h_close:SetPos(inner_width - header_tall * 0.8, header_tall * 0.25)
				h_close:SetSize(math.ceil(header_tall * 0.5), math.ceil(header_tall * 0.5))
				h_close:SetFont( "rpui.Fonts.DonateMenu.MenuButtonBold" );
				h_close:SetText( '' );
				h_close.Paint = function( this13, w, h )
					local baseColor999 = rpui.GetPaintStyle( this13 );
					local grs = this13._grayscale or 0
					surface.SetDrawColor( Color(grs, grs, grs, 255) );
					surface.DrawRect( 0, 0, w, h );

					draw.SimpleText( "✕", "rpui.Fonts.DonateMenu.MenuButtonBold", w * 0.5, h * 0.5, Color(255 - grs, 255 - grs, 255 - grs, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

					return true
				end
				h_close.DoClick = function()
					rpui.DonateMenu.Close(rpui.DonateMenu);
				end


				-- MAIN MODEL
				if not IsValid(rpui.DonateMenu.MainModel) then
					local pnl_bg = vgui.Create( "DModelPanel", rpui.DonateMenu );
					rpui.DonateMenu.MainModel = pnl_bg

					pnl_bg.SetCursor( pnl_bg, "arrow" );
					pnl_bg.SetSize( pnl_bg, wh_bg * 0.96, wh_bg + pad * 5 + 100 ); -- 0.56
					pnl_bg.SetPos( pnl_bg, -10000, -10000 );
					pnl_bg.Pos_X = rpui.DonateMenu.frameW * 0.2 + pad * 6 - 0.2 * wh_bg
					pnl_bg.Pos_Y = ScrH() - wh_bg - pad * 5
					pnl_bg.SetModel( pnl_bg, LocalPlayer():GetModel() );
					pnl_bg.SetZPos( pnl_bg, -200 );
					pnl_bg.SetFOV( pnl_bg, 35 );
					pnl_bg.xVelocity     = 0;
					pnl_bg.xOffset       = 0;
					pnl_bg.yVelocity     = 0;
					pnl_bg.ZoomingVector = Vector(0,0,0);
					pnl_bg.LayoutEntity = function() end
					pnl_bg.Think = function( this1 )
						if IsValid(rpui.DonateMenu.OpenedCategory) and rpui.DonateMenu.OpenedCategory ~= this then
							this1:SetPos(-10000, -10000)
						else
							this1:SetPos(this1.Pos_X, this1.Pos_Y - 100)
						end

						if IsValid(this1.Entity) and this1.sequenced != p.selected then
							local job_md_dt1 = rp.teams[ rp.cfg.PremiumConfig[p.selected].job() ]
							local seq1 = rp.cfg.PremiumConfig[p.selected].sequence

							this1.SetModel( this1, istable(job_md_dt1.model) and job_md_dt1.model[1] or job_md_dt1.model );
							this1.Entity.SetSkin(this1.Entity, rp.cfg.PremiumConfig[p.selected].skin or 0)
							this1.Entity.ResetSequence(this1.Entity, seq1)
							this1.sequenced = p.selected

							this1.size_mult_big = rp.cfg.PremiumConfig[p.selected].size_mult_big or 1
							this1.viewz_big = rp.cfg.PremiumConfig[p.selected].viewZ_big or 0
						end

						this1.Entity.SetAngles( this1.Entity, Angle( 0, 55, 0 ) );
						this1.Entity.SetPos( this1.Entity, Vector(100 - 80 * this1.size_mult_big * 1.2, 100 - 80 * this1.size_mult_big * 1.2, 26 - 35 * this1.size_mult_big * 1.15 + this1.viewz_big - 3) );
					end
				end

				local urpass = vgui.Create( "DPanel", p )
				urpass:SetPos(wh_bg * 0.203, ScrH() - wh_bg * 0.6 - pad * 5)
				urpass:SetSize(wh_bg * 0.2, wh_bg * 0.2)
				urpass.Paint = function(th05, bgw4, bgh4)
					surface.SetDrawColor( Color(255, 255, 255, 255) );
					surface.SetMaterial(urpass_mat)
					surface.DrawTexturedRect( 0, 0, bgw4, bgh4 );
				end




				-- VERTICAL SCROLL
				local scroll_pnl_handler = vgui.Create( "DPanel", p );
				scroll_pnl_handler.Paint = function() end
				scroll_pnl_handler:SetSize(wh_bg2, p:GetTall())
				scroll_pnl_handler:SetPos(inner_width - wh_bg2, header_tall + pad * 2)

				local scroll_pnl = vgui.Create( "rpui.ScrollPanel", scroll_pnl_handler );
				scroll_pnl:Dock(FILL)
				scroll_pnl.SetSpacingY(scroll_pnl, 0)
				scroll_pnl.SetScrollbarMargin(scroll_pnl, 0)

				scroll_pnl.OnMouseWheeled = function(this1, dt)
					this1.ySpeed = this1.ySpeed + dt * 2
				end
				scroll_pnl.InvalidateParent(scroll_pnl, true)
				scroll_pnl.AlwaysLayout(scroll_pnl, true)


				-- BACKGROUND
				local pnl_bg2 = vgui.Create( "DPanel", p );

				pnl_bg2:SetSize(wh_bg2, wh_bg4)
				--pnl_bg2:SetPos(inner_width - wh_bg2, header_tall + pad * 2)

				pnl_bg2.Paint = function(th02, bgw1, bgh1)
					surface.SetDrawColor(bg_col)
					surface.DrawRect(0, 0, bgw1, bgh1)
				end

				scroll_pnl:AddItem(pnl_bg2)
				pnl_bg2:Dock(TOP)
				pnl_bg2:DockMargin(0, 0, pad, 0)


				-- BONUS PANELS
				local in_sz = math.floor(0.219 * wh_bg3 * 0.8)

				local bb_content = vgui.Create( "DHorizontalScroller", p );
				bb_content:SetPos(inner_width - wh_bg2, wh_bg4 + header_tall + pad * 3)
				bb_content:SetSize(wh_bg2, wh_bg3 * 0.8 * 2 + pad)
				bb_content:SetOverlap( -pad * 1.2 );
				--bb_content.Paint = function() end
				bb_content.PerformLayout = function( this12 )
					local w = this12:GetWide();
					local h = this12:GetTall();

					this12.pnlCanvas.SetTall( this12.pnlCanvas, h );

					local max_x = table.Count(this12.Panels);
					local x = 0;
					for k, v in pairs( this12.Panels ) do
						if ( !IsValid( v ) ) then continue end
						if ( !v:IsVisible() ) then continue end

						local ij_x = (LocalPlayer():HasPremium() and k == max_x) and 4 or ((k - 1) % 4)
						local ij_y = (LocalPlayer():HasPremium() and k == max_x) and 1 or math.floor((k - 1) / 4)

						v.DownOffset = ij_y * (pad + v:GetTall())

						v:SetPos( ij_x * (pad + v:GetWide()), ij_y * (pad + v:GetTall()) );
						--v:SetTall( h );
						if ( v.ApplySchemeSettings ) then v:ApplySchemeSettings(); end
						--x = x + v:GetWide() - this12.m_iOverlap;
						x = v:GetWide();
					end

					x = (x + pad) * (LocalPlayer():HasPremium() and 5 or 4)
					this12.pnlCanvas.SetWide( this12.pnlCanvas, x + this12.m_iOverlap );

					if w < this12.pnlCanvas.GetWide(this12.pnlCanvas) then
						this12.OffsetX = math.Clamp( this12.OffsetX, 0, this12.pnlCanvas.GetWide(this12.pnlCanvas) - this12:GetWide() );
					else
						this12.OffsetX = 0;
					end

					this12.pnlCanvas.x = this12.OffsetX * -1;

					local btnSize   = 0.12 * h;
					local btnOffset = 0.5 * (h - btnSize);

					this12.btnLeft.SetSize( this12.btnLeft, btnSize * 1.5, btnSize );
					this12.btnLeft.SetPos( this12.btnLeft, btnOffset * 0.5, btnOffset );

					this12.btnRight.SetSize( this12.btnRight, btnSize * 1.5, btnSize );
					this12.btnRight.SetPos( this12.btnRight, w - this12.btnRight.GetWide(this12.btnRight) - btnOffset * 0.5, btnOffset );

					this12.btnLeft.SetVisible( this12.btnLeft, this12.pnlCanvas.x < 0 );
					this12.btnRight.SetVisible( this12.btnRight, this12.pnlCanvas.x + this12.pnlCanvas.GetWide(this12.pnlCanvas) > this12:GetWide() );
				end

				bb_content.btnLeft.Paint = function( this11, w, h )
					local baseColor, textColor = rpui.GetPaintStyle( this11, STYLE_TRANSPARENT_INVERTED );
					surface.SetDrawColor( baseColor );
					surface.DrawRect( 0, 0, w, h );
					draw.SimpleText( "<", "rpui.Fonts.DonateMenu.ItemButtonBig", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
				end

				bb_content.btnRight.Paint = function( this10, w, h )
					local baseColor, textColor = rpui.GetPaintStyle( this10, STYLE_TRANSPARENT_INVERTED );
					surface.SetDrawColor( baseColor );
					surface.DrawRect( 0, 0, w, h );
					draw.SimpleText( ">", "rpui.Fonts.DonateMenu.ItemButtonBig", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
				end

				bb_content.OnMouseWheeled = function() end

				scroll_pnl:AddItem(bb_content)
				bb_content:Dock(TOP)
				bb_content:DockMargin(0, pad, pad, 0)

				local texts = {
					translates.Get('На всех серверах URF'),
					translates.Get('Все VIP привилегии'),
					translates.Get('Включая эксклюзивные'),
				}

				local chars_prem = table.insert(texts, translates.Get('Больше персонажей'))
				local toolguns_prem = table.insert(texts, translates.Get('Выбери скин тулгана'))
				local physguns_prem = table.insert(texts, translates.Get('Выбери скин физгана'))
				local slots_prem = table.insert(texts, translates.Get('Premium слоты'))
				local smiles_prem = table.insert(texts, translates.Get('Добавь Emoji к нику'))
				local skins_prem = table.insert(texts, translates.Get('Скин админа'))
				local deni_prem

				if LocalPlayer():HasPremium() then
					deni_prem = table.insert(texts, translates.Get('Отказаться от Premium'))
				end

				local tt_lables = {
					{
						translates.Get('Подписка действует везде - вы получите'),
						translates.Get('Premium статус и все его привилегии на'),
						translates.Get('всех серверах urf.im и всех, которые'),
						translates.Get('будут появляться в будущем!'),
					},
					{
						translates.Get('Как Premium игроку вам будет доступно:'),
						translates.Get(' - Особые VIP Профессии'),
						translates.Get(' - Все профессии бесплатны'),
						translates.Get(' - 20 дополнитеьных пропов'),
						translates.Get(' - Отсутсвует лимит на профессии'),
						translates.Get(' - Доступна команда /job'),
						translates.Get(' - VIP статус в Discord'),
					},
					{
						translates.Get('Танцуй, Танцуй, Танцуй!'),
					},
					{
						translates.Get('Два дополнительных слота'),
						translates.Get('персонажей!'),
					},
					{
						false,
					},
					{
						false,
					},
					{
						translates.Get('Для Premium игроков зарезервировано'),
						translates.Get('25 слотов на сервере - вы всегда'),
						translates.Get('сможете зайти!'),
					},
					{
						false,
					},
					{
						translates.Get('Премиум скин для профессий'),
						translates.Get('администрации.'),
					},
					{
						false,
					},
				}

				local bg_mats_fr = {
					[1] = Material("premium/en_bonus1"),
					[3] = Material("premium/en_bonus3"),
				}

				local bg_mats = {
					[1] = Material("premium/bonus1"),
					[2] = Material("premium/bonus2"),
					[3] = Material("premium/bonus3"),
					[4] = Material("premium/bonus_chars.png"),
					[5] = Material("premium/bonus4"),
					[6] = Material("premium/bonus5"),
					[7] = Material("premium/bonus_slots.png"),
					[8] = Material("premium/bonus6"),
					[9] = Material("premium/bonus_skin.png"),
				}

				if LocalPlayer():HasPremium() then
					local dat_prem2 = util.JSONToTable(LocalPlayer():GetNetVar('GlobalRankData') or '[]')

					if dat_prem2.auto_pay == 0 then
						texts[deni_prem] = translates.Get('Авто. продление')
					end
				end

				for ij = 1, table.Count(texts) do
					local pnl_bgs = vgui.Create( "DButton", bb_content );

					pnl_bgs:SetText('')
					pnl_bgs:SetSize(wh_bg3 * 0.99, wh_bg3 * 0.8)

					if not deni_prem or (ij < deni_prem) then
						if rp.cfg.IsFrance and (ij == 1 or ij == 3) then
							pnl_bgs.mat = Material("premium/en_bonus" .. ij)

						elseif bg_mats[ij] then
							pnl_bgs.mat = bg_mats[ij]

						else
							pnl_bgs.mat = Material("premium/bonus" .. ij)
						end
					end

					pnl_bgs.Paint = function(th03, bgw2, bgh2)
						local baseColor  = rpui.GetPaintStyle( th03, STYLE_TRANSPARENT );
						surface.SetDrawColor( Color(0, 0, 0, 140 + baseColor.a * 0.33) );

						surface.DrawRect(0, 0, bgw2, bgh2 - in_sz)
						surface.SetDrawColor(my_new_col)
						surface.DrawRect(0, bgh2 - in_sz, bgw2, in_sz)

						if LocalPlayer():HasPremium() and (ij < toolguns_prem or ij == toolguns_prem and LocalPlayer():GetCustomToolgun() or ij == physguns_prem and LocalPlayer():GetCustomPhysgun() or ij == smiles_prem and LocalPlayer():GetNetVar('NickEmoji')) then
							local ts = 0.25 * bgh2;

							if not th03.StatusTriangle then
								th03.StatusTriangle = {
									{ x = bgw2 - ts, y = 0,  u = 0, v = 0 },
									{ x = bgw2,      y = 0,  u = 1, v = 0 },
									{ x = bgw2,      y = ts, u = 1, v = 1 }
								};
							end

							draw.NoTexture();

							surface.SetDrawColor( rpui.UIColors.BackgroundDonateBuyed );
							surface.DrawPoly( th03.StatusTriangle );

							surface.SetMaterial( rpui.GradientDownMat );
							surface.SetDrawColor( rpui.UIColors.DonateBuyed );
							surface.DrawPoly( th03.StatusTriangle );

							draw.SimpleText( "✔", "rpui.Fonts.DonateMenu.StatusTriangle", bgw2 - ts * 0.3, ts * 0.3, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
						end

						if not deni_prem or (ij < deni_prem) then
							surface.SetDrawColor(Color(255, 255, 255, 255))
							surface.SetMaterial(th03.mat)

							if ij == 3 then
								surface.DrawTexturedRect(wh_bg3 * 0.25 * 1.01, wh_bg3 * 0.25 * 0.86 - in_sz, wh_bg3 * 0.5 * 1.16, wh_bg3 * 0.5 * 1.16)
							else
								surface.DrawTexturedRect(wh_bg3 * 0.25 * 0.86, wh_bg3 * 0.25 * 0.86 - in_sz, wh_bg3 * 0.5 * 1.16, wh_bg3 * 0.5 * 1.16)
							end
						end

						draw.SimpleText( texts[ij], "rpui.Fonts.DonateMenu.Tooltip", bgw2 * 0.5, bgh2 - in_sz / 2, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
					end

					if ij == toolguns_prem then
						pnl_bgs.ShowCustomPanel = function(forced_y2)
							local pnl2 = vgui.Create("DPanel", p)
							local pnl_wt = wh_bg3 * 0.9 * 6 + pad * 7
							local pnl_ht = wh_bg3 * 0.7 + pad * 2
							pnl2:SetSize(pnl_wt, pnl_ht)
							pnl2:SetPos(inner_width - pnl_wt - wh_bg3 * 0.5, forced_y2 and (forced_y2 - pnl_ht + pad) or (wh_bg4 + header_tall + pad * 3 + wh_bg3 * 0.4 - pnl_ht))
							pnl2.Paint = function(me274, w274, h274)
								CHATBOX.Blur(me274)
								draw.RoundedBox(0, 0, 0, w274, h274, CHATBOX.Color("bg"))
							end
							pnl2.Close = function(me275)
								if (me275.m_bClosing) then return end

								me275.m_bClosing = true
								me275:AlphaTo(0, 0.2, 0, function()
									me275:Remove()
									me275.m_bClosing = nil
								end)
							end
							pnl2.Think = function( this275 )
								if input.IsMouseDown(MOUSE_LEFT) and rpui.DonateMenu.IsChildHovered(rpui.DonateMenu) and not this275.m_bClosing then
									if (not this275:IsHovered() and not this275:IsChildHovered()) then
										this275:Close()
									end
								end
							end

							local toolguns = {
								'gmod_tool',
								'gmod_tool_prem_1',
								'gmod_tool_prem_2',
								'gmod_tool_prem_3',
								'gmod_tool_prem_4',
								'gmod_tool_prem_5',
							}

							for cti = 1, 6 do
								local pnl_bgs3 = vgui.Create("DButton", pnl2);

								pnl_bgs3:SetText('')
								pnl_bgs3:DockMargin(pad, pad, 0, pad)
								pnl_bgs3:Dock(LEFT)
								pnl_bgs3:SetSize(wh_bg3 * 0.9, wh_bg3 * 0.7)

								local tg_class = toolguns[cti]

								local tg_id = rp.ToolGunSWEPS_k[tg_class]
								local tg_data = rp.ToolGunSWEPS[tg_id] or {
									model = 'models/weapons/w_toolgun.mdl',
									name = translates.Get('Обычный Toolgun'),
								}

								local pnl_bg_tg = vgui.Create( "DModelPanel", pnl_bgs3 );
								pnl_bg_tg.SetMouseInputEnabled( pnl_bg_tg, false );
								pnl_bg_tg.SetSize( pnl_bg_tg, wh_bg3 * 0.9, wh_bg3 * 0.6 );
								pnl_bg_tg.SetPos( pnl_bg_tg, 0, pad * .5 );
								pnl_bg_tg.SetModel( pnl_bg_tg, tg_data.model );
								pnl_bg_tg.SetFOV( pnl_bg_tg, 20 );
								pnl_bg_tg.xVelocity     = 0;
								pnl_bg_tg.xOffset       = 0;
								pnl_bg_tg.yVelocity     = 0;
								pnl_bg_tg.ZoomingVector = Vector(0,0,0);
								pnl_bg_tg.LayoutEntity = function() end
								pnl_bg_tg.Think = function( this3 )
									this3.Entity.SetAngles( this3.Entity, Angle( 0, 0, 0 ) );
									this3.Entity.SetPos( this3.Entity, Vector(0, 5, 41) );
								end

								pnl_bgs3.Paint = function(th06, bgw5, bgh5)
									local baseColor  = rpui.GetPaintStyle( th06, STYLE_TRANSPARENT );
									surface.SetDrawColor( Color(0, 0, 0, 140 + baseColor.a * 0.33) );

									surface.DrawRect(0, 0, bgw5, bgh5)

									draw.SimpleText( translates.Get(tg_data.name), "rpui.Fonts.DonateMenu.Tooltip", bgw5 * 0.5, bgh5 - in_sz + pad * .5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
								end

								pnl_bgs3.DoClick = function()
									if not LocalPlayer():HasPremium() then return end

									net.Start('Donate::ChooseToolgun')
										net.WriteUInt(cti, 4)
									net.SendToServer()

									pnl2:Close()
								end
							end

							return pnl2
						end

						pnl_bgs.DoClick = function()
							--if not LocalPlayer():HasPremium() then return end

							if not IsValid(bb_content.cpn2) then
								bb_content.cpn2 = pnl_bgs.ShowCustomPanel(wh_bg4 + header_tall + pad * 3)
							end
						end

					elseif ij == physguns_prem then
						pnl_bgs.ShowCustomPanel = function(forced_y2)
							local pnl2 = vgui.Create("DPanel", p)
							local pnl_wt = wh_bg3 * 0.9 * 6 + pad * 7
							local pnl_ht = wh_bg3 * 0.7 + pad * 2
							pnl2:SetSize(pnl_wt, pnl_ht)
							pnl2:SetPos(inner_width - pnl_wt - wh_bg3 * 0.5, forced_y2 and (forced_y2 - pnl_ht + pad) or (wh_bg4 + header_tall + pad * 3 + wh_bg3 * 0.4 - pnl_ht))
							pnl2.Paint = function(me274, w274, h274)
								CHATBOX.Blur(me274)
								draw.RoundedBox(0, 0, 0, w274, h274, CHATBOX.Color("bg"))
							end
							pnl2.Close = function(me275)
								if (me275.m_bClosing) then return end

								me275.m_bClosing = true
								me275:AlphaTo(0, 0.2, 0, function()
									me275:Remove()
									me275.m_bClosing = nil
								end)
							end
							pnl2.Think = function( this275 )
								if input.IsMouseDown(MOUSE_LEFT) and rpui.DonateMenu.IsChildHovered(rpui.DonateMenu) and not this275.m_bClosing then
									if (not this275:IsHovered() and not this275:IsChildHovered()) then
										this275:Close()
									end
								end
							end

							local toolguns = {
								'nil',
								'pg_1',
								'pg_2',
								'pg_3',
								'pg_4',
								'pg_5',
								--'gmod_tool_prem_5',
							}

							for cti = 1, 6 do
								local pnl_bgs3 = vgui.Create("DButton", pnl2);

								pnl_bgs3:SetText('')
								pnl_bgs3:DockMargin(pad, pad, 0, pad)
								pnl_bgs3:Dock(LEFT)
								pnl_bgs3:SetSize(wh_bg3 * 0.9, wh_bg3 * 0.7)

								local tg_class = toolguns[cti]

								--local tg_id = rp.ToolGunSWEPS_k[tg_class]
								local tg_data = rp.PremiumPhysguns[tg_class] or {
									wmodel = 'models/weapons/w_Physics.mdl',
									name = translates.Get('Обычный Physgun'),
								}

								if tg_data.wmodel then
                                    local pnl_bg_tg = vgui.Create( "DModelPanel", pnl_bgs3 );
                                    pnl_bg_tg.SetMouseInputEnabled( pnl_bg_tg, false );
                                    pnl_bg_tg.SetSize( pnl_bg_tg, wh_bg3 * 0.9, wh_bg3 * 0.6 );
                                    pnl_bg_tg.SetPos( pnl_bg_tg, 0, pad * .5 );
                                    pnl_bg_tg.SetModel( pnl_bg_tg, tg_data.wmodel );
                                    pnl_bg_tg.SetFOV( pnl_bg_tg, 40 );
                                    pnl_bg_tg.xVelocity     = 0;
                                    pnl_bg_tg.xOffset       = 0;
                                    pnl_bg_tg.yVelocity     = 0;
                                    pnl_bg_tg.ZoomingVector = Vector(0,0,0);
                                    pnl_bg_tg.LayoutEntity = function() end
                                    pnl_bg_tg.Think = function( this3 )
                                        this3.Entity.SetAngles( this3.Entity, Angle( 0, 0, 0 ) );
                                        this3.Entity.SetPos( this3.Entity, Vector(0, 5, 41) );
                                    end
                                else
                                    local pnl_bg_tg = vgui.Create( "Panel", pnl_bgs3 );
                                    pnl_bg_tg.SetMouseInputEnabled( pnl_bg_tg, false );
                                    pnl_bg_tg.SetSize( pnl_bg_tg, wh_bg3 * 0.9, wh_bg3 * 0.6 );
                                    pnl_bg_tg.SetPos( pnl_bg_tg, 0, pad * .5 );
                                    pnl_bg_tg.Paint = function( this, w, h )
                                        if tg_data.ico then
                                            if not this.ico then
                                                this.ico = Material( tg_data.ico, "smooth" );
                                            end

                                            local scl = h * 0.5;
                                            surface.SetDrawColor( rpui.UIColors.White );
                                            surface.SetMaterial( this.ico );
                                            surface.DrawTexturedRect( w * 0.5 - scl * 0.5, h * 0.5 - scl * 0.5, scl, scl );
                                        else
                                            draw.SimpleText( "?", "rpui.Fonts.DonateMenu.MenuButtonBigBold2", w * 0.5, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                                        end
                                    end
                                end

								pnl_bgs3.Paint = function(th06, bgw5, bgh5)
									local baseColor  = rpui.GetPaintStyle( th06, STYLE_TRANSPARENT );
									surface.SetDrawColor( Color(0, 0, 0, 140 + baseColor.a * 0.33) );

									surface.DrawRect(0, 0, bgw5, bgh5)

									draw.SimpleText( translates.Get(tg_data.name), "rpui.Fonts.DonateMenu.Tooltip", bgw5 * 0.5, bgh5 - in_sz + pad * .5, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
								end

								pnl_bgs3.DoClick = function()
									if not LocalPlayer():HasPremium() then return end

									net.Start('Donate::ChoosePhysgun')
										net.WriteString(tg_class)
									net.SendToServer()

									pnl2:Close()
								end
							end

							return pnl2
						end

						pnl_bgs.DoClick = function()
							--if not LocalPlayer():HasPremium() then return end

							if not IsValid(bb_content.cpn2) then
								bb_content.cpn2 = pnl_bgs.ShowCustomPanel(wh_bg4 + header_tall + pad * 3)
							end
						end


					elseif ij == smiles_prem then
						pnl_bgs.ShowCustomPanel = function(forced_y)
							local pnl = vgui.Create("DPanel", p)
							_CHATBOX_EMOTICONS = pnl
							local pnl_w = wh_bg2
							local pnl_h = 0.6 * wh_bg2
							pnl:SetSize(pnl_w, pnl_h)
							pnl:SetPos(inner_width - pnl_w - wh_bg3 * 0.5, forced_y and (forced_y - pnl_h + pad) or (wh_bg4 + header_tall + pad * 3 + wh_bg3 * 0.4 - pnl_h))
							pnl.Paint = function(me271, w271, h271)
								CHATBOX.Blur(me271)
								draw.RoundedBox(0, 0, 0, w271, h271, CHATBOX.Color("bg"))
							end
							pnl.Close = function(me272)
								if (me272.m_bClosing) then return end

								me272.m_bClosing = true
								me272:AlphaTo(0, 0.2, 0, function()
									me272:Remove()
									me272.m_bClosing = nil
								end)
							end
							pnl.Think = function( this231 )
								if input.IsMouseDown(MOUSE_LEFT) and rpui.DonateMenu.IsChildHovered(rpui.DonateMenu) and not this231.m_bClosing then
									if (not this231:IsHovered() and not this231:IsChildHovered()) then
										this231:Close();
									end
								end
							end

							pnl:SetAlpha(0)
							pnl:AlphaTo(255, 0.2)

							local scroll = vgui.Create("rpui.ScrollPanel", pnl)
							scroll:Dock(FILL)
							scroll:DockMargin(8, 8, 8, 8)
							scroll:SetSpacingY(0)
							scroll:SetScrollbarMargin(0)
							scroll.OnMouseWheeled = function(me273, dt)
								me273.ySpeed = me273.ySpeed + dt*2
							end

							local ilist = vgui.Create("DIconLayout")
							ilist:Dock(FILL)
							scroll:AddItem(ilist)

							local emotes_tab = {}

							for k, v in pairs(CHATBOX.Emoticons) do
								emotes_tab[v.h] = emotes_tab[v.h] or {}

								local i = #emotes_tab[v.h] + 1
								emotes_tab[v.h][i] = v
								emotes_tab[v.h][i].id = k
							end

							for k, v in pairs(emotes_tab) do
								table.sort(v, function(v1, v2)
									return v2.id > v1.id
								end)
							end

							for tall, emotes in pairs(emotes_tab) do
								for k, em in SortedPairs(emotes) do
									local id = em.id

									local img
									if (em.url) then
										img = vgui.Create("DButton", ilist)
										img:SetText("")
										img.Paint = function(me252, w252, h252)
											if (me252.m_Image) then
												surface.SetDrawColor(Color(255, 255, 255, 255))
												surface.SetMaterial(me252.m_Image)
												surface.DrawTexturedRect(0, 0, w252, h252)
											end
										end

										local mat = CHATBOX.GetDownloadedImage(em.url)
										if (mat) then
											img.m_Image = mat
										else
											CHATBOX.DownloadImage(
												em.url,
												function(mat)
													if IsValid(img) then
														img.m_Image = mat
													end
												end
											)
										end
									else
										img = vgui.Create("DImageButton", ilist)
										img:SetImage(em.path)
									end

									img:SetToolTip(":" .. id .. ":")
									img:SetSize(em.w, em.h)
									img.DoClick = function()
										if not LocalPlayer():HasPremium() then return end

										net.Start('Donate::ChooseEmoji')
											net.WriteString(id)
										net.SendToServer()

										pnl:Close()
									end
									img:DockMargin(4, 4, 4, 4)
								end
							end

							return pnl
						end

						pnl_bgs.DoClick = function()
							--if not LocalPlayer():HasPremium() then return end

							if not IsValid(bb_content.cpn2) then
								bb_content.cpn2 = pnl_bgs.ShowCustomPanel(wh_bg4 + header_tall + pad * 3)
							end
						end

					elseif ij == skins_prem and rp.shop.Mapping['premium'] then
						pnl_bgs.DoClick = function()
							if IsValid(rpui.DonateMenu.MainModel) then
								local ppp = rpui.DonateMenu.MainModel

								p.selected = -1
								ppp.sequenced  = -1

								ppp:SetModel(rp.shop.Mapping['premium'].CustomModels[1] or '')
							end
						end

					elseif deni_prem and (ij == deni_prem) then
						pnl_bgs.DoClick = function( this1111111 )
							if not LocalPlayer():HasPremium() then return end

							local dat_prem1 = util.JSONToTable(LocalPlayer():GetNetVar('GlobalRankData') or '[]')

							if dat_prem1.auto_pay == 1 then
								local unsub_menu = rpui.StringRequest(translates.Get("ОТПИСАТЬСЯ"), translates.Get("Введите причину отказа от Premium:"), "shop/filters/list.png", 1.8, function(self, str) end)

								unsub_menu:DoModal()

								unsub_menu.ok.SetText(unsub_menu.ok, translates.Get('Отписаться'))

								unsub_menu.ok.DoClick = function()
									if unsub_menu.UnsubQuestion then
										local reason_str = string.Trim(unsub_menu.input.GetValue(unsub_menu.input))

										if utf8.len(reason_str) < 10 then
											unsub_menu.UnsubQuestion = nil
											unsub_menu.ok.SetText(unsub_menu.ok, translates.Get('Подтвердите'))

											unsub_menu.input.SetValue(unsub_menu.input, '')

											unsub_menu.OverInputTitle = translates.Get('Минимум 10 символов!')
											unsub_menu.RetardAlert = CurTime() + 1

											return
										end

										dat_prem1.auto_pay = 0

										texts[deni_prem] = translates.Get('Авто. продление')

										if IsValid(rpui.DonateMenu.PremBtn) then
											rpui.DonateMenu.PremBtn.SetCursor(rpui.DonateMenu.PremBtn, 'hand')
											rpui.DonateMenu.PremBtn.SetEnabled(rpui.DonateMenu.PremBtn, true)

											rpui.DonateMenu.PremBtn.DoClick = function()
												net.Start('Donate::PremiumToggle')
												net.SendToServer()

												texts[deni_prem] = translates.Get('Отказаться от Premium')

												rpui.DonateMenu.PremBtn.SetCursor(rpui.DonateMenu.PremBtn, 'arrow')
												rpui.DonateMenu.PremBtn.SetEnabled(rpui.DonateMenu.PremBtn, false)
											end
										end

										net.Start('Donate::PremiumToggle')
											net.WriteString(utf8.sub(reason_str, 1, 64))
										net.SendToServer()

										this1111111.NextPress = CurTime() + 1

										unsub_menu:Close()
									else
										unsub_menu.UnsubQuestion = CurTime() + 1
										unsub_menu.ok.SetText(unsub_menu.ok, translates.Get('Подтвердите'))
									end
								end

								unsub_menu.NotifyColor = Color(255, 255, 255, 255)
								unsub_menu.PaintOver = function()
									local inX, inY = unsub_menu.input.GetPos(unsub_menu.input)
									draw.SimpleText(unsub_menu.OverInputTitle, unsub_menu.OverInputTitleFont, inX, inY - unsub_menu.pOffset, unsub_menu.NotifyColor, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
								end

								unsub_menu.Think = function( this2311 )
									if input.IsMouseDown(MOUSE_LEFT) and (IsValid(rpui.DonateMenu) and rpui.DonateMenu.IsChildHovered(rpui.DonateMenu)) and not this2311.m_bClosing then
										if (not this2311:IsHovered() and not this2311:IsChildHovered()) then
											this2311:Close();
										end
									end

									if unsub_menu.RetardAlert and unsub_menu.RetardAlert > CurTime() then
										local r_comp = 255 - (unsub_menu.RetardAlert - CurTime()) * 222
										unsub_menu.NotifyColor = Color(255, r_comp, r_comp, 255)
									else
										unsub_menu.NotifyColor = Color(255, 255, 255, 255)
									end

									if this2311.UnsubQuestion and this2311.UnsubQuestion < CurTime() then
										this2311.UnsubQuestion = nil
										this2311.ok.SetText(this2311.ok, translates.Get('Отписаться'))
									end
								end
							else
								if pnl_bgs.NextPress and pnl_bgs.NextPress > CurTime() then return end
								pnl_bgs.NextPress = CurTime() + 1

								net.Start('Donate::PremiumToggle')
								net.SendToServer()

								dat_prem1.auto_pay = 1

								texts[deni_prem] = translates.Get('Отказаться от Premium')
							end
						end
					end

					pnl_bgs.DrawTooltip = function(sf1)
						local my_lines = tt_lables[ij]
						if not my_lines[1] then return end

						if not isbool(my_lines[1]) then
							sf1.Tooltip = vgui.Create( "DPanel" );
							local tooltip = sf1.Tooltip;

							surface.SetFont("rpui.Fonts.DonateMenu.Tooltip")
							local text_space_x, text_space_y = surface.GetTextSize(' ')

							local pnl_w1 = 1.8 * wh_bg3
							local pnl_h1 = (#my_lines) * (text_space_y + 0.004 * wh_bg3) + 0.1 * wh_bg3
							tooltip:SetSize(pnl_w1, pnl_h1 + wh_bg3 * 0.08)

							tooltip:SetAlpha( 0 );
							tooltip:DockPadding( 0, wh_bg3 * 0.05, 0, 0 );

							tooltip.Think = function(tt)
								if not IsValid(rpui.DonateMenu) then
									tt:Remove()
									return
								end

								if IsValid(bb_content) and bb_content.GetCanvas then
									local pnl_bgs_x = bb_content:GetCanvas():LocalToScreen(pnl_bgs:GetPos()) + wh_bg3 - pnl_w1
									local pnl_bgs_y = scroll_pnl.yOffset
									tooltip:SetPos(pnl_bgs_x, wh_bg4 + header_tall + pad * 3 - pnl_h1 - pnl_bgs_y + (sf1.DownOffset or 0))
								end
							end

							tooltip.Paint = function(tt, wt, ht)
								local real_h = ht - 0.08 * wh_bg3

								surface.SetDrawColor(Color(0, 0, 0, 255))
								surface.DrawRect(0, 0, wt, real_h)

								if tt.BakedPoly then
									draw.NoTexture();
									surface.DrawPoly( tt.BakedPoly );
								else
									tt.BakedPoly = {
										{ x = wt, y = real_h - 2 },
										{ x = wt, y = real_h + wh_bg3 * 0.08 },
										{ x = wt * 0.94, y = real_h - 2 },
									};
								end
							end

							for ijk = 1, #my_lines do
								local label = vgui.Create( "DLabel", tooltip );

								label:Dock( TOP );
								label:DockMargin( 0, wh_bg3 * 0.004, 0, 0 );
								label:SetFont( "rpui.Fonts.DonateMenu.Tooltip" );
								label:SetTextColor( rpui.UIColors.White );
								label:SetContentAlignment(2)
								label:SetText( my_lines[ijk] );
								label:SetSize( pnl_w1, text_space_y );
							end
						end

						sf1._OnCursorEntered = sf1._OnCursorEntered or sf1.OnCursorEntered;
						sf1._OnCursorExited  = sf1._OnCursorExited or sf1.OnCursorExited;

						sf1.OnCursorEntered = function()
							if sf1._OnCursorEntered then
								sf1:_OnCursorEntered();
							end

							if IsValid( sf1.Tooltip ) or isbool(my_lines[1]) and my_lines[1] then
								sf1.ActivePanel = true

								timer.Simple(0.4 * (IsValid(sf1.Tooltip) and 1 or 2), function()
									if not IsValid(sf1) or not sf1.ActivePanel then return end

									if not IsValid(bb_content.cpn2) then
										if isbool(my_lines[1]) and my_lines[1] then
											bb_content.cpn2 = sf1.ShowCustomPanel(wh_bg4 + header_tall + pad * 3)

										else
											sf1.Tooltip.MakePopup( sf1.Tooltip )
											sf1.Tooltip.SetMouseInputEnabled( sf1.Tooltip, false );
											sf1.Tooltip.SetKeyBoardInputEnabled( sf1.Tooltip, false );

											sf1.Tooltip.AlphaTo(sf1.Tooltip, 255, 0.1);
										end
									end
								end)
							end
						end

						sf1.OnCursorExited = function()
							if sf1._OnCursorExited then
								sf1:_OnCursorExited();
							end

							if IsValid( sf1.Tooltip ) then
								sf1.Tooltip.AlphaTo(sf1.Tooltip, 0, 0.1);
							end

							sf1.ActivePanel = nil

							if not LocalPlayer():HasPremium() and IsValid(bb_content.cpn2) then
								bb_content.cpn2.Close(bb_content.cpn2)
							end
						end
					end

					pnl_bgs.Think = function(sf)
						if tt_lables[ij] and not IsValid(sf.Tooltip) then
							sf:DrawTooltip()
						end
					end

					bb_content:AddPanel(pnl_bgs)

					--local ij_off_x = (ij - 1) % 4
					--local ij_off_y = math.floor((ij - 1) / 4)

					--pnl_bgs:SetPos(ij_off_x * (pad + pnl_bgs:GetWide()), ij_off_y * (pad + pnl_bgs:GetTall()))
				end


				-- MAIN INFO PANEL
				local lb1 = vgui.Create( "DLabel", pnl_bg2 )
				lb1:SetFont('rpui.Fonts.DonateMenu.PurchaseButton')
				lb1:SetPos(0, pad * 4)
				lb1:SetColor(Color(255, 255, 255, 255))
				lb1:SetSize(wh_bg2, 100)
				lb1:SetContentAlignment(8)
				lb1:SetText(translates.Get('Преимущества подписки'))

				surface.SetFont("rpui.Fonts.DonateMenu.FlirtQuote2")
				local text_sz_x = surface.GetTextSize(translates.Get('Играй так как тебе хочется на всех серверах URF с подпиской URF PREMIUM.'))
				local text_sz_x1 = surface.GetTextSize(translates.Get('Более 40 премиум профессий доступны для игры сразу!'))
				local text_sz_x2 = surface.GetTextSize(translates.Get('Более') .. ' ')
				local text_sz_x3 = surface.GetTextSize(translates.Get('40 премиум'))
				local text_sz_x4 = surface.GetTextSize(' ' .. translates.Get('профессий доступны для игры сразу!'))

				local lb2 = vgui.Create( "DLabel", pnl_bg2 )
				lb2:SetFont('rpui.Fonts.DonateMenu.FlirtQuote2')
				lb2:SetPos(math.floor(-text_sz_x1/2 + text_sz_x2 / 2), pad * 9)
				lb2:SetColor(Color(255, 255, 255, 255))
				lb2:SetSize(wh_bg2, 100)
				lb2:SetContentAlignment(8)
				lb2:SetText(translates.Get('Более'))

				local lb5 = vgui.Create( "DLabel", pnl_bg2 )
				lb5:SetFont('rpui.Fonts.DonateMenu.FlirtQuote2')
				lb5:SetPos(math.floor(-text_sz_x1/2 + text_sz_x3/2 + text_sz_x2), pad * 9)
				lb5:SetColor(my_new_col)
				lb5:SetSize(wh_bg2, 100)
				lb5:SetContentAlignment(8)
				lb5:SetText(translates.Get('40 премиум'))

				local lb6 = vgui.Create( "DLabel", pnl_bg2 )
				lb6:SetFont('rpui.Fonts.DonateMenu.FlirtQuote2')
				lb6:SetPos(math.floor(-text_sz_x1/2 + text_sz_x3 + text_sz_x2 + text_sz_x4/2), pad * 9)
				lb6:SetColor(Color(255, 255, 255, 255))
				lb6:SetSize(wh_bg2, 100)
				lb6:SetContentAlignment(8)
				lb6:SetText(translates.Get('профессий доступны для игры сразу!'))

				if text_sz_x > 0.9 * wh_bg2 then
					local lb3 = vgui.Create( "DLabel", pnl_bg2 )
					lb3:SetFont('rpui.Fonts.DonateMenu.FlirtQuote2')
					lb3:SetPos(0, pad * 11)
					lb3:SetColor(Color(255, 255, 255, 255))
					lb3:SetSize(wh_bg2, 100)
					lb3:SetContentAlignment(8)
					lb3:SetText(translates.Get('Играй так как тебе хочется на всех серверах URF'))

					local text_sz_x5 = surface.GetTextSize(translates.Get('с подпиской') .. ' ' .. translates.Get('URF PREMIUM') .. '.')
					local text_sz_x6 = surface.GetTextSize(translates.Get('с подпиской') .. ' ')
					local text_sz_x7 = surface.GetTextSize(translates.Get('URF PREMIUM'))
					local text_sz_x8 = surface.GetTextSize('.')

					local lb4 = vgui.Create( "DLabel", pnl_bg2 )
					lb4:SetFont('rpui.Fonts.DonateMenu.FlirtQuote2')
					lb4:SetPos(math.floor(-text_sz_x5/2 + text_sz_x6/2), pad * 13)
					lb4:SetColor(Color(255, 255, 255, 255))
					lb4:SetSize(wh_bg2, 100)
					lb4:SetContentAlignment(8)
					lb4:SetText(translates.Get('с подпиской') .. ' ')

					local lb7 = vgui.Create( "DLabel", pnl_bg2 )
					lb7:SetFont('rpui.Fonts.DonateMenu.FlirtQuote2')
					lb7:SetPos(math.floor(-text_sz_x5/2 + text_sz_x6 + text_sz_x7/2), pad * 13)
					lb7:SetColor(my_new_col)
					lb7:SetSize(wh_bg2, 100)
					lb7:SetContentAlignment(8)
					lb7:SetText(translates.Get('URF PREMIUM'))

					local lb8 = vgui.Create( "DLabel", pnl_bg2 )
					lb8:SetFont('rpui.Fonts.DonateMenu.FlirtQuote2')
					lb8:SetPos(math.floor(-text_sz_x5/2 + text_sz_x6 + text_sz_x7 + text_sz_x8/2), pad * 13)
					lb8:SetColor(Color(255, 255, 255, 255))
					lb8:SetSize(wh_bg2, 100)
					lb8:SetContentAlignment(8)
					lb8:SetText('.')
				else
					local text_sz_x5 = surface.GetTextSize(translates.Get('Играй так как тебе хочется на всех серверах URF с подпиской URF PREMIUM.'))
					local text_sz_x6 = surface.GetTextSize(translates.Get('Играй так как тебе хочется на всех серверах URF') .. ' ' .. translates.Get('с подпиской') .. ' ')
					local text_sz_x7 = surface.GetTextSize(translates.Get('URF PREMIUM'))
					local text_sz_x8 = surface.GetTextSize('.')

					local lb3 = vgui.Create( "DLabel", pnl_bg2 )
					lb3:SetFont('rpui.Fonts.DonateMenu.FlirtQuote2')
					lb3:SetPos(math.floor(-text_sz_x5/2 + text_sz_x6/2), pad * 11)
					lb3:SetColor(Color(255, 255, 255, 255))
					lb3:SetSize(wh_bg2, 100)
					lb3:SetContentAlignment(8)
					lb3:SetText(translates.Get('Играй так как тебе хочется на всех серверах URF') .. ' ' .. translates.Get('с подпиской') .. ' ')

					local lb4 = vgui.Create( "DLabel", pnl_bg2 )
					lb4:SetFont('rpui.Fonts.DonateMenu.FlirtQuote2')
					lb4:SetPos(math.floor(-text_sz_x5/2 + text_sz_x6 + text_sz_x7/2), pad * 11)
					lb4:SetColor(my_new_col)
					lb4:SetSize(wh_bg2, 100)
					lb4:SetContentAlignment(8)
					lb4:SetText(translates.Get('URF PREMIUM'))

					local lb7 = vgui.Create( "DLabel", pnl_bg2 )
					lb7:SetFont('rpui.Fonts.DonateMenu.FlirtQuote2')
					lb7:SetPos(math.floor(-text_sz_x5/2 + text_sz_x6 + text_sz_x7 + text_sz_x8/2), pad * 11)
					lb7:SetColor(Color(255, 255, 255, 255))
					lb7:SetSize(wh_bg2, 100)
					lb7:SetContentAlignment(8)
					lb7:SetText('.')
				end

				local bb_content2 = vgui.Create( "DHorizontalScroller", pnl_bg2 );
				bb_content2:SetPos(pad * 2, wh_bg4 * 0.3)
				bb_content2:SetSize(wh_bg2 - pad * 4, wh_bg5)
				bb_content2:SetOverlap( 0 );
				bb_content2.PerformLayout = function( this9 )
					local w = this9:GetWide();
					local h = this9:GetTall();

					this9.pnlCanvas.SetTall( this9.pnlCanvas, h );

					local x = 0;
					for k, v in pairs( this9.Panels ) do
						if ( !IsValid( v ) ) then continue end
						if ( !v:IsVisible() ) then continue end
						v:SetPos( x, 0 );
						v:SetTall( h );
						if ( v.ApplySchemeSettings ) then v:ApplySchemeSettings(); end
						x = x + v:GetWide() - this9.m_iOverlap;
					end

					this9.pnlCanvas.SetWide( this9.pnlCanvas, x + this9.m_iOverlap );

					if w < this9.pnlCanvas.GetWide(this9.pnlCanvas) then
						this9.OffsetX = math.Clamp( this9.OffsetX, 0, this9.pnlCanvas.GetWide(this9.pnlCanvas) - this9:GetWide() );
					else
						this9.OffsetX = 0;
					end

					this9.pnlCanvas.x = this9.OffsetX * -1;

					local btnSize   = pad * 4;
					local btnOffset = h / 2;

					this9.btnLeft.SetSize( this9.btnLeft, btnSize * 1.5, btnSize );
					this9.btnLeft.SetPos( this9.btnLeft, pad * 4, btnOffset );

					this9.btnRight.SetSize( this9.btnRight, btnSize * 1.5, btnSize );
					this9.btnRight.SetPos( this9.btnRight, w - this9.btnRight.GetWide(this9.btnRight) - pad * 4, btnOffset );

					this9.btnLeft.SetVisible( this9.btnLeft, this9.pnlCanvas.x < 0 );
					this9.btnRight.SetVisible( this9.btnRight, this9.pnlCanvas.x + this9.pnlCanvas.GetWide(this9.pnlCanvas) > this9:GetWide() );
				end

				bb_content2.btnLeft.Paint = function( this8, w, h )
					local baseColor, textColor = rpui.GetPaintStyle( this8, STYLE_TRANSPARENT_INVERTED );
					surface.SetDrawColor( baseColor );
					surface.DrawRect( 0, 0, w, h );
					draw.SimpleText( "<", "rpui.Fonts.DonateMenu.ItemButtonBig", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
				end

				bb_content2.btnRight.Paint = function( this7, w, h )
					local baseColor, textColor = rpui.GetPaintStyle( this7, STYLE_TRANSPARENT_INVERTED );
					surface.SetDrawColor( baseColor );
					surface.DrawRect( 0, 0, w, h );
					draw.SimpleText( ">", "rpui.Fonts.DonateMenu.ItemButtonBig", w * 0.5, h * 0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
				end

				bb_content2.OnMouseWheeled = function() end

				for i = 1, 4 do
					local pnl_bgs2 = vgui.Create( "DPanel", bb_content2 );
					local job_md_dt = rp.teams[ rp.cfg.PremiumConfig[i].job() ]
					local seq = rp.cfg.PremiumConfig[i].sequence

					pnl_bgs2:SetText('')
					pnl_bgs2:SetSize(wh_bg5 * 0.48, wh_bg5)
					pnl_bgs2:SetPos(pad + (i - 1) * (wh_bg5 * 0.5 + pad), wh_bg4 * 0.3)

					pnl_bgs2.Paint = function(th04, bgw3, bgh3)
						th04.calpha = math.Approach(th04.calpha or 0.25, p.selected == i and 1 or 0.25, 0.1)

						surface.SetDrawColor(ColorAlpha(job_md_dt.color, th04.calpha * 255))
						surface.SetMaterial(selector_mat)

						th04.size = 0.9 + 0

						surface.DrawTexturedRect(bgw3 * 0.05, bgh3 / 2 - bgw3 * 0.8, bgw3 * 0.9, bgw3 * 1.8)

						if not th04.compiled then

							surface.SetFont("rpui.Fonts.DonateMenu.FlirtQuote2")
							local txt_sp_x = surface.GetTextSize(job_md_dt.name)

							if txt_sp_x < .8 * bgw3 then
								th04.compiled = { job_md_dt.name }
							else
								local str_exp = string.Explode(' ', job_md_dt.name)

								local temp_str = str_exp[1]
								local itt = 1
								local stt = 1

								th04.compiled = {}

								while itt < #str_exp do
									itt = itt + 1

									local txt_sp_x2 = surface.GetTextSize(temp_str .. (temp_str == '' and '' or ' ') .. str_exp[itt])

									if txt_sp_x2 > .8 * bgw3 then
										th04.compiled[stt] = temp_str
										temp_str = str_exp[itt]
										stt = stt + 1

									else
										temp_str = temp_str .. (temp_str == '' and '' or ' ') .. str_exp[itt]
									end
								end

								if temp_str ~= '' then
									th04.compiled[stt] = temp_str
								end
							end
						end

						local off = (#th04.compiled - 1) / 2

						for k, v in pairs(th04.compiled) do
							draw.SimpleText( v, "rpui.Fonts.DonateMenu.FlirtQuote2", bgw3 * 0.5, bgh3 - in_sz / 2 - off * in_sz * 0.46 + in_sz * 0.46 * (k - 1), Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
						end
					end

					local mview = vgui.Create( "DModelPanel", pnl_bgs2 );
					mview.SetSize( mview, wh_bg5 * 0.48 * 0.9, wh_bg5 * 0.48 * 1.8 );
					mview.SetPos( mview, wh_bg5 * 0.48 * 0.05, wh_bg5 / 2 - wh_bg5 * 0.48 * 0.9 );
					mview.SetModel( mview, istable(job_md_dt.model) and job_md_dt.model[1] or job_md_dt.model );
					mview.SetFOV( mview, 30 );
					mview.xVelocity     = 0;
					mview.xOffset       = 0;
					mview.yVelocity     = 0;
					mview.LayoutEntity = function() end
					mview.ZoomingVector = Vector(0,0,0);
					mview.OnMousePressed = function( this6, keycode )
						if IsValid( mview ) then
							if keycode == MOUSE_LEFT then
								p.selected = i
							end
						end
					end

					mview.Think = function( this5 )
						if IsValid(this5.Entity) and not this5.sequenced then
							this5.Entity.ResetSequence(this5.Entity, seq)
							this5.Entity.SetSkin(this5.Entity, rp.cfg.PremiumConfig[i].skin or 0)
							this5.sequenced = true

							this5.size_mult = rp.cfg.PremiumConfig[i].size_mult or 1
							this5.viewz = rp.cfg.PremiumConfig[i].viewZ or 0
						end

						this5.Entity.SetAngles( this5.Entity, Angle( 0, 20, 0 ) );
						this5.Entity.SetPos( this5.Entity, Vector(45 - 55 * this5.size_mult, 45 - 55 * this5.size_mult, 30 - 30 * this5.size_mult + this5.viewz) );
					end

					bb_content2:AddPanel(pnl_bgs2)
				end

				-- PURCHASE BUTTON
				local prem_sale_data = util.JSONToTable(nw.GetGlobal('prem_sale') or '[]') or {}
				local is_prem_sale = prem_sale_data.duration and prem_sale_data.duration > os.time(os.date("!*t"))
				local prem_discount = tonumber(prem_sale_data.discount or 0)

				if not rp.cfg.IsFrance then
					local cost = (rp.cfg.PremiumYearCost or rp.cfg.PremiumCost and rp.cfg.PremiumCost * 10 or 1990)
					cost = cost * (is_prem_sale and (100 - prem_discount) / 100 or 1)

					if (rp.cfg.PremiumCost or 199) == 199 then
						cost = math.ceil(cost)
					end

					cost = (cost % 1 ~= 0) and string.format('%4.2f', cost) or cost

					local btn = vgui.Create( "DButton", p )
						btn:SetFont('rpui.Fonts.DonateMenu.MenuButtonBigBold3')
						btn:SetSize(wh_bg * 0.438, wh_bg * 0.082)
						btn:SetPos((inner_width - wh_bg2) / 2 - wh_bg * 0.219 - pad * 2, wh_bg4 + header_tall + pad * 3 + wh_bg3 * 0.4 - wh_bg * 0.041)
						btn:SetText((cost .. translates.Get('Р / ПОЛГОДА')))
						btn.annual = true;
						btn.Paint = function( this5, w, h )
							this5.rotAngle = (this5.rotAngle or 0) + 100 * FrameTime();

							local this_text2 = this5:GetText()
							rpui.GetPaintStyle( this5, STYLE_GOLDEN );

							surface.SetDrawColor( my_new_col );
							surface.DrawRect( 0, 0, w, h );
							surface.SetDrawColor( Color(0,0,0) );
							surface.DrawRect( pad2, pad2, w - pad2 * 2, h - pad2 * 2 );

							local distsize  = math.sqrt( w*w + h*h );

							local parentalpha = rpui.DonateMenu.GetAlpha(rpui.DonateMenu) / 255;
							local alphamult   = LocalPlayer():HasPremium() and 1 or this5._alpha / 255;

							surface.SetAlphaMultiplier( parentalpha * alphamult );
								--surface.SetDrawColor( rpui.UIColors.BackgroundGold );
								surface.SetDrawColor( RainbowColor );
								surface.DrawRect( 0, 0, w, h );

								surface.SetMaterial( rpui.GradientMat );
								--surface.SetDrawColor( rpui.UIColors.Gold );
								surface.SetDrawColor( RainbowRotate );
								surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this5.rotAngle or 0) );

								draw.SimpleText( this_text2, this5:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
							surface.SetAlphaMultiplier( parentalpha * (1 - alphamult) );
								draw.SimpleText( this_text2, this5:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
							surface.SetAlphaMultiplier( 1 );

							return true
						end

						btn.DoClick = function(sbtn_1)
							--[[
							if rp.cfg.IsFrance then
								if net_in_progress then return end
								net_in_progress = true

								net.Start('Donate::GetPremiumID')
								net.SendToServer()

							else
								this:CreateDepositPanel(sbtn_1)
							end
							]]--

							this:CreateDepositPanel(sbtn_1)
						end

					rpui.DonateMenu.PremBtn = btn
				end

				if LocalPlayer():HasPremium() then
					timer.Simple(0, function()
						local dat_prem4 = util.JSONToTable(LocalPlayer():GetNetVar('GlobalRankData') or '[]')

						if dat_prem4.auto_pay != 1 then
							rpui.DonateMenu.PremBtn.DoClick = function()
								net.Start('Donate::PremiumToggle')
								net.SendToServer()

								if deni_prem then
									texts[deni_prem] = translates.Get('Отказаться от Premium')
								end

								rpui.DonateMenu.PremBtn.SetCursor(rpui.DonateMenu.PremBtn, 'arrow')
								rpui.DonateMenu.PremBtn.SetEnabled(rpui.DonateMenu.PremBtn, false)
							end

						else
							rpui.DonateMenu.PremBtn.SetCursor(rpui.DonateMenu.PremBtn, 'arrow')
							rpui.DonateMenu.PremBtn.SetEnabled(rpui.DonateMenu.PremBtn, false)
						end

						local dat_prem = util.JSONToTable(LocalPlayer():GetNetVar('GlobalRankData') or '[]')

						local lbl_time = vgui.Create( "DLabel", p )
						lbl_time:SetSize(wh_bg * 0.438, wh_bg * 0.052)
						lbl_time:SetPos((inner_width - wh_bg2) / 2 - wh_bg * 0.219 - pad * 2, wh_bg4 + header_tall + pad * 3 + wh_bg3 * 0.4 - wh_bg * 0.052 * 2)
						lbl_time:SetText('')
						lbl_time.Paint = function(tttt, w, h)
							local time_left = (LocalPlayer():GetNetVar('GlobalRankUntil') or os.time()) - os.time()
							local this_text1 = translates.Get('Осталось:') .. ' '

							time_left = (time_left < 86400) and 86400 or time_left

							--if time_left > 86400 then
								local days = math.ceil(time_left / 86400)
								this_text1 = this_text1 .. days .. ' ' .. ((days < 10 or days > 20) and ((days % 10 == 1 and translates.Get('день')) or (days % 10 > 0 and days % 10 < 5 and translates.Get('дня'))) or translates.Get('дней'))
							--else
							--	this_text1 = this_text1 .. ba.str.FormatTime(time_left, true)
							--end

							draw.SimpleText( this_text1, 'rpui.Fonts.DonateMenu.FlirtQuote2', 0, h, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );
						end

						local lbl_time2 = vgui.Create( "DLabel", p )
						lbl_time2:SetSize(wh_bg * 0.478, wh_bg * 0.052)
						lbl_time2:SetPos((inner_width - wh_bg2) / 2 - wh_bg * 0.219 - pad * 2, wh_bg4 + header_tall + pad * 4.2 + wh_bg3 * 0.4 - wh_bg * 0.052 + wh_bg * 0.082)
						lbl_time2:SetText('')
						lbl_time2.Paint = function()
							local dat_prem5 = util.JSONToTable(LocalPlayer():GetNetVar('GlobalRankData') or '[]')

							if dat_prem5.auto_pay != 1 then
								draw.SimpleText( translates.Get('Нажми, чтобы включить авто-продление!'), 'rpui.Fonts.DonateMenu.FlirtQuote2', 0, 0, rpui.UIColors.White, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
							end
						end
					end)
				end

				if not LocalPlayer():HasPremium() or rp.cfg.IsFrance then
					-- MONTHLY SUBSCRIPTION
					local cost = rp.cfg.PremiumCost or 199
					cost = (cost % 1 ~= 0) and string.format('%4.2f', cost) or cost

					cost = cost * (is_prem_sale and (100 - prem_discount) / 100 or 1)

					if (rp.cfg.PremiumCost or 199) == 199 then
						cost = math.ceil(cost)
					end

					local btn = vgui.Create( "DButton", p )
					rpui.DonateMenu.PremBtn = btn

					btn:SetFont('rpui.Fonts.DonateMenu.MenuButtonBigBold3')

					if not rp.cfg.IsFrance then
						btn:SetPos((inner_width - wh_bg2) / 2 - wh_bg * 0.219 - pad * 2, wh_bg4 + header_tall + pad * 4 + wh_bg3 * 0.4 - wh_bg * 0.041 + wh_bg * 0.082)

					else
						btn:SetPos((inner_width - wh_bg2) / 2 - wh_bg * 0.219 - pad * 2, wh_bg4 + header_tall + pad * 3 + wh_bg3 * 0.4 - wh_bg * 0.041)
					end

					btn:SetSize(wh_bg * 0.438, wh_bg * 0.082)
					btn:SetText(LocalPlayer():HasPremium() and translates.Get('Подписка активна') or (cost .. translates.Get('Р / МЕСЯЦ')))
					btn.Paint = function( this4, w, h )
						this4.rotAngle = (this4.rotAngle or 0) + 100 * FrameTime();

						local dat_prem3 = util.JSONToTable(LocalPlayer():GetNetVar('GlobalRankData') or '[]')

						local this_text = (LocalPlayer():HasPremium() and dat_prem3.auto_pay != 1) and translates.Get('Подписка неактивна') or this4:GetText()
						rpui.GetPaintStyle( this4, STYLE_GOLDEN );

						surface.SetDrawColor( my_new_col );
						surface.DrawRect( 0, 0, w, h );
						surface.SetDrawColor( Color(0,0,0) );
						surface.DrawRect( pad2, pad2, w - pad2 * 2, h - pad2 * 2 );

						local distsize  = math.sqrt( w*w + h*h );

						local parentalpha = rpui.DonateMenu.GetAlpha(rpui.DonateMenu) / 255;
						local alphamult   = LocalPlayer():HasPremium() and 1 or this4._alpha / 255;

						surface.SetAlphaMultiplier( parentalpha * alphamult );
							--surface.SetDrawColor( rpui.UIColors.BackgroundGold );
							surface.SetDrawColor( RainbowColor );
							surface.DrawRect( 0, 0, w, h );

							surface.SetMaterial( rpui.GradientMat );
							--surface.SetDrawColor( rpui.UIColors.Gold );
							surface.SetDrawColor( RainbowRotate );
							surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this4.rotAngle or 0) );

							draw.SimpleText( this_text, this4:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
						surface.SetAlphaMultiplier( parentalpha * (1 - alphamult) );
							draw.SimpleText( this_text, this4:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
						surface.SetAlphaMultiplier( 1 );

						return true
					end

					btn.DoClick = function(sbtn_2)
						--[[
						if rp.cfg.IsFrance then
							if net_in_progress then return end
							net_in_progress = true

							net.Start('Donate::GetPremiumID')
							net.SendToServer()

						else
							this:CreateDepositPanel(sbtn_2)
						end
						]]--

						this:CreateDepositPanel(sbtn_2)
					end
				end
			end,

			FrameOpen = function() end,
			HeaderInvisible = true
        }