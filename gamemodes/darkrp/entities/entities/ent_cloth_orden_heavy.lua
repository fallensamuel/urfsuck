-- "gamemodes\\darkrp\\entities\\entities\\ent_cloth_orden_heavy.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Base = "ent_base_cloth"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.PrintName = "Скат 9о Ордена"

ENT.Model = "models/player/stalker_lone/lone_bulat/lone_bulat.mdl"
ENT.EquipModel = "models/player/stalker_lone/lone_bulat/lone_bulat.mdl" --models/tnb/stalker/male_skat_exo.mdl
--ENT.CostumeSkin = 8 --4
ENT.CostumeHealth = 100
ENT.CostumeArmor = 350
ENT.CostumeSpeed = 320
ENT.AnomalyResistance = .3