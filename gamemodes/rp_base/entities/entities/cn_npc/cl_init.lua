-- "gamemodes\\rp_base\\entities\\entities\\cn_npc\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--[[
	Chessnut's NPC System
	Do not re-distribute without author's permission.

	Revision f9eac7b3ccc04d7a7834987aea7bd2f9cb70c8e0a58637a332f20d1b3d2ad790
--]]

include("shared.lua")

ENT.AutomaticFrameAdvance = true

local ipairs = ipairs
local CurTime = CurTime
local LocalPlayer = LocalPlayer
local math_sin = math.sin
local math_pi = math.pi
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local ents_FindByClass = ents.FindByClass
local vec = Vector(0, 0, 82)
local color_white = Color(255, 255, 255)
local color_black = Color(0, 0, 0)
local t

local function Draw(self)
	
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local dist = pos:Distance(LocalPlayer():GetPos())
	if (dist > 350) then return end
	t = cnQuests[self:GetQuest()]

	if t.showName == false then return end
	
	color_white.a = 350 - dist
	color_black.a = 350 - dist

	vec.z = self:OBBMaxs().z * 1.13

	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Right(), math_sin(CurTime() * math_pi) * -45)
	cam_Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.065)
	draw_SimpleTextOutlined(t.name, '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam_End3D2D()
	ang:RotateAroundAxis(ang:Right(), 180)
	cam_Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.065)
	draw_SimpleTextOutlined(t.name, '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam_End3D2D()
end

hook.Add('PostDrawTranslucentRenderables', function()
	for k, v in ipairs(ents_FindByClass('cn_npc')) do
		Draw(v)
	end
end)

function ENT:Draw()

	self:DrawModel()

	local realTime = RealTime()

	self:FrameAdvance(realTime - (self.lastTick or realTime))
	self.lastTick = realTime

end

function ENT:Think()
	--if ((self.nextAnimCheck or 0) < CurTime()) then
	--	self:setAnim()
	--	self.nextAnimCheck = CurTime() + 60
	--end

	--self:SetNextClientThink(CurTime() + 0.25)

	return true
end