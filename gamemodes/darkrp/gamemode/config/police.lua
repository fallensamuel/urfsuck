-- "gamemodes\\darkrp\\gamemode\\config\\police.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

-- [ НАГРАДЫ ] --
-- Награда даётся за нок и арест игрока, в зависимости от кол-ва его звёзд розыска

-- Награда за выведение из строя разыскиваемого игрока (когда он кладётся в анимацию лежания)
rp.cfg.PoliceKnockReward = { 10, 20, 30, 40, 50 };

-- Награда за арест разыскиваемого игрока
rp.cfg.PoliceArrestReward = { 25, 50, 125, 250, 500 };


-- [ ПОЛИЦЕЙСКИЕ ФРАКЦИИ ] --
-- Каждая полиц. фракция видит только выданные собой розыски

-- Добавление полицейской фракции
local POLICE_FACTION_MILITARY = rp.police.SetupFaction( "Военные",
	{
		FACTION_MILITARY,
		FACTION_MILITARYS -- Фракции профессий, входящие в данную полиц. фракцию 
	},
	{
		can_want = {
			[FACTION_REBEL] = true,	-- Фракции, на которые данная полиц. фракция сможет вешать розыски и арестовывать
			[FACTION_CITIZEN] = true,
			[FACTION_SVOBODA] = true,
			[FACTION_MONOLITH] = true,
			[FACTION_HITMANSOLO] = true,
			--[FACTION_NEBO] = true, 
		},

		jail = { -- Позиции тюрьмы данной полиц. фракции
			['rp_stalker_urfim_v3'] = {
				box = { -- Граница всей тюремной зоны
					Vector(-13828, -9984, -4099),
					Vector(-14072, -10360, -3976),
				},
				poses = { -- Позиции, на которые арестованный игрок будет телепортирован
					Vector(-14008, -10019, -4080),
					Vector(-13939, -10223, -4080),
				},
			},

			['rp_pripyat_urfim'] = {
				box = { -- Граница всей тюремной зоны
					Vector(4464, -6880, 16),
					Vector(4915, -7612, 342),
				},
				poses = { -- Позиции, на которые арестованный игрок будет телепортирован
					Vector(4569, -7317, 176),
					Vector(4615, -6998, 176),
				},
			},
			['rp_stalker_urfim'] = {
				box = { -- Граница всей тюремной зоны
					Vector(-10544, -11153, -384),
					Vector(-9548, -10305, 111),
				},
				poses = { -- Позиции, на которые арестованный игрок будет телепортирован
					Vector(-10089, -10725, -208),
					Vector(-9979, -10764, -208),
					Vector(-10079, -10837, -208),
				},
			},
		},

		supervisors = { -- Скупщики пленных
			['rp_stalker_urfim_v3'] = {
				name = "Начальник КПЗ", -- Имя нпц, отображается в бабле над ним
				model = "models/stalkertnb2/beri_rogue.mdl", -- Модель нпц
				pos = Vector(-12869, -11000, -4080), -- Позиция нпц
				ang = Angle(0, 92, 0), -- Угол нпц
				need_wanted_stars = true, -- ОПЦИОНАЛЬНО, можно удалить. Определяет, что сдавать можно только тех, кто в розыске
				custom_master_factions = nil,
				custom_slave_factions = nil,

				stars_rewards = { -- ОПЦИОНАЛЬНО, можно удалить
					[1] = 75, -- Награда за сдачу, по кол-ву звёзд розыска
					[2] = 125,
					[3] = 175,
					[4] = 225,
					[5] = 275,
				},

				stars_jail_time = { -- ОПЦИОНАЛЬНО, можно удалить
					[1] = 180, -- Время заключения, по кол-ву звёзд розыска, если не указано другое во фракции / профе
					[2] = 210,
					[3] = 240,
					[4] = 270,
					[5] = 300,
				},
			},

			['rp_pripyat_urfim'] = {
				name = "Постовой", -- Имя нпц, отображается в бабле над ним
				model = "models/player/stalker/compiled 0.34/soldierbandana.mdl", -- Модель нпц
				pos = Vector(4622, -6879, 16),
				ang = Angle(0, 93, 0), -- Угол нпц
				need_wanted_stars = true, -- ОПЦИОНАЛЬНО, можно удалить. Определяет, что сдавать можно только тех, кто в розыске
				custom_master_factions = nil,
				custom_slave_factions = nil,

				stars_rewards = { -- ОПЦИОНАЛЬНО, можно удалить
					[1] = 75, -- Награда за сдачу, по кол-ву звёзд розыска
					[2] = 125,
					[3] = 175,
					[4] = 225,
					[5] = 275,
				},

				stars_jail_time = { -- ОПЦИОНАЛЬНО, можно удалить
					[1] = 180, -- Время заключения, по кол-ву звёзд розыска, если не указано другое во фракции / профе
					[2] = 210,
					[3] = 240,
					[4] = 270,
					[5] = 300,
				},
			},

			['rp_stalker_urfim'] = {
				name = "Постовой", -- Имя нпц, отображается в бабле над ним
				model = "models/player/stalker_soldier/soldier_beret_2/soldier_beret_2.mdl", -- Модель нпц
				pos = Vector(-10971, -9208, -384),
				ang = Angle(0, -88, 0), -- Угол нпц
				need_wanted_stars = true, -- ОПЦИОНАЛЬНО, можно удалить. Определяет, что сдавать можно только тех, кто в розыске
				custom_master_factions = nil,
				custom_slave_factions = nil,

				stars_rewards = { -- ОПЦИОНАЛЬНО, можно удалить
					[1] = 75, -- Награда за сдачу, по кол-ву звёзд розыска
					[2] = 125,
					[3] = 175,
					[4] = 225,
					[5] = 275,
				},

				stars_jail_time = { -- ОПЦИОНАЛЬНО, можно удалить
					[1] = 180, -- Время заключения, по кол-ву звёзд розыска, если не указано другое во фракции / профе
					[2] = 210,
					[3] = 240,
					[4] = 270,
					[5] = 300,
				},
			},
    	},
	}
);

