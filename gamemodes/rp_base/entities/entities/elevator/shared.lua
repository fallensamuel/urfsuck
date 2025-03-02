-- "gamemodes\\rp_base\\entities\\entities\\elevator\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile();
DEFINE_BASECLASS( "base_entity" );
local color_clear = Color( 0, 0, 0, 0 );


----------------------------------------------------------------
ENT.PrintName		= "Лифт";
ENT.Spawnable		= false;
ENT.AdminOnly		= true;
ENT.Model			= Model( "models/hunter/plates/plate2x2.mdl" );
ENT.RenderGroup 	= RENDERGROUP_BOTH;
----------------------------------------------------------------


function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 0, "Door" );
end

function ENT:Initialize()
	if CLIENT then
		self:SetSolid( SOLID_VPHYSICS );
		return
	end

	self.door = ents.Create( "func_movelinear" );
	self.door:SetPos( self:GetPos() );
	self.door:SetAngles( self:GetAngles() );
	self.door:SetModel( self.Model );
	self.door:Spawn();
	self.door:SetMoveType( MOVETYPE_PUSH );
	self.door:SetNoDraw( true );
	self.door.parent = self;

	self.door:SetName( "elevator_" .. self:EntIndex() );
	self:SetName( "elevator_parent_" .. self:EntIndex() );

	self.door:SetKeyValue( "OnFullyOpen", self:GetName() .. ",Shake" );
	self.door:SetKeyValue( "OnFullyClosed", self:GetName() .. ",Shake" );

	self:SetDoor( self.door );

	self.door.child = ents.Create( "prop_dynamic" );
	self.door.child:SetModel( self.Model );
	self.door.child:Spawn();
	self.door.child:SetParent( self.door );
	self.door.child:SetLocalPos( vector_origin );
	self.door.child:SetLocalAngles( angle_zero );
	self.door.child:SetNotSolid( true );
	self.door.child:SetRenderMode( RENDERMODE_TRANSCOLOR );

	self:SetParent( self.door );
	self:SetNotSolid( true );
	self:SetNoDraw( true );
	self:SetColor( color_clear );

	timer.Simple( FrameTime(), function()
		if IsValid( self.ItemOwner ) then
			self.door:CPPISetOwner( self.ItemOwner );
		end
	end );
end

if CLIENT then return end

-- Entity: -----------------------------------------------------
function ENT:RemoveSound()
	if IsValid( self.door ) then
		self.door:StopSound( self.door.movesound or "" );
	end
end

function ENT:AcceptInput( name, act, caller, data )
	if self.door.shake and (name == "Shake") then
		local info = self.door.movespeed * 0.01;
		util.ScreenShake( self.door:GetPos(), info, info, 0.5, self.door.movespeed * 3.5 );
	end
end

function ENT:Think()
	if IsValid( self.door.child ) then
		self.door.child:SetColor( self.door:GetColor() );
		self.door.child:SetMaterial( self.door:GetMaterial() );
	end

	if IsValid( self.door ) then
		self.door:SetNoDraw( true );
	end
end

function ENT:OnRemove()
	if IsValid( self.door ) then self:RemoveSound(); end
	SafeRemoveEntity( self.door );
end

function ENT:SetStart( vec )
	if not IsValid( self.door ) then return end
	self.door:SetSaveValue( "m_vecPosition1", tostring(vec) );
	self.door.startPos = self.door:WorldToLocal( vec );
	self.door.worldStartPos = vec;
end

function ENT:SetEnd( vec )
	if not IsValid( self.door ) then return end
	self.door:SetSaveValue( "m_vecPosition2", tostring(vec) );
	self.door.endPos = self.door:WorldToLocal( vec );
	self.door.worldEndPos = vec;
end

function ENT:SetMoveSound( snd )
	if not IsValid( self.door ) then return end
	snd = tostring( snd );
	self.door:SetKeyValue( "StartSound", snd );
	self.door.movesound = snd;
end

function ENT:SetStopSound( snd )
	if not IsValid( self.door ) then return end
	snd = tostring( snd );
	self.door:SetKeyValue( "StopSound", snd );
	self.door.stopsound = snd;
end

