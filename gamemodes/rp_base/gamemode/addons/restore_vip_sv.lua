
local upgrades_loaded = {}
local rank_loaded = {}

local function checkVIP(pl)
	if (!pl:IsAdmin() && (pl:HasUpgrade('vip') or pl:HasUpgrade('VIP') or pl:HasUpgrade('vip_package')) and !pl:GetRankTable():IsVIP()) then
		ba.data.SetRank(pl, 'vip', 'vip' , 0)
	end
end

hook.Add('PlayerUpgradesLoaded', function(pl)
	if !rank_loaded[pl:SteamID()] then
		upgrades_loaded[pl:SteamID()] = true
		
	else
		upgrades_loaded[pl:SteamID()] = nil
		rank_loaded[pl:SteamID()] = nil

		checkVIP(pl)
	end
end)


hook.Add('playerRankLoaded', function(pl)
	if !upgrades_loaded[pl:SteamID()] then
		rank_loaded[pl:SteamID()] = true
		
	else
		upgrades_loaded[pl:SteamID()] = nil
		rank_loaded[pl:SteamID()] = nil

		checkVIP(pl)
	end
end)

hook.Add("PlayerAuthed", function(pl)
	upgrades_loaded[pl:SteamID()] = false
	rank_loaded[pl:SteamID()] = false
end)