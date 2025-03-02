-- "gamemodes\\rp_base\\gamemode\\addons\\unlock_team\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function PLAYER:TeamUnlocked(t)
	return IsValid(self) and istable(t) and (self:IsVIP() or not t.unlockPrice or t.command and self:GetNetVar('JobUnlocks') and self:GetNetVar('JobUnlocks')[t.command])
end

hook.Add( "ConfigLoaded", "rp.teams::RebuildTable", function()
	if SERVER then return end

	for k, data in ipairs( rp.teams ) do
		if not data.unlockPrice then continue end

		local t = {};

		setmetatable( t, {
			__index = function( this, key )
				local val = data[key];
				return hook.Run("OnTeamValueNotify", key, val) or val;
			end
		} );

		rp.teams[k] = t;
	end
end );

function rp.CalculateJobUnlockPrice( ply, price )
	price = hook.Run( "CalculateJobUnlockPrice", ply, price ) or price;
	return price;
end