-- "gamemodes\\darkrp\\gamemode\\config\\pets.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--Сизонпасс Хэллоуин
rp.pets.Add("pet_ivent_dog", {
	name = "Пес Курцхаар", -- Имя питомца в меню Аксессуаров
	model = "models/npc/dog/npc_dog.mdl", -- Модель питомца
	sound = "dog/say1.wav", -- Звук появления, исчезновения и нажатия Е на питомца
	spawn_effect = "mcsd_dust", -- Эффект появления и исчезновения питомца
	z_offset = 0, -- Смещение модели питомца
	scale = 1, -- Множитель размера модели питомца
	speed = 6, -- Скорость бега
	skin = 0, -- Смена скина на модели
	sequences = { -- Анимации питомца
		['idle'] = 'idle0', -- Анимация стояния
		['walk'] = 'walk_n', -- Анимация движения
	},
	
--	donate_price = 1, -- ОПЦИОНАЛЬНО (можно удалить), цена продажи питомца в донат магазине и описание
--	donate_desc = [[Питомец-корова из игры Minecraft.
--Вызвать можно через F4 -> Аксессуары]],
})


--rp.pets.Add("pet_yalta", {
--price = 10000, -- Продажа за внутриигровую валюту
--donate_price = 1, 
--donate_desc = [[Питомец тестовый
--Вызвать можно через F4 -> Аксессуары]],
--name = "Ялта", -- Имя пета
--model = "models/jerry/mutants/stalker_anomaly_pseudodog.mdl", -- Моделька
--sound = "hgn/stalker/creature/dog/bdog_idle_1.wav", -- Звук при спавне/тп/событиях
--spawn_effect = "mcsd_dust", -- Эффект появления
--z_offset = 0, -- Смещение по высоте
--scale = 0.75, -- Размер
--speed = 6,
--skin = 0,
--sounds = { -- Звуки на определенные события
 --   ['kill'] = 'hgn/stalker/creature/dog/bdog_panic_2.wav', -- При убийстве
  --  ['down'] = 'hgn/stalker/creature/dog/bdog_hurt_2.wav', -- При ноке владельца
    --['wait'] = 'hgn/stalker/creature/dog/bdog_idle_4.wav', -- Ожидание (афк)
--},
--sequences = { -- Анимации
--    ['idle'] = 'idle2', -- Ожидание
  --  ['walk'] = 'walk', -- Ходьба
    --['run']  = 'run', -- Бег
--    ['kill'] = 'wave', -- Убийство игроком
  --  ['down'] = 'sit_ground', -- Нок владельца
    --['wait'] = 'sleep', -- Ожидание (афк)
--},
--})