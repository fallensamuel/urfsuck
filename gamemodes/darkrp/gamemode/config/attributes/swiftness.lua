local ATTRIBUTE = {};


ATTRIBUTE.ID					= "swiftness";

ATTRIBUTE.Name					= "Скорость бега";
ATTRIBUTE.Desc					= "Увеличивает вашу скорость при беге.";

ATTRIBUTE.InitialAmount			= 50;
ATTRIBUTE.MaxAmount				= 300;

ATTRIBUTE.UpgradeMax 			= 200;
ATTRIBUTE.UpgradeConversionRate	= 10;

ATTRIBUTE.Color = Color(226, 50, 229)

ATTRIBUTE.TooltipDesc = function() return 'Change me' end

function ATTRIBUTE.calculate(ply)
	return ply:GetAttribute("swiftness") / ATTRIBUTE.MaxAmount
end

function ATTRIBUTE.update(ply)
	
end

function rp.GetDefaultSpeed(ply)
	return rp.cfg.RunSpeed + ATTRIBUTE.calculate(ply)
end


AttributeSystem.Attributes[ ATTRIBUTE.ID ] = ATTRIBUTE;