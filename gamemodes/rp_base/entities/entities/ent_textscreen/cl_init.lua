-- "gamemodes\\rp_base\\entities\\entities\\ent_textscreen\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include("shared.lua")

function ENT:Initialize()
	self:SetMaterial("models/effects/vol_light001")
	self:SetRenderMode(RENDERMODE_TRANSALPHA)
	self:SetColor(255, 255, 255, 0)
end

function ENT:Draw()
	rp_TextScreens[self] = true
	
--	if (self:GetPos():Distance(LocalPlayer():GetPos()) < 750) then
--		local ang = self:GetAngles()
--		local pos = self:GetPos() + ang:Up()
--		local camangle = Angle(ang.p, ang.y, ang.r)
--		self.lines = self.lines or {}
--
--		for i = 1, 3 do
--			if self:GetNetVar("Text" .. i) ~= "" then
--				self.lines[i] = self.lines[i] or {}
--				self.lines[i].font = allowablefonts[self:GetNetVar("Font" .. i) or 1]
--				self.lines[i].text = self:GetNetVar("Text" .. i) or ''
--				self.lines[i].r = self:GetNetVar("r" .. i) or 255
--				self.lines[i].g = self:GetNetVar("g" .. i) or 255
--				self.lines[i].b = self:GetNetVar("b" .. i) or 255
--				self.lines[i].a = self:GetNetVar("a" .. i) or 255
--				self.lines[i].size = math_Clamp(self:GetNetVar("size" .. i) or 100, 1, 100)
--				self.lines[i].fontname = getFont(self.lines[i].font, self.lines[i].size)
--			else
--				self.lines[i] = nil
--			end
--		end
--
--		cam_Start3D2D(pos, camangle, .25)
--		render.PushFilterMin(TEXFILTER.ANISOTROPIC)
--
--		local x, y = 0, 0
--
--		for k, v in ipairs(self.lines) do
--			local w, h = draw_SimpleTextOutlined(v.text, v.fontname, x, y, Color(v.r, v.g, v.b), 1, 1, 1, color_black)
--			y = y + h
--		end
--
--		render.PopFilterMin()
--
--		cam_End3D2D()
--		camangle:RotateAroundAxis(camangle:Right(), 180)
--		cam_Start3D2D(pos, camangle, .25)
--		render.PushFilterMin(TEXFILTER.ANISOTROPIC)
--		local x, y = 0, 0
--
--		for k, v in ipairs(self.lines) do
--			local w, h = draw_SimpleTextOutlined(v.text, v.fontname, x, y, Color(v.r, v.g, v.b), 1, 1, 1, color_black)
--			y = y + h
--		end
--		render.PopFilterMin()
--		cam_End3D2D()
--	end
end

function ENT:DrawTranslucent()
	self:Draw()
end