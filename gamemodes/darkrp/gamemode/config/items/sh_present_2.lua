-- "gamemodes\\darkrp\\gamemode\\config\\items\\sh_present_2.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Подарок: Временный VIP Статус"
ITEM.icon_override = "rpui/icons/ny_vip_gift"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "Подарок с рангом"
ITEM.category = "Storage"
ITEM.permit = "misc"
ITEM.noDrop = true
ITEM.notCanGive = true
ITEM.noUseFunc = true

local ranks = {
	['vip'] = 100,
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
		if not (item.player:IsVIP() or item.player:IsAdmin()) then
			local privilege = weighted_random(ranks)
			local time_id = weighted_random(times)
			
			RunConsoleCommand("urf", "setgroup", item.player:SteamID(), privilege, time_id, item.player:GetUserGroup()) 
				
			rp.Notify(item.player, NOTIFY_GREEN, rp.Term('HalloweenGift::Open'), 'ранг ' .. ba.ranks.Get(privilege).NiceName .. ' на ' .. time_id .. '!')
			item.player:EmitSound("open_gift.mp3", 110)
			
			return true
		else
			rp.Notify(item.player, NOTIFY_GREEN, rp.Term('HalloweenGift::InvalidRank'))
		end
	end,
}