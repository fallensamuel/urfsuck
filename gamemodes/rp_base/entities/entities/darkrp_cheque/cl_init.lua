include('shared.lua')
local LocalPlayer = LocalPlayer
local Color = Color
local cam = cam
local draw = draw
local Angle = Angle
local Vector = Vector
local color_white = Color(255, 255, 255)
local color_black = Color(0, 0, 0)

function ENT:Draw()
	self:DrawModel()
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local mypos = LocalPlayer():GetPos()
	local dist = pos:Distance(mypos)
	if dist > 350 or (mypos - mypos):DotProduct(LocalPlayer():GetAimVector()) < 0 then return end
	color_white.a = 350 - dist
	color_black.a = 350 - dist
	if not IsValid(self:Getowning_ent()) or not IsValid(self:Getrecipient()) then return end
	local amount = tostring(self:Getamount()) or '0'
	local owner = (IsValid(self:Getowning_ent()) and self:Getowning_ent().Name and self:Getowning_ent():Name()) or 'N/A'
	local recipient = (self:Getrecipient().Name and self:Getrecipient():Name()) or 'N/A'
	surface.SetFont('ChatFont')
	local TextWidth = surface.GetTextSize('Pay: ' .. recipient .. '\n$' .. amount .. '\nSigned: ' .. owner)
	cam.Start3D2D(pos + ang:Up() * 0.9, ang, 0.012)
	draw.SimpleTextOutlined('Pay: \n' .. recipient, '3d2d', -TextWidth * 0.5, -150, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	draw.SimpleTextOutlined('$\n' .. amount, '3d2d', -TextWidth * 0.5, 25, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	draw.SimpleTextOutlined('Signed: ' .. owner, '3d2d', -TextWidth * 0.5, 130, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_black)
	cam.End3D2D()
end