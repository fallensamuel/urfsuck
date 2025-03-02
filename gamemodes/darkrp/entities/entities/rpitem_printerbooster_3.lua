-- "gamemodes\\darkrp\\entities\\entities\\rpitem_printerbooster_3.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local AddCSLuaFile = AddCSLuaFile


AddCSLuaFile()

ENT.Base = "base_simpleprinterbooster"
ENT.PrintName = "Научный Бустер"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AdminOnly = true

ENT.PrinterSpeedMultiplier = 0.6
ENT.FireChanceMultiplier   = 2
ENT.BoostDuration          = 400
ENT.RateMultiplier         = 1

ENT.BoosterModel = "models/2rek/lithium_printers_2/lp2_storage3.mdl"

ENT.IsPrinterBooster = true

ENT.BoostColor = {144, 238, 144}

ENT.BoostedSoundDuration = 1
