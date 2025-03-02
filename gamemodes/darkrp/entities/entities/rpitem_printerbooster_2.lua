-- "gamemodes\\darkrp\\entities\\entities\\rpitem_printerbooster_2.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local AddCSLuaFile = AddCSLuaFile


AddCSLuaFile()

ENT.Base = "base_simpleprinterbooster"
ENT.PrintName = "Самодельный Бустер"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AdminOnly = true

ENT.PrinterSpeedMultiplier = 0.75
ENT.FireChanceMultiplier   = 2.5
ENT.BoostDuration          = 450
ENT.RateMultiplier         = 1

ENT.BoosterModel = "models/2rek/lithium_printers_2/lp2_storage2.mdl"

ENT.IsPrinterBooster = true

ENT.BoostColor = {240,128,128}

ENT.BoostedSoundDuration = 1
