-- "gamemodes\\darkrp\\entities\\entities\\mp_basic_7lvl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

ENT.Base = 'money_printer'
ENT.PrintName = 'Самопальный Биткоин-Майнер'
ENT.Category = 'Money Printers'
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.MaxHP = 110 -- хп
ENT.PrintAmount = 230 -- количество печати
ENT.MaxInk = 7  -- максимум чернил

if SERVER then
	ENT.SeizeReward = 500 --Награда за уничтожение
	ENT.Model = 'models/props_lab/harddrive01.mdl'
else
	function ENT:CalculateScreenPos(pos, ang)
		ang:RotateAroundAxis(ang:Up(), 180)
		ang:RotateAroundAxis(ang:Forward(), 90)
		pos = pos + ang:Up() * 3.8 + ang:Forward() * 3.5 + ang:Right() * 10
		return pos, ang, 0.025
	end
end