local POLICE_FACTION_MILITARY = rp.police.SetupFaction( "Чистое Небо",
	{
		FACTION_NEBO -- Фракции профессий, входящие в данную полиц. фракцию 
	},
	{
		can_want = {
			[FACTION_REBEL] = true,	-- Фракции, на которые данная полиц. фракция сможет вешать розыски и арестовывать
			[FACTION_SVOBODA] = true,
			[FACTION_MONOLITH] = true,
			[FACTION_HITMANSOLO] = true,
			[FACTION_DOLG] = true, 
			[FACTION_MILITARY] = true, 
			[FACTION_ECOLOG] = true, 
		},

		jail = { -- Позиции тюрьмы данной полиц. фракции
			['rp_stalker_urfim_v3'] = {
				box = { -- Граница всей тюремной зоны
					Vector(6244, 1121, -4116), 
					Vector(5932, 984, -4250),
				},
				poses = { -- Позиции, на которые арестованный игрок будет телепортирован
					Vector(6054, 1080, -4244),
					Vector(6186, 1053, -4244),
				},
			},
		},

		supervisors = { -- Скупщики пленных
			['rp_stalker_urfim_v3'] = {
				name = "Тюремщик", -- Имя нпц, отображается в бабле над ним
				model = "models/stalkertnb/cs2_vivid.mdl", -- Модель нпц
				pos = Vector(6282, 1094, -4242), -- Позиция нпц
				ang = Angle(0, -1, 0), -- Угол нпц
				--need_wanted_stars = true, -- ОПЦИОНАЛЬНО, можно удалить. Определяет, что сдавать можно только тех, кто в розыске
				custom_master_factions = nil,
				custom_slave_factions = nil,

				--stars_rewards = { -- ОПЦИОНАЛЬНО, можно удалить
				--	[1] = 75, -- Награда за сдачу, по кол-ву звёзд розыска
				--	[2] = 125,
				--	[3] = 175,
				--	[4] = 225,
				--    [5] = 275,
				--},

				stars_jail_time = { -- ОПЦИОНАЛЬНО, можно удалить
					[1] = 180, -- Время заключения, по кол-ву звёзд розыска, если не указано другое во фракции / профе
					[2] = 210,
					[3] = 240,
					[4] = 270,
					[5] = 300,
				},
			},
    	},
	}
);

-- [ ПРЕСТУПЛЕНИЯ ] --
-- Автоматически выдаваемые звёзды розыска за определённые действия

-- Добавление преступления
-- rp.police.AddCrime('Взлом Энергополя') -- Имя преступления, выступает в роли причины для розыска
-- 	:SetStars(1) -- Количество звёзд розыска, выдающееся при совершении этого преступления
-- 	:SetPoliceFactions({POLICE_FACTION_COMBINE}) -- Полиц. фракции, от которых будет вешаться розыск. Соответственно, преступление будет засчитываться только для тех игроков, которые могут разыскиваться указанными полиц. фракциями
-- 	:SetHook('PlayerFinishForcefieldCrack', function(crime, ply, ent) -- Добавление логики отслеживания преступления (в данном случае - используется событие взлома энергополя)
-- 		if IsValid(ply) and IsValid(ent) and ent.isForceField then
-- 			crime:Apply(ply)
-- 		end
-- 	end)
	
-- rp.police.AddCrime('Убийство')
-- 	:SetStars(1)
-- 	:SetPoliceFactions({POLICE_FACTION_COMBINE}) 
-- 	:SetVictimCheck(function(crime, ply)
-- 		return crime:IsInPoliceFaction(ply)
-- 	end)
-- 	:SetHook('PlayerDeath', function(crime, victim, _, killer)
-- 		if not killer:IsPlayer() or not killer:GetFaction() or not victim:GetFaction() then 
-- 			return 
-- 		end
		
-- 		if not crime:IsValidVictim(victim) then
-- 			return 
-- 		end
		
-- 		local radius_to_search = 500 * 500
		
-- 		local killer_pos = killer:GetPos()
-- 		local already_applied = {}
		
-- 		for k, v in pairs(player.GetAll()) do
-- 			if IsValid(v) and v:Alive() and v ~= victim and v:GetPos():DistToSqr(killer_pos) <= radius_to_search and crime:IsValidVictim(v) then
-- 				local police_faction = rp.police.GetFaction(v:GetFaction()).ID
				
-- 				if not already_applied[police_faction] then
-- 					already_applied[police_faction] = true
-- 					crime:Apply(killer, police_faction)
-- 				end
-- 			end
-- 		end
-- 	end)
