-- "gamemodes\\rp_base\\gamemode\\util\\luataunts_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--[[------------------------------------------------------------
    PLAYER:
        :IsPlayingTaunt()
        :StartTaunt( act, length )
        :EndTaunt()
------------------------------------------------------------]]--
local PLAYER = FindMetaTable( "Player" );

function PLAYER:IsPlayingTaunt()
    return self.bTauntActive or false;
end

if SERVER then
    function PLAYER:StartTaunt( act, length )
        if act == nil then
            timer.Remove( "taunt" .. ply:SteamID64() );
            self:EndTaunt();
        end

        if self.iTauntActID == act then return end

        self.bTauntActive = true;

        self.fTauntLength = length;
        self.iTauntActID  = act;

        net.Start( "GMOD_TAUNT" );
            net.WriteEntity( self );
            net.WriteBool( self.bTauntActive );
            net.WriteUInt( self.iTauntActID, 11 ); -- you can save some networking by defining a map of taunt ACTS_, but idc
        net.Broadcast();

        self:AnimRestartGesture( GESTURE_SLOT_VCD, self.iTauntActID, true );

        timer.Create( "taunt" .. self:SteamID64(), self.fTauntLength, 1, function()
            if not IsValid( self ) then return end
            self:EndTaunt();
        end );
    end


    function PLAYER:EndTaunt()
        self:AnimResetGestureSlot( GESTURE_SLOT_VCD );

        self.iTauntActID  = nil;
        self.bTauntActive = false;

        net.Start( "GMOD_TAUNT" );
            net.WriteEntity( self );
            net.WriteBool( self.bTauntActive );
        net.Broadcast();
    end
end


--[[------------------------------------------------------------
    Core:
------------------------------------------------------------]]--
if SERVER then
    util.AddNetworkString( "GMOD_TAUNT" );

    hook.Add( "PlayerStartTaunt", "GMOD_TAUNT::PlayerStartTaunt", function( ply, act, length )
        ply:StartTaunt( act, length );
    end );

    hook.Add( "PlayerShouldTaunt", "GMOD_TAUNT::PlayerShouldTaunt", function( ply, act )
        hook.Run( "PlayerStartTaunt", ply, act, ply:SequenceDuration( ply:SelectWeightedSequence(act) ) );
        return false -- disable engine taunt handling
    end );
end


if CLIENT then
    net.Receive( "GMOD_TAUNT", function()
        local ply = net.ReadEntity();
        if not IsValid(ply) then return end

        ply.bTauntActive = net.ReadBool();

        if ply.bTauntActive then
            ply.iTauntActID = net.ReadUInt( 11 );
            ply:AnimRestartGesture( GESTURE_SLOT_VCD, ply.iTauntActID, true );
        else
            ply:AnimResetGestureSlot( GESTURE_SLOT_VCD );
        end
    end );
end