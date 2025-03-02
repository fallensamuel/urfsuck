AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")
ENT.RemoveOnJobChange = true

ENT.MinPrice = 200
ENT.MaxPrice = 350

function ENT:Initialize()
	self:SetModel("models/props_c17/TrapPropeller_Engine.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
	self.sparking = false
	self:Setprice(self.MinPrice)
	self:SetContent('swb_awp')
end

function ENT:PhysgunPickup(pl)
	return ((pl == self:Getowning_ent()) or false)
end

function ENT:PhysgunFreeze(pl)
	return true
end

function ENT:GetShipmentPlease()
	local CurContent = self:GetContent();
	for Index, Shipment in pairs(rp.item.shop.shipments) do
		if (Shipment.content == CurContent) then
			return Shipment or {}
		end
	end
	return {}
end

function ENT:Use(pl)
	if pl:IsBanned() or self.InUse then return end

	local owner = self:Getowning_ent()
	local price = self:Getprice()

	if pl:HasWeapon(self:GetShipmentPlease().content) then
		return
	end

	if ((pl ~= owner) and (not pl:CanAfford(price))) or ((pl == owner) and (not pl:CanAfford(self.MinPrice))) then
		pl:Notify(NOTIFY_ERROR, rp.Term('CannotAfford'))
	elseif (pl == owner) then
		pl:Notify(NOTIFY_GENERIC, rp.Term('BoughtGunProduction'), rp.FormatMoney(self.MinPrice))
		pl:TakeMoney(self.MinPrice)
		self.InUse = true
		self.sparking = true

		timer.Simple(1, function()
			self:CreateGun(pl)
		end)
	else
		local gain = price - self.MinPrice

		owner:Notify(NOTIFY_GENERIC, rp.Term('SoldGun'), rp.FormatMoney(gain))
		owner:AddMoney(gain)
		owner:AddKarma(1)

		pl:Notify(NOTIFY_GENERIC, rp.Term('BoughtGunProduction'), rp.FormatMoney(price))
		pl:TakeMoney(price)
		self.InUse = true
		self.sparking = true

		timer.Simple(1, function()
			self:CreateGun(pl)
		end)
	end
end

function ENT:CreateGun(pl)
	pl:Give(self:GetShipmentPlease().content)
	pl:SelectWeapon(self:GetShipmentPlease().content)
	self.InUse = false
	self.sparking = false
end

function ENT:Think()
	if self.sparking then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(1)
		effectdata:SetScale(1)
		effectdata:SetRadius(2)
		util.Effect("Sparks", effectdata)
	end
end

function ENT:OnRemove()
	timer.Destroy(self:EntIndex())
	local ply = self:Getowning_ent()
	if not IsValid(ply) then return end
end