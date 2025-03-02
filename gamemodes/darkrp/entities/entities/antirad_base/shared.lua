-- "gamemodes\\darkrp\\entities\\entities\\antirad_base\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName 	= "antirad_base"
ENT.Category	= "StalkerRP"

ENT.Purpose		 = ""
ENT.Instructions = ""

ENT.Author 		= "Beelzebub"
ENT.Contact 	= "beelzebub@incredible-gmod.ru"

ENT.Spawnable 		= false
ENT.AdminSpawnable 	= false

ENT.AntiradMdl 	= "models/hunter/blocks/cube05x05x05.mdl"
ENT.AntiRadCount = 20

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "owning_ent")
end