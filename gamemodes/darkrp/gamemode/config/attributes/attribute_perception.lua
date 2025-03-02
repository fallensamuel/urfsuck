-- "gamemodes\\darkrp\\gamemode\\config\\attributes\\attribute_perception.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
/*local ATTRIBUTE = {};


ATTRIBUTE.ID					= "perception";

ATTRIBUTE.Name					= "Владение Оружием";
ATTRIBUTE.Desc					= "Оттачивая свой навык владения оружием вы можете стать самым опасным стрелком в Зоне. Влияет на наносимый урон по врагам:\n5 очко навыков за 1% увеличения урона. По достижении 100 уровня навыка, открывается ЛЕГЕНДАРНАЯ профессия - Тиран.";

ATTRIBUTE.InitialAmount			= 0;
ATTRIBUTE.MaxAmount				= 100;

ATTRIBUTE.UpgradeMax 			= 100;
ATTRIBUTE.UpgradeConversionRate	= 5;
ATTRIBUTE.Background = "rpui/attributes/weapons.png";
ATTRIBUTE.ProgressText          = "Текущий навык владения оружия";

ATTRIBUTE.Color 				= Color(127, 159, 255);


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
		
		CTakeDamageInfo:ScaleDamage( 1 + (amount+boostAmount) / ATTRIBUTE.UpgradeMax * 0.3 );
	end

	hook.Add( "EntityTakeDamage", "hook.AttributeSystem.attribute_perception.EntityTakeDamage", function( target, dmg )
		if IsValid(dmg:GetAttacker()) and dmg:GetAttacker():IsPlayer() then
			ATTRIBUTE.apply(dmg);
		end
	end );
end


AttributeSystem.Attributes[ ATTRIBUTE.ID ] = ATTRIBUTE;*/