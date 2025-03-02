
util.AddNetworkString('Social::GetInfo')
util.AddNetworkString('Social::Promocode')
util.AddNetworkString('Social::Steam')

local socials_cooldown = {}
local socials_got = {}

local SOCIAL_HOURS = 1
local SOCIAL_RANK = 2

local discord_rank_data = {
	[SOCIAL_HOURS] = {
		get_status = function(ply, force)
			local intervals = { 10, 100, 500, 1000 }
			local val = force or ply:GetPlayTime()
			
			for k = 1, #intervals do
				if val < intervals[k] then
					return k
				end
			end
			
			return #intervals + 1
		end,
		get_value = function(ply)
			return ply:GetPlayTime()
		end,
	},
	[SOCIAL_RANK] = {
		get_status = function(ply, force)
			--[[
			local ranks = {
				['user'] = 1,
				['vip'] = 2,
				
				['moderator'] = 3,
				['admin'] = 3,
				['headadmin'] = 3,
				['superadmin'] = 3,
				['globaladmin'] = 3,
				
				['vip+'] = 4,
				['adminplus'] = 4,
				['globalcontributor'] = 4,
				['goldencontributor'] = 4,
				['platinumcontributor'] = 4,
				
				['moderator*'] = 5,
				['admin*'] = 5,
				['headadmin*'] = 5,
				['superadmin*'] = 5,
				['globaladmin*'] = 5,
				['helper'] = 5,
				
				['deputy'] = 6,
				
				['manager'] = 7,
				['manager-plus'] = 7,
				
				['developer'] = 8,
				
				['root'] = 9,
			}
			
			return ranks[force and ba.ranks.Get(force).Name or ply:GetRank() or 'user'] or 1
			]]
			
			return force and ba.ranks.Get(force).ID or ply:GetRankTable().ID or 1
		end,
		get_value = function(ply)
			return ply:GetRankTable().ID
		end,
	},
}

hook.Add('InitPostEntity', 'Social::Initialize', function()
	rp._Stats:Query("CREATE TABLE IF NOT EXISTS `social_info` (`social_id` varchar(32) NOT NULL,`value` varchar(64) NOT NULL,`steamid` bigint(20) DEFAULT NULL,`promo` varchar(16) DEFAULT NULL,PRIMARY KEY (`social_id`,`value`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;")
	--rp._Stats:Query("CREATE TABLE IF NOT EXISTS `social_discord_update` (`discord_id` varchar(32) NOT NULL,`steamid` bigint(20) NOT NULL,`mode` int(8) NOT NULL,`value` int(32) NOT NULL,PRIMARY KEY (`discord_id`,`mode`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;")
	rp._Stats:Query("CREATE TABLE IF NOT EXISTS `social_discord_current` (`discord_id` varchar(32) NOT NULL,`steamid` bigint(20) NOT NULL,`mode` int(8) NOT NULL,`value` int(32) NOT NULL,PRIMARY KEY (`discord_id`,`mode`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;")
end)

local function send_socials(ply)
	if not IsValid(ply) then return end
	local data = socials_got[ply:SteamID64()]
	
	socials_cooldown[ply:SteamID64()] = CurTime() + 0.5
	
	net.Start('Social::GetInfo')
		net.WriteUInt(table.Count(data or {}), 6)
		for v, _ in pairs(data or {}) do
			net.WriteString(v)
		end
	net.Send(ply)
end

local function add_to_discord_update(ply, mode)
	local value = discord_rank_data[mode].get_value(ply)
	ply.SocialDiscordData[mode] = discord_rank_data[mode].get_status(ply)
	
	--print('Updated social data:', ply, mode)
	--rp._Stats:Query("REPLACE INTO `social_discord_update` VALUES(?, ?, ?, ?);", ply.DiscordID, ply:SteamID64(), mode, value)
	
	rp.syncHours.db:Query("REPLACE INTO `social_discord_update` VALUES(?, ?, ?);", ply.DiscordID, ply:SteamID64(), mode, function()
		rp._Stats:Query("REPLACE INTO `social_discord_current` VALUES(?, ?, ?, ?);", ply.DiscordID, ply:SteamID64(), mode, value)
	end)
end

local function check_discord_data(ply)
	for k, gt in pairs(discord_rank_data) do
		if not ply.SocialDiscordData[k] or ply.SocialDiscordData[k] ~= gt.get_status(ply) then
			add_to_discord_update(ply, k)
		end
	end
end

local function get_info(ply)
	if socials_got[ply:SteamID64()] then
		return send_socials(ply)
	end
	
	rp.syncHours.db:Query("SELECT * FROM `social_promo_used` WHERE `steamid` = ?;", ply:SteamID64(), function(data_sync)
		if not IsValid(ply) then return end
		socials_got[ply:SteamID64()] = {}
		
		for _, v in pairs(data_sync) do
			socials_got[ply:SteamID64()][v.social_id] = true
		end
		
		rp._Stats:Query('SELECT * FROM `social_info` WHERE `steamid` = ?;', ply:SteamID64(), function(data)
			for _, v in pairs(data or {}) do
				socials_got[ply:SteamID64()][v.social_id] = true
				
				if v.social_id == 'discord' then
					ply.DiscordID = v.value
					
					rp._Stats:Query("SELECT * FROM `social_discord_current` WHERE `steamid` = ?;", ply:SteamID64(), function(data)
						if not IsValid(ply) then return end
						
						ply.SocialDiscordData = {}
						
						for k, v in pairs(data or {}) do
							ply.SocialDiscordData[v.mode] = discord_rank_data[v.mode].get_status(nil, v.value)
						end
						
						hook.Run('Social::DiscordDataLoaded', ply)
					end)
				end
			end
			
			send_socials(ply)
		end)
	end)
