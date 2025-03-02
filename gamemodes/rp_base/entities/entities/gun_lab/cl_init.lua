include('shared.lua')
local LocalPlayer = LocalPlayer
local Color = Color
local cam = cam
local draw = draw
local Angle = Angle
local Vector = Vector
local CurTime = CurTime

local LShipment = LShipment or '';

function ENT:PrecacheData()
	if (LShipment != '') then return end
	local CurContent = self:GetContent();
	for Index, Shipment in pairs(rp.item.shop.shipments) do
		if (Shipment.content == CurContent) then
			LShipment = Shipment.name or '';
		end
	end
end

local tr = translates
local cached
	if tr then
		cached = {
			tr.Get( 'Цена' ), 
		}
	else
		cached = {
			'Цена', 
		}
	end

function ENT:Draw()
	self:DrawModel()
	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Name()) or 'Unknown'
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local mypos = LocalPlayer():GetPos()
	local dist = pos:Distance(mypos)
	if dist > 350 or (mypos - mypos):DotProduct(LocalPlayer():GetAimVector()) < 0 then return end
	-- fancy math says we dont need to draw
	ang:RotateAroundAxis(ang:Forward(), 90)
	local TextAng = ang
	color_white.a = 350 - dist
	color_black.a = 350 - dist
	TextAng:RotateAroundAxis(TextAng:Right(), math.sin(CurTime() * math.pi) * -45)
	cam.Start3D2D(pos, ang, 0.070)
	draw.SimpleTextOutlined(LShipment, '3d2d', 0, -450, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	draw.SimpleTextOutlined(cached[1] .. ': ' .. self:Getprice(), '3d2d', 0, -450, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam.End3D2D()
	ang:RotateAroundAxis(ang:Right(), 180)
	cam.Start3D2D(pos, ang, 0.070)
	draw.SimpleTextOutlined(LShipment, '3d2d', 0, -450, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM, 1, color_black)
	draw.SimpleTextOutlined(cached[1] .. ': ' .. self:Getprice(), '3d2d', 0, -450, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam.End3D2D()

	self:PrecacheData();
end