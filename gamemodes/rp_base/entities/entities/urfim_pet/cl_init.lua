-- "gamemodes\\rp_base\\entities\\entities\\urfim_pet\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include( "shared.lua" );

local SEQUENCE_IDLE = 0;
local SEQUENCE_WALK = 1;
local SEQUENCE_RUN  = 2; 
local SEQUENCE_KILL = 3;
local SEQUENCE_DOWN = 4;
local SEQUENCE_WAIT = 5;


local owner, ownerPos, distance, dir, trace, tr, vel;
local math_Clamp = math.Clamp;
local util_TraceLine = util.TraceLine;


----------------------------------------------------------------
function ENT:MakeSound( uid )
    if not self.IsVisible then return end

    local snd = self.Sounds[uid] or self.PetData.sound; 
    if snd then
        self:EmitSound( snd );
    end
end

function ENT:MakeEffect()
    if not self.IsVisible then return end

    if self.PetData.spawn_effect then
        local e = EffectData()
        e:SetOrigin(self:GetPos() + Vector(0, 0, 5))
        util.Effect(self.PetData.spawn_effect, e)
    end
end


----------------------------------------------------------------
function ENT:UpdateSequence( mode, kill )
    self.SeqMode, self.SeqStart, self.SeqKill = mode, CurTime(), tobool(kill);

    local seqmode = self.Sequences[mode];
    local seq = self.PetData.sequences[seqmode];

    if seq then
        local seqid, seqlen = self:LookupSequence( seq );

        if seqid then
            self.SeqGroundSpeed = self.GroundSpeed or self:GetSequenceGroundSpeed(seqid);
            self.SeqLength = seqlen or 0;
            
            self:ResetSequence( seq );
            self:ResetSequenceInfo();
        end
    end

    if self.Sounds[seqmode] then
        self:MakeSound( seqmode );
    end
end

function ENT:UpdateAnimation()
    local CT = CurTime();

    if self.SeqMode == SEQUENCE_IDLE then
        -- Deathmechanics:
        if self.Owner:IsInDeathMechanics() then
            self:UpdateSequence( SEQUENCE_DOWN );
            return
        end

        -- AFK:
        if (CT - self.SeqStart) > 60 then
            self:UpdateSequence( SEQUENCE_WAIT, true );
            return
        end
    end

    local ST = (CT - self.SeqStart);
    if (self.SeqMode ~= SEQUENCE_WALK) and (self.SeqMode ~= SEQUENCE_RUN) then
        self:SetCycle( (ST % self.SeqLength) / self.SeqLength );
    else
        -- local speed = (self:GetVelocity():Length() * FrameTime()) / engine.TickInterval() * 2;
        -- local rate = speed / self.SeqGroundSpeed;

        self:SetCycle( (ST % self.SeqLength) / self.SeqLength );
    end

    if self.SeqKill then
        if (self.LastCycle or 0) > self:GetCycle() then
            self:UpdateSequence( SEQUENCE_IDLE );
        end
    end

    self.LastCycle = self:GetCycle();
end

function ENT:UpdateMovement()
    owner = self.Owner
    
    if self.TargetAngle ~= self:GetAngles() then
        self:SetAngles( LerpAngle(FrameTime() * 12, self:GetAngles(), self.TargetAngle) );
    end

    movePos = self.TargetMove or owner:GetPos();
    distance = Vector(movePos.x, movePos.y, 0):DistToSqr(Vector(self:GetPos().x, self:GetPos().y, 0))
    
    if distance > self.TeleportDistance then 
        dir = self:GetPos() - movePos
        dir:Normalize()
        dir.z = 0
        
        trace = {}
        trace.start = movePos + dir * 180 + Vector(0, 0, self.SizeOffset * 3)
        trace.endpos = movePos + dir * 180 - Vector(0, 0, 1000)
        trace.filter = {self, owner}
        trace.collisiongroup = COLLISION_GROUP_WEAPON

        tr = util_TraceLine(trace)
        
        if tr.Hit then
            self:SetPos(tr.HitPos + Vector(0, 0, self.SizeOffset * 0.5 + self.ZOffset))
            self:MakeSound()
        end

        return
    end
    
    if distance > self.RunDistance then
        trace = {}
        trace.start = movePos + Vector(0, 0, self.SizeOffset * 2)
        trace.endpos = movePos - Vector(0, 0, 1000)
        trace.filter = {self, owner}
        trace.collisiongroup = COLLISION_GROUP_WEAPON

        tr = util_TraceLine(trace)
        
        if tr.Hit then
            movePos = tr.HitPos
        end
        
        trace.start = self:GetPos() + Vector(0, 0, self.SizeOffset * 3)
        trace.endpos = self:GetPos() - Vector(0, 0, 1000)

        tr = util_TraceLine(trace)
        
        if tr.Hit and tr.Fraction > 0 and tr.FractionLeftSolid == 0 then
            self:SetPos(tr.HitPos + Vector(0, 0, self.SizeOffset * 0.5 + self.ZOffset))
        end
        
        -- Movement:
        dir = movePos - self:GetPos();
        vel = math.min( 200, dir:Length() );
        
        if vel == 200 then
            if self.SeqMode ~= SEQUENCE_RUN then self:UpdateSequence( SEQUENCE_RUN ); end
        else
            if self.SeqMode ~= SEQUENCE_WALK then self:UpdateSequence( SEQUENCE_WALK ); end
        end

        vel = vel * 0.025;
        dir:Normalize();

        self:GetPhysicsObject():SetVelocity( (dir * vel * self.Speed) / FrameTime() );
        
        self.TargetAngle = Angle(0, self:GetVelocity():Angle().yaw, 0);
    else
        self:GetPhysicsObject():SetVelocity( (self:GetVelocity() * 0.8 / self.Speed) / FrameTime() );
        
        if (self.SeqMode == SEQUENCE_WALK) or (self.SeqMode == SEQUENCE_RUN) then
            self:UpdateSequence( SEQUENCE_IDLE );
        end

        if self.TargetMove and (self:GetVelocity():LengthSqr() == 0) then
            self.TargetMove = nil;
        end
    end

    if not self.TargetMove then
        for k, ply in ipairs( ents.FindInSphere(self:GetPos(), self.OBBRadius * 0.25) ) do
            if ply:IsPlayer() then
                if (ply ~= self.Owner) then
                    if (self.LastWalkaway or 0) > CurTime() then
                        return
                    end

                    self.LastWalkaway = CurTime() + 5;
                    self:MakeSound();
                end

                self.TargetMove = self:GetPos() + Angle(0, util.SharedRandom("pet",-1,1,CurTime()) * 360, 0):Forward() * (self.RunDistance ^ 0.5) * 1.75;
                break
            end
        end
    end
