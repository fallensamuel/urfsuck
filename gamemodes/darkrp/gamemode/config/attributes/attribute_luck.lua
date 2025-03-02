-- "gamemodes\\darkrp\\gamemode\\config\\attributes\\attribute_luck.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
/*
local ATTRIBUTE = {};


ATTRIBUTE.ID					= "luck";

ATTRIBUTE.Name					= "Мастерство";
ATTRIBUTE.Desc					= "Вам не страшны ни аномалии, ни мутанты, ведь Вы можете стать настоящим счастливчиком. \nВлияет на шанс нанесения критического урона по врагам. По достижении 100 уровня навыка, открывается ЛЕГЕНДАРНАЯ профессия - Счастливчик.";

ATTRIBUTE.InitialAmount			= 0;
ATTRIBUTE.MaxAmount				= 100;
ATTRIBUTE.Background = "rpui/attributes/luck.png";
ATTRIBUTE.ProgressText          = "Текущий уровень удачи";

ATTRIBUTE.UpgradeMax 			= 100;
ATTRIBUTE.UpgradeConversionRate	= 5;
ATTRIBUTE.Color                 = Color(235, 198, 86);


if CLIENT then
	ATTRIBUTE.TooltipDesc = function( value )
		return  ATTRIBUTE.Desc .. "\n\n" ..
				"Прогресс: " .. value .. "/" .. ATTRIBUTE.UpgradeMax .. " (" .. (value/ATTRIBUTE.UpgradeMax)*100 .. "%" .. ")"
	end
end


if SERVER then
	ATTRIBUTE.apply = function( ... )
		local args = {...}

		local CTakeDamageInfo = args[1];
		local ply 			  = CTakeDamageInfo:GetAttacker();

		if not AttributeSystem.Players[ply:SteamID64()]							 then return end
		if not AttributeSystem.Players[ply:SteamID64()].Attributes				 then return end
		if not AttributeSystem.Players[ply:SteamID64()].Attributes[ATTRIBUTE.ID] then return end

		if AttributeSystem.Players[ply:SteamID64()].Attributes[ATTRIBUTE.ID] == 0 then return end

		local amount      = AttributeSystem.Players[ply:SteamID64()].Attributes[ATTRIBUTE.ID];
		local boostAmount = 0;

		if AttributeSystem.PlayerBoosts[ply:SteamID64()] then
			if AttributeSystem.PlayerBoosts[ply:SteamID64()][ATTRIBUTE.ID] then
				for BoostID, Boost in pairs( AttributeSystem.PlayerBoosts[ply:SteamID64()][ATTRIBUTE.ID] ) do
					boostAmount = boostAmount + Boost.Amount * Boost.Stacks;
				end
			end
		end

		if math.random() <= math.Clamp( (amount+boostAmount) / ATTRIBUTE.MaxAmount, 0, 1 ) * 0.1 then
			CTakeDamageInfo:ScaleDamage( 2 );
		end
	end

	hook.Add( "EntityTakeDamage", "hook.AttributeSystem.attribute_luck.EntityTakeDamage", function( target, dmg )
		if IsValid(dmg:GetAttacker()) and dmg:GetAttacker():IsPlayer() then
			ATTRIBUTE.apply(dmg);
		end
	end );
end


AttributeSystem.Attributes[ ATTRIBUTE.ID ] = ATTRIBUTE;*/