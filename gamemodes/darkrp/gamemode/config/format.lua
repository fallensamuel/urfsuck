-- "gamemodes\\darkrp\\gamemode\\config\\format.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local string_comma = string.Comma

function rp.FormatMoney(n)
	return string_comma(n)..' ГРН'
end

function rp.formatNumber(n)
	return string_comma(n)
end