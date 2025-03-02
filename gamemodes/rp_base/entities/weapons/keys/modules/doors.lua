-- "gamemodes\\rp_base\\entities\\weapons\\keys\\modules\\doors.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile();

-- Config: -----------------------------------------------------
local Keys = {
    Sounds = {
        "npc/metropolice/gear1.wav",
        "npc/metropolice/gear2.wav",
        "npc/metropolice/gear3.wav",
        "npc/metropolice/gear4.wav",
        "npc/metropolice/gear5.wav",
        "npc/metropolice/gear6.wav"
    }
};

local Knock = {
    Delay = 5,
    Sounds = {
        "physics/wood/wood_crate_impact_hard2.wav"
    }
};

local Bell = {
    Delay = 10,
    Sounds = {
        "ambient/alarms/warningbell1.wav"
    }
};

-- Core: -------------------------------------------------------
local function TryDoor( wep, target, secondary )
    if IsValid( target ) and target:IsDoor() then
        local CT = CurTime();
        local owner = wep:GetOwner();

        local isDoorOwner = target:DoorOwnedBy( owner ) or target:DoorCoOwnedBy( owner );
        if not isDoorOwner then
            if math.max(target.NextKnock or 0, target.NextBell or 0) <= CT then
                wep:SendAnimToClient( ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST );
            end

            if IsValid(target:DoorGetOwner()) and ((target.NextBell or 0) <= CT) then
                rp.Notify( target:DoorGetOwner(), NOTIFY_GENERIC, rp.Term("PlayerRangDoorbell") );
                owner:EmitSound( Bell.Sounds[math.random(#Bell.Sounds)], 100, 110 );
                target.NextBell = CT + Bell.Delay;
            elseif (target.NextKnock or 0) <= CT then
                owner:EmitSound( Knock.Sounds[math.random(#Knock.Sounds)], 100, math.random(90, 110) );
                target.NextKnock = CT + Knock.Delay;
            end

            return
        end

        if (target.PickedAt or 0 + 2) > CT then
            rp.Notify( owner, NOTIFY_GENERIC, rp.Term("KeysCooldown") );
            return
        end

        if target.lock then
            return 
        end

        local lock = not secondary;

        wep:SendAnimToClient( ACT_GMOD_GESTURE_ITEM_PLACE );
        owner:EmitSound( Keys.Sounds[math.random(#Keys.Sounds)] );
        target:DoorLock( lock );

        rp.Notify( owner, NOTIFY_GENERIC, rp.Term(lock and "DoorLocked" or "DoorUnlocked") );

        return
    end
end

if SERVER then
    hook.Add( "OnKeysPrimary", "Keys::Doors", TryDoor );
    hook.Add( "OnKeysSecondary", "Keys::Doors", TryDoor );
end