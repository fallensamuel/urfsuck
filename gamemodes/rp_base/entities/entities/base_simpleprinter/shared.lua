ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName 	= "Base Принтер"
ENT.Category 	= "Принтеры URF"
ENT.Author 		= "SerGun & Beelzebub"
ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.PrinterSpeed 	= 8
ENT.Rate 			= 1
ENT.MaxMoney 		= 100
ENT.PrinterModel 	= "models/urf/bitminer_2.mdl"
ENT.InterfaceOffset = 30
ENT.ResourceName 	= "рм."


sound.Add({
	name = "printer_noise",
	channel = CHAN_STATIC,
	volume = 1,
	level = 100,
	pitch = {95, 110},
	sound = "simple_printer_noise.mp3"
})

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
	self:NetworkVar("Int", 0, "CurAmount")
	self:NetworkVar("Bool", 0, "IsWorking")
	self:NetworkVar("Bool", 1, "IsBroken")
	self:NetworkVar("Float", 0, "NextPrint")
end