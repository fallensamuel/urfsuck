-- "gamemodes\\darkrp\\entities\\entities\\ent_cloth_buran.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Base = "ent_base_cloth"

ENT.Spawnable = true
ENT.AdminSpawnable = false
ENT.AdminOnly = true

ENT.PrintName = "Бронекостюм Буран"

ENT.Model = "models/stalkertnb2/outfits/io7a_merc2.mdl"
ENT.EquipModel = "models/stalker_greh/greh_gear/greh_gear.mdl"

ENT.CostumeSkin = 1

ENT.CostumeBodygroups = {
  [1] = 2,
}

ENT.CostumeSpeed = 325
ENT.CostumeArmor = 300