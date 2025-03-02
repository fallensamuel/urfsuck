-- "gamemodes\\darkrp\\entities\\weapons\\weapon_bloodsucker\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
SWEP.IsBloodsucker = true

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Category = 'URF Stalker RP SWEPs'
SWEP.PrintName = 'Лапы Кровососа'
SWEP.Author = 'urf.im'

SWEP.ViewModel = 'models/weapons/v_hands.mdl'
SWEP.WorldModel = ''

SWEP.DrawAmmo = false

SWEP.Slot = 0
SWEP.SlotPos = 5

SWEP.Primary.Ammo = 'None'
SWEP.Primary.ClipSize = -1
SWEP.Primary.Automatic = false

SWEP.Secondary.Ammo = 'None'
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.Automatic = false

SWEP.KickDistance = 200 -- Дистанция атаки
SWEP.KickDamage = 75
SWEP.KickAng = math.cos( math.rad( 40 ) )

SWEP.ResetSpeedDelay = 60

SWEP.SprintStrength = 350
SWEP.SprintDamage = 150
SWEP.SprintSlowPercent = 30 -- на сколько процентов бросок снизит скорость жертве
SWEP.SprintExtraPower = Vector(0, 0, 300) -- Дополнительная сила, применяемая при прыжке (чтобы игрок не тёрся о поверхность)

-- SWEP.ExhaustionDamage = 5
-- SWEP.ExhaustionHeal = 5

SWEP.InvisDuration = 15
SWEP.InvisMaterial = 'models/effects/vol_light001'

SWEP.HealingDelay = 1
SWEP.SleepHeal = 5

SWEP.IdleSoundDelay = 5

SWEP.Sounds = {}
SWEP.Sounds.Idle = {}
SWEP.Sounds.Attack = {'npc/bloodsucker/attack_0.ogg', 'npc/bloodsucker/attack_1.ogg'}
SWEP.Sounds.Hit = {'npc/zombie/claw_strike1.wav', 'npc/zombie/claw_strike2.wav', 'npc/zombie/claw_strike3.wav'}
SWEP.Sounds.Sprint = {'npc/bloodsucker/heavy_hit_1.ogg'}
SWEP.Sounds.Damage = {'npc/bloodsucker/hit_0.ogg', 'npc/bloodsucker/hit_1.ogg', 'npc/bloodsucker/hit_2.ogg'}
-- SWEP.Sounds.Abil4 = 'npc/bloodsucker/vampire_sucking.ogg'
SWEP.Sounds.StartInvis = 'npc/bloodsucker/invisible.ogg'
SWEP.Sounds.EndInvis = 'npc/bloodsucker/invisible_2.ogg'
SWEP.Sounds.Footsteps = {'npc/bloodsucker/foot1.wav', 'npc/bloodsucker/foot2.wav', 'npc/bloodsucker/foot3.wav', 'npc/bloodsucker/foot4.wav'}

SWEP.ActivityTranslates = {}
SWEP.SpecialActivitiesFilters = {}

SWEP.ActivityTranslates[ACT_LAND] = ACT_RESET
SWEP.ActivityTranslates[ACT_MP_STAND_IDLE] = 'stand_idle_1'
SWEP.ActivityTranslates[ACT_MP_WALK] = 'stand_walk'
SWEP.ActivityTranslates[ACT_MP_RUN] = 'stand_run_1'
SWEP.ActivityTranslates[ACT_MP_CROUCH_IDLE] = 'stand_idle_3'
SWEP.ActivityTranslates[ACT_MP_CROUCHWALK] = 'stand_walk'

SWEP.SpecialActivitiesFilters[ACT_MP_STAND_IDLE] = function(owner)
    local hp = owner:Health()

    if hp <= 20 then
        return 2
    else
        return 1
    end
end

function SWEP:SetupDataTables()
    -- self:NetworkVar('Float', 0, 'NextExhaustion')
    self:NetworkVar('Float', 0, 'NextInvis')
end

function SWEP:Initialize()
end

function SWEP:TranslateActivity( act )
    local owner = self:GetOwner()

    local translate = self.ActivityTranslates[act]
    if translate then
        if isnumber(translate) then
            return translate
        elseif isstring(translate) then
            local seq = owner:LookupSequence(translate)
            if seq then
                return owner:GetSequenceActivity(seq)
            end
        elseif istable(translate) then
            local filter = self.SpecialActivitiesFilters[act]
            if not filter then return act end

            local newAct = translate[ filter(owner) ]

            if isnumber(newAct) then
                return newAct
            elseif isstring(newAct) then
                local seq = owner:LookupSequence(newAct)
                if seq then
                    return owner:GetSequenceActivity(seq)
                end
            end
        end
    end

	return act
end