-- "gamemodes\\darkrp\\entities\\entities\\mp_basic_11lvl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()

ENT.Base = 'money_printer'
ENT.PrintName = 'Водородный Биткоин-Майнер'
ENT.Category = 'Money Printers'
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.MaxHP = 200 -- хп
ENT.PrintAmount = 1600 -- количество печати
ENT.MaxInk = 10  -- максимум чернил

if SERVER then
	ENT.SeizeReward = 500 --Награда за уничтожение
	ENT.Model = 'models/props_lab/servers.mdl'
else
	function ENT:CalculateScreenPos(pos, ang)
		ang:RotateAroundAxis(ang:Up(), 90)
		ang:RotateAroundAxis(ang:Forward(), 90)
		pos = pos + ang:Up() * 11 - ang:Forward() * 8 - ang:Right() * 75
		return pos, ang, 0.03
	end
end