include('shared.lua')

function ENT:Initialize()
end

/*
function ENT:RenderTexture()
	self.Rendering = true
	
	wmat.Delete(self:EntIndex())
	
	wmat.Create(self:EntIndex(), {
		URL = self:GetURL(),
		W = 1014,
		H = 2100
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

function ENT:GetTexture()
	return wmat.Get(self:EntIndex())
end

local pos_offset = Vector(17.7, -23.5, 96.2)

surface.CreateFont("EntShop::Name", {
    font     = "Montserrat", 
    extended = true,
    weight   = 900,
    size     = 80,
});

surface.CreateFont( 'EntShop::Header', {
	font = 'Enhanced Dot Digital-7',
	size = 150,
	weight = 1000,
	antialias = true,
	extended = true
})
*/

function ENT:SetDrawText(text)
	self.HeaderText = text
	/*
	self.CurLetter = 1
	self.GainedLength = 0
	self.HeaderOffset = -1500
	self.RealHeaderOffset = -1500
	self.HeaderTempText = ''
	self.CurEndLetter = 1
	
	surface.SetFont('EntShop::Header')
	self.HeaderAllLength = surface.GetTextSize(text) + 20
	
	self.HeaderLength = {}
	
	local i = 0
	for v in string.gmatch(text, utf8.charpattern) do 
		i = i + 1
		self.HeaderLength[i] = surface.GetTextSize(v)
	end
	
	self.MaxLength = i
	*/
end

local FrameTime = FrameTime
local cam_Start3D2D = cam.Start3D2D
local cam_End3D2D = cam.End3D2D
local draw_SimpleText = draw.SimpleText
local surface_SetDrawColor = surface.SetDrawColor
local surface_SetMaterial = surface.SetMaterial
local surface_DrawRect = surface.DrawRect
local surface_DrawTexturedRect = surface.DrawTexturedRect

local mat_gr_down = Material('gui/gradient_down')
local mat_gr_up = Material('gui/gradient_up')

function ENT:Draw()
	self:DrawModel()
	if not self:InSight() then return end

	if self.HeaderText ~= self:GetHeader() then 
		self.HeaderText = self:GetHeader()
	end
	
	/*
	if (not self:GetTexture() and not self.Rendering) or (self:GetURL() ~= self.LastURL and not self.Rendering) then
		self:RenderTexture()
		
	elseif self:GetTexture() then
		local ang = self:GetAngles()
		
		ang:RotateAroundAxis(ang:Forward(), -90)
		ang:RotateAroundAxis(ang:Up(), 180)
		
		cam_Start3D2D((self:GetPos() + (self:GetForward() * pos_offset.x) + (self:GetUp() * pos_offset.z) + (self:GetRight() * pos_offset.y)), ang, 0.03)
			surface_SetDrawColor(0, 0, 0, 255)
			surface_DrawRect(0, 0, 1014, 2100)
			
			surface_SetDrawColor(255, 255, 255, 255)
			surface_SetMaterial(self:GetTexture())
			surface_DrawTexturedRect(0, 50, 1014, 2050)
			
			surface_SetDrawColor(0, 0, 0, 255)
			surface_SetMaterial(mat_gr_down)
			surface_DrawTexturedRect(0, 48, 1014, 500)
			surface_SetMaterial(mat_gr_up)
			surface_DrawTexturedRect(0, 2100 - 140, 1014, 140)
			
			--draw_SimpleText(IsValid(self:GetOwnerPly()) and self:GetOwnerPly():Name() or '', 'EntShop::Name', 506, 146, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
			
			if not self.HeaderLength or self.HeaderText ~= self:GetHeader() then
				self:SetDrawText(self.GetHeader and self:GetHeader() or IsValid(self:GetOwnerPly()) and self:GetOwnerPly():Name() or 'Стационарный магазин')
			end
			
			surface_DrawRect(-120, -482, 1420, 310)
			
			--[[
			draw_SimpleText(self.HeaderText, 'EntShop::Header', -120 - self.HeaderOffset, -422, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			self.HeaderOffset = self.HeaderOffset + 250 * FrameTime()
			
			if self.HeaderOffset > self.HeaderLength then
				self.HeaderOffset = -1500
			end
			]]
			
			local cur_letter_length = self.HeaderLength[self.CurLetter]
			local cur_end_letter_length = self.HeaderLength[self.CurEndLetter]
			
			draw_SimpleText(self.HeaderTempText, 'EntShop::Header', -120 - self.HeaderOffset, -410, Color(255, 255, 255, 255), TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
			
			self.HeaderOffset = self.HeaderOffset + 250 * FrameTime()
			self.RealHeaderOffset = self.RealHeaderOffset + 250 * FrameTime()
			
			--if self.HeaderOffset > self.HeaderAllLength then
			--	self.HeaderOffset = -1500
			--	self.HeaderTempText = self.HeaderText
			--	self.CurLetter = 1
			--
			--else
			
			if self.CurEndLetter <= self.MaxLength then
				if self.RealHeaderOffset + 1500 > cur_end_letter_length + self.GainedLength then
					self.GainedLength = self.GainedLength + cur_end_letter_length
					self.HeaderTempText = self.HeaderTempText .. utf8.sub(self.HeaderText, self.CurEndLetter, self.CurEndLetter)
					self.CurEndLetter = self.CurEndLetter + 1
				end
			end
			
			if self.HeaderOffset >= cur_letter_length - 30 then
				self.CurLetter = self.CurLetter + 1
				self.HeaderOffset = self.HeaderOffset - cur_letter_length
				self.HeaderTempText = utf8.sub(self.HeaderTempText, 2)
				
				if self.HeaderTempText == '' then
					self.HeaderOffset = -1500
					self.RealHeaderOffset = -1500
					self.HeaderTempText = '' --self.HeaderText
					self.CurLetter = 1
					self.CurEndLetter = 1
					self.GainedLength = 0
				end
			end
		cam_End3D2D()
	end
	*/
end

/*
local all_patterns = {"^https?://.*%.jpg", "^https?://.*%.png", "^https?://.*%.jpeg"}

local function IsValidURL(url)
	for _, pattern in ipairs(all_patterns) do
		if string.match(url, pattern) then return true end
	end
end
*/

net.Receive('ShopEnt::OpenShop', function()
	local ent_ind = net.ReadUInt(32)
	local ent = ents.GetByIndex(ent_ind)
	if not IsValid(ent) then return end
	
	local items_count = net.ReadUInt(16)
	local custom_items = {}
	
	for k = 1, items_count do
		local uID = net.ReadString()
		
		custom_items[uID] = {
			uniqueID = uID,
			price = net.ReadUInt(32),
			count = net.ReadUInt(12),
		}
	end
	
	rp.item.openVendorMenu(ent_ind, false, custom_items)
end)
