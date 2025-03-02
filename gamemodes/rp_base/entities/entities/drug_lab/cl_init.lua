-- "gamemodes\\rp_base\\entities\\entities\\drug_lab\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include('shared.lua')
local LocalPlayer = LocalPlayer
local Color = Color
local cam = cam
local draw = draw
local Angle = Angle
local Vector = Vector
local color_text = Color(255, 255, 255)
local color_textoutline = Color(0, 0, 0)
local color_outline = Color(245, 245, 245)
local color_grey = Color(50, 50, 50)
local color_red = Color(255, 50, 50)
local color_yellow = Color(255, 255, 50)
local color_green = Color(50, 255, 50)

local function barColor(perc)
	return ((perc <= .39) and color_red or ((perc <= .75) and color_yellow or color_green))
end

local tr = translates
local cached
	if tr then
		cached = {
			tr.Get( 'Мини лаборатория' ), 
			tr.Get( 'Приготовить' ), 
		}
	else
		cached = {
			'Мини лаборатория', 
			'Приготовить', 
		}
	end

function ENT:Draw()
	self:DrawModel()
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local mypos = LocalPlayer():GetPos()
	local dist = pos:Distance(mypos)
	if dist > 350 or (mypos - mypos):DotProduct(LocalPlayer():GetAimVector()) < 0 then return end
	color_text.a = 350 - dist
	color_textoutline.a = 350 - dist
	cam.Start3D2D(pos, Angle(0, LocalPlayer():EyeAngles().yaw - 90, 90), 0.065)
	draw.SimpleTextOutlined(cached[1], '3d2d', 0, -600, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_textoutline)
	cam.End3D2D()
	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Up(), 90)
	cam.Start3D2D(pos + Vector(0, 0, 1.3), ang, 0.05)
	draw.OutlinedBox(-225, 220, 400, 60, color_grey, color_outline, 2)
	draw.Box(-221, 225, (392 * self:GetPerc()), 50, barColor(self:GetPerc()))
	draw.SimpleTextOutlined(math.Round(self:GetPerc() * 100, 0) .. '%', 'PrinterSmall', 0, 250, color_text, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER, 1, color_textoutline)
	cam.End3D2D()
end

local fr

net.Receive('rp.DrugLabMenu', function()
	local ent = net.ReadEntity()

	if IsValid(fr) then
		fr:Close()
	end

	if IsValid(ent) and (ent:GetPerc() < 1) then return end
	local w, h = 160, 235

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle(cached[2])
		self:SetSize(w, h)
		self:Center()
		self:MakePopup()

		self.Think = function()
			if (not IsValid(ent)) or (ent:GetPos():Distance(LocalPlayer():GetPos()) >= 80) then
				fr:Close()
			end
		end
	end)

	local cont = ui.Create('ui_panel', function(self, p)
		self:SetPos(5, 30)
		self:SetWide(p:GetWide() - 10)
		self.Paint = function() end
	end, fr)

	local x, y = 0, 0
	local s = 75

	for k, v in ipairs(rp.Drugs) do
		ui.Create('rp_modelicon', function(self)
			self:SetPos(x * s, y * s)
			self:SetSize(s, s)
			self:SetModel(v.Model)

			--self:SetLabel(v.Name)
			self.DoClick = function()
				net.Start('rp.DrugLabCreate')
				net.WriteEntity(ent)
				net.WriteUInt(k, 8)
				net.SendToServer()
				fr:Close()
			end
		end, cont)

		y = (x >= 1) and (y + 1) or y
		x = (x >= 1) and 0 or (x + 1)
	end

	fr:SetTall((y * 75) + 35)
	cont:SetTall(fr:GetTall() - 35)
end)