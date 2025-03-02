local add
local whitecolr, graycolr = Color(255, 255, 255), Color(123, 123, 123)
local blur = Material("pp/blurscreen")
local scrw, scrh = ScrW(), ScrH()
local font, fontbig, fontsmall, fontdemismall = "GlassUIFont", "GlassUIFontBIG", "GlassUIFontSMALL", "GlassUIDemiSmall"

surface.CreateFont(font, {
	font = "Roboto Lt",
	weight = 250,
	size = 24,
	antialias = true,
	extended = true
})

surface.CreateFont(fontbig, {
	font = "Roboto",
	weight = 250,
	size = 46,
	antialias = true,
	extended = true
})

surface.CreateFont(fontsmall, {
	font = "Roboto Lt",
	weight = 250,
	size = 16,
	antialias = true,
	extended = true
})

surface.CreateFont(fontdemismall, {
	font = "Roboto Lt",
	weight = 250,
	size = 18,
	antialias = true,
	extended = true
})


local function __dontdraw()
end

local function __paintbox(self, w, h)
	surface.SetDrawColor(30, 30, 30, 100)
	surface.DrawRect(0, 0, w, h)
	surface.SetDrawColor(100, 100, 100, 150)
	surface.DrawOutlinedRect(0, 0, w, h)

	self:DrawTextEntryText(self:GetTextColor(), Color(66, 66, 66, 150), whitecolr)
end

local function __blur()
	add = math.Approach(add, 1, 0.025)

	render.UpdateScreenEffectTexture()
	surface.SetDrawColor(whitecolr)
	surface.SetMaterial(blur)
	for i = 1, 11 do
		blur:SetFloat("$blur", (i / 16) * add * 6)
		blur:Recompute()
		surface.DrawTexturedRect(0, 0, scrw, scrh)
	end

	surface.SetDrawColor(0, 0, 0, add * 180)
	surface.DrawRect(0, 0, scrw, scrh)
end

local function __hidehud(s)
	return s == "CHudMenu"
end

local function __close()
	hook.Remove("RenderScreenspaceEffects", "__donatblur")
	hook.Remove("HUDShouldDraw", "__donathidehud")
	add = nil
end

local button
local function __dropdonatmenu()
	add = 0
	hook.Add("RenderScreenspaceEffects", "__donatblur", __blur)
	hook.Add("HUDShouldDraw", "__donathidehud", __hidehud)
	
	local url, frame, numentry

	frame = vgui.Create("GFrame")
	frame:SetSize(520, 340)
	frame:MakePopup()
	frame:Center()
	frame.OnClose = __close
	frame.OnRemove = __close
	frame:SetTitle("Заголовок")

	frame:SetSkin('SUP')
	
	local panel = vgui.Create("DPanel", frame)
	panel:SetDrawBackground(false)
	panel:SetHeight(65)
	panel:Dock(TOP)
	
	panel:SetSkin('SUP')

	local t = vgui.Create("DLabel", panel)
	t:SetText("Выберите количество:")
	t:SetFont(font)
	t:SetPos(10, 10)
	t:SetSize(250, 32)
	
	t:SetSkin('SUP')

	local numentry = vgui.Create("DNumberWang", panel)
	numentry:SetValue(300)
	numentry:SetFont(font)
	numentry:SetPos(260, 10)
	numentry:SetSize(250, 32)
	numentry:SetDecimals(0)
	numentry:SetContentAlignment(5)
	numentry:SetMinMax(1, math.huge)
	--numentry:SetTextColor(whitecolr)
	--numentry.Paint = __paintbox
	numentry.OnValueChanged = function(self, val)
		button:SetText("Купить " .. val .. " кредитов за " .. val * 1 .. " Руб.")
	end
	
	numentry:SetSkin('SUP')

	local panel = vgui.Create("DPanel", frame)
	panel:SetDrawBackground(false)
	panel:SetHeight(32)
	panel:Dock(TOP)
	
	panel:SetSkin('SUP')

	local values = {50, 150, 500, 1000, 5000}
	for i = 1, 5 do
		local b, value = vgui.Create("DButton", panel), values[i] or i * 50
		b:SetText(value)
		b:SetFont(fontdemismall)
		b:SetSize(64, 24)
		b:DockMargin(0, 0, 48, 0)
		--b:SetColor(Color(200, 200, 200))
		b:SetSkin('SUP')
		b:Dock(LEFT)
		b.DoClick = function() numentry:SetValue(value) end
	end

	local panel = vgui.Create("DPanel", frame)
	panel:SetDrawBackground(false)
	panel:SetHeight(88)
	panel:Dock(TOP)
	
	panel:SetSkin('SUP')

	button = vgui.Create("DButton", panel)
	button:SetText("Купить 300 кредитов за 300 Руб.")
	button:SetFont(font)
	button:DockMargin(0, 16, 0, 0)
	button:Dock(FILL)
	--button:SetColor(Color(123, 255, 123))
	--button.m_cBackground = Color(123, 255, 123)

	button:SetSkin('SUP')
	
		--button.Paint = function(btn, w, h)
		--	derma.SkinHook('Paint', 'TabButton', btn, w, h)
		--end
		
	
	button.DoClick = function()
		--gui.OpenURL(url:GetValue())
		button:SetEnabled(false)
		
		local donation = donations.get("points")
		donations.getMethodByName('robokassa'):onClick(donation, nil, numentry:GetValue())
	end

	local panel = vgui.Create("DPanel", frame)
	panel:SetDrawBackground(false)
	panel:SetHeight(50)
	panel:Dock(TOP)
	
	panel:SetSkin('SUP')

	--[[
	url = vgui.Create("DTextEntry", panel)
	url:SetText("https://urf.im")
	url:SetEditable(false)
	url:SetFont(font)
	url:SetTextColor(graycolr)
	url:SetWidth(410)
	url:DockMargin(0, 16, 0, 8)
	url:SetMouseInputEnabled(true)
	url:Dock(LEFT)
	url.Paint = __paintbox

	local b = vgui.Create("GButton", panel)
	b:SetText("Копировать")
	b:DockMargin(4, 16, 0, 8)
	b:SetFont(fontsmall)
	b:Dock(FILL)
	b.DoClick = function( ... )
		SetClipboardText(url:GetValue())
	end

	local panel = vgui.Create("DPanel", frame)
	panel:SetDrawBackground(false)
	panel:SetHeight(111)
	panel:Dock(TOP)]]

	local panel = vgui.Create("DPanel", frame)
	panel:SetDrawBackground(false)
	panel:Dock(FILL)
	
	panel:SetSkin('SUP')

	local t = vgui.Create("DLabel", panel)
	t:SetFont(fontsmall)
	--t:SetColor(graycolr)
	t:SetText("Есть скины Counter Strike: Global Offensive, Dota 2, PUBG? Обменяй их на кредиты!")
	t:Dock(TOP)
	t:SetContentAlignment(5)

	t:SetSkin('SUP')
	
	local b = vgui.Create("DButton", panel)
	b:SetText("Пополнить скинами")
	b:SetSize(180, 25)
	b:SetPos(170, 35)
	b:SetFont(fontsmall)
	b.DoClick = function()
		frame:Close()
		net.Start("donations.buy")
			net.WriteString("points")
			net.WriteInt(donations.getMethodByName('skins').id, 8)
			net.WriteInt(0, 17)
		net.SendToServer()
	end
	
	b:SetSkin('SUP')
end

hook('donations.GotUrl', function()
	if button and button:IsValid() then
		button:SetEnabled(true)
	end
end)

concommand.Add("upgrades", __dropdonatmenu)