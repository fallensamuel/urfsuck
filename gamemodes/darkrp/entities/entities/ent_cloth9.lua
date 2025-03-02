-- "gamemodes\\darkrp\\entities\\entities\\ent_cloth9.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Base = "ent_base_cloth"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.PrintName = "Уплотненный Экзоскелет"

ENT.Model = "models/player/stalker_lone/lone_exo/lone_exo.mdl"
ENT.EquipModel = "models/player/stalker_lone/lone_exo/lone_exo.mdl"
ENT.CostumeHealth = 200
ENT.CostumeArmor = 550
ENT.CostumeSpeed = 270
ENT.AnomalyResistance = .25
ENT.IsExoskeleton = true