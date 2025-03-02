-- "gamemodes\\darkrp\\entities\\entities\\ent_cloth_exopers.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Base = "ent_base_cloth"

ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.AdminOnly = true

ENT.PrintName = "Бронекостюм Булат3м"

ENT.Model = "models/stalkertnb/outfits/exo_dave.mdl"
ENT.EquipModel = "models/tnb/stalker/male_cs2_helmet.mdl"
ENT.AnomalyResistance = .2
ENT.CostumeArmor = 400