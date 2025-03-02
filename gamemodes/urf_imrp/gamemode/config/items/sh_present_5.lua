ITEM.name = "Подарок: Умножение Времени"
ITEM.icon_override = "icons/time_gift"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "Подарок с множителем времени"
ITEM.category = "Storage"
ITEM.permit = "misc"
ITEM.noDrop = true
ITEM.notCanGive = true
ITEM.noUseFunc = true

local multipliers = {
	[2] = 80,
	[3] = 20,
}

local times = {
	['1h'] = 70,
	['2h'] = 25,
	['3h'] = 5
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
		if item.player:HasTimeMultiplayer('hllwn_gift') then
			rp.Notify(item.player, NOTIFY_GREEN, rp.Term('HalloweenGift::InvalidTime'))
			return false
		end
		
		local mult = weighted_random(multipliers)
		local time_id = weighted_random(times)
		
		rp.Notify(item.player, NOTIFY_GREEN, rp.Term('HalloweenGift::Open'), 'множитель времени x' .. mult .. ' на ' .. time_id .. '!')
		item.player:EmitSound("open_gift.mp3", 110)
		
		item.player:AddTimeMultiplayerSaved('hllwn_gift', mult, 3600 * tonumber(string.sub(time_id, 1, -2)))
		
		return true
	end,
}