-- "gamemodes\\rp_base\\entities\\entities\\elevator_button\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile();
DEFINE_BASECLASS( "base_entity" );


----------------------------------------------------------------
ENT.PrintName		= "Кнопка лифта";
ENT.Spawnable		= false;
ENT.AdminOnly		= true;
ENT.Model			= Model( "models/props_combine/combinebutton.mdl" );
ENT.RenderGroup 	= RENDERGROUP_BOTH;

ENT.SENDER = {};
ENT.SENDER.UP = 0;
ENT.SENDER.DOWN = 1;
ENT.SENDER.BOTH = 2;
----------------------------------------------------------------


function ENT:SetupDataTables()
	self:NetworkVar( "Entity", 0, "Elevator" );
	self:NetworkVar( "Int", 0, "Sender" );
end

if CLIENT then
	function ENT:Draw()
		self:DrawModel();
	end

	function ENT:DrawTranslucent()
		self:DrawModel();
	end

	return
end

function ENT:Initialize()
	self:SetModel( self.Model );
	self:SetSolid( SOLID_VPHYSICS );
	self:PhysicsInit( SOLID_VPHYSICS );
	self:SetUseType( SIMPLE_USE );
	self:PhysWake();

	timer.Simple( FrameTime(), function()
		if IsValid( self.ItemOwner ) then
			self:CPPISetOwner( self.ItemOwner );
		end
	end );
end

function ENT:Use( activator, caller, type, value )
	local elevator = self:GetElevator();

	if IsValid( elevator ) and elevator:GetVelocity():LengthSqr() <= 1 then
		local t = self:GetSender();

		if t == self.SENDER.UP then
			elevator:Fire( "Open" );
			goto ret;
		end

		if t == self.SENDER.DOWN then
			elevator:Fire( "Close" );
			goto ret;
		end

		if t == self.SENDER.BOTH then
			local startPos, endPos = elevator.worldStartPos, elevator.worldEndPos;

			if elevator:GetPos():DistToSqr( startPos ) <= 100 then
				elevator:Fire( "Open" ); return
			elseif elevator:GetPos():DistToSqr( endPos ) <= 100 then
				elevator:Fire( "Close" ); return
			end
		end
	end

	::ret::
end