-- "gamemodes\\rp_base\\entities\\weapons\\weapon_medkit_fast.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
DEFINE_BASECLASS 'weapon_medkit'
AddCSLuaFile()

SWEP.SelectorCategory		= translates.Get("РОЛЕПЛЕЙ")
SWEP.PrintName = "Аптечка ГО"
SWEP.Author = "robotboy655 & MaxOfS2D"
SWEP.Purpose = "Левая кнопка мыши - вылечить игрока, правая мыши - себя."

SWEP.HealAmount = 50 -- Maximum heal amount per use
SWEP.MaxAmmo = 100 -- Maxumum ammo

SWEP.Spawnable = false