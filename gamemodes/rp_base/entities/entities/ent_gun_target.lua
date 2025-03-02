AddCSLuaFile();

ENT.Type        =       'anim'
ENT.Base        =       'base_gmodentity'

ENT.PrintName   =       'Мишень'

function ENT:SetupDataTables()
    self:NetworkVar('Int', 0, 'DamageCounter');
end

function ENT:Draw()
    self:DrawModel();

    local Counter = self:GetDamageCounter();
    if (Counter == -1) then return end

    local Angle = self:GetAngles();
    Angle:RotateAroundAxis(Angle:Up(), 90);
    Angle:RotateAroundAxis(Angle:Forward(), 90);

    cam.Start3D2D(self:GetPos() + Angle:Up() * 7 - Angle:Forward() * 21 - Angle:Right() * 45, Angle, 0.3);
        draw.SimpleText(Counter or '', 'DermaLarge', 0, 0, Color(255, 255, 255, 240), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER);
    cam.End3D2D();
end

if (CLIENT) then return end

function ENT:Initialize()
    self:SetDamageCounter(-1);

    self:SetModel('models/props/cs_militia/haybale_target_02.mdl');
    self:PhysicsInit(SOLID_VPHYSICS);
    self:SetMoveType(MOVETYPE_VPHYSICS);
    self:SetSolid(SOLID_VPHYSICS);

    local Physics = self:GetPhysicsObject();
    if (IsValid(Physics)) then
        Physics:Wake();
    end
end

function ENT:ComputeTarget(LDP)
    return
        (LDP.z >= 13 and LDP.z <= 35) and
        (LDP.y >= -31 and LDP.y <= -10) and
        (LDP.x > 0)
end

function ENT:CleanupTimer()
    local ID = 'gt_' .. tostring(self:GetCreationID());
    if (timer.Exists(ID)) then timer.Remove(ID); end
    timer.Create(ID, 5, 1, function()
        if (!IsValid(self)) then return end
        self:SetDamageCounter(-1);
    end);
end

function ENT:OnTakeDamage(Damage)
    if (self:ComputeTarget(self:WorldToLocal(Damage:GetDamagePosition()))) then
        self:EmitSound('HL1/fvox/bell.wav');
        self:SetDamageCounter(Damage:GetDamage());
        self:CleanupTimer();
    end
end