SWEP.PrintName	= "Ассасин Пришелец"
SWEP.Slot		= 4
SWEP.SlotPos 	= 1
SWEP.DrawAmmo 	= false

SWEP.Author			= "Beelzebub"
SWEP.Contact		= "beelzebub@incredible-gmod.ru or [INC]Beelzebub#0281"

SWEP.Purpose		= ""
SWEP.Instructions	= ""
SWEP.DrawCrosshair	= false
SWEP.ViewModelFOV	= 65
--SWEP.ViewModelFlip	= true

SWEP.Weight					= 30
SWEP.AutoSwitchTo			= true
SWEP.AutoSwitchFrom			= true

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true
SWEP.AdminOnly              = true
SWEP.Category               = "Necrotic" 

SWEP.HoldType = "grenade" 
SWEP.UseHands = true
SWEP.ViewModel 	= ""--Model("models/weapons/w_npcnade.mdl")
SWEP.WorldModel = ""--Model("models/weapons/w_npcnade.mdl")

SWEP.DrawAmmo				= false

SWEP.Primary.Sound 			= Sound("")
SWEP.Primary.Round 			= ("")
SWEP.Primary.Cone			= 0.2
SWEP.Primary.Recoil			= 0
SWEP.Primary.Damage			= 0
SWEP.Primary.Spread			= .01
SWEP.Primary.NumShots		= 1
SWEP.Primary.RPM			= 0
SWEP.Primary.ClipSize		= 0
SWEP.Primary.DefaultClip	= 0
SWEP.Primary.KickUp			= 0
SWEP.Primary.KickDown		= 0
SWEP.Primary.KickHorizontal	= 0
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "none"

SWEP.Secondary.ClipSize		= 0
SWEP.Secondary.DefaultClip	= 0
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo			= "none"
SWEP.Secondary.IronFOV		= 0

SWEP.Penetration		= true
SWEP.Ricochet			= true
SWEP.MaxRicochet			= 1
SWEP.RicochetCoin		= 1
SWEP.BoltAction			= false
SWEP.Scoped				= false
SWEP.ShellTime			= .35
SWEP.Tracer				= 0	
SWEP.CanBeSilenced		= false
SWEP.Silenced			= false
SWEP.NextSilence 		= 0
SWEP.SelectiveFire		= false
SWEP.NextFireSelect		= 0
SWEP.OrigCrossHair = true

SWEP.Sequence2Index = {}

function SWEP:Initialize()
	self.GranadeCount = 10
	self:SetNoDraw(true)
end

function SWEP:PrimaryAttack()
	if (self.AttackDelay or 0) > CurTime() then return end
	self.AttackDelay = CurTime() + 2

	self.SpeedMult = 0.55

	self:SetPlayerSequence("Pests", nil, function()
		if SERVER then
			local tr = self.Owner:GetEyeTraceNoCursor()
			local ent = tr.Entity

			self.Owner:EmitSound(Sound("npc/vort/claw_swing"..math.random(1,2)..".wav"))

			if not ent:IsPlayer() then return end
			if self.Owner:GetPos():Distance(ent:GetPos()) > 90 then return end

			local dmg = math.random(75, 110)
			ent:TakeDamage(dmg, self.Owner, self)
			ent:EmitSound("vo/npc/male01/myarm0"..math.random(1,2)..".wav")
		end
	end)
end

