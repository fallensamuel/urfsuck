-- "gamemodes\\darkrp\\entities\\weapons\\weapon_krovosos\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
﻿include('shared.lua')

--[[
function SWEP:CalcView(ply, pos, ang, fov)
    return pos + Vector(0, 0, 15)
end

function SWEP:Think()
	if IsValid(self.Owner) then
		if self.ground != self.Owner:IsOnGround() then
			self.ground = self.Owner:IsOnGround()
			--self.Owner:SetBodygroup(1, self.ground && 0 or 1)
		end
	end
end
]]--

function SWEP:PrimaryAttack() 
	if not self.Owner:IsOnGround() then return end
	
	self.Owner:SetAnimation( PLAYER_ATTACK1 );
end

local CamoMat = Material("camo/camo_shade.vmt")
local CamoOverlayMat = "camo/camo_overlay.vmt"
local CamoIconMat = "camo/camo_icon.vmt"

local colorMofify = {
	["$pp_colour_addr"] = 0.4,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 1,
	["$pp_colour_colour"] = 0.5,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0,
}

local colorMofifyRed = {
	["$pp_colour_addr"] = 0.3,
	["$pp_colour_addg"] = 0,
	["$pp_colour_addb"] = 0,
	["$pp_colour_brightness"] = 0,
	["$pp_colour_contrast"] = 0.8,
	["$pp_colour_colour"] = 1.3,
	["$pp_colour_mulr"] = 0,
	["$pp_colour_mulg"] = 0,
	["$pp_colour_mulb"] = 0,
}

local percent

local function DrawCamoEffects()
	if LocalPlayer():GetNWBool("Cloaked") and LocalPlayer():GetNWFloat("Cloak_Recloaked") <= CurTime() then
		percent = LocalPlayer():GetColor().a / 255
		
		colorMofify["$pp_colour_colour"] = 0.4 + percent * 0.6
		DrawColorModify(colorMofify)
		--DrawMotionBlur(0.1 + percent * 0.9, 0.5, 0.01)
		--DrawToyTown(2,ScrH()/2)
		 
	--elseif IsValid(LocalPlayer():GetActiveWeapon()) and LocalPlayer():GetActiveWeapon():GetClass() == 'weapon_krovosos' then
	--	DrawColorModify(colorMofifyRed)
	end
end
hook.Add("RenderScreenspaceEffects","ShowCamoEffects",DrawCamoEffects)
	
local CamoOverlayID = surface.GetTextureID(CamoOverlayMat)
local CamoIconID = surface.GetTextureID(CamoIconMat)
local CamoIconSize = ScrH()/5
local CamoIconY = (ScrH()/2)+(ScrH()/5)
local CamoIconX = (ScrW()/2)-(CamoIconSize/2)
	
local function DrawCamoItems()
	if LocalPlayer():GetNWBool("Cloaked") and LocalPlayer():GetNWFloat("Cloak_Recloaked") <= CurTime() then
		surface.SetDrawColor(255,255,255,255)
		surface.SetTexture(CamoOverlayID)
		surface.DrawTexturedRect(0,0,ScrW(),ScrH())
			
		surface.SetDrawColor(0,0,0,255)
		surface.SetTexture(CamoIconID)
		surface.DrawTexturedRect(CamoIconX,CamoIconY,CamoIconSize,CamoIconSize)
	end
end
--hook.Add("HUDPaint","DrawActiveCamoItems",DrawCamoItems)
