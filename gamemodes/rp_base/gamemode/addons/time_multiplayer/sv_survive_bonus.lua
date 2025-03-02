

local bonuses = rp.cfg.SurviveTimeMultiplayer

for k, v in pairs(bonuses) do
	v.printDuration = math.ceil(v.duration / 60)
	v.printMultiplayer = math.ceil((v.multiplayer) * 100)
end

local bonuses_count = #bonuses


local nextBonus, bonus
local function createSurviveBonus(ply, id)
	if id > bonuses_count then return end
	bonus = bonuses[id]
	timer.Create('rp.SurviveBonus'..ply:UserID(), bonus.duration, 1, function()
		if !IsValid(ply) then return end

		ply:AddTimeMultiplayer('survive', bonus.multiplayer)
		ply:Notify(NOTIFY_GREEN, rp.Term('SurviveMultiplayer'), bonus.printDuration, bonus.printMultiplayer)

		nextBonus = bonuses[id + 1]

		if nextBonus then
			ba.notify(ply, ba.Term('NextMultiplayer'), nextBonus.printMultiplayer, nextBonus.printDuration - bonus.printDuration, '')
			createSurviveBonus(ply, id + 1)
		end
	end)
end


hook.Add("PlayerDeath", function(ply)
	if ply:GetTimeMultiplayer('survive') then
		ply:RemoveTimeMultiplayer('survive')
	end

	timer.Remove('rp.SurviveBonus'..ply:UserID())
end)

hook.Add("PlayerSpawn", function(ply)
	createSurviveBonus(ply, 1)
end)


hook.Add("PlayerDisconnected", function(ply)
	timer.Remove('rp.SurviveBonus'..ply:UserID())
end)

local diff = 0
function PLAYER:CalculateSurviveTimeMultiplayer()
	diff = CurTime() - self:GetNetVar('FirstJoined')
	if diff < bonuses[1][1] then return 1 end
	
	for i=#bonuses,1 do
		if diff > bonuses[i][1] then
			return bonuses[i][2]
		end
	end
	return 1
end