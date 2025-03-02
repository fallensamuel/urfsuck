include("pocket_controls.lua")
include("pocket_vgui.lua")
include("shared.lua")
SWEP.PrintName = "Сумка"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.FrameVisible = false

SWEP.ViewModelFOV = 40
SWEP.UseHands 				= false

SWEP.ShowViewModel = false
SWEP.ShowWorldModel = false

SWEP.VElements = {
	["suitcase"] = { type = "Model", model = "models/weapons/w_suitcase_passenger.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.37, 5.307, 2.947), angle = Angle(-45.89, 77.601, 180), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
//SWEP.VElements = {
//	["suitcase"] = { type = "Model", model = "models/weapons/w_suitcase_passenger.mdl", bone = "ValveBiped.cube2", rel = "", pos = Vector(0, -0.977, -0.08), angle = Angle(3.855, -19.458, -94.402), size = Vector(0.755, 0.755, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
//}
SWEP.WElements = {
	["suitcase"] = { type = "Model", model = "models/weapons/w_suitcase_passenger.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.683, -0.08, 0), angle = Angle(106.708, 0, 0), size = Vector(0.903, 0.903, 0.903), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

function SWEP:PrimaryAttack()
	return
end

function SWEP:SecondaryAttack()
	rp.inv.EnableMenu()

	return
end

function SWEP:DrawHUD()
	surface.SetDrawColor(0, 0, 0, 255)
	surface.DrawRect(ScrW() / 2, ScrH() / 2 - 3, 2, 8)
	surface.DrawRect(ScrW() / 2 - 3, ScrH() / 2, 8, 2)
end