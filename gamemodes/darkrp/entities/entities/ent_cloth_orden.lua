-- "gamemodes\\darkrp\\entities\\entities\\ent_cloth_orden.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Base = "ent_base_cloth"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.PrintName = "Одежда Ордена"

ENT.Model = "models/stalkertnb2/outfits/sunrise_loner.mdl"
ENT.EquipModel = "models/stalkertnb2/sunrise_symmetry.mdl"
ENT.AnomalyResistance = .25
ENT.CostumeArmor = 200
ENT.CostumeSpeed = 325