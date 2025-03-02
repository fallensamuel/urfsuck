-- "gamemodes\\rp_base\\entities\\entities\\npc_employer\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Base                  = "base_entity";
--ENT.Type                  = "ai";

ENT.PrintName             = "Employer";
ENT.Spawnable             = false;
ENT.Category              = "RP NPCs";

--ENT.AutomaticFrameAdvance = true;


function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "Faction" );
end

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:IsHidden(ply)
	if rp.cfg.DisableEmployersHide then return false end

	local oCLIENT = CLIENT
	CLIENT = true

	local fac = rp.Factions[self:GetFaction()]

	local jobsCount, noCustomCheck = #fac.jobsMap, 0
	for i = 1, jobsCount do
		local job = fac.jobsMap[i]
		local jtab = rp.teams[job]
		if jtab then
			if not jtab.customCheck or jtab.customCheck(ply) then
				CLIENT = oCLIENT
				return false
			end
		end
	end

	CLIENT = oCLIENT
	if jobsCount == noCustomCheck then return false end

	return true
end