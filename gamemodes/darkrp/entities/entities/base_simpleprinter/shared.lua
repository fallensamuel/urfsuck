-- "gamemodes\\darkrp\\entities\\entities\\base_simpleprinter\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local sound_Add = sound.Add


ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName 	= "Base Принтер"
ENT.Category 	= "Принтеры URF"
ENT.Author 		= "urf.im @ SerGun & Beelzebub & Alawork"
ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.PrinterSpeed 	= 8
ENT.Rate 			= 1
ENT.MaxMoney 		= 100
ENT.PrinterModel 	= "models/urf/bitminer_2.mdl"
ENT.InterfaceOffset = 30
ENT.ResourceName 	= "рм."
ENT.FireCooldown = 3

sound_Add({
    name = "printer_noise",
    channel = CHAN_STATIC,
    volume = 1,
    level = 100,
    pitch = {95, 110},
    sound = "simple_printer_noise.mp3"
})

sound_Add({
    name = "printer_boost_on",
    channel = CHAN_WEAPON,
    volume = 0.5,
    level = 75,
    pitch = 100,
    sound = "boost_on.mp3"
})

sound_Add({
    name = "printer_extinguish",
    channel = CHAN_WEAPON,
    volume = 0.5,
    level = 75,
    pitch = 100,
    sound = "extinguisher.mp3"
})

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "owning_ent")
    self:NetworkVar("Int", 0, "CurAmount")
    self:NetworkVar("Int", 1, "BoostDuration")
    self:NetworkVar("Bool", 0, "IsWorking")
    self:NetworkVar("Bool", 1, "IsFiring")
    self:NetworkVar("Bool", 2, "IsBoosted")
    self:NetworkVar("Float", 0, "NextPrint")
    self:NetworkVar("Float", 1, "FirePercent")
end
