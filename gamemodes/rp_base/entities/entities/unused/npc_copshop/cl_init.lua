include('shared.lua')
local ipairs = ipairs
local CurTime = CurTime
local LocalPlayer = LocalPlayer
local math_sin = math.sin
local math_pi = math.pi
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local draw_SimpleTextOutlined = draw.SimpleTextOutlined
local ents_FindByClass = ents.FindByClass
local vec = Vector(0, 0, 75)
local color_white = Color(255, 255, 255)
local color_black = Color(0, 0, 0)

local function Draw(self)
	local pos = self:GetPos()
	local ang = self:GetAngles()
	local dist = pos:Distance(LocalPlayer():GetPos())
	if (dist > 350) then return end
	color_white.a = 350 - dist
	color_black.a = 350 - dist
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)
	ang:RotateAroundAxis(ang:Right(), math_sin(CurTime() * math_pi) * -45)
	cam_Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.065)
	draw_SimpleTextOutlined('Арсенал полиции', '3d2d', 0, -100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam_End3D2D()
	ang:RotateAroundAxis(ang:Right(), 180)
	cam_Start3D2D(pos + vec + ang:Right() * 1.2, ang, 0.065)
	draw_SimpleTextOutlined('Арсенал полиции', '3d2d', 0, -100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
	cam_End3D2D()
end

hook.Add('PostDrawOpaqueRenderables', function()
	for k, v in ipairs(ents_FindByClass('npc_copshop')) do
		Draw(v)
	end
end)

local fr

net.Receive('rp.CopshopMenu', function()
	if IsValid(fr) then
		fr:Close()
	end

	local w, h = ScrW() * .3, ScrH() * .5

	fr = ui.Create('ui_frame', function(self)
		self:SetTitle('Арсенал полиции')
		self:SetSize(w, h)
		self:Center()
		self:MakePopup()
	end)

	local list = ui.Create('ui_scrollpanel', function(self, p)
		self:SetPos(5, 30)
		self:SetSize(p:GetWide() - 10, p:GetTall() - 35)
		self:SetPadding(5)
	end, fr)

	for k, v in pairs(rp.CopItems) do
		local pnl = ui.Create('ui_panel')
		pnl:SetTall(50)
		list:AddItem(pnl)

		if (v.Model ~= nil) then
			local prvbg = ui.Create('ui_panel', function(self, p)
				self:SetPos(0, 0)
				self:SetSize(50, 50)

				self.Paint = function(self, w, h)
					draw.Box(2, 2, w - 4, h - 4, rp.col.Outline)
				end
			end, pnl)

			ui.Create('DModelPanel', function(self, p)
				self:SetSize(45, 45)
				self:SetPos(2.5, 2.5)
				self:SetModel(v.Model)
				local min, max = self.Entity:GetRenderBounds()
				self:SetCamPos(max * 1.3)
				self:SetLookAt(Vector(0, 0, 3))
			end, prvbg)
		end

		local Title = ui.Create('DLabel', pnl)
		Title:SetFont('rp.ui.20')
		Title:SetPos(55, 10)
		Title:SetText(v.Name)
		Title:SizeToContents()
		local Price = ui.Create('DLabel', pnl)
		Price:SetFont('rp.ui.20')
		Price:SetPos(pnl:GetWide() / 2 - Price:GetWide() / 2, 10)
		Price:SetText(rp.FormatMoney(v.Price))
		Price:SizeToContents()
		local Buy = ui.Create('DButton', pnl)
		Buy:SetPos(pnl:GetWide() - 110, 5)
		Buy:SetSize(100, 40)
		Buy:SetText('Купить')

		Buy.DoClick = function()
			rp.RunCommand('copbuy', v.Name)
		end
	end
end)