-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\controls\\rpui_cases_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

rpui.UIColors.White = Color(255, 255, 255, 255)
local my_new_color = rpui.UIColors.White
local my_new_color2 = rpui.UIColors.BackgroundGold
local my_new_color3 = rpui.UIColors.Gold

local hue = SysTime()*0.1 % 360
local RainbowColor = HSVToColor(hue, 0.77, 0.77)
local RainbowRotate = HSLToColor(hue, 0.90, 0.40)

local flagged = false

return {
			MenuPaint = function( this16, w, h )
                this16.rotAngle = (this16.rotAngle or 0) + 100 * FrameTime();
        
				hue = SysTime()*0.1 % 360
				RainbowColor = HSVToColor(hue, 0.77, 0.77)
				RainbowRotate = HSLToColor(hue, 0.90, 0.40)
				
                surface.SetDrawColor( Color(0,0,0) );
                surface.DrawRect( 0, 0, w, h );
            
				rpui.GetPaintStyle( this16, STYLE_GOLDEN );
			
                local distsize  = math.sqrt( w*w + h*h );
            
                local parentalpha = this16.Base.GetAlpha(this16.Base) / 255;
                local alphamult   = this16._alpha / 255;
            
                surface.SetAlphaMultiplier( parentalpha * alphamult );
                    surface.SetDrawColor( RainbowColor );
                    surface.DrawRect( 0, 0, w, h );
            
                    surface.SetMaterial( rpui.GradientMat );
                    surface.SetDrawColor( RainbowRotate );
                    surface.DrawTexturedRectRotated( w * 0.5, h * 0.5, distsize, distsize, (this16.rotAngle or 0) );
            
                    draw.SimpleText( this16:GetText(), "rpui.Fonts.DonateMenu.MenuButtonBigBold", w * 0.5, h * 0.5, rpui.UIColors.Black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                surface.SetAlphaMultiplier( parentalpha * (1 - alphamult) );
                    draw.SimpleText( this16:GetText(), "rpui.Fonts.DonateMenu.MenuButtonBigBold", w * 0.5, h * 0.5, RainbowColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                surface.SetAlphaMultiplier( 1 );
            
                return true
            end,
			
            MenuPaintOver = function( this17, w, h )
                if this17.Base.GetAlpha(this17.Base) == 255 then
                    rpui.DrawStencilBorder( this17, 0, 10, w, h, 0.06, RainbowColor, RainbowRotate );
                end
            end,
			
			FrameCreation = function( this, w, h, menu_btn )
				local self = rpui.DonateMenu
				
				this:Dock(FILL)
				this:DockMargin(0, 0, 0, self.RMDepositBtn.GetTall(self.RMDepositBtn) + self.innerPadding * (self.DiscountNotifier.IsVisible(self.DiscountNotifier) and 1 or 2) + self.DiscountNotifier.GetTall(self.DiscountNotifier))
				
				-- PARENT
				this.p = vgui.Create( "DPanel", this );
				local p = this.p
				p:Dock(FILL)
				p.Paint = function() end
				p.selected = 1
				p.cur_selected = p.selected
				
				
				-- HEADER
				local header_tall = math.floor(self.MenuContainer.GetTall(self.MenuContainer) / #self.Categories) - self.innerPadding * 3
				
				local header_pnl = vgui.Create( "DPanel", p );
				header_pnl.Paint = function() end
				header_pnl:Dock(TOP)
				
				local header_pnl_pan = vgui.Create( "DPanel", header_pnl );
				header_pnl_pan:SetSize(math.ceil(w * 0.67), header_tall)
				header_pnl_pan:SetPos(w - header_pnl_pan:GetWide(), 0)
				header_pnl_pan.Paint = function( th, ww, hh )
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

						draw.SimpleText( translates.Get('URF CASE'), 'rpui.Fonts.DonateMenu.MenuButtonBigBold2', ww - hh * 0.7, hh * 0.5, rpui.UIColors.White, TEXT_ALIGN_RIGHT, TEXT_ALIGN_CENTER );
					surface.SetAlphaMultiplier( 1 );

					return true
				end
				
				header_pnl:SetTall(header_tall)
				
				
				-- HEADER BUTTONS
				local hbtn_wide = math.floor((w - header_pnl_pan:GetWide() - self.innerPadding * 4) * 0.5)
				local selected_menu = 1
				local select_case_menu
				
				local hbtn_1 = vgui.Create( "DButton", header_pnl );
				hbtn_1:SetSize(hbtn_wide, header_tall)
				hbtn_1.Paint = function( this, wt1, ht1 )
					this._alpha = math.Approach( this._alpha or 0, ((this:IsHovered() or selected_menu == 1) and 255 or 146), 768 * FrameTime() );
                    surface.SetDrawColor( Color( 0, 0, 0, this._alpha ) );
                    surface.DrawRect( 0, 0, wt1, ht1 );
                    draw.SimpleText( translates.Get("КЕЙСЫ"), 'rpui.Fonts.DonateMenu.ItemButtonBold', wt1 * 0.5, ht1 * 0.5, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end
				hbtn_1.DoClick = function()
					select_case_menu(1)
				end
				
				local hbtn_2 = vgui.Create( "DButton", header_pnl );
				hbtn_2:SetPos(hbtn_wide + self.innerPadding * 2, 0)
				hbtn_2:SetSize(hbtn_wide, header_tall)
				hbtn_2.Paint = function( this, wt2, ht2 )        
					this._alpha = math.Approach( this._alpha or 0, ((this:IsHovered() or selected_menu == 2) and 255 or 146), 768 * FrameTime() );
                    surface.SetDrawColor( Color( 0, 0, 0, this._alpha ) );
                    surface.DrawRect( 0, 0, wt2, ht2 );
                    draw.SimpleText( translates.Get("МОИ КЕЙСЫ"), 'rpui.Fonts.DonateMenu.ItemButtonBold', wt2 * 0.5, ht2 * 0.5, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
                    return true
                end
				hbtn_2.DoClick = function()
					select_case_menu(2)
				end
				
				
				-- MAIN SCROLL
				local scroll_pnl_handler = vgui.Create( "DPanel", p );
				scroll_pnl_handler.Paint = function() end
				scroll_pnl_handler:Dock(FILL)
				scroll_pnl_handler:DockMargin(0, self.innerPadding * 2, 0, 0)
				
				-- SCROLL SHOP
				local scroll_pnl = vgui.Create( "rpui.ScrollPanel", scroll_pnl_handler );
				scroll_pnl:Dock(FILL)
				scroll_pnl.SetSpacingY(scroll_pnl, 0)
				scroll_pnl.SetScrollbarMargin(scroll_pnl, 0)
				
				scroll_pnl.OnMouseWheeled = function(this1, dt)
					this1.ySpeed = this1.ySpeed + dt * 2
				end
				scroll_pnl.InvalidateParent(scroll_pnl, true)
				scroll_pnl.AlwaysLayout(scroll_pnl, true)
				
				-- SCROLL INV
				local scroll_pnl2 = vgui.Create( "rpui.ScrollPanel", scroll_pnl_handler );
				scroll_pnl2:Dock(FILL)
				scroll_pnl2.SetSpacingY(scroll_pnl2, 0)
				scroll_pnl2.SetScrollbarMargin(scroll_pnl2, 0)
				
				scroll_pnl2.OnMouseWheeled = function(this1, dt)
					this1.ySpeed = this1.ySpeed + dt * 2
				end
				scroll_pnl2.InvalidateParent(scroll_pnl, true)
				scroll_pnl2.AlwaysLayout(scroll_pnl, true)
				
				scroll_pnl2:SetVisible(false)
				
				
				local can = scroll_pnl:GetCanvas();
				local can2 = scroll_pnl2:GetCanvas();
				
				local size_multer_w = math.floor(w * 0.95)
				local size_multer_h = math.floor(size_multer_w * 0.36)
				local dm_bgc = Color(0, 0, 0, 150)
				
				local selector_mat = Material('premium/new_selector')
				local margined = false
				local bought_offset = 0
				
				local is_black = true
				local is_round = true
				
				local rarity_items = {1, 14, 20, 60}
				local rarity_colors = {
					[60] = {Color(170, 200, 235), Color(80, 110, 145)},
					[20] = {Color(76, 204, 89), Color(0, 102, 0)},
					[14] = {Color(151, 78, 210), Color(61, 0, 120)},
					[1] = {Color(240, 181, 25), Color(254, 121, 4)},
				}
				
				local function draw_RoundedPoly(ths, start_x, start_y, poly_w, poly_h)
					if not ths.poly_pts then
						local radius = 15
						local steps = 5
								
						local pi = math.pi
						local step = pi / (steps - 1) / 2
						local cur_pi = pi
						
						local corners = {
							{ start_x + radius, start_y + radius },
							{ start_x + poly_w - radius, start_y + start_y + radius },
							{ start_x + poly_w - radius, start_y + poly_h - radius },
							{ start_x + radius, start_y + poly_h - radius },
						}
						
						ths.poly_pts = {}
						
						for i = 1, 4 do
							for j = 0, steps - 1 do
								table.insert(ths.poly_pts, {
									x = math.Round(corners[i][1] + radius * math.cos(cur_pi + j * step)),
									y = math.Round(corners[i][2] + radius * math.sin(cur_pi + j * step)),
								})
							end
							
							cur_pi = cur_pi + pi / 2
						end
					end
					
					surface.DrawPoly(ths.poly_pts)
				end
				
				local actual_id = 0
				
				for n_id, lb_data in pairs(rp.lootbox.All) do
					if lb_data.hidden then continue end
					actual_id = actual_id + 1
					
					local lb_panel = vgui.Create('DPanel')
					scroll_pnl:AddItem(lb_panel)
					lb_panel:Dock(TOP)
					lb_panel:DockMargin(0, margined and self.innerPadding * 2 or 0, self.innerPadding * 2, 0)
					lb_panel:SetHeight(size_multer_h)
					lb_panel.Paint = function(_, dpw, dph)
						surface.SetDrawColor(dm_bgc)
						surface.DrawRect(0, 0, dpw, dph)
						
						surface.SetDrawColor(lb_data.color)
						surface.SetMaterial(selector_mat)
						surface.DrawTexturedRect(0.09 * dpw, 0.075 * dph, 0.15 * dpw, 0.66 * dph)
					end
					
					local lb_item = vgui.Create("DModelPanel", lb_panel)
					lb_item.SetCursor( lb_item, "arrow" );
					lb_item.SetSize( lb_item, 0.25 * size_multer_w, size_multer_h * 2);
					lb_item.SetPos( lb_item,  0.045 * size_multer_w, -0.28 * size_multer_h);
					lb_item.SetModel( lb_item, Model(lb_data.model) );
					
					if lb_data.skin then
						lb_item.SetSkin( lb_item, lb_data.skin );
					end
					
					if not lb_item.off_mass then
						--local off_mass_low, off_mass_top = lb_item.Entity.GetModelBounds(lb_item.Entity)
						--lb_item.off_mass = (off_mass_top.z - off_mass_low.z) / 40
						lb_item.off_mass = 1 + lb_item.Entity.GetModelRadius(lb_item.Entity) / 77
						lb_item.Entity.SetModelScale(lb_item.Entity, 1 / lb_item.off_mass)
					end
					
					--lb_item.SetZPos( lb_item, -200 );
					lb_item.SetFOV( lb_item, 58 );
					lb_item.lb_panel = lb_panel
					lb_item.xVelocity     = 0;
					lb_item.xOffset       = 0;
					lb_item.yVelocity     = 0;
					lb_item.ZoomingVector = Vector(0, 0, 0);
					lb_item.LayoutEntity = function() end
					lb_item.actual_id = actual_id
					lb_item.Think = function( this1 )
						local maxOffset = math.max( 0, can:GetTall() - scroll_pnl:GetTall() );
						local tar_pos = (lb_item.actual_id - 1) * (size_multer_h + self.innerPadding)
						local cur_ratio = (tar_pos - scroll_pnl.yOffset) / maxOffset
						
						local cur_x_1, cur_y_1 = lb_item.lb_panel.CursorPos(lb_item.lb_panel)
						--cur_y_1 = cur_y_1 - cur_ratio * 1500 - 0.28 * size_multer_h
						local inrange = (cur_x_1 > 0 and cur_x_1 < lb_item.lb_panel.GetWide(lb_item.lb_panel)) and (cur_y_1 > 0 and cur_y_1 < size_multer_h)
						this1.angle_rat = (this1.angle_rat or 0) + (inrange and 0.5 or 0)
						
						local cur_ang = Angle( 0, this1.angle_rat, 0 )
						cur_ang:RotateAroundAxis(Vector(1, -1, 0), cur_ratio * 150 - 20)
						
						this1.Entity.SetAngles( this1.Entity, cur_ang );
						this1.Entity.SetPos( this1.Entity, Vector(-cur_ratio * 10, -cur_ratio * 10, 60 - cur_ratio * 450) );
						this1.SetAlpha( this1, scroll_pnl:GetAlpha() > 240 and 255 or 0 );
						if lb_data.skin then
							this1.Entity.SetSkin( this1.Entity, lb_data.skin )
						end
						
						this1:SetPos(0.045 * size_multer_w, -0.28 * size_multer_h - cur_ratio * 1500)
					end
					
					local dbtn = vgui.Create('DButton', lb_panel)
					dbtn:SetSize( (0.158 + 0.06) * size_multer_w, size_multer_h - size_multer_h * 0.075 * 2.8 - 0.6 * size_multer_h)
					dbtn:SetPos( 0.06 * size_multer_w, 0.075 * size_multer_h * 1.85 + 0.6 * size_multer_h)
					dbtn:SetText(lb_data.price and (lb_data.price .. ' ' .. translates.Get("РУБ")) or translates.Get('ЗАБРАТЬ'))
					dbtn.Paint = function(this15, wt3, ht3)
						if is_round then
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
							surface.SetDrawColor(rpui.UIColors.White)
							draw_RoundedPoly(this15, 0, -20, wt3, ht3 + 20)

							render.SetStencilCompareFunction( STENCIL_EQUAL );
							render.SetStencilFailOperation( STENCIL_KEEP );
						end
						
						flagged = false
						
						if lb_data.cooldown_time then
							local cds = LocalPlayer():GetNetVar('LootboxCooldowns') or {}
							
							if cds[lb_data.NID] and tonumber(cds[lb_data.NID]) > os.time() then
								local time_t = string.FormattedTime(tonumber(cds[lb_data.NID]) - os.time())
								dbtn:SetText(string.format('%02i', time_t.h) .. ':' .. string.format('%02i', time_t.m) .. ':' .. string.format('%02i', time_t.s))
								
								flagged = true
							end
						end
						
						if not flagged and lb_data.needed_time and LocalPlayer():GetTodayPlaytime() < lb_data.needed_time then
							local time_t = string.FormattedTime(lb_data.needed_time - LocalPlayer():GetTodayPlaytime())
							dbtn:SetText(string.format('%02i', time_t.h) .. ':' .. string.format('%02i', time_t.m) .. ':' .. string.format('%02i', time_t.s))
						end
						
						if dbtn.AcceptTime and dbtn.AcceptTime < CurTime() then
							dbtn.AcceptTime = nil
							dbtn:SetText(lb_data.price and (lb_data.price .. ' ' .. translates.Get("РУБ")) or translates.Get('ЗАБРАТЬ'))
						end
						
						this15.rotAngle = (this15.rotAngle or 0) + 100 * FrameTime();
						
						surface.SetDrawColor( Color(0,0,0) );
						surface.DrawRect( 0, 0, wt3, ht3 );
					
						rpui.GetPaintStyle( this15, STYLE_GOLDEN );
					
						local distsize  = math.sqrt( wt3*wt3 + ht3*ht3 );
					
						local parentalpha = scroll_pnl.GetAlpha(scroll_pnl) / 255;
						
						local bs = rpui.PowOfTwo(ht3 * 0.03);
						
						surface.SetDrawColor( RainbowColor );
						surface.DrawRect( 0, 0, wt3, ht3 );
					
						surface.SetMaterial( rpui.GradientMat );
						surface.SetDrawColor( RainbowRotate );
						surface.DrawTexturedRectRotated( wt3 * 0.5, ht3 * 0.5, distsize, distsize, (this15.rotAngle or 0) );
						
						surface.SetDrawColor(ColorAlpha(rpui.UIColors.Black, 255 - (flagged and 255 or this15._alpha) * 0.5))
						surface.DrawRect( bs, bs, wt3 - bs * 2, math.ceil(ht3 * 0.57) );
						
						draw.SimpleText(dbtn:GetText(), "rpui.Fonts.DonateMenu.MenuButtonBigBold3", wt3 * 0.5, ht3 * 0.275, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
						
						draw.SimpleText( utf8.upper(lb_data.name), "rpui.Fonts.DonateMenu.DonateStats", wt3 * 0.5, ht3 * 0.78, ColorAlpha(rpui.UIColors.White, scroll_pnl.GetAlpha(scroll_pnl)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
						
						if is_round then
							render.SetStencilEnable( false );
						end
						
						return true
					end
					dbtn.DoClick = function()
						if dbtn:GetText() == translates.Get("ЗАГРУЖАЕМ...") then
							return
						end
						 
						if lb_data.price and LocalPlayer():GetCredits() < lb_data.price then
							rpui.DonateMenu.Header.Balance.DoClick(rpui.DonateMenu.Header.Balance)
							return
						end
						
						if dbtn:GetText() == translates.Get("ПОДТВЕРДИТЕ") then
							net.Start('Donate::BuyCase')
							net.WriteUInt(n_id, 8)
							net.SendToServer()
							
							rp.bought_case = n_id
							dbtn:SetText(translates.Get("ЗАГРУЖАЕМ..."))
							
							if not lb_data.price then
								timer.Simple(0.5, function()
									RunConsoleCommand('say', '/upgrades')
								end)
							end
							
						else
							if lb_data.cooldown_time then
								local cds = LocalPlayer():GetNetVar('LootboxCooldowns') or {}
								
								if cds[lb_data.NID] and tonumber(cds[lb_data.NID]) > os.time() then
									return
								end
							end
							
							if lb_data.needed_time and LocalPlayer():GetTodayPlaytime() < lb_data.needed_time then
								return
							end
							
							dbtn:SetText(translates.Get("ПОДТВЕРДИТЕ"))
							dbtn.AcceptTime = CurTime() + 3
						end
					end
					
					local rows_x = dbtn:GetPos()
					local rows_w = math.ceil(0.177 * size_multer_w) * 3 + self.innerPadding * 4
					local rows_h = math.ceil(0.39 * size_multer_h) * 2 + self.innerPadding * 2
					
					rows_x = rows_x * 2 + dbtn:GetWide()
				
					for item_id, dummy in pairs(lb_data.items) do
						local item_data = lb_data.items[#lb_data.items - item_id + 1]
						local this_colors
						local chance = item_data.chance
						
						if item_data.colors then
							this_colors = item_data.colors
							
						else
							for _, rc_data in pairs(rarity_items) do
								chance = chance - rc_data
								
								if chance <= 0 then
									this_colors = rarity_colors[rc_data]
									break
								end
							end
							
							if not this_colors then
								this_colors = rarity_colors[60]
							end
						end
						
						local dbtn3 = vgui.Create('DButton', lb_panel)
						dbtn3:SetSize(math.ceil(0.177 * size_multer_w), math.ceil(math.ceil(0.39 * size_multer_h) * 0.3))
						dbtn3:SetPos((size_multer_w - rows_x - rows_w) / 2 + rows_x + (dbtn3:GetWide() + self.innerPadding * 2) * ((item_id - 1) % 3), (size_multer_h - rows_h) / 2 + (math.ceil(0.39 * size_multer_h) + self.innerPadding * 2) * math.floor((item_id - 1) / 3) + math.ceil(math.ceil(0.39 * size_multer_h) * 0.7))
						dbtn3.SetCursor( dbtn3, "arrow" );
						dbtn3:SetText('')
						dbtn3.Paint = function(this19, tpw1, tph1)
							if is_round then
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
								surface.SetDrawColor(rpui.UIColors.White)
								draw_RoundedPoly(this19, 0, -20, tpw1, tph1 + 20)

								render.SetStencilCompareFunction( STENCIL_EQUAL );
								render.SetStencilFailOperation( STENCIL_KEEP );
							end
							
							this19.rotAngle = (this19.rotAngle or 0) + 100 * FrameTime();
						
							surface.SetDrawColor( Color(0,0,0) );
							surface.DrawRect( 0, 0, tpw1, tph1 );
						
							rpui.GetPaintStyle( this19, STYLE_GOLDEN );
						
							local distsize  = math.sqrt( tpw1*tpw1 + tph1*tph1 + 2 );
						
							local parentalpha = scroll_pnl.GetAlpha(scroll_pnl) / 255;
							local alphamult   = 1;
						
							surface.SetAlphaMultiplier( parentalpha * alphamult );
								surface.SetDrawColor( this_colors[1] );
								surface.DrawRect( 0, 0, tpw1, tph1 );
						
								surface.SetMaterial( rpui.GradientMat );
								surface.SetDrawColor( this_colors[2] );
								surface.DrawTexturedRectRotated( tpw1 * 0.5, tph1 * 0.5, distsize, distsize, (this19.rotAngle or 0) );
							surface.SetAlphaMultiplier( 1 );
							
							if is_round then
								render.SetStencilEnable( false );
							end
						end
						
						local dbtn41
						local dbtn2 = vgui.Create('DButton', lb_panel)
						dbtn2:SetSize(math.ceil(0.177 * size_multer_w), math.ceil(0.39 * size_multer_h))
						dbtn2:SetPos((size_multer_w - rows_x - rows_w) / 2 + rows_x + (dbtn2:GetWide() + self.innerPadding * 2) * ((item_id - 1) % 3), (size_multer_h - rows_h) / 2 + (dbtn2:GetTall() + self.innerPadding * 2) * math.floor((item_id - 1) / 3))
						dbtn2.SetCursor( dbtn2, "arrow" );
						dbtn2:SetText('')
						
						dbtn2.Paint = function(this18, tpw, tph)
							if is_round then
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
								surface.SetDrawColor(rpui.UIColors.White)
								draw_RoundedPoly(this18, 0, 0, tpw, tph)

								render.SetStencilCompareFunction( STENCIL_EQUAL );
								render.SetStencilFailOperation( STENCIL_KEEP );
							end
							
							surface.SetDrawColor(dm_bgc)
							surface.DrawRect(0, 0, tpw, math.ceil(tph * 0.7))
							
							surface.SetDrawColor(Color(255, 255, 255, 240))
							surface.SetMaterial(item_data.icon)
							surface.DrawTexturedRect(tpw * 0.5 - tph * 0.25, tph * 0.15, tph * 0.5, tph * 0.5)
							
							draw.SimpleText(utf8.upper(item_data.name), "rpui.Fonts.DonateMenu.DonateStats", tpw * 0.5, tph * 0.85, ColorAlpha(rpui.UIColors.White, scroll_pnl.GetAlpha(scroll_pnl)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							
							this18._talpha = math.Approach(this18._talpha or 0, (dbtn2:IsHovered() or dbtn41:IsHovered()) and 100 or 0, 768 * FrameTime())
							
							if is_round then
								render.SetStencilEnable( false );
							end
						end
						
						dbtn41 = vgui.Create('DPanel', dbtn2)
						dbtn41:SetSize(math.ceil(0.177 * size_multer_w), math.ceil(math.ceil(0.39 * size_multer_h) * (is_black and 0.65*1 or 0.7)))
						dbtn41:SetPos(0, 0)
						
						local already_has = item_data.calc_check and (not item_data.calc_check(LocalPlayer())) or false
						
						dbtn41.Paint = function(this18, tpw, tph)
							if is_round then
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
								surface.SetDrawColor(rpui.UIColors.White)
								draw_RoundedPoly(this18, 0, 0, tpw, tph + 20)
								
								render.SetStencilCompareFunction( STENCIL_EQUAL );
								render.SetStencilFailOperation( STENCIL_KEEP );
							end
							
							if (dbtn2._talpha or 0) > 1 then
								
								if is_black then
									draw.Blur(dbtn41)
								end
								
								surface.SetDrawColor(ColorAlpha(is_black and dm_bgc or Color(255, 255, 255), dbtn2._talpha * (is_black and 1 or 2)))
								surface.DrawRect(0, 0, tpw, tph)
								
								
								if not this18.WrappedText then
									surface.SetFont('rpui.Fonts.DonateMenu.DonateStats')
									local tW, tH = surface.GetTextSize(" ");

									this18.WrappedText = string.Wrap( 'rpui.Fonts.DonateMenu.DonateStats', item_data.description, tpw - self.innerPadding * 4 );

									this18.TextHeight        = tH;
									this18.WrappedTextHeight = #this18.WrappedText * tH;
								end
								
								draw.SimpleText(already_has and translates.Get("Получено") or translates.Get("Получи"), "rpui.Fonts.DonateMenu.ItemButton", tpw * 0.5, tph * 0.5 - this18.WrappedTextHeight * 0.5, ColorAlpha(is_black and rpui.UIColors.White or rpui.UIColors.Black, dbtn2._talpha * (is_black and 2.35*1 or 2.55)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								
								for k91, text91 in ipairs( this18.WrappedText ) do
								   -- draw.SimpleText( text9, this18:GetFont(), w * 0.5, h * 0.5 - this18.WrappedTextHeight * 0.5 + (k9-1) * this18.TextHeight, textColor, TEXT_ALIGN_CENTER )
									draw.SimpleText(utf8.upper(text91), "rpui.Fonts.DonateMenu.DonateStats", tpw * 0.5, tph * 0.5 - this18.WrappedTextHeight * 0.5 + (k91) * this18.TextHeight, ColorAlpha(is_black and rpui.UIColors.White or rpui.UIColors.Black, dbtn2._talpha * (is_black and 2.35*1 or 2.55)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								end
								
								--draw.SimpleText(utf8.upper(item_data.description), "rpui.Fonts.DonateMenu.DonateStats", tpw * 0.5, tph * 0.56, ColorAlpha(is_black and rpui.UIColors.White or rpui.UIColors.Black, dbtn2._talpha * (is_black and 2.35 or 2.55)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								
								if item_data.chance_desc and not already_has then
									draw.SimpleText(item_data.chance_desc, "rpui.Fonts.DonateMenu.StatusTriangle", tpw * 0.5, tph * 0.9, ColorAlpha(is_black and rpui.UIColors.White or rpui.UIColors.Black, dbtn2._talpha * (is_black and 2 or 2.55)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
								end
							end
							
							if already_has then
								local ts = 0.45 * tph
								
								if not this18.StatusTriangle then
									this18.StatusTriangle = {
										{ x = tpw - ts, y = 0,  u = 0, v = 0 },
										{ x = tpw,      y = 0,  u = 1, v = 0 },
										{ x = tpw,      y = ts, u = 1, v = 1 }
									}
								end
								
								draw.NoTexture()
								surface.SetDrawColor( rpui.UIColors.BackgroundDonateBuyed )
								surface.DrawPoly( this18.StatusTriangle )

								surface.SetMaterial( rpui.GradientDownMat )
								surface.SetDrawColor( rpui.UIColors.DonateBuyed )
								surface.DrawPoly( this18.StatusTriangle )

								draw.SimpleText( "✔", "rpui.Fonts.DonateMenu.DonateStatsSmall", tpw - ts * 0.3, ts * 0.3, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
							end
							
							if is_round then
								render.SetStencilEnable( false );
							end
						end
					end
					
					if rp.bought_case and rp.bought_case == n_id then
						local thanks = vgui.Create('DPanel', lb_panel)
						thanks:SetSize(rows_w * 1.1, rows_h * 1.1)
						thanks:SetPos((size_multer_w - rows_x - rows_w) / 2 + rows_x - rows_w * 0.05, size_multer_h / 2 - rows_h * 0.55)
						
						local remove_at = CurTime() + 3
						
						thanks.Paint = function(_, ddpw, ddph)
							draw.Blur(thanks)
							
							thanks._t_alpha = math.Approach(thanks._t_alpha or 255, (CurTime() > remove_at and 0 or 255), FrameTime() * 768)
							
							surface.SetDrawColor(0, 0, 0, thanks._t_alpha * 0.7)
							surface.DrawRect(ddpw / 2 - ddpw * 0.43, ddph / 2 - ddph * 0.24, ddpw * 0.86, ddph * 0.48)
							
							draw.SimpleText(translates.Get("СПАСИБО ЗА ПОКУПКУ!"), "rpui.Fonts.DonateMenu.MenuButtonBigBold3", ddpw * 0.5, ddph * 0.45, Color(255, 255, 255, thanks._t_alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							draw.SimpleText(translates.Get("КЕЙС ДОБАВЛЕН В \"МОИ КЕЙСЫ\""), "rpui.Fonts.DonateMenu.MenuButtonBigBold3", ddpw * 0.5, ddph * 0.55, Color(255, 255, 255, thanks._t_alpha), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
							
							if thanks._t_alpha < 1 then
								thanks:Remove()
							end
						end
						
						bought_offset = (actual_id - 1) * (size_multer_h + self.innerPadding)
						rp.bought_case = false
					end
					
					margined = true
				end
				
				local cases = LocalPlayer():GetLootboxes()
				local cases_count = table.Count(cases)
				
				if cases_count == 0 then
					local dummy2 = vgui.Create('DPanel')
					scroll_pnl2:AddItem(dummy2)
					dummy2:Dock(TOP)
					dummy2:DockMargin(0, 0, self.innerPadding * 2, 0)
					dummy2:SetHeight(size_multer_h)
					dummy2.Paint = function(_, dpw, dph)
						surface.SetDrawColor(0, 0, 0, 178)
						surface.DrawRect(dpw / 2 - dpw * 0.43, dph / 2 - dph * 0.24, dpw * 0.86, dph * 0.48)
						
						draw.SimpleText(translates.Get("ПРЕОБРЕСТИ КЕЙС"), "rpui.Fonts.DonateMenu.MenuButtonBigBold3", dpw * 0.5, dph * 0.45, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						draw.SimpleText(translates.Get("МОЖНО ВО ВКЛАДКЕ \"КЕЙСЫ\""), "rpui.Fonts.DonateMenu.MenuButtonBigBold3", dpw * 0.5, dph * 0.55, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
					end
				
				else
					local dummy2 = vgui.Create('DPanel')
					scroll_pnl2:AddItem(dummy2)
					dummy2:Dock(TOP)
					dummy2:DockMargin(0, 0, self.innerPadding * 2, 0)
					dummy2:SetHeight(math.ceil(cases_count / 4) * (size_multer_h + self.innerPadding))
					dummy2.Paint = function(_, dpw, dph)
						surface.SetDrawColor(dm_bgc)
						surface.DrawRect(0, 0, dpw, dph)
						
						local ctr2 = 0
						local real_ctr2
						
						for caseid, casedata in pairs(cases) do
							local lbdata = rp.lootbox.Map[casedata.id]
							real_ctr2 = cases_count - ctr2 - 1
							
							surface.SetDrawColor(lbdata.color)
							surface.SetMaterial(selector_mat)
							surface.DrawTexturedRect((real_ctr2 % 4) * size_multer_w / 4 + 0.09 * dpw - self.innerPadding * 3.3, math.floor(real_ctr2 / 4) * (size_multer_h + self.innerPadding) + 0.075 * size_multer_h, 0.15 * dpw, 0.66 * size_multer_h)
							
							ctr2 = ctr2 + 1
						end
					end
					
					local ctr = 0
					for case_id, case_data in pairs(cases) do
						local lb_item = vgui.Create("DModelPanel", dummy2)
						local lb_data = rp.lootbox.Map[case_data.id]
						if not lb_data then
							continue;
						end

						local real_ctr = cases_count - ctr - 1
						--print(real_ctr)
						local off_x = (real_ctr % 4) * size_multer_w / 4 - 3.3 * self.innerPadding
						local off_y = math.floor(real_ctr / 4) * (size_multer_h + self.innerPadding)
						ctr = ctr + 1
						
						lb_item.SetCursor( lb_item, "arrow" );
						lb_item.SetSize( lb_item, 0.25 * size_multer_w, size_multer_h * 2);
						lb_item.SetPos( lb_item,  off_x + 0.045 * size_multer_w, off_y + -0.28 * size_multer_h);
						lb_item.SetModel( lb_item, Model(lb_data.model) );
						
						if lb_data.skin then
							lb_item.SetSkin( lb_item, lb_data.skin );
						end
						
						if not lb_item.off_mass then
							--local off_mass_low, off_mass_top = lb_item.Entity.GetModelBounds(lb_item.Entity)
							--print("==============")
							--print(off_mass_low, off_mass_top)
							--print(lb_item.Entity:GetModelRenderBounds())
							--print(lb_item.Entity:GetModelRadius())
							--lb_item.off_mass = 1 + (off_mass_top.z - off_mass_low.z - 41) / 30
							lb_item.off_mass = 1 + lb_item.Entity.GetModelRadius(lb_item.Entity) / 77
							
							lb_item.Entity.SetModelScale(lb_item.Entity, 1 / lb_item.off_mass)
						end
						
						--lb_item.SetZPos( lb_item, -200 );
						lb_item.actual_id = math.floor(real_ctr / 4)
						lb_item.off_x = off_x
						lb_item.off_y = off_y
						lb_item.SetFOV( lb_item, 58 );
						lb_item.xVelocity     = 0;
						lb_item.xOffset       = 0;
						lb_item.yVelocity     = 0;
						lb_item.ZoomingVector = Vector(0, 0, 0);
						lb_item.LayoutEntity = function() end
						lb_item.Think = function( this1 )
							--this1.Entity.SetAngles( this1.Entity, Angle( 0, CurTime() * 11.5, 0 ) );
							--this1.Entity.SetPos( this1.Entity, Vector(0, 0, 11) );
							--this1.SetAlpha( this1, scroll_pnl2:GetAlpha() > 240 and 255 or 0 );
							--if lb_data.skin then
							--	this1.Entity.SetSkin( this1.Entity, lb_data.skin )
							--end
							
							local maxOffset = math.max( 1, scroll_pnl2:GetTall() );
							local tar_pos = this1.actual_id * (size_multer_h + self.innerPadding)
							local cur_ratio = math.Clamp((tar_pos - scroll_pnl2.yOffset) / (maxOffset or 1), -2, 2)
							
							local cur_x_2, cur_y_2 = lb_item:CursorPos()
							cur_y_2 = cur_y_2 - cur_ratio * 1500 - 0.28 * size_multer_h
							local inrange = (cur_x_2 > 0 and cur_x_2 < 0.25 * size_multer_w) and (cur_y_2 > 0 and cur_y_2 < size_multer_h)
							this1.angle_rat = (this1.angle_rat or 0) + (inrange and 0.5 or 0)
							
							local cur_ang = Angle( 0, this1.angle_rat, 0 )
							cur_ang:RotateAroundAxis(Vector(1, -1, 0), cur_ratio * 170 / (this1.off_mass * 3) - 20)
							
							this1.Entity.SetAngles( this1.Entity, cur_ang );
							this1.Entity.SetPos( this1.Entity, Vector(-cur_ratio * 15, -cur_ratio * 15, 60 - cur_ratio * 480 / (this1.off_mass * 3)) );
							this1.SetAlpha( this1, scroll_pnl2:GetAlpha() > 240 and 255 or 0 );
							
							--this1.Entity.SetPos(this1.Entity, Vector(0, 0, 50 - cur_ratio * 1600))
							--this1:SetCamPos(Vector(100, 100, 50 - cur_ratio * 1250))
							--this1:SetLookAt(Vector(0, 0, -cur_ratio * 1450))
							
							if lb_data.skin then
								this1.Entity.SetSkin( this1.Entity, lb_data.skin )
							end
							
							this1:SetPos(this1.off_x + 0.045 * size_multer_w, this1.off_y + -0.28 * size_multer_h - cur_ratio * 1500 / (this1.off_mass * 3))
						end
					end
					
					ctr = 0
					for case_id, case_data in pairs(cases) do
						local lb_item = vgui.Create("DModelPanel", dummy2)
						local lb_data = rp.lootbox.Map[case_data.id]
						
						local real_ctr = cases_count - ctr - 1
						--print(real_ctr)
						local off_x = (real_ctr % 4) * size_multer_w / 4 - 3.3 * self.innerPadding
						local off_y = math.floor(real_ctr / 4) * (size_multer_h + self.innerPadding)
						ctr = ctr + 1
						
						local dbtn = vgui.Create('DButton', dummy2)
						dbtn:SetSize( (0.158 + 0.06) * size_multer_w, size_multer_h - size_multer_h * 0.075 * 2.8 - 0.6 * size_multer_h)
						dbtn:SetPos( off_x + 0.06 * size_multer_w, off_y + 0.075 * size_multer_h * 1.85 + 0.6 * size_multer_h)
						dbtn:SetText(case_data.spawned and translates.Get("ОТКРЫВАЕМ...") or translates.Get("ОТКРЫТЬ"))
						dbtn.Paint = function(this15, wt5, ht5)
							if is_round then
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
								surface.SetDrawColor(rpui.UIColors.White)
								draw_RoundedPoly(this15, 0, -20, wt5, ht5 + 20)

								render.SetStencilCompareFunction( STENCIL_EQUAL );
								render.SetStencilFailOperation( STENCIL_KEEP );
							end
							
							this15.rotAngle = (this15.rotAngle or 0) + 100 * FrameTime();
							
							surface.SetDrawColor( Color(0,0,0) );
							surface.DrawRect( 0, 0, wt5, ht5 );
						
							rpui.GetPaintStyle( this15, STYLE_GOLDEN );
						
							local distsize  = math.sqrt( wt5*wt5 + ht5*ht5 );
						
							--local parentalpha = scroll_pnl2.GetAlpha(scroll_pnl2) / 255;
							local alphamult   = case_data.spawned and 1 or this15._alpha / 255;
							
							local bs = rpui.PowOfTwo(ht5 * 0.03);
							
							surface.SetDrawColor( RainbowColor );
							surface.DrawRect( 0, 0, wt5, ht5 );
						
							surface.SetMaterial( rpui.GradientMat );
							surface.SetDrawColor( RainbowRotate );
							surface.DrawTexturedRectRotated( wt5 * 0.5, ht5 * 0.5, distsize, distsize, (this15.rotAngle or 0) );
							
							surface.SetDrawColor(ColorAlpha(rpui.UIColors.Black, 255 - alphamult * 255 * 0.5))
							surface.DrawRect( bs, bs, wt5 - bs * 2, math.ceil(ht5 * 0.57) );
							
							if dbtn.AcceptTime and dbtn.AcceptTime < CurTime() then
								dbtn.AcceptTime = nil
								dbtn:SetText(translates.Get("ОТКРЫТЬ"))
							end
							
							draw.SimpleText( dbtn:GetText(), "rpui.Fonts.DonateMenu.MenuButtonBigBold3", wt5 * 0.5, ht5 * 0.275, rpui.UIColors.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
							
							draw.SimpleText( utf8.upper(lb_data.name), "rpui.Fonts.DonateMenu.DonateStats", wt5 * 0.5, ht5 * 0.78, ColorAlpha(rpui.UIColors.White, scroll_pnl2.GetAlpha(scroll_pnl2)), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
							
							if is_round then
								render.SetStencilEnable( false );
							end
							
							return true
						end
						dbtn.DoClick = function()
							if not case_data.spawned and dbtn:GetText() ~= translates.Get("СОЗДАЁМ...") then
								if dbtn:GetText() == translates.Get("ПОДТВЕРДИТЕ") then
									net.Start('Donate::OpenCase')
									net.WriteUInt(case_id, 32)
									net.SendToServer()
									
									rpui.DonateMenu:Close()
									dbtn:SetText(translates.Get("СОЗДАЁМ..."))
									
								else
									dbtn:SetText(translates.Get("ПОДТВЕРДИТЕ"))
									dbtn.AcceptTime = CurTime() + 3
								end
							end
						end
					end
				end
				
				timer.Simple(0, function()
					if (IsValid(scroll_pnl)) then scroll_pnl:InvalidateLayout() end
					if (IsValid(scroll_pnl2)) then scroll_pnl2:InvalidateLayout() end
					
					if bought_offset and bought_offset > 0 then
						timer.Simple(0.5, function()
							if (IsValid(scroll_pnl)) then
								scroll_pnl:SetOffset(bought_offset)
							end
						end)
					end
				end)
				
				select_case_menu = function(menu_mode)
					if menu_mode == selected_menu then return end
					
					selected_menu = menu_mode
					
					scroll_pnl:SetVisible(true)
					scroll_pnl2:SetVisible(true)
					
					if menu_mode == 1 then
						scroll_pnl2:SetAlpha(255)
						scroll_pnl:SetAlpha(0)
						
						scroll_pnl2:AlphaTo(0, 0.2, 0, function()
							scroll_pnl2:SetVisible(false)
							scroll_pnl:AlphaTo(255, 0.2, 0)
						end)
						
					else
						scroll_pnl:SetAlpha(255)
						scroll_pnl2:SetAlpha(0)
						
						scroll_pnl:AlphaTo(0, 0.2, 0, function()
							scroll_pnl:SetVisible(false)
							scroll_pnl2:AlphaTo(255, 0.2, 0)
						end)
					end
				end
			end,
			
			FrameOpen = function() end,
			TopsInvisible = true,
			TitleInvisible = true,
		}
