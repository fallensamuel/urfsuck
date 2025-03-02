local relations = {}

RANK_LEADER = 3
RANK_OFFICER = 2
RANK_TRAINER = 1

local repress = {}

function rp.AddRepress(teams, factions)
	factions = istable(factions) && factions || {factions}

	local targets = {}
	for k, v in pairs(rp.GetFactionTeams(factions)) do
		targets[v] = true
	end

	for k, team in pairs(istable(teams) && teams or {teams}) do
		repress[team] = targets
	end
end

function rp.CanRepress(ply, target)
	if !target then return repress[ply:Team()] end

	return !repress[target:Team()] && repress[ply:Team()] && repress[ply:Team()][target:Team()]
end

local id = 0
function rp.AddRelationships(teams, rank, factions)
	factions = istable(factions) && factions || {factions}

	local targets = {}
	for k, v in pairs(rp.GetFactionTeams(factions)) do
		targets[v] = true
	end

	for k, team in pairs(istable(teams) && teams or {teams}) do
		relations[team] = {rank = rank, factions = factions, targets = targets}
	end
end

function rp.IsHigherRank(self, target)
	return relations[self:Team()] && relations[self:Team()].targets[target:Team()] && self:GetFactionRank() > target:GetFactionRank()
end

function PLAYER:GetFactionRelations()
	return relations[self:Team()] || false
end

function PLAYER:GetFactionRank()
	return relations[self:Team()] && relations[self:Team()].rank || 0
end

local job_key, job_map, team = 1
local math_max = math.max
function rp.GetFactionPreviousRank(ply, return_default_team)
	job_map	= rp.Factions[ply:GetFaction()].jobsMap
	
	for k, v in pairs(job_map) do
		if v == ply:Team() then
			job_key = math_max(k - 1, 1)
			break
		end
	end
	
	team = job_map[job_key]
	
	while rp.teams[team].max and rp.teams[team].max < 3 and job_key > 1 do
		job_key = math_max(job_key - 1, 1)
		team = job_map[job_key]
	end
	
	if team && team != ply:Team() && rp.teams[team] then
		return team
	elseif return_default_team == nil || return_default_team == true then
		return rp.GetDefaultTeam(ply)
	end
end

function rp.GetRelationship( team )
	return relations[team] or {};
end