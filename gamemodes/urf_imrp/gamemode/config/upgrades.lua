
if isSerious then return end

rp.cfg.DiscountSettings = 
{
	interval = 24,  -- Часы
	count = 3
}

rp.cfg.AltPriceList = 
{
	Interval = 72, -- Часы
	Count = 3,
	List = 
	{
		-- ['UID предмета'] = Альтернативная цена в валюте
		--['3kk_RP_Cash'] = 121000,
		--['2kk_RP_Cash'] = 91000,
		--['1kk_RP_Cash'] = 41000,
		--['600k_RP_Cash'] = 25000,
		--['300k_RP_Cash'] = 13000
	}
}

-- Misc

--rp.shop.Add('Разблокировать всё', 'unlock_everything')
--    :SetCat('Основное')
--	:SetDesc([[
--		Разблокировать все профессии.
--
--		Цена подсчитывается с учётом уже разблокированных вами профессий.
--	]])
--	:SetPrice(50)
--	:SetStackable(false)
--	:SetNetworked(true)
--	:SetGetPrice(function(self, pl)
--		local s = 0
--		local t = 0
--		for k, v in pairs(rp.teams) do
--			if v.unlockTime then
--				t = t + math.max(v.unlockTime - pl:GetPlayTime(), 0) / 720
--				print(t)
--			end
--			if v.unlockPrice && !pl:TeamUnlocked(v) then
--				s = s + (v.unlockPrice / 1000)
--			end
--		end
--		print(s, t)
--		return math.floor(s)
--	end)

rp.shop.Add( "Эмоции+: Уникальные анимации", "shopacts_extra" )
    :SetCat( "Основное" )
    :SetPrice(450)
    :SetEmoteActs({
		"boneless",
		"breakdown",
		"dancemoves",
		"discofever",
		"electroshuffle",
		"sexy",
		"floss",
		"fresh",
		"gentleman",
		"groove",
		"hype",
		"dabe",
		"orangejustice",
		"poplock",
		"rambunctious",
		"swipe",
		"takethel",
		"trueheart",
		"twist",
		"happy",
		"wiggle",
		"youreawesome"
	})
    :SetDesc([[Включает в себя 21 новую анимацию: танцы, флекс и даб]])

rp.shop.Add('Набор Лоялиста', 'kit_start')
	:SetCat('Основное')
	:SetDesc([[Набор Лоялиста включает в себя т.2500, 15 часов игрового времени и VIP статус на 1 день.

Пакет доступен для покупки один раз.]])
	:SetPrice(100)
	:SetStackable(false)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(2500)
		pl:AddPlayTime(15 * 3600)
		if pl:GetRank() == 'user' then
			RunConsoleCommand('urf', 'setgroup', pl:SteamID(), 'vip', '24h', 'user')
		end
	end)
	:SetDiscount(0.3)

	
rp.shop.Add('Сумка с патронами', 'perma_ammo')
	:SetCat('Основное')
	:SetDesc('При каждом возраждении вам выдаётся сумка с 60 патронами каждого вида.\nМожно докупать.')
	:SetPrice(50)
	:SetStackable(true)
	:SetOnBuy(function(self, pl)
		pl:GiveAmmos(pl:GetUpgradeCount('perma_ammo'), true)
	end)

rp.shop.Add('Плохой аппетит', 'no_hunger')
	:SetCat('Основное')
	:SetDesc('Продолжительность сытости и мера насыщения едой увеличены в 2 раза.')
	:SetPrice(70)
	:SetDiscount(0.4)
	:SetStackable(false)
	:SetOnBuy(function(self, pl)
		pl:SetHungerRateMultiplier(2)
	end)

--if SERVER then
--	hook.Add("PlayerHasHunger", function(ply)
--		if ply:HasUpgrade('no_hunger') then return false end
--	end)
--end

