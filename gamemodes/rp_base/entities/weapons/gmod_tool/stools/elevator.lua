-- "gamemodes\\rp_base\\entities\\weapons\\gmod_tool\\stools\\elevator.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
TOOL.Category 						= "Construction";
TOOL.Name 							= translates.Get( "Лифт" );

TOOL.MaxDist 						= 512;

TOOL.ClientConVar["speed"]       	= "70";
TOOL.ClientConVar["movesound"]   	= "Elevators.HeavyMetal";
TOOL.ClientConVar["stopsound"]   	= "Elevators.Stop.HeavyMetal";
TOOL.ClientConVar["keystart"]    	= "0";
TOOL.ClientConVar["keyreturn"]   	= "0";
TOOL.ClientConVar["allowuse"]    	= "0";
TOOL.ClientConVar["shake"]       	= "1";

TOOL.Information = {
	{ name = "start", stage = 0, icon = "gui/lmb.png" },
	{ name = "update", stage = 0, icon = "gui/rmb.png" },

	{ name = "do_z", stage = 1, icon = "gui/lmb.png" },
	{ name = "undo", stage = 1, icon = "gui/rmb.png" },
	{ name = "reset", stage = 1, icon = "gui/r.png" },

	{ name = "do_x", stage = 2, icon = "gui/lmb.png" },
	{ name = "undo", stage = 2, icon = "gui/rmb.png" },
	{ name = "reset", stage = 2, icon = "gui/r.png" },

	{ name = "do_y", stage = 3, icon = "gui/lmb.png" },
	{ name = "undo", stage = 3, icon = "gui/rmb.png" },
	{ name = "reset", stage = 3, icon = "gui/r.png" },

	{ name = "create", stage = 4, icon = "gui/lmb.png" },
	{ name = "undo", stage = 4, icon = "gui/rmb.png" },
	{ name = "reset", stage = 4, icon = "gui/r.png" },
};
----------------------------------------------------------------

if CLIENT then
	language.Add( "tool.elevator.name", translates.Get("Лифт") );
	language.Add( "tool.elevator.desc", translates.Get("Инструмент для создания лифтов.") );

	language.Add( "tool.elevator.start", translates.Get("Создать лифт.") );
	language.Add( "tool.elevator.create", translates.Get("Создать лифт.") );
	language.Add( "tool.elevator.update", translates.Get("Обновить лифт.") );
	language.Add( "tool.elevator.reset", translates.Get("Сбросить.") );
	language.Add( "tool.elevator.undo", translates.Get("Отменить действие.") );

	language.Add( "tool.elevator.do_x", translates.Get("Установить позицию лифта по оси X.") );
	language.Add( "tool.elevator.do_y", translates.Get("Установить позицию лифта по оси Y.") );
	language.Add( "tool.elevator.do_z", translates.Get("Установить позицию лифта по оси Z.") );

	language.Add( "tool.elevator.keystart", translates.Get("Отправка") );
	language.Add( "tool.elevator.keyreturn", translates.Get("Возврат") );

	language.Add( "tool.elevator.movesound", translates.Get("Звук в движении") );
	language.Add( "tool.elevator.stopsound", translates.Get("Звук прибытия") );

	language.Add( "tool.elevator.speed", translates.Get("Скорость") );

	language.Add( "tool.elevator.allowuse", translates.Get("Использование на кнопку [E]") );

	language.Add( "tool.elevator.shake", translates.Get("Тряска") );

	language.Add( "Undone." .. TOOL.Name, translates.Get( "Лифт убран" ) );
	language.Add( "Undone_" .. TOOL.Name, translates.Get( "Лифт убран" ) );

	language.Add( "Cleanup." .. TOOL.Name, translates.Get( "Лифт" ) );
	language.Add( "Cleanup_" .. TOOL.Name, translates.Get( "Лифт" ) );

	language.Add( "Cleaned." .. TOOL.Name, translates.Get( "Все лифты удалены!" ) );
	language.Add( "Cleaned_" .. TOOL.Name, translates.Get( "Все лифты удалены!" ) );

	language.Add( "tool.elevator.movesounds.none", translates.Get("None") );
	language.Add( "tool.elevator.stopsounds.none", translates.Get("None") );

	list.Set( "elevator.Relative", "#tool.elevator.relative.prop", {elevator_local = "1"} );
	list.Set( "elevator.Relative", "#tool.elevator.relative.world", {elevator_local = "0"} );
