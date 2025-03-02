-- "gamemodes\\darkrp\\entities\\weapons\\detector_bear.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

SWEP.Base = "base_sweps_detector"
SWEP.PrintName = "Детектор \"Медведь\""
SWEP.Category = "S.T.A.L.K.E.R. Detector Sweps"
SWEP.Instructions = "Используйте для поиска артефактов, болт поможет вам не попасть в аномалию."

SWEP.Base = "base_sweps_detector"

SWEP.SearchRadius = 2500

SWEP.Spawnable = true
SWEP.AdminSpawnable	= true

SWEP.WorldModel = "models/kali/miscstuff/stalker/detector_bear.mdl"

SWEP.BeepSound = Sound("stalkerdetectors/echo.wav")

SWEP.ViewModelBoneMods = {
	["l-ring-low"] = { scale = Vector(1, 1, 1), pos = Vector(-0.186, 0.925, -0.556), angle = Angle(-50, 16.666, 0) },
	["l-thumb-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(-15.5, 27.777, -32.223) },
	["l-pinky-low"] = { scale = Vector(1, 1, 1), pos = Vector(0.925, 0.925, 0.555), angle = Angle(-90, 45.555, -32.223) },
	["l-middle-low"] = { scale = Vector(1, 1, 1), pos = Vector(0.185, 0, 0.185), angle = Angle(0, 0, 0) },
	["l-index-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(21.111, -12.223, 3.332) },
	["lwrist"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(0, 0, -72.223) },
	["r-index-low"] = { scale = Vector(1, 1, 1), pos = Vector(-0.186, 0, 0), angle = Angle(-1.111, -1.111, 16.666) },
	["r-thumb-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(10, -14.445, 16.666) },
	["r-middle-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(36.666, 0, 0) },
	["r-pinky-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(36.666, 0, 0) },
	["Base"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) },
	["r-ring-low"] = { scale = Vector(1, 1, 1), pos = Vector(0, 0, 0), angle = Angle(34.444, 0, 0) },
	["Dummy01"] = { scale = Vector(0.009, 0.009, 0.009), pos = Vector(0, 0, 0), angle = Angle(0, 0, 0) }
}

SWEP.IronSightsPos = Vector(0, 0, 0)
SWEP.IronSightsAng = Vector(0, 0, 0)

SWEP.WElements = {
	["Bear"] = { type = "Model", model = "models/kali/miscstuff/stalker/detector_bear.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.675, 1.557, -2.597), angle = Angle(-106.364, -167.144, 12.857), size = Vector(1, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 1} }
}

SWEP.VElements = {
	["detector"] = { type = "Model", model = "models/kali/miscstuff/stalker/detector_bear.mdl", bone = "lwrist", rel = "", pos = Vector(4, 1.1, -0.519), angle = Angle(-59.611, 31.558, 162.468), size = Vector(0.699, 0.699, 0.699), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 1} },
	--["detector"] = { type = "Model", model = "models/kali/miscstuff/stalker/detector_bear.mdl", bone = "l-upperarm", rel = "", pos = Vector(8.831, 0.518, -2.5), angle = Angle(33.895, 68.96, 17.531), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {[1] = 1} },
	["element_name"] = { type = "Model", model = "models/kali/miscstuff/stalker/bolt.mdl", bone = "Base", rel = "", pos = Vector(0, 0, 0), angle = Angle(12.857, -29.222, 180), size = Vector(0.755, 0.755, 0.755), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

if CLIENT then
	local matScreen = Material("models/kali/miscstuff/stalker/detectors/detector_bear_c"); // Òåêñòóðà, êîòîðóþ èùåì
	local RTTexture = GetRenderTarget("DTC_BEAR", 512, 512); // Ëþáîå íàçâàíèå

	local dot = surface.GetTextureID("models/kali/miscstuff/stalker/detectors/detector_bear_segment_copy");
	local bg = surface.GetTextureID("models/kali/miscstuff/stalker/detectors/detector_bear_copy");

	function SWEP:RenderScreen()

		local NewRT = RTTexture;
		local oldW = ScrW();
		local oldH = ScrH();
		local ply = LocalPlayer();

		matScreen:SetTexture( "$basetexture", NewRT);
	
		local OldRT = render.GetRenderTarget();
		render.SetRenderTarget(NewRT);
		render.SetViewPort( 0, 0, 512, 512);

		cam.Start2D();

			render.Clear( 50, 50, 100, 0 );

			surface.SetDrawColor( 255, 255, 255, 255 );
			surface.SetTexture( bg );
			surface.DrawTexturedRect( 0, 0, 512, 512);

			surface.SetTexture(dot);



			local ent = self.ClosestArt

			if IsValid(ent) then
				local ang = ply:GetAngles();
				local pos = ent:GetPos() - ply:GetShootPos()
				surface.SetDrawColor(255, 255, 255, 255)
				pos:Rotate(Angle(0, -1*ang.Yaw, 0));
				surface.DrawTexturedRectRotated( 131, 118, 150, 150, ((pos:Angle().y % 15) / 15 < 0.5 and pos:Angle().y - (pos:Angle().y % 15) or (pos:Angle().y % 15) / 15 >= 0.5 and pos:Angle().y - (pos:Angle().y % 15)  + 15) + 30  )
			end

		cam.End2D();

		render.SetRenderTarget(OldRT);
		render.SetViewPort( 0, 0, oldW, oldH )

	end
end