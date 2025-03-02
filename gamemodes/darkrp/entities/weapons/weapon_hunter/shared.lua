-- "gamemodes\\darkrp\\entities\\weapons\\weapon_hunter\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿AddCSLuaFile()
SWEP.PrintName = 'Hunter'

SWEP.WorldModel = ""
SWEP.ViewModel = ""
--SWEP.Spawnable			= true
SWEP.AdminOnly = true

SWEP.HitDistance = 200

SWEP.jGravity 		= 0.9
SWEP.jJumpPower 	= 300
SWEP.jSpeed	 		= 140
SWEP.jChargeDamage	= 2000
SWEP.jPrimaryTime	= 15
SWEP.jSecondaryTime	= 10
SWEP.jFlechAmount	= 20

SWEP.Primary.Clipsize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"

SWEP.Secondary.Clipsize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.DrawAmmo 			= false
SWEP.DrawCrosshair      = true
SWEP.Slot				= 1
SWEP.SlotPos			= 1
SWEP.HoldType 			= "slam"

SWEP.Sounds = 
{ 
	Attack2		= Sound('NPC_Hunter.MeleeAnnounce'), 
	Attack1		= Sound('NPC_Hunter.FlechetteShoot'), 
	LoopAttack1	= Sound('NPC_Hunter.FlechetteShootLoop'), 
	Step		= Sound('NPC_Hunter.Footstep'), 
	PreAttack2	= Sound('NPC_Hunter.MeleeAnnounce'), 
	PreAttack1	= Sound('NPC_Hunter.Alert'), 
	Hit		 	= Sound('NPC_Hunter.MeleeHit')
}

SWEP.IdleTranslate = { }
SWEP.IdleTranslate[ ACT_MP_STAND_IDLE ]                     = ACT_IDLE;
SWEP.IdleTranslate[ ACT_MP_WALK ]                           = ACT_WALK;
SWEP.IdleTranslate[ ACT_MP_RUN ]                            = ACT_RUN;
SWEP.IdleTranslate[ ACT_MP_CROUCH_IDLE ]                    = ACT_WALK;
SWEP.IdleTranslate[ ACT_MP_CROUCHWALK ]                     = ACT_WALK ;
SWEP.IdleTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]       = ACT_MELEE_ATTACK1;
SWEP.IdleTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]      = ACT_MELEE_ATTACK_SWING;
SWEP.IdleTranslate[ ACT_MP_RELOAD_STAND ]                   = ACT_RELOAD;
SWEP.IdleTranslate[ ACT_MP_RELOAD_CROUCH ]                  = ACT_RELOAD;
SWEP.IdleTranslate[ ACT_MP_JUMP ]                           = ACT_JUMP;
SWEP.IdleTranslate[ ACT_MP_SWIM_IDLE ]                      = ACT_JUMP;
SWEP.IdleTranslate[ ACT_MP_SWIM ]                           = ACT_JUMP;
SWEP.IdleTranslate[ ACT_GMOD_NOCLIP_LAYER]                  = ACT_GLIDE;
SWEP.IdleTranslate[ ACT_MP_STAND_IDLE ]                     = ACT_IDLE;

--local prev = 0
function SWEP:TranslateActivity( act )
	--if act != prev then
	--	prev = act
	--	print(act)
	--end
	
	if ( self.IdleTranslate[ act ] != nil ) then
 		return self.IdleTranslate[ act ]
	end
	return -1
end