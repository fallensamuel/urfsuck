AddCSLuaFile()
SWEP.Base = 'weapon_rp_base'

SWEP.Category = 'RP'
SWEP.Spawnable		= true

if CLIENT then
	SWEP.PrintName = 'Battering Ram'
	SWEP.Slot = 5
	SWEP.SlotPos = 1
	SWEP.Instructions = 'Left click to open doors and fade props\nRight click to ready the ram'
end

SWEP.ViewModel = Model('models/weapons/c_rpg.mdl')
SWEP.WorldModel = Model('models/weapons/w_rocket_launcher.mdl')
SWEP.Primary.Sound = Sound('Canals.d1_canals_01a_wood_box_impact_hard3')
SWEP.Primary.Delay = 2.5
local Ironsights = false
local OldJump = 190
local NewJump = 0
local NewRun = 180

--SWEP.AdminOnly = true

function SWEP:Deploy()
	if not IsValid(self.Owner) then return end
	NewRun = self.Owner:GetWalkSpeed()
	OldJump = self.Owner:GetJumpPower()
end

function SWEP:OnRemove()
	if not IsValid(self.Owner) then return end
	hook.Call('UpdatePlayerSpeed', GAMEMODE, self.Owner)
	self.Owner:SetJumpPower(OldJump)
end

function SWEP:Holster()
	self:OnRemove()

	return true
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) or CLIENT then return end
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self.Owner:LagCompensation(true)
	local tr = self.Owner:GetEyeTrace()
	self.Owner:LagCompensation(false)
	local ent = tr.Entity
	if not IsValid(ent) or not Ironsights or (self.Owner:EyePos():Distance(tr.HitPos) > self.HitDistance) then return end

	if ent:IsVehicle() && ent.extraSeats then
		ent:ClearSeats(15, true)
	elseif ent:IsDoor() then
		local tar = ent:DoorGetOwner()

		if IsValid(tar) then
			if ent.Locked then
				ent:DoorLock(false)
			end

			ent:Fire('open', '', .6)
			ent:Fire('setanimation', 'open', .6)
		else
			return
		end
	elseif (ent:GetClass() == 'prop_physics' or ent:GetClass() == 'prop_physics_multiplayer') then
		local tar = ent:CPPIGetOwner()

		if IsValid(tar) then
			--constraint.RemoveConstraints(ent, 'Weld')
			--ent:GetPhysicsObject():EnableMotion(true)
			
			ent:Fade()
			
			timer.Create('ram.unfade' .. ent:EntIndex(), 10, 0, function()
				if not IsValid(ent) then return end
				ent:UnFade()
				
				rp.AutoFreezer.Block(ent)
				rp.AutoFreezer.AntiPlayerBlock(ent)
			end)
		else
			return
		end
	else
		return
	end

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Owner:EmitSound(self.Primary.Sound)
	self.Owner:ViewPunch(Angle(-10, math.random(-5, 5), 0))
end

function SWEP:SecondaryAttack()
	if not IsValid(self.Owner) then return end
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	Ironsights = not Ironsights

	if Ironsights then
		self:SetHoldType('rpg')
		self.Owner:SetRunSpeed(NewRun)
		self.Owner:SetJumpPower(NewJump)
	else
		self:SetHoldType('normal')
		hook.Call('UpdatePlayerSpeed', GAMEMODE, self.Owner)
		self.Owner:SetJumpPower(OldJump)
	end
end
--[[
function SWEP:GetViewModelPosition(pos, ang) -- Fix
	return pos, ang
end
]]
--