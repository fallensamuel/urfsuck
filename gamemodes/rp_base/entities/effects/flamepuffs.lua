-- "gamemodes\\rp_base\\entities\\effects\\flamepuffs.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile();

game.AddParticles( "particles/fire_01.pcf" );
PrecacheParticleSystem( "burning_gib_01" );

local vec_default_bounds = Vector(1, 1, 1);

function EFFECT:Init( data )
	self.ent = data:GetEntity();

	if not IsValid( self.ent ) then return end

	self:SetParent( self.ent );
	self:SetRenderBounds( self.ent:GetRenderBounds() );

	if IsValid( self.ent.m_FlamePuff ) then
		self.ent.m_FlamePuff.removing = true;
	end

	self.t_start = CurTime();
	self.t_length = data:GetMagnitude() or 0;
	self.t_end = self.t_start + self.t_length;

	self.mins, self.maxs = self.ent:GetModelBounds();
	self.mins, self.maxs = self.mins or -vec_default_bounds, self.maxs or vec_default_bounds;
	self.bounds = self.maxs - self.mins;

	self.ent.m_FlamePuff = self;
	self.ent.m_FlamePuff_Sound = self.ent:StartLoopingSound( Sound("General.BurningObject") );

	self.ent:CallOnRemove( "StopBurningSound", function( ent )
		ent:StopLoopingSound( ent.m_FlamePuff_Sound );
	end );
end

function EFFECT:OnRemove()
	if IsValid( self.ent ) then
		self.ent:StopLoopingSound( self.ent.m_FlamePuff_Sound or -1 );
		self.ent.m_FlamePuff = nil;
	end
end

function EFFECT:Think()
	if self.removing then
		return false
	end

	local valid, lifetime = IsValid( self.ent ), true;

	if (self.t_length or 0) > 0 then
		lifetime = CurTime() < self.t_end;
	end

	if not (valid and lifetime) then
		self:OnRemove();
		return false
	end

	return true
end

function EFFECT:Render()
	local t = CurTime();

	if (self.fl_NextChange or 0) > t then return end
	self.fl_NextChange = t + math.Rand(0.025, 0.1);

	for i = 1, 3 do
		local origin = LocalToWorld( self.mins + Vector(self.bounds.x * math.random(), self.bounds.y * math.random(), self.bounds.z * math.random()), angle_zero, vector_origin, self.ent:GetAngles() );
		local particleSystem = CreateParticleSystem( self.ent, "burning_gib_01", PATTACH_ABSORIGIN_FOLLOW, 0, origin );

		timer.Simple( 0.25, function()
			particleSystem:StopEmission();
		end );
	end
end