end

if SERVER then
	if rp.GetLimit( "elevators" ) == 0 then
		rp.SetLimit( "elevators", 1 );
	end

	hook.Add( "CanTool", "Elevators::CanTool", function( ply, tr, tool )
		if IsValid(tr.Entity) and (tr.Entity:GetClass() == "func_movelinear") and tr.Entity:CPPIGetOwner() then
			if (not ply:IsAdmin()) and (ply ~= tr.Entity:CPPIGetOwner()) then return end
			return true
		end
	end );
end

-- Utilities: --------------------------------------------------
cleanup.Register( "elevators" );

if SERVER then
	numpad.Register( "ElevatorStart", function( ply, elevator )
		if not IsValid( elevator ) then return false end
		elevator.parent:RemoveSound(); elevator:Fire("Open");
	end );

	numpad.Register( "ElevatorReturn", function( ply, elevator )
		if not IsValid( elevator ) then return false end
		elevator.parent:RemoveSound(); elevator:Fire("Close");
	end );
end

-- Elevator creation: ------------------------------------------
TOOL.StageFuncs = {
	["height_check"] = function( self, origin )
		local ent = self:GetEnt( 0 );
		if not IsValid( ent ) then return end

		local mins, maxs = ent:OBBMins(), ent:OBBMaxs();
		local offset = (Vector(0,0,mins.z):Distance(Vector(0,0,maxs.z)) * 0.5) + 74;

		local tr_ev = util.TraceHull( {
			start = origin + vector_up * 8,
			endpos = origin + vector_up * offset,
			mins = mins,
			maxs = maxs,
			collisiongroup = COLLISION_GROUP_DEBRIS,
			filter = ent,
		} );

		if tr_ev.Hit then
			origin.z = tr_ev.HitPos.z - offset;
		end
	end,

	[0] = function( self, ply, trace, alt )
		local ent = trace.Entity;

		if alt then
			if (ent:GetClass() == "func_movelinear") and IsValid( ent.parent ) then
				local parent = trace.Entity.parent;
				parent:SetMoveSound( self:ReturnValidClientMoveSound() );
				parent:SetStopSound( self:ReturnValidClientStopSound() );
				parent:SetMoveSpeed( math.Clamp(tonumber(self:GetClientInfo("speed")), 1, 500) );
				parent:SetAllowUse( tobool(self:GetClientInfo("allowuse")) );
				parent:SetShake( tobool(self:GetClientInfo("shake")) );
				return true
			end

			return false
		end

		if (ent:GetClass() ~= "prop_physics") and (ent:GetClass() ~= "prop_physics_multiplayer") then
			return false
		end

		if SERVER and (not ply:IsRoot()) and (not self:GetWeapon():CheckLimit("elevators")) then
			return false
		end

		self:SetObject( 0, ent, ent:GetPos(), nil, 0, ent:GetAngles():Forward() );

		self.basePos, self.baseAng = ent:GetPos(), ent:GetAngles();
		self.movePos = self.basePos;

		return true
	end,

	[1] = function( self, ply, trace, alt )
		local target = self:GetEnt( 0 );

		if alt then
			self.movePos = target:GetPos();
			return
		end
		self.movePos = self.movePos or vector_origin;
		local normal = (ply:GetShootPos() - self.movePos):Angle(); normal.p = 0;

		local p = util.IntersectRayWithPlane( ply:GetShootPos(), ply:GetAimVector(), self.movePos, normal:Forward() );
		if not p then return end

		local new = Vector( self.movePos.x, self.movePos.y, p.z );
		self.StageFuncs["height_check"]( self, new );

		if ply:GetPos():Distance( new ) > self.MaxDist then
			return false
		end

		if p:Distance(self.movePos) > 4 then
			self.movePos = new;
		end

		return true
	end,

	[2] = function( self, ply, trace, alt )
		local target = self:GetEnt( 0 );

		if alt and IsValid(target) then
			local p = target:GetPos();
			self.movePos = Vector(p.x, p.y, self.movePos.z);
			return
		end
		self.movePos = self.movePos or vector_origin;
		local normal = Vector(0,1,0);

		local p = util.IntersectRayWithPlane( ply:GetShootPos(), ply:GetAimVector(), self.movePos, normal );
		if not p then return end

		local new = Vector( p.x, self.movePos.y, self.movePos.z );
		self.StageFuncs["height_check"]( self, new );

		if ply:GetPos():Distance( new ) > self.MaxDist then
			return false
		end

		if p:Distance(self.movePos) > 4 then
			self.movePos = new;
		end

		return true
	end,

	[3] = function( self, ply, trace, alt )
		local target = self:GetEnt( 0 );

		if alt and IsValid(target) then
			local p = target:GetPos();
			self.movePos = Vector(self.movePos.x, p.y, self.movePos.z);
			return
		end
		self.movePos = self.movePos or vector_origin;
		local normal = Vector(1,0,0);

		local p = util.IntersectRayWithPlane( ply:GetShootPos(), ply:GetAimVector(), self.movePos, normal );
		if not p then return end

		local new = Vector( self.movePos.x, p.y, self.movePos.z );
		self.StageFuncs["height_check"]( self, new );

		if ply:GetPos():Distance( new ) > self.MaxDist then
			return false
		end

		if p:Distance(self.movePos) > 4 then
			self.movePos = new;
		end

		return true
	end,

	[4] = function( self, ply, trace )
		if SERVER then
			local target = self:GetEnt( 0 );
			if not IsValid( target ) then return end

			local elevator = ents.Create( "elevator" );
			elevator.Model = target:GetModel();
			elevator.ItemOwner = ply;
			elevator:SetPos( self.basePos );
			elevator:SetAngles( self.baseAng );
			elevator:Spawn();
			elevator:Activate();

			elevator:SetMoveSound( self:ReturnValidClientMoveSound() );
			elevator:SetStopSound( self:ReturnValidClientStopSound() );

			elevator:SetMoveSpeed( math.Clamp(tonumber(self:GetClientInfo("speed")), 1, 500) );
			elevator:SetAllowUse( tobool(self:GetClientInfo("allowuse")) );
			elevator:SetShake( tobool(self:GetClientInfo("shake")) );

			for k, v in ipairs( target:GetMaterials() ) do
				elevator:GetDoor():SetSubMaterial( k - 1, v );
			end
			elevator:GetDoor():SetColor( target:GetColor() );

			elevator:SetStart( self.basePos );
			elevator:SetEnd( self.movePos );

			elevator:GetDoor().StartButton = numpad.OnDown( ply, tonumber(self:GetClientInfo("keystart")), "ElevatorStart", elevator:GetDoor() );
			elevator:GetDoor().ReturnButton = numpad.OnDown( ply, tonumber(self:GetClientInfo("keyreturn")), "ElevatorReturn", elevator:GetDoor() );
			elevator:GetDoor().b1 = tonumber( self:GetClientInfo("keystart") );
			elevator:GetDoor().b2 = tonumber( self:GetClientInfo("keyreturn") );

			SafeRemoveEntity( target );

			undo.Create( self.Name );
				undo.AddEntity( elevator );
				undo.SetPlayer( ply );
			undo.Finish();

			ply:AddCount( "elevators", elevator );
			ply:AddCleanup( "elevators", elevator );

			rp.Notify( ply, NOTIFY_GENERIC, translates.Get("Лифт создан") );
		end

		self:ClearObjects();

		return true
	end
};

