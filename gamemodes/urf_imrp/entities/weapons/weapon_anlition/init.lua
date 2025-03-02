AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:Deploy()
	self.OldSpeed 	= self.Owner:GetWalkSpeed()
	self.OldJump 	= self.Owner:GetJumpPower()
	self.OldModel 	= self.Owner:GetModel()
	
	self.Owner.NoFallDamage = true
	
	local info = self.Owner:GetJobTable() or {}
	self.jGravity 		= info.Gravity or self.jGravity
	self.jJumpPower 	= info.JumpPower or self.jJumpPower
	self.jSpeed	 		= info.Speed or self.jSpeed
	self.jPrimaryDamage	= info.PrimaryDamage or self.jPrimaryDamage
	self.jFallDamage	= info.FallDamage or self.jFallDamage
	self.jPrimaryTime	= info.PrimaryTime or self.jPrimaryTime
	self.jSecondaryTime	= info.SecondaryTime or self.jSecondaryTime
	self.jJumpAddTimes	= info.JumpAddTimes or self.jJumpAddTimes
	
	self.Owner:SetWalkSpeed(self.jSpeed)
	self.Owner:SetGravity(self.jGravity)
	--self.Owner:SetJumpPower(self.jJumpPower)
	
	--self.Owner:SetModel('models/AntLion.mdl')
	--self.Owner:SetSkin(math.random(0, 3))
end

function SWEP:OnRemove()
	self:Holster()
end

function SWEP:Holster()
	self.Owner:SetWalkSpeed(self.OldSpeed)
	self.Owner:SetGravity(1)
	self.Owner:SetJumpPower(self.OldJump)
	self.Owner:SetModel(self.OldModel)
	
	timer.Remove('antlionDigidle')
	self.underground = false
	
	self.Owner.NoFallDamage = nil
	self:StopSound(self.Sounds.Jump)
	
	self.Owner:SetBodygroup(1, 0)
	return true
end

function SWEP:PrimaryAttack()
	if self.underground or not self.ground then return end
	
	self:SetNextPrimaryFire(CurTime() + self.jPrimaryTime)
	self.Owner:forceSequence("attack" .. math.random(1, 6))	
	
	timer.Simple(0, function() 
		self:EmitSound(self.Sounds.Attack)
	end)
	
	-- Attack
	timer.Simple(0.4, function() 
		if IsValid(self) then 
			self.Owner:LagCompensation(true)
			
			local tr = util.TraceLine({
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
				filter = self.Owner,
				mask = MASK_SHOT_HULL
			})
			
			if not IsValid(tr.Entity) then 
				tr = util.TraceHull({
					start = self.Owner:GetShootPos(),
					endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * self.HitDistance,
					filter = self.Owner,
					mins = Vector(-10, -10, -8),
					maxs = Vector(10, 10, 8),
					mask = MASK_SHOT_HULL
				})
			end
			
			self.Owner:LagCompensation(false)
			
			if IsValid(tr.Entity) then
				self:EmitSound(self.Sounds.Hit)
				
				if (tr.Entity:IsPlayer() or (tr.Entity:Health() > 0)) then
					local dmginfo = DamageInfo()
				
					local attacker = self.Owner
					if not IsValid(attacker) then attacker = self end
					dmginfo:SetAttacker(attacker)

					dmginfo:SetInflictor(self)
					dmginfo:SetDamage(self.jPrimaryDamage)
					dmginfo:SetDamageForce(self.Owner:GetUp() * 5158 + self.Owner:GetForward() * 10012)

					tr.Entity:TakeDamageInfo(dmginfo)
				end
				
				local phys = tr.Entity:GetPhysicsObject()
				if IsValid(phys) then
					phys:ApplyForceOffset(self.Owner:GetAimVector() * 80 * phys:GetMass(), tr.HitPos)
				end
			end
		end
	end)
end

function SWEP:SecondaryAttack()
	if not self.ground then return end
	
	self:SetNextSecondaryFire(CurTime() + (self.underground and self.jSecondaryTime or 2))
	
	local mat = util.TraceLine({
		start = self.Owner:GetPos(),
		endpos = self.Owner:GetPos() - Vector(0, 0, 10)
	}).MatType
	
	if mat ~= MAT_GRASS and mat ~= MAT_DIRT and mat ~= MAT_SAND then return end
	
	local ed = EffectData()
	ed:SetOrigin(self.Owner:GetPos())
	ed:SetScale(200)
	util.Effect("ThumperDust", ed, true, true)
	
	if self.underground then
		self.Owner:forceSequence("digout")
		self.Owner:EmitSound(self.Sounds.Digout)
		
		timer.Remove('antlionDigidle')
	else
		self:SetNextSecondaryFire(CurTime() + 2)
		self.Owner:forceSequence("digin")
		self.Owner:EmitSound(self.Sounds.Digin)
		
		timer.Simple(0.5, function() 
			timer.Create('antlionDigidle', 0.5, 0, function() 
				if self.underground then
					self.Owner:forceSequence("digidle")
				end
			end)
		end)
	end
	
	self.underground = not self.underground
end

function SWEP:Reload()
	if self.Owner.act and os.time() < self.Owner.act then return end
	if not self.Owner:IsOnGround() then return end
	self.Owner.act = os.time() + 5
	
	self.Owner:EmitSound(self.Sounds.Angry)
	self.Owner:forceSequence("distract")
end

hook.Add("EntityTakeDamage", "antlionNoFallDmg", function(ent, dmginfo)
	if ent:IsPlayer() and ent.NoFallDamage and dmginfo and dmginfo:IsFallDamage() then
		dmginfo:SetDamage(0)
	end
end)