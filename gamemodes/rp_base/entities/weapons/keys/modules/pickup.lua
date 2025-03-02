-- "gamemodes\\rp_base\\entities\\weapons\\keys\\modules\\pickup.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile();

-- PLAYER: -----------------------------------------------------
local PLAYER = FindMetaTable( "Player" );
PLAYER._PickupObject = PLAYER._PickupObject or PLAYER.PickupObject;
function PLAYER:PickupObject( ent )
    if not IsValid( ent ) then return end

    if ent:IsPlayerHolding() then return end
    if hook.Run( "AllowPlayerPickup", self, ent ) == false then return end

    ent.holder = self;
    self:_PickupObject( ent );
end

-- Utilities: --------------------------------------------------
local function CanCarry( ent )
    local phys = ent:GetPhysicsObject();

    if
        not IsValid( phys )
        or not phys:IsMoveable()
        or phys:GetMass() > 100
        or (CurTime() - (ent.lastdropped or 0)) < 0
    then
        return false
    end

    return true
end

local function Filter( ent )
    return
        not ent:IsPlayer()
        and not ent:IsNPC()
        and not ent:IsVehicle()
        and CanCarry( ent )
end

-- Core: -------------------------------------------------------
local function OnObjectDrop( ply, ent, thrown )
    ent.lastdropped = CurTime() + engine.TickInterval() + 0.1;
end

local function DoPickup( wep, target )
    if IsValid( target ) and Filter( target ) then
        local CT = CurTime();
        wep:SetNextWeaponFire( CT + 0.5 );

        target:PhysWake();

        timer.Simple( 0.2, function()
            if not IsValid( target ) or not IsValid( wep ) then return end

            local owner = wep:GetOwner();
            if not IsValid( owner ) then return end

            wep:SendAnimToClient( ACT_PICKUP_GROUND );
            owner:PickupObject( target );
            owner:EmitSound( "physics/body/body_medium_impact_soft"..math.random(1,3)..".wav", 75 );
        end );

        return
    end
end

if SERVER then
    hook.Add( "OnPlayerPhysicsDrop", "Keys::ObjectDrop", OnObjectDrop );
    hook.Add( "OnKeysPrimary", "Keys::ObjectPickup", DoPickup );
    hook.Add( "OnKeysSecondary", "Keys::ObjectPickup", DoPickup );

    hook.Add( "GravGunOnPickedUp", "Keys::ObjectPickup", function( ply, ent ) ent.holder = ply; end );
    hook.Add( "OnPhysgunPickup", "Keys::ObjectPickup", function( ply, ent ) ent.holder = ply; end );
end