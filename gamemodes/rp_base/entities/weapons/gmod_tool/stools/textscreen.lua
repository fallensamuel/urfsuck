TOOL.Category		= "Roleplay"
TOOL.Name			= "#Textscreen"
TOOL.Command		= nil
TOOL.ConfigName		= ""

local allowablefonts = {
	"Open Sans Light",
	"Tahoma",
	"Helvetica",
	"Trebuchet MS",
	"Comic Sans MS",
	"Segoe UI",
	"Impact",
	"Broadway",
	"Webdings",
	"Snap ITC",
	"Papyrus",
	"Old English Text MT",
	"Mistral",
	"Lucida Handwriting",
	"Jokerman",
	"Freestyle Script",
	"Bradley Hand ITC",
	"Stencil",
	"Shrek"
}

local createdfonts = {
}

local function getFont(name, size)
	if (!createdfonts[name] or !createdfonts[name][size]) then
		local fd = {
			font = name,
			size = size,
			weight = 1500,
			shadow = true,
			antialias = true,
			extended = true,
			symbol = (name == "Webdings")
		}
			
		surface.CreateFont('CV' .. name .. size, fd)
		
		createdfonts[name] = createdfonts[name] or {}
		createdfonts[name][size] = true
	end
	
	 return ('CV' .. name .. size)
end


local TextBox = {}
local linelabels = {}
local labels = {}
local fontpickers = {}
local sliders = {}
for i = 1, 3 do
	TOOL.ClientConVar[ "font"..i ] = allowablefonts[1]
	TOOL.ClientConVar[ "text"..i ] = ""
	TOOL.ClientConVar[ "size"..i ] = 20
	TOOL.ClientConVar[ "r"..i ] = 255
	TOOL.ClientConVar[ "g"..i ] = 255
	TOOL.ClientConVar[ "b"..i ] = 255
	TOOL.ClientConVar[ "a"..i ] = 255
end

cleanup.Register("textscreens")

if (CLIENT) then
	language.Add("Tool.textscreen.name", "Textscreen")
	language.Add("Tool.textscreen.desc", translates.Get("Создать текстскрин с несколькими линиями, шрифтами, цветами и размерами.") or "Создать текстскрин с несколькими линиями, шрифтами, цветами и размерами.")	

	language.Add("Tool.textscreen.0", translates.Get("ЛКМ: создать текстскрин; ПКМ: обновить настройки") or "ЛКМ: создать текстскрин; ПКМ: обновить настройки")
	language.Add("Tool_textscreen_0", translates.Get("ЛКМ: создать текстскрин; ПКМ: обновить настройки") or "ЛКМ: создать текстскрин; ПКМ: обновить настройки")

	language.Add("Undone.textscreens", translates.Get("Текстскрин убран") or "Текстскрин убран")
	language.Add("Undone_textscreens", translates.Get("Текстскрин убран") or "Текстскрин убран")
	language.Add("Cleanup.textscreens", translates.Get("Текстскрины") or "Текстскрины")
	language.Add("Cleanup_textscreens", translates.Get("Текстскрины") or "Текстскрины")
	language.Add("Cleaned.textscreens", translates.Get("Все текстскрины удалены!") or "Все текстскрины удалены!")
	language.Add("Cleaned_textscreens", translates.Get("Все текстскрины удалены!") or "Все текстскрины удалены!")
	
	language.Add("SBoxLimit.textscreens", translates.Get("Вы достигли лимита текстскринов!") or "Вы достигли лимита текстскринов!")
	language.Add("SBoxLimit_textscreens", translates.Get("Вы достигли лимита текстскринов!") or "Вы достигли лимита текстскринов!")
end

