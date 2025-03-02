local PLAYER = FindMetaTable( "Player" );

function PLAYER:GetMood()
    return self:GetPData( "urf_mood_"..util.CRC(game.GetIPAddress()), PLAYER_MOOD_NORMAL );
end

function PLAYER:SetMood( mood, nosave )
    net.Start( "net.rp.mood" );
        net.WriteUInt( isbool(mood) and 0 or mood, 4 );
        if not nosave then
            self:SetPData( "urf_mood_" .. util.CRC(game.GetIPAddress()), mood );
        end
    net.SendToServer();
end

hook.Add( "OnEntityCreated", "hook.rp.MoodInitialize", function( ent )
    if ent == LocalPlayer() then
        LocalPlayer():SetMood( LocalPlayer():GetMood() );
    end

    hook.Remove( "OnEntityCreated", "hook.rp.MoodInitialize" );
end );

function rp.SetMood(ply, mood)
	ply:SetMood(mood)
end