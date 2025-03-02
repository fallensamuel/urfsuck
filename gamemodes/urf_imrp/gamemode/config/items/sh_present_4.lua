ITEM.name = "Подарок: Слуачайное Оружие"
ITEM.icon_override = "icons/gun_gift"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "Подарок с оружием"
ITEM.category = "Storage"
ITEM.permit = "misc"
ITEM.noDrop = true
ITEM.notCanGive = true
ITEM.noUseFunc = true

local weps = {
	['weapon_crowbar'] = 45,
	['swb_pistol'] = 25,
	['swb_smg'] = 15,
	['swb_shotgun'] = 10,
	['swb_ar2'] = 5,
}

local times = {
	['1d'] = 70,
	['2d'] = 25,
	['3d'] = 5
}

local function weighted_random(tbl)
	local summ = 0
	local result
	local default_summ = 0
	local default
	
	for k, v in pairs(tbl) do
		if not default or default_summ < v then
			default = k
			default_summ = v
		end
		
		summ = summ + v
	end
	
	local chance = math.random(0, summ)
	
	for k, v in pairs(tbl) do
		chance = chance - v
		
		if chance <= 0 then
			result = k
			break
		end
	end
	
	return result or default
end

ITEM.functions.TakeGift = {
	name = "Получить",
	tip = "useTip",
	icon = "icon16/add.png",
	onRun = function(item)
		local weps_copy = table.Copy(weps)
		local wep = weighted_random(weps_copy)
		
		while table.Count(weps_copy) > 0 and IsValid(item.player:GetWeapon(wep)) do
			weps_copy[wep] = nil
			wep = weighted_random(weps_copy)
		end
		
		if IsValid(item.player:GetWeapon(wep)) then
			rp.Notify(item.player, NOTIFY_GREEN, rp.Term('HalloweenGift::InvalidWep'))
			return false
		end
		
		local time_id = weighted_random(times)
		
		--rp.Notify(item.player, NOTIFY_GREEN, rp.Term('HalloweenGift::Open'), 'оружие ' .. (weapons.Get(wep) and weapons.Get(wep).PrintName or wep) .. ' на ' .. time_id .. '!')
		
		net.Start('Halloween::GaveWep')
			net.WriteString(wep)
			net.WriteString(time_id)
		net.Send(item.player)
		
		item.player:EmitSound("open_gift.mp3", 110)
		
		RunConsoleCommand("urf", "givetempweapon", item.player:SteamID(), wep, time_id) 
		
		return true
	end,
}

if SERVER then
	util.AddNetworkString('Halloween::GaveWep')
	
else
	net.Receive('Halloween::GaveWep', function()
		local wep = net.ReadString()
		local time_id = net.ReadString()
		
		rp.Notify(NOTIFY_GREEN, rp.Term('HalloweenGift::Open'), 'оружие ' .. (weapons.Get(wep) and weapons.Get(wep).PrintName or wep) .. ' на ' .. time_id .. '!')
	end)
end