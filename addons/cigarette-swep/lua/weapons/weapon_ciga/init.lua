SWEP.HoldDelay = 1
SWEP.NextPowerIncrease = 0

SWEP.Power = 0
SWEP.Delay = 0.1
SWEP.MaxPower = 50

AddCSLuaFile ("cl_init.lua")
AddCSLuaFile ("shared.lua")
include ("shared.lua")

util.AddNetworkString("cigaStart")
util.AddNetworkString("cigaEnd")
util.AddNetworkString("cigaMode")

function SWEP:FindInRadius()
	local origin = self.Owner:GetPos()
	local rec = {}
	for _, pl in pairs(player.GetHumans()) do
		if pl:GetPos():DistToSqr(origin) > 490000 then continue end
		rec[#rec + 1] = pl
	end
	return rec
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
	net.Start("cigaEnd")
		net.WriteEntity(self.Owner)
		net.WriteInt(self.Power,8)
	net.Broadcast()
	self.Hold = false
	self.Power = 0
end

function SWEP:OnHold()
	net.Start("cigaStart")
		net.WriteEntity(self.Owner)
	net.Send(self:FindInRadius())
end

function SWEP:Holster()
	if self.Hold then self:OnRelease() end
	return true
end

function SWEP:OnRemove()
	if self.Hold then self:OnRelease() end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextSecondaryFire(CurTime() + 1)
	self.Mode = self.Mode % 3  + 1
	net.Start("cigaMode")
	net.WriteEntity(self.Owner)
	net.WriteUInt(self.Mode, 2)
	net.Broadcast()
end

local function __sync(pl)
	if !IsValid(pl) then return end

	for _, self in pairs(ents.FindByClass("weapon_ciga*")) do
		if self.Base ~= "weapon_ciga" then continue end

		net.Start("cigaMode")
		net.WriteEntity(self.Owner)
		net.WriteUInt(self.Mode, 2)
		net.Send(pl)
	end
end

hook.Add("PlayerInitialSpawn", "SyncNWDataCiggs", function(pl)
	timer.Simple(5, __sync, pl)
end)