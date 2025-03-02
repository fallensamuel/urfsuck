AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Base = "ammo_bonuses_base"

ENT.PrintName = "Снаряжение Повстанцев"
ENT.Category = "Half-Life Alyx RP"

ENT.Spawnable = true
ENT.AdminSpawnable = true

ENT.Model = "models/props_marines/ammocrate01_static.mdl"
ENT.Term = 'AmmoNotRebel'
ENT.Factions = {
	[FACTION_REBEL] = true,
}
