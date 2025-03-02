AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString('runGuard.lock')

function SWEP:Deploy()
	self.OldSpeed 	= self.Owner:GetWalkSpeed()
	self.OldJump 	= self.Owner:GetJumpPower()
	self.OldModel 	= self.Owner:GetModel()
	
	local info = self.Owner:GetJobTable() or {}
	self.jGravity 		= info.Gravity or self.jGravity
	self.jJumpPower 	= info.JumpPower or self.jJumpPower
	self.jSpeed	 		= info.Speed or self.jSpeed
	self.jPrimaryDamage	= info.PrimaryDamage or self.jPrimaryDamage
	self.jChargeDamage	= info.ChargeDamage or self.jChargeDamage
	self.jPrimaryTime	= info.PrimaryTime or self.jPrimaryTime
	self.jSecondaryTime	= info.SecondaryTime or self.jSecondaryTime
	
	self.Owner:SetWalkSpeed(self.jSpeed)
	self.Owner:SetGravity(self.jGravity)
	self.Owner:SetJumpPower(self.jJumpPower)
	
	self:EmitSound(self.Sounds.Idle)
	
	--self.Owner:SetModel('models/antlion_guard.mdl')
	--self.Owner:SetSkin(math.random(0, 3))
end

function SWEP:OnRemove()
	self:Holster()
end

local function clearHooks(self)
	timer.Remove('animateGuard.' .. self:EntIndex())
	timer.Remove('runGuard.' .. self:EntIndex())
	timer.Remove('hitGuard.' .. self:EntIndex())
	
	hook.Remove("SetupMove", "runGuard." .. self:EntIndex())
	
	if not IsValid(self) then return end
	
	if self.Eye then 
		net.Start('runGuard.lock')
		net.Send(self.Owner)
		
		self.Eye = nil
	end
end

function SWEP:Holster()
	self.Owner:SetWalkSpeed(self.OldSpeed)
	self.Owner:SetJumpPower(self.OldJump)
	self.Owner:SetModel(self.OldModel)
	self.Owner:SetGravity(1)
	
	clearHooks(self)
	self:StopSound(self.Sounds.Idle)
	
	self.Owner:SetBodygroup(1, 0)
	return true
end

function SWEP:PrimaryAttack() 
	if self.Owner.act and self.Owner.act > os.time() then return end
	if not self.Owner:IsOnGround() then return end
	
	self:SetNextPrimaryFire(CurTime() + self.jPrimaryTime)
	self.Owner:forceSequence("shove") 
	
	timer.Simple(0, function() 
		self:EmitSound(self.Sounds.Attack1)
	end)
	
	timer.Simple(0.3, function() 
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
	if self.Owner.act and self.Owner.act > os.time() then return end
	if not self.Owner:IsOnGround() then return end
	
	self:SetNextSecondaryFire(CurTime() + self.jSecondaryTime)
	self.Owner:forceSequence("charge_startfast") 
	
	self.Owner.act = os.time() + 4
	self.Eye = self.Owner:GetAimVector()
	
	timer.Simple(0, function() 
		self:EmitSound(self.Sounds.Attack2)
	end)
	
	hook.Add("SetupMove", "runGuard." .. self:EntIndex(), function(ply, mvd, cmd)
		if ply ~= self.Owner then return end
		
		--mvd:SetMoveAngles(self.Eye:Angle())
		--ply:SetEyeAngles(self.Eye:Angle())
		
		if mvd:KeyDown(IN_JUMP) then
			mvd:SetButtons(bit.band(mvd:GetButtons(), bit.bnot(IN_JUMP)))
		end
	end)
	
	timer.Simple(4, function()
		clearHooks(self)
	end)
	
	net.Start('runGuard.lock')
		net.WriteVector(self.Eye)
	net.Send(self.Owner)
	
	timer.Simple(0.7, function() 
		self.Owner:SetVelocity(self.Eye * 1000)
		self.Owner:forceSequence("charge_loop")
		
		--self:EmitSound(self.Sounds.LoopAttack2)
		self.Owner:SetMoveType(MOVETYPE_WALK)
		
		timer.Create('hitGuard.' .. self:EntIndex(), 0.3, 10, function()
			self.Owner:LagCompensation(true)
			
			tr = util.TraceHull({
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + self.Eye * self.HitDistance,
				filter = self.Owner,
				mins = Vector(-50, -50, -20),
				maxs = Vector(50, 50, 20),
				mask = MASK_SHOT_HULL
			})
			
			self.Owner:LagCompensation(false)
			
			if IsValid(tr.Entity) then
				local attackDir = tr.Entity:WorldSpaceCenter() - self.Owner:WorldSpaceCenter()
				attackDir:Normalize()
				
				local dmginfo = DamageInfo()
				
				dmginfo:SetAttacker(IsValid(self.Owner) and self.Owner or self)
				dmginfo:SetInflictor(self)
				dmginfo:SetDamage(self.jChargeDamage)
				dmginfo:SetDamageForce(self.Owner:GetUp() * 1015800 + self.Owner:GetForward() * 2001200)
				
				tr.Entity:TakeDamageInfo(dmginfo)	
				tr.Entity:EmitSound(self.Sounds.Hit)			
			end
		end)
		
		timer.Create('runGuard.' .. self:EntIndex(), 0.05, 60, function() 
			local vel = self.Owner:GetAimVector()
			self.Eye = Vector(vel[1], vel[2], 0)
			
			if self.Owner:IsOnGround() then
				self.Owner:SetVelocity(self.Eye * 1000)
			end
			
			if self.Owner:GetVelocity():LengthSqr() < 50000 and self.Owner.act - os.time() < 3 then
				self.Owner:forceSequence("charge_stop")
				self:EmitSound(self.Sounds.Hit)		
				clearHooks(self)
				
				local ed = EffectData()
				ed:SetOrigin(self.Owner:GetPos())
				ed:SetScale(200)
				util.Effect("ThumperDust", ed, true, true)
			end
			
			if not self.Owner:Alive() then
				clearHooks(self)
			end
		end)
		
		timer.Create('animateGuard.' .. self:EntIndex(), 0.5, 6, function() 
			if not IsValid(self) then return end
			
			self.Owner:forceSequence("charge_loop", nil, nil, true)
			
			self:EmitSound(self.Sounds.Step)	
			timer.Simple(0.25, function() self:EmitSound(self.Sounds.Step) end)
			
			util.ScreenShake(self.Owner:GetPos(), 5, 5, 0.5, 1000)
		end)
	end)
end

function SWEP:Reload()
	if self.Owner.act and os.time() < self.Owner.act then return end
	if not self.Owner:IsOnGround() then return end
	self.Owner.act = os.time() + 5
	
	self.Owner:EmitSound(self.Sounds.Angry)
	self.Owner:forceSequence("bark")
end