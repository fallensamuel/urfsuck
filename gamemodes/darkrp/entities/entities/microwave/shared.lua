-- "gamemodes\\darkrp\\entities\\entities\\microwave\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Microwave"
ENT.Author = "Pcwizdan"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "price")
	self:NetworkVar("Entity", 1, "owning_ent")
end