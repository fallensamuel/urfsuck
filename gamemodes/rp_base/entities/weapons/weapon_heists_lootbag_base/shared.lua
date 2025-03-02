SWEP.PrintName             = "Сумка (база)";
SWEP.Category              = "[urf] Ограбления";

SWEP.DrawWeaponInfoBox     = false;

SWEP.Spawnable             = false;
SWEP.AdminOnly             = false;

SWEP.Primary.ClipSize      = -1;
SWEP.Primary.DefaultClip   = -1;
SWEP.Primary.Automatic     = false;
SWEP.Primary.Ammo          = "none";

SWEP.Secondary.ClipSize    = -1;
SWEP.Secondary.DefaultClip = -1;
SWEP.Secondary.Automatic   = false;
SWEP.Secondary.Ammo        = "none";

SWEP.Weight                = 1;

SWEP.AutoSwitchTo          = true;
SWEP.AutoSwitchFrom        = false;

SWEP.Slot                  = 0;
SWEP.SlotPos               = 0;

SWEP.DrawAmmo              = false;
SWEP.DrawCrosshair         = false;

SWEP.WorldModel            = "models/jessev92/payday2/item_bag_loot_jb.mdl";
SWEP.ViewModel             = "models/jessev92/payday2/item_bag_loot_jb.mdl";
SWEP.UseHands              = false;

SWEP.ShootSound            = Sound( "HealthKit.Touch" ); --Sound("physics/cardboard/cardboard_box_break3.wav");

-- HoldType:
    SWEP.TranslateActs = {
        [ACT_MP_STAND_IDLE]                = ACT_HL2MP_IDLE_KNIFE,
        [ACT_MP_WALK]                      = ACT_HL2MP_IDLE_KNIFE + 1,
        [ACT_MP_RUN]                       = ACT_HL2MP_IDLE_KNIFE + 2,
        [ACT_MP_CROUCH_IDLE]               = ACT_HL2MP_IDLE_KNIFE + 3,
        [ACT_MP_CROUCHWALK]                = ACT_HL2MP_IDLE_KNIFE + 4,
        [ACT_MP_ATTACK_STAND_PRIMARYFIRE]  = ACT_HL2MP_IDLE_KNIFE + 5,
        [ACT_MP_ATTACK_CROUCH_PRIMARYFIRE] = ACT_HL2MP_IDLE_KNIFE + 5,
        [ACT_MP_RELOAD_STAND]              = ACT_GMOD_GESTURE_MELEE_SHOVE_2HAND,
        [ACT_MP_RELOAD_CROUCH]             = ACT_GMOD_GESTURE_ITEM_THROW,
        [ACT_MP_JUMP]                      = ACT_HL2MP_JUMP_SLAM,
        [ACT_MP_SWIM]                      = ACT_HL2MP_IDLE_KNIFE + 9,
        [ACT_LAND]                         = ACT_LAND,
    };

    function SWEP:TranslateActivity( act )
        return self.TranslateActs[act] or act;
    end


--
    SWEP.ValueCapacity = 10000;
    SWEP.TakeAmount    = 100;

    function SWEP:GetValueCapacity()
        return self.ValueCapacity
    end

    function SWEP:GetValue()
        return self:GetNWInt( "value" );
    end