-- "gamemodes\\rp_base\\entities\\entities\\drug_lab\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = 'anim'
ENT.Base = 'base_anim'
ENT.PrintName = 'Мини лаборатория'
ENT.Author = 'aStonedPenguin'
ENT.Spawnable = true
ENT.Category = 'RP'
local math_clamp = math.Clamp
local math_round = math.Round
local CurTime = CurTime

ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar('Int', 0, 'CraftTime')
	self:NetworkVar('Int', 1, 'CraftRate')
end

function ENT:GetPerc()
	local p = self:GetCraftTime() or CurTime()
	local r = self:GetCraftRate() or 60

	return math_clamp(1 - (p - CurTime()) / r, 0, 1)
end