AddCSLuaFile()
game.AddAmmoType( {
	name = "ammo_hcanister"
} )
if CLIENT then language.Add( "ammo_hcanister" , "Вызов Хедкрабов" ) end

SWEP.PrintName			= "Вызов хедкрабов" 
SWEP.Author			= "( zuknes )" 
SWEP.Instructions		= "Вызывает контейнер с тремя обычными хедкрабами."
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category 				= "Other"
SWEP.Primary.ClipSize		= 10
SWEP.Primary.DefaultClip	= 1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "ammo_hcanister"
SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"
SWEP.Weight			= 5
SWEP.AutoSwitchTo		= false
SWEP.AutoSwitchFrom		= false
SWEP.Slot			= 1
SWEP.SlotPos			= 2
SWEP.DrawAmmo			= false
SWEP.DrawCrosshair		= true
SWEP.ViewModel			= "models/weapons/v_binoculars.mdl"
SWEP.WorldModel			= "models/weapons/w_binoculars.mdl"

SWEP.ViewModel		= "models/weapons/v_binocular5.mdl"
SWEP.WorldModel		= "models/weapons/w_binoculars.mdl"

SWEP.Type = 0
SWEP.Count = 3

function SWEP:PrimaryAttack()
	if (self.Weapon:CanPrimaryAttack()) then
		local trace = self.Owner:GetEyeTrace()
		local skytrace = {}
		skytrace.start = trace.HitPos
		skytrace.endpos = trace.HitPos + Vector(0,0,65000)
		skycheck = util.TraceLine(skytrace)
		if (!skycheck.HitSky or !trace.HitPos or trace.HitNormal:Angle().pitch == 0 or trace.HitNormal:Angle().pitch == 0) then 
			self.Owner:EmitSound("buttons/button8.wav")
			return false 
		end
		if !SERVER then return end
		local type = self.Type
		local count = self.Count

		local ang = trace.HitNormal:Angle()
		ang.pitch = ang.pitch - 270


		MakeHeadcrabcanister(trace.HitPos, ang, type, count)
		self.Owner:EmitSound("buttons/button14.wav")
	else
		self.Owner:EmitSound("buttons/button8.wav")
	end
	self.Weapon:TakePrimaryAmmo(1)
	self.Weapon:SetNextPrimaryFire( CurTime() +  2 )
end