function TOOL:LeftClick(tr)
	if (tr.Entity:GetClass() == "player") then return false end
	if (CLIENT) then return true end

	local Ply = self:GetOwner()
	local Font = {}
	local Text = {}
	local color = {}
	local size = {}
	for i = 1, 3 do
		local font = self:GetClientInfo("font"..i)
		for k, v in ipairs(allowablefonts) do
			if (v == font) then
				table.insert(Font, i, k)
			end
		end
		if (!Font[i]) then Font[i] = 1 end
		
		table.insert(Text, i, self:GetClientInfo("text"..i))
		table.insert(color, i, Color(tonumber(self:GetClientInfo("r"..i)), tonumber(self:GetClientInfo("g"..i)), tonumber(self:GetClientInfo("b"..i)), tonumber(self:GetClientInfo("a"..i))))
		table.insert(size, i, tonumber(self:GetClientInfo("size"..i)))
	end

	local SpawnPos = tr.HitPos
	
	if not (self:GetWeapon():CheckLimit("textscreens")) then return false end

	local TextScreen = ents.Create("ent_textscreen")
	TextScreen:SetPos(SpawnPos)
	TextScreen:Spawn()
	TextScreen:UpdateText(Font, Text, color, size)
	local angle = tr.HitNormal:Angle()
	angle:RotateAroundAxis(tr.HitNormal:Angle():Right(), -90)
	angle:RotateAroundAxis(tr.HitNormal:Angle():Forward(), 90)
	TextScreen:SetAngles(angle)
	TextScreen:Activate()
	
	undo.Create("textscreens")

	undo.AddEntity(TextScreen)
	undo.SetPlayer(Ply)
	undo.Finish()

	Ply:AddCount("textscreens", TextScreen)
	Ply:AddCleanup("textscreens", TextScreen)

	return true
end

function TOOL:RightClick(tr)
	if (tr.Entity:GetClass() == "player") then return false end
	if (CLIENT) then return true end

	local Ply = self:GetOwner()
	local Font = {}
	local Text = {}
	local color = {}
	local size = {}
	for i = 1, 3 do
		local font = self:GetClientInfo("font"..i)
		for k, v in ipairs(allowablefonts) do
			if (v == font) then
				table.insert(Font, i, k)
			end
		end
		if (!Font[i]) then Font[i] = 1 end
		
		table.insert(Text, i, self:GetClientInfo("text"..i))
		table.insert(color, i, Color(tonumber(self:GetClientInfo("r"..i)), tonumber(self:GetClientInfo("g"..i)), tonumber(self:GetClientInfo("b"..i)), tonumber(self:GetClientInfo("a"..i))))
		table.insert(size, i, tonumber(self:GetClientInfo("size"..i)))
	end

	local TraceEnt = tr.Entity

	if (TraceEnt:IsValid() and TraceEnt:GetClass() == "ent_textscreen") then
		TraceEnt:UpdateText(Font, Text, color, size)
		return true
	end
