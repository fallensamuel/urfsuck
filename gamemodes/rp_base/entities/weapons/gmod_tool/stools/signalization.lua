-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\signalization.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

-----------------------------------------------------
TOOL.Category = "Roleplay"
TOOL.Name = "#Tool.signalization.name"
TOOL.Information = {'left'}

if ( CLIENT ) then

	language.Add( "Tool.signalization.name", translates.Get("Сигнализация") )
	language.Add( "Tool.signalization.desc", translates.Get("Позволяет установить сигнализацию.") )

    language.Add('Tool.signalization.left', translates.Get('ЛКМ - Поставить сигнализацию.'));
    language.Add('Undone_signalization', translates.Get('Сигнализация убрана'));

end

local model_map = {
	["models/props_lab/reciever01a.mdl"] 	= true, 
	["models/props_lab/reciever01b.mdl"] 	= true, 
	//["models/props_lab/securitybank.mdl"] 	= true, 
	//["models/props_lab/servers.mdl"] 		= true
}

local sound_map = {
	["npc/attack_helicopter/aheli_damaged_alarm1.wav"] = translates.Get("Сирена"),
	["ambient/alarms/warningbell1.wav"] = translates.Get("Удар в колокол"),
}

// Модель по дефолту
TOOL.ClientConVar[ "model" ]      = "models/props_lab/reciever01a.mdl"
// Звук по дефолту
TOOL.ClientConVar[ "sound" ]       = "ambient/alarms/manhack_alert_pass1.wav"
// Игнор фракции по дефолту
TOOL.ClientConVar[ "ignore_fraction" ]     = 0
// Радиус
TOOL.ClientConVar[ "radius" ]     = 50	
// Игнор орги по дефолту
TOOL.ClientConVar[ "ignore_org" ]    = 0
// Имя сигналки по дефолту
TOOL.ClientConVar[ "sname" ]    = translates.Get("Сигнализация 1")

// Лист моделей
for k,v in pairs(model_map) do
	list.Set( "SigModel", k, {} )
end

// Лист звуков
for k,v in pairs(sound_map) do
	list.Set( "SigSound", k, v )
end


---------------------------------------------------------------
function TOOL:LeftClick( trace )

	if ( IsValid( trace.Entity ) && trace.Entity:IsPlayer() ) then return false end
	if ( CLIENT ) then return true end
	if not model_map[self:GetClientInfo( "model" )] then return false end
	if not sound_map[self:GetClientInfo( "sound" )] then return false end
	
	if(not self:GetWeapon():CheckLimit("signals")) then return false end

	local ply = self:GetOwner()
	local pos = trace.HitPos

	local model = self:GetClientInfo( "model" )
	local sound = self:GetClientInfo( "sound" )
	local radius = self:GetClientNumber( "radius" )
	local ignore_org = self:GetClientNumber( "ignore_org" )
	local ignore_frac = self:GetClientNumber( "ignore_fraction" )
	local sname = self:GetClientInfo( "sname" )

	radius = math.ceil(radius * 50);

	local ent = MakeSignalization( ply, pos, model, sound, radius, ignore_org, ignore_frac, sname)

	ply:AddCount("signals", ent)
	ply:AddCleanup("signals", ent)

	if (IsValid(ent) and IsValid(ent:GetPhysicsObject())) then
		ent:GetPhysicsObject():EnableMotion(false);
	end

	return true

end

function TOOL:RightClick( trace )

	return true

end

if ( SERVER ) then

	function MakeSignalization( ply, pos, model, sound, radius, ignore_org, ignore_frac, sname)

		if IsValid(ply) then

			local sig = ents.Create("urf_signal")
			sig:SetModel(model)
			sig.name = sname
			sig.beepsound = sound
			sig.radius = radius
			sig.ignore_frac = tobool(ignore_frac)
			sig.ignore_org = tobool(ignore_org)
			sig:SetOwner(ply)
			sig:SetPos(pos)
			sig:Spawn()

			undo.Create( "signalization" )
				undo.AddEntity( sig )
				undo.SetPlayer( ply )
			undo.Finish()

			return sig
		end
	end
	
end


function TOOL.BuildCPanel( CPanel )

	CPanel:TextEntry(translates.Get("Имя сигнализации"), "signalization_sname")
	
	CPanel:AddControl( "PropSelect", { Label = translates.Get("Модель сигнализации:"), ConVar = "signalization_model", Height = 3, Models = list.Get( "SigModel" ) } )
	
	local params = { Label = translates.Get("Звук сигнализации"), MenuButton = "0", Options = {} }

	for k,v in pairs (list.Get("SigSound")) do
		params.Options[v] = { signalization_sound = k}
	end
	CPanel:AddControl("ComboBox", params)

	CPanel:AddControl( "Slider", { Label = translates.Get("Радиус срабатывания:"),Type = "Integer", Min = 1, Max = 10, Command = "signalization_radius", Description = translates.Get("Какой будет радиус у сигналки") } )

	CPanel:AddControl( "Checkbox", { Label = translates.Get("Игнорировать игроков своей фракции"), Command = "signalization_ignore_fraction",    Description = translates.Get("Игнорирует вашу фракцию") } )
	CPanel:AddControl( "Checkbox", { Label = translates.Get("Игнорировать игроков своей организации"), Command = "signalization_ignore_org",    Description = translates.Get("Игнорирует вашу организацию") } )

	local Hint = vgui.Create('DLabel');
	Hint:SetDark(true);
	Hint:SetWrap(true);
	Hint:SetColor(Color(51, 51, 255));
	Hint:SetText(translates.Get('Подсказка: сигнализация реагирует на чужаков, издавая звук для того, чтобы сообщить о том, что рядом с ней находится чужак.'));
	Hint:SetContentAlignment(5);
	Hint:SetSize(CPanel:GetWide(), 50);
	CPanel:AddItem(Hint);
end