-- "gamemodes\\darkrp\\entities\\entities\\rpitem_printerbooster_5.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local AddCSLuaFile = AddCSLuaFile


AddCSLuaFile()

ENT.Base = "base_simpleprinterbooster"
ENT.PrintName = "Бустер О-сознания"
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AdminOnly = true

ENT.PrinterSpeedMultiplier = 0.2
ENT.FireChanceMultiplier   = 1
ENT.BoostDuration          = 300
ENT.RateMultiplier         = 1

ENT.BoosterModel = "models/2rek/lithium_printers_2/lp2_storage3.mdl"

ENT.IsPrinterBooster = true

ENT.BoostColor = {186, 85, 211}

ENT.BoostedSoundDuration = 1
