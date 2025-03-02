-- "gamemodes\\rp_base\\entities\\weapons\\keys\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile();

-- Configuration: ----------------------------------------------
SWEP.PrintName              = "Руки | Ключи";
SWEP.Author                 = "urf.im @ bbqmeowcat";
SWEP.Category               = "RP";
SWEP.SelectorCategory       = translates.Get( "РОЛЕПЛЕЙ" );

SWEP.Spawnable              = true;

SWEP.Primary.ClipSize       = -1;
SWEP.Primary.DefaultClip    = -1;
SWEP.Primary.Automatic      = false;
SWEP.Primary.Ammo           = "none";

SWEP.Secondary.ClipSize     = -1;
SWEP.Secondary.DefaultClip  = -1;
SWEP.Secondary.Automatic    = false;
SWEP.Secondary.Ammo         = "none";

SWEP.WorldModel             = Model( "" );
SWEP.HoldType               = "normal";

SWEP.ViewModel              = Model( "models/weapons/c_keys.mdl" );
SWEP.UseHands               = true;
SWEP.ViewModelFOV           = 40;

SWEP.Slot                   = 0;
SWEP.SlotPos                = 0;

SWEP.fl_Distance            = 100;
SWEP.fl_Delay               = 1;

-- Utilities: -------------------------------------------------------
AccessorFunc( SWEP, "fl_NextReload", "NextReloadFire", FORCE_NUMBER );

function SWEP:SendAnimToClient( act )
    local owner = self:GetOwner();
    if not IsValid( owner ) then return end

    net.Start( "SendAnimToClientNet" );
        net.WriteEntity( owner );
        net.WriteUInt( act, 12 );
    net.SendPVS( owner:GetPos() );
    owner:AnimRestartGesture( GESTURE_SLOT_ATTACK_AND_RELOAD, act, true );
end

function SWEP:SetNextWeaponFire( nextFire )
    self:SetNextPrimaryFire( nextFire );
    self:SetNextSecondaryFire( nextFire );
    self:SetNextReloadFire( nextFire );
end

function SWEP:GetTarget()
    local owner = self:GetOwner();
    if not IsValid( owner ) then return end

    local eyepos, aimvec = owner:GetShootPos(), owner:GetAimVector();

    local tr = util.TraceLine( {
        start = eyepos,
        endpos = eyepos + aimvec * self.fl_Distance,
        filter = owner
    } );

    return tr.Entity
end

-- Core: -------------------------------------------------------
function SWEP:Initialize()
    self:Deploy();
end

function SWEP:Holster()
    self:SetHoldType( self.HoldType );
    return true
end

function SWEP:PrimaryAttack()
    self:SetNextWeaponFire( CurTime() + self.fl_Delay );
    hook.Run( "OnKeysPrimary", self, self:GetTarget(), false );
end

function SWEP:SecondaryAttack()
    self:SetNextWeaponFire( CurTime() + self.fl_Delay );
    hook.Run( "OnKeysSecondary", self, self:GetTarget(), true );
end

function SWEP:Reload()
    if (self:GetNextReloadFire() or 0) > CurTime() then return end
    self:SetNextWeaponFire( CurTime() + self.fl_Delay );
    hook.Run( "OnKeysReload", self, self:GetTarget() );
end

-- Includes: ---------------------------------------------------
include( "modules/doors.lua" );
include( "modules/pickup.lua" );
include( "modules/gestures.lua" );