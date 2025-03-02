-------------------------------------
---------------- Cuffs --------------
-------------------------------------
-- Copyright (c) 2015 Nathan Healy --
-------- All rights reserved --------
-------------------------------------
-- weapon_cuff_elastic.lua  SHARED --
--                                 --
-- Elastic handcuffs.              --
-------------------------------------

AddCSLuaFile()

SWEP.Base = "weapon_cuff_base"

SWEP.Category = "Наручники"
SWEP.Author = "my_hat_stinks"
SWEP.Instructions = "Stretchable restraint."

SWEP.Spawnable = true
--SWEP.AdminOnly = true
SWEP.AdminSpawnable = true

SWEP.Slot = 3
SWEP.PrintName = "Наручники"

//
// Handcuff Vars
SWEP.CuffTime = 0 // Seconds to handcuff
SWEP.CuffSound = Sound( "buttons/lever7.wav" )

SWEP.CuffMaterial = "phoenix_storms/gear"
SWEP.CuffRope = "cable/cable2"
SWEP.CuffStrength = 0.9
SWEP.CuffRegen = 1.6
SWEP.RopeLength = 45
SWEP.CuffReusable = true

SWEP.CuffBlindfold = false
SWEP.CuffGag = false

SWEP.CuffStrengthVariance = 0.1 // Randomise strangth
SWEP.CuffRegenVariance = 0.3 // Randomise regen
