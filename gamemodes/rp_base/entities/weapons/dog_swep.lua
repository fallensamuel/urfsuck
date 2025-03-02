AddCSLuaFile()
SWEP.PrintName = 'Anlition Guard'

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

function SWEP:Deploy()
	self.Owner:SetWalkSpeed(100)
end

function SWEP:OnRemove()
	self:Holster()
end

function SWEP:Holster()
	self.Owner:SetBodygroup(1, 0)
	return true
end

local prev = 0
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

if CLIENT then
	function SWEP:Think()
		if IsValid(self.Owner) then
			if self.ground != self.Owner:IsOnGround() then
				self.ground = self.Owner:IsOnGround()
				self.Owner:SetBodygroup(1, self.ground && 0 or 1)
			end
		end
	end
end

local seqs = {'excitedpound', 'excitedup'}
function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime()+3.5)
	local r = table.Random(seqs)
	self.Owner:forceSequence(r)
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime()+3.5)
	self.Owner:forceSequence("pound")
end
