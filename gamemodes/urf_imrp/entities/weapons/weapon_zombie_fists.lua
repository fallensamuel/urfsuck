local CurTime, math = CurTime, math

local DRUG = {}
DRUG.Name = "Zombie Slow"
DRUG.Duration = 2
DRUG.NoKarmaLoss = true

function DRUG:StartHighServer(pl)
    pl.StunstickOldWalkSpeed = pl.StunstickOldRunSpeed or pl:GetWalkSpeed()
    pl.StunstickOldRunSpeed = pl.StunstickOldRunSpeed or pl:GetRunSpeed()
    pl:SetWalkSpeed(pl.StunstickOldRunSpeed * 0.5)
    pl:SetRunSpeed(pl.StunstickOldWalkSpeed * 0.5)
end

function DRUG:CalculateDuration(pl, stacks)
    return math.min(stacks * 3, 15)
end

--function DRUG:TickServer(pl, stacks, startTime, endTime)
--end
function DRUG:AddStack(pl, stacks)
    pl:SetWalkSpeed(pl:GetRunSpeed() * 0.7)
    pl:SetRunSpeed(pl:GetRunSpeed() * 0.7)
end

function DRUG:EndHighServer(pl)
    if (pl.StunstickOldWalkSpeed) then
        pl:SetWalkSpeed(pl.StunstickOldWalkSpeed)
        pl.StunstickOldWalkSpeed = nil
    end

    if (pl.StunstickOldRunSpeed) then
        pl:SetRunSpeed(pl.StunstickOldRunSpeed)
        pl.StunstickOldRunSpeed = nil
    end
end

RegisterDrug(DRUG)
AddCSLuaFile()
SWEP.PrintName = "Зомби Кулаки"
SWEP.Author = "urf.im"
SWEP.Purpose = "МОЗГИИИИИИИИИ."
SWEP.Category = "Necrotic"
SWEP.Slot = 0
SWEP.SlotPos = 4
SWEP.Spawnable = true
SWEP.ViewModel = Model("models/weapons/c_arms.mdl")
SWEP.WorldModel = ""
SWEP.ViewModelFOV = 54
SWEP.UseHands = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"
SWEP.DrawAmmo = false
SWEP.HitDistance = 48
SWEP.punchMin = 8
SWEP.punchMax = 12
SWEP.critMin = 12
SWEP.critMax = 24

local SwingSound = {Sound("npc/zombie/claw_miss1.wav"), Sound("npc/zombie/claw_miss2.wav")}
local HitSound = {Sound("npc/zombie/claw_strike1.wav"), Sound("npc/zombie/claw_strike2.wav"), Sound("npc/zombie/claw_strike3.wav")}
local RoarSound = {Sound('npc/fast_zombie/fz_scream1.wav'), Sound('npc/fast_zombie/fz_alert_close1.wav'), Sound('npc/zombie/zombie_voice_idle1.wav'), Sound('npc/zombie/zombie_voice_idle2.wav'), Sound('npc/zombie/zombie_voice_idle3.wav'), Sound('npc/zombie/zombie_voice_idle4.wav'), Sound('npc/zombie/zombie_voice_idle5.wav'), Sound('npc/zombie/zombie_voice_idle6.wav'), Sound('npc/zombie/zombie_voice_idle7.wav'), Sound('npc/zombie/zombie_voice_idle8.wav'), Sound('npc/zombie/zombie_voice_idle9.wav')}

