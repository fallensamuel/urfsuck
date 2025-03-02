-- "gamemodes\\rp_base\\gamemode\\addons\\mood\\cl_mood.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PLAYER = FindMetaTable( "Player" );

function PLAYER:GetMood()
    local ck = self:GetPData( "urf_mood_"..util.CRC(game.GetIPAddress()) );
    if ck then return ck end

    local keys = table.GetKeys( rp.Mood.HoldTypes or {} );
    return keys[math.random(#keys)];
end

function PLAYER:SetMood( mood, nosave )
    net.Start( "net.rp.mood" );
        net.WriteUInt( isbool(mood) and 0 or (tonumber(mood) or 0), 4 );
        if not nosave then
            self:SetPData( "urf_mood_" .. util.CRC(game.GetIPAddress()), mood );
        end
    net.SendToServer();
end

hook.Add( "InitPostEntity", "hook.rp.MoodInitialize", function( ent )
    LocalPlayer():SetMood( LocalPlayer():GetMood() );
    hook.Remove( "InitPostEntity", "hook.rp.MoodInitialize" );
end );

function rp.SetMood( ply, mood )
	ply:SetMood( mood );
end