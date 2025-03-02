AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Base = "ammo_bonuses_base"

ENT.PrintName = "Снаряжение Альянса"
ENT.Category = "Half-Life Alyx RP"

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Model = "models/items/ammocrate_smg1.mdl"
ENT.Term = 'AmmoNotAlliance'
ENT.Factions = {
	[FACTION_MPF] = true,
	[FACTION_HELIX] = true,
	[FACTION_CMD] = true,
	[FACTION_OTA] = true,
	[FACTION_GRID] = true,
}
