-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\urf_keypad.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
TOOL.Category = "Roleplay"
TOOL.Name = translates.Get("Специальный Кейпад")
TOOL.Command = nil

TOOL.ClientConVar['weld'] = '1'
TOOL.ClientConVar['freeze'] = '1'

TOOL.ClientConVar['secure'] = '0'

TOOL.ClientConVar['repeats_granted'] = '0'
TOOL.ClientConVar['repeats_denied'] = '0'

TOOL.ClientConVar['length_granted'] = '4'
TOOL.ClientConVar['length_denied'] = '0.1'

TOOL.ClientConVar['delay_granted'] = '0'
TOOL.ClientConVar['delay_denied'] = '0'

TOOL.ClientConVar['init_delay_granted'] = '0'
TOOL.ClientConVar['init_delay_denied'] = '0'

TOOL.ClientConVar['key_granted'] = '0'
TOOL.ClientConVar['key_denied'] = '0'

TOOL.ClientConVar['4factions'] = '1'
TOOL.ClientConVar['4orgs'] = '0'

cleanup.Register("keypads")

if(CLIENT) then
	language.Add("tool.urf_keypad.name", translates.Get("Специальный Кейпад"))
	language.Add("tool.urf_keypad.0", translates.Get("ЛКМ: Создать, ПКМ: Обновить"))
	language.Add("tool.urf_keypad.desc", translates.Get("Создает специальный кейпад"))

	language.Add("Undone_Keypad", translates.Get("Убран специальный кейпад"))
	language.Add("Cleanup_keypads", translates.Get("Специальные кейпады"))
	language.Add("Cleaned_keypads", translates.Get("Очищены все специальные кейпады"))

	language.Add("SBoxLimit_keypads", translates.Get("Вы достигли лимита специальных кейпадов!"))
end

function TOOL:SetupKeypad(ent, pass)
	local data = {
		RepeatsGranted = self:GetClientNumber("repeats_granted"),
		RepeatsDenied = self:GetClientNumber("repeats_denied"),

		LengthGranted = math.Clamp(self:GetClientNumber("length_granted"), 4, 10),
		LengthDenied = self:GetClientNumber("length_denied"),

		DelayGranted = math.Clamp(self:GetClientNumber("delay_granted"), 4, 10),
		DelayDenied = self:GetClientNumber("delay_denied"),

		InitDelayGranted = self:GetClientNumber("init_delay_granted"),
		InitDelayDenied = self:GetClientNumber("init_delay_denied"),

		KeyGranted = self:GetClientNumber("key_granted"),
		KeyDenied = self:GetClientNumber("key_denied"),

		Secure = util.tobool(self:GetClientNumber("secure")),

		ForFactions = util.tobool(self:GetClientNumber("4factions")),
		ForOrgs = util.tobool(self:GetClientNumber("4orgs")),

		FF_Faction = self:GetOwner():GetFaction(),
		FF_Org = self:GetOwner():GetOrg(),

		Owner = self:GetOwner()
	}

	ent:SetData(data)
end

function TOOL:RightClick(tr)
	if(IsValid(tr.Entity) and tr.Entity:GetClass() ~= "urf_keypad") then return false end

	if(CLIENT) then return true end

	local ply = self:GetOwner()
	local password = tonumber(ply:GetInfo("keypad_password"))

	local spawn_pos = tr.HitPos
	local trace_ent = tr.Entity

	if(trace_ent:GetClass() == "urf_keypad" and trace_ent.KeypadData.Owner == ply) then
		self:SetupKeypad(trace_ent, password) -- validated password

		return true
	end
end

function TOOL:LeftClick(tr)
	if(IsValid(tr.Entity) and tr.Entity:GetClass() == "player") then return false end

	if(CLIENT) then return true end

	local ply = self:GetOwner()

	local spawn_pos = tr.HitPos + tr.HitNormal
	local trace_ent = tr.Entity

	if(not self:GetWeapon():CheckLimit("keypads")) then return false end

	local ent = ents.Create("urf_keypad")
	ent:SetPos(spawn_pos)
	ent:SetAngles(tr.HitNormal:Angle())
	ent:Spawn()
	ent:SetPlayer(ply)
	ent:SetAngles(tr.HitNormal:Angle())
	ent:Activate()

	local phys = ent:GetPhysicsObject() -- rely on this being valid

	self:SetupKeypad(ent)

	undo.Create("Keypad")
		local phys = ent:GetPhysicsObject();

		phys:EnableCollisions( false );
		phys:EnableMotion( false );

		if tobool( self:GetClientNumber("weld") ) then
			timer.Simple( FrameTime(), function()
				if IsValid(ent) and IsValid(trace_ent) then
					local weld = constraint.Weld( ent, trace_ent, 0, tr.PhysicsBone, 0, true, true );

					if weld then
						ent:SetMoveType( MOVETYPE_VPHYSICS );
						phys:EnableMotion( true );
					end
				end
			end );
		end

		undo.AddEntity(ent)
		undo.SetPlayer(ply)
	undo.Finish()

	ply:AddCount("keypads", ent)
	ply:AddCleanup("keypads", ent)

	return true
