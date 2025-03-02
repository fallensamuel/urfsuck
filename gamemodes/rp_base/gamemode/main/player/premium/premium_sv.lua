
--[[

	TODO:

	[+]Выдаётся на всех серверах
		[+]Проверять rp.GlobalRanks.IsHigherRank!
	[+]Даёт Emotes+ автоматически
	[+]Даёт кастомный тулган автоматически
	[+]Выбор и рендер смайлика в ник (таб, чат, мир)
	
	[]Выбор тулганов
	[]Даёт премиальные смайлики в чат
	[]Особое отображение в табе

]]

util.AddNetworkString('Donate::GetPremiumID')
util.AddNetworkString('Donate::PremiumToggle')
util.AddNetworkString('Donate::ChooseEmoji')
util.AddNetworkString('Donate::ChooseToolgun')
util.AddNetworkString('Donate::ChoosePhysgun')


local function give_premium(ply, inv_id, is_recurrent, price)
	local steamid = ply:SteamID64()
	local rank = rp.GlobalRanks.GetInfo(steamid).rank
	
	if rank and (rank == 'global_prem' or rp.GlobalRanks.IsHigherRank(rank, 'global_prem')) then
		return
	end
	
	rp.GlobalRanks.GiveRank(steamid, 'global_prem', { 
		id = inv_id or os.time(),
		auto_pay = 1,
	}, function() 
		if IsValid(ply) then
			timer.Simple(0.1, function()
				--rp.shop.OpenMenu(ply)
			end)
		end
	end, true, (not is_recurrent) and (os.time() + ((price > 1000) and 364 or 30) * 24 * 60 * 60) or nil, is_recurrent)
end

local function take_premium(ply)
	local steamid = ply:SteamID64()
	local rank_info = rp.cfg.GlobalRankPlayers[steamid]
	
	
	
	if not rank_info or rank_info.rank != 'global_prem' then return end
	
	local rank_data = util.JSONToTable(rank_info.custom_data)
	rank_data.auto_pay = 0
	rank_info.custom_data = util.TableToJSON(rank_data)
	
	rp.syncHours.db:Query("UPDATE `global_ranks` SET `custom_data` = ? WHERE `steamid` = ?;", rank_info.custom_data, steamid)
end

local last_toggles = {}
net.Receive('Donate::PremiumToggle', function(_, ply)
	if last_toggles[ply:SteamID()] and last_toggles[ply:SteamID()] > CurTime() then return end
	last_toggles[ply:SteamID()] = CurTime() + 1
	
	local steamid = ply:SteamID64()
	local rank_info = rp.cfg.GlobalRankPlayers[steamid]
	
	if not rank_info or rank_info.rank != 'global_prem' then return end
	
	local rank_data = util.JSONToTable(rank_info.custom_data)
	rank_data.auto_pay = 1 - tonumber(rank_data.auto_pay)
	rank_info.custom_data = util.TableToJSON(rank_data)
	
	rp.cfg.GlobalRankPlayers[steamid] = rank_info
	ply:SetNetVar('GlobalRankData', rank_info.custom_data)
	
	rp.syncHours.db:Query("UPDATE `global_ranks` SET `custom_data` = ? WHERE `steamid` = ?;", rank_info.custom_data, steamid)
end)

net.Receive('Donate::ChoosePhysgun', function(_, ply)
	if last_toggles[ply:SteamID()] and last_toggles[ply:SteamID()] > CurTime() then return end
	last_toggles[ply:SteamID()] = CurTime() + 0.5
	
	local steamid = ply:SteamID64()
	local rank_info = rp.cfg.GlobalRankPlayers[steamid]
	
	if not rank_info or rank_info.rank != 'global_prem' then return end
	
	local tool_id = net.ReadString()
	
	if tool_id == 'nil' then
		ba.data.SetCustomPhysgun(ply)
		return
	end
	
	ba.data.SetCustomPhysgun(ply, tool_id, function()
		if IsValid(ply) then
			rp.Notify(ply, NOTIFY_GREEN, rp.Term('ToolgunMdlEquipped'), rp.PremiumPhysguns[tool_id].name)
		end
	end)
end)

net.Receive('Donate::ChooseToolgun', function(_, ply)
	if last_toggles[ply:SteamID()] and last_toggles[ply:SteamID()] > CurTime() then return end
	last_toggles[ply:SteamID()] = CurTime() + 0.5
	
	local steamid = ply:SteamID64()
	local rank_info = rp.cfg.GlobalRankPlayers[steamid]
	
	if not rank_info or rank_info.rank != 'global_prem' then return end
	
	local tool_id = math.Clamp(net.ReadUInt(3), 1, 5)
	
	if tool_id == 1 then
		ba.data.SetCustomToolgun(ply)
		return
	end
	
	tool_id = tool_id - 1
	
	local class = 'gmod_tool_prem_' .. tool_id
	
	ba.data.SetCustomToolgun(ply, class, function()
		if IsValid(ply) then
			local index = rp.ToolGunSWEPS_k[class]
			local sweptab = rp.ToolGunSWEPS[index]
			
			rp.Notify(ply, NOTIFY_GREEN, rp.Term('ToolgunMdlEquipped'), sweptab.name)
		end
	end)
end)

net.Receive('Donate::ChooseEmoji', function(_, ply)
	if last_toggles[ply:SteamID()] and last_toggles[ply:SteamID()] > CurTime() then return end
	last_toggles[ply:SteamID()] = CurTime() + 0.5
	
	local steamid = ply:SteamID64()
	local rank_info = rp.cfg.GlobalRankPlayers[steamid]
	
	if not rank_info or rank_info.rank != 'global_prem' then return end
	
	ply:SetNickEmoji(net.ReadString())
end)


net.Receive('Donate::GetPremiumID', function(_, ply)
	--if not ply:IsRoot() then return end
	
	local cost = rp.cfg.PremiumCost or 199
	local data = tostring(cost)
	
	donations.createInvoice(ply, 'robokassa', {
		name = 'premium',
		saveData = function(self, data) 
			return data and sql.SQLStr(data) or 'NULL' 
		end,
	}, nil, data, cost, function(ply, donation, duration, id, price)
		net.Start('Donate::GetPremiumID')
			net.WriteUInt(id, 32)
		net.Send(ply)
	end)
end)

hook.Add('SuccessfulSubscription', 'Donate::GivePremium', function(ply, id, data)
	local rank_info = rp.cfg.GlobalRankPlayers[steamid]
	give_premium(ply, id, rank_info and rank_info.rank == 'global_prem', tonumber(data) or 199)
end)

hook.Add('GlobalRankDiscarded', 'Donate::TakePremium', function(steamid, prev_rank)
	if prev_rank == 'global_prem' then
		local rank_info = rp.cfg.GlobalRankPlayers[steamid]
		
		if not rank_info then return end
		
		local rank_data = util.JSONToTable(rank_info.custom_data)
		rank_data.auto_pay = 0
		
		rp.syncHours.db:Query("UPDATE `global_ranks` SET `custom_data` = ? WHERE `steamid` = ?;", util.TableToJSON(rank_data), steamid)
	end
end)