rp.shop.Add("Увеличение инвентаря", 'Inventory_Upgrade')
	:SetCat('Основное')
	:SetDesc('Увеличивает инвентарь на 5 ячеек')
	:SetPrice(25)
	:SetCanBuy(function(self, pl)
		return pl:isCanInvUpgrade(), 'Лимит достигнут'
	end)
	:SetOnBuy(function(self, pl)
		pl:addInvSlots()
	end)

/*
rp.shop.Add('Большая сумка', 'pocket_space_2')
	:SetCat('Основное')
	:SetDesc('Место в твоей сумке повысится на 2 слота.\nМожно докупать.')
	:SetPrice(30)
	:SetGetPrice(function(self, pl)
		local cost = 0
		if pl:HasUpgrade(self:GetUID()) then
			cost = self.Price * (pl:GetUpgradeCount(self:GetUID()) * 0.5)
		end
		return self.Price + cost
	end)
	:SetSales(0.4, 0.5)
	--:SetNetworked(true)
*/

rp.shop.Add('Крутая Организация', 'org_prem')
	:SetCat('Основное')
	:SetDesc([[
		- 500 участников место 50	
		- 16 рангов вместо 5
	]])
	:SetPrice(30)
	:SetStackable(false)
	:SetNetworked(true)

rp.shop.Add('Лимит пропов', 'prop_limit_15')
	:SetCat('Основное')
	:SetDesc('Добавлен к вашему лимиту + 15 пропов.\nМожно докупать.')
	:SetPrice(30)
	:SetGetPrice(function(self, pl)
		return ((pl:GetUpgradeCount('prop_limit_15') + 1) * self.Price)
	end)


rp.shop.Add('Броня', 'armor')
	:SetCat('Основное')
	:SetDesc('Добавляет 33 брони при спавне.\nМожно увеличить до 165.')
	:SetPrice(57)
	:SetCanBuy(function(self, pl)
		return pl:GetUpgradeCount(self:GetUID()) < 5, 'Лимит достигнут'
	end)
	:SetGetPrice(function(self, pl)
		return ((pl:GetUpgradeCount(self:GetUID()) + 1) * self.Price)
	end)
	:SetOnBuy(function(self, pl)
		pl:GiveArmor(33)
	end)



rp.shop.Add('Здоровье', 'max_health')
	:SetCat('Основное')
	:SetDesc('Увлечивает ваше максимальное здоровье на 25 спавне.\nМожно увеличить до 100.')
	:SetPrice(135)
	:SetDiscount(0.2)
	:SetCanBuy(function(self, pl)
		return pl:GetPlayTime() > 200 * 3600 && pl:GetUpgradeCount(self:GetUID()) < 4, pl:GetUpgradeCount(self:GetUID()) >= 4 && 'Лимит достигнут' || 'Доступно для опытных игроков (200 часов)'
	end)
	:SetGetPrice(function(self, pl)
		return ((pl:GetUpgradeCount(self:GetUID()) + 1) * self.Price)
	end)
	:SetOnBuy(function(self, pl)
		pl:AddMaxHealth(25)
	end)



if (SERVER) then
	local limit = rp.cfg.PropLimit
	hook('PlayerSpawnProp', 'PropUpgrade.PlayerSpawnProp', function(pl)
		local l = limit

		if pl:IsVIP() then
			l = l + 20
		end

		local upgradeCount = pl:GetUpgradeCount('prop_limit_15')
		if (upgradeCount ~= 0) then
			l = l + (15 * upgradeCount)
		end

		if (pl:GetCount('props') >= l) then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('SboxPropLimit'))
			return false
		end
	end)
end

