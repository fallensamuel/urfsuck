-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\press_button.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
TOOL.Category = "Roleplay"
TOOL.Name = translates.Get("Нажимная плита")
TOOL.Information = {"left"}
TOOL.ClientConVar[ "model" ] = "models/props_phx/construct/wood/wood_panel1x1.mdl"
TOOL.ClientConVar[ "keygroup" ] = "37"
TOOL.ClientConVar[ "toggle" ] = "1"
TOOL.ClientConVar[ "cooldown" ] = "1"

if CLIENT then
	-- missing langs:
	language.Add( "Tool.press_button.name", translates.Get("Нажимная плита" ));
	language.Add( "Tool.press_button.desc", translates.Get("Та же кнопка, но срабатывает только тогда, когда на неё встанет игрок.") );
	language.Add( "Tool.press_button.left", translates.Get("ЛКМ: Создать нажимную плиту.") );
end

function TOOL:RightClick(trace)
	if (IsValid(trace.Entity) && trace.Entity:IsPlayer()) then return false end
	if (CLIENT) then return true end
	if (!util.IsValidPhysicsObject(trace.Entity, trace.PhysicsBone)) then return false end
	local ply = self:GetOwner()
	local model = self:GetClientInfo("model")
	local key = self:GetClientNumber("keygroup")
	local toggle = self:GetClientNumber("toggle") == 1
	local cooldown = self:GetClientNumber("cooldown") or 1

	if (IsValid(trace.Entity) && trace.Entity:GetClass() == "urf_button" && trace.Entity:CPPIGetOwner() == ply) then
		trace.Entity.Key = key
		trace.Entity.Toggled = toggle
		trace.Entity.Cooldown = tonumber(cooldown)
		return true, NULL, true
	end

	if (!self:GetSWEP():CheckLimit("buttons")) then return false end -- пробивается вместе с лимитами обычных кнопок, переделать это 1 секунда.
	if (!util.IsValidModel(model)) then return false end
	if (!util.IsValidProp(model)) then return false end

	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local button = MakePressPlate(ply, model, Ang, trace.HitPos, key, toggle)
	local min = button:OBBMins()
	button:SetPos(trace.HitPos - trace.HitNormal * min.z)
	button.Cooldown = tonumber(cooldown)

	undo.Create("Button")
		undo.AddEntity(button)
		undo.SetPlayer(ply)
	undo.Finish()

	ply:AddCleanup("buttons", button)
	return true, button
end

function TOOL:LeftClick(trace)
	local bool, button, set_key = self:RightClick(trace, true)
	if (CLIENT) then return bool end
	if (set_key) then return true end
	if (!IsValid(button)) then return false end
	if (!IsValid(trace.Entity) && !trace.Entity:IsWorld()) then return false end

	local weld = constraint.Weld(button, trace.Entity, 0, trace.PhysicsBone, 0, 0, true)
	trace.Entity:DeleteOnRemove(weld)
	button:DeleteOnRemove(weld)
	button:GetPhysicsObject():EnableCollisions(false)
	button.nocollide = true

	return true
end

if (SERVER) then
	function MakePressPlate(pl, Model, Ang, Pos, key, toggle, Vel, aVel, frozen)
		if (IsValid(pl ) && !pl:CheckLimit("buttons")) then return false end

		local button = ents.Create("urf_button")
		if (!IsValid(button)) then return false end
		button:SetModel(Model)
		button:SetAngles(Ang)
		button:SetPos(Pos)
		button:Spawn()
		button:CPPISetOwner(pl)
		button.Key = key
		button.Toggled = toggle

		if (IsValid(pl)) then
			pl:AddCount("buttons", button)
		end
		return button
	end

	duplicator.RegisterEntityClass("urf_button", MakePressPlate, "Model", "Ang", "Pos", "key", "toggle", "Vel", "aVel", "frozen")
end