local anim_zombie = {
    [ACT_MP_STAND_IDLE] = ACT_HL2MP_IDLE_ZOMBIE,
    [ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH_ZOMBIE,
    [ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_CROUCH_ZOMBIE_01,
    [ACT_MP_WALK] = ACT_HL2MP_WALK_ZOMBIE_03,
    [ACT_MP_RUN] = ACT_HL2MP_RUN_ZOMBIE,
    [ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_GMOD_GESTURE_RANGE_ZOMBIE,
    [ACT_MP_RELOAD_STAND] = ACT_GMOD_GESTURE_TAUNT_ZOMBIE
}

local anim_fast_zombie = {
    [ACT_MP_STAND_IDLE] = ACT_HL2MP_WALK_ZOMBIE,
    [ACT_MP_CROUCH_IDLE] = ACT_HL2MP_IDLE_CROUCH_ZOMBIE,
    [ACT_MP_CROUCHWALK] = ACT_HL2MP_WALK_CROUCH_ZOMBIE_05,
    [ACT_MP_WALK] = ACT_HL2MP_WALK_ZOMBIE_06,
    [ACT_MP_RUN] = ACT_HL2MP_RUN_ZOMBIE_FAST,
    [ACT_MP_ATTACK_STAND_PRIMARYFIRE] = ACT_GMOD_GESTURE_RANGE_ZOMBIE,
    [ACT_MP_RELOAD_STAND] = ACT_GMOD_GESTURE_TAUNT_ZOMBIE,
}

function SWEP:TranslateActivity(act)
    --print(act, anim_zombie[act])
    return self.fastZombie and anim_fast_zombie[act] or anim_zombie[act] or act
end

function SWEP:Initialize()
    self:SetHoldType("fist")

    if CLIENT and self:GetOwner():GetModel():find('zombie_fast') then
        self.fastZombie = true
    end
end

function SWEP:SetupDataTables()
    self:NetworkVar("Float", 0, "NextMeleeAttack")
    self:NetworkVar("Float", 1, "NextIdle")
    self:NetworkVar("Int", 2, "Combo")
end

function SWEP:UpdateNextIdle()
    local vm = self:GetOwner():GetViewModel()
    self:SetNextIdle(CurTime() + vm:SequenceDuration())
end

local CombineForcefields = {
	["combine_forcefield"] = true,
	["combine_forcefield_big"] = true,
	["combine_forcefield_cwu"] = true,
}

function SWEP:PrimaryAttack(right)
    self:GetOwner():SetAnimation(PLAYER_ATTACK1)
    local anim = "fists_left"

    if (right) then
        anim = "fists_right"
    end

    if (self:GetCombo() >= 2) then
        anim = "fists_uppercut"
    end

    local vm = self:GetOwner():GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence(anim))
    self:EmitSound(table.Random(SwingSound), 75)

    local trace = util.TraceLine({
        start = self:GetOwner():GetShootPos(),
        endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 105,
        filter = self:GetOwner()
    })

    if (not IsValid(trace.Entity)) then
        trace = util.TraceHull({
            start = self:GetOwner():GetShootPos(),
            endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * 105,
            filter = self:GetOwner(),
            mins = Vector(-10, -10, -8),
            maxs = Vector(10, 10, 8)
        })
    end

    local trent = trace.Entity

    if trent:IsValid() or trace.HitWorld then
        --self.Weapon:SendWeaponAnim(ACT_VM_HITKILL)
        --self:GetOwner():ViewPunch( Angle(-10,0,0) )
        --timer.Simple(0.1,function()
        --	if not self:IsValid() then return end
        --	self:GetOwner():ViewPunch( Angle(15,0,0) )
        --end)
        if trent:IsValid() then
            local class = trent:GetClass()
            if CombineForcefields[trent:GetClass()] and trent.enabled then
                trent.ZFists_HitCount = (trent.ZFists_HitCount or 0) + 1
                if trent.ZFists_HitCount >= 5 then
                    trent.ZFists_HitCount = 0
                    trent:Disable()
                end
            elseif (class == 'prop_physics' or class == 'prop_physics_multiplayer') and (trent.CPPIGetOwner and trent:CPPIGetOwner()) then
                trent.ZFists_HitCount = (trent.ZFists_HitCount or 0) + 1
                if trent.ZFists_HitCount >= 5 then
                    trent.ZFists_HitCount = 0
                    trent:Remove()
                end
            elseif trent.FadingDoor and trent.Fade then
                trent:Fade()
            elseif trent:IsPlayer() or trent:IsNPC() then
                --if SERVER then trent:EmitSound("physics/body/body_medium_break"..math.random(2,4)..".wav",75,math.random(70,90)) end
                --local effectdata = EffectData()
                --effectdata:SetOrigin(trace.HitPos)
                --effectdata:SetEntity(trent)
                --util.Effect( "BloodImpact", effectdata )
            elseif trent:GetClass() == "prop_door_rotating" then
                --[[and GetConVarNumber( "lordi_sledge_break_doors" ) == 1 ]]
                if SERVER and math.random(1, 5) == 1 then
                    trent:Fire("unlock")
                    trent:Fire("open")
                    --trent:SetNotSolid(true)
                    --trent:SetNoDraw(true)
                    ----Bit of madcow stuff here... :L
--                    --local ent = ents.Create("prop_physics")
--                    --trent:EmitSound("physics/wood/wood_furniture_break1.wav")
--                    --ent:SetPos(trent:GetPos())
--                    --ent:SetAngles(trent:GetAngles())
--                    --ent:SetModel(trent:GetModel())
--
--                    --if trent:GetSkin() then
--                    --    ent:SetSkin(trent:GetSkin())
--                    --end
--
--                    --ent:Spawn()
--                    --ent:GetPhysicsObject():ApplyForceCenter(self:GetOwner():GetAimVector() * 10000)
--
--                    --timer.Simple(25, function()
--                    --    if ent:IsValid() then
--                    --        ent:Remove()
--                    --    end
--
                    --    trent:SetNotSolid(false)
                    --    trent:SetNoDraw(false)
                    --end)
                elseif SERVER then
                    trent:EmitSound("physics/wood/wood_box_break" .. math.random(1, 2) .. ".wav", 75, math.random(50, 150))
                end
            end
            --if SERVER then trent:TakeDamage(math.random(150,200),self:GetOwner()) end
        end
        --[[if trace.HitWorld then
			local trace = self:GetOwner():GetEyeTrace()
			
			if self:GetOwner():GetShootPos():Distance(trace.HitPos) <= 105 then
				util.Decal("Impact.Sand",trace.HitPos + trace.HitNormal,trace.HitPos - trace.HitNormal)
			end
		end
		if SERVER then timer.Simple(0,function() if not self:IsValid() then return end self:EmitSound("physics/metal/metal_canister_impact_hard"..math.random(1,3)..".wav",75,math.random(90,110)) end) end
	else
		self.Weapon:SendWeaponAnim(ACT_VM_MISSCENTER)
		if SERVER then timer.Simple(0,function() if not self:IsValid() then return end self:EmitSound("npc/zombie/claw_miss1.wav",75,60) end) end
		self:GetOwner():ViewPunch( Angle(-10,0,0) )
		timer.Simple(0.1,function()
			if not self:IsValid() then return end
			self:GetOwner():ViewPunch( Angle(30,0,0) )
		end)
		]]
    end

    self:UpdateNextIdle()
    self:SetNextMeleeAttack(CurTime() + 0.5)
    self:SetNextPrimaryFire(CurTime() + 1.5)
    self:SetNextSecondaryFire(CurTime() + 1.5)
end

function SWEP:Reload()
    if self:GetNextPrimaryFire() > CurTime() or self:GetNextSecondaryFire() > CurTime() then return end
    self:GetOwner():SetAnimation(PLAYER_RELOAD)
    self:SetNextPrimaryFire(CurTime() + 2)
    self:SetNextSecondaryFire(CurTime() + 2)
    self:EmitSound(table.Random(RoarSound), 75)
end

function SWEP:SecondaryAttack()
    self:PrimaryAttack(true)
end

function SWEP:DealDamage()
    local anim = self:GetSequenceName(self:GetOwner():GetViewModel():GetSequence())
    self:GetOwner():LagCompensation(true)

    local tr = util.TraceLine({
        start = self:GetOwner():GetShootPos(),
        endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * self.HitDistance,
        filter = self:GetOwner(),
        mask = MASK_SHOT_HULL
    })

    if (not IsValid(tr.Entity)) then
        tr = util.TraceHull({
            start = self:GetOwner():GetShootPos(),
            endpos = self:GetOwner():GetShootPos() + self:GetOwner():GetAimVector() * self.HitDistance,
            filter = self:GetOwner(),
            mins = Vector(-10, -10, -8),
            maxs = Vector(10, 10, 8),
            mask = MASK_SHOT_HULL
        })
    end

    -- We need the second part for single player because SWEP:Think is ran shared in SP
    if (tr.Hit and not (game.SinglePlayer() and CLIENT)) then
        self:EmitSound(table.Random(HitSound), 75)
    end

    local hit = false

    if (SERVER and IsValid(tr.Entity) and (tr.Entity:IsNPC() or tr.Entity:IsPlayer() or tr.Entity:Health() > 0)) then
        local dmginfo = DamageInfo()
        local attacker = self:GetOwner()

        if (not IsValid(attacker)) then
            attacker = self
        end

        dmginfo:SetAttacker(attacker)
        dmginfo:SetInflictor(self)
        dmginfo:SetDamage(math.random(self.punchMin, self.punchMax))

        if (anim == "fists_left") then
            dmginfo:SetDamageForce(self:GetOwner():GetRight() * 4912 + self:GetOwner():GetForward() * 9998) -- Yes we need those specific numbers
        elseif (anim == "fists_right") then
            dmginfo:SetDamageForce(self:GetOwner():GetRight() * -4912 + self:GetOwner():GetForward() * 9989)
        elseif (anim == "fists_uppercut") then
            dmginfo:SetDamageForce(self:GetOwner():GetUp() * 5158 + self:GetOwner():GetForward() * 10012)
            dmginfo:SetDamage(math.random(self.critMin, self.critMax))
        end

        if tr.Entity:IsPlayer() then
            tr.Entity:AddHigh('Zombie Slow')
        end

        tr.Entity:TakeDamageInfo(dmginfo)
        hit = true
    end

    if (SERVER and IsValid(tr.Entity)) then
        local phys = tr.Entity:GetPhysicsObject()

        if (IsValid(phys)) then
            phys:ApplyForceOffset(self:GetOwner():GetAimVector() * 80 * phys:GetMass(), tr.HitPos)
        end
    end

    if (SERVER) then
        if (hit and anim ~= "fists_uppercut") then
            self:SetCombo(self:GetCombo() + 1)
        else
            self:SetCombo(0)
        end
    end

    self:GetOwner():LagCompensation(false)
end

function SWEP:OnDrop()
    self:Remove() -- You can't drop fists
end

function SWEP:Deploy()
    local vm = self:GetOwner():GetViewModel()
    vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_draw"))
    self:UpdateNextIdle()

    if (SERVER) then
        self:SetCombo(0)
    end

    local t = self:GetOwner():GetJobTable()
    self.punchMin = t.punchMin or self.punchMin
    self.punchMax = t.punchMax or self.punchMin
    self.critMin = t.critMin or self.punchMin
    self.critMax = t.critMax or self.punchMin

    return true
end

function SWEP:Think()
    local vm = self:GetOwner():GetViewModel()
    local curtime = CurTime()
    local idletime = self:GetNextIdle()

    if (idletime > 0 and CurTime() > idletime) then
        vm:SendViewModelMatchingSequence(vm:LookupSequence("fists_idle_0" .. math.random(1, 2)))
        self:UpdateNextIdle()
    end

    local meleetime = self:GetNextMeleeAttack()

    if (meleetime > 0 and CurTime() > meleetime) then
        self:DealDamage()
        self:SetNextMeleeAttack(0)
    end

    if (SERVER and CurTime() > self:GetNextPrimaryFire() + 0.1) then
        self:SetCombo(0)
    end
end