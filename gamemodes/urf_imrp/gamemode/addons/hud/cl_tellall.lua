local FrameTime	= FrameTime
local timer 	= timer
local surface 	= surface
	
local msgQueue	= {}
local createStaffMessage -- function defined later

surface.CreateFont("DarkRPHudMedium2", {
	font = "EuropaNuovaExtraBold",
	extended = true,
	size = 35,
	weight = 500,
	blursize = 0,
	scanlines = 0,
	antialias = true,
	underline = false,
	italic = false,
	strikeout = false,
	symbol = false,
	rotary = false,
	shadow = true,
	additive = false,
	outline = false,
})

local PANEL = {}
	 
function PANEL:Init()
	self.Slides = 3
end

function PANEL:Close()
	timer.Simple(1, function() 
		if (self:IsValid()) then 
			-- pTheme.Close(self) 
			self:Remove() -- Thats sure will work
		end 
		
		if (msgQueue[1]) then 
			createStaffMessage() 
		end 
	end)
end

function PANEL:SetMessage(str)
	self:SetSize(ScrW()/3, 56)
	self:SetPos(ScrW()/2 - self:GetWide()/2, 100)
		
	surface.SetFont('DarkRPHudMedium2')
		
	self.Msg = str
	self.Length = surface.GetTextSize(str) + 20
	self.Slides = 3
end

local color_black = Color(0,0,0)
local color_white = Color(255,255,255)
local color_text = Color(236, 197, 96)
local tellall_bar = Material('hud_elements/conteiner_urf/tellall_cont.png')
	
local sf_SetDrawColor = surface.SetDrawColor
local sf_DrawTexturedRect = surface.DrawTexturedRect
local sf_SetMat = surface.SetMaterial
local d_SimpleText = draw.SimpleText
	
function PANEL:Paint(w, h)
	self.Offset = (self.Offset or self:GetWide()) - (self.Slides > 0 and FrameTime() * 100 or 0)
		
	sf_SetDrawColor(color_white)
	sf_SetMat(tellall_bar)
	sf_DrawTexturedRect(0, 0, self:GetWide(), 56)
	
	d_SimpleText(self.Msg, 'DarkRPHudMedium2', 20 + self.Offset, 11, color_text, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP)
	
	if self.Offset < -self.Length then
		self.Offset = self:GetWide()
		self.Slides = self.Slides - 1
		
		if self.Slides == 0 then
			self:Close()
		end
	end
end

derma.DefineControl('ba_msg', 'badmin tellall', PANEL, 'ui_panel')

createStaffMessage = function()
	activeElement = ui.Create('ba_msg', function(self)
		self.RunOut = CurTime() + 12
		self:SetMessage(table.remove(msgQueue, 1))
	end)
end

net.Receive('ba.TellAll', function()
	local str = net.ReadString()
	
	table.insert(msgQueue, str)
	
	if (!IsValid(activeElement)) then
		createStaffMessage()
	end
end)