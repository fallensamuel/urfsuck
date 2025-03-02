-- "gamemodes\\darkrp\\entities\\entities\\ent_cloth7.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Base = "ent_base_cloth"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.PrintName = "Одежда 7"

ENT.Model = "models/player/stalker_lone/lone_sunrise_proto/lone_sunrise_proto.mdl"
ENT.EquipModel = "models/player/stalker_lone/lone_sunrise_proto/lone_sunrise_proto.mdl"

ENT.AnomalyResistance = .15
ENT.CostumeHealth = 200
ENT.CostumeArmor = 450
ENT.CostumeSpeed = 290
ENT.IsExoskeleton = true