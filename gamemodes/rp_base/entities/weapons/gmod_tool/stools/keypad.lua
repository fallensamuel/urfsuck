-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\keypad.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
TOOL.Category = "Roleplay"
TOOL.Name = "Keypad"
TOOL.Command = nil

TOOL.ClientConVar['weld'] = '1'
TOOL.ClientConVar['freeze'] = '1'

TOOL.ClientConVar['password'] = ''
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

cleanup.Register("keypads")
if SERVER then RunConsoleCommand("sbox_maxkeypads", "3") end

if(CLIENT) then
	language.Add("tool.keypad.name", "Keypad")
	language.Add("tool.keypad.0", translates.Get("ЛКМ - создать; ПКМ - обновить") or "ЛКМ - создать; ПКМ - обновить")
	language.Add("tool.keypad.desc", translates.Get("Создает панель с паролем") or "Создает панель с паролем")

	language.Add("Undone_Keypad", translates.Get("Кейпад удалён.") or "Кейпад удалён.")
	language.Add("Cleanup_keypads", translates.Get("Кейпады") or "Кейпады")
	language.Add("Cleaned_keypads", translates.Get("Все Кейпады удалены") or "Все Кейпады удалены")

	language.Add("SBoxLimit_keypads", translates.Get("Достигнут лимит Кейпадов!") or "Достигнут лимит Кейпадов!")
end

function TOOL:SetupKeypad(ent, pass)
	local data = {
		Password = pass,

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

		Owner = self:GetOwner()
	}

	ent:SetData(data)
end

function TOOL:RightClick(tr)
	if(IsValid(tr.Entity) and tr.Entity:GetClass() ~= "keypad") then return false end

	if(CLIENT) then return true end

	local ply = self:GetOwner()
	local password = tonumber(ply:GetInfo("keypad_password"))

	local spawn_pos = tr.HitPos
	local trace_ent = tr.Entity

	if(password == nil or (string.len(tostring(password)) > 4) or (string.find(tostring(password), "0"))) then
		ply:ChatPrint("Invalid password!")
		return false
	end

	if(trace_ent:GetClass() == "keypad" and trace_ent.KeypadData.Owner == ply) then
		self:SetupKeypad(trace_ent, password) -- validated password

		return true
	end
end

function TOOL:LeftClick(tr)
	if(IsValid(tr.Entity) and tr.Entity:GetClass() == "player") then return false end

	if(CLIENT) then return true end

	local ply = self:GetOwner()
	local password = self:GetClientNumber("password")

	local spawn_pos = tr.HitPos + tr.HitNormal
	local trace_ent = tr.Entity

	if(password == nil or (string.len(tostring(password)) > 4) or (string.find(tostring(password), "0"))) then
		ply:ChatPrint("Invalid password!")
		return false
	end

	if(not self:GetWeapon():CheckLimit("keypads")) then return false end

	local ent = ents.Create("keypad")
	ent:SetPos(spawn_pos)
	ent:SetAngles(tr.HitNormal:Angle())
	ent:Spawn()
	ent:SetPlayer(ply)
	ent:SetAngles(tr.HitNormal:Angle())
	ent:Activate()

	local phys = ent:GetPhysicsObject() -- rely on this being valid

	self:SetupKeypad(ent, password)

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
		ply:ConCommand("keypad_repeats_granted 0")
		ply:ConCommand("keypad_repeats_denied 0")
		ply:ConCommand("keypad_length_granted 4")
		ply:ConCommand("keypad_length_denied 0.1")
		ply:ConCommand("keypad_delay_granted 0")
		ply:ConCommand("keypad_delay_denied 0")
		ply:ConCommand("keypad_init_delay_granted 0")
		ply:ConCommand("keypad_init_delay_denied 0")
	end

	concommand.Add("keypad_reset", ResetSettings)

	function TOOL.BuildCPanel(CPanel)
		local r, l = CPanel:TextEntry(translates.Get("4х значный пароль") or "4х значный пароль", "keypad_password")
		r:SetTall(22)

		CPanel:ControlHelp(translates.Get("Допустимые цифры: 1-9") or "Допустимые цифры: 1-9")

		CPanel:CheckBox(translates.Get("Безопасный режим") or "Безопасный режим", "keypad_secure")
		CPanel:CheckBox(translates.Get("Сварить и заморозить") or "Сварить и заморозить", "keypad_weld")
		CPanel:CheckBox(translates.Get("Заморозить") or "Заморозить", "keypad_freeze")

		local ctrl = vgui.Create("CtrlNumPad", CPanel)
			ctrl:SetConVar1("keypad_key_granted")
			ctrl:SetConVar2("keypad_key_denied")
			ctrl:SetLabel1(translates.Get("Доступ получен") or "Доступ получен")
			ctrl:SetLabel2(translates.Get("Доступ запрещен") or "Доступ запрещен")
		CPanel:AddPanel(ctrl)

		CPanel:Button(translates.Get("Сбросить настройки") or "Сбросить настройки", "keypad_reset")

		CPanel:Help("")
		CPanel:Help(translates.Get("Настройки когда доступ получен") or "Настройки когда доступ получен")

		CPanel:NumSlider(translates.Get("Время удержания") or "Время удержания", "keypad_length_granted", 4, 10, 2)
		CPanel:NumSlider(translates.Get("Начальная задержка") or "Начальная задержка", "keypad_init_delay_granted", 0, 10, 2)
		CPanel:NumSlider(translates.Get("Задержка многократного нажатия") or "Задержка многократного нажатия", "keypad_delay_granted", 0, 10, 2)
		CPanel:NumSlider(translates.Get("Дополнительные повторы") or "Дополнительные повторы", "keypad_repeats_granted", 0, 5, 0)

		
		CPanel:Help("")
		CPanel:Help(translates.Get("Настройки когда доступ запрещен") or "Настройки когда доступ запрещен")

		CPanel:NumSlider(translates.Get("Время удержания") or "Время удержания", "keypad_length_denied", 0.1, 10, 2)
		CPanel:NumSlider(translates.Get("Начальная задержка") or "Начальная задержка", "keypad_init_delay_denied", 0, 10, 2)
		CPanel:NumSlider(translates.Get("Задержка многократного нажатия") or "Задержка многократного нажатия", "keypad_delay_denied", 0, 10, 2)
		CPanel:NumSlider(translates.Get("Дополнительные повторы") or "Дополнительные повторы", "keypad_repeats_denied", 0, 5, 0)
	end
end