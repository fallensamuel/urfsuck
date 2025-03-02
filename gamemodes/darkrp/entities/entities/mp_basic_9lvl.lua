-- "gamemodes\\darkrp\\entities\\entities\\mp_basic_9lvl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

ENT.Base = 'money_printer'
ENT.PrintName = 'Улучшенный Биткоин-Майнер'
ENT.Category = 'Money Printers'
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.MaxHP = 130 -- хп
ENT.PrintAmount = 500 -- количество печати
ENT.MaxInk = 8  -- максимум чернил

if SERVER then
	ENT.SeizeReward = 500 --Награда за уничтожение
	ENT.Model = 'models/props_lab/monitor02.mdl'
else
	function ENT:CalculateScreenPos(pos, ang)
		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 82)
		pos = pos + ang:Up() * 13.1 + ang:Forward() * 2 - ang:Right() * 10
		return pos, ang, 0.02
	end
end