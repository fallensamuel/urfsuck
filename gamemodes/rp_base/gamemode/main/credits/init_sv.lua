util.AddNetworkString'rp.CreditShop'

function PLAYER:AddCredits(amount, note, cback)
	rp.data.AddCredits(self:SteamID(), amount, note, function()
		self:SetNetVar('Credits', self:GetCredits() + amount)

		if (cback) then
			cback()
		end
	end)
end

function PLAYER:TakeCredits(amount, note, cback)
	local real_amount = math.min(self:GetCredits(), amount)
	rp.data.AddCredits(self:SteamID(), -real_amount, note, function()
		self:SetNetVar('Credits', self:GetCredits() - real_amount)

		if (cback) then
			cback(0)
		end
	end)
end

function PLAYER:CanAffordCredits(amount)
	return self:GetNetVar('Credits', 0) >= amount
end

function PLAYER:GetUpgradeCount(uid)
	return (self:GetVar('Upgrades', {})[uid] or 0)
end

function PLAYER:GetPermaWeapons()
	return self:GetVar('PermaWeapons', {})
end

function PLAYER:GetTotalDonated(cback)
	if self.TotalDonated then 
		if cback then
			cback(self.TotalDonated)
		else
			return self.TotalDonated
		end
	else
		rp._Stats:Query("SELECT SUM(`Change`) as total_donated FROM `kshop_credits_transactions` WHERE `SteamID` = ? AND `Note` LIKE 'auto purchase%';", self:SteamID(), function(data)
			if IsValid(self) then
				self.TotalDonated = data and data[1] and data[1].total_donated or 0
				
				if cback then
					cback(self.TotalDonated)
				end
			end
		end)
	end
end

hook.Add('SuccessfulPayment', 'Donate::TotalDonated', function(ply, credits)
	ply:GetTotalDonated(function(amt)
		ply.TotalDonated = amt + credits
	end)
end)

util.AddNetworkString( "rp.CreditShop.DisableWeapon" );
net.Receive( "rp.CreditShop.DisableWeapon", function( len, ply )
	local uid      = net.ReadString();

	if string.find( uid, ";" ) then
		local tbl = string.Explode(";",uid) or {};
		
		local disabledWeps = {};

		for _, wep in pairs(tbl) do
			if ply:HasUpgrade(wep) then
				disabledWeps[wep] = true;
			end
		end

		ply:SetVar( "DisabledDonateWeps", disabledWeps );
	elseif ply:HasUpgrade(uid) then
		local disabled     = net.ReadBool();
		local disabledWeps = ply:GetVar( "DisabledDonateWeps", {} );

		disabledWeps[uid] = disabled;
		ply:SetVar( "DisabledDonateWeps", disabledWeps );
	end
end );

local CAN_BUY = 0
local CANT_BUY = 1
local CANT_BUY_SHOW_BTN = 2

function rp.shop.OpenMenu(pl)
	if pl.OpeningCreditMenu then return end
	pl.OpeningCreditMenu = true

	rp.data.LoadCredits(pl, function()
		pl.OpeningCreditMenu = nil
		
		local ret = {}
		local can_refund = {}

		local donate_time = rp.shop.DonatesHistory[pl:SteamID64()] or {}
		local cur_time = os.time()
		local max_refund_time = 2 * 24 * 60 * 60
		
		local refund_reasons = {
			[translates.Get('Это у вас уже куплено!')] = true, 
			[translates.Get('Лимит достигнут')] = true, 
		}
		
		for k, v in ipairs(rp.shop.GetTable()) do
			if (not v:CanSee(pl)) then continue end
			local canbuy, reason = v:CanBuy(pl)

			if (not canbuy) then
				if utf8.find(reason, translates.Get("Вы не можете купить")) then
					ret[v:GetID()] = {reason, v:GetPrice(pl)}
				else
					ret[v:GetID()] = reason
				end
				
				if refund_reasons[reason] and donate_time[v:GetUID()] and cur_time - donate_time[v:GetUID()] < max_refund_time then
					table.insert(can_refund, v:GetID())
				end
			else
				ret[v:GetID()] = v:GetPrice(pl)
			end
		end
		
		local steamid = pl:SteamID64()
		local rank = (rp.GlobalRanks.GetInfo(steamid) or {}).rank
		
		net.Start('rp.CreditShop')
		net.WriteUInt(table.Count(ret), 8)
		net.WriteBool(pl.donateInProgress or false)
		
		for k, v in pairs(ret) do
			if istable(v) then
				net.WriteUInt(CANT_BUY_SHOW_BTN, 2)
				net.WriteUInt(k, 8)
				net.WriteString(v[1])
				net.WriteUInt(v[2], 16)
			elseif isstring(v) then
				net.WriteUInt(CANT_BUY, 2)
				net.WriteUInt(k, 8)
				net.WriteString(v)
			else
				net.WriteUInt(CAN_BUY, 2)
				net.WriteUInt(k, 8)
				net.WriteUInt(v, 16)
			end
		end
		
		net.WriteUInt(table.Count(can_refund), 8)
		
		for _, v in pairs(can_refund) do
			net.WriteUInt(v, 8)
		end

		net.Send(pl)
	end)
