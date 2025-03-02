-- "gamemodes\\darkrp\\entities\\weapons\\detector_veles.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

SWEP.Base	= "base_sweps_detector"
SWEP.PrintName = "Детектор \"Велес\""
SWEP.Category = "S.T.A.L.K.E.R. Detector Sweps"
SWEP.WorldModel = "models/kali/miscstuff/stalker/detector_veles.mdl"
SWEP.Instructions = "Используйте для поиска артефактов, болт поможет вам не попасть в аномалию."

SWEP.SearchRadius = 2500

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.ViewModelBoneMods = {
	["Base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["Dummy01"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.ViewModelBoneMods = {
	["l-ring-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.555, 0), angle = Angle(36.666, 7.777, -38.889) },
	["l-thumb-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-18.889, 10, 0) },
	["l-pinky-low"] = { scale = Vector(1, 1, 1), pos = Vector(-0.556, 0.699, 0), angle = Angle(1.11, 7.777, -38.889) },
	["l-middle-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.555, 0), angle = Angle(16.666, 3.332, -25.556) },
	["l-index-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0.555, 0), angle = Angle(10, 14.444, -27.778) },
	["lwrist"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -98.889) },
	["r-index-low"] = { scale = Vector(1, 1, 1), pos = Vector(-0.186, 0, 0), angle = Angle(-1.111, -1.111, 16.666) },
	["r-thumb-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10, -14.445, 16.666) },
	["r-middle-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(36.666, 0, 0) },
	["r-pinky-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(36.666, 0, 0) },
	["Base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["r-ring-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(34.444, 0, 0) },
	["Dummy01"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.VElements = {
	["Veles"] = { type = "Model", model = "models/kali/miscstuff/stalker/detector_veles.mdl", bone = "lwrist", rel = "", pos = Vector(3.635, 1.2, -0.801), angle = Angle(-43.248, 1.169, 111.039), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 1, bodygroup = {} },
	["element_name"] = { type = "Model", model = "models/kali/miscstuff/stalker/bolt.mdl", bone = "Base", rel = "", pos = Vector(0, 0, 0), angle = Angle(12.857, -29.222, 180), size = Vector(0.755, 0.755, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
	["screen"] = { type = "Quad", bone = "Base", rel = "Veles", pos = Vector(1.5, 0.1, .710), angle = Angle(0, -90, 0), size = 0.040, draw_func = nil}
}

SWEP.WElements = {
	["Bear"] = { type = "Model", model = "models/kali/miscstuff/stalker/detector_veles.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 1.557, -2.597), angle = Angle(-106.364, -167.144, 12.857), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 1} }
}

local function PointOnCircle( ang, radius, offX, offY )
	ang = math.rad( ang )
	local x = math.cos( ang ) * -radius + offX
	local y = math.sin( ang ) * radius + offY
	return x, y
end

local function DrawPointOnThatShit(material, x, y, ang, size )
	surface.SetMaterial(Material(material))
	surface.DrawTexturedRectRotated(x, y, size, size, ang )
end

function SWEP:Think()
	self.BaseClass.Think(self)
	self.VElements["screen"].draw_func = function( weapon )
		
		local plypos = self.Owner:GetPos()
		for k, v in pairs( self.Arts ) do
			if ( v:IsValid() ) then
				local tstdeg = ( (v:GetPos() - self.Owner:GetPos()):Angle().yaw - self.Owner:EyeAngles().yaw ) - 90
				local dest = self.Owner:GetPos():Distance(v:GetPos())-- plypos.x - v:GetPos().x, plypos.y - v:GetPos().y
				local x, y = PointOnCircle( tstdeg, dest/90, -2, 21 )
				--print(v:GetClass())
				surface.SetDrawColor( 0, 255, 0, 255 )
				DrawPointOnThatShit("icon16/control_play.png", x, y, v:GetAngles().yaw, 2 )
				--draw.SimpleText(".", "QuadFont", 0, 0, Color(0,255,0,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			end
		end
	end
end