function TOOL:UpdateGhostButton(ent, player)
	if (!IsValid(ent)) then return end
	local tr = util.GetPlayerTrace(player)
	local trace = util.TraceLine(tr)
	if (!trace.Hit) then return end

	if (trace.Entity && trace.Entity:GetClass() == "urf_button" || trace.Entity:IsPlayer()) then
		ent:SetNoDraw(true)
		return
	end

	local Ang = trace.HitNormal:Angle()
	Ang.pitch = Ang.pitch + 90

	local min = ent:OBBMins()
	ent:SetPos(trace.HitPos - trace.HitNormal * min.z)
	ent:SetAngles(Ang)

	ent:SetNoDraw(false)

end

function TOOL:Think()
	if (!IsValid(self.GhostEntity ) || self.GhostEntity:GetModel() != self:GetClientInfo("model")) then
		self:MakeGhostEntity(self:GetClientInfo("model" ), Vector(0, 0, 0), Angle(0, 0, 0))
	end
	self:UpdateGhostButton(self.GhostEntity, self:GetOwner())
end

local ConVarsDefault = TOOL:BuildConVarList()
function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl("Header", { Description = "#tool.button.desc" })
	-- CPanel:AddControl("ComboBox", { MenuButton = 1, Folder = "button", Options = { [ "#preset.default" ] = ConVarsDefault }, CVars = table.GetKeys(ConVarsDefault) })
	CPanel:AddControl("Numpad", { Label = "#tool.button.key", Command = "press_button_keygroup" })
	CPanel:AddControl("CheckBox", { Label = "#tool.button.toggle", Command = "press_button_toggle", Help = true })
	CPanel:AddControl("Label", { Text = translates.Get("Задержка:") })
	
	local Cooldown = vgui.Create('DComboBox');
	Cooldown:SetSize(CPanel:GetWide(), 25);

	Cooldown.OnSelect = function(Self, Index, Value)
		RunConsoleCommand('press_button_cooldown', tonumber(string.Left(Value, 1)));
	end

	--local Table = {
	--	'1 секунда',
	--	'2 секунды',
	--	'3 секунды',
	--	'4 секунды',
	--	'5 секунд',
	--	'6 секунд',
	--	'7 секунд',
	--	'8 секунд',
	--	'9 секунд'
	--};
	--for Index, Choice in pairs(Table) do
	for Index = 1, 9 do
		Cooldown:AddChoice(translates.Get('%s секунд.', Index));
	end
	Cooldown:ChooseOptionID(1);
	CPanel:AddItem(Cooldown);

	CPanel:AddControl("PropSelect", { Label = "#tool.button.model", ConVar = "press_button_model", Height = 4, Models = list.Get("PButtonModels") })

	local Hint = vgui.Create('DLabel');
	Hint:SetDark(true);
	Hint:SetWrap(true);
	Hint:SetColor(Color(51, 51, 255));
	Hint:SetText(translates.Get('Подсказка: нажимная плита - это та же кнопка, но срабатывает только тогда, когда на неё встанет игрок.'));
	Hint:SetContentAlignment(5);
	Hint:SetSize(CPanel:GetWide(), 50);
	CPanel:AddItem(Hint);
end

list.Set("PButtonModels", "models/props_phx/construct/metal_plate1.mdl", {})
list.Set("PButtonModels", "models/props_phx/construct/wood/wood_panel1x1.mdl", {})
list.Set("PButtonModels", "models/props_junk/trashdumpster02b.mdl", {})

local models = {
	"models/props_phx/construct/metal_plate1.mdl",
	"models/props_phx/construct/wood/wood_panel1x1.mdl",
	"models/props_junk/trashdumpster02b.mdl",
}

local rcc = RunConsoleCommand
cvars.AddChangeCallback("press_button_model", function(convar_name, value_old, value_new)
	if not table.HasValue(models, value_new) then
		rcc('press_button_model', models[1])
	end
end)

cvars.AddChangeCallback("press_button_cooldown", function(convar_name, value_old, value_new)
	if (value_new != value_old) then
		rcc('press_button_cooldown', value_new)
	end
end)

	-- "models/props_phx/construct/metal_plate1.mdl",
	-- "models/props_phx/construct/wood/wood_panel1x1.mdl",