local sayings = {
	'# самый крутой!',
	'# богат - # крут',
	'° ͜ʖ ͡° # ͡° ͜ʖ ͡°',
	'Спасибо #, спасибо за вашу щедрость',
	'Сервер говорит спасибо #!',
	'# крутой, дружите с ним!',
}
rp.shop.Add('Оповещение', 'announcement')
	:SetCat('Основное')
	:SetDesc('Случайное Оповещение о вас на весь сервер.')
	:SetPrice(5)
	:SetOnBuy(function(self, pl)
		local msg = string.gsub(sayings[math.random(#sayings)], '#', pl:Name())
		RunConsoleCommand('urf', 'tellall', msg)
	end)

rp.shop.Add('1000 часов', '1000h')
	:SetCat('Время игры')
	:SetDesc('Добавляет 1000 часов на твой аккаунт.\nЭкономия 1000 руб')
	:SetPrice(4400)
	:SetDiscount(0.4)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(1000 * 3600)
	end)
	
rp.shop.Add('500 часов', '500h')
	:SetCat('Время игры')
	:SetDesc('Добавляет 500 часов на твой аккаунт.\nЭкономия 500 руб')
	:SetPrice(2200)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(500 * 3600)
	end)

rp.shop.Add('200 часов', '200h')
	:SetCat('Время игры')
	:SetDesc('Добавляет 200 часов на твой аккаунт.\nЭкономия 100 руб')
	:SetPrice(990)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(200 * 3600)
	end)
	
rp.shop.Add('100 часов', '100h')
	:SetCat('Время игры')
	:SetDesc('Добавляет 100 часов на твой аккаунт.\nЭкономия 50 руб')
	:SetPrice(490)
	:SetSales(0.4)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(100 * 3600)
	end)
	
rp.shop.Add('80 часов', '80h')
	:SetCat('Время игры')
	:SetDesc('Добавляет 80 часов на твой аккаунт.\nЭкономия 20 руб')
	:SetPrice(400)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(80 * 3600)
	end)
	
rp.shop.Add('40 часов', '40h')
	:SetCat('Время игры')
	:SetDesc('Добавляет 40 часов на твой аккаунт.')
	:SetPrice(220)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(40 * 3600)
	end)
	
rp.shop.Add('20 часов', '20h')
	:SetCat('Время игры')
	:SetDesc('Добавляет 20 часов на твой аккаунт.')
	:SetPrice(100)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(20 * 3600)
	end)

rp.shop.Add('10 часов', '10h')
	:SetCat('Время игры')
	:SetDesc('Добавляет 10 часов на твой аккаунт.')
	:SetPrice(50)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(10 * 3600)
	end)

rp.shop.Add('5 часов', '5h')
	:SetCat('Время игры')
	:SetDesc('Добавляет 5 часов на твой аккаунт.')
	:SetPrice(25)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(5 * 3600)
	end)

-- Cash Packs
	
rp.shop.Add('Т 3,000,000', '3kk_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет Т 3,000,000 на твой аккаунт.\nБожественная экономия.')
	:SetPrice(2100)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(3000000)
	end)
	
rp.shop.Add('Т 2,000,000', '2kk_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет Т 2,000,000 на твой аккаунт.\nЭкономия 500 руб.')
	:SetPrice(1575)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(2000000)
	end)
	
rp.shop.Add('Т 1,000,000', '1kk_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет Т 1,000,000 на твой аккаунт.\nЭкономия 200 руб.')
	:SetPrice(840)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(1000000)
	end)

rp.shop.Add('Т 600,000', '600k_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет Т 600,000 на твой аккаунт.\nЭкономия 100 руб.')
	:SetPrice(525)
	:SetDiscount(0.25)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(600000)
	end)

rp.shop.Add('Т 300,000', '300k_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет Т 300,000 на твой аккаунт.\nЭкономия 50 руб.')
	:SetPrice(260)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(300000)
	end)

rp.shop.Add('Т 150,000', '150k_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет Т 150,000 на твой аккаунт.\nЭкономия 15 руб.')
	:SetPrice(140)
	:SetDiscount(0.15)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(150000)
	end)

rp.shop.Add('Т 100,000', '100k_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет Т 100,000 на твой аккаунт')
	:SetPrice(100)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(100000)
	end)
	