end


----------------------------------------------------------------
function ENT:GetPetID()
    return self.PetData.id
end


----------------------------------------------------------------
local events = {
    [rp.pets.Events["KILL"]] = function( self, ... )
        self:UpdateSequence( SEQUENCE_KILL, true );
    end,
};

function ENT:OnEvent( ev, ... )
    if events[ev] then events[ev]( self, ... ); end
end


----------------------------------------------------------------
function ENT:LoadPet( data )
    self.PetData = data;

    self.ZOffset = self.PetData.z_offset or 0;
    self.Speed = self.PetData.speed or 1;
    self.GroundSpeed = self.PetData.ground_speed or nil;
    self.Scale = self.PetData.scale or 1;
    self.Sounds = self.PetData.sounds or {};

    self.SeqMode = SEQUENCE_WALK;
    self.SeqStart = CurTime();
    self.SeqGroundSpeed = 0;
    self.SeqLength = 0;

    self.TargetMove = nil;
    self.TargetAngle = Angle();

    self.OBBRadius = self:GetModelRenderBounds():Length() * self.Scale;
    self.OBBMins = Vector(-1,-1,0) * self.OBBRadius;
    self.OBBMaxs = Vector(1,1,1) * self.OBBRadius;
    
    --

    self:SetModel( self.PetData.model );
    self:SetColor( Color(0,0,0,0) );
    
    if self.PetData.skin then
        self:SetSkin( self.PetData.skin );
    end

    self:PhysicsInit( SOLID_VPHYSICS );
    self:SetMoveType( MOVETYPE_VPHYSICS );
    self:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE );
    self:PhysWake();

    local physObj = self:GetPhysicsObject();
    if IsValid( physObj ) then
        physObj:EnableGravity( false );
        physObj:EnableCollisions( false );
    end

    self:SetNotSolid( true );
    self:SetModelScale( self.Scale );
    
    timer.Simple( 0, function()
        if not IsValid( self ) then return end
        
        self:UpdateSequence( SEQUENCE_IDLE );
        self:MakeSound();
        
        local sizeMin, sizeMax = self:GetPhysicsObject():GetAABB();
        self.SizeOffset = sizeMax.z - sizeMin.z;
        
        local trace = {};
        trace.start = self:GetPos() + Vector(0, 0, self.SizeOffset * 3);
        trace.endpos = self:GetPos() - Vector(0, 0, 1000);
        trace.filter = {self, owner};
        trace.collisiongroup = COLLISION_GROUP_WEAPON;

        local tr = util.TraceLine( trace );
        if tr.Hit and (tr.Fraction > 0) and (tr.FractionLeftSolid == 0) then
            self:SetPos( tr.HitPos + Vector(0, 0, self.SizeOffset * 0.5 + self.ZOffset) );
        end
        
        self:SetColor( Color(255,255,255,255) );
        self:MakeEffect();
    end );
end

function ENT:Think()
    local CT = CurTime();

    if not self.SizeOffset then
        return
    end
    
    if not IsValid( self.Owner ) then
        SafeRemoveEntity( self );
        return
    end
    
    if self.IsVisible then
        self:UpdateMovement();
    end

    self:NextThink( CT + 0.1 );
    return true
end

function ENT:Draw()
    local owner = self:GetOwner();

    if IsValid( owner ) then
        if self.IsVisible and owner:GetNoDraw() or (owner:GetRenderMode() == RENDERMODE_NONE) then
            self.IsVisible = false;
            return
        end
    end

    if not self.IsVisible then
        self.IsVisible = true;
    end

    self:DrawModel();
    self:UpdateAnimation();
end

function ENT:OnRemove()
    self:MakeSound();
    self:MakeEffect();
end


----------------------------------------------------------------
local nextCheck = 0;
hook.Add( "KeyPress", "Pets::ClientsidePress", function( ply, key )
    if key == IN_USE then
        if nextCheck < CurTime() then
            nextCheck = CurTime() + 0.5;
            
            trace = {};
            trace.start = EyePos();
            trace.endpos = EyePos() + EyeVector() * 50;
            trace.filter = LocalPlayer();

            tr = util_TraceLine( trace );
            for k, v in pairs( ents.FindInSphere(tr.HitPos, 50) ) do
                if IsValid(v) and v.IsPet then
                    v:MakeSound();
                end
            end
        end
    end
end )