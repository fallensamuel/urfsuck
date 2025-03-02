-- Modified notification.AddLegacy
cvar.Register 'notification_sound'
	:SetDefault(true)
	:AddMetadata('Menu', 'Звук уведомлений (Капля)')

notification = {}


surface.CreateFont("rpui.Notify", {
    font = "Montserrat",
    extended = true,
    weight = 600,
    size = 22,
	--shadow = true,
})


NOTIFY_GENERIC	= 0
NOTIFY_ERROR 	= 1
NOTIFY_UNDO		= 2
NOTIFY_CLEANUP 	= 4
NOTIFY_HINT 	= 4

NOTIFY_RED 		= NOTIFY_ERROR
NOTIFY_GREEN	= 3
NOTIFY_BLUE		= NOTIFY_HINT


local color_grey 	= Color(150,150,150)
local color_white 	= Color(235,235,235)
local color_bg 		= Color(0,0,0,230)


local notifyTypes 	= {
	[0]	= Color(255,128,51),
	[1]	= Color(150,39,43),
	[2]	= Color(51,128,255),
	[3]	= Color(30,152,43),
	[4]	= Color(51,128,255)
}

local notifyMats 	= {
	[0]	= Material('rpui/notify/1.png'),
	[1]	= Material('rpui/notify/2'),
	[2]	= Material('rpui/notify/1.png'),
	[3]	= Material('rpui/notify/2'),
	[4]	= Material('rpui/notify/1.png')
}

local Notices = {}

function notification.AddProgress( uid, text )
end

function notification.Kill( uid )
	if ( !IsValid( Notices[ uid ] ) ) then return end
	
	Notices[ uid ].StartTime 	= SysTime()
	Notices[ uid ].Length 		= 0.8
end

function notification.AddLegacy( text, type, length )
	if (type == nil) then
		type = 0
	end

	text = tostring(text)

	local parent
	if ( GetOverlayPanel ) then parent = GetOverlayPanel() end

	local Panel = ui.Create( 'NoticePanel', parent )
	Panel.NotifyType = type > 5 and 0 or type
	Panel.StartTime 	= SysTime()
	Panel.Length 		= length
	Panel.VelX			= 0
	Panel.VelY			= 0
	Panel.fx 			= ScrW() + 200
	Panel.fy 			= ScrH()
	Panel:SetText( text )
	Panel:SetPos( Panel.fx, Panel.fy )
	
	table.insert( Notices, Panel )

	local color = notifyTypes[type]
	MsgC(color_grey, '[', color, 'Notification', color_grey, '] ', color_white, text .. '\n')
	
	if (cvar.GetValue("notification_sound")) then
		surface.PlaySound('ambient/water/drip4.wav')
	end
end

-- This is ugly because it's ripped straight from the old notice system
local function UpdateNotice( i, Panel, Count )
	local x = Panel.fx
	local y = Panel.fy
	
	local w = Panel:GetWide() + 16
	local h = Panel:GetTall() + 16
	
	local ideal_y = ScrH() - (Count - i) * (h - 12) - 150
	local ideal_x = ScrW() - w - 20

	local timeleft = Panel.StartTime - (SysTime() - Panel.Length)

	if ( timeleft < 0.2  ) then
		ideal_x = ideal_x + w * 2
	end

	local spd = FrameTime() * 15
	
	y = y + Panel.VelY * spd
	x = x + Panel.VelX * spd
	
	local dist = ideal_y - y
	Panel.VelY = Panel.VelY + dist * spd * 1
	if (math.abs(dist) < 2 && math.abs(Panel.VelY) < 0.1) then Panel.VelY = 0 end
	local dist = ideal_x - x
	Panel.VelX = Panel.VelX + dist * spd * 1
	if (math.abs(dist) < 2 && math.abs(Panel.VelX) < 0.1) then Panel.VelX = 0 end
	
	-- Friction.. kind of FPS independant.
	Panel.VelX = Panel.VelX * (0.9 - FrameTime() * 8)
	Panel.VelY = Panel.VelY * (0.9 - FrameTime() * 8)

	Panel.fx = x
	Panel.fy = y
	Panel:SetPos( Panel.fx, Panel.fy )
end


hook.Add('Think', 'NotificationThink', function()
	for k, v in ipairs(Notices) do
		UpdateNotice(k, v, #Notices)
		if IsValid(v) and v:KillSelf() then
			table.remove(Notices, k)
		end
	end
end)


local PANEL = {}

function PANEL:Init()
	self.NotifyType = NOTIFY_GENERIC
	
	self.Label = ui.Create( 'DLabel', self )
	--self.Label:SetFont( 'rp.ui.22' )
	self.Label:SetFont( 'rpui.Notify' )
	self.Label:SetTextColor( color_white )
	self.Label:SetPos(20 + 24, 5)
end

function PANEL:SetText( txt )
	self.Label:SetText( txt )

	self:SizeToContents()
end

function PANEL:SizeToContents()
	self.Label:SizeToContents()

	self:SetWidth( self.Label:GetWide() + 10 + 5 + 20 + 24 + 5 )
	self:SetHeight( 34 )
	self:InvalidateLayout()
end

function PANEL:KillSelf()
	if ( self.StartTime + self.Length < SysTime() ) then
		self:Remove()
		return true
	end
	return false
end

function PANEL:Paint(w, h)
	local timeleft = self.StartTime - (SysTime() - self.Length)
	local color = notifyTypes[self.NotifyType]

	draw.Blur(self)
	
	surface.SetDrawColor(0, 0, 0, 150)
	surface.DrawRect(0, 0, w, h)
	
	surface.SetDrawColor(color)
	surface.DrawRect(w - 5, 0, 5, h)
	
	surface.SetMaterial(notifyMats[self.NotifyType])
	surface.DrawTexturedRect(5, 5, h - 10, h - 10)
	
	--draw.OutlinedBox(0, 0, w, h, color_bg, color)
	--draw.Box(0, h - 3, w * (timeleft/self.Length), 3, color)
end
vgui.Register('NoticePanel', PANEL, 'ui_panel')