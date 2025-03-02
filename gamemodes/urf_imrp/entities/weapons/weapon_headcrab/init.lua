AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:Deploy()

	self.OldWalkSpeed = self.Owner:GetWalkSpeed()
	self.OldRunSpeed  = self.Owner:GetRunSpeed()
	self.OldJumpPower = self.Owner:GetJumpPower()
	self.OldModel 	  = self.Owner:GetModel()
	
	local info = self.Owner:GetJobTable() or {}
	
	self.jGravity 		 = info.Gravity or self.jGravity
	self.jJumpPower 	 = info.JumpPower or self.jJumpPower
	self.jWalkSpeed	 	 = info.WalkSpeed or self.jWalkSpeed
	self.jRunSpeed	 	 = info.RunSpeed or self.jRunSpeed
	self.jPrimaryDamage	 = info.PrimaryDamage or self.jPrimaryDamage
	self.jPrimaryTime	 = info.PrimaryTime or self.jPrimaryTime
	self.jDigCoolDown	 = info.DigCoolDown or self.jDigCoolDown
	self.jMaxDigDuration = info.MaxDigDuration or self.jMaxDigDuration
	self.jPrimaryForce	 = info.PrimaryForce or self.jPrimaryForce
	self.jRegenPerSecond = info.RegenPerSecond or self.jRegenPerSecond
	
	self.Owner:SetWalkSpeed(self.jWalkSpeed)
	self.Owner:SetRunSpeed(self.jRunSpeed)
	self.Owner:SetGravity(self.jGravity)
	self.Owner:SetJumpPower(self.jJumpPower)
	
	self.Owner:SetModel('models/headcrabclassic.mdl')
	self:IdleSounds()
		
end

function SWEP:OnRemove()

	self:Holster()
	
end

function SWEP:Holster()

	self.Owner:SetWalkSpeed(self.OldWalkSpeed)
	self.Owner:SetRunSpeed(self.OldRunSpeed)
	self.Owner:SetJumpPower(self.OldJumpPower)
	self.Owner:SetModel(self.OldModel)
	self.Owner:SetGravity(1)
	
	self:RemoveTimers()
	
	return true
	
end

function SWEP:IdleSounds()

	timer.Create("IdleSounds." .. self:EntIndex(), 8, 0, function()
		if IsValid(self) then
			self.Owner:EmitSound(self.Sounds.Idle)	
		end
	end)
	
end

function SWEP:RemoveTimers()

	timer.Remove('hitHeadcrab.' .. self:EntIndex())
	timer.Remove("IdleSounds." .. self:EntIndex())
	
end

