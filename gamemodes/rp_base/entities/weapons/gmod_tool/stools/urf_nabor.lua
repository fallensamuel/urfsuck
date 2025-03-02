-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\urf_nabor.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
TOOL.Category		= "Roleplay"
TOOL.Name			= translates.Get("NPC Набора")
TOOL.Command		= nil
TOOL.ConfigName		= ""

local TextBox = {}
local linelabels = {}
local labels = {}
local fontpickers = {}
local sliders = {}

TOOL.ClientConVar[ "name" ] = ""
TOOL.ClientConVar[ "model" ] = ""

for i = 1, 10 do
	TOOL.ClientConVar[ "txt" .. i ] = ""
end

TOOL.ClientConVar[ "url" ] = ""
TOOL.ClientConVar[ "burl" ] = ""
TOOL.ClientConVar[ "pose" ] = "idle_all_01"

cleanup.Register("nabornpcs")

if (CLIENT) then
	language.Add("Tool.urf_nabor.name", translates.Get("NPC Набора"))
	language.Add("Tool.urf_nabor.desc", translates.Get("Создать NPC набора, предлагающего открыть ссылку."))

	language.Add("Tool.urf_nabor.0", translates.Get("ЛКМ: создать NPC набора; ПКМ: удалить NPC набора"))
	language.Add("Tool_urf_nabor_0", translates.Get("ЛКМ: создать NPC набора; ПКМ: удалить NPC набора"))

	language.Add("Undone.nabornpcs", translates.Get("NPC набора убран"))
	language.Add("Undone_nabornpcs", translates.Get("NPC набора убран"))
	language.Add("Cleanup.nabornpcs", translates.Get("NPC набора"))
	language.Add("Cleanup_nabornpcs", translates.Get("NPC набора"))
	language.Add("Cleaned.nabornpcs", translates.Get("Все NPC набора удалены!"))
	language.Add("Cleaned_nabornpcs", translates.Get("Все NPC набора удалены!"))

	language.Add("SBoxLimit.nabornpcs", translates.Get("Вы достигли лимита NPC набора!"))
	language.Add("SBoxLimit_nabornpcs", translates.Get("Вы достигли лимита NPC набора!"))
end

function TOOL:LeftClick(tr)
	if (tr.Entity:GetClass() == "player") then return false end
	local Ply = self:GetOwner()

	if not Ply:IsRoot() then return false end
	if (CLIENT) then return true end

	local Font = {}
	local Text = {}
	local color = {}
	local size = {}

	--table.insert(Text, i, self:GetClientInfo("text"..i))

	local SpawnPos = tr.HitPos

	if not (self:GetWeapon():CheckLimit("nabornpcs")) then return false end

	local NaborNpc = ents.Create("urf_nabornpc")
	NaborNpc:SetPos(SpawnPos)
	NaborNpc:Spawn()
	local angle = tr.HitNormal:Angle()
	angle:RotateAroundAxis(tr.HitNormal:Angle():Right(), -90)
	angle:RotateAroundAxis(tr.HitNormal:Angle():Forward(), 90)
	NaborNpc:SetAngles(angle)
	NaborNpc:Activate()

	NaborNpc.SavedSequence = self:GetClientInfo("pose") or "idle_all_01"

	local descText = ''
	for i = 1, 10 do
		--print(i, self:GetClientInfo("txt" .. i))
		descText = descText .. (self:GetClientInfo("txt" .. i) or '')
	end

	local texts = {}
	local i = 1

	while string.len(descText) > 0 and i <= 2 do
		table.insert( texts, string.sub(descText, 0, 511) )
		descText = string.sub( descText, 512 )

		i = i + 1
	end

	NaborNpc:Setup(
		self:GetClientInfo("name"),
		self:GetClientInfo("model"),
		texts, --self:GetClientInfo("txt"),
		self:GetClientInfo("url"),
		self:GetClientInfo("burl"),
		self:GetClientInfo("pose") or "idle_all_01"
	)

	undo.Create("nabornpcs")

	undo.AddEntity(NaborNpc)
	undo.SetPlayer(Ply)
	undo.Finish()

	Ply:AddCount("nabornpcs", NaborNpc)
	Ply:AddCleanup("nabornpcs", NaborNpc)

	return true
end

function TOOL:RightClick(tr)
	if (tr.Entity:GetClass() == "player") then return false end
	if (CLIENT) then return true end

	local Ply = self:GetOwner()
	local TraceEnt = tr.Entity

	if (TraceEnt:IsValid() and TraceEnt:GetClass() == "urf_nabornpc") then
		TraceEnt:Remove()
		return true
	end
end