function SWEP:SecondaryAttack()
	if (self.AttackDelay or 0) > CurTime() then return end
	self.AttackDelay = CurTime() + 5

	--self:SetNoDraw(false)

	self:SetPlayerSequence("Smoke", "Stab", function()	
		--self:SetNoDraw(true)

		if CLIENT then
			self.Owner:ViewPunch( Angle( 2,1,5 ) ) 
			return
		end	

		self.GranadeCount = self.GranadeCount or 10

		if self.GranadeCount <= 0 then return end
		self.GranadeCount = self.GranadeCount - 1

		local ply = self.Owner
		local ent = ents.Create("npc_grenade_frag")

		if not IsValid(ent) then return end

		ply:EmitSound("WeaponFrag.Throw", 75, 180, 0.2)

		timer.Simple(math.random(3, 6), function()
			local explode = ents.Create("env_explosion")
			explode:SetPos(ent:GetPos())
			
			if IsValid(self.Owner) then
				explode:SetOwner(self.Owner)
			end
			
			explode:Spawn()
			explode:SetKeyValue("iMagnitude", "220")
			explode:Fire("Explode", 0, 0)

			if IsValid(ent) then
				ent:Remove()
			end
		end)

		--ent:SetPos(ply:EyePos() + ( ply:GetAimVector() * 8 ))
		local v = self.Owner:GetShootPos()
			v = v + self.Owner:GetForward() * 1
			v = v + self.Owner:GetRight() * 3
			v = v + self.Owner:GetUp() * 1
		ent:SetPos(v)

		ent:SetAngles(Angle(math.random(1,100),math.random(1,100),math.random(1,100)))
		ent:Spawn()
		ent:PhysWake()
		--ent:GetPhysicsObject():SetVelocity( ply:GetAimVector()*1500)
 
		local phys = ent:GetPhysicsObject()
		if not IsValid(phys) then ent:Remove() return end

		if self.Owner:KeyDown( IN_FORWARD ) then
			self.Force = 3200
		elseif self.Owner:KeyDown( IN_BACK ) then
			self.Force = 2100
		elseif self.Owner:KeyDown( IN_MOVELEFT ) then
			self.Force = 2500
		elseif self.Owner:KeyDown( IN_MOVERIGHT ) then
			self.Force = 2500
		else
			self.Force = 2500
		end

		phys:ApplyForceCenter(self.Owner:GetAimVector() *self.Force *1.2 + Vector(0,0,200) )
		phys:AddAngleVelocity(Vector(math.random(-500,500),math.random(-500,500),math.random(-500,500)))
	end)
end

function SWEP:SetPlayerSequence(anim, anim2, anim2_callback)
	if CLIENT or self.SetPlayerSequenceDisabled then return end

	local ply = self.Owner
	local id = ply:LookupSequence(anim)

	if ply:GetSequence() == id then return end

	local time = ply:forceSequence(anim)
	if not time then return end

	if self.SpeedMult then
		time = time*self.SpeedMult
		self.SpeedMult = nil
	end

	self.SetPlayerSequenceDisabled = true
	timer.Simple(time, function()
		self.SetPlayerSequenceDisabled = false
		if anim2 then
			local time2 = self:SetPlayerSequence(anim2)
			if not time2 then return end
			timer.Simple(time2, anim2_callback)
		elseif anim2_callback then
			anim2_callback()
		end
	end)

	return time
end

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



--[[
function SWEP:Think()
	local ply = self.Owner
	if not ply:IsPlayer() then return end

	if ply:KeyDown(IN_RELOAD) then
		self:SetPlayerSequence("Inspect")
	end
end
]]--

local function Uncloak(ply)
	ply:SetNWBool("Cloaked1", false)
	ply:SetNWBool("Cloaked2", false)
	
	ply:SetDSP(0)
    ply:DrawShadow(true)
    ply:SetRenderMode(0)
    ply:SetColor(Color(255, 255, 255, 255))
	
    ply:SetNWInt("Cloak_NextToggle", CurTime() + 1)
end

function SWEP:Reload()
	if (self.NextReload or 0) > CurTime() then return end
	self.NextReload = CurTime() + 0.3

	local ply = self:GetOwner()
    local plypos =  ply:GetPos()

	if ply:GetNWInt("Cloak_NextToggle") == nil then
		ply:SetNWInt("Cloak_NextToggle", CurTime())
	end

    if ply:GetNWInt("Cloak_NextToggle") <= CurTime() and not ply:GetNWBool("Cloaked1") then
        ply:SetNWBool("Cloaked1", true)
        ply:DrawShadow(false)
        ply:SetRenderMode(4)
		
    elseif ply:GetNWInt("Cloak_NextToggle") and ply:GetNWBool("Cloaked1") then
    	Uncloak(ply)
    end
end