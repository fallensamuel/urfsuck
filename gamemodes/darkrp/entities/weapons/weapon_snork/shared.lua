-- "gamemodes\\darkrp\\entities\\weapons\\weapon_snork\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
SWEP.IsSnork = true

SWEP.Spawnable = true
SWEP.AdminOnly = true

SWEP.Category = 'URF Stalker RP SWEPs'
SWEP.PrintName = 'Лапы Снорка'
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

SWEP.KickCD = 1.5 -- Кулдаун между ударами
SWEP.KickDistance = 200 -- Дистанция атаки
SWEP.KickDamage = 60
SWEP.KickAng = math.cos( math.rad( 40 ) )

SWEP.ResetSpeedDelay = 15

SWEP.SprintCD = 5 -- Кулдаун между бросками
SWEP.SprintStrength = 350
SWEP.SprintDamage = 120
SWEP.SprintSlowPercent = 30 -- на сколько процентов бросок снизит скорость жертве
SWEP.SprintExtraPower = Vector(0, 0, 300) -- Дополнительная сила, применяемая при прыжке (чтобы игрок не тёрся о поверхность)

SWEP.KickAnim = 'stand_attack_0'
SWEP.SprintAnim = 'stand_leap_attack_0'

SWEP.HealingDelay = 1
SWEP.SleepHeal = 5

SWEP.Sounds = {}
SWEP.Sounds.Attack = {'wick/snork/snork_attack_hit_0.ogg', 'wick/snork/snork_attack_hit_1.ogg'}
SWEP.Sounds.Hit = {'npc/zombie/claw_strike1.wav', 'npc/zombie/claw_strike2.wav', 'npc/zombie/claw_strike3.wav'}
SWEP.Sounds.Sprint = {'wick/snork/snork_attack_hit_0.ogg', 'wick/snork/snork_attack_hit_1.ogg'}
SWEP.Sounds.Damage = {'wick/snork/snork_idle_0.ogg', 'wick/snork/snork_idle_1.ogg', 'wick/snork/snork_idle_2.ogg'}

SWEP.ActivityTranslates = {}

SWEP.ActivityTranslates[ACT_LAND] = ACT_RESET
SWEP.ActivityTranslates[ACT_MP_STAND_IDLE] = 'stand_idle_0'
SWEP.ActivityTranslates[ACT_MP_WALK] = 'stand_walk_fwd_0'
SWEP.ActivityTranslates[ACT_MP_RUN] = 'stand_run_0'
SWEP.ActivityTranslates[ACT_MP_CROUCH_IDLE] = 'stand_idle_1'
SWEP.ActivityTranslates[ACT_MP_CROUCHWALK] = 'stand_walk_fwd_0'

function SWEP:Initialize()
end

function SWEP:TranslateActivity( act )
    local owner = self:GetOwner()

    local translate = self.ActivityTranslates[act]
    if translate then
        if isnumber(translate) then
            return translate
        end

        local seq = owner:LookupSequence(translate)
        if seq then
            return owner:GetSequenceActivity(seq)
        end
    end

	return act
end