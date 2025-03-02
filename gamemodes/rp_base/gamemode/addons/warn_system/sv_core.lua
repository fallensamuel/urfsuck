util.AddNetworkString("WarnSystem")

function PLAYER:GetWarns(callback)
	if self.WarnCount then
		if callback then
			callback(self.WarnCount)
		end
		return
	end

	rp._Stats:Query("SELECT `Count` FROM `warn_system` WHERE `SteamID` = "..self:SteamID64()..";", function(data)
		data = data[1] or data

		self.WarnCount = data["Count"] or 0
		if callback then
			callback(data["Count"])
		end
	end)
end

function PLAYER:ResetWarns()
	self.WarnCount = 0
	rp._Stats:Query("UPDATE `warn_system` SET `Count` = 0 WHERE `SteamID` = "..self:SteamID64()..";")
end

function PLAYER:AddWarn(whoadd, minus)
	local sid64, sid = self:SteamID64(), self:SteamID()
	
	if IsValid(whoadd) then
		if not minus then ba.notify(whoadd, ba.Term("WarnSystem.Success"), self:Name(), "") end
		ba.logAction(whoadd, self, minus and 'unwarn' or 'warn', '')
	end
	
	ba.notify(self, ba.Term("WarnSystem.New"), IsValid(whoadd) and whoadd:Name() or 'Console', "")

	self:GetWarns(function(warn_count)
		local new_warn_count = (warn_count or 0) + (minus and -1 or 1)
		if new_warn_count < 0 then new_warn_count = 0 end
		if minus then ba.notify(whoadd, ba.Term("WarnSystem.NewCount"), new_warn_count, "") end
		local request = warn_count and ("UPDATE `warn_system` SET `Count` = "..new_warn_count.." WHERE `SteamID` = "..sid64..";") or ("INSERT INTO `warn_system` (`SteamID`, `Count`) VALUES("..sid64..", 1);")

		if IsValid(self) then
			self.WarnCount = new_warn_count
		end

		rp._Stats:Query(request, function()
			if not IsValid(whoadd) then return end

			--ba.notify(whoadd, ba.Term("WarnSystem.NewCount"), new_warn_count)

			if not minus and new_warn_count >= 3 then
				ba.notify(whoadd, ba.Term("WarnSystem.ItsTime2Ban"))

				net.Start("WarnSystem")
					net.WriteString(sid)
				net.Send(whoadd)
			end
		end)
	end)
end

hook.Add("OnPlayerBan", "ResetWanrs", function(ply)
	if IsValid(ply) then ply:ResetWarns() end
end)

hook.Add("InitPostEntity", "rp.InitWarnSystemSQL", function()
	rp._Stats:Query("CREATE TABLE IF NOT EXISTS `warn_system` (`SteamID` bigint(20) NOT NULL, `Count` int(8) NOT NULL, PRIMARY KEY (`SteamID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;")
end)

local baBansAmount = {}
local baBanRefillTime = 10 * 60
local baMaxBans = 7

local function isValidBansAmount(pl)
	if not IsValid(pl) then return true end -- if console
	baBansAmount[pl:SteamID()] = baBansAmount[pl:SteamID()] or { 
		LastBan 	= 0, 
		BansAmount 	= 0 
	}
	
	if baBansAmount[pl:SteamID()].LastBan ~= 0 then
		local bans_refilled = math.floor((CurTime() - baBansAmount[pl:SteamID()].LastBan) / baBanRefillTime)
		
		baBansAmount[pl:SteamID()].LastBan 		= baBansAmount[pl:SteamID()].LastBan + bans_refilled * baBanRefillTime
		baBansAmount[pl:SteamID()].BansAmount 	= baBansAmount[pl:SteamID()].BansAmount - bans_refilled
	end
	
	if baBansAmount[pl:SteamID()].BansAmount >= baMaxBans then
		ba.notify_err(pl, ba.Term('BansLimitExceeded'), string.FormattedTime(math.ceil(baBansAmount[pl:SteamID()].LastBan + baBanRefillTime - CurTime()), "%02i:%02i"))
		return false
	end
	
	baBansAmount[pl:SteamID()].LastBan 		= (baBansAmount[pl:SteamID()].LastBan == 0) and CurTime() or baBansAmount[pl:SteamID()].LastBan
	baBansAmount[pl:SteamID()].BansAmount 	= baBansAmount[pl:SteamID()].BansAmount + 1
	
	return true
end

local time_table = {
	{
		id = 'mo', 
		ln = 2592000,
	}, 
	{
		id = 'w', 
		ln = 604800,
	}, 
	{
		id = 'd', 
		ln = 86400,
	}, 
	{
		id = 'h', 
		ln = 3600,
	}, 
	{
		id = 'mi', 
		ln = 60,
	}, 
}

local function get_len_str(raw_time) 
	local raw_time_str
	
	for k, v in pairs(time_table) do 
		if raw_time < v.ln then continue end
		raw_time_str = math.ceil(raw_time / v.ln) .. v.id
		break
	end
	
	return raw_time_str
end

function HiddenWarnBanFunction(pl, args)
	args.target:GetWarns(function(warn_count)
		if not warn_count or warn_count < 3 then return end

		local banned, _ = ba.IsBanned(ba.InfoTo64(args.target))

		local min = 60*60
		local max = 24 * min
		if args.time > max then
			args.time = max
			args.raw.time = '24h'
		elseif args.time < min then
			args.time = min
			args.raw.time = '1h'
		end
		
		if not isValidBansAmount(pl) then return end
		
		if not banned then
			ba.Ban(args.target, args.reason, args.time, pl, function(data)
				if data.is_terminal then
					local raw_time = data.unban_time - data.ban_time
					ba.notify_all(ba.Term('TerminalBan'), args.target, pl, get_len_str(raw_time) or args.raw.time, data.bans_count, args.reason)
				else
					--local left_bans = data.bans_count < 10 and 10 - data.bans_count or data.bans_count < 20 and 20 - data.bans_count or data.bans_count < 30 and 30 - data.bans_count
					
					local left_bans = 10 - (data.bans_count % 10)
					local ban_len = math.ceil(data.bans_count / 10)
					ban_len = ban_len == 1 and '6h' or ban_len == 2 and '1w' or ban_len == 3 and '1mo'
					
					ba.notify_all(ba.Term('AdminBannedPlayer'), pl, args.target, args.raw.time, args.reason)
					
					if ban_len then
						ba.notify(args.target, ba.Term('TerminalBanLeft'), left_bans, ban_len)
					end
				end

				args.target:ResetWarns()
			end, true)
		elseif banned and (not ba.IsPlayer(pl) or pl:HasAccess('S')) then
			ba.UpdateBan(ba.InfoTo64(args.target), args.reason, args.time, pl, function()
				ba.notify_all(ba.Term('AdminUpdatedBan'), pl, args.target, args.raw.time, args.reason)
				args.target:ResetWarns()
			end, true)
		else
			ba.notify_err(pl, ba.Term('PlayerAlreadyBanned'))
		end
	end)
end