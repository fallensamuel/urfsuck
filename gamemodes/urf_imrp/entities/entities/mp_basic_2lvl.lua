AddCSLuaFile()

ENT.Base = 'money_printer'
ENT.PrintName = 'Принтер'
ENT.Category = 'Money Printers'
ENT.Spawnable = true
ENT.AdminOnly	= true
ENT.MaxHP = 60 -- хп
ENT.PrintAmount = 100 -- количество печати
ENT.MaxInk = 5  -- максимум чернил

if SERVER then
	ENT.SeizeReward = 500 --Награда за уничтожение
	ENT.Model = 'models/props_lab/reciever01b.mdl'
else
	function ENT:CalculateScreenPos(pos, ang)
		ang:RotateAroundAxis(ang:Up(), 90)
		pos = pos + ang:Up() * 3.4 + ang:Forward() * 2.6 + ang:Right() * 4
		return pos, ang, 0.023
	end
end