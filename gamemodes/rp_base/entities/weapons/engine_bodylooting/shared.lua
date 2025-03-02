-- "gamemodes\\rp_base\\entities\\weapons\\engine_bodylooting\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
BODYLOOTING_DIST_REACH_SQR = math.pow( 42, 2 );

BODYLOOTING_ID_STATE  = 0;
BODYLOOTING_ID_TARGET = 1;
BODYLOOTING_ID_INFO   = 2;
BODYLOOTING_ID_ANIM   = 3;

BODYLOOTING_STATE_UNKNOWN = 0;
BODYLOOTING_STATE_WALKUP  = 1;
BODYLOOTING_STATE_CROUCH  = 2;
BODYLOOTING_STATE_FINISH  = 3;

----------------------------------------------------------------
SWEP.PrintName              = "Обыск игрока";
SWEP.Category               = "RP";
SWEP.Author                 = "bbqmeowcat @ urf.im";

SWEP.Slot                   = 0;
SWEP.SlotPos                = 0;

SWEP.Spawnable              = false;
SWEP.AdminOnly              = true;

SWEP.ViewModel              = Model( "models/ventrische/c_vrbodylooting.mdl" );
SWEP.WorldModel             = "";
SWEP.ViewModelFOV           = 74;
SWEP.UseHands               = true;
SWEP.DrawCrosshair          = false;

SWEP.Primary.ClipSize       = -1;
SWEP.Primary.DefaultClip    = -1;
SWEP.Primary.Automatic      = false;
SWEP.Primary.Ammo           = "none";

SWEP.Secondary.ClipSize     = -1;
SWEP.Secondary.DefaultClip  = -1;
SWEP.Secondary.Automatic    = false;
SWEP.Secondary.Ammo         = "none";

SWEP.Timeout                = 5;

----------------------------------------------------------------
function SWEP:GetState()
    return self.i_State;
end

function SWEP:GetTarget()
    return self.m_Target;
end

function SWEP:GetInformation()
    return self.s_Information
end

function SWEP:LookupPosition()
    local target = self:GetTarget();

    if not IsValid( target ) then
        local owner = self:GetOwner();
        return owner:EyePos() + owner:GetAimVector(); -- ew
    end

    if not self.m_iLookupTargetBone then
        self.m_iLookupTargetBone = 0;

        for b = 0, target:GetBoneCount() - 1 do
            if string.find( string.lower(target:GetBoneName(b)), "spine2" ) then
                self.m_iLookupTargetBone = b;
            end
        end
    end

    return target:GetBoneMatrix( self.m_iLookupTargetBone ):GetTranslation() + vector_up * 12;
end

function SWEP:Initialize()
    self:SetHoldType( "normal" );
end

function SWEP:Holster()
    return false
end

function SWEP:PrimaryAttack()
end

function SWEP:SecondaryAttack()
end