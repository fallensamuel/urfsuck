-- "gamemodes\\darkrp\\entities\\entities\\rpitem_printerbooster_4.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local AddCSLuaFile = AddCSLuaFile


AddCSLuaFile()

ENT.Base = "base_simpleprinterbooster"
ENT.PrintName = "Военный Бустер"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AdminOnly = true

ENT.PrinterSpeedMultiplier = 1
ENT.FireChanceMultiplier   = 4
ENT.BoostDuration          = 600
ENT.RateMultiplier         = 3.5

ENT.BoosterModel = "models/2rek/lithium_printers_2/lp2_storage3.mdl"

ENT.IsPrinterBooster = true

ENT.BoostColor = {70, 30, 180}

ENT.BoostedSoundDuration = 1
