AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "MP7"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector (-4.8, 0, 1)
	SWEP.AimAng = Vector (0, 0, 2)
	
	SWEP.SprintPos = Vector(9.071, 0, 1.6418)
	SWEP.SprintAng = Vector(-12.9765, 26.8708, 0)
	
	SWEP.IconLetter = "a"
	SWEP.IconFont = "WeaponIcons"
	
	SWEP.MuzzleEffect = "swb_rifle_med"
end

SWEP.Base = 'swb_base'
SWEP.PlayBackRate = 30
SWEP.PlayBackRateSV = 12
SWEP.SpeedDec = 15
SWEP.BulletDiameter = 9
SWEP.CaseLength = 19

SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true

SWEP.Slot = 2
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto"}
SWEP.Category = "Half-Life Alyx SWB"

SWEP.Author			= "aStonedPenguin"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 50
SWEP.ViewModel			= "models/weapons/c_smg1.mdl"
SWEP.WorldModel			= "models/weapons/w_smg1.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 45
SWEP.Primary.Reload 		= Sound("Weapon_SMG1.Reload")
SWEP.Primary.DefaultClip	= 135
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "SMG1"

SWEP.FireDelay = 0.065
SWEP.FireSound = Sound("Weapon_SMG1.Single")
SWEP.Recoil = 0.75

SWEP.HipSpread = 0.04
SWEP.AimSpread = 0.001
SWEP.VelocitySensitivity = 1.6
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.007
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 25
SWEP.DeployTime = 1


function SWEP:ReloadSound()
	self.Weapon:EmitSound(self.Primary.Reload)
end