rp.shop.Add('Т 50,000', '50k_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет Т 50,000 на твой аккаунт')
	:SetPrice(50)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(50000)
	end)

rp.shop.Add('Т 25,000', '25k_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет Т 25,000 на твой аккаунт')
	:SetPrice(25)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(25000)
	end)
	
-- Ranks
/*
rp.shop.Add('VIP', 'VIP')
	:SetCat('Основное')
	:SetDesc([[Даётся навсегда

		- Особые VIP Профессии
		- Все профессии бесплатны
		- 20 дополнитеьных пропов
		- Отсутсвует лимит на профессии
		- Доступна команда /job
		- VIP статус в Discord
	]])
	:SetPrice(450)
	:SetDiscount(0.3)
	:SetCanBuy(function(self, pl)
		return !(pl:IsAdmin() || (pl:IsVIP() && (pl:HasUpgrade('vip') or pl:HasUpgrade('VIP') or pl:HasUpgrade('vip_package') or pl:HasUpgrade('moderator') or pl:HasUpgrade('admin') or pl:HasUpgrade('moderator_package') or pl:HasUpgrade('admin_package')))), 'Вы уже VIP!'
	end)
	:SetOnBuy(function(self, pl)
		local msg = string.gsub(sayings[math.random(#sayings)], '#', pl:Name())
		RunConsoleCommand('urf', 'tellall', msg)
		if !pl:IsAdmin() then
			ba.data.SetRank(pl, 'vip', 'vip' , 0)
		end
	end)
*/

rp.shop.Add('Модератор', 'moderator')
	:SetCat('Привелегии')
	:SetDesc([[Даётся навсегда

		Все команды и возможности VIP плюс:
		/adminbase (админ база)
		/freeze (заморозить и разморозить)
		/jail (посадить в тюрьму)
		/mute, /mutevoice, /muteсhat (заткнуть текстовый / голосовой чат)
		/goto, /tp, /return (телепортация)
		/denyteamvote (отменить голосование на разжалование)
		/pe (список действий игрока)
		/menu (админ меню)

		Возможности в админ моде (/adminmode):
		- Видеть логи сервера через консоль
		- Видеть, отвечать и отклонять жалобы игроков
		- Доступ к професии Админ

		Доступ к особой професии Модератора]])
	:SetGetPrice(function(self, pl)
		if pl:HasUpgrade('VIP') or pl:HasUpgrade('vip') or pl:HasUpgrade('VIP_Package') then
			return 500
		else
			return 800
		end
	end)
	:SetCanBuy(function(self, pl)
		if pl:GetRank() == 'moderator' then
			return false, 'Вы уже в числе Администрации!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'setgroup', pl:SteamID(), 'moderator')
	end)


rp.shop.Add('Администратор', 'admin')
	:SetCat('Привелегии')
	:SetDesc([[Даётся навсегда

		Все команды и возможности Модератора и VIP плюс:
		/setjob (изменить профессию)
		/unwanted (отменить розыск)
		/unarrest (отменить арест)
		/unwarrant (отменить розыск)
		/viewpocket (просмотреть сумку)
		/spectate (наблюдать от лица игрока)
		/sg (снимок экрана игрока)
		/ban (забанить игрока)
		/adminmode (перейти в админ мод)

		Возможности в админ моде (/adminmode):
		- Тоскать игроков физ ганом
		- Noclip (проходить сквозь стены)
		- Доступ к пропам игрока (двигать, удалить)

		Доступ к особой професии Администратора
	]])
	:SetGetPrice(function(self, pl)
		if pl:HasUpgrade('VIP') or pl:HasUpgrade('vip') or pl:HasUpgrade('VIP_Package') then
			return 1000
		elseif pl:HasUpgrade('moderator') or pl:HasUpgrade('moderator_package') then
			return 500
		else
			return 1300
		end
	end)
	:SetCanBuy(function(self, pl)
		if pl:GetRank() == 'admin' then
			return false, 'Вы уже в числе Администрации!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'setgroup', pl:SteamID(), 'admin')
	end)


