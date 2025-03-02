code_db = ptmysql.newdb('mysql.urf.im','promocodes', 'fgsXp4wukmfbsFWi', 'promocodes', 3306)

local tr = translates
local cached
if tr then
	cached = {
		tr.Get( 'usecount должен быть числом' ), 
		tr.Get( 'Неверный параметр action' ), 
		tr.Get( 'Промокод без макс. количества использований не может быть больше 250 кредитов' ), 
		tr.Get( 'Сумма промокода не может превосходить 10,000 кредитов' ), 
		tr.Get( 'Купон уже существует' ), 
		tr.Get( 'Длительность не может быть больше двух недель.' ), 
		tr.Get( 'Такого купона не существует' ), 
		tr.Get( 'Купон успешно удален' ), 
		tr.Get( 'time_customcheck не может быть больше двух недель.' )
	}
else
	cached = {
		'usecount должен быть числом', 
		'Неверный параметр action', 
		'Промокод без макс. количества использований не может быть больше 250 кредитов', 
		'Сумма промокода не может превосходить 10,000 кредитов', 
		'Купон уже существует', 
		'Длительность не может быть больше двух недель.', 
		'Такого купона не существует', 
		'Купон успешно удален', 
		'time_customcheck не может быть больше двух недель.'
	}
end

local promocode_action = {}

local server_name = donations.getServerName()

local function addPromocodeAction(name, func)
	promocode_action[name] = func
end

addPromocodeAction('addcredits', function(ply, name, data)
	ply:AddCredits(tonumber(data), 'promocode activated -'..name, cback)
	return data..' ' .. (translates and translates.Get('кредитов') or 'кредитов')
end)

addPromocodeAction('addupgrade', function(ply, name, data)
	local upgrade = rp.shop.GetByUID(data)
	rp.data.AddUpgrade(ply, upgrade:GetID())
	return upgrade:GetName()
end)

addPromocodeAction("addmoney", function(ply, name, data)
	data = tonumber(data)
	ply:AddMoney(data)
	return rp.FormatMoney(data)
end)

addPromocodeAction("givejob", function(ply, name, data)
	local job = rp.teamscmd[data or ''] or 1
	
	if rp.teamscmd[data] then
		rp.JobsWhitelist.GiveAccess(ply:SteamID64(), data)
	end
	
	return 'профессию ' .. rp.teams[job].name
end)

addPromocodeAction("timemultiplier", function(ply, name, data, duration)
	duration 	= tonumber(duration)
	data 		= tonumber(data)
	
	--print(data, duration)
	
	if duration and duration > 0 then
		ply:AddTimeMultiplayerSaved(name, data / 100, duration)
	end
	
	return 'множитель времени ' .. data .. '%'
end)
addPromocodeAction("addtempusergroup", function(ply, name, data)
	local info = string.Split(data, ";")
	RunConsoleCommand("urf", "setgroup", ply:SteamID(), info[1], info[2].."mi", ply:GetUserGroup())
	return translates and translates.Get("временную группу %s на %s", info[1], ba.str.FormatTime(info[2])) or ("временную группу " .. info[1] .. " на " .. ba.str.FormatTime(info[2]))
end)

util.AddNetworkString('Promocode::UseResult')

