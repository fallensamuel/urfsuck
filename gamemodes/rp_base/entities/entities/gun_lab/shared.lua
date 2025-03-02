-- "gamemodes\\rp_base\\entities\\entities\\gun_lab\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Gun Lab"
ENT.Author = "Pcwizdan"
ENT.Spawnable = false
ENT.AdminSpawnable = false


function ENT:SetupDataTables()
	self:NetworkVar("Int", 0, "price")
	self:NetworkVar('String', 0, 'Content')
	self:NetworkVar("Entity", 1, "owning_ent")
end