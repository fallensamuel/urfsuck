-- "gamemodes\\darkrp\\entities\\entities\\rpitem_printerbooster_1.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local AddCSLuaFile = AddCSLuaFile


AddCSLuaFile()

ENT.Base = "base_simpleprinterbooster"
ENT.PrintName = "Нелегальный Бустер"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AdminOnly = true

ENT.PrinterSpeedMultiplier = 0.80
ENT.FireChanceMultiplier   = 3
ENT.BoostDuration          = 300
ENT.RateMultiplier         = 1

ENT.BoosterModel = "models/2rek/lithium_printers_2/lp2_storage1.mdl"

ENT.IsPrinterBooster = true

ENT.BoostColor = {64, 224, 208}

ENT.BoostedSoundDuration = 1