local two_weeks = 60*60*24*14
rp.AddCommand('/usepromocode', function(pl, text, args)
	if pl.processingPurchase && pl.processingPurchase > CurTime() then 
		pl:Notify(NOTIFY_ERROR, rp.Term('ProcessingPleaseWait')) 
		
		--Promocode::UseResult
		net.Start('Promocode::UseResult')
			net.WriteUInt(0, 4)
		net.Send(pl)
		
		return 
	end
	
	pl.processingPurchase = CurTime() + 2
	if (not args[1]) then pl.processingPurchase = false return end
	local code = string.lower(args[1])

	code_db:query_ex("SELECT `id`, `action`, `data`, `time_customcheck`, `action_duration`, `only4newbies`, `use_count`, UNIX_TIMESTAMP(`expires_at`) as expires, `force_allow` FROM `active_promocodes` WHERE `name` = '?' AND `server_name` = "..server_name, {code}, function(promocode_data)
		if promocode_data && promocode_data[1] then
			local actual_result_id
			
			for k, v in pairs(promocode_data) do
				if  (not v.expires or tonumber(v.expires) >= os.time()) and 
					(not v.use_count or v.use_count > 0 or force_allowed) then
					
					actual_result_id = k
					promocode_data = promocode_data[k]
					
					break
				end
			end
			
			if not actual_result_id then
				promocode_data = promocode_data[1]
			end
			
			local force_allowed = promocode_data.force_allow and (promocode_data.force_allow == pl:SteamID64())
			
			if promocode_data.expires and tonumber(promocode_data.expires) < os.time() then
				pl:Notify(NOTIFY_ERROR, rp.Term("PromoFailExpired"))
				
				--Promocode::UseResult
				net.Start('Promocode::UseResult')
					net.WriteUInt(8, 4)
				net.Send(pl)
				
				pl.processingPurchase = false
				return
			end
			
			if promocode_data.use_count and promocode_data.use_count <= 0 and not force_allowed then
				pl:Notify(NOTIFY_ERROR, rp.Term("PromoFailUsecount"))
				
				--Promocode::UseResult
				net.Start('Promocode::UseResult')
					net.WriteUInt(7, 4)
				net.Send(pl)
				
				pl.processingPurchase = false
				return
			end
			
			local sid64 = pl:SteamID64()
			code_db:query("SELECT name FROM `used_promocode` WHERE `steamid`='"..sid64.."' AND `promocode_id` = '"..promocode_data.id.."';", function(usage_data) 
				if !(usage_data && usage_data[1]) then

					local time_customcheck = tonumber(promocode_data.time_customcheck)
					if not force_allowed and (time_customcheck and time_customcheck > 0) and (
						pl:GetPlayTime() > time_customcheck and (
						pl.lastjoin and ( pl.lastjoin + two_weeks > os.time() ) and
						pl.firstjoin and ( pl.firstjoin < os.time() - 24 * 60 * 60 )
					)) then
						pl:Notify(NOTIFY_ERROR, rp.Term("PromocodeTimeLimited"), ba.str.FormatTime( time_customcheck ))
						
						--Promocode::UseResult
						net.Start('Promocode::UseResult')
							net.WriteUInt(1, 4)
						net.Send(pl)
						
						ba.logAction(pl, '', 'promo_use_fail', code .. ':hours')
						pl.processingPurchase = false
						return
					end

					local DoAfter = function(__newbie_activated)
						code_db:query_ex("INSERT INTO used_promocode(promocode_id, steamid, name, server_name) VALUES('"..promocode_data.id.."', "..sid64..", '?', "..server_name..")", {code}, function()
							if !promocode_action[promocode_data.action] then
								pl:Notify(NOTIFY_ERROR, rp.Term('TechError'))
								
								--Promocode::UseResult
								net.Start('Promocode::UseResult')
									net.WriteUInt(2, 4)
								net.Send(pl)
								
								pl.processingPurchase = false
								return
							end

							local result = promocode_action[promocode_data.action](pl, code, promocode_data.data, promocode_data.action_duration)
							pl:Notify(NOTIFY_GENERIC, rp.Term('PromocodeActivated'), string.upper(code), result)
							code_db:query_ex("UPDATE `active_promocodes` SET `use_count` = `use_count` - 1 WHERE name = '?' AND server_name = "..server_name, {code})

							--Promocode::UseResult
							net.Start('Promocode::UseResult')
								net.WriteUInt(3, 4)
							net.Send(pl)
							
							if __newbie_activated then
								code_db:query("UPDATE `used_promocode` SET `newbie_activated` = 1 WHERE promocode_id = " .. promocode_data.id .. " AND server_name= "..server_name.." AND steamid = "..sid64..";")
							end
							
							pl.processingPurchase = false
						end)
					end

					if promocode_data.only4newbies and promocode_data.only4newbies == 1 and not force_allowed then
						code_db:query("SELECT newbie_activated FROM `used_promocode` WHERE `steamid`='"..pl:SteamID64().."' AND `newbie_activated` = 1 LIMIT 1;", function(usage_data2)
							if not usage_data2 or not usage_data2[1] then DoAfter(true) return end

							for i = 1, #usage_data2 do
								local v = usage_data2[i]
								if v.newbie_activated == 1 then
									pl:Notify(NOTIFY_ERROR, rp.Term("PromocodeNewbieERR"))
									
									--Promocode::UseResult
									net.Start('Promocode::UseResult')
										net.WriteUInt(4, 4)
									net.Send(pl)
									
									ba.logAction(pl, '', 'promo_use_fail', code .. ':nwebie')
									return
								end
							end

							DoAfter(true)
						end)
					else
						DoAfter()
					end
				else
					pl:Notify(NOTIFY_ERROR, rp.Term('YouAlreadyUsedPromocode'))
					
					--Promocode::UseResult
					net.Start('Promocode::UseResult')
						net.WriteUInt(5, 4)
					net.Send(pl)
					
					pl.processingPurchase = false
				end
			end)
		else
			rp._Stats:Query('SELECT * FROM `social_info` WHERE `promo` = ?;', code, function(data)
				if not IsValid(pl) then return end
				
				if data and data[1] then
					if data[1].steamid then
						pl:Notify(NOTIFY_ERROR, rp.Term('YouAlreadyUsedPromocode'))
						
						--Promocode::UseResult
						net.Start('Promocode::UseResult')
							net.WriteUInt(5, 4)
						net.Send(pl)
						
						pl.processingPurchase = false
						return
					end
					
					local social_id = data[1].social_id
					
					if not hook.Run('Social::CanUsePromo', pl, social_id, code) then
						pl:Notify(NOTIFY_ERROR, rp.Term('YouAlreadyUsedPromocode'))
						
						net.Start('Promocode::UseResult')
							net.WriteUInt(5, 4)
						net.Send(pl)
						
						pl.processingPurchase = false
						return
					end
					
					rp.cfg.Social[social_id].bonus_func(pl)
					rp.Notify(pl, NOTIFY_GREEN, rp.Term('PromocodeActivated'), code, isfunction(rp.cfg.Social[social_id].bonus_text) and rp.cfg.Social[social_id].bonus_text(pl) or rp.cfg.Social[social_id].bonus_text)
					
					rp._Stats:Query('UPDATE `social_info` SET `steamid` = ? WHERE `promo` = ? AND `social_id` = ?;', pl:SteamID64(), code, social_id)
					
					--Promocode::UseResult
					net.Start('Promocode::UseResult')
						net.WriteUInt(3, 4)
					net.Send(pl)
					
					hook.Run('PlyUsedSocialPromo', pl, social_id, code, data[1].value)
				else
					pl:Notify(NOTIFY_ERROR, rp.Term('PromocodeNotFound'))
					
					--Promocode::UseResult
					net.Start('Promocode::UseResult')
						net.WriteUInt(6, 4)
					net.Send(pl)
					
					pl.processingPurchase = false
				end
			end)
		end
	end)
end)