-- Events
/*
rp.shop.Add('Паркур Ивент', 'event_parkour')
	:SetCat('Ивенты')
	:SetDesc('Каждый сможет использовать навыки паркуриста в течении получаса')
	:SetPrice(30)
	:SetCanBuy(function(self, pl)
		if rp.EventIsRunning('Parkour') then
			return false, 'Этот Ивент уже идёт!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'startevent', 'Parkour', '30mi')
	end)

rp.shop.Add('Ивент Пожиратель', 'event_burger')
	:SetCat('Ивенты')
	:SetDesc('Каждый может превратиться в Бургер и убегать от пожирателей.\nИли стать пожирателем и догонять бургер чтобы его съесть и не умереть от голода.')
	:SetPrice(25)
	:SetCanBuy(function(self, pl)
		if rp.EventIsRunning('BURGATRON') then
			return false, 'This event is already running!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'startevent', 'burgatron', '30mi')
	end)
*/

rp.shop.Add('VIP Ивент', 'event_vip')
	:SetCat('Ивенты')
	:SetDesc('Каждый будет иметь возможность использовать VIP привилегии в течении получаса')
	:SetPrice(35)
	:SetDiscount(0.1)
	:SetCanBuy(function(self, pl)
		if rp.EventIsRunning('VIP') then
			return false, 'Этот Ивент уже идёт!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'startevent', 'VIP', '30mi')
	end)


rp.shop.Add('Ивент Зарплаты', 'event_salary')
	:SetCat('Ивенты')
	:SetDesc('Каждый получит двойную зарплату в течение получаса')
	:SetPrice(20)
	:SetCanBuy(function(self, pl)
		if rp.EventIsRunning('Salary') then
			return false, 'Этот Ивент уже идёт!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'startevent', 'salary', '30mi')
	end)

rp.shop.Add('Ивент Притеров', 'event_printer')
	:SetCat('Ивенты')
	:SetDesc('Все принтеры будут печатать в 2 раза больше в течение получаса')
	:SetPrice(60)
	:SetCanBuy(function(self, pl)
		if rp.EventIsRunning('Printer') then
			return false, 'This event is already running!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'startevent', 'printer', '30mi')
	end)

rp.shop.Add('Vape Wave', 'event_vape')
	:SetCat('Ивенты')
	:SetDesc('Все получают электронную сигарету при спавне в течение 5 минут')
	:SetPrice(50)
	:SetDiscount(0.15)
	:SetCanBuy(function(self, pl)
		if rp.EventIsRunning('VapeWave') then
			return false, 'Этот Ивент уже идёт!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'startevent', 'VapeWave', '5mi')
	end)

rp.shop.Add('Танцевальный ивент', 'event_dance')
	:SetCat('Ивенты')
	:SetDesc('Все могут использовать танцевальные анимации в течение получаса')
	:SetPrice(50)
	:SetDiscount(0.15)
	:SetCanBuy(function(self, pl)
		if rp.EventIsRunning('DanceEvent') then
			return false, 'Этот Ивент уже идёт!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'startevent', 'DanceEvent', '30mi')
	end)


if !isSerious then
rp.shop.Add('Spinner-Вечеринка', 'event_spinner')
	:SetCat('Ивенты')
	:SetDesc('Все получают спиннер при спавне в течение 10 минут')
	:SetPrice(50)
	:SetCanBuy(function(self, pl)
		if rp.EventIsRunning('SpinnerEvent') then
			return false, 'Этот Ивент уже идёт!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'startevent', 'SpinnerEvent', '10mi')
	end)