function SWEP:PrimaryAttack()
 
	if self.Owner.act and self.Owner.act > os.time() then return end
	if not self.Owner:IsOnGround() then return end
	if self.IsUnderGround then return end
	
	self:SetNextPrimaryFire(CurTime() + self.jPrimaryTime)
	self.Owner:forceSequence("jumpattack_broadcast", nil, 1, 1) 

	self.Owner:EmitSound(self.Sounds.Attack) 	
	
	self.Owner:SetPos(self.Owner:GetPos() + Vector(0, 0, 1))
	
	local Dir = self.Owner:GetEyeTrace().Normal
	Dir.z = math.Clamp(Dir.z, 0.5, 1)
	
	self.Owner:SetVelocity(Dir * self.jPrimaryForce) 
	
	timer.Simple(0.1, function()
		timer.Create('hitHeadcrab.' .. self:EntIndex(), 0.05, 0, function() 
			if not IsValid(self) or self.Owner:IsOnGround() then 
				timer.Remove('hitHeadcrab.' .. self:EntIndex())
				return 
			end
			
			self.Owner:LagCompensation(true)
			
			local tr = util.TraceLine({
			
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() - Vector(0, 0, 40) + self.Owner:GetAimVector() * self.HitDistance,
				filter = self.Owner,
				mask = MASK_SHOT_HULL
				
			})
			
			if not IsValid(tr.Entity) then 
			
				tr = util.TraceHull({
				
					start = self.Owner:GetShootPos(),
					endpos = self.Owner:GetShootPos() - Vector(0, 0, 20) + self.Owner:GetAimVector() * self.HitDistance,
					filter = self.Owner,
					mins = Vector(-10, -10, -8),
					maxs = Vector(10, 10, 8),
					mask = MASK_SHOT_HULL
					
				})
				
			end
		
			self.Owner:LagCompensation(false)
			
			if IsValid(tr.Entity) then
				timer.Remove('hitHeadcrab.' .. self:EntIndex())
				sound.Play("physics/metal/metal_barrel_impact_hard" .. math.random(8) .. ".wav", self.Owner:GetPos(), 100, 100, 1)
				
				if (tr.Entity:IsPlayer() or (tr.Entity:Health() > 0)) then
				
					local Attacker = self.Owner
					if not IsValid(Attacker) then Attacker = self end

					local DmgInfo = DamageInfo()					
					DmgInfo:SetAttacker(Attacker)
					DmgInfo:SetInflictor(self)
					DmgInfo:SetDamage(self.jPrimaryDamage)
					DmgInfo:SetDamageType(0)
					
					tr.Entity:TakeDamageInfo(DmgInfo)
					
				end
				
				local phys = tr.Entity:GetPhysicsObject()
				
				if IsValid(phys) then
				
					phys:ApplyForceOffset(self.Owner:GetAimVector() * 500 * phys:GetMass(), tr.HitPos)
					
				end
				
			end
			
		end)
		
	end)
	
end

function SWEP:SecondaryAttack() 

	if not self.Owner:IsOnGround() then return end
	
	local Mat = util.TraceLine({
	
		start = self.Owner:GetPos(),
		endpos = self.Owner:GetPos() - Vector(0, 0, 10)
		
	}).MatType
	
	if Mat ~= MAT_GRASS and Mat ~= MAT_DIRT and Mat ~= MAT_SAND and Mat ~= MAT_SNOW then return end
	
	if self.IsUnderGround then

		self:SetNextSecondaryFire(CurTime() + self.jDigCoolDown)
		
		self.Owner:forceSequence("burrowout") 
		self.Owner:EmitSound(self.Sounds.BurrowOut)
		self.Owner:DrawShadow(true)
	
		timer.Remove("headcrabDigIdle")
		timer.Remove("digAutoExit")
		
	else

		self:SetNextSecondaryFire(CurTime() + 2)	
	
		self.Owner:forceSequence("burrowin")
		self.Owner:EmitSound(self.Sounds.BurrowIn)

		timer.Create("digAutoExit", self.jMaxDigDuration, 1, function() 
			
			self:SetNextSecondaryFire(CurTime() + self.jDigCoolDown)
			
			self.Owner:forceSequence("burrowout") 
			self.Owner:EmitSound(self.Sounds.BurrowOut)
			self.Owner:DrawShadow(true)
			
			timer.Remove("headcrabDigIdle")
			
			self.IsUnderGround = not self.IsUnderGround
					
		end)
		
		timer.Simple(0.5, function() 
		
			self.Owner:DrawShadow(false) 
		
			timer.Create("headcrabDigIdle", 0.5, 0, function() 
			
				if self.IsUnderGround then
				
					if self.Owner:Health() < self.Owner:GetMaxHealth()  then
					
						self.Owner:SetHealth(math.min(self.Owner:Health() + self.jRegenPerSecond / 2), self.Owner:GetMaxHealth())
					
					end
				
					self.Owner:forceSequence("burrowidle")
					
				end
				
			end)
			
		end)
		
	end
	
	self.IsUnderGround = not self.IsUnderGround
	
end

function SWEP:Reload()

	if self.Owner.act and os.time() < self.Owner.act then return end
	
	self.Owner.act = os.time() + 3
	
	self.Owner:EmitSound(self.Sounds.Alert)
	
end