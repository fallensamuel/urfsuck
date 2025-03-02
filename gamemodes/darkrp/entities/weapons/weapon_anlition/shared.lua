AddCSLuaFile()
SWEP.PrintName = 'Anlition'

SWEP.WorldModel = ""
SWEP.ViewModel = ""
SWEP.Spawnable			= true
SWEP.AdminOnly = true

SWEP.HitDistance 	= 100

SWEP.jGravity 		= 0.7
SWEP.jJumpPower 	= 400
SWEP.jSpeed	 		= 140
SWEP.jPrimaryDamage	= 20
SWEP.jFallDamage	= 200
SWEP.jPrimaryTime	= 3.5
SWEP.jSecondaryTime	= 1
SWEP.jJumpAmount	= 2 

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

SWEP.Sounds = 
{
	Attack 	= Sound('NPC_Antlion.MeleeAttackSingle'), 
	Jump 	= Sound('NPC_Antlion.WingsOpen'), 
	Land 	= Sound('NPC_Antlion.Land'), 
	Angry 	= Sound('NPC_Antlion.MeleeAttackDouble'), 
	Digin 	= Sound('NPC_Antlion.BurrowIn'), 
	Digout 	= Sound('NPC_Antlion.BurrowOut'), 
	Hit 	= Sound('NPC_Antlion.MeleeAttack')
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
		if (act == ACT_MP_RUN or act == ACT_MP_WALK) and not self.ground then
			return ACT_JUMP
		end
		
 		return self.IdleTranslate[ act ]
	else
	end
	return -1
end

SWEP.nextJump = 0
SWEP.jump_amount = 0
 
function SWEP:Think()
	if IsValid(self.Owner) then
		if self.ground != self.Owner:IsOnGround() then
			self.ground = self.Owner:IsOnGround()
			
			if SERVER then
				if self.ground then
					self:StopSound(self.Sounds.Jump)
					self:EmitSound(self.Sounds.Land)
					
					self.Owner:SetBodygroup(1, 0)
					
					self.jump_amount = 0
					
					for k, v in ipairs(ents.FindInSphere(self.Owner:GetPos(), 10)) do
						if v:IsPlayer() and v ~= self.Owner and v:Alive() or v:IsNPC() then
							local dmginfo = DamageInfo()
							
							dmginfo:SetAttacker(self.Owner)
							dmginfo:SetInflictor(self)
							dmginfo:SetDamage(self.jFallDamage)

							v:TakeDamageInfo(dmginfo)
						end
					end
				else
					self.Owner:EmitSound(self.Sounds.Jump)
					self.Owner:forceSequence("jump_start", nil, nil, true)
					self.Owner:SetBodygroup(1, 1)
				end
			else
				self.Owner:SetBodygroup(1, self.ground && 0 or 1)
			end
		end
	end
	
	if not self.underground and self.Owner:KeyDown(IN_JUMP) and self.nextJump < CurTime() and self.jump_amount < self.jJumpAmount then
		self.nextJump = CurTime() + 1
		
		local vec = self.Owner:GetVelocity()
		vec.z = self.jJumpPower
		self.Owner:SetVelocity(-self.Owner:GetVelocity() + vec)
		
		self.jump_amount = self.jump_amount + 1
	end
end