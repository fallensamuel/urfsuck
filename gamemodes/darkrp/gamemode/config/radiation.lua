-- "gamemodes\\darkrp\\gamemode\\config\\radiation.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--——————————————————R A D I A T I O N —▬— S Y S T E M——————————————————--

/*
	Список функций для конфигурации:

	rp.Radiation.SetEnable(b) -- bool
	rp.Radiation.AddZone(dmgtype, tickdmg) -- number, function/number
	rp.Radiation.SetDefaultJob(index) -- job index
	rp.Radiation.AddZombieJob(team1, team2) -- job index or table {job1, job2, job3, e.t.c}, job index
	rp.Radiation.AddFractionZombieJob(faction, team2) -- то-же самое, только для фракций
	rp.Radiation.SetInfectChance(n) -- number (from 0 to 100)

	Поддерживаемые SHARED каллбэки для таблиц профессий:
	OnZombieInfect
	OnZombieDeInfect
	Каллбэки содержат 1 аргумент - энтити игрока
	Пример использования:
	TEAM_POCAN = rp.addTeam("Поц", {
	    color = Color(100, 117, 109),
	    model = model_bandit1,
	    OnZombieInfect = function(ply)
			rp.Notify(ply, NOTIFY_GREEN, "Теперь ты зомби!")
	    end,
	    OnZombieDeInfect = function(ply)
			rp.Notify(ply, NOTIFY_GREEN, "Ты больше не зомби :(")
	    end
	}
*/

--—————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————

--[[
	Usage:

	rp.Radiation.SetEnable(true) -- включить модуль
	rp.Radiation.SetEnable(False) -- выключить модуль
]]--

rp.Radiation.SetEnable(true)

--—————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————

--[[
	Usage: 
	
	rp.Radiation.SetZombieFaction(FACTION_ZOMBIE)

	Используется для PMETA функции IsRadiationZombie
]]--

rp.Radiation.SetZombieFaction(FACTION_ZOMBIE1)

--—————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————

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

rp.Radiation.AddZone(8, function(ply, dmg)
	return dmg*0.3
end)
rp.Radiation.AddZone(256, function(ply, dmg)
	return dmg*0.35
end)
rp.Radiation.AddZone(2097152, function(ply, dmg)
	return dmg*0.35
end)
rp.Radiation.AddZone(16, function(ply, dmg)
	return dmg*0.35
end)	
rp.Radiation.AddZone(262144, function(ply, dmg)
	return dmg*0.35
end)
rp.Radiation.AddZone(256, function(ply, dmg)
	return dmg*0.35
end)
rp.Radiation.AddZone(65536, function(ply, dmg)
	return dmg*0.3
end)


--—————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————

--[[
	Стандартная зомби профессия.
	rp.Radiation.SetDefaultJob(TEAM_ZOMBIE_DEFAULT)

	Если текущая профессия и фракция игрока не имеет уникальной зомби професии, то он получит данную (стандартную) профу при заражении.
]]--

rp.Radiation.SetDefaultJob(TEAM_ZOMBIE_STALKER)

--—————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————

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

--rp.Radiation.AddZombieJob({TEAM_RCTDOLG, TEAM_RCTDOLGVIP, TEAM_PRDOLG, TEAM_VIPDOLG}, TEAM_ZOMBIE_GOP)
--rp.Radiation.AddZombieJob(TEAM_OSEP, TEAM_ZOMBIE_STALKER)

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

rp.Radiation.AddFractionZombieJob(FACTION_CITIZEN, TEAM_ZOMBIE_STALKER)
rp.Radiation.AddFractionZombieJob({FACTION_DOLG,FACTION_DOLGVIP}, TEAM_ZOMBIE_DOLG)
rp.Radiation.AddFractionZombieJob({FACTION_SVOBODA,FACTION_SVOBODAVIP}, TEAM_ZOMBIE_SVOB)
rp.Radiation.AddFractionZombieJob({FACTION_MILITARY,FACTION_MILITARYS, FACTION_MILITARYT}, TEAM_ZOMBIE_MILITARY)
rp.Radiation.AddFractionZombieJob(FACTION_REBEL, TEAM_ZOMBIE_BANDIT)

--—————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————————

--[[
	Шанс превращения в зомби при достижении порога рад. облучения  (100 едениц)
	Превращение происходит не мгновенно, т.к. кол-во текущей радиации игроков проверяется с переодичностью в 10 секунд
	Функция принимает number данные. От 0 до 100 едениц, где 100 является 100% шансом

	rp.Radiation.SetInfectChance(100) -- Игрок всегда будет превращатся в зомби
	rp.Radiation.SetInfectChance(0) -- Нет шансов на заражение - итогом 100%-ного облучения всегда будет смерть
	rp.Radiation.SetInfectChance(50) -- Надеюсь вы и сами понимаете какой результат даст 50% шанс :)
]]--

rp.Radiation.SetInfectChance(70)
rp.Radiation.SetMaxRadiationDamage(15)

--[[
	Функции rp.Radiation.AddImunityJob и rp.Radiation.AddImunityFaction
	позваляют установить невосприимчивость к радиации - определённым группам (проф, фракций)

	Функции принимают 1 аргумент:
	Индекс професии/фракциии
	Или таблицу с перечислением нескольких профессий/фракций
]]--	
rp.Radiation.AddImunityJob({TEAM_GHOSTCITIZEN,TEAM_SUPERVISOR,TEAM_BANNED,TEAM_LAZSCOR})
rp.Radiation.AddImunityFaction({FACTION_ZOMBIE,FACTION_ZOMBIE1,FACTION_MUTANTS,FACTION_ADMINS})