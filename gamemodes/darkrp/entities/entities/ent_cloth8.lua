-- "gamemodes\\darkrp\\entities\\entities\\ent_cloth8.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Base = "ent_base_cloth"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.PrintName = "Камуфляжная Заря"

ENT.Model = "models/player/stalker_lone/lone_old/lone_old.mdl"
ENT.EquipModel = "models/player/stalker_lone/lone_old/lone_old.mdl"

ENT.CostumeArmor = 225
--ENT.CostumeSpeed = 320
ENT.AnomalyResistance = .2