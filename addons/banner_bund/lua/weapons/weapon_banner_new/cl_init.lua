include('shared.lua')


SWEP.WepSelectIcon = surface.GetTextureID( "weapons/banner0_hud" )

function SWEP:Initialize()
	killicon.Add("weapon_banner0", "killicons/banner_killicon", color_white)
	self:SetHoldType( "melee2" )
end

local fr
local all_patterns = {"^https?://.*%.jpg", "^https?://.*%.png", "^https?://.*%.jpeg"}

local function IsValidURL(url)
	for _, pattern in ipairs(all_patterns) do
		if string.match(url, pattern) then return true end
	end
end

local function drawImageWindow()
	local set
	local text
	local ava
	
	if IsValid(fr) then
		fr:Close()
	end
	
	fr = ui.Create('ui_frame', function(self)
	self:SetSize(520, 155)
		self:SetTitle('Изменить изображение')
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
		self:SetText('Расширения .jpg и .png! За нецензуру бан.\nФормат ссылки: http://yourdomain.com/image.png')
		self:SetFont('rp.ui.24')
		self:SetTextColor(rp.col.Close)
		self:SizeToContents()
		self:SetPos((p:GetWide() - self:GetWide()) / 2, 35)
	end, fr)

	set = ui.Create('DButton', function(self, p)
		self:SetText('Изменить')
		self:SetPos(5, p:GetTall() - 32)
		self:SetSize(p:GetWide() - 10, 25)

		function self:DoClick()
			p:Close()
			rp.RunCommand('setimagebanner', text:GetValue())
		end
	end, fr)
end
	
function SWEP:Reload()
	if not IsValid(self) then return end
	if !IsFirstTimePredicted() then return end
	drawImageWindow()
end
	
	
function SWEP:RenderTexture()
	self.Rendering = true
	
	wmat.Delete(self:EntIndex())
	
	wmat.Create(self:EntIndex(), {
		URL = self:GetURLt(),
		W = 1100,
		H = 589
	}, function(material)
		if IsValid(self) then
			self.Rendering = false
			self.LastURL = self:GetURLt()
		end
	end, function()
		if IsValid(self) then
			self.Rendering = false
		end
	end)
end

function SWEP:GetTexture()
	return wmat.Get(self:EntIndex())
end

function SWEP:DrawWorldModel()
	self:DrawModel()
	
	if cvar.GetValue('enable_pictureframes') == false or not self:InSight() then return end

	if (not self:GetTexture() and not self.Rendering) or (self:GetURLt() ~= self.LastURL and not self.Rendering) then
		self:RenderTexture()
		
	elseif self:GetTexture() then
		local ent = self.Owner or self
		
		local bone = ent:LookupBone('ValveBiped.Bip01_R_Hand')
		local pos, ang = Vector(0, 0, 0), Angle(0, 0, 0)
		
		local m = ent:GetBoneMatrix(bone)
		
		if m then
			pos, ang = m:GetTranslation(), m:GetAngles()
		end
		
		ang:RotateAroundAxis(ang:Up(), -45)
		ang:RotateAroundAxis(ang:Forward(), -96)
		ang:RotateAroundAxis(ang:Right(), -34)
		
		cam.Start3D2D(pos + ang:Forward() * -23.4 + ang:Right() * -47.9 + ang:Up() * 4.9, ang, 0.0462)
			surface.SetDrawColor(255, 255, 255, 255)
			surface.SetMaterial(self:GetTexture())
			surface.DrawTexturedRect(0, 0, 1100, 589)
		cam.End3D2D()


		
	end
end

function SWEP:DrawWeaponSelection( x, y, wide, tall, alpha )

	-- Set us up the texture
	surface.SetDrawColor( 255, 255, 255, alpha )
	if self:GetTexture() then
		surface.SetMaterial(self:GetTexture())
	else
		surface.SetTexture( self.WepSelectIcon )
	end

	-- Lets get a sin wave to make it bounce
	local fsin = 0

	if ( self.BounceWeaponIcon == true ) then
		fsin = math.sin( CurTime() * 10 ) * 5
	end

	-- Borders
	y = y + 10
	x = x + 10
	wide = wide - 20

	-- Draw that mother
	surface.DrawTexturedRect( x + ( fsin ), y - ( fsin ),	wide-fsin*2 , ( wide / 2 ) + ( fsin ) )

	-- Draw weapon info box
	self:PrintWeaponInfo( x + wide + 20, y + tall * 0.95, alpha )

end