AddCSLuaFile()
DEFINE_BASECLASS("base_ore_node")
ENT.Spawnable = true
ENT.PrintName = 'Месторождение серебра'
ENT.Category = 'Mining'
ENT.AdminOnly	= true
ENT.Model = 'models/props_debris/concrete_spawnchunk001a.mdl'

--ENT.Ores = {"ore_silver"}

ENT.MaxHealth = 100
ENT.RechargeTime = 180

ENT.DamageIncomeMultiplayer = 0.06