function ba.PromocodeAdd(name, action, value, usecount, date, ply, time_customcheck, one_newbie_usage, action_duration)
	if !tonumber(usecount) then
		ba.notify_err(ply, cached[1])
		return
	end

	if time_customcheck then
		if not tonumber(time_customcheck) then
			ba.notify_err(ply,"time_customcheck должен быть числом")
			return
		end
		
		time_customcheck = tonumber(time_customcheck)
	else
		time_customcheck = 0
	end
	
	if action_duration then
		if not tonumber(action_duration) then
			ba.notify_err(ply,"action_duration должен быть числом")
			return
		end
		
		action_duration = tonumber(action_duration)
	end

	usecount = usecount == 0 && 'NULL' || tonumber(usecount)
	
	if !promocode_action[action] then
		ba.notify_err(ply, cached[2])
		return
	end
	
	if action == 'timemultiplier' then
		local value = tonumber(value) / 100
		
		if value < 0.1 or value > 20 then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('CantCreateTimeMultiplayer'))
			return
		end
	end
	
	if action == 'addcredits' then
		local value = tonumber(value)
		
		if (usecount == 'NULL') and (value > 300) then
			ba.notify_err(ply, cached[3])
		elseif (usecount ~= 'NULL') and (value * usecount > 10000) then 
			ba.notify_err(ply, cached[4])
		end
	end
	
	local checkcupon = code_db:query_sync("SELECT server_name,name FROM active_promocodes WHERE name = '?' AND server_name = "..server_name..";", {name})
	
	if !checkcupon || #checkcupon > 1 then
		if IsValid(ply) and ply:IsPlayer() then 
			ba.notify_err(ply, cached[5])
		end
		return
	end

	if date > 2 * 7 * 24 * 3600 then
		ba.notify_err(ply, cached[6])
		return
	end
	
	
	if time_customcheck ~= 0 and time_customcheck > 2 * 7 * 24 * 3600 then
		ba.notify_err(ply, cached[9] or "time_customcheck не может быть больше двух недель.")
		return
	end

	if action_duration then
		code_db:query_ex("INSERT INTO active_promocodes (expires_at,name,server_name,use_count,action,data,time_customcheck,action_duration,only4newbies) VALUES(DATE_ADD(NOW(),INTERVAL '?' SECOND),'?',"..server_name..",?,'?','?','?','?','?')", {date, name, usecount, action, value, time_customcheck, action_duration, one_newbie_usage and 1 or 0})
		
	else
		code_db:query_ex("INSERT INTO active_promocodes (expires_at,name,server_name,use_count,action,data,time_customcheck,only4newbies) VALUES(DATE_ADD(NOW(),INTERVAL '?' SECOND),'?',"..server_name..",?,'?','?','?','?')", {date, name, usecount, action, value, time_customcheck, one_newbie_usage and 1 or 0})
	end 
	
	if ply and ply:IsPlayer() and ply:IsValid() then
		ba.notify(ply, tr and tr.Get('coupon', name, action, value, math.floor(date / 3600 / 24), usecount == 'NULL' && 'неограниченно' || usecount, time_customcheck ~= 0 and ba.str.FormatTime(time_customcheck) or 'хоть сколько') or ("Купон "..name.." создан (даёт "..action.." в размере "..value.. ", действует ".. math.floor(date / 3600 / 24) .. " дней, активаций "..(usecount == 'NULL' && 'неограниченно' || usecount) .. (time_customcheck ~= 0 and ", возможно активировать до "..ba.str.FormatTime(time_customcheck).." наигранного времени" or "") .. ")"))
	end
end 

function ba.PromocodeRemove(name,ply)
	local checkcupon = code_db:query_sync("SELECT server_name,name FROM active_promocodes WHERE name = '?' AND server_name = "..server_name..";", {name})
	
	if #checkcupon == 0 then
		if ply and ply:IsPlayer() and ply:IsValid() then -- нужно ли это?
			ba.notify_err(ply, cached[7])
		end
		return
	end
	
	if ply and ply:IsPlayer() and ply:IsValid() then
		ba.notify(ply, cached[8])
	end
	
	code_db:query_ex("DELETE FROM active_promocodes WHERE server_name = "..server_name.." AND name = '?';", {name})
end