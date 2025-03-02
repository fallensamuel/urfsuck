-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\init_f4menu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function rp.CloseF4Menu()
	if rp and IsValid(rp.F4MenuPanel) then
		rp.F4MenuPanel.Close(rp.F4MenuPanel)
	end
end

hook.Add( "ConfigLoaded", "rpui.InitializeF4Menu", function()
	function GM:ShowSpare2()
			if IsValid(rp.F4MenuPanel) then
				rp.F4MenuPanel.Close(rp.F4MenuPanel)
				return
			end

			net.Start("F4Menu::Open")
			net.WriteBool(false)
			net.SendToServer()

			local F4Menu = vgui.Create( "rpui.F4Menu", GetHUDPanel() );
			F4Menu:SetSize( ScrW() * 0.75, ScrH() * 0.75 );
			F4Menu:Center();
			F4Menu:MakePopup();

			rp.F4MenuPanel = F4Menu

			F4Menu.OnCreated = function( this )
				local CmdsList = this:AddTab( translates.Get("Действия"), vgui.Create("rpui.CommandsList") );
				CmdsList:SetSpacing( this.innerPadding );

				--if rp.cfg.EnableF4Jobs then
					local ProfList = this:AddTab( translates.Get("Профессии"), function()
						local f4jobmenu = rp.OpenEmployerMenu(table.GetKeys(rp.Factions))
						f4jobmenu.IsThroughF4 = not rp.cfg.EnableF4Jobs
						this:Close()
					end);
				--end

				hook.Run('PopulateNewF4Tabs', this)

				local ShopList = vgui.Create("rpui.ShopList")

				if IsValid(ShopList) then
					ShopList = this:AddTab( translates.Get("Магазин"), ShopList );
					ShopList:SetSpacing( this.innerPadding );
				end

				if not rp.cfg.DisableF4Crafting then
					local CraftingMenu = this:AddTab( translates.Get("Крафтинг"), vgui.Create("rpui.CraftingMenu") );
					CraftingMenu:SetSpacing( this.innerPadding );
				end

				if rp.cfg.EnableDiplomacy then
					local DiplomacyMenu = this:AddTab( translates.Get("Дипломатия"), vgui.Create("rpui.Diplomacy") );

					if DiplomacyMenu.SetSpacing then
						DiplomacyMenu:SetSpacing( this.innerPadding );
					end
				end

				if rp.seasonpass and (LocalPlayer().GetSeason and LocalPlayer():GetSeason() or rp.seasonpass.GetSeason()) then
					local Seasonpass = this:AddTab(translates.Get("Urf Pass"), function()
						this:Close();

						local SeasonpassMenu = vgui.Create("rpui.Seasonpass")
						SeasonpassMenu.SetSize(SeasonpassMenu, ScrW() * 0.75, ScrH() * 0.75)
						SeasonpassMenu.Center(SeasonpassMenu)
						SeasonpassMenu.MakePopup(SeasonpassMenu)

					end, nil, function(SPButton)
						local season = LocalPlayer().GetSeason and LocalPlayer():GetSeason() or rp.seasonpass.GetSeason()
						local f4_mat = season.F4ButtonMaterial
						local f4_col = season.F4ButtonColor
						local f4b_col = season.F4ButtonBackColor
						local f4_col2 = Color(season.F4ButtonColor.r * 0.7, season.F4ButtonColor.g * 0.7, season.F4ButtonColor.b * 0.7)

						local noShadowing = season.F4ButtonNoShadowing

						SPButton:SetText('')

						SPButton.Paint = function(sp, sp_w, sp_h)
							sp.rotAngle = (sp.rotAngle or 0) + 100 * FrameTime();
							local baseColor, textColor = rpui.GetPaintStyle( sp, STYLE_GOLDEN );
							surface.SetDrawColor( Color(0, 0, 0, (sp:IsHovered() or noShadowing) and 255 or 146) );
							surface.DrawRect( 0, 0, sp_w, sp_h );

							local mX, mY = sp:LocalCursorPos()
							mY = -(mY - sp_h * 0.5) / ScrH() * 0.2 * sp_h

							sp.mY = (sp.mY or 0) + (mY - (sp.mY or 0)) * FrameTime() * 7

							local distsize  = math.sqrt( sp_w*sp_w + sp_h*sp_h );
							local parentalpha = sp.GetParent(sp).GetParent(sp.GetParent(sp)).GetAlpha(sp.GetParent(sp).GetParent(sp.GetParent(sp))) / 255;
							local alphamult   = noShadowing and 1 or (sp._alpha / 255);

							surface.SetAlphaMultiplier( parentalpha * (0.25 + 0.75 * alphamult) );
								if f4b_col then
									surface.SetDrawColor( f4b_col )
									surface.DrawRect( 0, 0, sp_w, sp_h );
								end

								if f4_mat then
									if noShadowing then
										rpui.DrawStencilBorder( sp, 0, 0, sp_w, sp_h, 0.06, f4_col2, f4_col,sp.GetParent(sp).GetParent(sp.GetParent(sp)).GetAlpha(sp.GetParent(sp).GetParent(sp.GetParent(sp))) / 255 );

										surface.SetDrawColor( Color(255, 255, 255, parentalpha * sp._alpha) )
										surface.SetMaterial(f4_mat)
										surface.DrawTexturedRect( 2, 2, sp_w - 4, sp_h - 4 );

									else
										surface.SetDrawColor( Color(255, 255, 255, 255) )
										surface.SetMaterial(f4_mat)
										surface.DrawTexturedRect( 2, 2, sp_w - 4, sp_h - 4 );
									end

								elseif f4_col then
									--surface.SetDrawColor( Color(0, 0, 0, 0) )
									--surface.SetDrawColor( rpui.UIColors.BackgroundGold );
									--surface.DrawRect( -sp_w * 0.1, sp.mY - sp_h * 0.1, sp_w * 1.2, sp_h * 1.2 );

									surface.SetMaterial( rpui.GradientMat );
									surface.SetDrawColor( f4_col );
									surface.DrawTexturedRectRotated( sp_w * 0.5, sp_h * 0.5, distsize, distsize, (sp.rotAngle or 0) );

									surface.SetAlphaMultiplier( parentalpha * (1 - alphamult) );
									draw.SimpleText( translates.Get("BATTLEPASS"), "rpui.Fonts.F4Menu.GoldTabButton" or sp:GetFont(), sp_w * 0.5, sp_h * 0.5, f4_col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
								end
							surface.SetAlphaMultiplier( 1 );

							draw.SimpleText( translates.Get("BATTLEPASS"), "rpui.Fonts.F4Menu.GoldTabButton" or sp:GetFont(), sp_w * 0.5, sp_h * 0.5, f4_col, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
						end

						if not noShadowing then
							SPButton.PaintOver = function(spo, spo_w, spo_h)
								rpui.DrawStencilBorder( spo, 0, 0, spo_w, spo_h, 0.06, f4_col2, f4_col,spo.GetParent(spo).GetParent(spo.GetParent(spo)).GetAlpha(spo.GetParent(spo).GetParent(spo.GetParent(spo))) / 255 );
							end
						end

					end)
				end

				if rp.cfg.EnableAttributes then
					local AttributesMenu = this:AddTab( translates.Get("Навыки"), vgui.Create("rpui.AttributesMenu") );

					if AttributesMenu.SetSpacing then
						AttributesMenu:SetSpacing( this.innerPadding );
					end
				end

				if rp.cfg.EnableSkills then
					local tree = select(2, table.Random(SkillTrees.Trees.list))
					local SkillsMenu = this:AddTab(translates.Get("Способности"), SkillTrees:Menu(tree));

					if SkillsMenu.SetSpacing then
						SkillsMenu:SetSpacing( this.innerPadding );
					end
				end

				local BonusesMenu = this:AddTab( translates.Get("Бонусы"), vgui.Create("rpui.BonusesMenu") );

				if BonusesMenu.SetSpacing then
					BonusesMenu:SetSpacing( this.innerPadding );
				end

				if not rp.cfg.DisableF4Orgs then
					if LocalPlayer():GetOrg() == nil then
						this:AddTab( translates.Get("Организации"), function()
							local ScrScale = ScrH()/1080

							local menu = vgui.Create("urf.im/rpui/menus/createorg")
							menu:SetSize(650*ScrScale, 245*ScrScale)
							menu:Center()
							menu:MakePopup()

							menu.header.SetIcon(menu.header, "rpui/misc/flag.png")
							menu.header.SetTitle(menu.header, utf8.upper(translates.Get("Создать Организацию")))
							menu.header.SetFont(menu.header, "rpui.playerselect.title")

							for k, v in pairs(rp.cfg.DefaultOrgBanners) do
								if wmat.Get("rp.DefaultOrgBanner." .. k) then
									menu.logoselector.AddItem( menu.logoselector, wmat.Get("rp.DefaultOrgBanner." .. k) )
								else
									wmat.Create("rp.DefaultOrgBanner." .. k, {
										URL = v,
										W = 100,
										H = 100
									}, function(material)
										if not IsValid(menu) or not IsValid(menu.logoselector) then return end
										menu.logoselector.AddItem( menu.logoselector, material )
									end, function() end)
								end
							end

							menu.ActiveBanner = 1
							local web_mat = wmat.Get("rp.DefaultOrgBanner." .. menu.ActiveBanner)
							menu.logoselector.SetActiveItem(menu.logoselector, web_mat)

							this:Close();
						end );
					else
						local OrganisationMenu = this:AddTab( translates.Get("Организации"), vgui.Create("rpui.OrganisationMenu") );
						OrganisationMenu:SetSpacing( this.innerPadding );
						this.OrganisationMenu = OrganisationMenu
					end
				end

				if rp.cfg.EnableHats then
					--[[ deprecated
					local HatsMenu = this:AddTab( translates.Get("Аксессуары"), vgui.Create("rpui.HatsMenu") );

					if HatsMenu.SetSpacing then
						HatsMenu:SetSpacing( this.innerPadding );
					end
					]]--

					local AccessoriesMenu = this:AddTab( translates.Get("Аксессуары"), vgui.Create("rpui.AccessoriesMenu") );

					if AccessoriesMenu.SetSpacing then
						AccessoriesMenu:SetSpacing( this.innerPadding );
					end
				end

				local SettingsList = this:AddTab( translates.Get("Настройки"), vgui.Create("rpui.SettingsList"), function()
					net.Start("F4Menu::Open")
					net.WriteBool(true)
					net.SendToServer()
				end);
				SettingsList:SetSpacing( this.innerPadding );

				local DonateMenu = this:AddTab( translates.Get("Донат"), function()
					this:Close();
					RunConsoleCommand('say', '/upgrades');
				end, nil, function(Button)
					Button:SetText('');
					Button.HoverTime = nil;

					local os_time = os.time()
					local prem_sale_data = util.JSONToTable(nw.GetGlobal('prem_sale') or '[]') or {}
					local is_prem_sale = prem_sale_data.duration and prem_sale_data.duration > os.time()
					local is_sale = rp.GetDiscountTime() >= os_time
					local is_skinsmult = rp.GetSkinsDonateMultiplayerTime and rp.GetSkinsDonateMultiplayerTime() >= os_time
					local is_globalmult = rp.GetDonateMultiplayerTime and rp.GetDonateMultiplayerTime() >= os_time
					local Sale = is_sale and table.Copy(nw.GetGlobal('rp.shop.settings')) or {global = 0, duntil = 0};

					local case_present = nw.GetGlobal('donate_case_present') or '[]'
					case_present = util.JSONToTable(case_present)

					local has_crowdfund = ba.svar.Get('crowdfund') and ba.svar.Get('crowdfund') ~= ''
					local crowdfund_data
					if has_crowdfund then
						crowdfund_data = util.JSONToTable(ba.svar.Get('crowdfund'))
						has_crowdfund = crowdfund_data.time and tonumber(crowdfund_data.time) > os.time()
					end

					local has_crowdpromo = ba.svar.Get('crowdpromo') and ba.svar.Get('crowdpromo') ~= ''
					local crowdpromo_data
					if has_crowdpromo then
						crowdpromo_data = util.JSONToTable(ba.svar.Get('crowdpromo'))
						has_crowdpromo = crowdpromo_data.time and tonumber(crowdpromo_data.time) > os.time()
					end

					local personal_ = LocalPlayer().GetPersonalDiscount and LocalPlayer():GetPersonalDiscount()*100 or 0
					local is_personal_sale
					if personal_ > Sale.global then
						Sale.global = personal_
					end
					if not is_sale and personal_ > 0 then
						is_sale = true
						is_personal_sale = true
					end

					local multplyaer_personal_ = LocalPlayer().GetPersonalDonateMultiplayer and LocalPlayer():GetPersonalDonateMultiplayer() or 0

					local btn_name = translates.Get('ДОНАТ') .. (is_sale and ' (-' .. Sale.global .. '%)' or '')

					function Button:Paint(w, h)
						Button._borderalpha = math.Approach( Button._borderalpha or 0, (Button.IsHovered(Button) or Button.Selected) and 1 or 0, 3 * FrameTime() );

						Button.rotAngle = (Button.rotAngle or 0) + 100 * FrameTime();

						local baseColor = rpui.GetPaintStyle( Button, STYLE_GOLDEN );

						Button.textColor = Color(
							rpui.UIColors.White.r * Button._borderalpha + rpui.UIColors.Black.r * (1 - Button._borderalpha),
							rpui.UIColors.White.g * Button._borderalpha + rpui.UIColors.Black.g * (1 - Button._borderalpha),
							rpui.UIColors.White.b * Button._borderalpha + rpui.UIColors.Black.b * (1 - Button._borderalpha),
							255
						);
						--surface.SetDrawColor( Color(0,0,0,Button:IsHovered() and 255 or 146) );
						--surface.DrawRect( 0, 0, w, h );

						Button._alpha = 255
						local distsize  = math.sqrt( w*w + h*h );
						local parentalpha = Button.GetParent(Button).GetParent(Button.GetParent(Button)).GetAlpha(Button.GetParent(Button).GetParent(Button.GetParent(Button))) / 255;
						local alphamult   = 1;

						local clrgreen = Color(24, 167, 28);
						local clrblack = Color(0, 0, 0, 205);

						surface.SetAlphaMultiplier( parentalpha * alphamult );
							surface.SetDrawColor( clrgreen );
							surface.DrawRect( 0, 0, w, h );

							surface.SetMaterial( rpui.GradientMat );
							surface.SetDrawColor( clrblack );
							surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (Button.rotAngle or 0) );

							draw.SimpleText( btn_name, "rpui.Fonts.F4Menu.GoldTabButton" or Button:GetFont(), w * 0.5, h * 0.5, Button.textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
						--surface.SetAlphaMultiplier( parentalpha * (1 - alphamult) );
						--	draw.SimpleText( btn_name, "rpui.Fonts.F4Menu.GoldTabButton" or Button:GetFont(), w * 0.5, h * 0.5, rpui.UIColors.TextGold, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
						surface.SetAlphaMultiplier( 1 );
					end

					function Button:PaintOver(w, h)
						local clr = Color(
							Button.textColor.r,
							Button.textColor.g,
							Button.textColor.b,
							Button._borderalpha * 255
						);

						rpui.DrawStencilBorder( Button, 0, 0, w, h, 0.06, clr, clr, Button._borderalpha * 255 );
					end

					function Button:Think()
						if !IsValid(self.Hint) then
							self:DrawHint()
						end

						if !IsValid(self.CrowdfundHint) then
							self:DrawCrowdfundHint()
						end

						if !IsValid(self.CrowdpromoHint) then
							self:DrawCrowdpromoHint()
						end
					end

					local frameH = ScrH()
					surface.CreateFont( "rpui.Fonts.F4Menu.CF1", {
						font     = "Montserrat",
						extended = true,
						weight 	 = 600,
						size     = frameH * 0.03,
					} );

					surface.CreateFont( "rpui.Fonts.F4Menu.CF2", {
						font     = "Montserrat",
						extended = true,
						weight 	 = 620,
						size     = frameH * 0.019,
					} );

					surface.CreateFont( "rpui.Fonts.F4Menu.Tooltip", {
						font     = "Montserrat",
						extended = true,
						weight = 500,
						size     = frameH * 0.0175,
					} );

					local Text_ExpireGroup = translates.Get("Привелегия истечёт через ")
					function Button:DrawUsergroupExpire(iscrowdfund_enabled)
						local expire = LocalPlayer():GetNetVar("UsergroupExpire")
						local time = os.time()

						if not expire or expire == 0 or expire < time or LocalPlayer():GetUserGroup() == "Premium" then return end

						if IsValid(self.UsergroupExpire) then

							return
						end

						self.UsergroupExpire = vgui.Create("EditablePanel")
						local UsergroupExpire = self.UsergroupExpire

						local PseudoParent = self.GetParent(self).GetParent(self.GetParent(self));
						local FrameX, FrameY = PseudoParent:GetPos();
						local FrameSY = PseudoParent:GetTall();
						local FrameSX = PseudoParent:GetWide();

						local function FormatTime(time_left)
							local s = time_left % 60
							local m = math.floor(time_left / 60) % 60
							local h = math.floor(time_left / 3600)

							return string.format('%02i:%02i:%02i', h, m, s)
						end

						UsergroupExpire.Resize = function()
							surface.SetFont("rpui.Fonts.F4Menu.Tooltip")
							local tW, tH = surface.GetTextSize(Text_ExpireGroup .. FormatTime(expire - os.time()))
							UsergroupExpire:SetSize(tW + 16, tH + 8)
							UsergroupExpire:SetPos(FrameX + PseudoParent:GetWide() - UsergroupExpire:GetWide(), FrameY - UsergroupExpire:GetTall());
						end

						UsergroupExpire.Resize()

						timer.Create("f4menu/usergroup/expire", 1, 0, function()
							if IsValid(UsergroupExpire) == false then
								return timer.Remove("f4menu/usergroup/expire")
							end
							UsergroupExpire.Resize()
						end)

						local bgColor = Color(0, 12, 24, 74)
						function UsergroupExpire:Paint(w, h)
							if not IsValid(Button) or LocalPlayer():GetUserGroup() == "Premium" then return end

							local exp = expire - os.time()
							if exp <= 0 then return end

							surface.SetAlphaMultiplier(F4Menu:GetAlpha() / 255)
								draw.Blur(self)
								surface.SetDrawColor(bgColor)
								surface.DrawRect(0, 0, w, h)

								draw.SimpleText(Text_ExpireGroup .. FormatTime(exp), "rpui.Fonts.F4Menu.Tooltip", w*0.5, h*0.5, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							surface.SetAlphaMultiplier(1)
						end

						function UsergroupExpire:Think()
							if IsValid(PseudoParent) == false or expire - os.time() <= 0 then
								self:Remove()
							end
						end
					end

					function Button:DrawCrowdfundHint()
						if not has_crowdfund then self:DrawUsergroupExpire() return end
						if (IsValid(self.CrowdfundHint)) then self:DrawUsergroupExpire(true) return end
						self:DrawUsergroupExpire(true)

						self.CrowdfundHint = vgui.Create( "DButton" );
						self.CrowdfundHint.InvalidateParent( self.CrowdfundHint, true );

						local PseudoParent = self.GetParent(self).GetParent(self.GetParent(self));
						local FrameX, FrameY = PseudoParent:GetPos();
						local FrameSY = PseudoParent:GetTall();
						local FrameSX = PseudoParent:GetWide();

						local function get_nice_text(num)
							local nice_text = ''
							local as_text = '' .. num
							local length = #as_text

							for i = 1, #as_text do
								nice_text = as_text[length - i + 1] .. nice_text
								if i % 3 == 0 then
									nice_text = ' ' .. nice_text
								end
							end

							return nice_text
						end

						local percent = math.floor(tonumber(crowdfund_data.funded) / tonumber(crowdfund_data.amount) * 100)
						local clamped_percent = math.min(percent, 100)
						local nice_money_text_1 = get_nice_text(crowdfund_data.amount)
						local nice_money_text_2 = get_nice_text(crowdfund_data.funded)

						local tt_lables = {
							translates.Get('Любое ваше пополнение будет потрачено исключительно'),
							translates.Get('на цель сбора средств. Кликните по банеру для получения'),
							translates.Get('более подробной информации.'),
						}

						surface.SetFont("rpui.Fonts.F4Menu.Tooltip")
						local t_x3, t_y3 = surface.GetTextSize(tt_lables[1])
						local tooltip_width = t_x3
						local tooltip_height = t_y3 * 3

						surface.SetFont("rpui.Fonts.F4Menu.CF1")
						local t_x2, t_y2 = surface.GetTextSize(crowdfund_data.name)
						local t_x6, t_y6 = surface.GetTextSize('00:00:00')
						local t_x7, t_y7 = surface.GetTextSize('100%')

						surface.SetFont("rpui.Fonts.F4Menu.CF2")
						local t_x4, t_y4 = surface.GetTextSize(translates.Get('из %s собрано', nice_money_text_1))
						local t_x5, t_y5 = surface.GetTextSize(translates.Get('осталось'))

						local my_size_x = ScrW() * .1 + math.max(t_x2, t_x4 + t_x5 + t_x6 + t_x7 + ScrW() * 0.005);
						local self_crowdfund_hint = self.CrowdfundHint;

						self_crowdfund_hint:SetAlpha(0);
						self_crowdfund_hint:SetText('');

						self_crowdfund_hint:SetSize(my_size_x, math.Round(ScrH() * .115));

						if IsValid(self.Hint) then
							self_crowdfund_hint:SetPos(FrameX + FrameSX - my_size_x - this.innerPadding, FrameY + FrameSY);
						else
							self_crowdfund_hint:SetPos(FrameX + this.innerPadding, FrameY + FrameSY);
						end

						function self_crowdfund_hint:FormatTime(time_left)
							local s = time_left % 60
							local m = math.floor(time_left / 60) % 60
							local h = math.floor(time_left / 3600)

							return string.format('%02i:%02i:%02i', h, m, s)
						end

						function self_crowdfund_hint:Paint( w, h )
							if not IsValid(Button) then return end
							Button.rotAngle = (Button.rotAngle or 0) + 100 * FrameTime();
							local baseColor, textColor = rpui.GetPaintStyle( Button, STYLE_GOLDEN );
							surface.SetDrawColor( Color(0,0,0,255))

							local distsize  = math.sqrt( w*w + h*h );
							local parentalpha = self:GetAlpha() / 255;
							local alphamult   = Button._alpha / 255;

							local time_left = math.max(0, tonumber(crowdfund_data.time) - os.time())

							rpui.ExperimentalStencil(function()
								draw.NoTexture();
								surface.SetDrawColor( rpui.UIColors.White );

								if IsValid(Button.Hint) then
									surface.DrawPoly( {{x = w - 16, y = 16}, {x = w, y = 0}, {x = w, y = 16}} );
								else
									surface.DrawPoly( {{x = 16, y = 16}, {x = 0, y = 16}, {x = 0, y = 0}} );
								end
								surface.DrawRect(0, 16, w, h);

								render.SetStencilCompareFunction( STENCIL_EQUAL );
								render.SetStencilFailOperation( STENCIL_KEEP );

								surface.SetAlphaMultiplier( F4Menu:GetAlpha() / 255 );
									surface.SetDrawColor( rpui.UIColors.BackgroundGold );
									surface.DrawRect(0, 0, w, h);

									surface.SetMaterial( rpui.GradientMat );
									surface.SetDrawColor( rpui.UIColors.Gold );
									surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (Button.rotAngle or 0) );

									local real_h = h - 16

									surface.SetDrawColor( Color(0, 0, 0, 77));
									surface.DrawRect( h * 0.3, 16 + math.Round(real_h * 0.45), (w - h * 0.6), math.Round(real_h * 0.1) );

									surface.SetDrawColor( Color(239, 0, 57, 255));
									surface.DrawRect( h * 0.3, 16 + math.Round(real_h * 0.45), (w - h * 0.6) * 0.01 * clamped_percent, math.Round(real_h * 0.1) );

									surface.SetDrawColor( Color(255, 255, 255, 255));
									surface.DrawRect( h * 0.3 + (w - h * 0.6) * 0.01 * clamped_percent - math.Round(real_h * 0.08), 16 + math.Round(real_h * 0.42), math.Round(real_h * 0.16), math.Round(real_h * 0.16) );

									draw.SimpleText( crowdfund_data.name, "rpui.Fonts.F4Menu.CF1", h * 0.3, 16 + math.Round(real_h * 0.4), rpui.UIColors.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM );

									draw.SimpleText( self:FormatTime(time_left), "rpui.Fonts.F4Menu.CF1", h * 0.3, 16 + math.floor(real_h * 0.6 - ScrH() * 0.002), rpui.UIColors.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );

									draw.SimpleText( percent .. '%', "rpui.Fonts.F4Menu.CF1", w - h * 0.3, 16 + math.floor(real_h * 0.6 - ScrH() * 0.002), rpui.UIColors.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP );

									draw.SimpleText( nice_money_text_2 .. ' ' .. translates.Get("₽"), "rpui.Fonts.F4Menu.CF1", w - h * 0.3, 16 + math.Round(real_h * 0.4), rpui.UIColors.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_BOTTOM );


									if not self.TimeOffset or self.TimeOffsetSave ~= time_left then
										surface.SetFont("rpui.Fonts.F4Menu.CF1")

										local t_x, t_y = surface.GetTextSize(self:FormatTime(time_left))
										self.TimeOffset = t_x
									end

									if not self.PercentOffset then
										surface.SetFont("rpui.Fonts.F4Menu.CF1")

										local t_x1, t_y1 = surface.GetTextSize(percent .. '%')
										self.PercentOffset = t_x1
									end

									draw.SimpleText( translates.Get('осталось'), "rpui.Fonts.F4Menu.CF2", self.TimeOffset + ScrW() * 0.01 + h * 0.3, 16 + math.ceil(real_h * 0.6), rpui.UIColors.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );

									draw.SimpleText( translates.Get("из %s собрано", nice_money_text_1), "rpui.Fonts.F4Menu.CF2", w - h * 0.3 - ScrW() * 0.01 - self.PercentOffset, 16 + math.ceil(real_h * 0.6), rpui.UIColors.Black, TEXT_ALIGN_RIGHT, TEXT_ALIGN_TOP );
								surface.SetAlphaMultiplier( 1 );
							end);
						end

						function self_crowdfund_hint:Think()
							if tonumber(crowdfund_data.time) - os.time() <= 0 then
								self:Remove()
							end
							if (!IsValid(PseudoParent)) then
								self:Remove();
							end
						end

						function self_crowdfund_hint:DoClick()
							gui.OpenURL(crowdfund_data.link)
						end


						local t_px, t_py = self_crowdfund_hint:GetPos()
						local t_sx, t_sy = self_crowdfund_hint:GetSize()

						t_px = t_px + (t_sx - (tooltip_width + tooltip_height * 0.1)) / 2

						self_crowdfund_hint.Tooltip = vgui.Create( "DPanel" );
						local tooltip = self_crowdfund_hint.Tooltip;

						tooltip:SetPos( t_px, t_py - tooltip_height * 1.5 + frameH * 0.015 );
						tooltip:SetSize( tooltip_width + tooltip_height * 0.4, math.ceil(tooltip_height * 1.55) );
						tooltip:SetAlpha( 0 );
						tooltip:DockPadding( 0, tooltip_height * 0.1, 0, 0 );

						tooltip.Think = function(tt)
							if not IsValid(Button) then
								tt:Remove()
							end
						end

						tooltip.Paint = function(tt, wt, ht)
							surface.SetDrawColor(Color(0, 0, 0, 255))
							surface.DrawRect(0, 0, wt, math.ceil(tooltip_height * 1.25))

							if tt.BakedPoly then
								draw.NoTexture();
								surface.DrawPoly( tt.BakedPoly );
							else
								tt.BakedPoly = {
									{ x = wt / 2 - ht * 0.23, y = math.floor(tooltip_height * 1.25) },
									{ x = wt / 2 + ht * 0.23, y = math.floor(tooltip_height * 1.25) },
									{ x = wt / 2,              y = ht },
								};
							end
						end

						for i = 1, 3 do
							local label = vgui.Create( "DLabel", tooltip );

							label:Dock( TOP );
							label:DockMargin( 0, tooltip_height * 0.025, 0, 0 );
							label:SetFont( "rpui.Fonts.F4Menu.Tooltip" );
							label:SetTextColor( rpui.UIColors.White );
							label:SetContentAlignment(2)
							label:SetText( tt_lables[i] );
							label:SetSize( tooltip_width + tooltip_height * 0.1, t_y3 );
						end

						self_crowdfund_hint._OnCursorEntered = self_crowdfund_hint.OnCursorEntered;
						self_crowdfund_hint._OnCursorExited  = self_crowdfund_hint.OnCursorExited;

						self_crowdfund_hint.OnCursorEntered = function()
							if self_crowdfund_hint._OnCursorEntered then
								self_crowdfund_hint:_OnCursorEntered();
							end

							if IsValid( self_crowdfund_hint.Tooltip ) then
								self_crowdfund_hint.Tooltip.ActivePanel = true

								self_crowdfund_hint.Tooltip.MakePopup( self_crowdfund_hint.Tooltip )
								self_crowdfund_hint.Tooltip.SetMouseInputEnabled( self_crowdfund_hint.Tooltip, false );
								self_crowdfund_hint.Tooltip.SetKeyBoardInputEnabled( self_crowdfund_hint.Tooltip, false );

								self_crowdfund_hint.Tooltip.AlphaTo(self_crowdfund_hint.Tooltip, 255, 0.1);
							end
						end

						self_crowdfund_hint.OnCursorExited = function()
							if self_crowdfund_hint._OnCursorExited then
								self_crowdfund_hint:_OnCursorExited();
							end

							if IsValid( self_crowdfund_hint.Tooltip ) then
								self_crowdfund_hint.Tooltip.ActivePanel = nil
								self_crowdfund_hint.Tooltip.AlphaTo(self_crowdfund_hint.Tooltip, 0, 0.1);
							end
						end

						self_crowdfund_hint:AlphaTo(255, 0.25);
					end

					function Button:DrawCrowdpromoHint()
						if not has_crowdpromo then self:DrawUsergroupExpire() return end
						if IsValid(self.CrowdpromoHint) then self:DrawUsergroupExpire(true) return end
						self:DrawUsergroupExpire(true)

						self.CrowdpromoHint = vgui.Create( "DButton" );
						self.CrowdpromoHint.InvalidateParent( self.CrowdpromoHint, true );

						local PseudoParent = self.GetParent(self).GetParent(self.GetParent(self));
						local FrameX, FrameY = PseudoParent:GetPos();
						local FrameSY = PseudoParent:GetTall();
						local FrameSX = PseudoParent:GetWide();

						surface.SetFont( "rpui.Fonts.F4Menu.CF1" );
						local t_nw, t_nh = surface.GetTextSize( crowdpromo_data.name );
						local t_tw, t_th = surface.GetTextSize( "00:00:00" );

						surface.SetFont( "rpui.Fonts.F4Menu.CF2" );
						local t_taw, t_tah = surface.GetTextSize( translates.Get("осталось") );

						local block_width = ScrW() * 0.05 + math.max( t_nw, t_tw + t_taw + ScrW() * 0.01 );
						local self_crowdpromo_hint = self.CrowdpromoHint;

						self_crowdpromo_hint:SetAlpha( 0 );
						self_crowdpromo_hint:SetText( "" );

						self_crowdpromo_hint:SetSize( block_width, 16 + this.innerPadding * 0.5 + t_nh + this.innerPadding * 0.25 + t_th + this.innerPadding );

						if IsValid(self.Hint) then
							self_crowdpromo_hint:SetPos( FrameX + FrameSX - block_width - this.innerPadding, FrameY + FrameSY );
						else
							self_crowdpromo_hint:SetPos( FrameX + this.innerPadding, FrameY + FrameSY );
						end

						function self_crowdpromo_hint:FormatTime( time_left )
							local s = time_left % 60;
							local m = math.floor(time_left / 60) % 60;
							local h = math.floor(time_left / 3600);

							return string.format( "%02i:%02i:%02i", h, m, s );
						end

						function self_crowdpromo_hint:Paint( w, h )
							if not IsValid( Button ) then return end
							Button.rotAngle = (Button.rotAngle or 0) + 100 * FrameTime();

							local baseColor, textColor = rpui.GetPaintStyle( Button, STYLE_GOLDEN );
							surface.SetDrawColor( Color(0,0,0,255) );

							local distsize = math.sqrt( w*w + h*h );
							local parentalpha = self:GetAlpha() / 255;
							local alphamult = Button._alpha / 255;

							local time_left = math.max(0, tonumber(crowdpromo_data.time) - os.time())

							rpui.ExperimentalStencil(function()
								draw.NoTexture();
								surface.SetDrawColor( rpui.UIColors.White );

								if IsValid(Button.Hint) then
									surface.DrawPoly( {{x = w - 16, y = 16}, {x = w, y = 0}, {x = w, y = 16}} );
								else
									surface.DrawPoly( {{x = 16, y = 16}, {x = 0, y = 16}, {x = 0, y = 0}} );
								end
								surface.DrawRect(0, 16, w, h);

								render.SetStencilCompareFunction( STENCIL_EQUAL );
								render.SetStencilFailOperation( STENCIL_KEEP );

								surface.SetAlphaMultiplier( F4Menu:GetAlpha() / 255 );
									surface.SetDrawColor( rpui.UIColors.BackgroundGold );
									surface.DrawRect(0, 0, w, h);

									surface.SetMaterial( rpui.GradientMat );
									surface.SetDrawColor( rpui.UIColors.Gold );
									surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (Button.rotAngle or 0) );

									local real_h = h - 16

									draw.SimpleText( crowdpromo_data.name, "rpui.Fonts.F4Menu.CF1", h * 0.3, 16 + this.innerPadding * 0.5, rpui.UIColors.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );

									local t_x, t_y = draw.SimpleText( self:FormatTime(time_left), "rpui.Fonts.F4Menu.CF1", h * 0.3, 16 + this.innerPadding * 0.5 + t_nh + this.innerPadding * 0.25, rpui.UIColors.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
									draw.SimpleText( translates.Get('осталось'), "rpui.Fonts.F4Menu.CF2", t_x + ScrW() * 0.01 + h * 0.3, 16 + this.innerPadding * 0.5 + t_nh + this.innerPadding * 0.25, rpui.UIColors.Black, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP );
								surface.SetAlphaMultiplier( 1 );
							end);

							return true
						end

						function self_crowdpromo_hint:Think()
							if (tonumber(crowdpromo_data.time) - os.time()) <= 0 then
								self:Remove();
							end

							if not IsValid( PseudoParent ) then
								self:Remove();
							end
						end

						function self_crowdpromo_hint:DoClick()
							gui.OpenURL( crowdpromo_data.link );
						end

						self_crowdpromo_hint:AlphaTo( 255, 0.25 );
					end

					function Button:DrawHint()
						if (IsValid(self.Hint)) then return end
						if not is_prem_sale and not is_sale and (not is_skinsmult and not is_globalmult and multplyaer_personal_ <= 1) and not (case_present and case_present.time_until and case_present.time_until > os.time()) then return end

						self.Hint = vgui.Create( "DButton" );
						self.Hint.SetText(self.Hint, "")
						self.Hint.DoClick = function()
							RunConsoleCommand('say', '/upgrades')
						end
						self.Hint.InvalidateParent( self.Hint, true );

						local PseudoParent = self.GetParent(self).GetParent(self.GetParent(self));
						local FrameX, FrameY = PseudoParent:GetPos();
						local FrameSY = PseudoParent:GetTall();

						local self_hint = self.Hint;

						self_hint:SetAlpha(0);

						local lines_num = 2

						local remain_txt = translates.Get('осталось')
						local sale_txt = is_personal_sale and translates.Get('ПЕРСОНАЛЬНАЯ СКИДКА') or translates.Get('СКИДКА')
						local on_all_txt = translates.Get('НА ВСЁ')

						local tooltip_phrase, tooltip_phrase_args = "", {}

						local line1txt, line2txt, custom_font_

					--local prem_sale_data = util.JSONToTable(nw.GetGlobal('prem_sale') or '[]') or {}
					--local is_prem_sale = prem_sale_data.duration and prem_sale_data.duration > os.time(os.date("!*t"))

						if prem_sale_data.duration and prem_sale_data.duration > os.time() then
							local discount = tonumber(prem_sale_data.discount)
							local cost = rp.cfg.PremiumCost or 199

							tooltip_phrase = "Первый месяц премиум подписки сейчас стоит %sр!"
							tooltip_phrase_args = {(not rp.cfg.PremiumCost or rp.cfg.PremiumCost == 199) and math.ceil(cost * (100 - discount) / 100) or (cost * (100 - discount) / 100)}

							line1txt = translates.Get('СКИДКА %s%% НА ПРЕМИУМ!', discount)
							--line2txt = translates.Get('при пополнении от %sр', case_present.amount_until)
							--lines_num = 3

						elseif case_present and case_present.amount_until and case_present.time_until and case_present.time_until > os.time() then
							tooltip_phrase = "Например, пополнив счёт на %s р, вы получите два %s!"
							tooltip_phrase_args = {case_present.amount_until * 2, rp.lootbox.Map[case_present.present_id].name}

							line1txt = translates.Get('%s В ПОДАРОК', utf8.upper(rp.lootbox.Map[case_present.present_id].name))
							line2txt = translates.Get('за каждые пополненные %sр', case_present.amount_until)
							lines_num = 3

						elseif is_sale then
							local allowed_cats = {[translates.Get("Шапки")] = true, [translates.Get("Время")] = true, [translates.Get("Профессии")] = true, [translates.Get("Валюта")] = true}

							local items = {}
							for k, v in pairs(rp.shop.GetTable()) do
								if allowed_cats[v.Cat] then
									table.insert(items, v)
								end
							end

							local item = items[math.random(1, #items)]

							if item then
								local rub = " ".. translates.Get("РУБ")

								tooltip_phrase = "Например `%s` сейчас стоит %s вместо %s!"
								tooltip_phrase_args = {item.Name, math.floor(item.Price * (1 - Sale.global/100)) .. rub, item.Price .. rub}
							end

						else
							if is_globalmult then
								local mult = (rp.GetDonateMultiplayer and rp.GetDonateMultiplayer() or 0)

								sale_txt = translates.Get('БОНУС')
								on_all_txt = translates.Get('НА ПОПОЛНЕНИЯ')
								Sale = {
									global = 100 * mult
								}

								tooltip_phrase = "Например если вы пожертвуете %s руб, вы получите %s руб на ваш счёт"

								local min = rp.GetDonateMultiplayerMinimum()
								if min > 0 then
									lines_num = 3
									line2txt = translates.Get('при пожертвовании от %s руб', min)
									tooltip_phrase_args = {min + 50, (min + 50) * mult}
								else
									tooltip_phrase_args = {250, 250 * mult}
								end
							elseif is_skinsmult then
								sale_txt = translates.Get('БОНУС')
								on_all_txt = translates.Get('ДОНАТ СКИНАМИ')
								Sale = {
									global = 100 * rp.GetSkinsDonateMultiplayer()
								}

								tooltip_phrase = "Например если вы пожертвуете %s руб скинами, вы получите %s руб на ваш счёт"
								tooltip_phrase_args = {250, 250 * rp.GetSkinsDonateMultiplayer()}
							elseif multplyaer_personal_ > 1 then
								sale_txt = translates.Get('ПЕРСОНАЛЬНЫЙ БОНУС')
								on_all_txt = translates.Get('НА ПОПОЛНЕНИЯ')
								Sale = {
									global = multplyaer_personal_ * 100
								}
								custom_font_ = "rpui.Fonts.ESCMenu.Tooltip_2"

								tooltip_phrase = "Например если вы пожертвуете %s руб, вы получите %s руб на ваш счёт"
								tooltip_phrase_args = {250, 250 * multplyaer_personal_}
							end
						end

						if tooltip_phrase ~= "" then self_hint:SetTooltip(translates.Get(tooltip_phrase, unpack(tooltip_phrase_args))) end

						--local selfw, selfh = ScrW() * .25, 0.03 * ScrH()
						--self_hint:SetSize(selfw, selfh * lines_num);
						self_hint:SetPos(FrameX + this.innerPadding, FrameY + FrameSY);

						function self_hint:Paint( w, h )
							if not IsValid(Button) then return end
							Button.rotAngle = (Button.rotAngle or 0) + 100 * FrameTime();
							local baseColor, textColor = rpui.GetPaintStyle( Button, STYLE_GOLDEN );
							surface.SetDrawColor( Color(0,0,0,255))

							local distsize  = math.sqrt( w*w + h*h );
							local parentalpha = self:GetAlpha() / 255;
							local alphamult   = Button._alpha / 255;

							rpui.ExperimentalStencil(function()
								draw.NoTexture();
								surface.SetDrawColor( rpui.UIColors.White );

								surface.DrawPoly( {{x = 16, y = 16}, {x = 0, y = 16}, {x = 0, y = 0}} );
								surface.DrawRect(0, 16, w, h);

								render.SetStencilCompareFunction( STENCIL_EQUAL );
								render.SetStencilFailOperation( STENCIL_KEEP );

								surface.SetAlphaMultiplier( F4Menu:GetAlpha() / 255 );
									surface.SetDrawColor( rpui.UIColors.BackgroundGold );
									surface.DrawRect(0, 0, w, h);

									surface.SetMaterial( rpui.GradientMat );
									surface.SetDrawColor( rpui.UIColors.Gold );
									surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (Button.rotAngle or 0) );

									 local last = is_prem_sale and prem_sale_data.duration and prem_sale_data.duration > os.time() and (prem_sale_data.duration - os.time()) or case_present and case_present.time_until and case_present.time_until > os.time() and (case_present.time_until - os.time()) or is_personal_sale and (LocalPlayer().GetPersonalDiscountTime and LocalPlayer():GetPersonalDiscountTime() or 0) or is_sale and (rp.GetDiscountTime() - os.time()) or (
										is_globalmult and ((rp.GetDonateMultiplayerTime and rp.GetDonateMultiplayerTime() or 0) - os.time())
										or is_skinsmult and ((rp.GetSkinsDonateMultiplayerTime and rp.GetSkinsDonateMultiplayerTime() or 0) - os.time())
										or (LocalPlayer().GetPersonalDonateMultiplayerTime and LocalPlayer():GetPersonalDonateMultiplayerTime() or 0)
									 );
									 local tb = string.FormattedTime((last > 0) and last or 0);
									 local Out = remain_txt .. ' ' .. string.format("%02i:%02i:%02i", tb['h'], tb['m'], tb['s']);

									local show3lines = lines_num > 2

									local txt = sale_txt .. ' ' .. Sale.global .. '% ' .. on_all_txt
									surface.SetFont("rpui.Fonts.F4Menu.Hint1")
									local _w, _h = surface.GetTextSize(txt)

									if not self.ProperlyScaled then
										local ts, th = 0, 0;
										local __textw, __texth;

										__textw, __texth = draw.SimpleText( line1txt or txt, "rpui.Fonts.F4Menu.Hint1" or Button:GetFont(), w * 0.5, show3lines and _h or h * 0.675, rpui.UIColors.Black, TEXT_ALIGN_CENTER, show3lines and TEXT_ALIGN_TOP or TEXT_ALIGN_BOTTOM );
										ts = math.max( ts, __textw ); th = th + __texth;
										__textw, __texth = draw.SimpleText( line2txt or Out, "rpui.Fonts.F4Menu.Hint2" or Button:GetFont(), w * 0.5, h * 0.625, rpui.UIColors.Black, TEXT_ALIGN_CENTER, show3lines and TEXT_ALIGN_CENTER or TEXT_ALIGN_TOP );
										ts = math.max( ts, __textw ); th = th + __texth;

										if show3lines then
											__textw, __texth = draw.SimpleText( Out, "rpui.Fonts.F4Menu.Hint2" or Button:GetFont(), w * 0.5, h * 0.95, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );
											ts = math.max( ts, __textw ); th = th + __texth;
										end

										self:SetSize( math.max(self:GetWide(), ts + th*0.5), math.max(self:GetTall(), th * 1.5) );

										self.ProperlyScaled = true;
									else
										draw.SimpleText( line1txt or txt, "rpui.Fonts.F4Menu.Hint1" or Button:GetFont(), w * 0.5, show3lines and _h or h * 0.675, rpui.UIColors.Black, TEXT_ALIGN_CENTER, show3lines and TEXT_ALIGN_TOP or TEXT_ALIGN_BOTTOM );
										draw.SimpleText( line2txt or Out, "rpui.Fonts.F4Menu.Hint2" or Button:GetFont(), w * 0.5, h * 0.625, rpui.UIColors.Black, TEXT_ALIGN_CENTER, show3lines and TEXT_ALIGN_CENTER or TEXT_ALIGN_TOP );

										if show3lines then
											draw.SimpleText( Out, "rpui.Fonts.F4Menu.Hint2" or Button:GetFont(), w * 0.5, h * 0.95, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM );
										end
									end
								surface.SetAlphaMultiplier( 1 );
							end);
						end

						function self_hint:Think()
							if (!IsValid(PseudoParent)) then
								self:Remove();
							end
						end

						self_hint:AlphaTo(255, 0.25);
					end
				end );
			end
	end
end );
