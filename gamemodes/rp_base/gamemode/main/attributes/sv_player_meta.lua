
function PLAYER:SetupAttributeSystem()
	print('Trying to load attributes...')
	AttributeSystem.Players[self:SteamID64()] = AttributeSystem.Players[self:SteamID64()] or {};

	local plyAttributes = {
		Points     = 0,
		Attributes = {}
	}

	AttributeSystem.Database:Query( "SELECT * FROM attributesystem WHERE steamid = ?", self:SteamID64(), function( data )
		if #data == 0 then
			local queryAttributes = {};

			table.insert( queryAttributes, self:SteamID64() );
			table.insert( queryAttributes, "points" );
			table.insert( queryAttributes, rp.cfg.InitialAttributePoints );
			plyAttributes.Points = rp.cfg.InitialAttributePoints;

			for AttributeID, Attribute in pairs( AttributeSystem.Attributes ) do
				table.insert( queryAttributes, self:SteamID64() );
				table.insert( queryAttributes, AttributeID );
				table.insert( queryAttributes, AttributeSystem.Attributes[AttributeID].InitialAmount );
				plyAttributes.Attributes[AttributeID] = AttributeSystem.Attributes[AttributeID].InitialAmount;
			end

			AttributeSystem.Database:Query(
				"INSERT INTO attributesystem (steamid, attribute_id, value) VALUES " .. string.TrimRight( string.rep("(?,?,?),",table.Count(queryAttributes)/3), "," ),
				unpack(queryAttributes)
			);
		else
			if #data < table.Count(AttributeSystem.Attributes)+1 then
				local queryAttributes    = {};
				local existingAttributes = {};

				for Key, Attribute in pairs( data ) do
					existingAttributes[Attribute.attribute_id] = true;
				end

				for AttributeID, Attribute in pairs( AttributeSystem.Attributes ) do
					if existingAttributes[AttributeID] then continue end

					table.insert( queryAttributes, self:SteamID64() );
					table.insert( queryAttributes, AttributeID );
					table.insert( queryAttributes, AttributeSystem.Attributes[AttributeID].InitialAmount );
					plyAttributes.Attributes[AttributeID] = AttributeSystem.Attributes[AttributeID].InitialAmount;
				end

				AttributeSystem.Database:Query(
					"INSERT INTO attributesystem (steamid, attribute_id, value) VALUES " .. string.TrimRight( string.rep("(?,?,?),",table.Count(queryAttributes)/3), "," ),
					unpack(queryAttributes)
				);
			end

			for Key, Attribute in pairs( data ) do
				if Attribute.attribute_id == "points" then
					plyAttributes.Points = Attribute.value;	continue
				end
				plyAttributes.Attributes[Attribute.attribute_id] = Attribute.value;
			end
		end

		AttributeSystem.Players[self:SteamID64()] = plyAttributes;
		self:SyncAttributeSystem();
	end );
end


function PLAYER:SyncAttributeSystem()
	self:SetNetVar( "net.SyncAttributeData", self );

	for AttributeID, _ in pairs( AttributeSystem.Players[self:SteamID64()].Attributes ) do
		if AttributeSystem.Attributes[AttributeID] and AttributeSystem.Attributes[AttributeID].update then
			timer.Simple( 0, function() AttributeSystem.Attributes[AttributeID].update(nil, self) end );
		end
	end
end


function PLAYER:SetAttributeSystemPoints( num )
	if not AttributeSystem.Players[self:SteamID64()] then return end

	AttributeSystem.Players[self:SteamID64()].Points = num;
	
	self:SaveAttributeSystem();
	self:SyncAttributeSystem();
end


function PLAYER:AddAttributeSystemPoints( num )
	if not AttributeSystem.Players[self:SteamID64()] then return end

	AttributeSystem.Players[self:SteamID64()].Points = AttributeSystem.Players[self:SteamID64()].Points + num;
	
	self:SaveAttributeSystem();
	self:SyncAttributeSystem();
end


