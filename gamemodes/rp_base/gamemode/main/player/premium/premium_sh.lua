-- "gamemodes\\rp_base\\gamemode\\main\\player\\premium\\premium_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

local physguns = {
	weapon_physgun = true,
}

local premiums = { ['31'] = true, ['global_prem'] = true }
function PLAYER:HasPremium()
	local g_rank = self:GetNetVar('GlobalRank')
	return g_rank and (isstring(g_rank) and premiums[g_rank] or isnumber(g_rank) and premiums['' .. g_rank]) or false
end

local pg_data
hook.Add('PreDrawViewModel', 'test_phys', function(vm, pl, wep)
	if IsValid(pl) and pl:HasPremium() and IsValid(wep) and physguns[wep:GetClass()] then
		pg_data = pl:GetCustomPhysgun()
		
		if pg_data then
			vm:SetModel(pg_data.vmodel) 
		end
	end
end)

local wep
hook.Add('PrePlayerDraw', 'test_phys', function(pl)
	if IsValid(pl) and pl:HasPremium() then
		wep = pl:GetActiveWeapon()
		if IsValid(wep) and physguns[wep:GetClass()] then
			pg_data = pl:GetCustomPhysgun()
			
			if pg_data and pg_data.wmodel then
				wep:SetModel(pg_data.wmodel) 
			end
		end
	end
end)

hook.Add('PreDrawPlayerHands', 'test_phys', function(hands, vm, pl, wep)
	if IsValid(pl) and pl:HasPremium() and IsValid(wep) and physguns[wep:GetClass()] then
		pg_data = pl:GetCustomPhysgun()
		
		if pg_data and not pg_data.use_hands then
			return true
		end
	end
end)



-- [[ Premium Discount ]] --
nw.Register('prem_sale')
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetGlobal()

rp.AddTerm("PremSaleStart", "Скидка # на премиум активирована на #ч!")
rp.AddTerm("PremSaleEnd", "Скидка на премиум закончена")

ba.cmd.Create('Prem Sale Set', function(pl, args)
	local discount 	= tonumber(args.discount)
	local time 		= args.time
	
	if discount < 10 or discount > 70 then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('ShopSaleCantCreate'))
		return
	end
	
	rp.PremiumDiscount(discount, time)
	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('PremSaleStart'), discount .. "%", math.floor(time / 3600))
	
	ba.logAction(pl, tostring(discount), 'premsale set', tostring(time))
end)
:AddParam('string', 'discount')
:AddParam('time', 'time')
:SetFlag('e')
:SetHelp('Sets premium discount')

ba.cmd.Create('Prem Sale Reset', function(pl, args)
	rp.PremiumDiscount()
	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('PremSaleEnd'))
	
	ba.logAction(pl, '', 'premsale reset', '')
end)
:SetFlag('e')
:SetHelp('Removes premium discount')
