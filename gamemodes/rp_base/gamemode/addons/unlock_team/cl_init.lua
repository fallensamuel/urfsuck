-- "gamemodes\\rp_base\\gamemode\\addons\\unlock_team\\cl_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function rp.UnlockTeam( iTeam )
	net.Start( "rp.UnlockTeam" );
		net.WriteInt( iTeam, 10 );
	net.SendToServer();
end

local keys = { ["unlockPrice"] = true };

hook.Add( "OnTeamValueNotify", "OnTeamValueNotify", function( key, val )
	if keys[key] then
		return rp.CalculateJobUnlockPrice( LocalPlayer(), val ) or val;
	end
end );