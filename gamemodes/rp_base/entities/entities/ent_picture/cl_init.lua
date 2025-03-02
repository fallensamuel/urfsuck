-- "gamemodes\\rp_base\\entities\\entities\\ent_picture\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include'shared.lua'
cvar.Register'enable_pictureframes':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Отображение Картин')

function ENT:RenderTexture(options)
	self.Rendering = true

	if (string.sub(self:GetURL(), 1, 4) == 'ORG:') then
		self.IsOrg = true
		self.OrgName = string.sub(self:GetURL(), 5)
		self.LastURL = self:GetURL()
	else
		self.IsOrg = false
		wmat.Delete(self:EntIndex())

		options = options or {}
		
		options.URL = self:GetURL()
		options.W = 1014
		options.H = 1014
		
		wmat.Create(self:EntIndex(), options, function(material)
			if IsValid(self) then
				self.Rendering = false
				self.LastURL = self:GetURL()
			end
		end, function()
			if IsValid(self) then
				self.Rendering = false
			end
		end)
	end
end

function ENT:GetTexture()
	if (not self.IsOrg) then
		return wmat.Get(self:EntIndex())
	else
		local mat = rp.orgs.GetBanner(self.OrgName)

		if (mat and self.Rendering) then
			self.Rendering = false
		end

		return mat
	end
end

function ENT:Draw()
	self:DrawModel()
	if (cvar.GetValue('enable_pictureframes') == false) or (not self:InSight()) then return end

	if (not self:GetTexture() and not self.Rendering) or (self:GetURL() ~= self.LastURL and not self.Rendering) then
		self:RenderTexture()
	elseif self:GetTexture() then
		local ang = self:GetAngles()
		ang:RotateAroundAxis(ang:Up(), 90)
		cam.Start3D2D((self:GetPos() + (self:GetForward() * (-self:OBBMaxs().y + 0.5)) + (self:GetUp() * 1.65) + (self:GetRight() * (self:OBBMaxs().x - 0.5))), ang, 0.0462)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.SetMaterial(self:GetTexture())
		surface.DrawTexturedRect(0, 0, 1014, 1014)
		cam.End3D2D()
	end
end

local all_patterns = {"^https?://.*%.jpg", "^https?://.*%.png", "^https?://.*%.jpeg"}

local function IsValidURL(url)
	for _, pattern in ipairs(all_patterns) do
		if string.match(url, pattern) then return true end
	end
end

local tr = translates
local cached
	if tr then
		cached = {
			tr.Get( 'Изменить изображение' ), 
			tr.Get( 'Расширения .jpg и .png! За нецензуру бан.' ), 
			tr.Get( 'Формат ссылки:' ), 
			tr.Get( 'Изменить' ), 
			tr.Get( 'Ваш аватар' ), 
		}
	else
		cached = {
			'Изменить изображение', 
			'Расширения .jpg и .png! За нецензуру бан.', 
			'Формат ссылки:', 
			'Изменить', 
			'Ваш аватар', 
		}
	end

local fr

net.Receive('rp.OpenImageWindow', function()
	local set
	local text
	local ava

	if IsValid(fr) then
		fr:Close()
	end

	fr = ui.Create('ui_frame', function(self)
		self:SetSize(520, 155)
		self:SetTitle(cached[1])
		self:MakePopup()
		self:Center()

		function self:Think()
			if IsValid(set) and IsValid(text) and IsValidURL(text:GetValue()) then
				set:SetDisabled(false)
			else
				set:SetDisabled(true)
			end
		end
	end)

	text = ui.Create('DTextEntry', function(self, p)
		self:SetPos(5, 90)
		self:SetSize(p:GetWide() - 10, 25)

		self.OnEnter = function(s)
			set:DoClick()
		end
	end, fr)

	ui.Create('DLabel', function(self, p)
		self:SetText(cached[2] .. '\n' .. cached[3] .. ' http://yourdomain.com/image.png')
		self:SetFont('rp.ui.24')
		self:SetTextColor(rp.col.Close)
		self:SizeToContents()
		self:SetPos((p:GetWide() - self:GetWide()) / 2, 35)
	end, fr)

	set = ui.Create('DButton', function(self, p)
		self:SetText(cached[4])
		self:SetPos(5, p:GetTall() - 32)
		self:SetSize(p:GetWide() / 2 - 7.5, 25)

		function self:DoClick()
			p:Close()
			rp.RunCommand('setimage', text:GetValue())
		end
	end, fr)

	ava = ui.Create('DButton', function(self, p)
		self:SetText(cached[5])
		self:SetPos(p:GetWide() / 2 + 2.5, p:GetTall() - 32)
		self:SetSize(p:GetWide() / 2 - 7.5, 25)

		function self:DoClick()
			p:Close()
			rp.RunCommand('setimageavatar')
		end
	end, fr)
/*
	if (LocalPlayer():GetOrg()) then
		ui.Create('DButton', function(self, p)
			set:SetWide(fr:GetWide() / 3 - 6.666)
			ava:SetWide(fr:GetWide() / 3 - 6.666)
			ava:SetPos(set.x + set:GetWide() + 5, ava.y)
			self:SetText('Логотип Организации')
			self:SetPos(ava.x + ava:GetWide() + 5, p:GetTall() - 32)
			self:SetSize(fr:GetWide() - self.x - 5, 25)

			function self:DoClick()
				p:Close()
				rp.RunCommand('setimageorg')
			end
		end, fr)
	end
	*/
end)