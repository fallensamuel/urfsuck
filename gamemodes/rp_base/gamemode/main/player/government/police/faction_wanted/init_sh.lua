-- "gamemodes\\rp_base\\gamemode\\main\\player\\government\\police\\faction_wanted\\init_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

if not rp.cfg.NewWanted then return end

-- LIB --
rp.police = {
	Factions = {},
	FactionsMap = {},
}

rp.police.SetupFaction = function(name, factions_to_check, data)
	local factions = {}
	
	for k, v in pairs(istable(factions_to_check) and factions_to_check or {factions_to_check}) do
		if v then
			table.insert(factions, v)
		end
	end
	
	if #factions == 0 then
		print('[POLICE] ERROR! No valid factions for ' .. name)
		return -1
	end
	
	data.Factions = factions
	data.Name = name
	data.ID = table.insert(rp.police.Factions, data)
	
	for k, v in pairs(factions) do
		rp.police.FactionsMap[v] = data
	end
	
	return data.ID
end

rp.police.GetFaction = function(faction)
	return rp.police.FactionsMap[faction] or false
end


-- META --
function PLAYER:IsCP()
	return IsValid(self) and (self:GetJobTable() and self:GetJobTable().police or self.IsCombine and self:IsCombine()) or false
end

function PLAYER:CanPoliceFaction(faction)
	return self:IsCP() and rp.police.GetFaction(self:GetFaction()) and rp.police.GetFaction(self:GetFaction()).can_want[faction] or false
end

if CLIENT then
	local lp, mf
	
	function PLAYER:IsWanted(faction)
		lp = LocalPlayer()
		
		if not IsValid(self) or not IsValid(lp) then return false end
		
		mf = rp.police.GetFaction(faction or lp:GetFaction())
		
		if not mf or not self:GetFaction() then return false end
		
		return self:GetNetVar('FactionWanted') and self:GetNetVar('FactionWanted')[mf.ID] or false
	end
	
	function PLAYER:GetWantedStars(faction)
		lp = LocalPlayer()
		
		if not IsValid(self) or not IsValid(lp) then return 0 end
		
		mf = rp.police.GetFaction(faction or lp:GetFaction())
		
		return mf and self:GetNetVar('WantedStars') and self:GetNetVar('WantedStars')[mf.ID] or 0
	end
else
	local mf
	
	function PLAYER:IsWanted(faction)
		if not IsValid(self) or not faction then return false end
		
		mf = rp.police.GetFaction(faction)
		
		return mf and self:GetNetVar('FactionWanted') and self:GetNetVar('FactionWanted')[mf.ID] or false
	end
	
	function PLAYER:GetWantedStars(faction)
		if not IsValid(self) or not faction then return 0 end
		
		mf = rp.police.GetFaction(faction)
		
		return mf and self:GetNetVar('WantedStars') and self:GetNetVar('WantedStars')[mf.ID] or 0
	end
end

function PLAYER:GetWantedReason(faction)
	return self:IsWanted(faction)
end


-- VARS --
nw.Register'FactionWanted':Write(function(v)
	net.WriteUInt(table.Count(v), 8)

	for fact, reason in pairs(v) do
		net.WriteUInt(fact, 8)
		net.WriteString(reason)
	end
end):Read(function()
	local ret = {}

	for i = 1, net.ReadUInt(8) do
		ret[net.ReadUInt(8)] = net.ReadString()
	end

	return ret
end):SetPlayer()

nw.Register'WantedStars':Write(function(v)
	net.WriteUInt(table.Count(v), 8)

	for fact, stars in pairs(v) do
		net.WriteUInt(fact, 8)
		net.WriteUInt(stars, 3)
	end
end):Read(function()
	local ret = {}

	for i = 1, net.ReadUInt(8) do
		ret[net.ReadUInt(8)] = net.ReadUInt(3)
	end

	return ret
end):SetPlayer()