-- "gamemodes\\rp_base\\entities\\entities\\urf_button.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
DEFINE_BASECLASS("base_anim")

function ENT:SetupDataTables()
	self:NetworkVar( "Bool", 0, "Pressed" );
end

function ENT:Initialize()
	if (SERVER) then
		self:PhysicsInit(SOLID_VPHYSICS)
		self:SetMoveType(MOVETYPE_NONE)
		self:SetSolid(SOLID_VPHYSICS)
		self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
		self:SetTrigger( true ) -- тк коллизия отключена ^
		--self.Col = self:GetColor() or Color(255, 255, 255)
		self.Cooldown = 1
	end

	if CLIENT then
		self.RenderMatrix = Matrix();
		self.EntityHeight = self:OBBMaxs().z;
		self.__pressed    = false;
	end
end

function ENT:StartTouch(ent)
	if not (ent:IsPlayer() and ent:IsValid()) then return end
	self:EmitSound('buttons/lightswitch2.wav', 50, 70)
	if self.Toggled then self:Toggle(!self.On, ent) return end
	self:Toggle(true, ent)
	timer.Destroy('urfpressbutton' .. self:GetCreationID());
end
-- self:EmitSound('buttons/button3.wav', 60, 70)

function ENT:EndTouch(ent)
	if not (ent:IsPlayer() and ent:IsValid()) then return end
	if self.Toggled then return end

	timer.Create('urfpressbutton' .. self:GetCreationID(), self.Cooldown, 1, function()
		if (!IsValid(self)) then return end
		self:Toggle(false, ent);
	end);
end

function ENT:Toggle(bEnable, ply)
	local prop_pos = self:GetPos()
	local pl = self:CPPIGetOwner()
	pl.UsingKeypad = true

	if (bEnable) then
		numpad.Activate(pl, self.Key, true)
		self.On = true

		--self:SetPos(Vector(prop_pos.x,prop_pos.y,prop_pos.z - .5)) -- CRAZY ENTITY!
		--self.Col = self:GetColor();
		--self:SetColor(Color(self.Col.r - 150, self.Col.g - 150, self.Col.b - 150));
	else
		numpad.Deactivate(pl, self.Key, true)
		self.On = false

		--self:SetPos(Vector(prop_pos.x,prop_pos.y,prop_pos.z + .5)) -- CRAZY ENTITY!
		--self:SetColor(self.Col);
	end

	self:SetPressed( self.On );

	pl.UsingKeypad = false
end

function ENT:Draw()
	if self:GetPressed() ~= self.__pressed then -- because NetworkVarNotify doesn't work from serverside -> clientside
		self.RenderMatrix:SetTranslation( Vector( 0, 0, -self.EntityHeight * 0.5 ) * (self:GetPressed() and 1 or 0) );
		self:EnableMatrix( "RenderMultiply", self.RenderMatrix );

		self.__pressed = self:GetPressed();
	end

	self:DrawModel();
end