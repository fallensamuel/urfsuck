-- "gamemodes\\darkrp\\entities\\weapons\\weapon_psevdogiant\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
SWEP.PrintName = "Псевдогигант"
SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false

SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = ""
SWEP.WorldModel = ""

--SWEP.Spawnable = true
SWEP.Category = "RP"
SWEP.AdminOnly = true

SWEP.Primary.Damage = 125
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.pSecondaryTime = 3.5
SWEP.pPrimaryTime = 0.9

SWEP.pPrimaryDamage = 150
SWEP.pSecondaryDamage = 300
SWEP.pSphereRadius = 300

SWEP.pRegenHp = 10
SWEP.pRegenArmor = 20
SWEP.pRegenHpTime = 3

SWEP.pMaxHealth = 200
SWEP.pMaxArmor = 600

SWEP.pPlayerModel = "models/stalkertnb2/pseudogiant1.mdl"
SWEP.pHitDistance = 150
SWEP.pWalkSpeed = 150
SWEP.pRunSpeed = 450

SWEP.pBoostDelay = 6
SWEP.pBoostTime = 3
SWEP.pBoostDamage = 300

SWEP.Sound = {
	Attack = "npc/ministrider/ministrider_skewer1.wav",
}

SWEP.IdleTranslate = { }
SWEP.IdleTranslate[ ACT_MP_STAND_IDLE ]                     = ACT_IDLE;
SWEP.IdleTranslate[ ACT_MP_WALK ]                           = ACT_WALK;
SWEP.IdleTranslate[ ACT_MP_RUN ]                            = ACT_WALK;
SWEP.IdleTranslate[ ACT_MP_CROUCH_IDLE ]                    = ACT_IDLE;
SWEP.IdleTranslate[ ACT_MP_CROUCHWALK ]                     = ACT_WALK ;
SWEP.IdleTranslate[ ACT_MP_ATTACK_STAND_PRIMARYFIRE ]       = ACT_MELEE_ATTACK1;
SWEP.IdleTranslate[ ACT_MP_ATTACK_CROUCH_PRIMARYFIRE ]      = ACT_MELEE_ATTACK_SWING;
SWEP.IdleTranslate[ ACT_MP_RELOAD_STAND ]                   = ACT_RELOAD;
SWEP.IdleTranslate[ ACT_MP_RELOAD_CROUCH ]                  = ACT_RELOAD;
SWEP.IdleTranslate[ ACT_MP_JUMP ]                           = ACT_IDLE;
SWEP.IdleTranslate[ ACT_MP_SWIM_IDLE ]                      = ACT_IDLE;
SWEP.IdleTranslate[ ACT_MP_SWIM ]                           = ACT_IDLE;
SWEP.IdleTranslate[ ACT_GMOD_NOCLIP_LAYER]                  = ACT_GLIDE;
SWEP.IdleTranslate[ ACT_MP_STAND_IDLE ]                     = ACT_IDLE;

function SWEP:TranslateActivity( act )
	if ( self.IdleTranslate[ act ] != nil ) then
 		return self.IdleTranslate[ act ]
	end
	return -1
end

function SWEP:StartSound(name)
	if self.Sound[name] then
		if type(self.Sound[name]) == "table" then
			self.Owner:EmitSound(table.Random(self.Sound[name]))
		else
			self.Owner:EmitSound(self.Sound[name])
		end
	end
end

hook.Add("PlayerFootstep", "PsevdogiantScreenShake", function(client, position, foot, soundName, volume)
    if client:GetNWBool("IsPsevdogiant") then
        util.ScreenShake(client:GetPos(), 2, 2, 0.5, 100)
    end
end)

SWEP.NextReload = 0
function SWEP:Reload()
	if CurTime() < self.NextReload then return end

	if self.IsSleep then
		self.IsSleep = false

		if SERVER then
	    	self.Owner:SetWalkSpeed(self.OldSpeed)
	    	self.Owner:SetRunSpeed(self.OldRunSpeed)

    		timer.Destroy("RegenHp"..self:EntIndex())
    		self.Owner:forceSequence("stand_turn_ls_0")
    	end
    	--self.Owner:AddVCDSequenceToGestureSlot( GESTURE_SLOT_ATTACK_AND_RELOAD, self.Owner:LookupSequence("stand_turn_ls_0"), 0, true)
	else
		self.IsSleep = true

		if SERVER then
		    self.Owner:SetWalkSpeed(0.0001)
		    self.Owner:SetRunSpeed(0.0001)

		    timer.Create("RegenHp"..self:EntIndex(),self.pRegenHpTime,0,function()
		    	if not IsValid(self) or not IsValid(self.Owner) or not self.IsSleep then return end
		    	self.Owner:SetHealth(math.min(self.Owner:Health()+self.pRegenHp, self.pMaxHealth))
		    	self.Owner:SetArmor(math.min(self.Owner:Armor()+self.pRegenArmor, self.pMaxArmor))
		    end)
		    self.Owner:forceSequence("sleep_idle_0")
	    end
	end

	self.NextReload = CurTime() + 2
end