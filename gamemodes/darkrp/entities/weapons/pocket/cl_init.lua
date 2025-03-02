-- "gamemodes\\darkrp\\entities\\weapons\\pocket\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("pocket_controls.lua")
include("pocket_vgui.lua")
include("shared.lua")
SWEP.PrintName = "Рюкзак"
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
	["element_name"] = { type = "Model", model = "models/hgn/srp/items/backpack-1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(10.029, -2.209, -2.959), angle = Angle(-40.715, -0.166, 131.503), size = Vector(0.8, 0.8, 0.8), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
//SWEP.VElements = {
//	["suitcase"] = { type = "Model", model = "models/weapons/w_suitcase_passenger.mdl", bone = "ValveBiped.cube2", rel = "", pos = Vector(0, -0.977, -0.08), angle = Angle(3.855, -19.458, -94.402), size = Vector(0.755, 0.755, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
//}
SWEP.WElements = {
	["suitcase"] = { type = "Model", model = "models/hgn/srp/items/backpack-1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5.287, 5.151, -1.625), angle = Angle(172.195, 1.34, 0), size = Vector(0.535, 0.535, 0.535), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
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