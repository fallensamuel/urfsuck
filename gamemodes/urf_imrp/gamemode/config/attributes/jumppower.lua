local ATTRIBUTE = {};

ATTRIBUTE.ID					= "jumppower";

ATTRIBUTE.Name					= "Сила прыжка";
ATTRIBUTE.Desc					= "Увеличивает вашу высоту прыжка.";

ATTRIBUTE.InitialAmount			= 10;
ATTRIBUTE.MaxAmount				= 300;

ATTRIBUTE.UpgradeMax 			= 200;
ATTRIBUTE.UpgradeConversionRate	= 10;

ATTRIBUTE.Color = Color(92, 244, 65)

ATTRIBUTE.TooltipDesc = function() return 'Change me' end

if SERVER then
	ATTRIBUTE.update = function( ... )
		local args = {...}

		local ply    = args[1];

		local amount      = ply:GetAttributeAmount(ATTRIBUTE.ID);
		local boostAmount = 0;

		for BoostID, Boost in pairs( ply:GetAttributeBoosts(ATTRIBUTE.ID) ) do
			boostAmount = boostAmount + Boost.Amount * Boost.Stacks;
		end

		ply:SetJumpPower(
			baseclass.Get( player_manager.GetPlayerClass(ply) ).JumpPower +
			math.Clamp( (amount+boostAmount) / ATTRIBUTE.MaxAmount, 0, 1 ) * 250
		);
	end

	hook.Add( "PlayerSpawn", "hook.AttributeSystem.attribute_jumppower.PlayerSpawn", function( ply )
		timer.Simple( 0, function() ATTRIBUTE.update(ply) end );
	end );
end

AttributeSystem.Attributes[ ATTRIBUTE.ID ] = ATTRIBUTE;