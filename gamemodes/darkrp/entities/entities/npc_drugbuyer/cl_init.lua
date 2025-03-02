-- "gamemodes\\darkrp\\entities\\entities\\npc_drugbuyer\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include('shared.lua')

ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()
	self:DrawModel()
end

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
local color_white = Color(255, 248, 63)
local color_black = Color(0, 0, 0)

local function Draw(self)
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local dist = pos:Distance(LocalPlayer():GetPos())
	if (dist > 350) then return end
	local t = rp.GetTerm('ArtBuyer')
	color_white.a = 350 - dist
	color_black.a = 350 - dist
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Right(), math_sin(CurTime() * math_pi) * -45)
	cam_Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.065)
	draw_SimpleTextOutlined(t, '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam_End3D2D()
	ang:RotateAroundAxis(ang:Right(), 180)
	cam_Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.065)
	draw_SimpleTextOutlined(t, '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam_End3D2D()
end

hook.Add('PostDrawTranslucentRenderables', function()
	for k, v in ipairs(ents_FindByClass('npc_drugbuyer')) do
		Draw(v)
	end
end)

local fr

net.Receive('rp.DrugBuyerMenu', function()
	if IsValid(fr) then
		fr:Close()
	end

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Скупщик артефактов')
		self:SetSize(450, 125)
		self:Center()
		self:MakePopup()
	end)

	ui.Create('DLabel', function(self, p)
		self:SetPos(5, 30)
		self:SetText('Артефакт у тебя? Давай его сюда!\n\nПередай его при помощи грави гана.')
		self:SizeToContents()
	end, fr)
end)