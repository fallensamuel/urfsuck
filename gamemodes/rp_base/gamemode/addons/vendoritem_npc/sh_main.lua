rp.VendorItemsNPCS = {}

----------------------------------------- M E T A -----------------------------------------
local VendorMETA = {Name = "None", Items = {}, Model = "models/Barney.mdl", Sequence = "idle_all_01", Bodygroups = {}}

function VendorMETA:SetName(name)
	self.Name = name
	return self
end

function VendorMETA:AddBuyItem(uid, price)
	self.Items[uid] = price
	return self
end

function VendorMETA:SetPriceItem(uid, icon)
	self.PriceItem = uid
	self.PriceItemIcon = icon
	return self
end

function VendorMETA:SetModel(mdl)
	self.Model = mdl
	return self
end

function VendorMETA:SetPos(x, y, z)
	self.Pos = isvector(x) and x or Vector(x, y, z)
	return self
end

function VendorMETA:SetAngles(x, y, z)
	self.Angles = isangle(x) and x or Angle(x, y, z)
	return self
end

function VendorMETA:SetSkin(skin)
	self.Skin = skin
	return self
end

function VendorMETA:SetBodygroup(k, v)
	self.Bodygroups[k] = v
	return self
end

function VendorMETA:SetSequence(uid)
	self.Sequence = uid
	return self
end

function VendorMETA:SetCustomCheck(func, errterm)
	self.CustomCheck = func
	self.notAllowedTerm = errterm
	return self
end

function VendorMETA:SetJobCheck(...)
	local check = {}
	for i, v in pairs({...}) do
		check[v] = true
	end
	
	self:SetCustomCheck(function(ply, ent)
		return check[ply:Team()]
	end)

	return self
end

function VendorMETA:SetFactionCheck(...)
	local check = {}
	for i, v in pairs({...}) do
		check[v] = true
	end
	
	self:SetCustomCheck(function(ply, ent)
		return check[ply:GetFaction()]
	end)

	return self
end

function VendorMETA:SetPriceSmall(str)
	self.PriceSmall = str
	return self
end

function VendorMETA:SetPriceName(str)
	self.PriceName = str
	return self
end

function VendorMETA:SetFindInfo(str)
	self.FindInfo = str
	return self
end

----------------------------------------- M E T A -----------------------------------------

function rp.AddItemVendor(name)
	local already
	for k, v in pairs(rp.VendorItemsNPCS) do
		if v.Name == name then
			already = true
			if IsValid(v.ent) then v.ent:Remove() end
			table.remove(rp.VendorItemsNPCS, k)
			break
		end
	end

	local index = table.insert(rp.VendorItemsNPCS, table.Copy(VendorMETA))
	local obj = rp.VendorItemsNPCS[index]:SetName(name)

	if SERVER and already and rp.AlreadyInitPostEntity then
		timer.Simple(1, function()
			rp.RespawnItemVendor(index, obj)
		end)
	end

	return obj
end



-- EXAMPLE:
--[[
rp.AddItemVendor("Игорь")
:SetModel("models/eli.mdl")
:SetPos(1037, 2248, -377)
:SetAngles(0, -15, 0)
:SetSkin(1)
:SetBodygroup(1, 2)
:SetSequence("citizen2_stand")
:SetPriceItem("olives", 'rpui/misc/3d.png') -- Итем за который можно будет купить другие предметы (uid и иконка)
:AddBuyItem("egg", 2) -- 1 яйцо за 2 огурчика
:AddBuyItem("cheese", 1) -- 1 сыр за 1 огурчик
:AddBuyItem("swb_ak74", 10) -- 1 калаш за 10 огурчиков
:SetPriceSmall("олив") -- отобржается в меню
:SetPriceName("оливок") -- отобржается в меню
:SetFindInfo("Ищи оливки в продуктовом!")

-- Кастомчеки:
--:SetJobCheck(TEAM_CITIZEN, TEAM_POLICE, TEAM_ADMIN)
--:SetFactionCheck(FACTION_CITIZEN, FACTION_POLICE)
:SetCustomCheck(function(ply, ent) return ply:IsRoot() end)
-- Используйте SetJobCheck или SetFactionCheck или SetCustomCheck, если вам нужно больше возможностей
]]--