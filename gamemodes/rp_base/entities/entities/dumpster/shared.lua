ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Dumpster"
ENT.Spawnable = true
ENT.Category = "RP"

ENT.AdminOnly = true

function ENT:SetupDataTables()
	self:DTVar("Int", 0, "CooldownTime")
end