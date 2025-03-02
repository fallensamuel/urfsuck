AddCSLuaFile()

SWEP.Chamberable = false

if CLIENT then
    
    SWEP.DrawCrosshair = false
	SWEP.PrintName = "Арбалет"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector(-7.722, -7, 2.079)
	SWEP.AimAng = Vector(0.892, -0.81, -2.309)
	
	SWEP.SprintPos = Vector(0, 0, -0.7)
	SWEP.SprintAng = Vector(-7.739, 28.141, 0)
	
	SWEP.ViewModelMovementScale = 0.7
	SWEP.DrawBlackBarsOnAim = true
	SWEP.AimOverlay = surface.GetTextureID("swb/scope_rifle")
	SWEP.FadeDuringAiming = true
	SWEP.MoveWepAwayWhenAiming = true
	SWEP.ZoomAmount = 35
	SWEP.DelayedZoom = true
	SWEP.SnapZoom = true
	SWEP.SimulateCenterMuzzle = true
	
	SWEP.AdjustableZoom = true
	SWEP.MinZoom = 35
	SWEP.MaxZoom = 75
	
	SWEP.IconLetter = "z"
	
	SWEP.MuzzleEffect = "swb_rifle_med"
	SWEP.InvertShellEjectAngle = true

	function SWEP:Reload()
		
		if self.ReloadDelay or CT < self.ReloadWait or self.dt.State == SWB_ACTION or self.ShotgunReloadState != 0 then return false end
		if self.Owner:KeyDown(IN_USE) and self.dt.State != SWB_RUNNING then self:CycleFiremodes() return false end

		if self:Clip1() < self:GetMaxClip1() then
				
			self.Owner:EmitSound(Sound("weapons/crossbow/reload1.wav")) 
				
			timer.Create('Realoding', 0.8, 1, function() 
					
				self.Owner:EmitSound(Sound("weapons/crossbow/bolt_load2.wav")) 
				
			end )
			
		end
		
	end

end

SWEP.PlayBackRate = 1
SWEP.PlayBackRateSV = 1
SWEP.FadeCrosshairOnAim = true
SWEP.PreventQuickScoping = true

SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true

SWEP.SpeedDec = 40
SWEP.BulletDiameter = 8.58
SWEP.CaseLength = 69.20

SWEP.Slot = 4
SWEP.SlotPos = 0
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"bolt"}
SWEP.Base = "swb_base"
SWEP.Category = "Half-Life Alyx SWB"

SWEP.Author	= ""
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.Instructions = ""

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/c_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "XBOWBolt"

SWEP.FireDelay = 1.5
SWEP.FireSound = Sound("weapons/crossbow/fire1.wav")
SWEP.Recoil = 4

SWEP.HipSpread = 0.06
SWEP.AimSpread = 0.0001
SWEP.RifleSpread = 0.003
SWEP.VelocitySensitivity = 0
SWEP.MaxSpreadInc = 0
SWEP.SpreadPerShot = 0
SWEP.SpreadCooldown = 0
SWEP.Shots = 1
SWEP.Damage = 250
SWEP.DeployTime = 1