end

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", {	Text = "#Tool.textscreen.name", Description	= "#Tool.textscreen.desc" } )
	resetall = vgui.Create("DButton", resetbuttons)
	resetall:SetSize(100, 25)	
	resetall:SetText(translates.Get("Сбросить все") or "Сбросить все")
	resetall.DoClick = function()
		local menu = DermaMenu()
		menu:AddOption("Reset fonts", function()
			for i = 1, 3 do
				RunConsoleCommand("textscreen_font"..i, "Tahoma")
			end
		end)
		menu:AddOption("Reset colors", function()
			for i = 1, 3 do
				RunConsoleCommand("textscreen_r"..i, 255)
				RunConsoleCommand("textscreen_g"..i, 255)
				RunConsoleCommand("textscreen_b"..i, 255)
				RunConsoleCommand("textscreen_a"..i, 255)
			end
		end)
		menu:AddOption("Reset sizes", function()
			for i = 1, 3 do
				RunConsoleCommand("textscreen_size"..i, 20)
				sliders[i]:SetValue(20)
			end			
		end)
		menu:AddOption("Reset textboxes", function()
			for i = 1, 3 do
				RunConsoleCommand("textscreen_text"..i, "")
				TextBox[i]:SetValue("")
			end
		end)
		menu:AddOption("Reset everything", function()
			for i = 1, 3 do
				RunConsoleCommand("textscreen_r"..i, 255)
				RunConsoleCommand("textscreen_g"..i, 255)
				RunConsoleCommand("textscreen_b"..i, 255)
				RunConsoleCommand("textscreen_a"..i, 255)
				RunConsoleCommand("textscreen_size"..i, 20)
				sliders[i]:SetValue(20)
				RunConsoleCommand("textscreen_text"..i, "")
				TextBox[i]:SetValue("")
			end
		end)
		menu:Open()
	end
	CPanel:AddItem(resetall)
	resetline = vgui.Create("DButton")
	resetline:SetSize(100, 25)	
	resetline:SetText(translates.Get("Сбросить линию") or "Сбросить линию")
	resetline.DoClick = function()
		local menu = DermaMenu()
		for i = 1, 3 do
			menu:AddOption((translates.Get("Сбросить линию") or "Сбросить линию") .. " " .. i, function()
				RunConsoleCommand("textscreen_font"..i, "Tahoma")
				RunConsoleCommand("textscreen_r"..i, 255)
				RunConsoleCommand("textscreen_g"..i, 255)
				RunConsoleCommand("textscreen_b"..i, 255)
				RunConsoleCommand("textscreen_a"..i, 255)
				RunConsoleCommand("textscreen_size"..i, 20)
				sliders[i]:SetValue(20)
				RunConsoleCommand("textscreen_text"..i, "")
				TextBox[i]:SetValue("")
			end)
		end
		menu:AddOption(translates.Get("Сбросить все линии") or "Сбросить все линии", function()
			for i = 1, 3 do
				RunConsoleCommand("textscreen_font"..i, "Tahoma")
				RunConsoleCommand("textscreen_r"..i, 255)
				RunConsoleCommand("textscreen_g"..i, 255)
				RunConsoleCommand("textscreen_b"..i, 255)
				RunConsoleCommand("textscreen_a"..i, 255)
				RunConsoleCommand("textscreen_size"..i, 20)
				sliders[i]:SetValue(20)
				RunConsoleCommand("textscreen_text"..i, "")
				TextBox[i]:SetValue("")
			end			
		end)
		menu:Open()
	end
	CPanel:AddItem(resetline)

	for i = 1, 3 do
		linelabels[i] = CPanel:AddControl("Label", {
			Text = (translates.Get("Линия") or "Линия") .. " "..i,
			Description = (translates.Get("Линия") or "Линия") .. " "..i
		})
		linelabels[i]:SetFont("Default")
		CPanel:AddControl("Color", {
			Label = (translates.Get("Линия") or "Линия") .. " " .. i .. " " .. (translates.Get("шрифт и цвет") or "шрифт и цвет"),
			Red = "textscreen_r"..i,
			Green = "textscreen_g"..i,
			Blue = "textscreen_b"..i,
			Alpha = "textscreen_a"..i,
			ShowHSV = 1,
			ShowRGB = 1,
			Multiplier = 255
		})
		fontpickers[i] = vgui.Create("DComboBox")
		for k, v in ipairs(allowablefonts) do fontpickers[i]:AddChoice(v) end
		fontpickers[i]:ChooseOption("Tahoma")
		fontpickers[i].OnSelect = function(pnl, idx, value)
			RunConsoleCommand("textscreen_font"..i, value)
			labels[i]:SetFont(getFont(value or allowablefonts[1], math.Round(sliders[i]:GetValue())))
		end
		
		CPanel:AddItem(fontpickers[i])
		sliders[i] = vgui.Create("DNumSlider")
		sliders[i]:SetText(translates.Get("Размер") or "Размер")
		sliders[i]:SetMinMax(20, 100)
		sliders[i]:SetDecimals(0)
		sliders[i]:SetValue(20)
		sliders[i]:SetConVar("textscreen_size"..i)
		sliders[i].OnValueChanged = function(panel, value)
			local str, data = fontpickers[i]:GetSelected()
			str = str or allowablefonts[1]
			labels[i]:SetFont(getFont(str, math.Round(value)))
		end
		CPanel:AddItem(sliders[i])
		TextBox[i] = vgui.Create("DTextEntry")
		TextBox[i]:SetUpdateOnType(true)
		TextBox[i]:SetEnterAllowed(true)
		TextBox[i]:SetConVar("textscreen_text"..i)
		TextBox[i]:SetValue(GetConVarString("textscreen_text"..i))
		TextBox[i].OnTextChanged = function()
			labels[i]:SetText(TextBox[i]:GetValue())
		end
		CPanel:AddItem(TextBox[i])
		labels[i] = CPanel:AddControl("Label", {
			Text = "Line "..i,
			Description = "Line "..i
		})
		labels[i]:SetFont("Default")
		labels[i].Think = function()
			labels[i]:SetColor(Color(GetConVarNumber("textscreen_r"..i), GetConVarNumber("textscreen_g"..i), GetConVarNumber("textscreen_b"..i), GetConVarNumber("textscreen_a"..i)))
		end
	end