end

hook.Add('playerRankLoaded', 'Social::SendData', function(ply)
	timer.Simple(5, function()
		get_info(ply)
	end)
end)

hook.Add('Social::CanUsePromo', 'Social::CheckPromocode', function(ply, social_id, promo)
	if not promo or string.len(promo) < 2 then return false end
	promo = utf8.sub(promo, 1, 16)
	
	if socials_got[ply:SteamID64()] and socials_got[ply:SteamID64()][social_id] then
		return false
	end
	
	return true
end)

net.Receive('Social::GetInfo', function(_, ply)
	if socials_cooldown[ply:SteamID64()] and socials_cooldown[ply:SteamID64()] > CurTime() then return end
	get_info(ply)
end)

net.Receive('Social::Promocode', function(_, ply)
	if socials_cooldown[ply:SteamID64()] and socials_cooldown[ply:SteamID64()] > CurTime() then return end
	socials_cooldown[ply:SteamID64()] = CurTime() + 0.5
	
	local social_id = net.ReadString()
	local promo = net.ReadString()
	
	if not promo or string.len(promo) < 2 then return end
	promo = utf8.sub(promo, 1, 16)
	
	if socials_got[ply:SteamID64()] and socials_got[ply:SteamID64()][social_id] then
		return rp.Notify(ply, NOTIFY_ERROR, rp.Term('YouAlreadyUsedPromocode'))
	end
	
	rp.syncHours.db:Query("SELECT * FROM `social_promo_used` WHERE `steamid` = ? AND `social_id` = ?;", ply:SteamID64(), social_id, function(dt)
		if dt and dt[1] then 
			return rp.Notify(ply, NOTIFY_ERROR, rp.Term('YouAlreadyUsedPromocode'))
		end
		
		rp._Stats:Query('SELECT * FROM `social_info` WHERE `promo` = ? AND `social_id` = ?;', promo, social_id, function(data)
			if not IsValid(ply) then return end
			
			if data and data[1] then
				if data[1].steamid then
					if ply:SteamID64() == data[1].steamid then
						socials_got[ply:SteamID64()] = socials_got[ply:SteamID64()] or {}
						socials_got[ply:SteamID64()][social_id] = true
					end
					
					return rp.Notify(ply, NOTIFY_ERROR, rp.Term('YouAlreadyUsedPromocode'))
				end
				
				rp.cfg.Social[social_id].bonus_func(ply)
				rp.Notify(ply, NOTIFY_GREEN, rp.Term('PromocodeActivated'), promo, isfunction(rp.cfg.Social[social_id].bonus_text) and rp.cfg.Social[social_id].bonus_text(ply) or rp.cfg.Social[social_id].bonus_text)
				
				rp._Stats:Query('UPDATE `social_info` SET `steamid` = ? WHERE `promo` = ? AND `social_id` = ?;', ply:SteamID64(), promo, social_id)
				
				hook.Run('PlyUsedSocialPromo', ply, social_id, promo, data[1].value)
			else
				rp.Notify(ply, NOTIFY_ERROR, rp.Term('PromocodeNotFound'))
			end
		end)
	end)
end)

net.Receive('Social::Steam', function(_, ply)
	rp._Stats:Query("SELECT * FROM `social_info`  WHERE `social_id` = 'steam' AND `steamid` = ?;", ply:SteamID64(), function(data)
		if not IsValid(ply) or ply.SteamRewardInProcess or not (data and data[1]) or data[1].promo == 'given' then return end
		
		ply.SteamRewardInProcess = true
		
		rp._Stats:Query("UPDATE `social_info` SET `promo` = 'given' WHERE `social_id` = 'steam' AND `steamid` = ?;", ply:SteamID64(), function()
			ply.SteamRewardInProcess = nil
			rp.cfg.Social.steam.bonus_func(ply)
			
			socials_got[ply:SteamID64()] = socials_got[ply:SteamID64()] or {}
			socials_got[ply:SteamID64()]['steam'] = true
			
			ba.notify_all(ba.Term('PlayerJoinedSteamGroup'), ply, rp.cfg.Social.steam.bonus_text)
		end)
	end)
end)

hook.Add('PlyUsedSocialPromo', 'SetAsUnactive', function(ply, social_id, promo, social_value)
	if social_id == 'discord' then
		ply.DiscordID = social_value
		ply.SocialDiscordData = {}
		
		check_discord_data(ply)
	end
	
	net.Start('Social::Promocode')
		net.WriteString(social_id)
	net.Send(ply)
	
	socials_got[ply:SteamID64()] = socials_got[ply:SteamID64()] or {}
	socials_got[ply:SteamID64()][social_id] = true
	
	if social_id == 'discord' or social_id == 'steam' then
		rp.syncHours.db:Query("REPLACE INTO `social_promo_used` VALUES(?, ?);", ply:SteamID64(), social_id)
	end
end)

timer.Create('Social::CheckDiscordRank', 30, 0, function() -- 60
	for _, ply in pairs(player.GetAll()) do
		if not IsValid(ply) or not ply.SocialDiscordData then continue end
		check_discord_data(ply)
	end
end)
