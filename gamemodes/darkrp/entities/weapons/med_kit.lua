-- "gamemodes\\darkrp\\entities\\weapons\\med_kit.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
SWEP.Base = 'weapon_rp_base'

if CLIENT then
	SWEP.PrintName = "Аптечка"
	SWEP.Slot = 5
	SWEP.SlotPos = 0
	SWEP.Category = "Help Sweps"
	SWEP.Spawnable = true
	SWEP.AdminSpawnable = true
	SWEP.Purpose = "Heal the wounded"
	SWEP.Instructions = "Left click to heal other player\nRight click to heal yourself"
end

SWEP.ViewModel = Model("models/weapons/c_medkit.mdl")
SWEP.WorldModel = Model("models/weapons/w_medkit.mdl")
SWEP.Primary.Delay = 0.1
SWEP.Primary.Sound = Sound('hl1/fvox/boop.wav')

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self._Reload.Sound = {Sound('npc_citizen.health01'), Sound('npc_citizen.health02'), Sound('npc_citizen.health03'), Sound('npc_citizen.health04'), Sound('npc_citizen.health05')}
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if CLIENT then return end
	self.Owner:LagCompensation(true)
	local ent = self.Owner:GetEyeTrace().Entity
	self.Owner:LagCompensation(false)
	local health = (IsValid(ent) and ent:IsPlayer()) and ent:Health()
	local maxhealth = (IsValid(ent) and ent:IsPlayer()) and math.min(ent:GetMaxHealth(), 200)
	if not isnumber(health) or health >= maxhealth or (self.Owner:GetPos():Distance(ent:GetPos()) > self.HitDistance) then return end
	ent:SetHealth(health > maxhealth - 1 and maxhealth or health + 1)
	self.Owner:EmitSound(self.Primary.Sound, 125, health)
end

function SWEP:SecondaryAttack()
	if not IsValid(self.Owner) then return end
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	local health = SERVER and self.Owner:Health()
	local maxhealth = SERVER and math.min(self.Owner:GetMaxHealth(), 200)
	if CLIENT or health >= maxhealth then return end
	self.Owner:SetHealth(health > maxhealth - 1 and maxhealth or health + 1)
	self.Owner:EmitSound(self.Primary.Sound, 125, health)
end

function SWEP:Reload()
	if not IsValid(self.Owner) or not self:CanReload() then return end
	self:SetNextReload(CurTime() + self._Reload.Delay)
	if CLIENT then return end
	self.Owner:EmitSound(self._Reload.Sound[math.random(1, 5)])
end