end


-- Textscreen renderer:
if CLIENT then
	local cvar_Get = cvar.Get
	cvar.Register'enable_textscreens_render':SetDefault(true):AddMetadata('State', 'RPMenu'):AddMetadata('Menu', 'Включить отображение 3D2D надписей')

	local ipairs                     = ipairs;
	local Color                      = Color;
	local Angle                      = Angle;
	local math_Clamp                 = math.Clamp;
	local cam_Start3D2D, cam_End3D2D = cam.Start3D2D, cam.End3D2D;
	local draw_SimpleTextOutlined    = draw.SimpleTextOutlined;
	local allowablefonts             = { "Open Sans Light", "Tahoma", "Helvetica", "Trebuchet MS", "Comic Sans MS", "Segoe UI", "Impact", "Broadway", "Webdings", "Snap ITC", "Papyrus", "Old English Text MT", "Mistral", "Lucida Handwriting", "Jokerman", "Freestyle Script", "Bradley Hand ITC", "Stencil", "Shrek" };
	local createdfonts               = {};

	local function getFont( name, size )
		if not createdfonts[name] or not createdfonts[name][size] then
			local fd = {
				font      = name,
				size      = size,
				weight    = 1500,
				shadow    = true,
				antialias = true,
				symbol    = (name == "Webdings"),
				extended  = true,
			}

			surface.CreateFont( "CV" .. name .. size, fd );  
			createdfonts[name]       = createdfonts[name] or {}
			createdfonts[name][size] = true
		end

		return ( "CV" .. name .. size );
	end

	rp_TextScreens = {};
	hook.Add( "PostDrawTranslucentRenderables", "rp.TextScreen.Render", function()
		local cvar = cvar_Get("enable_textscreens_render")
		if not cvar or not cvar.Value then return end

		for ent, shouldRender in pairs(rp_TextScreens) do
			if not IsValid( ent ) then
				rp_TextScreens[ent] = nil;
				continue
			end

			if ent:GetPos():Distance( LocalPlayer():GetPos() ) > 750 then continue end

			local ang      = ent:GetAngles();
			local pos      = ent:GetPos() + ang:Up();
			local camangle = Angle(ang.p, ang.y, ang.r);

			ent.lines = ent.lines or {}

			for i = 1, 3 do
				if ent:GetNetVar( "Text" .. i ) ~= "" then
					ent.lines[i]          = ent.lines[i] or {};

					ent.lines[i].font     = allowablefonts[ent:GetNetVar("Font" .. i) or 1];
					ent.lines[i].text     = ent:GetNetVar("Text" .. i) or "";

					ent.lines[i].r        = ent:GetNetVar("r" .. i) or 255;
					ent.lines[i].g        = ent:GetNetVar("g" .. i) or 255;
					ent.lines[i].b        = ent:GetNetVar("b" .. i) or 255;
					ent.lines[i].a        = ent:GetNetVar("a" .. i) or 255;

					ent.lines[i].size     = math_Clamp(ent:GetNetVar("size" .. i) or 100, 1, 100);

					ent.lines[i].fontname = getFont(ent.lines[i].font, ent.lines[i].size);
				else
					ent.lines[i] = nil;
				end
			end

			cam_Start3D2D( pos, camangle, .25 );
			render.PushFilterMin( TEXFILTER.ANISOTROPIC );
				local x, y = 0, 0;

				for k, v in ipairs( ent.lines ) do
					local w, h = draw_SimpleTextOutlined( v.text, v.fontname, x, y, Color(v.r, v.g, v.b), 1, 1, 1, color_black );
					y = y + h;
				end
			render.PopFilterMin();
			cam_End3D2D();

			camangle:RotateAroundAxis( camangle:Right(), 180 );

			cam_Start3D2D (pos, camangle, .25 );
			render.PushFilterMin( TEXFILTER.ANISOTROPIC );
				local x, y = 0, 0;

				for k, v in ipairs( ent.lines ) do
					local w, h = draw_SimpleTextOutlined( v.text, v.fontname, x, y, Color(v.r, v.g, v.b), 1, 1, 1, color_black );
					y = y + h;
				end
			render.PopFilterMin();
			cam_End3D2D();
		end
	end );
end