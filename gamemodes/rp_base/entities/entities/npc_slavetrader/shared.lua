-- "gamemodes\\rp_base\\entities\\entities\\npc_slavetrader\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Base                  = "base_entity";
ENT.PrintName             = "Тюремщик";
ENT.Spawnable             = false;
ENT.Category              = "RP NPCs";

ENT.IsJailAdvisor         = true;

function ENT:SetupDataTables()
    self:NetworkVar( "Int", 0, "PoliceFaction" );
end

function ENT:SetAutomaticFrameAdvance( bUsingAnim )
	self.AutomaticFrameAdvance = bUsingAnim
end

function ENT:CheckMaster(ply)
	local my_faction = self:GetPoliceFaction()
	local ply_faction = rp.police.GetFaction(ply:GetFaction() or -1)
	
	local self_data = rp.police.Factions[self:GetPoliceFaction() or -1].supervisors[game.GetMap()]
	
	if self_data.custom_master_factions and (not ply:GetFaction() or not self_data.custom_master_factions[ply:GetFaction()]) then
		return false
		
	elseif not self_data.custom_master_factions then
		if not ply_faction or ply_faction.ID ~= my_faction then
			return false
		end
	end
	
	return true
end

function ENT:CheckSlave(ply)
	local faction_data = rp.police.Factions[self:GetPoliceFaction() or -1]
	
	if not faction_data then
		return false
	end
	
	local self_data = faction_data.supervisors[game.GetMap()]
	
	if self_data.custom_slave_factions and not self_data.custom_slave_factions[ply:GetFaction()] then
		return false
		
	elseif not self_data.custom_slave_factions then
		if not ply:GetFaction() or not faction_data.can_want[ply:GetFaction()] then
			return false
		end
	end
	
	if self_data.need_wanted_stars and not ply:IsWanted(SERVER and faction_data.Factions[1]) then
		return false
	end
	
	return true
end

function ENT:GetSlavePrice(ply)
	local faction_data = rp.police.Factions[self:GetPoliceFaction()]
	local self_data = faction_data.supervisors[game.GetMap()]
	
	local stars_reward = self_data.rewards and self_data.rewards[ply:GetWantedStars(faction_data.Factions[1])] or 0
	local bonus = ply:GetJobTable() and ply:GetJobTable().slavePrice or ply:GetFactionTable() and ply:GetFactionTable().slavePrice or 0
	
	return stars_reward + bonus
end
