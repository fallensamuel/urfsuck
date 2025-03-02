-- "gamemodes\\darkrp\\entities\\weapons\\weapon_tushkan\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
SWEP.IsTushkan = true

SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Category = 'URF Stalker RP SWEPs'
SWEP.PrintName = 'Лапы Тушкана'
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
SWEP.KickDamage = 35
SWEP.KickAng = math.cos( math.rad( 40 ) )

SWEP.ResetSpeedDelay = 60

SWEP.SprintStrength = 350
SWEP.SprintDamage = 80
SWEP.SprintSlowPercent = 15 -- на сколько процентов бросок снизит скорость жертве

SWEP.HealingDelay = 1
SWEP.SleepHeal = 5

SWEP.IdleSoundDelay = 5

SWEP.Sounds = {}
SWEP.Sounds.Idle = {'npc/tushkan/tushkano_aggressive_0.ogg', 'npc/tushkan/tushkano_aggressive_1.ogg', 'npc/tushkan/tushkano_aggressive_2.ogg', 'npc/tushkan/tushkano_aggressive_3.ogg'}
SWEP.Sounds.Attack = {'npc/tushkan/tushkano_attack_0.ogg', 'npc/tushkan/tushkano_attack_1.ogg'}
SWEP.Sounds.Hit = {'npc/zombie/claw_strike1.wav', 'npc/zombie/claw_strike2.wav', 'npc/zombie/claw_strike3.wav'}
SWEP.Sounds.Sprint = {'npc/tushkan/tushkano_threaten_1.ogg', 'npc/tushkan/tushkano_threaten_2.ogg', 'npc/tushkan/tushkano_threaten_3.ogg'}
SWEP.Sounds.Damage = {'npc/tushkan/tushkano_pain_0.ogg', 'npc/tushkan/tushkano_pain_1.ogg', 'npc/tushkan/tushkano_pain_2.ogg', 'npc/tushkan/tushkano_pain_3.ogg'}

SWEP.ActivityTranslates = {}
SWEP.SpecialActivitiesFilters = {}

SWEP.ActivityTranslates[ACT_LAND] = ACT_RESET
SWEP.ActivityTranslates[ACT_MP_STAND_IDLE] = {'stand_idle_0', 'stand_idle_dmg_0'}
SWEP.ActivityTranslates[ACT_MP_WALK] = 'stand_ran_dmg_0'
SWEP.ActivityTranslates[ACT_MP_RUN] = 'stand_run_0'
SWEP.ActivityTranslates[ACT_MP_CROUCH_IDLE] = 'sleep_idle_0'
SWEP.ActivityTranslates[ACT_MP_CROUCHWALK] = 'stand_ran_dmg_0'

SWEP.SpecialActivitiesFilters[ACT_MP_STAND_IDLE] = function(owner)
    local hp = owner:Health()

    if hp <= 20 then
        return 2
    else
        return 1
    end
end

function SWEP:Initialize()
end

function SWEP:TranslateActivity( act )
    local owner = self:GetOwner()
    if IsValid(owner) then
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
                if filter then
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
        end
    end

	return act
end