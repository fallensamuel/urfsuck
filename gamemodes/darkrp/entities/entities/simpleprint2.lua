-- "gamemodes\\darkrp\\entities\\entities\\simpleprint2.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local AddCSLuaFile = AddCSLuaFile

AddCSLuaFile()

ENT.Base = "base_simpleprinter_money"
ENT.PrintName = "Обычный Майнер"
ENT.Category = "[urf] Принтеры"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AdminOnly	= true
ENT.PrinterModel = "models/urf/bitminer_1.mdl"
ENT.ResourceName = false

ENT.PrinterSpeed = 3
ENT.Rate = 10
ENT.MaxMoney = 4500
ENT.FireChance = 15
ENT.FireDuration = 300
ENT.FireCooldown = 300

ENT.InterfaceOffset = 50
