AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

local IsValid = IsValid

function MakeHeadcrabcanister(pos, ang, type, count)
	local prop_headcrabcanister = ents.Create("prop_headcrabcanisterz")
	if (!prop_headcrabcanister:IsValid()) then return false end

	prop_headcrabcanister:SetAngles( Angle(-75, ang.y, 90) )
	prop_headcrabcanister:SetPos(pos)
	prop_headcrabcanister:Spawn()
	prop_headcrabcanister:Activate()
	prop_headcrabcanister.solid = true

	prop_headcrabcanister:Launch(type, count)
end

function ENT:Initialize()
	self.Entity:SetModel("models/props_combine/headcrabcannister01b.mdl")
	self.Entity:SetCollisionBounds(Vector()*-2, Vector()*2)
	self.Entity:PhysicsInit( SOLID_VPHYSICS )
	self.Entity:SetMoveType( MOVETYPE_VPHYSICS )
	self.Entity:SetSolid( SOLID_VPHYSICS )
	self.Entity:SetCollisionGroup( COLLISION_GROUP_WORLD )
	self.Entity:DrawShadow(true)
	self.Entity:SetColor( Color(255,255,255, 0) )
	self.Entity:SetRenderMode( RENDERMODE_TRANSALPHA )
	local phys = self.Entity:GetPhysicsObject()
		if phys and phys:IsValid() then 
			phys:Sleep()
			phys:EnableCollisions(false)
			phys:EnableMotion(false)
			phys:EnableGravity(false)
		end
	constraint.NoCollide(self.Entity, game.GetWorld())
end

function ENT:Launch(type, count)
	local headcrabcanister = ents.Create("env_headcrabcanister")
		headcrabcanister:SetKeyValue( 'targetname', 'env_headcrabcanister' )
		headcrabcanister:SetKeyValue( 'angles', self:GetAngles().p, self:GetAngles().y, self:GetAngles().r )
		headcrabcanister:SetKeyValue( 'Damage', 130 )
		headcrabcanister:SetKeyValue( 'DamageRadius' , 150 )
		headcrabcanister:SetKeyValue( 'FlightSpeed', 3000 )
		headcrabcanister:SetKeyValue( 'FlightTime' , 10 )
		headcrabcanister:SetKeyValue( 'SmokeLifetime', -1 )
		headcrabcanister:SetKeyValue( 'StartingHeight', 2000 )
		headcrabcanister:SetKeyValue( 'HeadcrabType', type )
		headcrabcanister:SetKeyValue( 'HeadcrabCount', count )
		headcrabcanister:Fire( "Spawnflags", "8192", 0)
		headcrabcanister:Fire( "AddOutput", "OnImpacted headcrabcanister Kill", "", 2, 1 )
		headcrabcanister:SetCollisionGroup(0)
		headcrabcanister:SetPos( self:GetPos() )
		self.Entity:DeleteOnRemove(headcrabcanister)
		headcrabcanister:Spawn()
		headcrabcanister:Activate()
		headcrabcanister:Fire( "FireCanister", "", 1 )
		timer.Simple(20, function()
			if (IsValid(self) and IsValid(headcrabcanister)) then
				timer.Create("removecanister"..headcrabcanister:EntIndex(), 0.1, 90, function()
					if (IsValid(headcrabcanister)) then
					headcrabcanister:SetPos(headcrabcanister:GetPos() + Vector(0,0,-1))
					end
				end)
				timer.Simple(9, function()
					if (IsValid(headcrabcanister)) then
						headcrabcanister:Remove()
					end
					if (IsValid(self)) then
						self:Remove()
					end
				end)
			end
		end)
end