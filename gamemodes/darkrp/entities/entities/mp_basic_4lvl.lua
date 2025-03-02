-- "gamemodes\\darkrp\\entities\\entities\\mp_basic_4lvl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

ENT.Base = 'money_printer'
ENT.PrintName = 'Лазерный принтер'
ENT.Category = 'Money Printers'
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.MaxHP = 80 -- хп
ENT.PrintAmount = 135 -- количество печати
ENT.MaxInk = 5  -- максимум чернил

if SERVER then
	ENT.SeizeReward = 500 --Награда за уничтожение
	ENT.Model = 'models/props_c17/consolebox05a.mdl'
else
	function ENT:CalculateScreenPos(pos, ang)
		ang:RotateAroundAxis(ang:Up(), 0)
		pos = pos + ang:Up() * 5.7 - ang:Forward() * 0.4 + ang:Right() * 6
		return pos, ang, 0.037
	end
end