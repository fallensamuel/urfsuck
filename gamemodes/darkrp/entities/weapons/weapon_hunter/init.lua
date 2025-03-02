AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString('runHunter.lock')

SWEP.AdminOnly = true

function SWEP:Deploy()
	self.OldSpeed 	= self.Owner:GetWalkSpeed()
	self.OldJump 	= self.Owner:GetJumpPower()
	self.OldModel 	= self.Owner:GetModel()
	
	local info = self.Owner:GetJobTable() or {}
	self.jGravity 		= info.Gravity or self.jGravity
	self.jJumpPower 	= info.JumpPower or self.jJumpPower
	self.jSpeed	 		= info.Speed or self.jSpeed
	self.jChargeDamage	= info.ChargeDamage or self.jChargeDamage
	self.jPrimaryTime	= info.PrimaryTime or self.jPrimaryTime
	self.jSecondaryTime	= info.SecondaryTime or self.jSecondaryTime
	self.jFlechAmount	= info.FlechAmount or self.jFlechAmount
	
	self.Owner:SetWalkSpeed(self.jSpeed)
	self.Owner:SetGravity(self.jGravity)
	self.Owner:SetJumpPower(self.jJumpPower)
	
	--self.Owner:SetModel('models/hunter.mdl')
	--self.Owner:SetSkin(math.random(0, 3))
end

function SWEP:OnRemove()
	self:Holster()
end

local function clearHooks(self)
	timer.Remove('animateHunter.' .. self:EntIndex())
	timer.Remove('runHunter.' .. self:EntIndex())
	timer.Remove('shootHunter.' .. self:EntIndex())
	timer.Remove('hitHunter.' .. self:EntIndex())
	
	hook.Remove("SetupMove", "runHunter." .. self:EntIndex())
	
	if not IsValid(self) then return end
	
	self:StopSound(self.Sounds.LoopAttack1)
	--self:StopSound(self.Sounds.LoopAttack2)
	
	if self.Eye then 
		net.Start('runHunter.lock')
		net.Send(self.Owner)
		
		self.Eye = nil
	end
end

function SWEP:Holster()
	self.Owner:SetWalkSpeed(self.OldSpeed)
	self.Owner:SetGravity(1)
	self.Owner:SetJumpPower(self.OldJump)
	self.Owner:SetModel(self.OldModel)
	
	clearHooks(self)
	
	self.Owner:SetBodygroup(1, 0)
	return true
end

function SWEP:PrimaryAttack() 
	if self.Owner.act and self.Owner.act > os.time() then return end
	if not self.Owner:IsOnGround() then return end
	
	self:SetNextPrimaryFire(CurTime() + self.jPrimaryTime)
	self.Owner:forceSequence("plant") 
	
	timer.Simple(0, function() 
		self:EmitSound(self.Sounds.PreAttack1)
	end)
	
	local anim_time	= 1 + self.jFlechAmount * 0.1
	self.Owner.act 	= os.time() + anim_time
	
	timer.Simple(anim_time - 0.5, function()
		clearHooks(self)
	end)
	
	timer.Simple(0.5, function() 
		self.Owner:forceSequence("shoot_minigun")
		
		self:EmitSound(self.Sounds.LoopAttack1)
		
		local anim_ct = math.floor(self.jFlechAmount / 1.5)
		timer.Create('animateHunter.' .. self:EntIndex(), 0.15, anim_ct, function() 
			self.Owner:forceSequence("shoot_minigun")
		end)
		
		timer.Create('shootHunter.' .. self:EntIndex(), 0.1, self.jFlechAmount, function() 
			local flec = ents.Create("hunter_flechette")
				flec:SetPos(self.Owner:GetShootPos() + Vector(0, 0, 15) + self.Owner:GetAimVector())
				flec:SetAngles(self.Owner:GetAimVector():Angle())
				flec:SetVelocity(self.Owner:GetAimVector() * 3500)
			flec:Spawn()
			
			self:EmitSound(self.Sounds.Attack1)
		end)
	end)
end

function SWEP:SecondaryAttack() 
	if self.Owner.act and self.Owner.act > os.time() then return end
	if not self.Owner:IsOnGround() then return end
	
	self:SetNextSecondaryFire(CurTime() + self.jSecondaryTime)
	self.Owner:forceSequence("charge_start") 
	
	self.Owner.act = os.time() + 4
	self.Eye = self.Owner:GetAimVector()
	
	timer.Simple(0, function() 
		self:EmitSound(self.Sounds.PreAttack2)
	end)
	
	hook.Add("SetupMove", "runHunter." .. self:EntIndex(), function(ply, mvd, cmd)
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
	
	net.Start('runHunter.lock')
		net.WriteVector(self.Eye)
	net.Send(self.Owner)
	
	timer.Simple(1, function() 
		self.Owner:SetVelocity(self.Eye * 1000)
		self.Owner:forceSequence("charge_loop")
		
		--self:EmitSound(self.Sounds.LoopAttack2)
		self.Owner:SetMoveType(MOVETYPE_WALK)
		
		timer.Create('hitHunter.' .. self:EntIndex(), 0.3, 10, function() 
			if not self.Owner:Alive() then
				clearHooks(self)
			end

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
				
				self:EmitSound(self.Sounds.Hit)
			end
		end)
		
		timer.Create('runHunter.' .. self:EntIndex(), 0.05, 60, function() 
			
			if not self.Owner:Alive() then
				clearHooks(self)
			end

			local vel = self.Owner:GetAimVector()
			self.Eye = Vector(vel[1], vel[2], 0)
			
			if self.Owner:IsOnGround() then
				self.Owner:SetVelocity(self.Eye * 1000)
			end
			
			if self.Owner:GetVelocity():LengthSqr() < 50000 and self.Owner.act - os.time() < 3 then

				self.Owner:forceSequence("charge_crash")
				self:EmitSound(self.Sounds.Hit)		
				clearHooks(self)
				
				local ed = EffectData()
				ed:SetOrigin(self.Owner:GetPos())
				ed:SetScale(200)
				util.Effect("ThumperDust", ed, true, true)
			end
		end)
		
		timer.Create('animateHunter.' .. self:EntIndex(), 0.5, 6, function() 
			if not self.Owner:Alive() then
				clearHooks(self)
			end

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
	self.Owner.act = os.time() + 3
	
	local anim = table.Random({"hunter_angry", "hunter_angry_2"})
	self.Owner:forceSequence(anim)
end