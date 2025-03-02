-- "gamemodes\\darkrp\\entities\\weapons\\weapon_zombie_kamikadze\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
SWEP.IsZombieKamikadze = true

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Category = 'URF Stalker RP SWEPs'
SWEP.PrintName = 'Руки Зомби Камикадзе'
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
SWEP.KickDamage = 40
SWEP.KickSlowSpeedPercent = 10
SWEP.KickAng = math.cos( math.rad( 40 ) )

SWEP.ResetSpeedDelay = 15

SWEP.ExplosionRadius = 650
SWEP.ExplosionDamage = 600

SWEP.HealingDelay = 1
SWEP.SleepHeal = 5

SWEP.IdleSoundDelay = 5

-- SWEP.ResetSpeedDelay = 60

SWEP.Sounds = {}
SWEP.Sounds.Idle = {'npc/zombie/zombie_idle_2.ogg','npc/zombie/zombie_idle_3.ogg','npc/zombie/zombie_idle_4.ogg','npc/zombie/zombie_idle_5.ogg','npc/zombie/zombie_idle_6.ogg','npc/zombie/zombie_idle_7.ogg','npc/zombie/zombie_idle_8.ogg','npc/zombie/zombie_idle_9.ogg',}
SWEP.Sounds.Attack = {'npc/zombie/zombie_attack_1.ogg','npc/zombie/zombie_attack_2.ogg','npc/zombie/zombie_attack_3.ogg','npc/zombie/zombie_attack_4.ogg','npc/zombie/zombie_attack_5.ogg','npc/zombie/zombie_attack_6.ogg','npc/zombie/zombie_attack_7.ogg',}
SWEP.Sounds.Hit = {'npc/zombie/claw_strike1.wav', 'npc/zombie/claw_strike2.wav', 'npc/zombie/claw_strike3.wav'}
SWEP.Sounds.Explode = {'npc/controller/controller_psy_hit_l.ogg'}
SWEP.Sounds.Damage = {'npc/zombie/zombie_take_damage_1.ogg','npc/zombie/zombie_take_damage_2.ogg','npc/zombie/zombie_take_damage_3.ogg','npc/zombie/zombie_take_damage_4.ogg','npc/zombie/zombie_take_damage_5.ogg',}

SWEP.ActivityTranslates = {}
SWEP.SpecialActivitiesFilters = {}

SWEP.ActivityTranslates[ACT_LAND] = ACT_RESET
SWEP.ActivityTranslates[ACT_MP_STAND_IDLE] = 'stand_idle_1'
SWEP.ActivityTranslates[ACT_MP_WALK] = 'stand_walk_fwd_1'
SWEP.ActivityTranslates[ACT_MP_RUN] = 'stand_run_4'
SWEP.ActivityTranslates[ACT_MP_CROUCH_IDLE] = 'stabd_idle_5'
SWEP.ActivityTranslates[ACT_MP_CROUCHWALK] = 'stand_walk_fwd_1'

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