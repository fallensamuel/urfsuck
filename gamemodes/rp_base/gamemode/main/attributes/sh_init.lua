-- "gamemodes\\rp_base\\gamemode\\main\\attributes\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AttributeSystem = AttributeSystem or {};

AttributeSystem.Attributes   = AttributeSystem.Attributes	 or {};
AttributeSystem.Boosts	     = AttributeSystem.Boosts		 or {};
AttributeSystem.Players	     = AttributeSystem.Players		 or {};
AttributeSystem.PlayerBoosts = AttributeSystem.PlayersBoosts or {};



--[[ ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
	Networking:
---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ]]--
nw.Register( "net.SyncAttributeData" ):Write( function(ply)
	net.WriteUInt( AttributeSystem.Players[ply:SteamID64()].Points, 16 );

	local tabKeys = table.GetKeys( AttributeSystem.Attributes );

	for idx = 1, #tabKeys do
		net.WriteUInt( AttributeSystem.Players[ply:SteamID64()].Attributes[tabKeys[idx]], 16 );
	end

	for idx = 1, #tabKeys do
		local boostKeys = {};
		local boostCount = 0;

		if AttributeSystem.PlayerBoosts[ply:SteamID64()] then
			if AttributeSystem.PlayerBoosts[ply:SteamID64()][tabKeys[idx]] then
				boostCount = table.Count( AttributeSystem.PlayerBoosts[ply:SteamID64()][tabKeys[idx]] );
				boostKeys  = table.GetKeys( AttributeSystem.PlayerBoosts[ply:SteamID64()][tabKeys[idx]] );
			end
		end

		net.WriteUInt( boostCount, 8 );

		for boost_idx = 1, boostCount do
			local boost = AttributeSystem.PlayerBoosts[ply:SteamID64()][tabKeys[idx]][boostKeys[boost_idx]];
			net.WriteString( boostKeys[boost_idx] .. "," .. boost.Amount .. "," .. boost.Expires .. "," .. boost.Stacks );
		end
	end
end ):Read( function()
	AttributeSystem.Players.LocalPlayer.Points = net.ReadUInt(16);

	local tabKeys = table.GetKeys( AttributeSystem.Attributes );

	local plyAttributeData = {}
	for idx = 1, #tabKeys do
		plyAttributeData[ tabKeys[idx] ] = net.ReadUInt(16);
	end

	local plyBoostData = {}
	for idx = 1, #tabKeys do
		local boostCount = net.ReadUInt(8);

		for boost_idx = 1, boostCount do
			local boost = string.Split( net.ReadString(), "," );

			plyBoostData[ tabKeys[idx] ] = plyBoostData[ tabKeys[idx] ] or {};

			plyBoostData[ tabKeys[idx] ][ boost[1] ] = {
				Amount  = boost[2],
				Expires = boost[3],
				Stacks  = boost[4]
			}
		end
	end

	AttributeSystem.Players.LocalPlayer.Attributes = plyAttributeData;
	AttributeSystem.PlayerBoosts.LocalPlayer       = plyBoostData;
end ):SetLocalPlayer();


-- // --


function AttributeSystem.getAttributes()
	return AttributeSystem.Attributes;
end;


function AttributeSystem.getBoosts()
	return AttributeSystem.Boosts;
end;


function AttributeSystem.getAttribute( attribID )
	if not AttributeSystem.Attributes[ attribID ] then return {} end

	return AttributeSystem.Attributes[ attribID ]
end;


function AttributeSystem.getBoost( boostID )
	if not AttributeSystem.Boosts[ boostID ] then return {} end

	return AttributeSystem.Boosts[ boostID ]
end;