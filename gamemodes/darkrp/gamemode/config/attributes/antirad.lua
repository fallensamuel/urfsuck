-- "gamemodes\\darkrp\\gamemode\\config\\attributes\\antirad.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local ATTRIBUTE = {};


ATTRIBUTE.ID					= "antirad";

ATTRIBUTE.Name					= "Крепкие Гены";
ATTRIBUTE.Desc					= "Вашей устойчивости к губительным эффектам аномалии позавидует даже опытный сталкер в экзоскелете! \nВлияет на получение урона от аномалий.";

ATTRIBUTE.InitialAmount			= 0;
ATTRIBUTE.MaxAmount				= 100;

ATTRIBUTE.UpgradeMax 			= 100;
ATTRIBUTE.UpgradeConversionRate	= 5;
ATTRIBUTE.ProgressText          = "Текущий прогресс";
ATTRIBUTE.Background = "rpui/attributes/anomaly.png";

ATTRIBUTE.Color = Color(44, 100, 196)

if CLIENT then
	ATTRIBUTE.TooltipDesc = function( value )
		return  ATTRIBUTE.Desc .. "\n\n" ..
				"Прогресс: " .. value .. "/" .. ATTRIBUTE.UpgradeMax .. " (" .. (value/ATTRIBUTE.UpgradeMax)*100 .. "%" .. ")"
	end
end

AttributeSystem.Attributes[ ATTRIBUTE.ID ] = ATTRIBUTE;

if SERVER then
	hook.Add("PlayerSpawn", function(ply)
		timer.Simple(0, function()
			if not ply:GetAttributeAmount('antirad') then return end
			ply:AddAnomalyResistance(ply:GetAttributeAmount('antirad') / 1000)
		end)
	end)
end