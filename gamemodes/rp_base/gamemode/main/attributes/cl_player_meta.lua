-- "gamemodes\\rp_base\\gamemode\\main\\attributes\\cl_player_meta.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PLAYER = FindMetaTable( "Player" );


function PLAYER:GetAttributeSystem()
	if self ~= LocalPlayer() then return end
	return AttributeSystem.Players.LocalPlayer;
end


function PLAYER:GetAttributeSystemBoosts()
	if self ~= LocalPlayer() then return end
	return (AttributeSystem.PlayerBoosts.LocalPlayer or {});
end


function PLAYER:GetAttributeBoosts( attribID )
	if not AttributeSystem.PlayerBoosts.LocalPlayer then return {} end
	return (AttributeSystem.PlayerBoosts.LocalPlayer[attribID] or {});
end


function PLAYER:GetAttributeSystemPoints()
	if self ~= LocalPlayer() then return end
	return AttributeSystem.Players.LocalPlayer.Points;
end


function PLAYER:GetAttributes()
	if self ~= LocalPlayer() then return end
	return AttributeSystem.Players.LocalPlayer.Attributes;
end


function PLAYER:GetAttributeAmount( attribID )
	if self ~= LocalPlayer() then return end
	if (!AttributeSystem.Players.LocalPlayer.Attributes) then return 0 end
	return AttributeSystem.Players.LocalPlayer.Attributes[attribID] or 0;
end


function PLAYER:GetAttributeAmountBoosted( attribID )
	if self ~= LocalPlayer() then return end
	
	if not AttributeSystem.PlayerBoosts.LocalPlayer 		  then return 0 end;
	if not AttributeSystem.PlayerBoosts.LocalPlayer[attribID] then return 0 end;

	local value = 0;

	for BoostID, Boost in pairs( AttributeSystem.PlayerBoosts.LocalPlayer[attribID] ) do
		value = value + Boost.Amount * Boost.Stacks;
	end

	return value;
end


function PLAYER:GetAttributeAmountPercent( attribID )
	if self ~= LocalPlayer() then return 0 end
	return (AttributeSystem.Players.LocalPlayer.Attributes[attribID] / AttributeSystem.Attributes[attribID].UpgradeMax);
end

function PLAYER:GetAttributeAmountMultiplier( attribID )
	if self ~= LocalPlayer() then return 0 end
	return (AttributeSystem.Players.LocalPlayer.Attributes[attribID] / AttributeSystem.Attributes[attribID].UpgradeMax);
end


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