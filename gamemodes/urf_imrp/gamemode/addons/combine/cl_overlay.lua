local surface = surface
local ScrW = ScrW
local ScrH = ScrH

local overlay_cp
local overlay_ota

hook("HUDPaint", function()
	--if !overlay then
	--	overlay = Material("effects/combine_binocoverlay")
	--	overlay:SetFloat("$alpha", ".4")
	--	overlay:Recompute()
	--end
	--if !overlay_ota then
	--	overlay_ota = Material("effects/combine_binocoverlay")
	--	overlay_ota:SetVector("$color", Vector(1, .1, .1))
	--	overlay_ota:SetFloat("$alpha", ".5")
	--	overlay_ota:Recompute()
	--end
	if (LocalPlayer():IsCombine()) then
--[[
		if LocalPlayer():GetFaction() == FACTION_OTA then
			if !overlay_ota then
				overlay_cp = nil
				overlay_ota = Material("effects/combine_binocoverlay")
				overlay_ota:SetVector("$color", Vector(1, .2, .2))
				overlay_ota:SetFloat("$alpha", ".5")
				overlay_ota:Recompute()
			end
			surface.SetMaterial(overlay_ota)
		else
			if !overlay_cp then
				overlay_ota = nil
				overlay_cp = Material("effects/combine_binocoverlay")
				overlay_cp:SetVector("$color", Vector(1, 1, 1))
				overlay_cp:SetFloat("$alpha", ".4")
				overlay_cp:Recompute()
			end
			surface.SetMaterial(overlay_cp)
		end
]]--
		if !overlay_cp then
			overlay_ota = nil
			overlay_cp = Material("effects/combine_binocoverlay")
			overlay_cp:SetVector("$color", Vector(1, 1, 1))
			overlay_cp:SetFloat("$alpha", ".4")
			overlay_cp:Recompute()
		end

		surface.SetDrawColor(0, 0, 0)
		surface.SetMaterial(overlay_cp)
		surface.DrawTexturedRect(0, 0, ScrW(), ScrH())
	end
end)