-- "gamemodes\\darkrp\\entities\\entities\\simpleprint1.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local AddCSLuaFile = AddCSLuaFile

AddCSLuaFile()

ENT.Base = "base_simpleprinter_money"
ENT.PrintName = "Кустарный Принтер"
ENT.Category = "[urf] Принтеры"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AdminOnly	= true
ENT.PrinterModel = "models/urf/bitminer_2.mdl"
ENT.ResourceName = false

ENT.PrinterSpeed = 3
ENT.Rate = 5
ENT.MaxMoney = 3000
ENT.FireChance = 25
ENT.FireDuration = 300
ENT.FireCooldown = 300

ENT.InterfaceOffset = 30
