local fr, offsetX, offsetY, panelW, panelH

function rp.DrawF4Content()
	local w, h = ScrW() * 0.75, ScrH() * 0.7

	return ui.Create('ui_frame', function(self)
		self:SetTitle('Меню Сервера')
		self:SetSize(w, h)
		self:MakePopup()
		self:Center()
		local keydown = false

		function self:Think()
			if input.IsKeyDown(KEY_F4) and keydown then
				if self.tabs.DidntPressAnything then
					--net.Start('rp.CheckMenuStatistics')
					--	net.WriteString('Действия')
					--net.SendToServer()
				end
				
				self:Close()
			elseif (not input.IsKeyDown(KEY_F4)) then
				keydown = true
			end
		end
		
	end), 2, 30, w, h
end

function GM:_oldShowSpare2()
	if IsValid(fr) then
		fr:SetVisible(false)
	end

	local time_bonus = LocalPlayer():GetTimeMultiplayer() + rp.GetTimeMultiplier()
	
	fr, offsetX, offsetY, panelW, panelH = rp.DrawF4Content()

	if time_bonus > 0 then
		local time_btn = ui.Create('DButton', fr)
			--time_btn:SetSize(0, 30)
			--time_btn:DockMargin(0, 3, 0, 0)
			--time_btn:Dock( BOTTOM )
			time_btn:SetPos(offsetX, offsetY + panelH - 63)
			time_btn:SetSize(panelW, 30)
			
			time_btn.text 		= 'Получение времени увеличено на ' .. math.floor(time_bonus * 100) .. '%!'
			time_btn.time_until = rp.GetTimeMultiplierRemain()
			
			time_btn.Paint = function(_, w, h)
				time_btn:SetColor(rp.col.White)
				surface.SetDrawColor(HSVToColor(360, 0.8 - math.sin(CurTime() * 2) * 0.1, 1))
				surface.DrawRect(0, 0, w, h)
			end
			
			time_btn.Think = function()
				local lasts = time_btn.time_until - os.time()
				local tb = string.FormattedTime((lasts > 0) and lasts or 0)
				
				time_btn:SetText(time_btn.text .. ' Осталось ' .. string.format("%02i:%02i:%02i", tb['h'], tb['m'], tb['s']))
				
				if(lasts <= 0) then 
					time_btn:SetText(time_btn.text)
				end
			end
			
			time_btn.DoClick = function()
			end
	end

	local tabs = ui.Create('ui_tablist', fr)
	tabs.Paint = function() end 
	tabs:SetPos(offsetX, offsetY)
	tabs:SetSize(panelW, panelH - (time_bonus > 0 and 66 or 36))
	--tabs._yoffset = time_bonus > 0 and 38 or nil
	--tabs:DockToFrame()
	
	
	fr.tabs = tabs
	--tabs.DidntPressAnything = true
	--tabs.CheckStatistics = true
	
	
	-- Commands
	tabs:AddTab('Действия', ui.Create('rp_commandlist'), true)
	-- Jobs
	--tabs:AddTab('Профессии', ui.Create('rp_jobslist'))
	
	--Crafting
	if not rp.cfg.DisableCores['inventory'] then
		tabs:AddTab('Магазин', ui.Create('rp_shoplist_inventory'))

		local CraftingContainer = vgui.Create( "DPanel", fr );
		CraftingContainer:Dock( FILL );
		CraftingContainer:InvalidateParent( true );
		tabs:AddTab('Инвентарь', CraftingContainer);
		hook.Run("rp.OpenCrafting",CraftingContainer)
	else
		-- Shop
		tabs:AddTab('Магазин', ui.Create('rp_shoplist'))
	end
	
	hook.Call('PopulateF4Tabs', GAMEMODE, tabs, fr) -- todo, remove
	-- Settings
	local s = ui.Create('ui_settingspanel')
	s:SetState('All')
	s:SetSize(fr:GetWide() - 165, fr:GetTall() - 35)
	tabs:AddTab('Настройки', s)

	-- Справочник
	tabs:AddButton('Справочник', function(self)
		if IsValid(self.panel) then return self.panel:Close() end
		local x, y = self:GetPos()
		self.panel = ui.Create('DPanel', function(panel, p)
			panel:SetPos(x, y+34)
			panel:SetSize(self:GetWide(), 0)
			for k,v in pairs(rp.cfg.MoTD) do
				ui.Create('DButton', function(button)
					button:SetPos(0, (k-1)*24)
					button:SetSize(panel:GetWide(), 25)
					button:SetText(v[1])
					button:SetFont('ui.24')
					button:SetTextColor(ui.col.White)
					button.DoClick = function()
						gui.OpenURL(v[2])
						panel:Close()
					end
				end, panel)
				panel.Tall = (panel.Tall || 0)+24
			end
			panel.Close = function(self)
				self:SizeTo(self:GetWide(),0,0.15,0,-1,function()
					self:Remove()
				end)
			end
			panel:SizeTo(panel:GetWide(),panel.Tall,0.15)
		end, tabs)

		self.Think = function()
			if !self:IsHovered() && IsValid(self.panel) && !self.panel:IsHovered() && !self.panel:IsChildHovered(2) then
				if self.panel.IsClose then return end
				self.panel.IsClose = true
				self.panel:Close()
			end
		end
	end)

	if rp.GetDiscount() == 0 then
		tabs:AddButton('Донат', function()
			fr:Close()
			rp.RunCommand('upgrades')
		end)
	else
		tabs:AddButton('Донат (-' .. rp.GetDiscount() * 100 ..'%)', function()
			fr:Close()
			rp.RunCommand('upgrades')
		end)
	end

end

function rp.GetF4Menu()
	return fr
end