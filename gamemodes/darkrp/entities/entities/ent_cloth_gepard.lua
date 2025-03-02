-- "gamemodes\\darkrp\\entities\\entities\\ent_cloth_gepard.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Base = "ent_base_cloth"

ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.AdminOnly = true

ENT.PrintName = "Экзоскелет Гепард"

ENT.Model = "models/stalkertnb/outfits/exo_dave.mdl"
ENT.EquipModel = "models/tnb/stalker/male_skat_exo.mdl"
ENT.CostumeSkin = 2
ENT.CostumeSpeed = 325