end
-- Оружие
--rp.shop.Add('Камера', 'perma_camera')
--	:SetCat('Оружие')
--	:SetPrice(100)
--	:SetWeapon('gmod_camera')
/*
rp.shop.Add('Нож', 'perma_knife')
	:SetCat('Оружие')
	:SetPrice(80)
	:SetWeapon('swb_knife')
	:SetIcon('models/weapons/w_knife_t.mdl')
*/

	
rp.shop.Add('Кулаки', 'perma_fists')
	:SetCat('Оружие')
	:SetPrice(50)
	:SetWeapon('hl2_combo_fists')

rp.shop.Add('Электронная сигарета', 'perma_vape')
	:SetCat('Оружие')
	:SetPrice(70)
	:SetDiscount(0.20)
	:SetWeapon('weapon_vape')
	:SetStackable(true)
	:SetIcon('models/vape_pen.mdl')
	:SetDesc('Вам будет даваться Электронная Сигарета при возрождении.\nОна позволяет вам пускать струи белого дыма, подчеркивая ваше превосходство над окружающими.\nМожно улучшить, чтобы менять цвет дыма.')
	:SetCanBuy(function(self, pl)
		return pl:GetUpgradeCount(self:GetUID()) < 2, 'Круче некуда.'
	end)
	:SetGetPrice(function(self, pl)
		local cost = 0
		if pl:HasUpgrade(self:GetUID()) then
			cost = self.Price * (pl:GetUpgradeCount(self:GetUID()))
		end
		return self.Price + cost
	end)

rp.shop.Add('Монтировка', 'perma_crowbar')
	:SetCat('Оружие')
	:SetPrice(110)
	:SetWeapon('weapon_crowbar')
	:SetIcon('models/weapons/w_crowbar.mdl')




rp.shop.Add('USP', 'perma_pistol')
	:SetCat('Оружие')
	:SetPrice(120)
	:SetWeapon('swb_pistol')
	:SetIgnoreDisallow(true)
	:SetIcon('models/weapons/w_pistol.mdl')

rp.shop.Add('357 Magnum', 'perma_357')
	:SetCat('Оружие')
	:SetPrice(200)
	:SetWeapon('swb_357')
	:SetIgnoreDisallow(true)
	:SetIcon('models/weapons/w_357.mdl')



rp.shop.Add('MP7', 'perma_smg')
	:SetCat('Оружие')
	:SetPrice(250)
	:SetWeapon('swb_smg')
	:SetIgnoreDisallow(true)
	:SetIcon('models/weapons/w_smg1.mdl')


rp.shop.Add('SPAS-12', 'perma_shotgun')
	:SetCat('Оружие')
	:SetPrice(350)
	:SetWeapon('swb_shotgun')
	:SetIgnoreDisallow(true)
	:SetIcon('models/weapons/w_shotgun.mdl')


rp.shop.Add('AR2', 'perma_ar2')
	:SetCat('Оружие')
	:SetPrice(600)
	:SetDiscount(0.25)
	:SetWeapon('swb_ar2')
	:SetIgnoreDisallow(true)
	:SetIcon('models/weapons/w_irifle.mdl')

rp.shop.Add('Арбалет', 'perma_crossbow')
	:SetCat('Оружие')
	:SetPrice(900)
	:SetWeapon('swb_bow')
	:SetIgnoreDisallow(true)
	:SetIcon('models/weapons/w_crossbow.mdl')



rp.shop.Add('Мина (SLAM)', 'weapon_slam')
	:SetCat('Оружие')
	:SetPrice(1000)
	:SetWeapon('weapon_slam')
	:SetIgnoreDisallow(true)
	:SetIcon('models/weapons/w_slam.mdl')

rp.shop.Add('C4', 'weapon_c4')
	:SetCat('Оружие')
	:SetPrice(1600)
	:SetWeapon('weapon_c4')
	:SetIgnoreDisallow(true)
	:SetIcon('models/weapons/2_c4_planted.mdl')




