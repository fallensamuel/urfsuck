SWEP.PrintName = "Оружие Пса"
SWEP.Slot = 5
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true

SWEP.Contact = ""
SWEP.Purpose = ""

SWEP.ViewModelFOV = 60
SWEP.ViewModelFlip = false
SWEP.UseHands = true
SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.Spawnable = true
SWEP.Category = "Root"

SWEP.Primary.Damage = 100
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.pPlayerModel = "models/dog.mdl"
SWEP.pWalkSpeed = 100
SWEP.pRunSpeed = 310
SWEP.pBoostSpeed = 400
SWEP.pGravity = 0
SWEP.pJumpPower = 0
SWEP.pSphereRadius = 200
SWEP.pRadiusDamage = 10
SWEP.pPrimatyTime = 2
SWEP.pSecondaryTime = 2
SWEP.pBoostTime = 3
SWEP.pNextBoost = 3
SWEP.pPrimaryDamage = 150
SWEP.pSecondaryDamage = 180
SWEP.pBoostDamage = 100
SWEP.AdminOnly = true 

SWEP.HitDistance = 200

SWEP.IsCanBoost = true

SWEP.Sound = {
	AttackRadius = {
		"npc/dog/car_impact1.wav",
		"npc/dog/car_impact2.wav"
	},
	Attack = "npc/ministrider/ministrider_skewer1.wav",
	Death = "npc/dog/dog_scared1.wav",
	Raid = "npc/ministrider/hunter_prestrike1.wav",
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

function SWEP:DestroyBoost()
    self.Owner:SetWalkSpeed(self.pWalkSpeed)
    self.Owner:SetRunSpeed(self.pRunSpeed)

    self.Owner.DogBoosted = false
end

function SWEP:Reload()
    if self.IsCanBoost then
        self.Owner:SetWalkSpeed(self.pBoostSpeed)
        self.Owner:SetRunSpeed(self.pBoostSpeed)

        self:StartSound("Raid")
        self:StartSound("Run")

        self.IsCanBoost = false
        self.Owner.DogBoosted = true
        timer.Create("NextBoost"..self:EntIndex(), self.pNextBoost, 1, function()
            if !IsValid(self) then return end
            self.IsCanBoost = true
        end)
        timer.Create("BoostTime"..self:EntIndex(), self.pBoostTime, 1, function()
            if !IsValid(self) then return end
            self:DestroyBoost()
        end)
    end
end

function SWEP:Think()
	if !self.Owner.DogBoosted then return end
	self.Owner:LagCompensation(true)
	tr = util.TraceHull({
		start = self.Owner:GetShootPos(),
		endpos = self.Owner:GetShootPos() + self.Owner:GetAimVector() * 10,
		filter = self.Owner,
		mins = Vector(-50, -50, -20),
		maxs = Vector(50, 50, 20),
		mask = MASK_SHOT_HULL
	})
	self.Owner:LagCompensation(false)

	if IsValid(tr.Entity) then	
		self:DestroyBoost()
		if SERVER then
			self.Owner:SetVelocity(self.Owner:GetAimVector() * 200)
		
			local dmginfo = DamageInfo()
			dmginfo:SetAttacker(IsValid(self.Owner) and self.Owner or self)
			dmginfo:SetInflictor(self)
			dmginfo:SetDamage(self.pBoostDamage)
			tr.Entity:TakeDamageInfo(dmginfo)

			tr.Entity:SetVelocity(self.Owner:GetAimVector() * 4000)
		end

		util.ScreenShake(self.Owner:GetPos(), 10, 10, 0.8, 50)
	end
end