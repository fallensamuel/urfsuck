--VAPE SWEP \//\ by Swamp Onions - http://steamcommunity.com/id/swamponions/

AddCSLuaFile ("cl_init.lua")
AddCSLuaFile ("shared.lua")
include ("shared.lua")

util.AddNetworkString("VapeStart")
util.AddNetworkString("VapeEnd")

SWEP.HoldDelay = 1
SWEP.NextPowerIncrease = 0

SWEP.Power = 0
SWEP.Delay = 0.1
SWEP.MaxPower = 50

function SWEP:Deploy()
	self.canChangeColor = self.Owner:GetUpgradeCount('perma_vape') > 1
	if self.canChangeColor then
		self:CallOnClient('SetCanChangeColor')
	end
	self:SetHoldType("slam")
end

function SWEP:Think()
	if self.Hold then
		if self.Owner:KeyDown(IN_ATTACK) then
			if self.NextPowerIncrease < CurTime() then
				self.Power = self.Power + 1
				self.NextPowerIncrease = CurTime() + self.Delay
				if !self.MaxPower || self.Power > self.MaxPower then
					self:OnRelease()
				end
			end
		elseif self.Hold < CurTime() then
			self.Hold = false
			self:OnRelease()
		end
	elseif self.Owner:KeyDown(IN_ATTACK) && self.Weapon:GetNextPrimaryFire() < CurTime() then
		self.Weapon:SetNextPrimaryFire(CurTime() + 2 )
		self.Hold = CurTime() + self.HoldDelay
		self:OnHold()
	end
end

function SWEP:OnRelease()
	net.Start("VapeEnd")
		net.WriteEntity(self.Owner)
		net.WriteInt(self.Power,8)
	net.Broadcast()
	self.Hold = false
	self.Power = 0
end

function SWEP:OnHold()
	net.Start("VapeStart")
		net.WriteEntity(self.Owner)
	net.Broadcast()
end

function SWEP:Holster()
	if self.Hold then self:OnRelease() end
	return true
end

function SWEP:OnRemove()
	if self.Hold then self:OnRelease() end
end
