
-----------------------------------------------------


AddCSLuaFile()



local BaseClass = baseclass.Get('weapon_hl2axe')



SWEP.Spawnable			= true

SWEP.Category = "Half-Life Alyx Melee"

SWEP.UseHands = true

SWEP.PrintName				= "Фомка"

SWEP.ViewModel				= Model( "models/weapons/c_crowbar.mdl" )

SWEP.WorldModel				= Model( "models/weapons/w_crowbar.mdl" )



SWEP.HitSound = Sound( "Flesh.ImpactHard" )

SWEP.SwingSound = Sound( "WeaponFrag.Roll" )

SWEP.HitSoundElse = Sound("Canister.ImpactHard")



SWEP.Push = false

SWEP.IsDestroyingProps = true



SWEP.HitRate = 0.4

SWEP.DamageDelay = 0.08

SWEP.PushDelay = 1

SWEP.DamageMin = 1

SWEP.DamageMax = 3



SWEP.PushAngle = Angle(-5, -1, 0.125)

SWEP.HitAngle = Angle(-2, -2, 0.125)



SWEP.HoldType = "melee"



