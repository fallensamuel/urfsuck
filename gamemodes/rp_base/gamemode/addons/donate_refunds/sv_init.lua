
util.AddNetworkString('rp.Donates.Return')
util.AddNetworkString('rp.Donates.SendToPlayer')

local donators_cache = {}

function rp.GetDonates(ply, caller, cback)
	rp._Stats:Query("SELECT t1.Time as time1, t2.Time as time2, t1.Upgrade as upg, t2.Change as cost FROM kshop_purchases as t1 INNER JOIN kshop_credits_transactions as t2 ON (t1.SteamID = t2.SteamID AND IF(t1.Time > t2.Time, t1.Time - t2.Time, t2.Time - t1.Time) < 3) WHERE t1.SteamID = '" .. ply .. "'", function(data) -- INNER JOIN отсеит купленные за валюту донаты
		if not data or table.Count(data) == 0 then 
			cback()
			return 
		end
		
		local actual_donates = {}
		for k, v in pairs(data) do
			local shop_item = rp.shop.GetByUID(v.upg)
			
			if shop_item then
				table.insert(actual_donates, v)
			end
		end
		
		if table.Count(actual_donates) == 0 then 
			cback()
			return 
		end
		
		donators_cache[caller] = {ply, actual_donates}
		cback(actual_donates)
	end)
end

local not_return_cats = {
	['Время'] = true,
	['Валюта'] = true,
	['Привелегии'] = true,
	['Ивенты'] = true,
}

net.Receive('rp.Donates.Return', function(_, ply)
	if not donators_cache[ply] then 
		return rp.Notify(ply, NOTIFY_ERROR, rp.Term('DonatesFailed'))
	end
	
	local donate_id = net.ReadUInt(12)
	
	local donator = donators_cache[ply][1]
	local donates = donators_cache[ply][2]
	
	if not donates[donate_id] then 
		return rp.Notify(ply, NOTIFY_ERROR, rp.Term('DonatesFailed'))
	end
	
	local donate = donates[donate_id]
	--PrintTable(donate)
	
	local upg = rp.shop.GetByUID(donate.upg)
	
	--PrintTable(upg or {})
	
	if not upg or not_return_cats[upg.Cat] then return end
	
	--print('Donate refunded')
	
	rp._Stats:Query('DELETE FROM `kshop_purchases` WHERE `Time` = ? AND `SteamID` = ? LIMIT 1', donate.time1, donator, function()
		rp.data.AddCredits(donator, -donate.cost, 'Refund: ' .. donate.upg .. ' by ' .. ply:Name() .. ' (' .. ply:SteamID() .. ')', function()
			rp.Notify(ply, NOTIFY_GREEN, rp.Term('DonatesSuccessful'), -donate.cost, donate.upg, donator)
		end)
	end)
end)
