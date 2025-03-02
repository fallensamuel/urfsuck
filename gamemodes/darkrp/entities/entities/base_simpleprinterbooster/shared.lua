-- "gamemodes\\darkrp\\entities\\entities\\base_simpleprinterbooster\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName 	= "Base Бустер"
ENT.Category 	= "Принтеры URF"
ENT.Author 		= "urf.im @ Alawork"
ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.PrinterSpeedMultiplier = 2
ENT.FireChanceMultiplier   = 1.5
ENT.BoostDuration          = 10
ENT.RateMultiplier         = 2
ENT.FireCooldown = 3

ENT.BoosterModel = "models/props_lab/reciever01d.mdl"

ENT.IsPrinterBooster = true

ENT.BoostColor = {255, 0, 0}

ENT.BoostedPrintSound = ""
ENT.BoostedSoundDuration = 1
