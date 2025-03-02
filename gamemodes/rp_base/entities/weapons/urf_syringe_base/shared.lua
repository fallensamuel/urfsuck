-- "gamemodes\\rp_base\\entities\\weapons\\urf_syringe_base\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
WEAPON_SYRINGE_MAP = WEAPON_SYRINGE_MAP or {};
WEAPON_SYRINGE_IDX = WEAPON_SYRINGE_IDX or {};


local SWEP = SWEP or {};

SWEP.Category               = "[urf.im] Инъекции";
SWEP.PrintName              = "Syringe (Base)";

SWEP.Author                 = "[urf.im] @bbqmeowcat";
SWEP.Purpose                = "N/A";

SWEP.Spawnable              = false;
SWEP.AdminOnly              = true;

SWEP.HoldType               = "slam";
SWEP.ViewModel              = "models/weapons/urf/c_multipsyringe.mdl";
SWEP.ViewModelFOV           = 70;
SWEP.WorldModel             = "models/weapons/urf/w_multipsyringe.mdl";
SWEP.UseHands               = true;

SWEP.Primary.ClipSize		= -1;
SWEP.Primary.DefaultClip	= 1;
SWEP.Primary.Automatic		= false;
SWEP.Primary.Ammo           = "urf_syringe_base";

SWEP.Secondary.ClipSize     = -1;
SWEP.Secondary.DefaultClip  = -1;
SWEP.Secondary.Automatic    = false;
SWEP.Secondary.Ammo         = "none";

SWEP.Slot			        = 0;
SWEP.SlotPos			    = 0;

SWEP.DrawAmmo			    = true;
SWEP.DrawCrosshair		    = true;

SWEP.SkinID                 = 0;

SWEP.NotifyMessage          = {
    "Вы вкололи себе что-то странное",
    "Вам вкололи что-то странное!",
};


sound.Add( {
    name       = "syringe.slide",
    channel    = CHAN_ITEM,
    soundlevel = SNDLVL_NORM,
    sound      = "weapons/syringe_slide.wav"
} );

sound.Add( {
    name       = "syringe.click",
    channel    = CHAN_ITEM,
    soundlevel = SNDLVL_NORM,
    sound      = "weapons/syringe_click.wav"
} );

sound.Add( {
    name       = "syringe.inject",
    channel    = CHAN_WEAPON,
    soundlevel = SNDLVL_GUNFIRE,
    sound      = "weapons/syringe_inject.wav"
} );


--[[
local weapons_OnLoaded = weapons.OnLoaded;
weapons.OnLoaded = function()
    for _, wep in pairs( weapons.GetList() ) do
        if (wep.ClassName == "urf_syringe_base") or (wep.Base == "urf_syringe_base") then
            local id = table.Count(WEAPON_SYRINGE_IDX) + 1;

            WEAPON_SYRINGE_IDX[id]            = wep.ClassName;
            WEAPON_SYRINGE_MAP[wep.ClassName] = id;

            wep.Primary.Ammo = wep.Primary.Ammo or wep.ClassName;
            game.AddAmmoType( {name = wep.Primary.Ammo, dmgtype = DMG_DIRECT} );

            if CLIENT then
                language.Add( wep.Primary.Ammo .. "_ammo", wep.PrintName );
            end
        end
    end
    
    weapons_OnLoaded();
    weapons.OnLoaded = weapons_OnLoaded;
end
]]--

hook.Add( "PreRegisterSWEP", "urf.Syringes::Register", function( wep, class )
    if (class == "urf_syringe_base") or (wep.Base == "urf_syringe_base") then
        local id = table.Count(WEAPON_SYRINGE_IDX) + 1;

        WEAPON_SYRINGE_IDX[id]    = class;
        WEAPON_SYRINGE_MAP[class] = id;

        wep.Primary.Ammo = wep.Primary.Ammo or class;
        game.AddAmmoType( {name = wep.Primary.Ammo, dmgtype = DMG_DIRECT} );

        if CLIENT then
            language.Add( wep.Primary.Ammo .. "_ammo", wep.PrintName );
        end
    end
end );


function SWEP:Initialize()
    self:SetHoldType( self.HoldType );
    self:SetSkin( self.SkinID );
end