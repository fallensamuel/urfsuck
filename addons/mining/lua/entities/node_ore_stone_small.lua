AddCSLuaFile()
DEFINE_BASECLASS("base_ore_node")
ENT.Spawnable = true
ENT.PrintName = 'Маленький камень'
ENT.Category = 'Mining'
ENT.AdminOnly	= true
ENT.Model = 'models/props_canal/rock_riverbed02b.mdl'

--ENT.Ores = {"ore_stone", "ore_stone", "ore_stone", "ore_stone", "ore_stone"}

ENT.MaxHealth = 40
ENT.RechargeTime = 30

ENT.DamageIncomeMultiplayer = 0.01