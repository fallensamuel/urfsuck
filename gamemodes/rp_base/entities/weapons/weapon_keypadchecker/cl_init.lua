-- "gamemodes\\rp_base\\entities\\weapons\\weapon_keypadchecker\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("shared.lua")
local DrawData = {}

net.Receive("DarkRP_keypadData", function(len)
	DrawData = net.ReadTable()
end)

local lineMat = Material("cable/chain")

function SWEP:DrawHUD()
	draw.WordBox(2, 10, ScrH() / 2, "Shoot a keypad to see what it controls.", "HudFont", Color(0, 0, 0, 120), Color(255, 255, 255, 255))
	draw.WordBox(2, 10, ScrH() / 2 + 20, "Shoot a Fading door/thruster/whatever to see which keypads are connected to it.", "HudFont", Color(0, 0, 0, 120), Color(255, 255, 255, 255))
	draw.WordBox(2, 10, ScrH() / 2 + 40, "Right click to clear.", "HudFont", Color(0, 0, 0, 120), Color(255, 255, 255, 255))
	local entMessages = {}

	for k, v in pairs(DrawData or {}) do
		if not IsValid(v.ent) or not IsValid(v.original) then continue end
		entMessages[v.ent] = (entMessages[v.ent] or 0) + 1
		local pos = v.ent:LocalToWorld(v.ent:OBBCenter()):ToScreen()
		local name = (v.name and ": " .. v.name:gsub("onDown", "ON"):gsub("onUp", "OFF") or "")
		draw.WordBox(2, pos.x, pos.y + entMessages[v.ent] * 16, (v.delay and v.delay .. " seconds " or "") .. v.type .. name, "HudFont", Color(0, 0, 0, 120), Color(255, 255, 255, 255))
		cam.Start3D(EyePos(), EyeAngles())
		render.SetMaterial(lineMat)
		render.DrawBeam(v.original:GetPos(), v.ent:GetPos(), 2, 0.01, 20, Color(0, 255, 0, 255))
		cam.End3D()
	end
end

function SWEP:SecondaryAttack()
	DrawData = {}
end