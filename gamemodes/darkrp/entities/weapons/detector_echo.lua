-- "gamemodes\\darkrp\\entities\\weapons\\detector_echo.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

SWEP.Base = "base_sweps_detector"
SWEP.PrintName = "Детектор \"Отклик\""
SWEP.Category = "S.T.A.L.K.E.R. Detector Sweps"
SWEP.Instructions = "Используйте для поиска артефактов, болт поможет вам не попасть в аномалию."

SWEP.SearchRadius = 2500

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.WorldModel = "models/kali/miscstuff/stalker/detector_echo.mdl"

SWEP.ViewModelBoneMods = {
	["l-ring-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-3.333, 10, -16.667) },
	["l-thumb-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-10, 18.888, -3.333) },
	["l-pinky-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-38.889, 21.111, -10) },
	["l-middle-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, -0.186, 0), angle = Angle(14.444, 1.11, -18.889) },
	["l-index-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(14.444, 0, 0) },
	["lwrist"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -87.778) },
	["r-index-low"] = { scale = Vector(1, 1, 1), pos = Vector(-0.186, 0, 0), angle = Angle(-1.111, -1.111, 16.666) },
	["r-thumb-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10, -14.445, 16.666) },
	["r-middle-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(36.666, 0, 0) },
	["r-pinky-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(36.666, 0, 0) },
	["Base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["r-ring-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(34.444, 0, 0) },
	["Dummy01"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}


SWEP.VElements = {
	["echo"] = { type = "Model", model = "models/kali/miscstuff/stalker/detector_echo.mdl", bone = "lwrist", rel = "", pos = Vector(3.635, 1.557, -0.9), angle = Angle(-50.26, 15.194, 139.091), size = Vector(0.55, 0.55, 0.55), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {[1] = 1} },
	--["detector"] = { type = "Model", model = "models/kali/miscstuff/stalker/detector_bear.mdl", bone = "l-upperarm", rel = "", pos = Vector(8.831, 0.518, -2.5), angle = Angle(33.895, 68.96, 17.531), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 1} },
	["element_name"] = { type = "Model", model = "models/kali/miscstuff/stalker/bolt.mdl", bone = "Base", rel = "", pos = Vector(0, 0, 0), angle = Angle(12.857, -29.222, 180), size = Vector(0.755, 0.755, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
}

SWEP.WElements = {
	["Bear"] = { type = "Model", model = "models/kali/miscstuff/stalker/detector_echo.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 1.557, -2.597), angle = Angle(-106.364, -167.144, 12.857), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 1} }
}

function SWEP:Beep()
	self.Owner:EmitSound(self.BeepSound, 100, 100)
	self.VElements["echo"].skin = 2
	timer.Simple(0.1, function()
		if IsValid(self) and IsValid(self.Weapon) then
			self.VElements["echo"].skin = 1
		end
	end)
end