end


if(CLIENT) then
	local function ResetSettings(ply)
		ply:ConCommand("urf_keypad_repeats_granted 0")
		ply:ConCommand("urf_keypad_repeats_denied 0")
		ply:ConCommand("urf_keypad_length_granted 4")
		ply:ConCommand("urf_keypad_length_denied 0.1")
		ply:ConCommand("urf_keypad_delay_granted 0")
		ply:ConCommand("urf_keypad_delay_denied 0")
		ply:ConCommand("urf_keypad_init_delay_granted 0")
		ply:ConCommand("urf_keypad_init_delay_denied 0")
	end

	concommand.Add("urf_keypad_reset", ResetSettings)

	function TOOL.BuildCPanel(CPanel)
		CPanel:CheckBox(translates.Get("Кейпад для организации"), "urf_keypad_4orgs")
		CPanel:CheckBox(translates.Get("Кейпад для фракции"), "urf_keypad_4factions")
		CPanel:CheckBox(translates.Get("Сварить и заморозить кейпад"), "urf_keypad_weld")
		CPanel:CheckBox(translates.Get("Заморозить кейпад"), "urf_keypad_freeze")

		local ctrl = vgui.Create("CtrlNumPad", CPanel)
			ctrl:SetConVar1("urf_keypad_key_granted")
			ctrl:SetConVar2("urf_keypad_key_denied")
			ctrl:SetLabel1(translates.Get("Доступ разрешен"))
			ctrl:SetLabel2(translates.Get("Доступ запрещен"))
		CPanel:AddPanel(ctrl)

		CPanel:Button(translates.Get("Сбросить настройки"), "urf_keypad_reset")

		CPanel:Help("")
		local Text = vgui.Create('DLabel', CPanel);
		Text:Dock(TOP);
		Text:SetText(translates.Get("Настройки при предоставлении доступа"));
		Text:SetColor(Color(0, 128, 0));
		Text:SetContentAlignment(5);

		CPanel:NumSlider(translates.Get("Длина задержки"), "urf_keypad_length_granted", 4, 10, 2)
		CPanel:NumSlider(translates.Get("Начальная задержка"), "urf_keypad_init_delay_granted", 0, 10, 2)
		CPanel:NumSlider(translates.Get("Задержка многократного нажатия"), "urf_keypad_delay_granted", 0, 10, 2)
		CPanel:NumSlider(translates.Get("Дополнительные повторы"), "urf_keypad_repeats_granted", 0, 5, 0)

		CPanel:Help("")
		Text = vgui.Create('DLabel', CPanel);
		Text:Dock(TOP);
		Text:SetText(translates.Get("Настройки при отказе доступа"));
		Text:SetColor(Color(128, 0, 0));
		Text:SetContentAlignment(5);

		CPanel:NumSlider(translates.Get("Длина задержки"), "urf_keypad_length_denied", 0.1, 10, 2)
		CPanel:NumSlider(translates.Get("Начальная задержка"), "urf_keypad_init_delay_denied", 0, 10, 2)
		CPanel:NumSlider(translates.Get("Задержка многократного нажатия"), "urf_keypad_delay_denied", 0, 10, 2)
		CPanel:NumSlider(translates.Get("Дополнительные повторы"), "urf_keypad_repeats_denied", 0, 5, 0)

		local Hint = vgui.Create('DLabel');
		Hint:SetDark(true);
		Hint:SetWrap(true);
		Hint:SetColor(Color(51, 51, 255));
		Hint:SetText(translates.Get('Подсказка: с данным типом кейпадов могут взаимодействовать только люди из Вашей фракции или организации.'));
		Hint:SetContentAlignment(5);
		Hint:SetSize(CPanel:GetWide(), 50);
		CPanel:AddItem(Hint);
	end
end