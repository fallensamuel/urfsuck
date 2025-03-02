-- "gamemodes\\darkrp\\entities\\entities\\simpleprint3.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local AddCSLuaFile = AddCSLuaFile

AddCSLuaFile()

ENT.Base = "base_simpleprinter_money"
ENT.PrintName = "Улучшенный Майнер"
ENT.Category = "[urf] Принтеры"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AdminOnly	= true
ENT.PrinterModel = "models/urf/bitminer_3.mdl"
ENT.ResourceName = false

ENT.PrinterSpeed = 3
ENT.Rate = 15
ENT.MaxMoney = 6000
ENT.FireChance = 10
ENT.FireDuration = 360
ENT.FireCooldown = 300

ENT.InterfaceOffset = 65