function PLAYER:SetAttributeAmount( attribID, num )
	if not AttributeSystem.Players[self:SteamID64()] then return end
	if not AttributeSystem.Players[self:SteamID64()].Attributes[attribID] then return end

	AttributeSystem.Players[self:SteamID64()].Attributes[attribID] = num;
	self:SyncAttributeSystem();
end


function PLAYER:UpgradeAttribute( attribID, num, sync )
	if num <= 0 then return end

	if not AttributeSystem.Players[self:SteamID64()] then return end
	if not AttributeSystem.Players[self:SteamID64()].Attributes[attribID] then return end

	if AttributeSystem.Players[self:SteamID64()].Points-num < 0 then return end
	if AttributeSystem.Players[self:SteamID64()].Attributes[attribID] + AttributeSystem.Attributes[attribID].UpgradeConversionRate*num > AttributeSystem.Attributes[attribID].UpgradeMax then return end

	AttributeSystem.Players[self:SteamID64()].Points = AttributeSystem.Players[self:SteamID64()].Points - num;
	AttributeSystem.Players[self:SteamID64()].Attributes[attribID] = AttributeSystem.Players[self:SteamID64()].Attributes[attribID] + AttributeSystem.Attributes[attribID].UpgradeConversionRate * num;

	if sync != false then
		self:SaveAttributeSystem();
		self:SyncAttributeSystem();
	end
end


function PLAYER:SaveAttributeSystem()
	if not AttributeSystem.Players[self:SteamID64()] then return end

	AttributeSystem.Database:Query( "UPDATE attributesystem SET value = ? WHERE steamid = ? AND attribute_id = ?", AttributeSystem.Players[self:SteamID64()].Points, self:SteamID64(), "points" );	

	for AttributeID, Attribute in pairs( AttributeSystem.Players[self:SteamID64()].Attributes ) do
		AttributeSystem.Database:Query( "UPDATE attributesystem SET value = ? WHERE steamid = ? AND attribute_id = ?", Attribute, self:SteamID64(), AttributeID );	
	end
end


function PLAYER:BoostAttribute( attribID, boostID )
	if not AttributeSystem.Players[self:SteamID64()].Attributes[attribID] then return end
	if not AttributeSystem.Boosts[boostID] 								  then return end

	AttributeSystem.PlayerBoosts[self:SteamID64()]					  = AttributeSystem.PlayerBoosts[self:SteamID64()] 					  or {};
	AttributeSystem.PlayerBoosts[self:SteamID64()][attribID]		  = AttributeSystem.PlayerBoosts[self:SteamID64()][attribID] 		  or {};
	AttributeSystem.PlayerBoosts[self:SteamID64()][attribID][boostID] = AttributeSystem.PlayerBoosts[self:SteamID64()][attribID][boostID] or {};

	AttributeSystem.PlayerBoosts[self:SteamID64()][attribID][boostID].Amount  = AttributeSystem.Boosts[boostID].Amount;
	AttributeSystem.PlayerBoosts[self:SteamID64()][attribID][boostID].Expires = CurTime() + AttributeSystem.Boosts[boostID].Duration;
	AttributeSystem.PlayerBoosts[self:SteamID64()][attribID][boostID].Stacks  = AttributeSystem.PlayerBoosts[self:SteamID64()][attribID][boostID].Stacks or 0;

	if AttributeSystem.Boosts[boostID].Stackable and AttributeSystem.PlayerBoosts[self:SteamID64()][attribID][boostID].Stacks < AttributeSystem.Boosts[boostID].MaxStacks then
		AttributeSystem.PlayerBoosts[self:SteamID64()][attribID][boostID].Stacks = (AttributeSystem.PlayerBoosts[self:SteamID64()][attribID][boostID].Stacks + 1) or 1;
	else
		AttributeSystem.PlayerBoosts[self:SteamID64()][attribID][boostID].Stacks = 1;
	end

	self:SyncAttributeSystem();
end


