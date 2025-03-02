AddCSLuaFile()
DEFINE_BASECLASS("base_ore_node")
ENT.Spawnable = true
ENT.PrintName = 'Месторождение меди'
ENT.Category = 'Mining'
ENT.AdminOnly	= true
ENT.Model = 'models/props_wasteland/rockgranite03c.mdl'

--ENT.Ores = {"ore_copper"}

ENT.MaxHealth = 60
ENT.RechargeTime = 120

ENT.DamageIncomeMultiplayer = 0.04