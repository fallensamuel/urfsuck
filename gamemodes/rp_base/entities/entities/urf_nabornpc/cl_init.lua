-- "gamemodes\\rp_base\\entities\\entities\\urf_nabornpc\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include'shared.lua'

function ENT:Draw()
	self:DrawModel()
end

local menu
function ENT:OpenMenu()
	if IsValid(menu) then 
		return 
	end
	
	local title = string.Explode("<br>", self:GetNPCNameAndBT())
	local text = self:GetNPCText1() .. self:GetNPCText2()
	local url = self:GetNPCUrl()
	local btn_text = title[2]
	title = title[1]
	
	local frameH = ScrH()
	
    surface.CreateFont("rpui.Fonts.Seasonpass.Notify", {
        font     = "Montserrat",
        extended = true,
        weight   = 700,
        size     = math.ceil(frameH * 0.027),
    })
	
    surface.CreateFont("rpui.Fonts.Social.Title", {
        font = "Montserrat",
        extended = true,
        weight = 500,
        size = math.max(math.ceil(frameH * 0.025), 25)
    })
	
	local h_mul = math.floor(ScrH() * 0.195) / 150
	local linedText = string.Explode( "\n", string.Replace( text, "\\n", "\n" ) )
	local wrappedText = {}
	
	for k, v in pairs(linedText) do
		for k1, v1 in pairs( string.Wrap( 'rpui.Fonts.Social.Title', v, 420 * h_mul * 0.8 ) ) do
			table.insert(wrappedText, v1)
		end
	end
	
	menu = vgui.Create('urf.im/rpui/menus/blank')
	menu:SetSize(420 * h_mul, (175 * h_mul + (#wrappedText - 2) * 22 * h_mul))
	menu:Center()
	menu:MakePopup()

	menu.header.SetIcon(menu.header, 'rpui/standart.png')
	menu.header.SetTitle(menu.header, title)
	menu.header.SetFont(menu.header, "rpui.Fonts.Social.Title")
	menu.header.IcoSizeMult = 1.4 + 0
	
	for k, v in pairs(wrappedText) do
		local label1 = vgui.Create("DLabel", menu.workspace)
		label1.Dock(label1, TOP)
		label1.SetTall(label1, h_mul * 23)
		label1.DockMargin(label1, 10, 22 * h_mul * (k == 1 and 1 or 0), 10, 0)
		label1.SetFont(label1, "rpui.Fonts.Social.Title")
		label1.SetContentAlignment(label1, 5)
		label1.SetText(label1, v)
	end

	local ok = vgui.Create("DButton", menu.workspace)
	ok.Dock(ok, BOTTOM)
	ok.SetTall(ok, h_mul * 32)
	ok.DockMargin(ok, 10, 0, 10, 10)
	ok.SetText(ok, "")
	ok.Paint = function(me, w, h)
		local baseColor, textColor = rpui.GetPaintStyle( me, STYLE_TRANSPARENT );
		surface.SetDrawColor( baseColor );
		surface.DrawRect( 5, 1, w - 20, h - 1 );

		draw.SimpleText( btn_text, "rpui.Fonts.Social.Title", w*0.5, h*0.5, textColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );

		return true;
	end
	ok.DoClick = function()
		gui.OpenURL(url)
		menu:Remove()
	end
end

net.Receive("NaborNPC::OpenMenu", function()
	local ent = net.ReadEntity()
	if not IsValid(ent) or not ent.OpenMenu then return end
	
	ent:OpenMenu()
end)

rp.AddBubble("entity", "urf_nabornpc", {
	ico = Material("rpui/standart.png", "smooth noclamp"),
	offset = Vector(0, 0, 25),
	name = function(ent)
		if ent.SavedName and ent.SavedName ~= '' then return ent.SavedName end
		
		if IsValid(ent) and ent.GetNPCNameAndBT then
			local title = string.Explode("<br>", ent:GetNPCNameAndBT())
			title = title[1]
			
			ent.SavedName = title
			
			return title
			
		else
			return translates.Get('NPC Набора')
		end
	end,
	desc = function(ent)
		return translates.Get("[Е] Взаимодействие");
	end,
	--as_texture = true,
	scale = 0.6,
	ico_col = Color(115, 146, 255),
	title_colr = Color(115, 146, 255),
	customCheck = function(ent)
		return true
	end,
})
