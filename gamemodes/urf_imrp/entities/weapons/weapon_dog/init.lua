AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function SWEP:Initialize()
    self:SetHoldType("pistol")

    if not IsValid(self.Owner) || not self.Owner:IsPlayer() then return end

    self.OldSpeed = self.Owner:GetWalkSpeed()
    self.OldGravity = self.Owner:GetGravity()
    self.OldRunSpeed = self.Owner:GetRunSpeed()
    self.OldModel = self.Owner:GetModel()

    --self.Owner:SetWalkSpeed(self.pWalkSpeed)
    --self.Owner:SetRunSpeed(self.pRunSpeed)
    self.Owner:SetGravity(self.pGravity)
    --self.Owner:SetModel(self.pPlayerModel)
end

function SWEP:Deploy()
    self:SetHoldType("pistol")

    if not IsValid(self.Owner) || not self.Owner:IsPlayer() then return end

    self.OldSpeed = self.Owner:GetWalkSpeed()
    self.OldGravity = self.Owner:GetGravity()
    self.OldRunSpeed = self.Owner:GetRunSpeed()
    self.OldJumpPower = self.Owner:GetJumpPower()
    self.OldModel = self.Owner:GetModel()

    --self.Owner:SetWalkSpeed(self.pWalkSpeed)
    --self.Owner:SetRunSpeed(self.pRunSpeed)
    self.Owner:SetGravity(self.pGravity)
    self.Owner:SetJumpPower(self.pJumpPower)
   -- self.Owner:SetModel(self.pPlayerModel)

    self.Owner:SetCustomCollisionCheck(true) 

    self.Owner:SetNWBool("IsDog",true)

    self.Active = true
end

function SWEP:OnRemove()
    self:Holster()
end

function SWEP:Holster()
    self:Death()

    --self.Owner:SetWalkSpeed(self.OldSpeed)
   	--self.Owner:SetRunSpeed(self.OldRunSpeed)
    self.Owner:SetGravity(self.OldGravity)
    self.Owner:SetJumpPower(self.OldJumpPower)
    --self.Owner:SetModel(self.OldModel)

    self.Owner:SetNWBool("IsDog",false)

    self.Active = false
    return true
end

function SWEP:Death()
    if self.Owner:Health() > 0 || !self.Active then return end

    local explode = ents.Create("env_explosion")
    explode:SetKeyValue("m_iMagnitude", 100)
    explode:SetKeyValue("m_flDamageForce", 200)
    explode:SetPos(self.Owner:GetPos())
    explode:Spawn()
    explode:Fire("Explode")

    local d = DamageInfo()
    d:SetDamage( self.pRadiusDamage )
    d:SetDamageType( DMG_BLAST )

    self.Owner:LagCompensation(true)
    for k,v in pairs(ents.FindInSphere(self.Owner:GetPos(),self.pSphereRadius)) do
     if v:IsPlayer() && v != self.Owner then
         d:SetAttacker(v)
         v:TakeDamageInfo(d)
     end
    end
    self.Owner:LagCompensation(false)

    self:StartSound("Death")
end

function SWEP:PrimaryAttack()
    self.Weapon:SetNextPrimaryFire(CurTime() + self.pPrimatyTime)
    self.Weapon:SetNextSecondaryFire(CurTime() + self.pPrimatyTime)
    self:StartSound("Attack")

    timer.Simple(0.4, function() 
        if !IsValid(self) || !self.Active then return end
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
            if (tr.Entity:IsPlayer() or (tr.Entity:Health() > 0)) then
                local dmginfo = DamageInfo()
            
                local attacker = self.Owner
                if not IsValid(attacker) then attacker = self end
                dmginfo:SetAttacker(attacker)
                dmginfo:SetInflictor(self)
                dmginfo:SetDamage(self.pPrimaryDamage)
                dmginfo:SetDamageForce(self.Owner:GetUp() * 5158 + self.Owner:GetForward() * 10012)

                tr.Entity:TakeDamageInfo(dmginfo)
            end
            
            local phys = tr.Entity:GetPhysicsObject()
            if IsValid(phys) then
                phys:ApplyForceOffset(self.Owner:GetAimVector() * 80 * phys:GetMass(), tr.HitPos)
            end
        end
    end)
end

function SWEP:SecondaryAttack()
    self.Weapon:SetNextSecondaryFire(CurTime() + self.pSecondaryTime)
    self.Weapon:SetNextPrimaryFire(CurTime() + self.pPrimatyTime)
    self:StartSound("AttackRadius")

    self.Owner:SetWalkSpeed(1)
    self.Owner:SetRunSpeed(1)

    timer.Simple(0.8, function() 
    	if !IsValid(self) || !self.Active then return end
        for k,v in pairs(ents.FindInSphere(self.Owner:GetPos(), self.pSphereRadius)) do
            if IsValid(v) && v:IsPlayer() && v != self.Owner && v:Health() > 0 then             
                local dmginfo = DamageInfo()
            
                local attacker = self.Owner
                if not IsValid(attacker) then attacker = self end
                dmginfo:SetAttacker(attacker)
                dmginfo:SetInflictor(self)
                dmginfo:SetDamage(self.pSecondaryDamage)
                dmginfo:SetDamageForce(self.Owner:GetUp() * 5158 + self.Owner:GetForward() * 10012)

                v:TakeDamageInfo(dmginfo)
            end
        end

		local effectdata = EffectData()
		effectdata:SetOrigin( self.Owner:GetPos() )
		effectdata:SetScale( 500 )
		util.Effect( "ThumperDust", effectdata, true, true)

    	self.Owner:SetWalkSpeed(self.pWalkSpeed)
    	self.Owner:SetRunSpeed(self.pRunSpeed)
    end)
end