end

rp.AddCommand('/upgrades', rp.shop.OpenMenu)
-- Data
local db = rp._Credits

function rp.data.AddCredits(steamid, amount, note, cback)
	db:Query('INSERT INTO `kshop_credits_transactions` (`Time`, `SteamID`, `Change`, `Note`) VALUES(?, ?, ?, ?);', os.time(), steamid, amount, (note or ''), cback)
end

function rp.data.LoadCredits(pl, cback)
	db:Query('SELECT COALESCE(SUM(`Change`), 0) AS `Credits` FROM `kshop_credits_transactions` WHERE `SteamID`="' .. pl:SteamID() .. '";', function(data)
		if IsValid(pl) then
			pl:SetNetVar('Credits', tonumber(data[1]['Credits']))

			if cback then
				cback(data)
			end
		end
	end)
end

function rp.data.AddUpgrade(pl, id, altpay)
	local upg_obj = rp.shop.Get(id)
	local canbuy, reason = upg_obj:CanBuy(pl)

	if (not canbuy and not (upg_obj:GetAltPrice() and pl:GetMoney() >= upg_obj:GetAltPrice())) then
		pl:Notify(NOTIFY_ERROR, rp.Term('CantPurchaseUpgrade'), reason)
	else
		if pl.donateInProgress then
			pl:Notify(NOTIFY_ERROR, rp.Term('DonateInProgress'))
			return
		end
		
		local cost = upg_obj:GetPrice(pl)

		pl.donateInProgress = true

		local function fcallback(isAlt)
			if (!isAlt) then isAlt = 0; end
			--db:Query("INSERT INTO `kshop_credits_transactions` VALUES('" .. os.time() .. "', '" .. pl:SteamID() .. "', '" .. -cost .. "', 'Purchase: " .. upg_obj:GetUID() .. "');", function(dat)
			--db:Query("INSERT INTO `kshop_purchases` VALUES('" .. os.time() .. "', '" .. pl:SteamID() .. "', '" .. upg_obj:GetUID() .. "');", function(dat)
			db:Query("INSERT INTO `kshop_purchases` VALUES('" .. os.time() .. "', '" .. pl:SteamID() .. "', '" .. upg_obj:GetUID() .. "', '" .. isAlt .. "');", function(dat)
				for k, v in ipairs(player.GetAll()) do
					v:ChatPrint(translates.Get("%s купил %s", pl:Name(), upg_obj:GetName()))
				end
				
				pl.donateInProgress = nil

				rp.shop.DonatesHistory[pl:SteamID64()] = rp.shop.DonatesHistory[pl:SteamID64()] or {}
				rp.shop.DonatesHistory[pl:SteamID64()][upg_obj:GetUID()] = os.time()
				
				local upgrades = pl:GetVar('Upgrades')
				upgrades[upg_obj:GetUID()] = upgrades[upg_obj:GetUID()] and (upgrades[upg_obj:GetUID()] + 1) or 1
				pl:SetVar('Upgrades', upgrades)
				upg_obj:OnBuy(pl)
				rp.shop.OpenMenu(pl)
			end)
		end

		if (altpay and pl:GetMoney() >= upg_obj:GetAltPrice()) then
			pl:TakeMoney(upg_obj:GetAltPrice());
			fcallback(1);
			return
		end

		-- disputable thing, but will help not go to minus
		if (pl:CanAffordCredits(cost)) then
			pl:TakeCredits(cost, 'Purchase: ' .. upg_obj:GetUID(), fcallback)
		end
	end
end

hook('PlayerDisconnected', 'rp.shop.ClearDonateHistory', function(pl)
	rp.shop.DonatesHistory[pl:SteamID64()] = nil
end)

hook('PlayerAuthed', 'rp.shop.LoadCredits', function(pl)
	pl:GetTotalDonated()
	
	rp.data.LoadCredits(pl, function()
		if IsValid(pl) then
			ba.notify(pl, translates.Get("У вас в кошельке: %i Рублей.", pl:GetCredits()))
		end
	end)

	db:Query('SELECT `Upgrade`, `Time` FROM `kshop_purchases` WHERE `SteamID`="' .. pl:SteamID() .. '";', function(data)
		if IsValid(pl) then
			local pl_id = pl:SteamID64()
			
			local upgrades = {}
			local weps = {}
			local networked = {}

			rp.shop.DonatesHistory[pl_id] = {}
			
			for k, v in ipairs(data) do
				local uid = v.Upgrade
				local obj = rp.shop.GetByUID(uid)
				local wep = rp.shop.Weapons[uid]
				upgrades[uid] = upgrades[uid] and (upgrades[uid] + 1) or 1

				if not rp.shop.DonatesHistory[pl_id][uid] or rp.shop.DonatesHistory[pl_id][uid] < v.Time then
					rp.shop.DonatesHistory[pl_id][uid] = v.Time
				end
				
				if (wep ~= nil) then
					if (obj ~= nil && (!obj:IsIgnoreDisallow() || !pl:GetJobTable().disallowDonateWeapons)) then
						pl:Give(wep)
					end
					weps[#weps + 1] = wep
				end

				if (obj ~= nil) and obj:IsNetworked() then
					networked[#networked + 1] = obj:GetID()
				end
			end

			pl:SetVar('Upgrades', upgrades)
			pl:SetVar('PermaWeapons', weps)

			if (#networked > 0) then
				pl:SetNetVar('Upgrades', networked)
			end

			hook.Call('PlayerUpgradesLoaded', nil, pl)
		end
	end)
end)

hook('PlayerLoadout', 'rp.shop.PlayerLoadout', function(pl)
	if rp.teams[pl:Team()] and rp.teams[pl:Team()].DontHaveDonateSWEPS then return end
	
	local disabledWeapons = pl:GetVar( "DisabledDonateWeps", {} );

	for k, v in ipairs(pl:GetPermaWeapons()) do
		local uid     = rp.shop.WeaponsMap[v];
		local upgrade = rp.shop.GetByUID(uid)
		if upgrade ~= nil && upgrade:IsIgnoreDisallow() && pl:GetJobTable().disallowDonateWeapons then continue end
		if (disabledWeapons[uid] or false)													      then continue end
		pl:Give(v)
	end

	if pl:HasUpgrade('random_melee_weapon') and !disabledWeapons['random_melee_weapon'] then
		pl:Give(table.Random(rp.cfg.MeleeWeapons))
	end

	if pl:HasUpgrade('armor') then
		pl:GiveArmor(pl:GetUpgradeCount('armor')*33)
	end

	if pl:HasUpgrade('max_health') then
		pl:AddMaxHealth(pl:GetUpgradeCount('max_health')*25)
	end

	if pl:HasUpgrade('perma_ammo') then
		pl:GiveAmmos(pl:GetUpgradeCount('perma_ammo'), true)
	end

	if pl:HasUpgrade('no_hunger') then
		pl:SetHungerRateMultiplier(2)
	end
	
	if pl:HasUpgrade('emotions_pack') and !disabledWeapons['emotions_pack'] then
		pl:Give('dab')
		pl:Give('facepunch')
		pl:Give('flip')
		pl:Give('middlefinger')
		pl:Give('seig_hail')
		pl:Give('surrender')
	end
end)

rp.AddCommand('/buyupgrade', function(pl, text, args)
	local id = tonumber(args[1])
	if not args[1] or not rp.shop.Get(id) or rp.shop.Get(id):GetCat() == translates.Get('Особые услуги') or rp.shop.Get(id):GetUID() == 'unused' then return end
	rp.data.AddUpgrade(pl, id)
end)

rp.AddCommand('/altbuyupgrade', function(pl, text, args)
	local id = tonumber(args[1])
	if not args[1] or not rp.shop.Get(id) or rp.shop.Get(id):GetCat() == translates.Get('Особые услуги') or rp.shop.Get(id):GetUID() == 'unused' then return end
	rp.data.AddUpgrade(pl, id, true)
end)

-- Daily Sale
local silent
local function updateGlobalSale(is_silent)
	if not ba.svar.stored then return end
	
	rp.shop.initGlobalVars(is_silent)
	
	local gl_amount	= ba.svar.GetGlobal('sales_global_amount')
	local gl_time 	= ba.svar.GetGlobal('sales_global_time')
	
	silent = is_silent
	nw.SetGlobal('rp.shop.settings', {
		global 	= gl_amount and tonumber(gl_amount) or 0, 
		duntil 	= gl_time and tonumber(gl_time) or 0
	})
end

local function updateGlobalGlobal()
	if silent then 
		silent = nil 
		return 
	end
	
	timer.Simple(0, function()
		rp.NotifyAll(NOTIFY_GENERIC, rp.Term('ShopSaleStart'), tonumber(ba.svar.GetGlobal('sales_global_amount')), math.floor((tonumber(ba.svar.GetGlobal('sales_global_time')) - os.time() + 1) / 3600))
		updateGlobalSale()
	end)
end

function rp.shop.initGlobalVars(is_silent)
	silent = is_silent
	ba.svar.Create('sales_global_amount', nil, nil, updateGlobalGlobal, true)
	silent = is_silent
	ba.svar.Create('sales_global_time', nil, nil, updateGlobalGlobal, true)
end

updateGlobalSale()
hook('bAdmin_Loaded', updateGlobalSale)

function rp.SetDiscount(value, discount_time, is_silent)
	value 			= (value < 10) and 10 or (value > 70) and 70 or value
	discount_time 	= discount_time + os.time()
	
	silent = is_silent
	ba.svar.SetGlobal('sales_global_amount', tostring(value))
	silent = is_silent
	ba.svar.SetGlobal('sales_global_time', discount_time)
	
	updateGlobalSale(is_silent)
end

util.AddNetworkString('rp.sales.SendToClient')

hook.Add("PlayerDataLoaded", "rp.sales.SendSales", function(ply)
	net.Start('rp.sales.SendToClient')
		net.WriteTable(rp.shop.sales_current or {})
		net.WriteTable(rp.shop.sales_altprice or {})
	net.Send(ply)
end)

local function GenAltPrice()
	rp.shop.sales_altprice = {};

	if (!rp.cfg.AltPriceList) then return end

	local Count = rp.cfg.AltPriceList.Count or 5;
	local Interval = rp.cfg.AltPriceList.Interval or 24 * 7;

	local HasAltPrice = rp.shop.altrotate or {};
	local AltPriceItems = table.GetKeys(HasAltPrice);

	math.randomseed(math.floor(os.time() / Interval / 3600));

	local Item;
	local Amount;
	local G = {};

	for Index = 1, Count do
		Item = AltPriceItems[math.random(1, #AltPriceItems)];
		while (G[Item]) do
			if (#table.GetKeys(G) == #table.GetKeys(AltPriceItems) or !G) then break end
			Item = AltPriceItems[math.random(1, #AltPriceItems)];
		end
		if (!Item) then continue end
		G[Item] = true;
		if (!Item or !rp.shop.Mapping[Item]) then continue end

		Amount = HasAltPrice[Item];
		if (!Amount) then continue end

		rp.shop.sales_altprice[Item] = Amount;
		rp.shop.Mapping[Item]:SetAltPrice(Amount);
	end

	math.randomseed(os.time());
end

hook.Add('rp.AddUpgrades', 'rp.shop.daily', function()
	GenAltPrice();

	if not rp.cfg.DiscountSettings then return end
	
	math.randomseed(math.floor(os.time() / rp.cfg.DiscountSettings.interval / 3600))
	
	local item
	local amount
	local G = {};
	
	local sales 		= rp.shop.sales or {}
	local sales_items 	= table.GetKeys(sales)
	
	rp.shop.sales_current = {}
	
	for k = 1, rp.cfg.DiscountSettings.count do
		item = sales_items[math.random(1, #sales_items)]
		
		while (G[item]) do
			if (#table.GetKeys(G) == #table.GetKeys(sales_items) or !G) then break end
			item = sales_items[math.random(1, #sales_items)];
		end
		if (!item) then continue end
		G[item] = true;
		
		if not rp.shop.Mapping[item] then continue end
		
		amount = sales[item][math.random(1, #sales[item])]
		if not amount then continue end
		
		rp.shop.sales_current[item] = amount
		rp.shop.Mapping[item]:SetDiscount(amount)
	end
	
	math.randomseed(os.time())
end)
--[[
hook.Add("baDataLoaded", "SendPersonalSaleNotify", function(ply)
	local sale = ply:GetPersonalDiscount()
	if sale > 0 then
		ba.notify(ply, ba.Term("PersonalDiscount"), sale*100, "")
	end
end)
]]--