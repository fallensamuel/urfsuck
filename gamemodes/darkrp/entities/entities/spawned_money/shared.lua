-- "gamemodes\\darkrp\\entities\\entities\\spawned_money\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Spawned Money"
ENT.Author = "FPtje"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"amount")
end

local ENTITY = FindMetaTable("Entity")
function ENTITY:IsMoneyBag()
	return self:GetClass() == "spawned_money"
end