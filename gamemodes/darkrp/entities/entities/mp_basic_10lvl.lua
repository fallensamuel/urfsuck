-- "gamemodes\\darkrp\\entities\\entities\\mp_basic_10lvl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

ENT.Base = 'money_printer'
ENT.PrintName = 'Лазерный Биткоин-Майнер'
ENT.Category = 'Money Printers'
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.MaxHP = 140 -- хп
ENT.PrintAmount = 1000 -- количество печати
ENT.MaxInk = 9  -- максимум чернил

if SERVER then
	ENT.SeizeReward = 500 --Награда за уничтожение
	ENT.Model = 'models/props_c17/FurnitureWashingmachine001a.mdl'
else
	function ENT:CalculateScreenPos(pos, ang)
		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 0)
		pos = pos + ang:Up() * 15.9 + ang:Forward() * 4 + ang:Right() * 10
		return pos, ang, 0.035
	end
end