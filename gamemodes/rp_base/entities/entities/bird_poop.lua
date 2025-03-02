-- "gamemodes\\rp_base\\entities\\entities\\bird_poop.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile();

ENT.Type = 'anim';
ENT.Base = 'base_gmodentity';

ENT.Spawnable = false;
ENT.AdminSpawnable = false;

ENT.LifeTime = 10;
ENT.StartSpeed = 1;

local White = Color(255, 255, 255);
local TextureResolution = 1 / (15 + 1) * .5;

function ENT:Initialize()
    if (CLIENT) then return end

    self:SetModel('models/hunter/blocks/cube025x025x025.mdl');
    self:DrawShadow(false);

    self:PhysicsInit(SOLID_VPHYSICS);
    self:SetMoveType(MOVETYPE_VPHYSICS);
    self:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER);
    
    local Physics = self:GetPhysicsObject();

    if (IsValid(Physics)) then
        Physics:Wake();
        Physics:SetVelocity(Vector(0, 0, -self.StartSpeed));
    end

    util.SpriteTrail(self, 0, White, false, 48, 1, .25, TextureResolution, 'trails/laser');
    self.Spawned = CurTime();
end

function ENT:Think()
    if (CLIENT) then return end

    local Time = CurTime();

    if ((Time - (self.Spawned or 0)) > self.LifeTime) then
        SafeRemoveEntity(self);
    end

    self:NextThink(Time + 1);
end

function ENT:PhysicsCollide(Data, Physics)
    if (IsValid(self) and (Data.HitEntity == Entity(0))) then
        self:EmitSound('phx/eggcrack.wav');
        util.Decal('BirdPoop', Data.HitPos + Data.HitNormal, Data.HitPos - Data.HitNormal);
    end

    SafeRemoveEntity(self);
end

if (SERVER) then return end

function ENT:Draw()

end