AddCSLuaFile()
SWEP.PrintName = 'Headcrab'

SWEP.WorldModel = ""
SWEP.ViewModel = ""
SWEP.Spawnable			= true

SWEP.HitDistance = 100
SWEP.AttackStamina = 20

SWEP.jGravity 		  = 1
SWEP.jJumpPower 	  = 300
SWEP.jWalkSpeed	 	  = 120
SWEP.jRunSpeed	 	  = 200
SWEP.jPrimaryTime	  = 1.5
SWEP.jPrimaryDamage	  = 50
SWEP.jDigCoolDown	  = 10
SWEP.jMaxDigDuration  = 6
SWEP.jRegenPerSecond  = 5
SWEP.jPrimaryForce    = 400

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
SWEP.Category = "Necrotic"

SWEP.Sounds = { 

	Attack	  = Sound("NPC_Headcrab.Attack"), 
	Idle	  = Sound("NPC_HeadCrab.Idle"),
	BurrowIn  = Sound("NPC_Headcrab.BurrowIn"),
	BurrowOut = Sound("NPC_Headcrab.BurrowOut") 
	
}

SWEP.Taunts = { 

	"excited_dance", 
	"excited_wait_catch", 
	"excitedpound", 
	"excitedup"
	
}

SWEP.IdleTranslate = { }
SWEP.IdleTranslate[ ACT_MP_STAND_IDLE ]                     = ACT_IDLE;
SWEP.IdleTranslate[ ACT_MP_WALK ]                           = ACT_RUN;
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

hook.Add('StartCommand', 'HeadCrabDuck', function(ply, cmd)
	local wep = ply:GetActiveWeapon()
	if not IsValid(wep) or not wep.is_headcrab then return end
	
	if cmd:KeyDown(IN_DUCK) then
		cmd:RemoveKey(IN_DUCK)
	end
end)