AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "357 MAGNUM"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector(-3.21, 0.958, 1)
	SWEP.AimAng = Vector(0, -0.216, 0)
	
	SWEP.SprintPos = Vector(1.185, -15.796, -14.254)
	SWEP.SprintAng = Vector(64.567, 0, 0)
	
	SWEP.ZoomAmount = 5
	SWEP.ViewModelMovementScale = 0.85
	SWEP.Shell = "smallshell"
	
	SWEP.IconLetter = "e"
	SWEP.IconFont = "WeaponIcons"
	
	SWEP.MuzzleEffect = "swb_pistol_large"
end

SWEP.SpeedDec = 12
SWEP.BulletDiameter = 9.1
SWEP.CaseLength = 33

SWEP.PlayBackRate = 2
SWEP.PlayBackRateSV = 2

SWEP.Kind = WEAPON_PISTOL
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true
SWEP.AmmoEnt = "item_ammo_revolver_ttt"

SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.NormalHoldType = "revolver"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"semi"}
SWEP.Base = "swb_base"
SWEP.Category = "Half-Life Alyx SWB"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel		= "models/weapons/c_357.mdl"
SWEP.WorldModel		= "models/weapons/w_357.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 6
SWEP.Primary.DefaultClip	= 12
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "357"

SWEP.FireDelay = 0.7
SWEP.FireSound = Sound("Weapon_357.Single")
SWEP.Recoil = 3
SWEP.Chamberable = false

SWEP.HipSpread = 0.048
SWEP.AimSpread = 0.0075
SWEP.VelocitySensitivity = 1.85
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.015
SWEP.SpreadCooldown = 0.5
SWEP.Shots = 1
SWEP.Damage = 85
SWEP.DeployTime = 1