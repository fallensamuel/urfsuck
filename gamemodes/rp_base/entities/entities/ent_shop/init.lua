AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

util.AddNetworkString('ShopEnt::OpenShop')

--[[

Состояния удаления:
- Игрок вышел с сервера:
	- Удалить ентити
	- Не удалять инвентарь
	
- Ентити удалена, игрок на сервере:
	- Удалять инвентарь + возвращать предметы
	
- Сервер вылетел:
	- Ничего не делать

При заходе игрока:
Проверять, есть ли в базе инвентарь ent_shop с его айди. Если есть - удалять + возвращать предметы

]]

function ENT:Initialize()
	--self:SetModel("models/zerochain/props_vendingmachine/zvm_machine.mdl") 
	self:SetUseType(SIMPLE_USE)
	self:SetModel("models/props_canteen/vendingmachine01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	
	--self:SetMoveType(MOVETYPE_NONE)
	--self:SetCollisionGroup(COLLISION_GROUP_NONE)
	
	
	--self:DropToFloor()
	--self:SetURL('https://i.imgur.com/SQVrd7a.png')
	
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
	
	--FixInvalidPhysicsObject(self)
	
	timer.Simple(0, function()
		if not IsValid(self:GetOwnerPly()) then return end
		
		self:SetHeader('[E] Открыть магазин')
		
		rp.item.newInv(self:GetOwnerPly():SteamID64(), 'ent_shop', 5, 5, function(inventory)
			inventory.entity = self
			inventory.vars.isBag = self.itemTable.uniqueID
			
			self.itemTable:setData("id", inventory:getID())
			self.invTable = inventory
			
			self:SetInvID(inventory:getID())
		end)
	end)
end

local function returnPlayerItems(ply, invId, cback)
	local inv = ply:getInv()
	if not inv then return end
	
	rp._Stats:Query("SELECT * FROM `items` WHERE `_invID` = ?;", invId, function(items)
		local j = 0
		
		local function proceed_items()
			j = j + 1
			
			if items[j] then
				local item_data = items[j]._data and util.JSONToTable(items[j]._data) or {}
				local count = item_data.count or 1
				
				item_data.count = nil
				inv:add(items[j]._uniqueID, count, item_data, nil, nil, nil, true, function()
					proceed_items()
				end)
			else
				rp._Stats:Query("DELETE FROM `items` WHERE `_invID` = ?;", invId, function()
					rp._Stats:Query("DELETE FROM `inventories` WHERE `_invID` = ?;", invId, function()
						if cback then
							cback()
						end
					end)
				end)
			end
		end
						
		proceed_items()
	end)
end

function ENT:RemoveInventory()
	if not self.Removing and self.invTable then 
		self.Removing = true
		
		returnPlayerItems(self:GetOwnerPly(), self.invTable:getID())
	end
end

function ENT:OnRemove()
	if IsValid(self:GetOwnerPly()) then
		self:RemoveInventory()
	end
end

util.AddNetworkString('ShopEnt::OpenBag')
util.AddNetworkString('ShopEnt::ChangeImage')
util.AddNetworkString('ShopEnt::ChangeText')

net.Receive('ShopEnt::OpenBag', function(_, ply)
	local self = Entity(net.ReadUInt(16) or -1)
	
	if not IsValid(self) or not (self.GetOwnerPly and IsValid(self:GetOwnerPly()) and self:GetOwnerPly() == ply) then return end
	
	local index = self.itemTable:getData("id")
	netstream.Start(ply, "rpOpenBag", index, true)
end)

net.Receive('ShopEnt::ChangeImage', function(_, ply)
	local self = Entity(net.ReadUInt(16) or -1)
	
	if not IsValid(self) or not (self.GetOwnerPly and IsValid(self:GetOwnerPly()) and self:GetOwnerPly() == ply) then return end
	
	self:SetURL(net.ReadString() or 'https://i.imgur.com/SQVrd7a.png')
end)

net.Receive('ShopEnt::ChangeText', function(_, ply)
	local self = Entity(net.ReadUInt(16) or -1)
	
	if not IsValid(self) or not (self.GetOwnerPly and IsValid(self:GetOwnerPly()) and self:GetOwnerPly() == ply) then return end
	
	local str = net.ReadString()
	local len = utf8.len(str)
	
	if len < 2 or len > 64 then return end
	
	self:SetHeader(str)
end)

function ENT:Use(ply)
	if self.LastUsed and self.LastUsed > CurTime() then return end
	self.LastUsed = CurTime() + 1
	
	if not IsValid(self:GetOwnerPly()) then return end
	
	if ply == self:GetOwnerPly() then
		--local index = self.itemTable:getData("id")
		--netstream.Start(ply, "rpOpenBag", index, true)
		
	else
		local inv = rp.item.inventories[self:GetInvID() or -1]
		if not inv then return end
		
		local items = inv:getItems(true)
		
		--net.Start("VendorNpc_OpenMenu")
		net.Start("ShopEnt::OpenShop")
			net.WriteInt(self:EntIndex(), 32)
			--net.WriteBool(false)
			
			net.WriteUInt(table.Count(items), 16)
			
			for k, v in pairs(items) do
				-- Write:
				-- uniqueID, price, amount
				
				net.WriteString(v.uniqueID)
				net.WriteUInt(v:getData('price') or 500, 32)
				net.WriteUInt(v:getData('count') or 1, 12)
				
			end
		net.Send(ply)
	end
end

hook.Add('PlayerDisconnected', 'ShopEnt::PlayerDisconnected', function(ply)
	for k, v in pairs(ents.FindByClass('ent_shop')) do
		if v:GetOwnerPly() == ply then
			v.Removing = true
			v:Remove()
		end
	end
end)

hook.Add('PlayerInventoryLoaded', 'ShopEnt::PlayerInventoryLoaded', function(ply)
	timer.Simple(2, function()
		local inv = ply:getInv()
		if not inv then return end
		
		rp._Stats:Query("SELECT `_invID` FROM `inventories` WHERE `_charID` = ? AND _invType = 'ent_shop';", ply:SteamID64(), function(data)
			if #data == 0 then return end
			
			local i = 0
			
			local function proceed()
				i = i + 1
				
				if data[i] then
					returnPlayerItems(ply, data[i]._invID, function()
						proceed()
					end)
				else
					rp.Notify(ply, NOTIFY_GENERIC, 'Помещённые в магазин предметы восстановлены.')
				end
			end
			
			proceed()
		end)
	end)
end)


util.AddNetworkString('ShopEnt::BuyItem')

net.Receive('ShopEnt::BuyItem', function(_, ply)
	local item_dt 		= net.ReadString() or 'nil'
	local ent_shop 		= Entity(net.ReadUInt(16) or -1)
	local item_amount	= net.ReadUInt(8)
	
	item_dt = rp.item.list[item_dt] or rp.item.base[item_dt]
	
	if item_dt and IsValid(ent_shop) and ent_shop:GetClass() == 'ent_shop' and ply:GetPos():DistToSqr(ent_shop:GetPos()) < 250000 then
		local inv 		= ent_shop.invTable
		local new_inv 	= ply:getInv()
		local item 		= inv:hasItem(item_dt.uniqueID)
		
		if not item or not new_inv then return end
		
		local price = item:getData('price') * item_amount
		
		if ply:GetMoney() >= price and item:getCount() >= item_amount then
			new_inv:add(item_dt.uniqueID, item_amount, {}, nil, nil, nil, nil, function(failed)
				if failed then return end
				
				rp.Notify(ply, NOTIFY_GREEN, rp.Term("Vendor_bought"), item_amount, item.name, rp.FormatMoney(price))
				ply:AddMoney(-price)
				
				ent_shop:GetOwnerPly():AddMoney(price)
				rp.Notify(ent_shop:GetOwnerPly(), NOTIFY_GREEN, rp.Term('EntShop::Bought'), ply:Name(), item_amount, item.name, rp.FormatMoney(price))
				
				if item:getCount() > item_amount then
					item:addCount(-item_amount)
				else
					item:remove()
				end
				
				ent_shop:EmitSound("item_buy.wav")
			end)
		end
	end
end)




