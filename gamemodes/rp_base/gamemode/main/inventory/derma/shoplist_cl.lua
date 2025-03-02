-- "gamemodes\\rp_base\\gamemode\\main\\inventory\\derma\\shoplist_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PANEL = {}

function PANEL:Init()
	local cat
	self.Cats = {}
	self.List = ui.Create('ui_listview', self)
	self.List.Paint = function() end
	cat = ui.Create('rp_shopcatagory')

	for k, v in ipairs(rp.ammoTypes) do
		if not v.price then 
			continue
		end
		if (not self.Cats['Патроны']) then
			self.List:AddSpacer('Патроны'):SetTall(25)
			self.Cats['Патроны'] = true
			cat = ui.Create('rp_shopcatagory')
		end
		cat:AddItem(v.model, v.name, v.price, function()
			local t = table.Copy(v);
			t.customCheck = nil;
			net.Start("rp.ShopBuyItem")
				net.WriteTable(t)
			net.SendToServer()
		end, v.unlockTime)
	end
	self.List:AddItem(cat)
	
	cat = ui.Create('rp_shopcatagory')
	for k, v in ipairs(rp.item.shop.foods) do
		if table.Count(v.allowed) > 0 and (v.allowed[LocalPlayer():Team()] ~= true) then
			continue
		end
		if v.customCheck and v.customCheck(LocalPlayer()) ~= true then
			continue
		end
		if not v.price then 
			continue
		end
		if (not self.Cats['Еда']) then
			self.List:AddSpacer('Еда'):SetTall(25)
			self.Cats['Еда'] = true
			cat = ui.Create('rp_shopcatagory')
		end
		cat:AddItem(v.model, v.name, v.price, function()
			net.Start("rp.ShopBuyItem")
				net.WriteTable(v)
			net.SendToServer()
		end, v.unlockTime)
	end
	self.List:AddItem(cat)

	for k, v in ipairs(rp.item.shop.shipments) do
		if table.Count(v.allowed) > 0 and (v.allowed[LocalPlayer():Team()] ~= true) then
			continue
		end
		if v.customCheck and v.customCheck(LocalPlayer()) ~= true then
			continue
		end
		if not v.price then 
			continue
		end
		if (not self.Cats['Ящики']) then
			self.List:AddSpacer('Ящики'):SetTall(25)
			self.Cats['Ящики'] = true
			cat = ui.Create('rp_shopcatagory')
		end

		cat:AddItem(v.model, v.name, v.price, function()
			net.Start("rp.ShopBuyItem")
				net.WriteTable(v)
			net.SendToServer()
		end, v.unlockTime)
	end
	self.List:AddItem(cat)

	for k, v in ipairs(rp.item.shop.weapons) do
		if table.Count(v.allowed) > 0 and (v.allowed[LocalPlayer():Team()] ~= true) then
			continue
		end
		if v.customCheck and v.customCheck(LocalPlayer()) ~= true then
			continue
		end
		if not v.price then 
			continue
		end
		
		if (not self.Cats['Оружие']) then
			self.List:AddSpacer('Оружие'):SetTall(25)
			self.Cats['Оружие'] = true
			cat = ui.Create('rp_shopcatagory')
		end

		cat:AddItem(v.model, v.name, v.price, function()
			net.Start("rp.ShopBuyItem")
				net.WriteTable(v)
			net.SendToServer()
		end, v.unlockTime)
	end
	self.List:AddItem(cat)

	for k, v in ipairs(rp.item.shop.entities) do
		if table.Count(v.allowed) > 0 and (v.allowed[LocalPlayer():Team()] ~= true) then
			continue
		end
		if v.customCheck and v.customCheck(LocalPlayer()) ~= true then
			continue
		end
		if not v.price then 
			continue
		end
		
		if (not self.Cats['Предметы']) then
			self.List:AddSpacer('Предметы'):SetTall(25)
			self.Cats['Предметы'] = true
			cat = ui.Create('rp_shopcatagory')
		end
		cat:AddItem(v.model, v.name, v.pricesep or v.price, function()
			if v.onlyEntity then
				rp.RunCommand(v.cmd:sub(2))
			else
				net.Start("rp.ShopBuyItem")
					net.WriteTable(v)
				net.SendToServer()
			end
		end, v.unlockTime)
	end
	self.List:AddItem(cat)
end

function PANEL:PerformLayout()
	self.List:SetPos(5, 5)
	self.List:SetSize(self:GetWide() - 10, self:GetTall() - 10)
end

vgui.Register('rp_shoplist_inventory', PANEL, 'Panel')