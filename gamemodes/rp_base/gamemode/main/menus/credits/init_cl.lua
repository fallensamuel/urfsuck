-- "gamemodes\\rp_base\\gamemode\\main\\menus\\credits\\init_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿local fr
local mat
local categoryCreationFuncs

local sale_button

local disabledWeps = {};

categoryCreationFuncs = {
	["Основное"] = function(upgrade, parent)		
		if (upgrade:GetIcon()) then
			categoryCreationFuncs["Оружие"](upgrade, parent)
			return
		end

		local text = string.Wrap('rp.ui.22', upgrade:GetDesc(), parent:GetWide() - 10)
		local y = (parent:GetTall() - (#text * 22)) * 0.5

		for k, v in pairs(text) do
			ui.Create('DLabel', function(self)
				self:SetText(v)
				self:SizeToContents()
				self:CenterHorizontal()
				self:SetPos(self.x, y)
				y = y + 22
			end, parent)
		end
	end,
	["Магия"] = function(upgrade, parent)
		if (not upgrade:GetIcon()) then
			categoryCreationFuncs["Основное"](upgrade, parent)

			return
		end

		local mdlpnl = ui.Create("DImage", function(self) -- TODO: FIX
			self:SetImage(upgrade:GetIcon())
			self:SetSize(171, 171)
			self:Center()
		end, parent)


		local text = string.Wrap('rp.ui.22', upgrade:GetDesc() or '', parent:GetWide() - 10)
		local y = (parent:GetTall() - (#text * 22)) - 50
	
		for k, v in pairs(text) do
			ui.Create('DLabel', function(self)
				self:SetText(v)
				self:SizeToContents()
				self:CenterHorizontal()
				self:SetPos(self.x, y)
				y = y + 22
			end, parent)
		end
		
	end,
	["Профессии"] = function(upgrade, parent)
		if (not upgrade:GetIcon()) then
			categoryCreationFuncs["Основное"](upgrade, parent)

			return
		end

		local mdlpnl = ui.Create("DModelPanel", function(self) -- TODO: FIX
			self:SetSize(parent:GetSize())
			self:Center()
			local nm = upgrade:GetName()

			self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
			self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )

			self:SetModel(upgrade:GetIcon())

			//if (nm == '.357 Magnum') then
			//	self:SetFOV(25)
			//	self:SetCamPos(Vector(10, -60, 15))
			//	self:SetLookAt(Vector(0, 45, -8))
			//elseif (nm == "Knife") then
			//	self:SetFOV(50)
			//	self:SetCamPos(Vector(0, 25, 10))
			//	self:SetLookAt(Vector(0, 0, 9))
			//elseif (nm == "Stunstick" or nm == "Crowbar") then
			//	self:SetFOV(85)
			//	self:SetCamPos(Vector(0, 25, 10))
			//	self:SetLookAt(Vector(0, 0, 0))
			//elseif (nm == '.357 Magnum') then
			//	self:SetFOV(40)
			//	self:SetCamPos(Vector(0, 25, 10))
			//	self:SetLookAt(Vector(0, 0, -2))
			//end
			if IsValid(self.Entity) then
				local size1, size2 = self.Entity:GetRenderBounds()
				local size = (-size1+size2):Length()
				self:SetFOV(25)
				self:SetCamPos(Vector(size*2,size*1,size*1))
				self:SetLookAt((size1+size2)/2)
			end

		end, parent)


		local text = string.Wrap('rp.ui.22', upgrade:GetDesc() or '', parent:GetWide() - 10)
		local y = (parent:GetTall() - (#text * 22)) - 50
	
		for k, v in pairs(text) do
			ui.Create('DLabel', function(self)
				self:SetText(v)
				self:SizeToContents()
				self:CenterHorizontal()
				self:SetPos(self.x, y)
				y = y + 22
			end, parent)
		end
		
	end,
	["Оружие"] = function(upgrade, parent)
			print('loading', upgrade:GetName())
		if (not upgrade:GetIcon()) then
			print('no icon for', upgrade:GetName())
			categoryCreationFuncs["Основное"](upgrade, parent)

			return
		end

		local mdlpnl = ui.Create("DModelPanel", function(self) -- TODO: FIX
			self:SetSize(parent:GetSize())
			self:Center()
			local nm = upgrade:GetName()

			self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
			self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )

			self:SetModel(upgrade:GetIcon())
			
			if IsValid(self.Entity) then
				if upgrade:GetMaterial() then
					self.Entity:SetMaterial(upgrade:GetMaterial())
				end
				
				local size1, size2 = self.Entity:GetRenderBounds()
				local size = (-size1+size2):Length()
				self:SetFOV(25)
				self:SetCamPos(Vector(size*2,size*1,size*1))
				self:SetLookAt((size1+size2)/2)
			end

		end, parent)


		local text = string.Wrap('rp.ui.22', upgrade:GetDesc() or '', parent:GetWide() - 10)

		for k, v in pairs(text) do
			ui.Create('DLabel', function(self)
				self:Dock( BOTTOM )
				self:InvalidateLayout( true )
				self:SetText( v )
				self:SetContentAlignment( 5 )
				self:SetZPos( 10 + #text - k );
			end, parent)
		end
	end,
	["Шапки"] = function(upgrade, parent)
		local prev = ui.Create('rp_playerpreview', function(self, p)
			self:SetPos(p:GetWide() * 0.175, 25)
			self:SetSize(p:GetWide() * 0.65, p:GetTall() - 20)
			self:SetFOV(25)
		end, parent)

		local hasHat
		local model

		for k, v in pairs(rp.hats.list) do
			if (v.name == upgrade:GetName()) then
				prev:SetHat(v.model)
				hasHat = table.HasValue(LocalPlayer():GetNetVar('HatData') or {}, v.model)
				model = v.model
				break
			end
		end

		if (hasHat) then
			ui.Create("DButton", function(self)
				self:SetText("Equip")
				self:SetSize(parent:GetWide() - 10, 25)
				self:SetPos(5, parent:GetTall() - 60)

				self.DoClick = function()
					if (self.Unequip) then
						rp.RunCommand('removehat')
					else
						rp.RunCommand('sethat', model)
					end
				end

				self.Think = function()
					if (LocalPlayer():GetHat() and LocalPlayer():GetHat() == model) then
						self:SetText("Unequip")
						self.Unequip = true
					else
						self:SetText("Equip")
						self.Unequip = false
					end
				end
			end, parent)
		end
	end,
	["Особые услуги"] = function(upgrade, parent)
		parent.lblName = ui.Create("DLabel", function(self)
			self:SetFont('rp.ui.28')
			self:SetText(upgrade:GetName())
			self:SizeToContents()
			self:CenterHorizontal()
			self:SetPos(self.x, 5)
		end, parent)

		local text = string.Wrap('rp.ui.22', upgrade:GetDesc(), parent:GetWide() - 10)
		local y = (parent:GetTall() - (#text * 22)) * 0.5

		for k, v in pairs(text) do
			ui.Create('DLabel', function(self)
				self:SetText(v)
				self:SizeToContents()
				self:CenterHorizontal()
				self:SetPos(self.x, y)
				y = y + 22
			end, parent)
		end

		parent.btnPurchase = ui.Create("DButton", function(self)
			self:SetText("Для покупки обратитесь к нашему консультанту")
			self:SetSize(0, 25)
			self:DockMargin(5, 5, 5, 5)
			self:Dock(BOTTOM)
			self.DoClick = function(s)
				gui.OpenURL(rp.cfg.ConsultUrl)
			end
		end, parent)
	end,
}

local function createUpgradeInfo(upgrade, note, disabled, parent)
	parent:Clear()

	if !upgrade:GetBuildInCategory() then
		disabled = LocalPlayer().donateInProgress or  disabled
		note     = LocalPlayer().donateInProgress and 'Обрабатывается покупка...' or note
		
		parent.btnPurchase = ui.Create("DButton", function(self)
			--self:SetText(disabled and "Покупка недоступна" or "Купить")
			self:SetText(disabled and (note ~= "Это у вас уже куплено!" and note ~= 'Обрабатывается покупка...' and "Пополнить баланс" or "Покупка недоступна") or "Купить")
			self:SetSize(0, 25)
			self:DockMargin(5, 5, 5, 5)
			self:Dock(BOTTOM)

			--[[
			local Cant = false;

			if (!upgrade:GetPrice(LocalPlayer()) or LocalPlayer():GetCredits() < (upgrade:GetPrice(LocalPlayer()))) then
				self:SetText('Пополнить баланс');
				self.DoClick = function(s)
					parent:GetParent():GetParent():GetParent().CreditsBtn:DoClick()
				end
				Cant = true;
			end
			]]

			--if (!Cant) then
				if (disabled) then
					self:SetDisabled(note == "Это у вас уже куплено!" or note == 'Обрабатывается покупка...')
					self.DoClick = function(s)
						parent:GetParent():GetParent():GetParent().CreditsBtn:DoClick()
					end
				else
					self.DoClick = function(s)
						if (not s.Timeout) then
							s.Timeout = SysTime()
							s:SetText("Подтвердите")
		
							return
						end
		
						rp.RunCommand('buyupgrade', tostring(upgrade:GetID()))
						s:SetText("Покупка..")
						fr.Category = upgrade:GetCat()
						fr.Upgrade = upgrade:GetUID()
		
						fr.Blocker = ui.Create("Panel", function(s)
							s:SetSize(fr:GetSize())
						end, fr)
		
						fr.btnClose:MoveToFront()
					end
				end
			--end
	
			self.Think = function(s)
				if (s.Timeout and SysTime() > s.Timeout + 3) then
					s:SetText("Купить")
					s.Timeout = nil
				end
	
				s:MoveToFront()
			end
		end, parent)

		if (upgrade.AltPrice) then
			parent.btnAltPurchase = ui.Create("DButton", function(self)
				self:SetText(disabled and (note ~= "Это у вас уже куплено!" and note ~= 'Обрабатывается покупка...' and "Пополнить баланс" or "Покупка недоступна") or "Купить за " .. rp.FormatMoney(upgrade.AltPrice))
				self:SetSize(0, 25)
				self:DockMargin(5, 5, 5, 5)
				self:Dock(BOTTOM)

				if (IsValid(parent.btnPurchase)) then 
					self:DockMargin(5, 0, 5, 5); 
					parent.btnPurchase:DockMargin(5, 0, 5, 5);
				else 
					self:DockMargin(5, 5, 5, 0); 
				end

				if (disabled and (note == "Это у вас уже куплено!" or note == "Пополнить баланс" or note == "Покупка недоступна")) then
                    self:Remove();
                elseif (LocalPlayer():GetMoney() < upgrade.AltPrice) then
                    self:SetText("Вам не хватает " .. rp.FormatMoney(upgrade.AltPrice - LocalPlayer():GetMoney()))
                    self:SetDisabled(true)
					self.DoClick = function(s)
						parent:GetParent():GetParent():GetParent().CreditsBtn:DoClick()
					end
				else
					self.DoClick = function(s)
						if (not s.Timeout) then
							s.Timeout = SysTime()
							s:SetText("Подтвердите")
		
							return
						end
		
						rp.RunCommand('altbuyupgrade', tostring(upgrade:GetID()))
						s:SetText("Покупка..")
						fr.Category = upgrade:GetCat()
						fr.Upgrade = upgrade:GetUID()
		
						fr.Blocker = ui.Create("Panel", function(s)
							s:SetSize(fr:GetSize())
						end, fr)
		
						fr.btnClose:MoveToFront()
					end
				end
		
				self.Think = function(s)
					if (s.Timeout and SysTime() > s.Timeout + 3) then
						s:SetText("Купить")
						s.Timeout = nil
					end
		
					s:MoveToFront()
				end
			end, parent)
		end

		if (upgrade:GetCat() == "Оружие") and (note == "Это у вас уже куплено!") then
			parent.btnDisable = ui.Create( "DButton", function( self )
				self:SetSize( 0, 25 );
				self:DockMargin( 5, 5, 5, 0 );
				self:Dock( BOTTOM );
				self:SetZPos( 1 );

				disabledWeps[upgrade:GetUID()] = disabledWeps[upgrade:GetUID()] or false;
				self:SetText( disabledWeps[upgrade:GetUID()] and "Включить выдачу оружия" or "Выключить выдачу оружия" );

				self.DoClick = function( s )
					if not s.Timeout then
						disabledWeps[upgrade:GetUID()] = !disabledWeps[upgrade:GetUID()];

						local pdata_disabledWeps = {};
						for wepclass, wep in pairs( disabledWeps ) do
							if wep then
								table.insert( pdata_disabledWeps, wepclass );
							end
						end
						LocalPlayer():SetPData( "urf_disableddonateweps_" .. util.CRC(game.GetIPAddress()), table.concat(pdata_disabledWeps,";") );

						s:SetEnabled( false );
						s.Timeout = SysTime();

						net.Start( "rp.CreditShop.DisableWeapon" );
							net.WriteString( upgrade:GetUID() );
							net.WriteBool( disabledWeps[upgrade:GetUID()] );
						net.SendToServer();

						s:SetText( disabledWeps[upgrade:GetUID()] and "Включить выдачу оружия" or "Выключить выдачу оружия" );
					end
				end

				self.Think = function( s )
					if s.Timeout and SysTime() > s.Timeout + 3 then
						s:SetEnabled( true );
						s.Timeout = nil;
					end
				end
			end, parent );
		end

		parent.lblName = ui.Create("DLabel", function(self)
			self:SetFont('rp.ui.28')
			self:SetText(upgrade:GetName())
			self:SizeToContents()
			self:CenterHorizontal()
			self:SetPos(self.x, 5)
		end, parent)
	
		parent.lblNote = ui.Create("DLabel", function(self)
			self:SetFont('rp.ui.22')
			self:SetText(note)
			self:SizeToContents()
			self:CenterHorizontal()
			self:SetPos(self.x, parent.lblName:GetTall() + 5)
	
			if (disabled) then
				self:SetTextColor(rp.col.Red)
			end
		end, parent)
	end

	timer.Simple(0.05, function()
		local creationFunc = categoryCreationFuncs[upgrade:GetCat()] or categoryCreationFuncs["Основное"]
		creationFunc(upgrade, parent)
	end)
end

local function createUpgradeSheet(category)
	local pnl = ui.Create('Panel', function(self)
		self:DockPadding(0, 5, 0, 0)
		self:Dock(FILL)
	end)

	local toClick

	pnl.Content = ui.Create('ui_panel', function(self)
		self:SetSize(math.max(ScrW() * 0.45, 740) * 0.6824, math.max(ScrH() * 0.58, 530) * 0.9018)
		self:DockMargin(0, 0, 0, 0)
		self:Dock(FILL)
	end, pnl)

	pnl.List = ui.Create('ui_listview', function(self)
		self.Paint = function(self, w, h)
			draw.OutlinedBox(0, self:GetCanvas().y, w, self:GetCanvas():GetTall(), ui.col.Black, ui.col.Outline)
		end

		self:SetSize(210, 0)
		self:DockMargin(0, 0, 5, 0)
		self:Dock(LEFT)

		for k, v in ipairs(category.Upgrades) do
			--if (not v.Price and not self.HasUnavailableTag) then
			--	self:AddRow("Недоступны:", true)
			--	self.HasUnavailableTag = true
			--end

			local btn = self:AddRow(v.Upgrade:GetName())

			--if (not v.Price) then
			--	btn:SetBackgroundColor(ui.col.ButtonRed)
			--end

			btn.ODC = btn.DoClick

			btn.DoClick = function(self)
				self:ODC()
				createUpgradeInfo(v.Upgrade, v.Price or v.Reason, v.Price == nil, pnl.Content)
			end

			if v.Upgrade.Cat == "Оружие" then
				btn.CancelMat  = Material("icon16/cancel.png"); 
				btn.OpacityClr = Color(255,255,255,200);

				btn.PaintOver = function( s, w, h )
					local hh = math.ceil(h/2);
					
					if disabledWeps[v.Upgrade.UID] then
						surface.SetDrawColor( s.OpacityClr );
						surface.SetMaterial( s.CancelMat );
						surface.DrawTexturedRect( w-hh-3, 3, hh, hh );
					end
				end
			end

			--btn.PaintOver = function(s, w, h)
			--	if (not v.Price) then
			--		surface.SetDrawColor(255, 50, 50, 50)
			--		surface.DrawRect(0, 0, w, h)
			--	end
			--end
			
			-------------- Sales --------------
			local sale = nw.GetGlobal('rp.shop.settings')
			
			if sale and v.Upgrade:GetUID() == sale.item then
				sale_button = {
					button = btn, 
					tab = category
				}
			end
			-----------------------------------

			if (not toClick) then
				toClick = (k + (self.HasUnavailableTag and 1 or 0))
			end

			if (fr.Upgrade and fr.Upgrade == v.Upgrade:GetUID()) then
				toClick = k
			end
		end
	end, pnl)

	if toClick and pnl.List.Rows[toClick] then
		pnl.List.Rows[toClick]:DoClick()
	end
	
	pnl.Content.Think = function(s)
		if (not s:IsVisible()) then return end

		if (SysTime() > fr.NextLine) then
			fr.NextLine = SysTime() + math.Rand(0, 0.15)

			for i = 1, math.random(math.Clamp(2000 - #fr.Lines, 0, 200)) do
				local beString = not fr.HasStr and math.random(5000) == fr.NextString

				if (beString) then
					local str = fr.Strings[math.random(#fr.Strings)]
					surface.SetFont('rp.ui.15')
					local tw = surface.GetTextSize(str)

					table.insert(fr.Lines, {
						w = tw,
						y = math.random(s:GetTall() - 15),
						st = SysTime(),
						spd = math.Rand(4, 6),
						str = str
					})

					s.NextString = math.random(5000)
					fr.HasStr = true
				else
					table.insert(fr.Lines, {
						w = math.random(50),
						y = math.random(s:GetTall()),
						st = SysTime(),
						spd = math.Rand(1, 2)
					})
				end
			end
		end
	end

	pnl.Content.Paint = function(s, w, h)
		local st = SysTime()
		surface.SetDrawColor(40, 40, 40)
		surface.DrawRect(0, 0, w, h)
		surface.SetFont('rp.ui.15')
		surface.SetTextColor(255, 255, 255, 150)
		surface.SetDrawColor(rp.col.SUP)

		for k, v in ipairs(fr.Lines) do
			local diff = (st - v.st) / v.spd
			local x = -v.w + (diff * (w + v.w))

			if (x > w) then
				table.insert(fr.ToDel, k)
			else
				if (v.str) then
					surface.SetTextPos(x, v.y)
					surface.DrawText(v.str)
				else
					surface.DrawLine(x, v.y, x + v.w, v.y)
				end
			end
		end

		surface.SetDrawColor(0, 0, 0, 245)
		surface.DrawRect(0, 0, w, h)
	end

	return pnl
end

net('rp.CreditShop', function()
	if (not mat) then
		wmat.Create('SUP70', {
			URL = 'http://funmania.myarena.ru/static/images/fm.jpg',
			W = 70,
			H = 70
		}, function(material)
			mat = material

			if (IsValid(fr)) then
				fr.StartSpin = SysTime()
			end
		end)
	end

	local cannotbuy = {}
	local canbuy = {}
	local categories = {}
	
	local count = net.ReadUInt(8)
	LocalPlayer().donateInProgress = net.ReadBool()
	
	for i = 1, count do
		if net.ReadBool() then
			canbuy[net.ReadUInt(8)] = net.ReadUInt(16)
		else
			cannotbuy[net.ReadUInt(8)] = net.ReadString()
		end
	end

	local cat_sale = categories[table.insert(categories, {
		Name = 'SALE',
		Color = Color(255, 0, 0),
		Icon = 'icon16/new.png',
		Tooltip = 'Новые скидки каждую неделю!',
		Upgrades = {}
	})]

	for k, v in pairs(canbuy) do
		local upg = rp.shop.GetTable()[k]
		if not upg then continue end

		if upg.Discount != 0 || rp.GetDiscount() != 0 then
			canbuy[k] = {
				Upgrade = upg,
				Price = v .. ' кредитов (скидка '.. math.floor((v) / (1 - (upg.Discount > rp.GetDiscount() && upg.Discount || rp.GetDiscount())) - (v)) ..' кредитов)',
				buyable = true
			}
		else
			canbuy[k] = {
				Upgrade = upg,
				Price = v .. ' кредитов',
				buyable = true
			}

			if (upg:GetAltPrice()) then
				canbuy[k].Price = canbuy[k].Price .. ' / ' .. rp.FormatMoney(upg:GetAltPrice());
			end
		end


		local cat

		if upg:GetDiscount() != 0 or upg:GetAltPrice() then
			table.insert(cat_sale.Upgrades, canbuy[k])
		end

		for k, v in ipairs(categories) do
			if (v.Name == upg:GetCat()) then
				cat = v
				break
			end
		end

		if upg:GetCat() != 'SALE' then
			cat = cat or categories[table.insert(categories, {
				Name = upg:GetCat(),
				Upgrades = {}
			})]
			table.insert(cat.Upgrades, canbuy[k])
		end
	end

	for k, v in pairs(cannotbuy) do
		local upg = rp.shop.GetTable()[k]
		if not upg then continue end

		cannotbuy[k] = {
			Upgrade = upg,
			Reason = v,
			Buyable = false
		}

		local cat

		for k, v in ipairs(categories) do
			if (v.Name == upg:GetCat()) then
				cat = v
				break
			end
		end

		if upg:GetDiscount() != 0 or upg:GetAltPrice() then
			table.insert(cat_sale.Upgrades, cannotbuy[k])
		end

		if upg:GetCat() != 'SALE' then
			cat = cat or categories[table.insert(categories, {
				Name = upg:GetCat(),
				Upgrades = {}
			})]
			table.insert(cat.Upgrades, cannotbuy[k])
		end
	end

	if (IsValid(fr)) then
		if fr.Blocker then fr.Blocker:Remove() end
		fr.PropertyList:Remove()
		fr.PropertyList = nil
	else
		fr = nil
	end

	fr = fr or ui.Create('ui_frame')
	fr:SetTitle("Кошелёк: " .. LocalPlayer():GetCredits() .. " Кредитов")
	fr:SetSize(math.max(ScrW() * 0.45, 740), math.max(ScrH() * 0.58, 530))
	fr:Center()
	fr:MakePopup()
	fr.StartSpin = SysTime()
	fr.NextLine = 0
	fr.NextString = 1
	fr.Lines = {}
	fr.ToDel = {}
	fr.Category = 'SALE'
	fr.Strings = {'Давай, нажми купить!', 'Купи меня, давай купи!', 'Ну чего ты ждешь? Давай покупай!', 'Я знаю ты хочешь ...'}

	fr.CreditsBtn = fr.CreditsBtn or ui.Create("DButton", function(self)
		self:SetText("Пополнить счёт")
		self:SetBackgroundColor(Color(0,200,0, 150))
	
		self.DoClick = function(s)
			LocalPlayer():ConCommand("upgrades")
			-- local donation = donations.get("points")

			-- local frame = vgui.Create( "DFrame" )
			-- frame:SetSize( 500, 100 )
			-- frame:SetTitle( "Пополнить счёт" )
			-- frame:SetDraggable( true )
			-- frame:MakePopup()
			-- frame:Center()

			-- local panel = vgui.Create("DPanel", frame)
			-- panel:SetSize( 200, 200 )
			-- panel:Center()
			-- panel:Dock(FILL)

			-- local slider = vgui.Create( "DNumSlider", panel )
			-- slider:DockMargin(5,5,5,5)
			-- slider:SetWide(490)
			-- slider:SetText("Выберите количество")
			-- slider:SetDecimals(0)
			-- slider:SetMax( 5000 )
			-- slider:SetMin(1)
			-- slider:Dock(TOP)
			-- slider.Label:SetColor(Color(0,0,0))

			-- local button = vgui.Create("DButton", panel)
			-- button:SetText("Выберите количество")
			-- button:Dock(TOP)
			-- button:SetDisabled(true)


			-- slider.OnValueChanged = function(s, val)
			-- 	local data = math.Round(val)
			-- 	button:SetDisabled(false)
			-- 	button:SetText("Купить ".. data.." кредитов за "..donation:priceFunc(LocalPlayer(), data).." Руб.")
			-- end

			-- slider:SetValue(300)

			-- function button:DoClick()
			-- 	if IsValid(frame) && IsValid(slider) then
			-- 		donations.getMethodByName('robokassa'):onClick(donation, nil, math.Round(slider:GetValue()))
			-- 		fr:Close()
			-- 		frame:Remove()
			-- 	end
			-- end
		end

		self:SizeToContents()
		self:SetSize(self:GetWide() + 10, fr.btnClose:GetTall())
		self:SetPos(fr.btnClose.x - self:GetWide() + 1, 0)
	end, fr)
	
	------------------- Discount -------------------
	local sale = nw.GetGlobal('rp.shop.settings')
	
	if rp.GetDiscount() > 0 and rp.GetDiscountTime() > os.time() then
		fr.DiscountPanel = ui.Create('DButton', fr)
			fr.DiscountPanel.time_until = rp.GetDiscountTime()
			fr.DiscountPanel.text = "Скидка " .. (rp.GetDiscount() * 100) .. "%!"
			
			fr.DiscountPanel:SetSize(fr:GetWide() - 6, 30)
			fr.DiscountPanel:SetPos(3, fr:GetTall() - 35)
			fr.DiscountPanel:SetText("")
			
			fr.DiscountPanel.Paint = function(_, w, h)
				fr.DiscountPanel:SetColor(rp.col.White)
				surface.SetDrawColor(HSVToColor(360, 0.8 - math.sin(CurTime() * 2) * 0.1, 1))
				surface.DrawRect(0, 0, w, h)
			end
			
			fr.DiscountPanel.Think = function()
				local lasts = fr.DiscountPanel.time_until - os.time()
				local tb = string.FormattedTime((lasts > 0) and lasts or 0)
				
				fr.DiscountPanel:SetText(fr.DiscountPanel.text .. ' Осталось ' .. string.format("%02i:%02i:%02i", tb['h'], tb['m'], tb['s']))
				
				if(lasts <= 0) then 
					rp.RunCommand("upgrades") 
					fr:Remove()
				end
			end
	elseif sale and sale.item and rp.shop.Mapping[sale.item] then
		local sale_btn = ui.Create('DButton', fr)
			sale_btn:SetSize(fr:GetWide() - 6, 30)
			sale_btn:SetPos(3, fr:GetTall() - 35)
			--sale_btn:SetText('Торопись! Только сегодня скидка на `' .. rp.shop.Mapping[sale.item].Name .. '`!')
			
			sale_btn.text 		= 'Торопись! Только сегодня скидка на ' .. rp.shop.Mapping[sale.item].Name .. '! Осталось'
			sale_btn.time_until	= math.ceil(os.time() / 86400) * 86400
			
			sale_btn.Paint = function(_, w, h)
				sale_btn:SetColor(rp.col.White)
				surface.SetDrawColor(HSVToColor(360, 0.8 - math.sin(CurTime() * 2) * 0.1, 1))
				surface.DrawRect(0, 0, w, h)
			end
			
			sale_btn.Think = function()
				local lasts = sale_btn.time_until - os.time()
				local tb = string.FormattedTime((lasts > 0) and lasts or 0)
				
				sale_btn:SetText(sale_btn.text .. ' ' .. string.format("%02i:%02i:%02i", tb['h'], tb['m'], tb['s']))
				
				if(lasts <= 0) then 
					rp.RunCommand("upgrades") 
					fr:Remove()
				end
			end
			
			sale_btn.DoClick = function()
				if not sale_button or not sale_button.tab then return end
				
				sale_button.tab:DoClick()
				
				timer.Simple(0, function()
					sale_button.button:DoClick()
				end)
			end
	end
	-----------------------------------------------
	
	fr.SkinPurchaseBtn = fr.SkinPurchaseBtn or ui.Create("DButton", function(self)
		self:SetText("Пополнить скинами")

		self.DoClick = function(s)
			fr:Close()
			net.Start("donations.buy")
				net.WriteString("points")
				net.WriteInt(donations.getMethodByName('skins').id, 8)
				net.WriteInt(0, 17)
			net.SendToServer()
		end
		
		self:SetBackgroundColor(Color(0,200,0, 150))
		self:SizeToContents()
		self:SetSize(self:GetWide() + 10, fr.btnClose:GetTall())
		self:SetPos(fr.CreditsBtn.x - self:GetWide() + 1, 0)
	end, fr)


	hook.Call('CreditsMenuOpened', nil, fr)

	fr.PropertyList = fr.PropertyList or ui.Create('ui_propertysheet', function(self)
		self.tabScroller.pnlCanvas.Paint = function() end
		self:Dock(FILL)
		self:DockMargin(0, -1, 0, (rp.GetDiscount() > 0 and rp.GetDiscountTime() > os.time() or sale and sale.item) and 35 or 0)
		self:DockPadding(5, 0, 5, 5)
		self:SetPadding(0)

		for k, v in ipairs(categories) do
			local dat = self:AddSheet(v.Name, createUpgradeSheet(v), v.Icon, false, false, v.Tooltip)
			--dat.Tab.ODC = dat.Tab.DoClick

			--dat.Tab.DoClick = function(s)
			--	if (self:GetActiveTab() == s) then return end
			--	s:ODC()
			--	fr.StartSpin = SysTime()
			--end

			if sale_button and v == sale_button.tab then
				sale_button.tab = dat.Tab
			end
			
			dat.Tab:SetFont('rp.ui.18')

			if (fr.Category and fr.Category == v.Name) then
				dat.Tab:DoClick()
			end
		end
	end, fr)

	fr.OT = fr.OT or fr.Think

	fr.Think = function(s)
		s:OT()

		for k, v in ipairs(s.ToDel or {}) do
			if (not s.Lines[v - (k - 1)]) then break end

			if (s.Lines[v - (k - 1)].str) then
				s.HasStr = nil
			end

			table.remove(s.Lines, v - (k - 1))
		end

		table.Empty(s.ToDel)
	end

	fr.OP = fr.OP or fr.Paint

	fr.Paint = function(s, w, h)
		s:OP(w, h)

		if (mat) then
			local diff = math.Clamp(SysTime() - s.StartSpin, 0, 1) * 1.57079632679
			local rot8 = math.sin(diff + math.pi) + 1
			surface.DisableClipping(true)
			surface.SetMaterial(mat)
			surface.DrawTexturedRectRotated(4, 4, 70, 70, rot8 * 360)
			surface.DisableClipping(false)
		end
	end
end)

hook.Add('rp.shop.daily', function(val)
	timer.Simple(1, function() 
		if not val.item or not rp.shop.Mapping[val.item] then return end
		rp.shop.Mapping[val.item]:SetDiscount(val.amount / 100)
	end)
end)

hook.Add('OnReloaded', function()
	local data = nw.GetGlobal('rp.shop.settings')
	if not data then return end
	hook.Call('rp.shop.daily', nil, data)
end)

hook.Add('OnEntityCreated', 'disabledWeps', function(ply)
	if ply == LocalPlayer() then
		local str_data = LocalPlayer():GetPData('urf_disableddonateweps_'..util.CRC(game.GetIPAddress()),"");
		if not str_data then return end
		
		local data = string.Explode(';', str_data)

		for _, wep in pairs(data) do
			disabledWeps[wep] = true
		end

		net.Start( "rp.CreditShop.DisableWeapon" );
			net.WriteString( table.concat(table.GetKeys(disabledWeps),";") );
		net.SendToServer();

		hook.Remove('OnEntityCreated', 'disabledWeps')
	end
end)