function TOOL:Holster()
	self:ClearObjects();
	self:SetStage( 0 );

	if CLIENT then
		self:ReleaseGhostEntity();
	end
end

function TOOL:LeftClick( trace )
	local stage = self:GetStage();
	local f = self.StageFuncs[stage];

	if not f then return end
	local b = f( self, self:GetOwner(), trace );

	if b then
		self:SetStage( (stage + 1) % (#self.StageFuncs + 1) );
	end

	return b
end

function TOOL:RightClick( trace )
	local stage = self:GetStage();
	if stage < 1 then
		local f = self.StageFuncs[0];
		if f then
			local b = f( self, self:GetOwner(), trace, true );
			b = SERVER and b or true
		end

		return true
	end

	self:SetStage( stage - 1 );

	local f = self.StageFuncs[stage - 1];
	if f then f( self, self:GetOwner(), trace, true ); end

	return true
end

if CLIENT then
	function TOOL:Think()
		self:UpdateGhostElevator();
	end

	function TOOL:UpdateGhostElevator()
		local stage = self:GetStage();

		if stage == 0 then
			if IsValid( self.GhostEntity ) then
				self:ReleaseGhostEntity();
			end

			return
		end

		local ply = self:GetOwner();
		local trace = ply:GetEyeTrace();
		local target = self:GetEnt( 0 );

		if IsValid( target ) and (not IsValid(self.GhostEntity)) then
			self:MakeGhostEntity( target:GetModel(), target:GetPos(), target:GetAngles() );
		end

		if not IsValid( self.GhostEntity ) then
			return
		end

		local origin = Vector(self.movePos.x, self.movePos.y, self.movePos.z);
		local origin_l = Vector(self.movePos.x, self.movePos.y, self.movePos.z);

		if stage == 1 then
			local normal = (ply:GetShootPos() - origin):Angle(); normal.p = 0;

			local p = util.IntersectRayWithPlane( ply:GetShootPos(), ply:GetAimVector(), origin, normal:Forward() );
			if not p then return end

			if p:Distance(origin_l) > 4 then
				origin.z = p.z;
			end

			self.GhostEntity:SetPos( origin );
			goto cont
		end

		if stage == 2 then
			local normal = Vector(0,1,0);

			local p = util.IntersectRayWithPlane( ply:GetShootPos(), ply:GetAimVector(), origin, normal );
			if not p then return end

			if p:Distance(origin_l) > 4 then
				origin.x = p.x;
			end

			self.GhostEntity:SetPos( origin );
			goto cont
		end

		if stage == 3 then
			local normal = Vector(1,0,0);

			local p = util.IntersectRayWithPlane( ply:GetShootPos(), ply:GetAimVector(), origin, normal );
			if not p then return end

			if p:Distance(origin_l) > 4 then
				origin.y = p.y;
			end

			self.GhostEntity:SetPos( origin );
			goto cont
		end

		::cont::

		local mins, maxs = Vector(0,0,self.GhostEntity:OBBMins().z), Vector(0,0,self.GhostEntity:OBBMaxs().z);
		local offset = (mins:Distance(maxs) * 0.5) + 74;

		local tr_ev = util.TraceHull( {
			start = origin + vector_up * 8,
			endpos = origin + vector_up * offset,
			mins = self.GhostEntity:OBBMins(),
			maxs = self.GhostEntity:OBBMaxs(),
			collisiongroup = COLLISION_GROUP_DEBRIS,
			filter = target,
		} );

		if tr_ev.Hit then
			origin.z = tr_ev.HitPos.z - offset;
			self.GhostEntity:SetPos( origin );
		end

		local valid_dist = ply:GetPos():Distance( origin ) <= self.MaxDist;
		self.GhostEntity:SetColor( valid_dist and Color(0,255,0,150) or Color(255,0,0,150) );

		if stage == 4 then
			self.GhostEntity:SetColor( Color(255,255,255,150) );
		end
	end
end


function TOOL.BuildCPanel(CPanel)
	CPanel:AddControl( "Numpad", {
		Label = "#tool.elevator.keystart",
		Command = "elevator_keystart",
		Label2 = "#tool.elevator.keyreturn",
		Command2 = "elevator_keyreturn"
	} );

	CPanel:AddControl( "ComboBox", {
		Label = "#tool.elevator.movesound",
		Options = list.Get("elevator.MoveSounds")
	} );

	CPanel:AddControl( "ComboBox", {
		Label = "#tool.elevator.stopsound",
		Options = list.Get("elevator.StopSounds")
	} );

	CPanel:AddControl( "Slider", {
		Label = "#tool.elevator.speed",
		Command = "elevator_speed",
		Type = "Float",
		Min = 1,
		Max = 200
	} );

	CPanel:AddControl( "CheckBox", {
		Label = "#tool.elevator.allowuse",
		Command = "elevator_allowuse",
	} );

	CPanel:AddControl( "CheckBox", {
		Label = "#tool.elevator.shake",
		Command = "elevator_shake",
	} );
end

local moveSounds = {
	["Heavy Metal"] = "plats/skylift_move.wav",
	["Squeaky"] = "plats/elevator_loop1.wav",
	["Tram"] = "plats/tram_move.wav",
	["Rusty"] = "plats/hall_elev_move.wav",
	["Old 1"] = "plats/elevator_move_loop1.wav",
	["None"] = "common/null.wav",
};

local stopSounds = {
	["Heavy Metal"] = "plats/skylift_stop.wav",
	["Squeaky"] = "plats/elevator_stop.wav",
	["Rusty"] = "plats/hall_elev_stop.wav",
	["Old 1"] = "plats/elevator_stop1.wav",
	["Old 2"] = "plats/elevator_stop2.wav",
	["Industrial"] = "plats/elevator_large_stop1.wav",
	["None"] = "common/null.wav",
};

local validSounds = {
	move = {}, stop = {}
};

for k, v in pairs( moveSounds ) do
	local name = k:gsub(" ", "");
	local snd = "Elevators." .. name;

	sound.Add({
		name = snd,
		sound = v,
		volume = 1,
		pitch = 100,
		level = 75,
		channel = CHAN_STATIC
	});

	list.Set( "elevator.MoveSounds", "#tool.elevator.movesounds." .. name:lower(), {elevator_movesound = snd} );
	validSounds.move[snd:lower()] = true;

	if CLIENT then
		language.Add( "tool.elevator.movesounds." .. name:lower(), k );
	end
end

for k, v in pairs( stopSounds ) do
	local name = k:gsub(" ", "");
	local snd = "Elevators.Stop." .. name;

	sound.Add( {
		name = snd,
		sound = v,
		volume = 1,
		pitch = 100,
		level = 75,
		channel = CHAN_STATIC
	} );

	list.Set( "elevator.StopSounds", "#tool.elevator.stopsounds." .. name:lower(), {elevator_stopsound = snd} );
	validSounds.stop[snd:lower()] = true;

	if CLIENT then
		language.Add( "tool.elevator.stopsounds." .. name:lower(), k );
	end
end

function TOOL:ReturnValidClientMoveSound()
	local snd = self:GetClientInfo( "movesound" );
	return validSounds.move[snd:lower()] and snd or "Elevators.HeavyMetal";
end

function TOOL:ReturnValidClientStopSound()
	local snd = self:GetClientInfo( "stopsound" );
	return validSounds.stop[snd:lower()] and snd or "Elevators.Stop.HeavyMetal";
end