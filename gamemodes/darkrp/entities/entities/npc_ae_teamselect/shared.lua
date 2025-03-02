-- "gamemodes\\darkrp\\entities\\entities\\npc_ae_teamselect\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Base                  = "base_entity"

ENT.PrintName             = "Autoevent - Teams"
ENT.Spawnable             = false
ENT.Category              = "RP NPCs"
ENT.IsAutoeventTeamNPC    = true

function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "AutoeventName")
    self:NetworkVar("Int", 0, "AutoeventID")
end

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end
