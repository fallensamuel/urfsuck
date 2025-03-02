AddCSLuaFile()

ENT.Base = 'money_printer'
ENT.PrintName = 'Money Printer Level 1'
ENT.Category = 'Money Printers'
ENT.Spawnable = true
ENT.AdminOnly	= true
ENT.MaxHP = 100 -- хп
ENT.PrintAmount = 500 -- количество печати
ENT.MaxInk = 5  -- максимум чернил

if SERVER then
	ENT.SeizeReward = 500 --Награда за уничтожение
	ENT.Model = 'models/props_c17/consolebox01a.mdl'
else
	function ENT:CalculateScreenPos(pos, ang)
		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 90)
		pos = pos + ang:Up() * 16.15
		return pos, ang, 0.03
	end
end