-- "gamemodes\\darkrp\\gamemode\\config\\items\\sh_present_3.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ITEM.name = "Подарок: Случайная Профессия"
ITEM.icon_override = "icons/job_gift"
ITEM.width = 1
ITEM.height = 1
ITEM.desc = "Подарок с профой"
ITEM.category = "Storage"
ITEM.permit = "misc"
ITEM.noDrop = true
ITEM.notCanGive = true
ITEM.noUseFunc = true

local jobs = {
	['pigeon'] = 20,
	['crow'] = 20,
	['g_man_teleport'] = 15,
	['hevmk2'] = 15,
	['larry'] = 15,
	['ofcgrid'] = 15,
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
		local jobs_copy = table.Copy(jobs)
		local job = weighted_random(jobs_copy)
		
		while table.Count(jobs_copy) > 0 and rp.PlayerHasAccessToJob(job, item.player) do
			jobs_copy[job] = nil
			job = weighted_random(jobs_copy)
		end
		
		if rp.PlayerHasAccessToJob(job, item.player) then
			rp.Notify(item.player, NOTIFY_GREEN, rp.Term('HalloweenGift::InvalidJob'))
			return false
			
		else
			local time_id = weighted_random(times)
			
			rp.Notify(item.player, NOTIFY_GREEN, rp.Term('HalloweenGift::Open'), 'профессию ' .. (rp.teamscmd[job] and rp.teams[ rp.teamscmd[job] ] and rp.teams[ rp.teamscmd[job] ].name or job) .. ' на ' .. time_id .. '!')
			item.player:EmitSound("open_gift.mp3", 110)
			
			RunConsoleCommand("urf", "givetempjob", item.player:SteamID(), job, time_id) 
			
			return true
		end
	end,
}