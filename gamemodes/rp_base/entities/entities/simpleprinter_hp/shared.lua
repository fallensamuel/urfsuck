-- "gamemodes\\rp_base\\entities\\entities\\simpleprinter_hp\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

ENT.Base = "base_simpleprinter"
ENT.Spawnable 		= true
ENT.AdminSpawnable 	= true
ENT.AdminOnly 	= true

ENT.AdminOnly = true

ENT.PrinterModel = "models/urf/bitminer_2.mdl"
ENT.PrintName 	 = "Принтер здоровья"
ENT.ResourceName = translates and translates.Get( "здоровья" ) or "здоровья"

ENT.PrinterSpeed 	= 3
ENT.Rate 			= 2
ENT.MaxMoney 		= 100
ENT.InterfaceOffset = 30