-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\elevator_button.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
TOOL.Category = "Construction";
TOOL.Name = translates.Get( "Кнопка лифта" );

TOOL.ClientConVar["send"]  = "1";
TOOL.ClientConVar["model"] = "models/props_combine/combinebutton.mdl";

TOOL.Information = {
	{name = "left", stage = 0},
	{name = "right", stage = 0},
};

if CLIENT then
	language.Add( "tool.elevator_button.name", translates.Get("Кнопки лифта") );
	language.Add( "tool.elevator_button.left", translates.Get("Разместить кнопку лифта") );
	language.Add( "tool.elevator_button.right", translates.Get("Выбрать лифт") );
	language.Add( "tool.elevator_button.desc", translates.Get("Инструмент для создания кнопок лифта.") );

	language.Add( "tool.elevator_button.model", translates.Get("Модель") );
	language.Add( "tool.elevator_button.send", translates.Get("Эта кнопка будет") );
	language.Add( "tool.elevator_button.send.call", translates.Get("Вызывать") );
	language.Add( "tool.elevator_button.send.send", translates.Get("Отправлять") );
	language.Add( "tool.elevator_button.send.both", translates.Get("Вызывать / Отправлять") );

	language.Add( "Undone." .. TOOL.Name, translates.Get( "Кнопка лифта убрана" ) );
	language.Add( "Undone_" .. TOOL.Name, translates.Get( "Кнопка лифта убрана" ) );

	language.Add( "Cleanup." .. TOOL.Name, translates.Get( "Кнопка лифта" ) );
	language.Add( "Cleanup_" .. TOOL.Name, translates.Get( "Кнопка лифта" ) );

	language.Add( "Cleaned." .. TOOL.Name, translates.Get( "Все кнопки лифта удалены!" ) );
	language.Add( "Cleaned_" .. TOOL.Name, translates.Get( "Все кнопки лифта удалены!" ) );

	list.Set( "elevatorbuttons.SendOptions", "#tool.elevator_button.send.call", {elevator_button_send = "0"} );
	list.Set( "elevatorbuttons.SendOptions", "#tool.elevator_button.send.send", {elevator_button_send = "1"} );
	list.Set( "elevatorbuttons.SendOptions", "#tool.elevator_button.send.both", {elevator_button_send = "2"} );
end

if SERVER then
	if rp.GetLimit( "elevatorbuttons" ) == 0 then
		rp.SetLimit( "elevatorbuttons", 3 );
	end
end

cleanup.Register( "elevatorbuttons" );

function TOOL:ReturnValidClientModel()
	local model = self:GetClientInfo( "model" );
	return list.Get("ButtonModels")[model] and model or "models/props_combine/combinebutton.mdl";
end

function TOOL:LeftClick( trace )
	if IsValid( trace.Entity ) and trace.Entity:IsPlayer() then return false end
	if not IsValid( self:GetEnt(0) ) then return false end
	if CLIENT then return true end;

	if (not self:GetOwner():IsRoot()) and (not self:GetWeapon():CheckLimit("elevatorbuttons")) then
		return false
	end

	local ang = trace.HitNormal:Angle();
	ang:RotateAroundAxis( ang:Right(), -90 );

	local button = ents.Create("elevator_button");
	button.Model = self:ReturnValidClientModel();
	button:SetPos( trace.HitPos );
	button:SetAngles( ang );
	button:Spawn();
	button:SetSender( tonumber(self:GetClientInfo("send")) );
	button:SetElevator( self:GetEnt(0) );
	button:GetPhysicsObject():EnableMotion( false );

	undo.Create( self.Name );
		undo.AddEntity( button );
		undo.SetPlayer( self:GetOwner() );
	undo.Finish();

	self:GetOwner():AddCount( "elevatorbuttons", button );
	self:GetOwner():AddCleanup( "elevatorbuttons", button );

	return true
end

function TOOL:RightClick( trace )
	local ent = trace.Entity;
	if not IsValid( ent ) then return false end

	if ent:IsPlayer() then return false end
	if ent:GetClass() ~= "func_movelinear" then return false end

	self:SetObject( 0, ent, vector_origin, nil, 0, vector_origin );

	if CLIENT and IsFirstTimePredicted() then
		rp.Notify( NOTIFY_GENERIC, translates.Get("Лифт выбран") );
	end

	return true
end

function TOOL:Holster()
	self:SetStage(0);
	self:ReleaseGhostEntity();
end

function TOOL:UpdateGhostButton(player, ent)
	if not IsValid(ent) then return end
	local trace = player:GetEyeTrace();

	if not trace.Hit then
		ent:SetNoDraw( true );
		return
	end

	if IsValid( trace.Entity ) and trace.Entity:IsPlayer() then
		ent:SetNoDraw( true );
		return
	end;

	local ang = trace.HitNormal:Angle();
	ang:RotateAroundAxis( ang:Right(), -90 );

	ent:SetAngles( ang );

	ent:SetPos( trace.HitPos );
	ent:SetNoDraw( false );
end

function TOOL:Think()
	local mdl = self:ReturnValidClientModel():lower();

	if not IsValid(self.GhostEntity) or self.GhostEntity:GetModel():lower() ~= mdl then
		self:MakeGhostEntity( mdl, vector_origin, angle_zero );
	end

	self:UpdateGhostButton( self:GetOwner(), self.GhostEntity );
end

function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl( "PropSelect", {
		Label = "#tool.elevator_button.model",
		ConVar = "elevator_button_model",
		Height = 4,
		Models = list.Get("ButtonModels");
	} );

	CPanel:AddControl( "ComboBox", {
		Label = "#tool.elevator_button.send",
		Options = list.Get("elevatorbuttons.SendOptions")
	} );
end