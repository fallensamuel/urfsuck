-- "gamemodes\\rp_base\\entities\\entities\\urf_signal\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName= "Сигнализация"
ENT.Contact= ""
ENT.Purpose= "None"
ENT.Instructions= "[E] to disable"
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.Category 	= "RP"

ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 6, "Owner")
end
