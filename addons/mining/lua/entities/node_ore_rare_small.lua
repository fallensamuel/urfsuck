AddCSLuaFile()
DEFINE_BASECLASS("base_ore_node")
ENT.Spawnable = true
ENT.PrintName = 'Редкое месторождение руды'
ENT.Category = 'Mining'
ENT.AdminOnly	= true
ENT.Model = 'models/rarerocks/crystal1.mdl'

--ENT.Ores = {"ore_silver", "ore_silver", "ore_silver", "ore_gold"}

ENT.MaxHealth = 70
ENT.RechargeTime = 300

ENT.DamageIncomeMultiplayer = 3