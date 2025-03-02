include'shared.lua'

function ENT:RenderTexture()
	self.Rendering = true

	if (string.sub(self:GetURL(), 1, 4) == 'ORG:') then
		self.IsOrg = true
		self.OrgName = string.sub(self:GetURL(), 5)
		self.LastURL = self:GetURL()
	else
		self.IsOrg = false
		wmat.Delete(self:EntIndex())

		wmat.Create(self:EntIndex(), {
			URL = self:GetURL(),
			W = 2028,
			H = 2028
		}, function(material)
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
		surface.DrawTexturedRect(0, 0, 2028, 2028)
		cam.End3D2D()
	end
end
