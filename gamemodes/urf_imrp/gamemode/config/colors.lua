
local c = Color

rp.col = {
	SUP 		= c(51,128,255),

	-- Misc
	Black 		= c(0,0,0),
	White 		= c(255,255,255),
	Red 		= c(245,0,0),
	Orange 		= c(245,120,0),
	Purple 		= c(180,50,200),
	Green 		= c(50,200,50),
	Grey 		= c(150,150,150),
	Yellow 		= c(255,255,51),
	Pink 		= c(245,120,120),

	-- Chat
	OOC 		= c(100,255,150),
	-- UI 
	Background 		= c(0,0,0,230),
	Outline 		= c(190,190,190,200),
	Highlight 		= c(255,255,255,125),
	Button 			= c(120,120,120),
	ButtonHovered	= c(51,128,255),
}

-- Chat Colors
rp.chatcolors = {}
for k, v in pairs(rp.col) do
	local count = #rp.chatcolors + 1
	rp.chatcolors[k] = count
	rp.chatcolors[count] = v
end

rp.cfg.UIColor = rp.cfg.UIColor or {}
rp.cfg.UIColor.BlockHeader = c(0, 0, 0)
rp.cfg.UIColor.BlockHeaderInverted = c(255, 255, 255)
rp.cfg.UIColor.SubHeader = c(255, 255, 255)

rp.cfg.UIColor.Selected = c(255, 255, 255)

rp.cfg.UIColor.Blank      = c(0, 0, 0, 0)
rp.cfg.UIColor.White      = c(255, 255, 255, 255)
rp.cfg.UIColor.Black      = c(0, 0, 0, 255)
rp.cfg.UIColor.Tooltip    = c(0, 0, 0, 228)
rp.cfg.UIColor.Active     = c(255, 255, 255, 255)
rp.cfg.UIColor.Background = c(0, 0, 0, 127)
rp.cfg.UIColor.Hovered    = c(0, 0, 0, 180)
rp.cfg.UIColor.Shading    = c(0, 12, 24, 74)

if CLIENT then
	ui.col = {
		SUP 			= c(51,128,255),
		Background 		= c(10,10,10,170),
		Outline 		= c(100,100,100,255),
		Hover 			= c(160,160,160,40),


		Button 			= c(140,140,140),
		ButtonHover 	= c(220,220,220),
		ButtonRed 		= c(240,0,0),
		ButtonGreen 	= c(0,240,0),
		Close 			= c(235,235,235),
		CloseBackground = c(215,45,90),
		CloseHovered 	= c(235,25,70),


		OffWhite 		= c(200,200,200),
		FlatBlack 		= c(40,40,40),
		Black 			= c(0,0,0),
		White 			= c(255,255,255),
		Red 			= c(255,0,0),
		Orange 			= c(245,120,0),
	}
	
	hook.Run('ui.col.ColorsChanged')
end