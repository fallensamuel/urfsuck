-- "gamemodes\\rp_base\\entities\\entities\\money_basket\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include('shared.lua')
local LocalPlayer = LocalPlayer
local Color = Color
local cam = cam
local draw = draw
local Angle = Angle
local Vector = Vector
local color_white = Color(255, 255, 255)
local color_black = Color(0, 0, 0)
local color_bg = Color(10, 10, 10)

function ENT:Draw()
	local normal = self:GetUp() -- Everything "behind" this normal will be clipped
	local position = normal:Dot( self:GetPos() ) -- self:GetPos() is the origin of the clipping plane

	local oldEC = render.EnableClipping( true )
	render.PushCustomClipPlane( normal, position )

	self:DrawModel()

	render.PopCustomClipPlane()
	render.EnableClipping( oldEC )
end

local tr = translates
local cached
	if tr then
		cached = tr.Get( 'Деньги' )
	else
		cached = 'Деньги'
	end

function ENT:Draw()
	self:DrawModel()
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local dist = pos:Distance(LocalPlayer():GetPos())
	local alpha = 300 - dist
	color_white.a = alpha
	color_black.a = alpha
	if dist > 300 then return end
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)
	cam.Start3D2D((pos + self:GetForward() * (self:OBBMaxs().y - 4.25)), ang, 0.020)
	draw.Box(-550, -325, 1100, 650, color_bg)
	draw.SimpleTextOutlined(IsValid(self:Getowning_ent()) and self:Getowning_ent():Name() or 'Unknown', '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	draw.SimpleTextOutlined(cached .. ': ' .. self:Getmoney(), '3d2d', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	cam.End3D2D()
end