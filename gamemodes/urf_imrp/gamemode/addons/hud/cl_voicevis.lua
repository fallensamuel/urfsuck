-- Inspired by IJWTB
PLAYER.GetJobColor = PLAYER.GetJobColor or function(self) return team.GetColor(self:Team()) end -- rp fix

local math 				= math
local table 			= table
local draw 				= draw
local team 				= team
local IsValid 			= IsValid
local CurTime 			= CurTime

local PANEL 			= {}
local PlayerVoicePanels = {}

local color_white 		= Color(255,255,255)
local color_bg 			= Color(0,0,0)
local color_outline 	= Color(20,20,20)
local color_vis_outline	= Color(200,200,200)
local color_vis_bg 		= Color(40,40,40)

local voice_bar = Material('hud_elements/conteiner_urf/voice_cont.png')

surface.CreateFont("DarkRPHudMicro", {
	font = "EuropaNuovaExtraBold",
	extended = true,
	size = 20,
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

local sf_SetDrawColor = surface.SetDrawColor
local sf_DrawTexturedRect = surface.DrawTexturedRect
local sf_SetMat = surface.SetMaterial
local sf_DrawTexturedRectRotated = surface.DrawTexturedRectRotated
local sf_DrawPoly = surface.DrawPoly
local sf_DrawLine = surface.DrawLine
local d_SimpleText = draw.SimpleText


function PANEL:Init()
	self.LabelName = ui.Create('DLabel', self)
	self.LabelName:SetFont('DarkRPHudMicro')
	self.LabelName:SetContentAlignment(6)
	self.LabelName:Dock(FILL)
	self.LabelName:DockMargin(0, 0, 7, 0)
	self.LabelName:SetTextColor(color_white)

	self.Avatar = ui.Create('AvatarImage', self)
	self.Avatar:Dock(LEFT)
	self.Avatar:SetSize(40, 40)

	self.Color = color_transparent
	self.LastThink = CurTime()

	self:SetSize(230, 45)
	self:DockPadding(4, 4, 4, 4)
	self:DockMargin(2, 2, 2, 2)
	self:Dock(BOTTOM)
end

function PANEL:Setup(pl)
	self.pl = pl
	if pl:GetJobTable().reversed then
		self.LabelName:SetText(pl:GetJobName())
	else
		self.LabelName:SetText(pl:Nick())
	end
	--self.LabelName:SetText(pl:Nick())
	self.Avatar:SetPlayer(pl)
	
	self.Color = pl:GetJobColor()

	self:InvalidateLayout()
end


local pl, volume, color, colorb, barH
local d_Box = draw.Box

function PANEL:Paint(w, h)
	if not IsValid(self.pl) then return end
	
	pl 		= self.pl
	volume 	= pl:VoiceVolume()
	color 	= pl:GetJobColor() or color_white
	colorb	= Color(color.r, color.g, color.b, 130)

	pl.VoiceBars 	= pl.VoiceBars or {}

	self.Color 		= color

	if (pl.VoiceBars[26] ~= nil) and (self.LastThink < CurTime() - 0.033) then
		table.remove(pl.VoiceBars, 1)
		pl.VoiceBars[26] = (((volume == 0) and (pl == LocalPlayer())) and math.Rand(0, 1) or math.Clamp(volume, 0.05, 1))
		self.LastThink = CurTime()
	end

	sf_SetDrawColor(color)
	sf_SetMat(voice_bar)
	sf_DrawTexturedRect(42, 4, 190, 36)

	for i = 1, 26 do
		if (pl.VoiceBars[i] == nil) then
			pl.VoiceBars[i] = (((volume == 0) and (pl == LocalPlayer())) and math.Rand(0, 0.8) or math.Clamp(volume, 0.025, 1))
		end
		
		barH = pl.VoiceBars[i] * 26
		d_Box((w - 170) + (7 * (i - 1)) - 12, h - barH - 5, 6, barH, colorb)
	end
end

function PANEL:Think()
	if IsValid(self.pl) then
		if self.pl:GetJobTable().reversed then
			self.LabelName:SetText((self.pl:GetNetVar('RC_RadioOnSpeak') && '[РАЦИЯ] ' or '') .. self.pl:GetJobName())
		else
			self.LabelName:SetText((self.pl:GetNetVar('RC_RadioOnSpeak') && '[РАЦИЯ] ' or '') .. self.pl:Nick())
		end
		--self.LabelName:SetText(self.pl:Name())
	else
		self:Remove()
	end
	
	if self.fadeAnim then
		self.fadeAnim:Run()
	end
end

function PANEL:FadeOut(anim, delta, data)
	if anim.Finished then
		if IsValid(PlayerVoicePanels[self.pl]) then
			PlayerVoicePanels[self.pl]:Remove()
			PlayerVoicePanels[self.pl] = nil
			return 
		end
		return 
	end
	self:SetAlpha(255 - (255 * delta))
end

hook.Add('InitPostEntity', 'ba.vv_new.InitPostEntity', function() timer.Simple(10, function() 
	derma.DefineControl('VoiceNotify', '', PANEL, 'DPanel')
	
	function GAMEMODE:PlayerStartVoice(pl)
		if not IsValid(g_VoicePanelList) then return end

		GAMEMODE:PlayerEndVoice(pl)

		if IsValid(PlayerVoicePanels[pl]) then
			if PlayerVoicePanels[pl].fadeAnim then
				PlayerVoicePanels[pl].fadeAnim:Stop()
				PlayerVoicePanels[pl].fadeAnim = nil
			end
			PlayerVoicePanels[pl]:SetAlpha(255)
			return
		end

		if not IsValid(pl) then return end

		local pnl = g_VoicePanelList:Add('VoiceNotify')
		pnl:Setup(pl)
		
		PlayerVoicePanels[pl] = pnl
	end

	function GAMEMODE:PlayerEndVoice(pl)
		if IsValid(PlayerVoicePanels[pl]) then
			if (PlayerVoicePanels[pl].fadeAnim) then return end

			PlayerVoicePanels[pl].fadeAnim = Derma_Anim('FadeOut', PlayerVoicePanels[pl], PlayerVoicePanels[pl].FadeOut)
			PlayerVoicePanels[pl].fadeAnim:Start(1)
		end
	end
	
	timer.Simple(0, function()
		if IsValid(g_VoicePanelList) then g_VoicePanelList:Remove() end
		g_VoicePanelList = ui.Create('DPanel')
		g_VoicePanelList:ParentToHUD()
		g_VoicePanelList:SetPos(ScrW() - 255, 100)
		g_VoicePanelList:SetSize(230, ScrH() - 200)
		g_VoicePanelList.Paint = function() end
	end)
end) end)