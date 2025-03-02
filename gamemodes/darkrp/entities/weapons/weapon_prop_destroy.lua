AddCSLuaFile()

SWEP.Spawnable = true

SWEP.PrintName = 'Монтировка'
SWEP.Category = 'Half-Life Alyx RP'
SWEP.Base = 'weapon_rp_base'
SWEP.Slot = 0
SWEP.SlotPos = 1
SWEP.Instructions = ''
SWEP.WeaponType = "Melee"

SWEP.HoldType = 'fist'

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.VModelFlip = false
SWEP.HoldType = "melee"

SWEP.SoundMiss = Sound("Weapon_Crowbar.Single")
SWEP.SoundWallHit = Sound("Flesh.BulletImpact")
SWEP.SoundFlesh = Sound("Weapon_Crowbar.Melee_Hit")

SWEP.Primary.Damage			= 20
SWEP.Primary.NumShots		= 1
SWEP.Primary.ClipSize		= -1
SWEP.Primary.SpareClip		= -1
SWEP.Primary.Delay			= 0.34
SWEP.Primary.Ammo			= "none"
SWEP.Primary.Automatic 		= true 

SWEP.Secondary.Damage		= 0
SWEP.Secondary.NumShots		= 1
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.SpareClip	= -1
SWEP.Secondary.Delay		= 0
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.Automatic 	= true 

SWEP.IsDestroyingProps 		= true 

SWEP.AdminOnly = true

local HitDistance = 70

function SWEP:PrimaryAttack()
	if self:GetNextPrimaryFire() > CurTime() then return end
	self.Owner:SetAnimation(PLAYER_ATTACK1)

	local Delay = self.Primary.Delay
	
	self.Owner:LagCompensation(true)
	local tr = util.TraceLine({
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * HitDistance,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	})
	if not IsValid(tr.Entity) then
		tr = util.TraceHull({
			start = self.Owner:GetShootPos(),
			endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * HitDistance,
			filter = self.Owner,
			mins = Vector(-10, -10, -8),
			maxs = Vector(10, 10, 8),
			mask = MASK_SHOT_HULL
		})
	end
	self.Owner:LagCompensation(false)
	
	if tr.Hit then
		self:EmitSound(self.SoundWallHit)
		self:SendWeaponAnim(ACT_VM_HITCENTER)
	else
		self:EmitSound(self.SoundMiss)
		self:SendWeaponAnim(ACT_VM_MISSCENTER)
		Delay = Delay * 1.25
	end
	
	self:SetNextPrimaryFire(CurTime() + Delay)
	self:SetNextSecondaryFire(CurTime() + Delay)
	
	if not tr.Hit or not IsFirstTimePredicted() then return end
	
	self.Owner:FireBullets({
		--Damage = math.random(self.Primary.Damage),
		Damage = self.Primary.Damage,
		Distance = HitDistance * 2, 
		Force = 100,
		HullSize = 1,
		Num = 1,
		Dir = self.Owner:GetAimVector(), 
		Spread = Vector(0, 0), 
		Src = tr.StartPos,
		IgnoreEntity = self.Owner,
	})
end

function SWEP:SecondaryAttack()
	self:PrimaryAttack()
end
