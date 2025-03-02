AddCSLuaFile()

ENT.Base = 'money_printer'
ENT.PrintName = 'Генератор токенов Альянса'
ENT.Category = 'Money Printers'
ENT.Spawnable = true
ENT.AdminOnly	= true
ENT.MaxHP = 300 -- хп
ENT.PrintAmount = 50 -- количество печати
ENT.MaxInk = 100  -- максимум чернил

if SERVER then
	ENT.SeizeReward = 400 --Награда за уничтожение
	ENT.Model = 'models/props_combine/breenconsole.mdl'
else
	function ENT:CalculateScreenPos(pos, ang)
		ang:RotateAroundAxis(ang:Up(), 360)
		ang:RotateAroundAxis(ang:Forward(), 90)
		pos = pos + ang:Up() * -6 + ang:Forward() * 0 - ang:Right() * 48,6
		return pos, ang, 0.03
	end
end