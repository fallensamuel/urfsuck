-------------------------------------
---------------- Cuffs --------------
-------------------------------------
-- Copyright (c) 2015 Nathan Healy --
-------- All rights reserved --------
-------------------------------------
-- weapon_cuff_standard.lua SHARED --
--                                 --
-- Rope handcuffs.                 --
-------------------------------------

AddCSLuaFile()

SWEP.Base = "weapon_cuff_base"

SWEP.Category = "Наручники"
SWEP.Author = "my_hat_stinks"
SWEP.Instructions = "A weak restraint."

SWEP.Spawnable = true
--SWEP.AdminOnly = true
SWEP.AdminSpawnable = true

SWEP.Slot = 3
SWEP.PrintName = "Веревка"

//
// Handcuff Vars
SWEP.CuffTime = 0 // Seconds to handcuff
SWEP.CuffSound = Sound( "buttons/lever7.wav" )

SWEP.CuffMaterial = "models/props_foliage/tree_deciduous_01a_trunk"
SWEP.CuffRope = "cable/rope"
SWEP.CuffStrength = 0.85
SWEP.CuffRegen = 0.8
SWEP.RopeLength = 75
SWEP.CuffReusable = false

SWEP.CuffBlindfold = false
SWEP.CuffGag = false

SWEP.CuffStrengthVariance = 0.1 // Randomise strangth
SWEP.CuffRegenVariance = 0.2 // Randomise regen
