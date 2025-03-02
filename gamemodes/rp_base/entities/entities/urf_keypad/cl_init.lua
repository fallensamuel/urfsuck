-- "gamemodes\\rp_base\\entities\\entities\\urf_keypad\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("sh_init.lua")

--[[
	We are going to borrow offsets etc from Robbis_1's keypad here
]]

local X = -50
local Y = -100
local W = 100
local H = 200
local VEC_ZERO = Vector(0, 0, 0)

local color_black = Color(0,0,0)
local color_outline = Color(255,255,255)
local color_entry = Color(50, 75, 50, 255)

local tr = translates
local cached
	if tr then
		cached = {
			tr.Get( 'ДОСТУП' ), 
			tr.Get( 'РАЗРЕШЕН' ), 
			tr.Get( 'ЗАПРЕЩЕН' ), 
		}
	else
		cached = {
			'ДОСТУП', 
			'РАЗРЕШЕН', 
			'ЗАПРЕЩЕН', 
		}
	end

function ENT:Draw()
	self:DrawModel()

	local ply = LocalPlayer()

	if (IsValid(ply)) then
		local distance = ply:EyePos():Distance(self:GetPos())

		if (distance <= 750) then
			local ang = self:GetPos() - ply:EyePos()
			local tr = util.TraceLine(util.GetPlayerTrace(ply, ang))

			if (tr.Entity == self) then
				local pos = self:GetPos() + self:GetForward() * 1.1
				local ang = self:GetAngles()
				local rot = Vector(-90, 90, 0)

				ang:RotateAroundAxis(ang:Right(), rot.x)
				ang:RotateAroundAxis(ang:Up(), rot.y)
				ang:RotateAroundAxis(ang:Forward(), rot.z)

				surface.SetFont("Keypad")

				cam.Start3D2D(pos, ang, 0.05)

					local tr = util.TraceLine({
						start = ply:EyePos(),
						endpos = ply:GetAimVector() * 32 + ply:EyePos(),
						filter = ply,
					})

					local pos = self:WorldToLocal(tr.HitPos)
					local status = self:GetStatus()
					local value = self:GetDisplayText() or ""

					surface.SetDrawColor(color_black)
					surface.DrawRect(X-5, Y-5, W+10, H+10)

					draw.OutlinedBox(X+5, Y+5, 90, H-10, color_entry, color_outline)

					surface.SetFont("Keypad")

					if (status == self.Status_None) then
						draw.SimpleText(value, "Keypad", X + W/2, Y + H/2, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						color_outline = Color(255,255,255)
					elseif (status == self.Status_Granted) then
						draw.SimpleText(cached[1], "KeypadState", X + W/2, Y + H/2 - 10, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						draw.SimpleText(cached[2], "KeypadState", X + W/2, Y + H/2 + 10, Color(0, 255, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						color_outline = Color(0,255,0)
					elseif (status == self.Status_Denied) then
						draw.SimpleText(cached[1], "KeypadState", X + W/2, Y + H/2 - 10, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						draw.SimpleText(cached[3], "KeypadState", X + W/2, Y + H/2 + 10, Color(255, 0, 0, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
						color_outline = Color(255,0,0)
					end

				cam.End3D2D()
			end
		end
	end
end