AddCSLuaFile()

ENT.Base = "base_simpleprinter"
ENT.Spawnable 		= true
ENT.AdminSpawnable 	= true
ENT.AdminOnly 	= true

ENT.AdminOnly = true

ENT.AmmoPriceMult 	= 0.02 -- мультиплайр цены обоймы выбранных патрон (зависит от ammotype.price) 

ENT.PrinterModel = "models/urf/bitminer_2.mdl"
ENT.PrintName 	 = "Принтер патрон"
ENT.ResourceName = translates and translates.Get( "зарядов" ) or "зарядов"

ENT.PrinterSpeed 	= 8
ENT.Rate 			= 1
ENT.MaxMoney 		= 100
ENT.InterfaceOffset = 30