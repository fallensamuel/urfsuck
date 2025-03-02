-- "gamemodes\\darkrp\\entities\\entities\\simpleprint4.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local AddCSLuaFile = AddCSLuaFile

AddCSLuaFile()

ENT.Base = "base_simpleprinter_money"
ENT.PrintName = "Секретный Майнер"
ENT.Category = "[urf] Принтеры"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AdminOnly	= true
ENT.PrinterModel = "models/urf/bitminer_urf.mdl"

ENT.ResourceName = false
ENT.PrinterSpeed = 3
ENT.Rate = 20
ENT.MaxMoney = 9000
ENT.FireChance = 5
ENT.FireDuration = 420
ENT.FireCooldown = 300

ENT.InterfaceOffset = 95