function PLAYER:ClearAttributeBoost( attribID, boostID )
	if not AttributeSystem.PlayerBoosts[self:SteamID64()] 			 		  then return end
	if not AttributeSystem.PlayerBoosts[self:SteamID64()][attribID] 		  then return end
	if not AttributeSystem.PlayerBoosts[self:SteamID64()][attribID][boostID] then return end

	AttributeSystem.PlayerBoosts[self:SteamID64()][attribID][boostID] = nil;

	if table.Count(AttributeSystem.PlayerBoosts[self:SteamID64()][attribID]) == 0 then
		AttributeSystem.PlayerBoosts[self:SteamID64()][attribID] = nil;
	end

	if table.Count(AttributeSystem.PlayerBoosts[self:SteamID64()]) == 0 then
		AttributeSystem.PlayerBoosts[self:SteamID64()] = nil;
	end

	self:SyncAttributeSystem();
end


function PLAYER:ClearAttributeBoosts( attribID )
	if not AttributeSystem.PlayerBoosts[self:SteamID64()] 			 then return end
	if not AttributeSystem.PlayerBoosts[self:SteamID64()][attribID] then return end

	AttributeSystem.PlayerBoosts[self:SteamID64()][attribID] = nil;

	if table.Count(AttributeSystem.PlayerBoosts[self:SteamID64()]) == 0 then
		AttributeSystem.PlayerBoosts[self:SteamID64()] = nil;
	end

	self:SyncAttributeSystem();
end


function PLAYER:ClearBoosts()
	if not AttributeSystem.PlayerBoosts[self:SteamID64()] then return end

	AttributeSystem.PlayerBoosts[self:SteamID64()] = nil;

	self:SyncAttributeSystem();
end


function PLAYER:GetAttributeSystem()
	return AttributeSystem.Players[self:SteamID64()];
end


function PLAYER:GetAttributeSystemBoosts()
	return (AttributeSystem.PlayerBoosts[self:SteamID64()] or {});
end


function PLAYER:GetAttributeBoosts( attribID )
	if not AttributeSystem.PlayerBoosts[self:SteamID64()] then return {} end
	return (AttributeSystem.PlayerBoosts[self:SteamID64()][attribID] or {});
end


function PLAYER:GetAttributeSystemPoints()
	return AttributeSystem.Players[self:SteamID64()].Points;
end


function PLAYER:GetAttributes()
	return AttributeSystem.Players[self:SteamID64()].Attributes;
end


function PLAYER:GetAttributeAmount( attribID )
	if not IsValid(self) or not AttributeSystem.Players[self:SteamID64()].Attributes then return 0 end
	return (AttributeSystem.Players[self:SteamID64()].Attributes[attribID] or 0);
end


function PLAYER:GetAttributeAmountBoosted( attribID )
	if not AttributeSystem.PlayerBoosts[self:SteamID64()] 			then return 0 end;
	if not AttributeSystem.PlayerBoosts[self:SteamID64()][attribID] then return 0 end;

	local value = 0;

	for BoostID, Boost in pairs( AttributeSystem.PlayerBoosts[self:SteamID64()][attribID] ) do
		value = value + Boost.Amount * Boost.Stacks;
	end

	return value;
end


function PLAYER:GetAttributeAmountPercent( attribID )
	return (AttributeSystem.Players[self:SteamID64()].Attributes[attribID] / AttributeSystem.Attributes[attribID].UpgradeMax);
end

function PLAYER:GetAttributeAmountMultiplier( attribID )
	return (AttributeSystem.Players[self:SteamID64()].Attributes[attribID] / AttributeSystem.Attributes[attribID].UpgradeMax);
end

function PLAYER:GetAttribute( attribID )
    if not AttributeSystem.Players[self:SteamID64()].Attributes           then return {} end
    if not AttributeSystem.Players[self:SteamID64()].Attributes[attribID] then return {} end

    local attribData = {
        amount  = AttributeSystem.Players[self:SteamID64()].Attributes[attribID],
        boosted = 0 
    }

    if not AttributeSystem.PlayerBoosts[self:SteamID64()]             then return attribData end;
    if not AttributeSystem.PlayerBoosts[self:SteamID64()][attribID] then return attribData end;

    for BoostID, Boost in pairs( AttributeSystem.PlayerBoosts[self:SteamID64()][attribID] ) do
        attribData.boosted = attribData.boosted + Boost.Amount * Boost.Stacks;
    end

    return attribData;
end