rp.shop.Add('RPG', 'perma_rpg')
	:SetCat('Оружие')
	:SetPrice(3300)
	:SetWeapon('weapon_rpg')
	:SetIgnoreDisallow(true)
	:SetIcon('models/Weapons/w_rocket_launcher.mdl')
	:SetOnBuy(function(self, pl)
		local weps = pl:GetVar('PermaWeapons')
		weps[#weps + 1] = wep
		pl:SetVar('PermaWeapons', weps)

		RunConsoleCommand('urf', 'tellall', 'Большое спасибо ' .. pl:Name() .. ' за покупку RPG! Ты крутой!')
	end)

-- Профессии
rp.shop.Add('Голубь', 'job_pigeon')
	:SetCat('Профессии')
	:SetPrice(100)
	:SetDiscount(0.25)
	:SetDesc('Позволяет вам бездумно летать по карте и издавать противное птичье пение. После покупки находится в NPC Беженцов.')
	:SetTeam(TEAM_PIGEON)

rp.shop.Add('Ворона', 'job_crow')
	:SetCat('Профессии')
	:SetPrice(120)
	:SetDiscount(0.25)
	:SetDesc('Позволяет вам бездумно летать по карте и издавать мерзкое птичье пение. После покупки находится в NPC Беженцов.')
	:SetTeam(TEAM_CROW)

rp.shop.Add('Чайка', 'job_seagull')
	:SetCat('Профессии')
	:SetPrice(150)
	:SetDiscount(0.25)
	:SetDesc('Позволяет вам бездумно летать по карте и издавать отвратительные звуки чайки. После покупки находится в NPC Беженцов.')
	:SetTeam(TEAM_SEAGULL)


-- Права
rp.shop.Add('Хэд Админ+', 'unused') 
	:SetCat('Особые услуги') 
	:SetPrice(0) 
	:SetBuildInCategory(true) 
	:SetDesc('Вы можете приобрести права Хэд Администратора и выше.\n\nЦена обговаривается с консультантом.')
	:SetOnBuy(function(self, ply) end)
	:SetCanBuy(function() return SERVER end)

rp.shop.Add('Своя проффесия', 'unused') 
	:SetCat('Особые услуги') 
	:SetPrice(0) 
	:SetBuildInCategory(true) 
	:SetDesc('Вы можете приобрести свою личную проффесию с уникальным вооружением и скином, которая будет доступна только вам или членам вашей организации.\n\nЦена обговаривается с консультантом.')
	:SetOnBuy(function(self, ply) end)
	:SetCanBuy(function() return SERVER end)

rp.shop.Add('Своя фракция', 'unused') 
	:SetCat('Особые услуги') 
	:SetPrice(0) 
	:SetBuildInCategory(true) 
	:SetDesc('Вы можете приобрести свою личную фракцию с разными проффесиями, уникальным вооружением, скинами, а также собственную базу, которую вы сможете обустроить по вашему вкусу. Иметь доступ к ней будете только вы и члены организаций в зависимости от их ранга в вашей организации.\n\nЦена обговаривается с консультантом.')
	:SetOnBuy(function(self, ply) end)
	:SetCanBuy(function() return SERVER end)

rp.shop.Add('Спонсорство', 'unused') 
	:SetCat('Особые услуги') 
	:SetPrice(0) 
	:SetBuildInCategory(true) 
	:SetDesc('Если у вас возникло желание координально помочь проекту, вы можете обсудить это с консультантом.')
	:SetOnBuy(function(self, ply) end)
	:SetCanBuy(function() return SERVER end)

rp.shop.Add('Случайное холодное оружие', 'random_melee_weapon')
	:SetCat('Оружие')
	:SetPrice(50)
	:SetDesc('При каждом спавне вам будет выдавать случайное холодное оружие.')
	:SetOnBuy(function(self, ply) ply:Give(table.Random(rp.cfg.MeleeWeapons)) end)
	:SetStackable(false)


hook.Call('rp.AddUpgrades', GAMEMODE)