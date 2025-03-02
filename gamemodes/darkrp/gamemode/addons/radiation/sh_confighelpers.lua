-- "gamemodes\\darkrp\\gamemode\\addons\\radiation\\sh_confighelpers.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--——————————————————C O N F I G —▬— H E L P E R S——————————————————--
rp.Radiation = rp.Radiation or {}

rp.Radiation.SetEnable = function(b) -- bool
	rp.Radiation.Enable = tobool(b)
end

--[[
	Usage:

	rp.Radiation.SetEnable(true) -- включить модуль
	rp.Radiation.SetEnable(False) -- выключить модуль
]]--

rp.Radiation.SetZombieFaction = function(n)
	rp.Radiation.ZombieFaction = n
end

--[[
	Usage: 
	
	rp.Radiation.SetZombieFaction(FACTION_ZOMBIE)
]]--

rp.Radiation.AddZone = function(dmgtype, tickdmg) -- number, function/number
	rp.Radiation.Zones[dmgtype] = tickdmg
end

--[[
	Usage:

	rp.Radiation.AddZone(number тип урона, function(ply, dmg_amount) или number кол-во радиации при получении урона)
	
	Пример:
	rp.Radiation.AddZone(1337, function(ply, dmg)
		return ply:IsVip() and dmg*0.5 or dmg -- випы получат в 2 раза меньше облучения. обычные игроки получат облучение равное кол-ву полученного демейджа
	end)
	rp.Radiation.AddZone(228, function()
		return 5 -- +5 радиации при получении любого урона с типом 228
	end)
]]--

rp.Radiation.SetDefaultJob = function(index) -- job index
	rp.Radiation.DefaultJob = index
end

--[[
	Стандартная зомби профессия.
	rp.Radiation.SetDefaultJob(TEAM_DEFAULT_ZOMBIE)

	Если текущая профессия и фракция игрока не имеет уникальной зомби професии, то он получит данную (стандартную) профу при заражении.
]]--

rp.Radiation.AddZombieJob = function(team1, team2) -- job index or table {job1, job2, job3, e.t.c}, job index
	if isnumber(team1) then
		rp.Radiation.ZombieJobs[team1] = team2
	elseif istable(team1) then
		for _, t in pairs(team1) do
			rp.Radiation.ZombieJobs[t] = team2
		end
	end
end

--[[
	Уникальная зомби профессия для указанной работы.
	Она всегда будет приоритетнее чем зомби профессия фракции.

	Usage:
	rp.Radiation.AddZombieJob(TEAM_BOMJ, TEAM_BOMJ_ZOMBIE)

	Первый аргумент функции так-же принимает таблицы:
	rp.Radiation.AddZombieJob({
		TEAM_POLICE,
		TEAM_SWAT,
		TEAM_FBI,
		TEAM_SHERIF
	}, TEAM_POLICE_ZOMBIE)
]]--

rp.Radiation.AddFractionZombieJob = function(faction, team2) -- то-же самое, только для фракций
	if isnumber(faction) then
		rp.Radiation.ZombieFactions[faction] = team2
	elseif istable(faction) then
		for _, t in pairs(faction) do
			rp.Radiation.ZombieFactions[t] = team2
		end
	end
end

--[[
	То-же самое что и функция rp.Radiation.AddZombieJob
	Принимает индексы фракций в качестве первого аргумента.
	Так-же как и rp.Radiation.AddZombieJob поддерживает таблицы в качестве первого аргумента

	rp.Radiation.AddFractionZombieJob(FACTION_ADMINS, TEAM_ADMIN_ZOMBIE)
	rp.Radiation.AddFractionZombieJob({
		FACTION_CITIZEN,
		FACTION_WORKERS
	}, TEAM_CITIZEN_ZOMBIE)
]]--

rp.Radiation.SetInfectChance = function(n) -- number (from 0 to 100)
	rp.Radiation.InfectChance = math.Clamp(n, 0, 100)
end

--[[
	Шанс превращения в зомби при достижении порога рад. облучения  (100 едениц)
	Превращение происходит не мгновенно, т.к. кол-во текущей радиации игроков проверяется с переодичностью в 10 секунд
	Функция принимает number данные. От 0 до 100 едениц, где 100 является 100% шансом

	rp.Radiation.SetInfectChance(100) -- Игрок всегда будет превращатся в зомби
	rp.Radiation.SetInfectChance(0) -- Нет шансов на заражение - итогом 100%-ного облучения всегда будет смерть
	rp.Radiation.SetInfectChance(50) -- Надеюсь вы и сами понимаете какой результат даст 50% шанс :)
]]--

rp.Radiation.SetMaxRadiationDamage = function(n)
	rp.Radiation.MaxRadiationDamage = n
end

rp.Radiation.AddImunityJob = function(job)
	if isnumber(job) then
		rp.Radiation.ImmunityJobs[job] = true
	elseif istable(job) then
		for _, t in pairs(job) do
			rp.Radiation.ImmunityJobs[t] = true
		end
	end
end

rp.Radiation.AddImunityFaction = function(fac)
	if isnumber(fac) then
		rp.Radiation.ImmunityFactions[fac] = true
	elseif istable(fac) then
		for _, t in pairs(fac) do
			rp.Radiation.ImmunityFactions[t] = true
		end
	end
end