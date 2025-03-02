-- "gamemodes\\rp_base\\entities\\entities\\money_printer\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include('shared.lua')
local LocalPlayer = LocalPlayer
local cam = cam
local draw = draw
local IsValid = IsValid
local math = math
local color_red = Color(255, 50, 50)
local color_yellow = Color(255, 255, 50)
local color_green = Color(50, 255, 50)
local color_bg = Color(10, 10, 10)
local color_outline = Color(245, 245, 245)
local color_grey = Color(50, 50, 50)
local color_black = Color(0, 0, 0)
local color_white = color_outline
local color_grey = Color(50, 50, 50)
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local draw_SimpleText = draw.SimpleText
local draw_Box = draw.Box
local draw_OutlinedBox = draw.OutlinedBox
local draw_Outline = draw.Outline
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local math_Clamp = math.Clamp
local math_Round = math.Round
local CurTime = CurTime
local IsValid = IsValid
local LocalPlayer = LocalPlayer

local o = {
	x = -478,
	y = -338,
	w = 726,
	h = 315
}

local function barColor(perc)
	return ((perc <= .39) and color_red or ((perc <= .75) and color_yellow or color_green))
end

local function drawStatBar(name, y, perc)
	perc = math_Clamp(perc, 0, 1)
	draw_OutlinedBox(o.x + 20, y, o.w - 40, 65, color_grey, color_outline, 2)
	draw_Outline(o.x + 23, y + 2, o.w - 46, 61, color_black, 3)
	draw_Box(o.x + 25, y + 5, (o.w - 51) * perc, 55, barColor(perc))
	draw_SimpleTextOutlined(name, 'PrinterSmall', o.x + (o.w * .5), y + 28, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 2, color_black)
end

local function predict(timeValue, value)
	return math_Round((CurTime() - timeValue) / value * 100, 0) / 100
end

function ENT:CalculateScreenPos(pos, ang)
	ang:RotateAroundAxis(ang:Up(), 90)
	ang:RotateAroundAxis(ang:Forward(), 90)
	pos = pos + ang:Up() * 16.15
	return pos, ang, 0.03
end

local tr = translates
local cached
	if tr then
		cached = {
			tr.Get( 'Заряды' ), 
			tr.Get( 'Прочность' ), 
			tr.Get( 'Процесс' ), 
		}
	else
		cached = {
			'Заряды', 
			'Прочность', 
			'Процесс', 
		}
	end

function ENT:Draw3D2D()
	self:DrawModel()
	local pos, ang, scale = self:CalculateScreenPos(self:GetPos(), self:GetAngles())
	cam_Start3D2D(pos, ang, scale)
	-- Background
	draw_Box(o.x, o.y, o.w, o.h, color_bg)
	-- Outline
	draw_Outline(o.x + 5, o.y + 5, o.w - 10, o.h - 5, color_white, 5)
	draw_Outline(o.x + 5, o.y + 70, o.w - 10, o.h - 65, color_white, 5)
	-- Owner
	local name = (IsValid(self:Getowning_ent()) and self:Getowning_ent():Name() or 'Unknown')
	draw_SimpleText(name, 'PrinterLarge', o.w * .5 + o.x, o.y + 35, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	-- Stats
	drawStatBar(cached[1] .. ': ' .. self:GetInk() .. '/' .. self:GetMaxInk(), o.y + 85, self:GetInk() / self:GetMaxInk())
	drawStatBar(cached[2] .. ': ' .. self:GetHP() .. '/'..self.MaxHP, o.y + 160, self:GetHP() / self.MaxHP)
	local prinrPerc = predict(self:GetLastPrint(), rp.cfg.PrintDelay)
	drawStatBar(cached[3] .. ': ' .. math_Clamp(prinrPerc, 0, 1) * 100 .. '%', o.y + 235, prinrPerc)
	cam_End3D2D()
end