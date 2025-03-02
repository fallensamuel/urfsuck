AddCSLuaFile()
DEFINE_BASECLASS("base_ore_node")
ENT.Spawnable = true
ENT.PrintName = 'Большой камень'
ENT.Category = 'Mining'
ENT.AdminOnly	= true
ENT.Model = 'models/props_canal/rock_riverbed02c.mdl'

--ENT.Ores = {"ore_stone", "ore_stone", "ore_copper"}

ENT.MaxHealth = 100
ENT.RechargeTime = 60

ENT.DamageIncomeMultiplayer = 0.01

ENT.Vec = Vector(0,0,60)