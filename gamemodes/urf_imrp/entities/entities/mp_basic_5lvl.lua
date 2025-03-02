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
	ENT.SeizeReward = 150 --Награда за уничтожение
	ENT.Model = 'models/props_c17/consolebox01a.mdl'
else
	function ENT:CalculateScreenPos(pos, ang)
		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 90)
		pos = pos + ang:Up() * 16.15
		return pos, ang, 0.03
	end
end