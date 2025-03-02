-- "gamemodes\\darkrp\\entities\\entities\\npc_drugbuyer\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Base = "base_entity"
ENT.PrintName = "Drug Buyer"
ENT.Instructions = "Base entity"
ENT.Author = "Vend"
ENT.Spawnable = false
ENT.AdminOnly = true

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end