local ATTRIBUTE = {};


ATTRIBUTE.ID					= "fallresist";

ATTRIBUTE.Name					= "Устойчивость к падениям с большой высоты";
ATTRIBUTE.Desc					= "Помогает вам легче справиться с падениями с больших высот.";

ATTRIBUTE.InitialAmount			= 0;
ATTRIBUTE.MaxAmount				= 300;

ATTRIBUTE.UpgradeMax 			= 200;
ATTRIBUTE.UpgradeConversionRate	= 10;

ATTRIBUTE.Color = Color(244, 200, 66)

ATTRIBUTE.TooltipDesc = function() return 'Change me' end

if SERVER then
	hook.Add( "GetFallDamage", "hook.AttributeSystem.attribute_fallresist.GetFallDamage", function( ply, speed )
		local damage = ( speed / 8 );

		if not AttributeSystem.Players[ply:SteamID64()]							 then return end
		if not AttributeSystem.Players[ply:SteamID64()].Attributes				 then return end
		if not AttributeSystem.Players[ply:SteamID64()].Attributes[ATTRIBUTE.ID] then return end

		local amount      = AttributeSystem.Players[ply:SteamID64()].Attributes[ATTRIBUTE.ID];
		local boostAmount = 0;

		if AttributeSystem.PlayerBoosts[ply:SteamID64()] then
			if AttributeSystem.PlayerBoosts[ply:SteamID64()][ATTRIBUTE.ID] then
				for BoostID, Boost in pairs( AttributeSystem.PlayerBoosts[ply:SteamID64()][ATTRIBUTE.ID] ) do
					boostAmount = boostAmount + Boost.Amount * Boost.Stacks;
				end
			end
		end

		return speed / (8 * math.Clamp( (amount+boostAmount) / ATTRIBUTE.MaxAmount, 0, 1 ) * 3)
	end );
end


AttributeSystem.Attributes[ ATTRIBUTE.ID ] = ATTRIBUTE;