function ENT:SetMoveSpeed( vel )
	if not IsValid( self.door ) then return end
	self.door:Fire( "SetSpeed", tostring(vel) );
	self.door.movespeed = tonumber(vel);
end

function ENT:SetShake( bShake )
	self.door.shake = tobool( bShake );
end

function ENT:SetAllowUse( bUse )
	self.door.allowuse = tobool(bUse);
end

function ENT:ChangeModel( model )
	if IsValid( self.door ) then
		self.door:SetModel( model );
		self.door:Activate();
	end

	if IsValid( self.door.child ) then
		self.door.child:SetModel( model );
	end
end


-- Hooks: ------------------------------------------------------
hook.Add( "KeyPress", "Elevators::UseHandler", function( ply, key )
	if key ~= IN_USE then return end

	local ent = ply:GetEyeTrace().Entity;

	if not IsValid( ent ) then return end
	if ply:GetEyeTrace().HitPos:DistToSqr(ply:EyePos()) >= 7225 then return end -- 85

	if ent:GetClass() == "func_movelinear" then
		if ent.allowuse then
			local startPos, endPos = ent.worldStartPos, ent.worldEndPos;

			if ent:GetPos():DistToSqr( startPos ) <= 100 then
				ent.parent:RemoveSound(); ent:Fire( "Open" ); return
			elseif ent:GetPos():DistToSqr( endPos ) <= 100 then
				ent.parent:RemoveSound(); ent:Fire( "Close" ); return
			end
		end
	elseif IsValid( ent:GetParent() ) then
		ent = ent:GetParent();

		if ent:GetClass() == "func_movelinear" then
			if ent.allowuse then
				local startPos, endPos = ent.worldStartPos, ent.worldEndPos;

				if ent:GetPos():DistToSqr( startPos ) <= 100 then
					ent.parent:RemoveSound(); ent:Fire( "Open" ); return
				elseif ent:GetPos():DistToSqr( endPos ) <= 100 then
					ent.parent:RemoveSound(); ent:Fire( "Close" ); return
				end
			end
		end
	end
end );

hook.Add( "PhysgunPickup", "Elevators::NoPhysgunPickup", function( ply, ent )
	if ent:GetClass() == "func_movelinear" then
		return false
	end

	local p = ent:GetParent();
	if IsValid( p ) and (p:GetClass() == "func_movelinear") then
		return false
	end
end );


-- Duplicator: -------------------------------------------------
--[[
duplicator.RegisterEntityClass( "func_movelinear", function(player, data, startPos, endPos, speed, moveSound, stopSound, blockDamage, bAllowUse, startButton, returnButton, parts, worldStartPos, bShake)
	local ent = ents.Create("elevator")
	ent:SetPos(data.Pos)
	ent:SetAngles(data.Angle)
	ent.Model = data.Model
	ent:Spawn()

	ent:SetStart(ent:GetDoor():LocalToWorld(startPos))
	ent:SetEnd(ent:GetDoor():LocalToWorld(endPos))

	ent:SetMoveSpeed(speed)
	ent:SetMoveSound(moveSound)
	ent:SetStopSound(stopSound)

	ent:SetBlockDamage(blockDamage)
	ent:SetAllowUse(bAllowUse)
	ent:SetShake(bShake)

	ent:GetDoor().StartButton = numpad.OnDown(player, startButton, "ElevatorStart", ent:GetDoor())
	ent:GetDoor().ReturnButton = numpad.OnDown(player, returnButton, "ElevatorReturn", ent:GetDoor())

	table.Add(ent:GetTable(), data)

	if (parts) then
		for k, v in pairs(parts) do
			local prop = ents.Create("prop_physics")
			prop:SetPos(ent:GetDoor():LocalToWorld(v.origin))
			prop:SetAngles(ent:GetDoor():LocalToWorldAngles(v.angles))
			prop:SetModel(v.model)
			prop:SetMaterial(v.material)
			prop:SetRenderMode(v.rendermode)
			prop:SetColor(v.color)
			prop:Spawn()
			prop:SetParent(ent:GetDoor())
			prop:GetPhysicsObject():EnableMotion(false)
		end
	end

	return ent
end, "Data", "startPos", "endPos", "movespeed", "movesound", "stopsound", "blockdamage", "allowuse", "	", "b2", "parts", "material", "worldStartPos", "shake")
]]--