local allowableposes = {
	'idle_all_01',
	'idle_all_angry',
	'pose_standing_01',
	'pose_standing_02',
	'd1_t01_breakroom_watchbreen',
	'd1_t02_playground_cit2_pockets',
	'ruka_dick',
}

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", {	Text = "#Tool.urf_nabor.name", Description	= "#Tool.urf_nabor.desc" } )

	local linelabel1 = CPanel:AddControl("Label", {
		Text = translates.Get("Имя NPC"),
		Description = translates.Get("Имя NPC")
	})
	linelabel1:SetFont("Default")

	local nametextb = vgui.Create("DTextEntry")
	nametextb:SetUpdateOnType(true)
	nametextb:SetEnterAllowed(true)
	nametextb:SetConVar("urf_nabor_name")
	nametextb:SetValue(GetConVarString("urf_nabor_name"))
	nametextb.OnValueChange = function()
	end
	CPanel:AddItem(nametextb)

	local linelabel2 = CPanel:AddControl("Label", {
		Text = translates.Get("Модель NPC"),
		Description = translates.Get("Модель NPC")
	})
	linelabel2:SetFont("Default")

	local modeltextb = vgui.Create("DTextEntry")
	modeltextb:SetUpdateOnType(true)
	modeltextb:SetEnterAllowed(true)
	modeltextb:SetConVar("urf_nabor_model")
	modeltextb:SetValue(GetConVarString("urf_nabor_model"))
	modeltextb.OnValueChange = function()
	end
	CPanel:AddItem(modeltextb)

	local linelabel3 = CPanel:AddControl("Label", {
		Text = translates.Get("Текст описания"),
		Description = translates.Get("Текст описания")
	})
	linelabel3:SetFont("Default")

	local texttextb = vgui.Create("DTextEntry")
	texttextb:SetMultiline(true)
	texttextb:SetUpdateOnType(true)
	texttextb:SetTall(150)
	texttextb:SetEnterAllowed(true)
	--texttextb:SetConVar("urf_nabor_txt")
	--texttextb:SetValue(GetConVarString("urf_nabor_txt"))
	texttextb.OnValueChange = function()
		descText = texttextb:GetText() or ''

		--print('ALL:', descText)

		local i = 1
		local convar

		while string.len(descText) > 0 and i <= 10 do
			convar = GetConVar( 'urf_nabor_txt' .. i )
			i = i + 1

			--print(i, 'NOW:', string.sub(descText, 0, 222))

			convar:SetString( string.Replace( string.sub(descText, 0, 222), "\n", "\\n" ) )
			descText = string.sub( descText, 223 )
		end

		if i <= 10 then
			for k = i, 10 do
				convar = GetConVar( 'urf_nabor_txt' .. k )
				convar:SetString( '' )
			end
		end

		--print(1, descText)
	end
	--texttextb._OldOnChange = texttextb._OldOnChange or texttextb.OnChange or function() end
	--texttextb.OnChange = function(...)
		--descText = texttextb:GetText() or ''
		--texttextb._OldOnChange(...)
		--print(2, descText)
	--end
	CPanel:AddItem(texttextb)

	local linelabel4 = CPanel:AddControl("Label", {
		Text = translates.Get("Ссылка"),
		Description = translates.Get("Ссылка")
	})
	linelabel4:SetFont("Default")

	local urltextb = vgui.Create("DTextEntry")
	urltextb:SetUpdateOnType(true)
	urltextb:SetEnterAllowed(true)
	urltextb:SetConVar("urf_nabor_url")
	urltextb:SetValue(GetConVarString("urf_nabor_url"))
	urltextb.OnValueChange = function()
	end
	CPanel:AddItem(urltextb)

	local linelabel5 = CPanel:AddControl("Label", {
		Text = translates.Get("Текст кнопки перехода по ссылке"),
		Description = translates.Get("Текст кнопки перехода по ссылке")
	})
	linelabel5:SetFont("Default")

	local gurltextb = vgui.Create("DTextEntry")
	gurltextb:SetUpdateOnType(true)
	gurltextb:SetEnterAllowed(true)
	gurltextb:SetConVar("urf_nabor_burl")
	gurltextb:SetValue(GetConVarString("urf_nabor_burl"))
	gurltextb.OnValueChange = function()
	end
	CPanel:AddItem(gurltextb)

	local linelabel6 = CPanel:AddControl("Label", {
		Text = translates.Get("Поза NPC"),
		Description = translates.Get("Поза NPC")
	})
	linelabel6:SetFont("Default")

	local posepick = vgui.Create("DComboBox")
	for k, v in pairs(allowableposes) do
		posepick:AddChoice(v)
	end
	posepick:ChooseOption("idle_all_01")
	posepick.OnSelect = function(pnl, idx, value)
		RunConsoleCommand("urf_nabor_pose", value)
	end
	CPanel:AddItem(posepick)
end
