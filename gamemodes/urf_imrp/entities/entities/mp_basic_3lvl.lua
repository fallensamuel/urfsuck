AddCSLuaFile()

ENT.Base = 'money_printer'
ENT.PrintName = 'Генератор токенов'
ENT.Category = 'Money Printers'
ENT.Spawnable = true
ENT.AdminOnly	= true
ENT.MaxHP = 100 -- хп
ENT.PrintAmount = 20 -- количество печати
ENT.MaxInk = 50  -- максимум чернил

if SERVER then
	ENT.SeizeReward = 100 --Награда за уничтожение
	ENT.Model = 'models/props_c17/consolebox03a.mdl'
else
	function ENT:CalculateScreenPos(pos, ang)
		ang:RotateAroundAxis(ang:Up(), 90)
		pos = pos + ang:Up() * 8 + ang:Forward() * 3.3 + ang:Right() * 4
		return pos, ang, 0.029
	end
end