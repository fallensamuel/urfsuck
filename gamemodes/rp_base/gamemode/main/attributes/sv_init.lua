AttributeSystem.Database = rp._Stats

util.AddNetworkString( "net.AttributeSystem.UpgradeAttributes" );


hook.Add( "PlayerInitialSpawn", "hook.AttributeSystem.PlayerInitialSpawn", function( ply ) 
	ply:SetupAttributeSystem();
end );


hook.Add( "PlayerDisconnected", "hook.AttributeSystem.PlayerDisconnected", function( ply )
	ply:SaveAttributeSystem();

	if AttributeSystem.Players[ply:SteamID64()]	  then AttributeSystem.Players[ply:SteamID64()] 	  = nil; end
	if AttributeSystem.PlayerBoosts[ply:SteamID64()] then AttributeSystem.PlayerBoosts[ply:SteamID64()] = nil; end		
end );


timer.Create( "timer.AttributeSystem.BoostCheck", 5, 0, function()
	for SteamID, PlayerBoostData in pairs( AttributeSystem.PlayerBoosts ) do
		local ply = player.GetBySteamID64( SteamID );

		if not IsValid(ply) then
			AttributeSystem.PlayerBoosts[SteamID] = nil;
			continue
		end

		for AttributeID, AttributeBoosts in pairs( PlayerBoostData ) do
			for BoostID, Boost in pairs( AttributeBoosts ) do
				if CurTime() > Boost.Expires then
					if Boost.Stacks <= 1 then
						ply:ClearAttributeBoost( AttributeID, BoostID );
					else
						Boost.Stacks  = Boost.Stacks - 1;
						Boost.Expires = CurTime() + AttributeSystem.Boosts[BoostID].Duration;
					end
					ply:SyncAttributeSystem();
				end 
			end
		end
	end
end );


-- // --

--[[ meta/cl_player_meta.lua
function PLAYER:RequestUpgradeAttributes( upgradeData )
	if self ~= LocalPlayer() then return end

	local attribKeys = table.GetKeys( AttributeSystem.getAttributes() );

	net.Start( "net.AttributeSystem.UpgradeAttributes" );
		net.WriteUInt( table.Count(upgradeData), 4 );

		for AttributeID, PointsAmount in pairs( upgradeData ) do
			net.WriteUInt( table.KeyFromValue(attribKeys,AttributeID), 4 );
			net.WriteUInt( math.max(0,PointsAmount), 8 );
		end
	net.SendToServer();
end
]]--

net.Receive( "net.AttributeSystem.UpgradeAttributes", function( len, ply )
	
	local tabKeys = table.GetKeys( AttributeSystem.getAttributes() );
	local c       = net.ReadUInt(4);

	for idx = 1, c do
		local AttributeID  = tabKeys[net.ReadUInt(4)];
		local PointsAmount = net.ReadUInt(8);

		ply:UpgradeAttribute( AttributeID, PointsAmount, false );
	end

	ply:SaveAttributeSystem();
	ply:SyncAttributeSystem();
end );