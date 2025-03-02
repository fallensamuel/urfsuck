-- "gamemodes\\rp_base\\entities\\weapons\\weapon_ufim_pee\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
SWEP.Category                   = "RP";

SWEP.PrintName                  = "Pee";
SWEP.Author                     = "urf.im @ bbqmeowcat";
SWEP.Instructions               = "ЛКМ - писать";

SWEP.Spawnable                  = true;
SWEP.AdminOnly                  = true;

SWEP.DrawCrosshair              = false;
SWEP.DrawAmmo                   = true;

SWEP.Weight                     = 0;
SWEP.Slot                       = 0;
SWEP.SlotPos                    = 0;

SWEP.ViewModelFOV               = 1;
SWEP.ViewModel                  = "models/weapons/c_arms_citizen.mdl";
SWEP.WorldModel                 = "";

SWEP.HoldType                   = "normal";
SWEP.UseHands                   = false;

-- Моча:
SWEP.Primary.ClipSize           = -1;
SWEP.Primary.Automatic          = true;
SWEP.Primary.Ammo               = "pee";
SWEP.Primary.DefaultClip        = 100;
SWEP.Primary.Delay              = 0.25;     -- 0.25 s
SWEP.Primary.RestoreCooldown    = 60;       -- 1 mi
SWEP.Primary.RestoreDelay       = 1;        -- 1 s

-- Говно:
SWEP.Secondary.ClipSize         = -1;
SWEP.Secondary.Automatic        = false;
SWEP.Secondary.Ammo             = "poo";
SWEP.Secondary.DefaultClip      = 3;
SWEP.Secondary.Delay            = 30;       -- 30 s
SWEP.Secondary.RestoreCooldown  = 300;      -- 5 mi
SWEP.Secondary.RestoreDelay     = 300;      -- 5 mi

-- Отдельные настройки мочи:
SWEP.Pee                        = {};
SWEP.Pee.Delay                  = 0.02;
SWEP.Pee.Gravity                = Vector( 0, 0, -1 ) * 600;
SWEP.Pee.Particle               = "effects/slime1";

-- Звуки:
SWEP.Sounds                     = {};
SWEP.Sounds.Zip                 = "piss/zipperup.wav";
SWEP.Sounds.Unzip               = "piss/zipperdown.wav";


----------------------------------------------------------------
game.AddAmmoType( { name = "pee", dmgtype = DMG_ACID } );
game.AddAmmoType( { name = "poo", dmgtype = DMG_RADIATION } );

function SWEP:SetupDataTables()
    self:NetworkVar( "Bool", 0, "IsPeeing" );
end


----------------------------------------------------------------
function SWEP:Initialize()
    self.TimerIDPrimary   = self:GetClass() .. self:EntIndex() .. "primary";
    self.TimerIDSecondary = self:GetClass() .. self:EntIndex() .. "secondary";

    self:SetHoldType( self.HoldType );
end


function SWEP:Deploy()
    self.TimerIDPrimary   = self:GetClass() .. self:EntIndex() .. "primary";
    self.TimerIDSecondary = self:GetClass() .. self:EntIndex() .. "secondary";
    
    self:EmitSound( self.Sounds.Unzip );
    return true
end


function SWEP:Holster()
    if SERVER then
        if self:GetIsPeeing() then self:EndPeeing(); end
    end

    self:EmitSound( self.Sounds.Zip );
    return true
end


function SWEP:OnRemove()
    if SERVER then
        if self:GetIsPeeing() then self:EndPeeing(); end
    end
    
    self:EmitSound( self.Sounds.Zip );
end