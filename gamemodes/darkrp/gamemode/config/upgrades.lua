-- "gamemodes\\darkrp\\gamemode\\config\\upgrades.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-- Misc

--rp.shop.Add('Разблокировать всё', 'unlock_everything')
--	:SetCat('Основное')
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

rp.cfg.DiscountSettings = {
    interval = 24 * 3,   -- В часах	
    count = 7            -- Количество товаров в ротации
    -- поставить в ротацию SetSales 5 штук
}

rp.cfg.AltPriceList = {
	Interval = 24 * 7,
	Count = 5
}

rp.shop.Add( "Набор голосов", "voicepack" )
    :SetCat( "Основное" )
    :SetDesc( [[Вы получите доступ к 4 уникальным голосам, которые можно будет использовать для произнесения ваших сообщений в игровом чате.

Смена голоса находится в C-меню.]] )
    :SetPrice( 199 )
    :SetNetworked( true )
    :SetStackable( false )

rp.shop.Add( "Эмоции+: Уникальные анимации", "shopacts_extra" )
    :SetCat( "Основное" )
    :SetPrice(549)
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
/*	
rp.shop.Add('Набор Ручная Пушка', 'special_5675')
:SetCat('SALE')
:SetPrice(3300)
:SetStackable(false)
:SetIcon('models/weapons/w_python.mdl')
:SetWeapon('swb_valera')
:SetDesc('Уникальный набор в честь начала лета, включает в себя самый страшный короткоствольный револьвер в мире, 135 игровых часов и 100000 Грн. Протестировать оружие Вы можете в профессии Метти, в Ренегатах.')
:SetOnBuy(function(self, pl)
	  local weps = pl:GetVar('PermaWeapons')
	  weps[#weps + 1] = wep
	  pl:SetVar('PermaWeapons', weps)
	 pl:AddMoney(100000)
	pl:AddPlayTime(135 * 3600)
end)
:SetHidden(true)

rp.shop.Add('Набор Меткий Стрелок', 'special_762')
:SetCat('SALE')
:SetPrice(2640)
:SetStackable(false)
:SetIcon('models/weapons/w_psg1.mdl')
:SetWeapon('swb_psg1')
:SetDesc('Уникальный набор, доступный в течение ограниченного времени, включает в себя автоматическую винтовку PSG-1 на аккаунт, 150 игровых часов и 50000 Грн. ')
:SetOnBuy(function(self, pl)
	  local weps = pl:GetVar('PermaWeapons')
	  weps[#weps + 1] = wep
	  pl:SetVar('PermaWeapons', weps)
	 pl:AddMoney(50000)
	pl:AddPlayTime(150 * 3600)
end)
:SetHidden(true)

rp.shop.Add('Набор Лазутчик', 'special_198')
:SetCat('SALE')
:SetPrice(1300)
:SetStackable(false)
:SetIcon('models/weapons/w_bizon.mdl')
:SetWeapon('swb_bizonsilens')
:SetDesc('Уникальный набор, доступный в течение ограниченного времени, включает в себя бесшумный пистолет-пулемет Бизон на аккаунт, 100 игровых часов и 25 000 Грн. ')
:SetOnBuy(function(self, pl)
	  local weps = pl:GetVar('PermaWeapons')
	  weps[#weps + 1] = wep
	  pl:SetVar('PermaWeapons', weps)
	 pl:AddMoney(25000)
	pl:AddPlayTime(100 * 3600)
end)
:SetHidden(true)

rp.shop.Add('Предложение недели', 'special_2105')
	:SetCat('SALE')
	:SetPrice(1300)
	:SetStackable(false)
	:SetIcon('models/weapons/w_m4beowolf.mdl')
	:SetWeapon('swb_m4_kekler')
	:SetDesc('Специальное предложение действует до воскресения. При покупке вы получите уникальную М4 на свой аккаунт, 100 игровых часов и 25 000 грн. Предложение заканчивается 27.05')
	:SetOnBuy(function(self, pl)
  		local weps = pl:GetVar('PermaWeapons')
  		weps[#weps + 1] = wep
  		pl:SetVar('PermaWeapons', weps)
 		pl:AddMoney(25000)
		pl:AddPlayTime(100 * 3600)
	end)
	:SetHidden(true)
*/
rp.shop.Add('Пакет Бывалого', 'kit_start')
	:SetCat('Основное')
	:SetDesc([[Вы получите 1250 Гривен, 15 часов игрового времени и VIP статус на 1 день.

Пакет доступен для покупки один раз.]])
	:SetPrice(110)
	:SetStackable(false)
	:SetDiscount(0.3) -- не убирать никогда, в этом суть пакета

	:SetOnBuy(function(self, pl)
		pl:AddMoney(1250)
		pl:AddPlayTime(15 * 3600)
		if pl:GetRank() == 'user' then
			RunConsoleCommand('urf', 'setgroup', pl:SteamID(), 'vip', '24h', 'user')
		end
	end)
/*
	rp.shop.Add('Набор выжившего', 'special_2111')
	:SetCat('SALE')
	:SetPrice(1600)
	:SetStackable(false)
	:SetIcon('models/weapons/w_skorpion.mdl')
	:SetWeapon('swb_scorpion')
	:SetDesc('Специальное предложение действует 2 недели. При покупке вы получите уникальный ПП Scorpion на свой аккаунт, 154 игровых часов и 31150 грн.')
	:SetOnBuy(function(self, pl)
  		local weps = pl:GetVar('PermaWeapons')
  		weps[#weps + 1] = wep
  		pl:SetVar('PermaWeapons', weps)
 		pl:AddMoney(31150)
		pl:AddPlayTime(154 * 3600)
	end)
	:SetHidden(true)
*/
rp.shop.Add('Сумка с патронами', 'perma_ammo')
	:SetCat('Основное')
	:SetDesc('При каждом возрождении вам выдаётся дополнительные 2 пачки патронов каждого вида.\nМожно докупать.')
	:SetPrice(79)
	:SetSales(0.1, 0.15, 0.2)
	:SetStackable(true)
	:SetOnBuy(function(self, pl)
		pl:GiveAmmos(pl:GetUpgradeCount('perma_ammo'), true)
	end)

rp.shop.Add('Плохой аппетит', 'no_hunger')
	:SetCat('Основное')
	:SetDesc('Вам больше не надо кушать (вы не умираете от голода).')
	:SetPrice(99)
	:SetSales(0.1)
	:SetStackable(false)


if SERVER then
	hook.Add("PlayerHasHunger", function(ply)
		if ply:HasUpgrade('no_hunger') then return false end
	end)
end

rp.shop.Add("Увеличение инвентаря", 'Inventory_Upgrade')
	:SetCat('Основное')
	:SetDesc('Увеличивает инвентарь на 5 ячеек')
	:SetPrice(40)
	:SetCanBuy(function(self, pl)
		return pl:isCanInvUpgrade(), 'Лимит достигнут'
	end)
	:SetOnBuy(function(self, pl)
		pl:addInvSlots()
	end)
	:SetGetPrice(function(self, pl)
		local cost = 0
		local upg_count = (pl:HasUpgrade('Inventory_Upgrade') and pl:GetUpgradeCount('Inventory_Upgrade') or 0) + (pl:HasUpgrade('pocket_space_2') and pl:GetUpgradeCount('pocket_space_2') or 0)
		
		if upg_count > 0 then
			cost = self.Price * upg_count * 0.5
		end
		
		return self.Price + cost
	end)

/*
rp.shop.Add('Большая сумка', 'pocket_space_2')
	:SetCat('Основное')
	:SetDesc('Место в твоей сумке повысится на 2 слота.\nМожно докупать.')
	:SetPrice(30)
	:SetSales(0.4)
	:SetGetPrice(function(self, pl)
		local cost = 0
		if pl:HasUpgrade(self:GetUID()) then
			cost = self.Price * (pl:GetUpgradeCount(self:GetUID()) * 0.5)
		end
		return self.Price + cost
	end)
	--:SetNetworked(true)
*/
rp.shop.Add('Крутая Организация', 'org_prem')
	:SetCat('Основное')
	:SetDesc([[
		- 125 участников место 50
		- 10 рангов вместо 5
	]])
	:SetPrice(219)
	:SetSales(0.4)
	:SetStackable(false)
	:SetNetworked(true)

rp.shop.Add('Лимит пропов', 'prop_limit_15')
	:SetCat('Основное')
	:SetDesc('Добавлен к вашему лимиту + 15 пропов.\nМожно докупать.')
	:SetPrice(45)
	:SetSales(0.1, 0.15, 0.2)
	:SetGetPrice(function(self, pl)
		return ((pl:GetUpgradeCount('prop_limit_15') + 1) * self.Price)
	end)

rp.shop.Add('Броня', 'armor')
	:SetCat('Основное')
	:SetDesc('Добавляет 20 брони при спавне.\nМожно увеличить до 100.')
	:SetPrice(119)
	:SetSales(0.1)
	:SetCanBuy(function(self, pl)
		return pl:GetUpgradeCount(self:GetUID()) < 5, 'Лимит достигнут'
	end)
	:SetGetPrice(function(self, pl)
		return ((pl:GetUpgradeCount(self:GetUID()) + 1) * self.Price)
	end)
	:SetOnBuy(function(self, pl)
		pl:GiveArmor(20)
	end)

rp.shop.Add('Здоровье', 'max_health')
	:SetCat('Основное')
	:SetDesc('Увлечивает ваше максимальное здоровье на 25 спавне.\nМожно увеличить до 150.')
	:SetPrice(219)
	:SetSales(0.1)
	:SetCanBuy(function(self, pl)
		return pl:GetPlayTime() > 200 * 3600 && pl:GetUpgradeCount(self:GetUID()) < 6, pl:GetUpgradeCount(self:GetUID()) >= 6 && 'Лимит достигнут' || 'Доступно для опытных игроков (200 часов)'
	end)
	:SetGetPrice(function(self, pl)
		return ((pl:GetUpgradeCount(self:GetUID()) + 1) * self.Price)
	end)
	:SetOnBuy(function(self, pl)
		if pl:GetMaxHealth() < 250 then
			pl:AddMaxHealth(pl:GetMaxHealth() < 225 and 25 or 250 - pl:GetMaxHealth())
		end
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
	'# самый блатной!',
	'# мажор - # топ',
	'° ?? ?° # ?° ?? ?°',
	'Спасибо #, спасибо за подгон',
	'Не гони, спасибо #!',
	'# топ поц!',
}
rp.shop.Add('Оповещение', 'announcement')
	:SetCat('Основное')
	:SetDesc('Случайное Оповещение о вас на весь сервер.')
	:SetPrice(5)
	:SetSales(0.2)
	:CanAltPrice(25000)
	:SetOnBuy(function(self, pl)
		local msg = string.gsub(sayings[math.random(#sayings)], '#', pl:Name())
		RunConsoleCommand('urf', 'tellall', msg)
	end)


local tips = {
	'#-из-за-него-стало-чуточку-теплее!',
	'#-подкинул-на-перекус-или-бухлишко!',
	'#-сделал-этот-день-чуточку-лучше!',
}
rp.shop.Add('На чай мапперу', 'mapper_tip')
	:SetCat('Основное')
	:SetDesc('Отблагодарить маппера за новую карту прямой отправкой денег на его счёт!')
	:SetPrice(20)
	:SetSales(0.4)
	:SetOnBuy(function(self, pl)
		local msg = string.gsub(tips[math.random(#tips)], '#', pl:Name())
		RunConsoleCommand('urf', 'tellall', msg)
	end)
/*
rp.shop.Add('ВАЗ 2121 - Нива', 'car_raf')
	:SetCat('Основное')
	:SetDesc('После приобретения вы сможете покупать Ниву в F4 Магазине.')
	:SetStackable(false)
	:SetIcon('models/tails models/dayz/niva/niva.mdl')
	:SetNetworked(true)
	:SetSales(0.25)
	:SetGetPrice(function(self, pl)
		if pl:HasUpgrade('car_car') then
			return 1350
		elseif pl:HasUpgrade('car_lada') then

			return 2850
		else
			return 3850
		end
	end)

rp.shop.Add('Лада "Шестёрка"', 'car_car')
	:SetCat('Основное')
	:SetDesc('После приобретения вы сможете покупать шестёрку в трех вариациях(Классика, Восточная, Сгнившая) в F4 Магазине. ')
	:SetStackable(false)
	:SetIcon('models/sadtrixie/2103.mdl')
	:SetNetworked(true)
	:SetSales(0.15)
	:SetGetPrice(function(self, pl)
		if pl:HasUpgrade('car_lada') then
			return 1675
		else
			return 3250
		end
	end)

rp.shop.Add('RAF 2203', 'car_lada')
	:SetCat('Основное')
	:SetPrice(1575)
	:SetDesc('После приобретения вы сможете покупать машину в F4 Магазине.')
	:SetStackable(false)
	:SetIcon('models/vehicles/7seatvan.mdl')
	:SetNetworked(true)
*/
-- Time packs

rp.shop.Add('1000 часов', '1000h')
	:SetCat('Время')
	:SetDesc('Добавляет 1000 часов на твой аккаунт.\nБожественная экономия.')
	:SetPrice(5099)	
	:SetSales(0.2, 0.25, 0.3)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(1000 * 3600)
	end)
	
rp.shop.Add('500 часов', '500h')
	:SetCat('Время')
	:SetDesc('Добавляет 500 часов на твой аккаунт.\nЭкономия 1350 руб')
	:SetPrice(2549)
	:SetSales(0.2, 0.25, 0.3)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(500 * 3600)
	end)

rp.shop.Add('350 часов', '350h')
	:SetCat('Время')
	:SetDesc('Добавляет 350 часов на твой аккаунт.\nЭкономия 760 руб')
	:SetPrice(2049)
	:SetSales(0.2, 0.25, 0.3)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(350 * 3600)
	end)

rp.shop.Add('220 часов', '220h')
	:SetCat('Время')
	:SetDesc('Добавляет 220 часов на твой аккаунт.\nЭкономия 462 руб')
	:SetPrice(1249)
	:SetSales(0.2, 0.25, 0.3)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(220 * 3600)
	end)
	
	rp.shop.Add('150 часов', '150h')
	:SetCat('Время')
	:SetDesc('Добавляет 150 часов на твой аккаунт.\nЭкономия 290 руб')
	:SetPrice(879)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(150 * 3600)
	end)

rp.shop.Add('100 часов', '100h')
	:SetCat('Время')
	:SetDesc('Добавляет 100 часов на твой аккаунт.\nЭкономия 195 руб')
	:SetPrice(595)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(100 * 3600)
	end)
	
rp.shop.Add('80 часов', '80h')
	:SetCat('Время')
	:SetDesc('Добавляет 80 часов на твой аккаунт.\nЭкономия 138 руб')
	:SetPrice(494)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(80 * 3600)
	end)
	
rp.shop.Add('40 часов', '40h')
	:SetCat('Время')
	:SetDesc('Добавляет 40 часов на твой аккаунт\nЭкономия 69 руб.')
	:SetPrice(249)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(40 * 3600)
	end)
	
rp.shop.Add('20 часов', '20h')
	:SetCat('Время')
	:SetDesc('Добавляет 20 часов на твой аккаунт\nЭкономия 22 руб.')
	:SetPrice(121)
	:SetSales(0.25, 0.35)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(20 * 3600)
	end)
	
rp.shop.Add('10 часов', '10h')
	:SetCat('Время')
	:SetDesc('Добавляет 10 часов на твой аккаунт.')
	:SetPrice(66)
	:SetSales(0.25, 0.35)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(10 * 3600)
	end)
	
rp.shop.Add('5 часов', '5h') --50h
	:SetCat('Время')
	:SetDesc('Добавляет 5 часов на твой аккаунт.')
	:SetPrice(33)
	:SetOnBuy(function(self, pl)
		pl:AddPlayTime(5 * 3600)
	end)

-- Cash Packs

	
rp.shop.Add('450,000 ГРН', '3kk_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет 450,000 ГРН на твой аккаунт.\nБожественная экономия.')
	:SetPrice(2699)
	:SetSales(0.2, 0.25, 0.3)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(450000)
	end)
	
rp.shop.Add('300,000 ГРН', '2kk_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет 6,000,000 ГРН на твой аккаунт.\nЭкономия 830 руб.')
	:SetPrice(1869)
	:SetSales(0.2, 0.25, 0.3)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(300000)
	end)
	
rp.shop.Add('187,000 ГРН', '1_5kk_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет 187,000 ГРН на твой аккаунт.\nЭкономия 450 руб.')
	:SetPrice(1199)
	:SetSales(0.2, 0.25, 0.3)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(187000)
	end)

rp.shop.Add('125,000 ГРН', '1kk_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет 125,000 ГРН на твой аккаунт.\nЭкономия 260 руб.')
	:SetPrice(855)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(125000)
	end)

rp.shop.Add('75,000 ГРН', '600k_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет 75,000 ГРН на твой аккаунт.\nЭкономия 150 руб.')
	:SetPrice(515)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(75000)
	end)

rp.shop.Add('22,500 ГРН', '150k_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет 22,500 ГРН на твой аккаунт.\nЭкономия 38 руб.')
	:SetPrice(163)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(22500)
	end)

rp.shop.Add('15,000 ГРН', '100k_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет 15,000 ГРН на твой аккаунт\nЭкономия 20 руб.')
	:SetPrice(99)
	:SetSales(0.25, 0.35)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(15000)
	end)
	
rp.shop.Add('7000 ГРН', '50k_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет 7,000 ГРН на твой аккаунт')
	:SetPrice(54)
	:SetSales(0.25, 0.35)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(7000)
	end)

rp.shop.Add('3250 ГРН', '25k_RP_Cash')
	:SetCat('Валюта')
	:SetDesc('Добавляет 3,250 ГРН на твой аккаунт')
	:SetPrice(27)
	:SetOnBuy(function(self, pl)
		pl:AddMoney(3250)
	end)
	
-- Навыки    
rp.shop.Add( "1 очко навыков", "attsys_1pts" )
	:SetCat( "Навыки" )
	:SetPrice( 20 )
	:SetDesc('Добавляет 1 очко атрибутов на твой аккаунт.')
	:SetAttributePoints( 1 )

rp.shop.Add( "5 очко навыков", "attsys_5pts" )
	:SetCat( "Навыки" )
	:SetPrice( 99 )
	:SetDesc('Добавляет 5 очков атрибутов на твой аккаунт.')
	:SetAttributePoints( 5 )

rp.shop.Add( "10 очко навыков", "attsys_10pts" )
	:SetCat( "Навыки" )
	:SetPrice( 199 )
	:SetDesc('Добавляет 10 очков атрибутов на твой аккаунт.')
	:SetAttributePoints( 10 )

rp.shop.Add( "15 очко навыков", "attsys_15pts" )
	:SetCat( "Навыки" )
	:SetPrice( 249 )
	:SetDesc('Добавляет 15 очков атрибутов на твой аккаунт.')
	:SetAttributePoints( 15 )

rp.shop.Add( "30 очко навыков", "attsys_30pts" )
	:SetCat( "Навыки" )
	:SetPrice( 449 )
	:SetDesc('Добавляет 30 очков атрибутов на твой аккаунт.\nЭкономия 50 руб.')
	:SetAttributePoints( 30 )

rp.shop.Add( "50 очко навыков", "attsys_50pts" )
	:SetCat( "Навыки" )
	:SetPrice( 899 )
	:SetDesc('Добавляет 50 очков атрибутов на твой аккаунт.\nЭкономия 100 руб.')
	:SetAttributePoints( 50 )

rp.shop.Add( "75 очко навыков", "attsys_75pts" )
	:SetCat( "Навыки" )
	:SetPrice( 1349 )
	:SetDesc('Добавляет 75 очков атрибутов на твой аккаунт.\nЭкономия 150 руб.')
	:SetAttributePoints( 75 )

rp.shop.Add( "100 очко навыков", "attsys_100pts" )
	:SetCat( "Навыки" )
	:SetPrice( 1799 )
	:SetDesc('Добавляет 100 очков атрибутов на твой аккаунт.\nЭкономия 200 руб.')
	:SetAttributePoints( 100 )
-- Ranks
rp.shop.Add('VIP', 'VIP')
	:SetCat('Привилегии')
	:SetDesc([[Даётся навсегда

		- Особые VIP Профессии
		- Все профессии бесплатны
		- 20 дополнительных пропов
		- Отсутствует лимит на профессии
		- Доступна команда /job
		- VIP статус в Discord
	]])
	:SetPrice(399)
	:SetHidden(true)
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

local ranks_tree = {
	['moderator'] = {
		['moderator'] = true,
		['admin'] = true,
		['headadmin'] = true,
		['superadmin'] = true,
		['globaladmin'] = true,
	},
	['admin'] = {
		['admin'] = true,
		['headadmin'] = true,
		['superadmin'] = true,
		['globaladmin'] = true,
	},
	['headadmin'] = {
		['headadmin'] = true,
		['superadmin'] = true,
		['globaladmin'] = true,
	},
	['superadmin'] = {
		['superadmin'] = true,
		['globaladmin'] = true,
	},
	['globaladmin'] = {
		['globaladmin'] = true,
	},
}

rp.shop.Add('Модератор', 'moderator')
	:SetCat('Привилегии')
	:SetHidden(true)
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

		Дополнительные возможности:
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
		if ranks_tree['moderator'][pl:GetRank() or ''] then
			return false, 'Вы уже в числе Администрации!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'setgroup', pl:SteamID(), 'moderator')
	end)

rp.shop.Add('Администратор', 'admin')
	:SetCat('Привилегии')
	:SetHidden(true)
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
		if (pl:HasUpgrade('moderator') or pl:HasUpgrade('moderator_package')) and (pl:GetRank() == 'moderator') then
			return 500
			
		elseif pl:HasUpgrade('VIP') or pl:HasUpgrade('vip') or pl:HasUpgrade('VIP_Package') then
			return 1000
			
		else
			return 1300
		end
	end)
	:SetCanBuy(function(self, pl)
		if ranks_tree['admin'][pl:GetRank() or ''] then
			return false, 'Вы уже в числе Администрации!'
		end
		return true
	end)

rp.shop.Add('Администратор', 'admin_new')
	:SetCat('Привилегии')
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
		if (pl:HasUpgrade('moderator') or pl:HasUpgrade('moderator_package')) and (pl:GetRank() == 'moderator') then
			return 2200
			
		elseif pl:HasUpgrade('VIP') or pl:HasUpgrade('vip') or pl:HasUpgrade('VIP_Package') then
			return 2700
			
		else
			return 3000
		end
	end)
	:SetCanBuy(function(self, pl)
		if ranks_tree['admin'][pl:GetRank() or ''] then
			return false, 'Вы уже в числе Администрации!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'setgroup', pl:SteamID(), 'admin')
	end)
	:SetCustomCanSee(function(self, pl)
		local total_donated = pl:GetTotalDonated()
		return total_donated and total_donated >= 3000
	end)
	
rp.shop.Add('Head Admin', 'headadmin')
	:SetCat('Привилегии')
	:SetDesc([[Даётся навсегда и включает в себя:
		- Все возможности VIP статуса;
		- Все возможности администратора (/mute, /kick, /ban, /tp и т.д.);
		- Команда /slay, больше информации в меню /viewstaff;
		- Иммунитет к действиям ранга AdminPlus и ниже;
		- Возможность полета в РП профессии, при условии пресечения грубого нарушения, проведении ивента/разборок;
		- Доступ к админ-профессии HeadAdmin;
	]])
	:SetCanBuy(function(self, pl)
		if ranks_tree['headadmin'][pl:GetRank() or ''] then
			return false, 'Вы уже в числе Администрации!'
		end
		return true
	end)
	:SetGetPrice(function(self, pl)
		if pl:HasUpgrade('admin') and (pl:GetRank() == 'admin') then
			return 2700

		elseif pl:HasUpgrade('admin_new') and (pl:GetRank() == 'admin') then
			return 1000
			
		elseif (pl:HasUpgrade('moderator') or pl:HasUpgrade('moderator_package')) and (pl:GetRank() == 'moderator') then
			return 3200
			
		elseif pl:HasUpgrade('VIP') or pl:HasUpgrade('vip') or pl:HasUpgrade('VIP_Package') then
			return 3700
			
		else
			return 4000
		end
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'setgroup', pl:SteamID(), 'headadmin')
	end)
	:SetCustomCanSee(function(self, pl)
		local total_donated = pl:GetTotalDonated()
		return total_donated and total_donated >= 3000
	end)
	
rp.shop.Add('Super Admin', 'superadmin')
	:SetCat('Привилегии')
	:SetDesc([[Даётся навсегда и включает в себя:
			- Все возможности VIP статуса;
			- Все возможности администратора (/mute, /kick, /ban, /tp и т.д.);
			- Все возможности HeadAdmin (/slay, расширенный /viewstaff);
			- Иммунитет к действиям ранга HeadAdmin* и ниже;
			- Возможность полета в РП профессии, не нарушая РП процесс;
			- Доступ к админ-профессии SuperAdmin;
	]])
	:SetCanBuy(function(self, pl)
		if ranks_tree['superadmin'][pl:GetRank() or ''] then
			return false, 'Вы уже в числе Администрации!'
		end
		return true
	end)
	:SetGetPrice(function(self, pl)
		if pl:HasUpgrade('headadmin') and (pl:GetRank() == 'headadmin') then
			return 2000
			
		elseif pl:HasUpgrade('admin') and (pl:GetRank() == 'admin') then
			return 4700

		elseif pl:HasUpgrade('admin_new') and (pl:GetRank() == 'admin') then
			return 3000
			
		elseif (pl:HasUpgrade('moderator') or pl:HasUpgrade('moderator_package')) and (pl:GetRank() == 'moderator') then
			return 5200
			
		elseif pl:HasUpgrade('VIP') or pl:HasUpgrade('vip') or pl:HasUpgrade('VIP_Package') then
			return 5700
			
		else
			return 6000
		end
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'setgroup', pl:SteamID(), 'superadmin')
	end)
	:SetCustomCanSee(function(self, pl)
		local total_donated = pl:GetTotalDonated()
		return total_donated and total_donated >= 3000
	end)
	
rp.shop.Add('Global Admin', 'globaladmin')
	:SetCat('Привилегии')
	:SetIcon('models/items/hl2_gift.mdl')
	:SetDesc([[Даётся навсегда и включает в себя:
			- Все возможности VIP статуса;
			- Все возможности администратора (/mute, /kick, /ban, /tp и т.д.);
			- Все возможности HeadAdmin (/slay, расширенный /viewstaff);
			- Все возможности SuperAdmin (полет в РП профессиях);
			- Иммунитет к действиям ранга SuperAdmin* и ниже;
			- Изменение моделей игроков при помощи /setmodel;
			- Спавн нестандартных пропов, оружия, энтити и транспорта;
			- Выдача профессии при помощи /forcesetjob;
			- Использование команд на себе;
			- Доступ к админ-профессии GlobalAdmin;
	]])
	:SetCanBuy(function(self, pl)
		if ranks_tree['globaladmin'][pl:GetRank() or ''] then
			return false, 'Вы уже в числе Администрации!'
		end
		return true
	end)
	:SetGetPrice(function(self, pl)
		if pl:HasUpgrade('superadmin') and (pl:GetRank() == 'superadmin') then
			return 6000
			
		elseif pl:HasUpgrade('headadmin') and (pl:GetRank() == 'headadmin') then
			return 8000
			
		elseif pl:HasUpgrade('admin') and (pl:GetRank() == 'admin') then
			return 10700

		elseif pl:HasUpgrade('admin_new') and (pl:GetRank() == 'admin') then
			return 9000
			
		elseif (pl:HasUpgrade('moderator') or pl:HasUpgrade('moderator_package')) and (pl:GetRank() == 'moderator') then
			return 11200
			
		elseif pl:HasUpgrade('VIP') or pl:HasUpgrade('vip') or pl:HasUpgrade('VIP_Package') then
			return 11700
			
		else
			return 12000
		end
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'setgroup', pl:SteamID(), 'globaladmin')
	end)
	:SetCustomCanSee(function(self, pl)
		local total_donated = pl:GetTotalDonated()
		return total_donated and total_donated >= 3000
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
	:SetPrice(45)
	:SetSales(0.4, 0.45, 0.5)
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
	:SetPrice(45)
	:SetSales(0.4, 0.45, 0.5)
	:CanAltPrice(5000)
	:SetCanBuy(function(self, pl)
		if rp.EventIsRunning('Salary') then
			return false, 'Этот Ивент уже идёт!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'startevent', 'salary', '30mi')
	end)

rp.shop.Add('Ивент Принтеров', 'event_printer')
	:SetCat('Ивенты')
	:SetDesc('Все принтеры будут печатать в 2 раза больше в течение получаса')
	:SetPrice(69)
	:SetSales(0.4, 0.45, 0.5)
	:CanAltPrice(10000)
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
	:SetPrice(49)
	:SetSales(0.4, 0.45, 0.5)
	:CanAltPrice(12500)
	:SetCanBuy(function(self, pl)
		if rp.EventIsRunning('VapeWave') then
			return false, 'Этот Ивент уже идёт!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'startevent', 'VapeWave', '5mi')
	end)


rp.shop.Add('X2 время', 'event_double_time')
	:SetCat('Ивенты')
	:SetDesc('Все получают +100% к получению времени на 30 минут')
	:SetPrice(95)
	:SetSales(0.4, 0.45, 0.5)
	:SetCanBuy(function(self, pl)
		if rp.EventIsRunning('DoubleTime') then
			return false, 'Этот Ивент уже идёт!'
		end
		return true
	end)
	:SetOnBuy(function(self, pl)
		RunConsoleCommand('urf', 'startevent', 'DoubleTime', '30mi')
	end)

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
	:SetPrice(84)
	:CanAltPrice(85000)
	:SetSales(0.1)
	:SetWeapon('hl2_combo_fists')
/*	
rp.shop.Add('Сигарета', 'weapon_ciga_cheap')
	:SetCat('Оружие')
	:SetPrice(124)
	:SetSales(0.1)
	:SetWeapon('weapon_ciga_cheap')
	:SetIcon('models/mordeciga/mordes/oldcigshib.mdl')

rp.shop.Add('Capitan Black', 'weapon_ciga_blat')
	:SetCat('Оружие')
	:SetPrice(209)
	:SetSales(0.25)
	:SetWeapon('weapon_ciga_pachka_blat')
	:SetDesc('Вам будет даваться сигарета Capitan Black при возрождении.\nОна позволяет вам пускать струи благородного черного дыма')
	:SetIcon('models/mordeciga/mordes/pachkablat.mdl')

rp.shop.Add('Электронная сигарета', 'perma_vape')
	:SetCat('Оружие')
	:SetPrice(269)
	:SetSales(0.25)
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


rp.shop.Add('Спиннер', 'fidgetspinner_new')
	:SetCat('Оружие')
	:SetPrice(299)
	:CanAltPrice(45000)
	:SetSales(0.25)
	:SetWeapon('fidgetspinner_new')
	:SetIcon('models/weapons/w_fidget_spinner.mdl')
	:SetCanBuy(function(self, pl)
        return false
    end)
*/
rp.shop.Add('Набор эмоций', 'emotions_pack')
	:SetCat('Оружие')
	:SetDesc([[Вам будет выдан набор эмоций которым вы сможете:
- кинуть зигу
- показать средний палец
- сделать dab
- показать facepalm
- сделать флип
- поднять руки вверх]])
	:SetPrice(619)
	:SetSales(0.3, 0.4)
	:SetStackable(false)
	:SetOnBuy(function(self, pl)
		pl:Give('dab')
		pl:Give('facepunch')
		pl:Give('flip')
		pl:Give('middlefinger')
		pl:Give('seig_hail')
		pl:Give('surrender')
	end)

rp.shop.Add('Штык-Нож M9', 'tfa_anomaly_knife_combat')
	:SetCat('Оружие')
	:SetPrice(125)
	:SetSales(0.15, 0.25, 0.3)
	:SetWeapon('tfa_anomaly_knife_combat')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_knife_combat_w.mdl')

rp.shop.Add('Монтировка', 'perma_crowbar')
	:SetCat('Оружие')
	:SetPrice(145)
	:SetSales(0.1, 0.15, 0.2)
	:SetWeapon('weapon_crowbar')
	:SetIcon('models/weapons/w_crowbar.mdl')
	:SetDesc('Даже инструмент может стать оружием.')

rp.shop.Add('АПС', 'tfa_anomaly_aps')
	:SetCat('Оружие')
	:SetPrice(179)
	:SetSales(0.15, 0.2, 0.25)
	:SetWeapon('tfa_anomaly_aps')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_aps.mdl')
	:SetDesc('Легкое и дешевое оружие. Как раз для новичка.')

rp.shop.Add('Кольт', 'tfa_anomaly_colt1911')
	:SetCat('Оружие')
	:SetPrice(209)
	:SetSales(0.3)
	:SetHidden(true)
	:SetWeapon('tfa_anomaly_colt1911')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_colt1911_w.mdl')
	:SetDesc('Любимица Военных')
	:SetHidden(true)
	
rp.shop.Add('MP412', 'tfa_anomaly_mp412')
	:SetCat('Оружие')
	:SetPrice(250)
	:SetSales(0.3)
	:SetWeapon('tfa_anomaly_mp412')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_mp412_w.mdl')
	:SetDesc('Тут не требуется слова.')

rp.shop.Add('Гадюка', 'tfa_anomaly_mp5')
	:SetCat('Оружие')
	:SetPrice(379)
	:SetSales(0.1, 0.15)
	:CanAltPrice(55000)
	:SetWeapon('tfa_anomaly_mp5')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_mp5_w.mdl')
	:SetDesc('Легкое и практичное оружие.')
/*	
rp.shop.Add('Мачете', 'm9k_machete')
	:SetCat('Оружие')
	:SetPrice(399)
	:SetSales(0.15, 0.25)
	:SetWeapon('m9k_machete')
	:SetIcon('models/weapons/w_fc2_machete.mdl')
	:SetDesc('Сильнейшее оружие в ближнем бою.')
*/
rp.shop.Add('Гитара', 'guitar_stalker')
	:SetCat('Оружие')
	:SetPrice(415)
	:SetSales(0.3)
	:SetWeapon('guitar_stalker')
	:SetIcon('models/custom/guitar/m_d_45.mdl')
	:SetDesc('Развлекайте сталкеров спокойной музыкой гитары у костра.')

rp.shop.Add('Баннер', 'weapon_banner_new')
	:SetCat('Оружие')
	:SetPrice(419)
	:SetSales(0.25, 0.4)
	:CanAltPrice(75000)
	:SetWeapon('weapon_banner_new')
	:SetIcon('models/weapons/w_banner0.mdl')
	:SetDesc('Устрой бунт или начисти лицо своему недругу!')

rp.shop.Add('TOЗ-34', 'tfa_anomaly_toz34')
	:SetCat('Оружие')
	:SetPrice(399)
	:SetWeapon('tfa_anomaly_toz34')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_toz34_w.mdl')
	:SetHidden(true)

rp.shop.Add('SPAS-12', 'tfa_anomaly_spas12')
	:SetCat('Оружие')
	:SetPrice(449)
	:SetSales(0.4)
	:CanAltPrice(120000)
	:SetWeapon('tfa_anomaly_spas12')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_spas12_w.mdl')

rp.shop.Add('Scorpion vz.61', 'tfa_anomaly_vz61')
	:SetCat('Оружие')
	:SetPrice(525)
	:SetSales(0.15, 0.25)
	:SetWeapon('tfa_anomaly_vz61')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_vz61_w.mdl')
	
rp.shop.Add('Граната', 'tfa_anomaly_f1')
	:SetCat('Оружие')
	:SetPrice(599)
	:SetSales(0.25, 0.35)
	:CanAltPrice(150000)
	:SetWeapon('tfa_anomaly_f1')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_f1_w.mdl')

rp.shop.Add('Витязь', 'tfa_anomaly_vityaz')
	:SetCat('Оружие')
	:SetPrice(639)
	:SetSales(0.35)
	:SetWeapon('tfa_anomaly_vityaz')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_vityaz_w.mdl')
	:SetHidden(true)

rp.shop.Add('Deagle', 'tfa_anomaly_desert_eagle')
	:SetCat('Оружие')
	:SetPrice(709)
	:SetWeapon('tfa_anomaly_desert_eagle')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_desert_eagle_w.mdl')

rp.shop.Add('AK-74', 'tfa_anomaly_ak74')
	:SetCat('Оружие')
	:SetPrice(799)
	:CanAltPrice(250000)
	:SetSales(0.25, 0.35)
	:SetWeapon('tfa_anomaly_ak74')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_ak74.mdl')

rp.shop.Add('LR 300', 'tfa_anomaly_lr300')
	:SetCat('Оружие')
	:SetPrice(979)
	:SetSales(0.15, 0.25)
	:SetWeapon('tfa_anomaly_lr300')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_lr300_w.mdl')
	
rp.shop.Add('СВД', 'tfa_anomaly_svd')
	:SetCat('Оружие')
	:SetPrice(999)
	:SetWeapon('tfa_anomaly_svd')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_svd_w.mdl')

rp.shop.Add('АС ВАЛ','tfa_anomaly_val')
	:SetCat('Оружие')
	:SetPrice(1099)
	:SetSales(0.15)
	:SetWeapon('tfa_anomaly_val')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_val_w.mdl')
/*	
rp.shop.Add('Граната Липучка', 'm9k_sticky_grenade')
	:SetCat('Оружие')
	:SetPrice(949)
	:SetWeapon('m9k_sticky_grenade')
	:SetIcon('models/weapons/w_sticky_grenade_thrown.mdl')
	:SetHidden(true)

rp.shop.Add('Дымовуха','stalker_grenade_gd')
	:SetCat('Оружие')
	:SetPrice(969)
	:SetSales(0.35)
	:SetWeapon('stalker_grenade_gd')
	:SetIcon('models/weapons/w_stalker_grenade_gd.mdl')
	:SetDesc('Дымовая Граната')	
	:SetHidden(true)
*/
rp.shop.Add('СВУ','tfa_anomaly_svu')
	:SetCat('Оружие')
	:SetPrice(1099)
	:CanAltPrice(220000)
	:SetSales(0.15, 0.2)
	:SetWeapon('tfa_anomaly_svu')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_svu_w.mdl')
/*	
rp.shop.Add('Мина (SLAM)', 'weapon_slam')
	:SetCat('Оружие')
	:SetPrice(1149)
	:SetSales(0.25, 0.35)
	:SetWeapon('weapon_slam')
	:SetIcon('models/weapons/w_slam.mdl')

rp.shop.Add('ПНВ', 'hdtf_nightvision')
	:SetCat('Оружие')
	:SetPrice(1199)
	:SetSales(0.25, 0.35)
	:SetWeapon('hdtf_nightvision')
	:SetIcon('models/hunt_down_the_freeman/weapons/w_nvg.mdl')

rp.shop.Add('Медкит', 'weapon_medkit')
	:SetCat('Оружие')
	:SetPrice(1249)
	:SetSales(0.25, 0.35)
	:SetWeapon('weapon_medkit')
	:SetIcon('models/weapons/w_medkit.mdl')	
*/
rp.shop.Add('ПКМ', 'tfa_anomaly_pkm')
	:SetCat('Оружие')
	:SetPrice(1549)
	--:CanAltPrice(310000)
	:SetSales(0.1)
	:SetWeapon('tfa_anomaly_pkm')
	:SetIcon('models/flaymi/anomaly/weapons/w_models/wpn_pkm_w.mdl')
/*
rp.shop.Add('ПКП','tfa_anomaly_pkm')
	:SetCat('Оружие')
	:SetPrice(1939)
	:SetSales(0.15, 0.25)
	:SetWeapon('tfa_anomaly_pkm')
	:SetIcon('models/weapons/w_pkp.mdl')

rp.shop.Add('Винторез','stalker_vintorez')
	:SetCat('Оружие')
	:SetPrice(1149)
	:SetSales(0.15, 0.2, 0.25)
	:CanAltPrice(265000)
	:SetWeapon('swb_vss_kekler')
	:SetIcon('models/weapons/w_stalker_vss.mdl')

rp.shop.Add('Desert Eagle GOLD', 'stalker_deagle_gold')
	:SetCat('Оружие')
	:SetPrice(990)
	:SetSales(0.15, 0.25)
	:SetWeapon('swb_deagle_gold')
	:SetIcon('models/weapons/w_pist_deagv2.mdl')
--	:SetCanBuy(function() return false end)

rp.shop.Add('АКС-74У GOLD', 'srp_ak74su_gold')
	:SetCat('Оружие')
	:SetPrice(1290)
	:SetSales(0.15, 0.25)
	:SetWeapon('swb_ak74su_gold')
	:SetIcon('models/weapons/z_smg_ak74.mdl')
--	:SetCanBuy(function() return false end)

rp.shop.Add('М14 “Стрелок”', 'swb_m14')
	:SetCat('Оружие')
	:SetPrice(1350)
	:SetSales(0.15, 0.25)
	:SetWeapon('swb_m14')
	:SetIcon('models/weapons/w_m14_scope.mdl')

if !isNoDonate then 
rp.shop.Add('Гранатомёт EX41', 'm9k_ex41')
	:SetCat('Оружие')
	:SetPrice(1750)
	:SetSales(0.1, 0.15)
	:SetWeapon('m9k_ex41')
	:SetIcon('models/weapons/w_ex41.mdl')
end
	
rp.shop.Add('КСВК', 'srp_ksvk')
	:SetCat('Оружие')
	:SetPrice(1729)
	:SetSales(0.2, 0.25)
	:SetWeapon('swb_ksvk')
	:SetIcon('models/weapons/w_ksvk.mdl')
	
rp.shop.Add('СПАС-14','srp_spas14')
	:SetCat('Оружие')
	:SetPrice(1499)
	:CanAltPrice(390000)
	:SetSales(0.15)
	:SetWeapon('swb_spas14')
	:SetIcon('models/weapons/w_spas12.mdl')
	:SetDesc('Дробовик с увеличенным темпом стрельбы')
	
rp.shop.Add('C4', 'weapon_c4')
	:SetCat('Оружие')
	:SetPrice(1750)
	:SetSales(0.25, 0.35)
	:SetWeapon('weapon_c4')
	:SetIcon('models/weapons/2_c4_planted.mdl')

rp.shop.Add('Сайга', 'swb_sayga')
	:SetCat('Оружие')
	:SetPrice(2000)
	:SetWeapon('swb_sayga_kekler')
	:SetIcon('models/weapons/w_saiga12mod.mdl')
		


rp.shop.Add('Отбойник', 'stalker_eliminator')
	:SetCat('Оружие')
	:SetPrice(2469)
	:SetSales(0.15)
	:SetWeapon('swb_eliminator')
	:SetIcon('models/weapons/w_stalker_striker.mdl')

rp.shop.Add('СВУмк-2', 'stalker_svu')
	:SetCat('Оружие')
	:SetPrice(1359)
	:SetSales(0.15, 0.2)
	:SetWeapon('swb_svumk2')
	:SetIcon('models/weapons/w_stalker_svu.mdl')
	:SetHidden(true)

	rp.shop.Add('Гаусс Пушка', 'srp_gauss')
	:SetCat('Оружие')
	:SetPrice(2259)
	:SetWeapon('swb_gauss')
	:SetIcon('models/weapons/w_gauss.mdl')

if !isNoDonate then 
rp.shop.Add('Гаусс Пушка 2', 'swb_gauss2')
	:SetCat('Оружие')
	:SetPrice(4125)
	:SetSales(0.1)
	:SetWeapon('swb_gauss2')
	:SetIcon('models/weapons/w_stalker_gauss.mdl')
end

if !isNoDonate then 
rp.shop.Add('RPG-7', 'm9k_rpg7')
	:SetCat('Оружие')
	:SetPrice(3490)
	:SetSales(0.1)
	:SetWeapon('m9k_rpg7')
	:SetDesc('Не каждый можете себе это позволить.')
	:SetIcon('models/weapons/w_gdc_rpg7.mdl')
	:SetOnBuy(function(self, pl)
		local weps = pl:GetVar('PermaWeapons')
		weps[#weps + 1] = wep
		pl:SetVar('PermaWeapons', weps)

		RunConsoleCommand('urf', 'tellall', 'Большое спасибо ' .. pl:Name() .. ' за покупку RPG! Ты крутой!')
	end)

rp.shop.Add('RPG', 'perma_rpg')
	:SetCat('Оружие')
	:SetPrice(3369)
	:SetSales(0.3)
	:SetWeapon('weapon_rpg')
	:SetDesc('Не каждый можете себе это позволить.')
	:SetHidden(true)
	:SetCanBuy(function() return false end)

rp.shop.Add('Матадор', 'm9k_matador')
	:SetCat('Оружие')
	:SetPrice(5759)
	:SetSales(0.1)
	:SetWeapon('m9k_matador')
	:SetIcon('models/weapons/w_gdcw_matador_rl.mdl')
	:SetDesc('Мощная Штучка.')

rp.shop.Add('Рп-74', 'swb_rp74')
	:SetCat('Оружие')
	:SetPrice(2888)
	:SetWeapon('swb_rp74')
	:SetIcon('models/weapons/w_stalker_pkm.mdl')
	:SetDesc('Настоящая огневая мощь.')
	:SetHidden(true)


rp.shop.Add('М16', 'swb_m16')
	:SetCat('Оружие')
	:SetPrice(979)
	:SetWeapon('swb_m16')
	:SetIcon('models/weapons/w_m16.mdl')
	:SetHidden(true)

rp.shop.Add('Милкор', 'm9k_milkormgl')
	:SetCat('Оружие')
	:SetPrice(4145)
	:SetSales(0.1)
	:SetWeapon('m9k_milkormgl')
	:SetIcon('models/weapons/w_milkor_mgl1.mdl')
	:SetDesc('Мощная Штучка.')	
	:SetHidden(true)
end
*/
rp.shop.Add('Хэд Админ+', 'unused') 
	:SetCat('Особые услуги') 
	:SetPrice(0) 
	:SetBuildInCategory(true) 
	:SetDesc('Вы можете приобрести права HeadAdmin, SuperAdmin и GlobalAdmin. \n\nЦена обговаривается с консультантом.')
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
	:SetDesc('Вы можете приобрести свою личную фракцию с разными проффесиями, уникальным вооружением, скинами, которую вы сможете обустроить по вашему вкусу. Иметь доступ к ней будете только вы и члены организаций в зависимости от их ранга в вашей организации.\n\nЦена обговаривается с консультантом.')
	:SetOnBuy(function(self, ply) end)
	:SetCanBuy(function() return SERVER end)

rp.shop.Add('Личное оружие', 'unused') 
	:SetCat('Особые услуги') 
	:SetPrice(0) 
	:SetBuildInCategory(true) 
	:SetDesc('Вы можете приобрести Личное оружие, настроенное по Вашему вкусу, на личную профессию, аккаунт или профессию организации. \n\nЦена обговаривается с консультантом.')
	:SetOnBuy(function(self, ply) end)
	:SetCanBuy(function() return SERVER end)

rp.shop.Add('Промокод', 'unused') 
	:SetCat('Особые услуги') 
	:SetPrice(0) 
	:SetBuildInCategory(true) 
	:SetDesc('Вы можете заказать уникальный промокод на Кредиты, как одноразовый, так и с множеством использований. \n\nЦена обговаривается с консультантом.')
	:SetOnBuy(function(self, ply) end)
	:SetCanBuy(function() return SERVER end)

rp.shop.Add('Спонсорство', 'unused') 
	:SetCat('Особые услуги') 
	:SetPrice(0) 
	:SetBuildInCategory(true) 
	:SetDesc('Если у вас возникло желание координально помочь проекту, вы можете обсудить это с консультантом.')
	:SetOnBuy(function(self, ply) end)
	:SetCanBuy(function() return SERVER end)

rp.shop.Add('Своя база', 'unused') 
	:SetCat('Особые услуги') 
	:SetPrice(0) 
	:SetBuildInCategory(true) 
	:SetDesc('Для своей Организации Вы можете приобрести одну из баз или создать новую с учетом Ваших пожеланий, если Вам не приглянулась ни одна свободная база. \n\nЦена обговаривается с консультантом.')
	:SetOnBuy(function(self, ply) end)
	:SetCanBuy(function() return SERVER end)




/*
rp.shop.Add('Боров', 'borov')
	:SetCat('Профессии')
	:SetPrice(575)
	:SetSales(0.35)
	:SetDesc('После покупки вы сможете взять профессию у бандитов. Имеет повышенную зарплату, хорошее вооружение и контроль над бандитами.')
	:SetTeam(TEAM_BOROV)
	:SetCanBuy(function(self, pl)
		return pl:GetPlayTime() > 210 * 3600, 'Вам нужно отыграть 210 часов!'
	   end) 


rp.shop.Add('Генерал Воронин', 'voronin')
	:SetCat('Профессии')
	:SetPrice(975)
	:SetSales(0.35)
	:SetDesc('После покупки вы сможете взять профессию у ДОЛГа. Имеет повышенную зарплату, хорошее вооружение и контроль над ДОЛГом.')
	:SetIcon('models/player/stalker/compiled 0.34/voronin.mdl')
	:SetTeam(TEAM_VORONIN)
	:SetCanBuy(function(self, pl)
		return pl:GetPlayTime() > 350 * 3600, 'Вам нужно отыграть 350 часов!'
	   end) 


rp.shop.Add('Лукаш', 'lukash')
	:SetCat('Профессии')
	:SetPrice(975)
	:SetSales(0.35)
	:SetDesc('После покупки вы сможете взять профессию у Свободы. Имеет повышенную зарплату, хорошее вооружение и контроль над свободой.')
	:SetTeam(TEAM_LUKASH)
	:SetCanBuy(function(self, pl)
		return pl:GetPlayTime() > 350 * 3600, 'Вам нужно отыграть 350 часов!'
	   end) 

rp.shop.Add('Стрелок', 'strelok')
	:SetCat('Профессии')
	:SetPrice(2750)
	:SetSales(0.25)
	:SetDesc('После покупки вы сможете взять профессию у барменов. Имеет повышенную зарплату, супер вооружение, высокую броню и ХП.')
	:SetIcon('models/player/stalker/compiled 0.34/streloksunrise.mdl')
	:SetTeam(TEAM_STRELOK)
	:SetCanBuy(function(self, pl)
		return pl:GetPlayTime() > 350 * 3600, 'Вам нужно отыграть 350 часов!'
	   end) 


rp.shop.Add('Чёрный Сталкер', 'blackstalker')
	:SetCat('Профессии')
	:SetPrice(2220)
	:SetSales(0.1)
	:SetDesc('После покупки вы сможете взять профессию у НПС зомби. Имеет повышенную зарплату, супер вооружение, высокую броню и ХП.')
	:SetIcon('models/stalkertnb/exo_baldry.mdl')
	:SetTeam(TEAM_GORZ)
	:SetHidden(true)
	:SetCanBuy(function(self, pl)
		return pl:GetPlayTime() > 350 * 3600, 'Вам нужно отыграть 350 часов!'
	   end) 

rp.shop.Add('Прапорщик "Морган"', 'morgan')
	:SetCat('Профессии')
	:SetPrice(1990)
	:SetSales(0.35)
	:SetDesc('После покупки вы сможете взять профессию у НПС ДОЛГа. Имеет повышенную зарплату, среднее количество брони, арсенал с оружием на продажу.')
	:SetIcon('models/stalkertnb/rad_duty.mdl')
	:SetTeam(TEAM_DOLGMORGAN)
	:SetHidden(true)
	:SetCanBuy(function(self, pl)
		return pl:GetPlayTime() > 210 * 3600, 'Вам нужно отыграть 210 часов!'
	   end) 

rp.shop.Add('Наёмник Легенда', 'job_hitdonatik')
	:SetCat('Профессии')
	:SetPrice(2125)
	:CanAltPrice(450000)
	:SetSales(0.25)
	:SetDesc('После покупки вы сможете взять профессию у НПС Наёмников. Имеет повышенную зарплату, повышенную выжеваемость и разнообразное вооружение.')
	:SetIcon('models/stalkertnb/exo_zack.mdl')
	:SetTeam(TEAM_HITMANDONAT)
	:SetHidden(true)
	:SetCanBuy(function(self, pl)
		return pl:GetPlayTime() > 350 * 3600, 'Вам нужно отыграть 350 часов!'
	   end) 


rp.shop.Add('Ворона', 'job_crow')
	:SetCat('Профессии')
	:SetPrice(290)
	:SetDesc('Позволяет вам бездумно летать по карте и издавать мерзкое птичье пение.')
	:SetIcon('models/crow.mdl')
	:SetTeam(TEAM_CROW)
	:SetStackable(false)
	:SetNetworked(true)

rp.shop.Add('Голубь', 'job_pigeon')
	:SetCat('Профессии')
	:SetPrice(215)
	:SetDesc('После покупки вы сможете взять профессию у барменов. Позволяет вам бездумно летать по карте и издавать мерзкое птичье пение.')
	:SetTeam(TEAM_PIGEON)
	:SetStackable(false)
	:SetNetworked(true)

rp.shop.Add('Попугай', 'job_parrot')
	:SetCat('Профессии')
	:SetPrice(149)
	:SetDesc('Позволяет вам бездумно летать по карте и издавать отвратительные звуки попугая.')
	:SetTeam(TEAM_PARROT)
	:SetStackable(false)
	:SetNetworked(true)
	
rp.shop.Add('Коза', 'job_goat')
	:SetCat('Профессии')
	:SetPrice(199)
	:SetDesc('Позволяет вам бездумно слоняться по карте, бодать и кусать обидчиков, и испражняться где только вздумается.')
	:SetTeam(TEAM_GOAT)
	:SetStackable(false)
	:SetNetworked(true)

--Орден
if !isNoDonate then 
	rp.shop.Add('Медик Ордена', 'job_ordenm')
	:SetCat('Орден')
	:SetPrice(600)
	:CanAltPrice(150000)
	:SetDesc([[После покупки вы сможете взять профессию у НПС Ордена. Встроенная защита от аномалий, 2 скина на выбор. 
	Полевой медик, имеет базовые знания по ведению боя и выживанию в ЧЗО, в дополнение к этому ,как правило, является образованным Ученым.]])
	:SetIcon('models/stalkertnb/cs4_recondite.mdl')
	:SetTeam(TEAM_ORDENM)
	:SetCanBuy(function(self, pl)
		return pl:GetPlayTime() > 150 * 3600, 'Вам нужно отыграть 150 часов!'
	   end)

	rp.shop.Add('Механик Ордена', 'job_ordenmex')
	:SetCat('Орден')
	:SetPrice(850)
	:SetDesc([[После покупки вы сможете взять профессию у НПС Ордена. Багги и Волга в продаже.
	Специалист, обслуживающий технику и обмундирование бойцов. Торгует снаряжением, оборудованием, инструментами и машинами.]])
	:SetIcon('models/stalkertnb2/sunrise_chinatown.mdl')
	:SetTeam(TEAM_ORDENMEX)
	:SetCanBuy(function(self, pl)
  return pl:GetPlayTime() > 200 * 3600, 'Вам нужно отыграть 200 часов!'
 end)

	rp.shop.Add('Штурмовик Ордена', 'job_ordens')
	:SetCat('Орден')
	:SetPrice(1000)
	:CanAltPrice(250000)
	:SetDesc([[После покупки вы сможете взять профессию у НПС Ордена.
	Боец, прошедший обучение тактическим основам для захвата или очистки территории от превосходящего количества противников.]])
	:SetIcon('models/stalkertnb/beri_recondite.mdl')
	:SetTeam(TEAM_ORDENS)
	:SetCanBuy(function(self, pl)
		return pl:GetPlayTime() > 250 * 3600, 'Вам нужно отыграть 250 часов!'
	   end)

rp.shop.Add('Снайпер Ордена', 'job_ordensn')
	:SetCat('Орден')
   :SetPrice(1200)
   :SetDesc([[После покупки вы сможете взять профессию у НПС Ордена. Вооружен уникальной 20мм винтовкой Ордена.
   Элитный боец, прошедший спец подготовку по разведке и ведению боя на дальней дистанции. Для удобства решил убрать большинство защиты взамен скорости.]])
   :SetIcon('models/stalkertnb2/sunrise_symmetry.mdl')
   :SetTeam(TEAM_ORDENSN)
   :SetCanBuy(function(self, pl)
   return pl:GetPlayTime() > 300 * 3600, 'Вам нужно отыграть 300 часов!'
	  end)
end
*/
-- Models

local disallowFactions = {}
if FACTION_REBELVIP then disallowFactions[FACTION_REBELVIP] = true end
if FACTION_1HUNTERS then disallowFactions[FACTION_1HUNTERS] = true end
if FACTION_TOPOL then disallowFactions[FACTION_TOPOL] = true end
if FACTION_ZOMBIE then disallowFactions[FACTION_ZOMBIE] = true end
if FACTION_DOLG then disallowFactions[FACTION_DOLG] = true end
if FACTION_DOLGVIP then disallowFactions[FACTION_DOLGVIP] = true end
if FACTION_ECOLOG then disallowFactions[FACTION_ECOLOG] = true end
if FACTION_MUTANTS then disallowFactions[FACTION_MUTANTS] = true end
if FACTION_STERVATNIKI then disallowFactions[FACTION_STERVATNIKI] = true end
if FACTION_REFUGEES then disallowFactions[FACTION_REFUGEES] = true end
if FACTION_HITMANSOLO then disallowFactions[FACTION_HITMANSOLO] = true end
if FACTION_MILITARY then disallowFactions[FACTION_MILITARY] = true end
if FACTION_MILITARYT then disallowFactions[FACTION_MILITARYT] = true end
if FACTION_MILITARYS then disallowFactions[FACTION_MILITARYS] = true end
if FACTION_MONOLITH then disallowFactions[FACTION_MONOLITH] = true end
if FACTION_NETRAL then disallowFactions[FACTION_NETRAL] = true end
if FACTION_REBEL then disallowFactions[FACTION_REBEL] = true end
if FACTION_NEBO then disallowFactions[FACTION_NEBO] = true end
if FACTION_RENEGADES then disallowFactions[FACTION_RENEGADES] = true end
if FACTION_SVOBODA then disallowFactions[FACTION_SVOBODA] = true end
if FACTION_SVOBODAVIP then disallowFactions[FACTION_SVOBODAVIP] = true end
if FACTION_ADMINS then disallowFactions[FACTION_ADMINS] = true end
if FACTION_SUN then disallowFactions[FACTION_SUN] = true end
if FACTION_CONCORD then disallowFactions[FACTION_CONCORD] = true end
if FACTION_PROZRENIE then disallowFactions[FACTION_PROZRENIE] = true end
if FACTION_POISK then disallowFactions[FACTION_POISK] = true end
if FACTION_PARTIZAN then disallowFactions[FACTION_PARTIZAN] = true end
if FACTION_ORDEN then disallowFactions[FACTION_ORDEN] = true end
if FACTION_GYDRA then disallowFactions[FACTION_GYDRA] = true end
if FACTION_GREH then disallowFactions[FACTION_GREH] = true end
if FACTION_FANTOM then disallowFactions[FACTION_FANTOM] = true end
if FACTION_DEATDIVIS then disallowFactions[FACTION_DEATDIVIS] = true end
if FACTION_BERSERK then disallowFactions[FACTION_BERSERK] = true end
if FACTION_ANGELRIP then disallowFactions[FACTION_ANGELRIP] = true end
if FACTION_KOCHEVNIKI then disallowFactions[FACTION_KOCHEVNIKI] = true end
if FACTION_NAIMCHERRIN then disallowFactions[FACTION_NAIMCHERRIN] = true end
if FACTION_WINDORG then disallowFactions[FACTION_WINDORG] = true end
if FACTION_UNITED then disallowFactions[FACTION_UNITED] = true end
if FACTION_OXOTNIK then disallowFactions[FACTION_OXOTNIK] = true end
if FACTION_GIS then disallowFactions[FACTION_GIS] = true end
if FACTION_BOUNTY then disallowFactions[FACTION_BOUNTY] = true end
if FACTION_MST then disallowFactions[FACTION_MST] = true end
if FACTION_NEMESIS then disallowFactions[FACTION_NEMESIS] = true end
if FACTION_BROTHERS then disallowFactions[FACTION_BROTHERS] = true end
if FACTION_OTVERG then disallowFactions[FACTION_OTVERG] = true end
if FACTION_ISKRA then disallowFactions[FACTION_ISKRA] = true end
if FACTION_DIGGER then disallowFactions[FACTION_DIGGER] = true end
if FACTION_SHADOW then disallowFactions[FACTION_SHADOW] = true end
if FACTION_INTERPOL then disallowFactions[FACTION_INTERPOL] = true end
if FACTION_FANATS then disallowFactions[FACTION_FANATS] = true end
if FACTION_LP then disallowFactions[FACTION_LP] = true end
/*
rp.shop.Add('Комбинезон "Сева V.2"', 'model_seva')
	:SetCat('Модели')
	:SetPrice(250)
	--:SetHidden(true)
	:SetDesc[['При покупке вы сможете брать эту модель за сталкеров - одиночек.']]
	:SetIcon('models/tnb/stalker/male_seva_cs4.mdl')
	:CustomModel({
		BlacklistFactions = disallowFactions
	})
	:SetStackable(false)
	:SetNetworked(true)

rp.shop.Add('Комбинезон "Скат"', 'model_skat')
	:SetCat('Модели')
	:SetPrice(300)
	--:SetHidden(true)
	:SetDesc[['При покупке вы сможете брать эту модель за сталкеров - одиночек.']]
	:SetIcon('models/stalkertnb2/skat_stalker.mdl')
	:CustomModel({
		BlacklistFactions = disallowFactions
	})
	:SetStackable(false)
	:SetNetworked(true)

rp.shop.Add('Костюм "Тусовщик"', 'model_party')
	:SetCat('Модели')
	:SetPrice(340)
	--:SetHidden(true)
	:SetDesc[['При покупке вы сможете брать эту модель за сталкеров - одиночек.']]
	:SetIcon('models/stalkertnb/psz9d_dreadlocks.mdl')
	:CustomModel({
		BlacklistFactions = disallowFactions
	})
	:SetStackable(false)
	:SetNetworked(true)

rp.shop.Add('Костюм "Алиса"', 'model_alice')
	:SetCat('Модели')
	:SetPrice(380)
	--:SetHidden(true)
	:SetDesc[['При покупке вы сможете брать эту модель за сталкеров - одиночек.']]
	:SetIcon('models/tnb/stalker/female_07_sunrise.mdl')
	:CustomModel({
		BlacklistFactions = disallowFactions
	})
	:SetStackable(false)
	:SetNetworked(true)

rp.shop.Add('Костюм "Роза"', 'model_widow')
	:SetCat('Модели')
	:SetPrice(410)
	--:SetHidden(true)
	:SetDesc[['При покупке вы сможете брать эту модель за сталкеров - одиночек.']]
	:SetIcon('models/stalkertnb2/sunrise_rosa.mdl')
	:CustomModel({
		BlacklistFactions = disallowFactions
	})
	:SetStackable(false)
	:SetNetworked(true)

rp.shop.Add('Костюм "Химик"', 'model_chem')
	:SetCat('Модели')
	:SetPrice(465)
	--:SetHidden(true)
	:SetDesc[['При покупке вы сможете брать эту модель за сталкеров - одиночек.']]
	:SetIcon('models/stalkertnb2/seva_madscientist.mdl')
	:CustomModel({
		BlacklistFactions = disallowFactions
	})
	:SetStackable(false)
	:SetNetworked(true)

rp.shop.Add('Комбинезон "Экзо-Булат"', 'model_umaru')
	:SetCat('Модели')
	:SetPrice(500)
	--:SetHidden(true)
	:SetDesc[['При покупке вы сможете брать эту модель за сталкеров - одиночек.']]
	:SetIcon('models/muravey/exo_skat_kratos.mdl')
	:CustomModel({
		BlacklistFactions = disallowFactions
	})
	:SetStackable(false)
	:SetNetworked(true)

 rp.shop.Add('Уитли', 'utli')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/player/ianmata1998/whealteyii.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)


 rp.shop.Add('Уитли', 'premium')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/dawson/death_a_grim_bundle_pms/death_painted/death_painted.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)
--донатки
 rp.shop.Add('Николет', 'nikoletadm')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/player/shi/rom_maid.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

     rp.shop.Add('Масай', 'masaiadm')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/madara_jump_force.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

      rp.shop.Add('Тузлов', 'tuzlovadm')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/sirris/mae.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

          rp.shop.Add('Лазскор', 'lazadm')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/kotachi/aether_gaze/rstar/kotachi/kotachi.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)


    	rp.shop.Add('Николет2', 'nikoletadm2')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/pacagma/xenoblade_chronicles_2/brighid/brighid_player.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

    	rp.shop.Add('Итачи', 'Itachiadm')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/player/ita/itachi_uchiha.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)


    	rp.shop.Add('Хаширама', 'hashiramaadm')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/hashirama_mowgli.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

    	rp.shop.Add('Обито', 'obitoadm')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/obito.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

    	rp.shop.Add('animemodel1', 'animemodel1')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/bluearchive/miyu blue archive.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)


    	rp.shop.Add('Дьявол', 'helladm')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/player/demon_violinist/demon_violinist.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

    	rp.shop.Add('Фердинанд', 'ferd')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/player/shi/azuki.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

    	rp.shop.Add('Элен', 'elen')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/blaze/honkai_impact/mei/mei_springtide/mei_pm.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

       rp.shop.Add('Ruslan', 'Ruslan')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/walterwhite/playermodels/walterwhitecas.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

       rp.shop.Add('Ферд', 'Ferd')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/cyanblue/soa/meracle/npc/meracle.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)


       rp.shop.Add('Ферд2', 'Ferd2')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/cyanblue/genshin_impact/dehya/dehya.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

       rp.shop.Add('Ялта', 'Yalta')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/cyanblue/genshin_impact/dehya/dehya.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

           rp.shop.Add('Ялта2', 'Yalta2')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/cyanblue/genshin_impact/dehya/dehya.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

    rp.shop.Add('animemodel2', 'animemodel2')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/bluearchive/cocona.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

*/    
-- RP PASS

rp.shop.Add( "Émotions Rp Pass: Des animations uniques", "dreamfeet" )
    :SetCat( "Principal" )
    :SetPrice(35)
    :SetHidden(true)
    :SetEmoteActs({
		"dreamfeet",
	})
    :SetDesc([[Sos]])

rp.shop.Add('RP pass Emojis', 'february_emoji_1')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'february_emoji_1',
    })

rp.shop.Add('RP pass Emojis', 'february_emoji_2')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'february_emoji_2',
    })

rp.shop.Add('RP pass Emojis', 'february_emoji_3')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'february_emoji_3',
    })
    
 rp.shop.Add('G-MAN Ветеран', 'model_carnaval')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/kaesar/hlalyx/urf/g_real_man.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

rp.shop.Add('Лоли Канна', 'kanna')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/player/dewobedil/maid_dragon/kanna_edit/default_p.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true) 
rp.shop.Add('RP pass Emojis', 'space_emoji_1')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'space_emoji_1',
    })

rp.shop.Add('RP pass Emojis', 'space_emoji_2')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'space_emoji_2',
    })

rp.shop.Add('RP pass Emojis', 'space_emoji_3')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'space_emoji_3',
    })

rp.shop.Add('RP pass Emojis', 'space_emoji_4')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'space_emoji_4',
    })

 rp.shop.Add('RP pass Emojis', 'space_emoji_5')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'space_emoji_5',
    })

rp.shop.Add('Космонавт', 'model_space')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/urf/cod_ghosts/odin/odin_astronaut.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true) 
    
rp.shop.Add( "Émotions Rp Pass: Des animations uniques", "cowboy_dance" )
    :SetCat( "Principal" )
    :SetPrice(35)
    :SetHidden(true)
    :SetEmoteActs({
        "cowboy_dance",
    })
    :SetDesc([[Sos]])
	
rp.shop.Add( "Émotions Rp Pass: Des animations uniques", "moonwalking" )
    :SetCat( "Principal" )
    :SetPrice(35)
    :SetHidden(true)
    :SetEmoteActs({
        "moonwalking",
    })
    :SetDesc([[Sos]])

rp.shop.Add( "Émotions Rp Pass: Des animations uniques", "robotdance" )
    :SetCat( "Principal" )
    :SetPrice(35)
    :SetHidden(true)
    :SetEmoteActs({
        "robotdance",
    })
    :SetDesc([[Sos]])
    
 rp.shop.Add( "Émotions Rp Pass: Des animations uniques", "technozombie" )
    :SetCat( "Principal" )
    :SetPrice(35)
    :SetHidden(true)
    :SetEmoteActs({
        "technozombie",
    })
    :SetDesc([[Sos]])  

rp.shop.Add('Успешный Успех', 'noobie_emoji')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'noobie_emoji',
    })

rp.shop.Add('Летний Пепе', 'summerpepe')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'summerpepe',
    })
	
rp.shop.Add( "Case Emote", "hula" )
    :SetCat( "Principal" )
    :SetPrice(35)
    :SetHidden(true)
    :SetDesc([[]])
    :SetEmoteActs({
        "f_hula",
    })

-- Июльский Кейс
rp.shop.Add( "JazzDance", "f_jazz_dance" )
    :SetCat( "Principal" )
    :SetPrice(35)
    :SetHidden(true)
    :SetDesc([[]])
    :SetEmoteActs({
        "f_jazz_dance",
    })

rp.shop.Add('Салли-Майк', 'sally')
    :SetCat('Модели')
    :SetPrice(200)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/konnie/sulleymike/sulleymike.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)
 
-- Летний БатлПасс
rp.shop.Add( "Drum Major", "f_drum_major" )
    :SetCat( "Principal" )
    :SetPrice(35)
    :SetHidden(true)
    :SetDesc([[]])
    :SetEmoteActs({
        "f_drum_major",
    })

rp.shop.Add('Луиджо-ДжоДжо', 'model_jojo_one')
    :SetCat('Модели')
    :SetPrice(200)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/mario_nk/luigi/luigi_jojo.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

rp.shop.Add('Марио-ДжоДжо', 'model_jojo_two')
    :SetCat('Модели')
    :SetPrice(200)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/mario_nk/mario/mario_jojo.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

rp.shop.Add('Богатый Пепе', 'summer_emoji_1')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'summer_emoji_1',
    })  

rp.shop.Add('Пепе Фак', 'summer_emoji_2')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'summer_emoji_2',
    })  

rp.shop.Add('Боевой Пепе', 'summer_emoji_3')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'summer_emoji_3',
    }) 
    
rp.shop.Add('Мэй', 'may')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/cyanblue/gg/may/may.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

rp.shop.Add( "Танец Разбрызгивателя", "f_sprinkler" )
    :SetCat( "Principal" )
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc([[]])
    :SetEmoteActs({
        "f_sprinkler",
    })

rp.shop.Add('Кровавая Леди', 'model_ladyred')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/rumbleroses/evilrose.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

rp.shop.Add( "Танец Технозомби", "f_technozombie" )
    :SetCat( "Principal" )
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc([[]])
    :SetEmoteActs({
        "f_technozombie",
    }) 

rp.shop.Add('Тыква 1', 'halloween_emoji_1')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'halloween_emoji_1',
    })   

rp.shop.Add('Тыква 2', 'halloween_emoji_2')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'halloween_emoji_2',
    }) 

rp.shop.Add('Тыква 3', 'halloween_emoji_3')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'halloween_emoji_3',
    }) 

-- СП НГ 2022
rp.shop.Add('Новогодняя Хаку', 'model_nyhacky')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/player/dewobedil/vocaloid/yowane_haku/christmas_p.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

rp.shop.Add('Гринч 1', 'newyear2022_1')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'newyear2022_1',
    })   

rp.shop.Add('Гринч 2', 'newyear2022_3')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'newyear2022_3',
    }) 

rp.shop.Add('Гринч 3', 'newyear2022_3')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'newyear2022_3',
    }) 

rp.shop.Add('Гринч 4', 'newyear2022_4')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'newyear2022_4',
    }) 

rp.shop.Add('Гринч 5', 'newyear2022_5')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'newyear2022_5',
    })

-- СП Весна 2022   
rp.shop.Add('Красная Угроза', 'model_guard_admin_1')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/kemot44/models/mk11/characters/skarlet_kold_war_pm.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

rp.shop.Add('Боец 1', 'gd_emoji_1')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'gd_emoji_1',
    }) 
    
rp.shop.Add('Боец 1', 'gd_emoji_2')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'gd_emoji_2',
    })

rp.shop.Add('Боец 1', 'gd_emoji_3')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'gd_emoji_3',
    })

rp.shop.Add('Боец 1', 'gd_emoji_4')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'gd_emoji_4',
    })

rp.shop.Add('Боец 1', 'gd_emoji_5')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'gd_emoji_5',
    })

rp.shop.Add('Ржумэн', 'roflman')
    :SetCat('Модели')
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/player/ganimator/emotiguy_requiem.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

-- Лето-Лето Кейс 2022
rp.shop.Add( "Эмоция: Голововорот", "f_peely_blender" )
    :SetCat( "Principal" )
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc([[]])
    :SetEmoteActs({
        "f_peely_blender",
    }) 

rp.shop.Add('2 Парня', 'urf_summer_male_male_07')
    :SetCat('Модели')
    :SetPrice(100)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/player/group01/male_male_077.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

-- СП Хэллоуин 2022   
rp.shop.Add('Хэллоуин 2022 - 1', 'halloween2022_emoji_1')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'halloween2022_emoji_1',
    })

rp.shop.Add('Хэллоуин 2022 - 2', 'halloween2022_emoji_2')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'halloween2022_emoji_2',
    })

rp.shop.Add('Хэллоуин 2022 - 3', 'halloween2022_emoji_3')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'halloween2022_emoji_3',
    })

rp.shop.Add('Хэллоуин 2022 - 4', 'halloween2022_emoji_4')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'halloween2022_emoji_4',
    })
/*                   
rp.shop.Add('Ивент "Искажение"', 'zombie_event')
        :SetCat('Ивенты')
        :SetDesc('Вы станете нулевым зомби. Попробуйте заразить всех игроков!')
        :SetPrice(150)
        :SetAltPrice(75000)
        :SetCanBuy(function(self, ply)
            if eventZombie.Started then
                return false, 'Этот ивент уже начался!'
            end

            if eventZombie.CD and eventZombie.CD > CurTime() then
                return false, 'Этот ивент можно будет запустить через ' .. os.date('%M:%S', os.difftime(eventZombie.CD, CurTime()))
            end

            return true
        end)
        :SetOnBuy(function(self, ply)
            eventZombie.start(ply)
        end)
*/
-- БП Зима 22/23
rp.shop.Add('Зима 2022/23 - 1', 'winter_22_23_emoji_1')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'winter_22_23_emoji_1',
    })

rp.shop.Add('Зима 2022/23 - 2', 'winter_22_23_emoji_2')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'winter_22_23_emoji_2',
    })

rp.shop.Add('Зима 2022/23 - 3', 'winter_22_23_emoji_3')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'winter_22_23_emoji_3',
    })

rp.shop.Add('Зима 2022/23 - 4', 'winter_22_23_emoji_4')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'winter_22_23_emoji_4',
    })

rp.shop.Add('Зима 2022/23 - 5', 'winter_22_23_emoji_5')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'winter_22_23_emoji_5',
    })

rp.shop.Add('Полярник', 'winter_22_23_adminmodel')
    :SetCat('Модели')
    :SetPrice(100)
    :SetHidden(true)
    :SetDesc[['']]
    :SetIcon('models/player/darky_m/rust/arctic_hazmat.mdl')
    :CustomModel({
        WhitelistFactions = {
            [FACTION_ADMINS] = true,
        }
    })
    :SetStackable(false)
    :SetNetworked(true)

-- БП ОСЕНЬ'23
rp.shop.Add('Сталкер Эмодзи - 1', 'aut_stalker_emoji_1')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'aut_stalker_emoji_1',
    })

rp.shop.Add('Сталкер Эмодзи - 2', 'aut_stalker_emoji_2')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'aut_stalker_emoji_2',
    })

rp.shop.Add('Сталкер Эмодзи - 3', 'aut_stalker_emoji_3')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'aut_stalker_emoji_3',
    })

rp.shop.Add('Сталкер Эмодзи - 4', 'aut_stalker_emoji_4')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'aut_stalker_emoji_4',
    })

rp.shop.Add('Сталкер Эмодзи - 5', 'aut_stalker_emoji_5')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'aut_stalker_emoji_5',
    })

rp.shop.Add('Сталкер Эмодзи - 6', 'aut_stalker_emoji_6')
    :SetCat('Principal')
    :SetPrice(20)
    :SetHidden(true)
    :SetDesc[['']]
    :SetEmojis({
        'aut_stalker_emoji_6',
    })

rp.shop.Add( "Эмоция: Фэнси", "f_fancyfeet" )
    :SetCat( "Principal" )
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc([[]])
    :SetEmoteActs({
        "f_fancyfeet",
    })

rp.shop.Add( "Эмоция: Диско", "f_dg_disco" )
    :SetCat( "Principal" )
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc([[]])
    :SetEmoteActs({
        "f_dg_disco",
    })

rp.shop.Add( "Эмоция: Волна", "f_octopus" )
    :SetCat( "Principal" )
    :SetPrice(50)
    :SetHidden(true)
    :SetDesc([[]])
    :SetEmoteActs({
        "f_octopus",
    })

rp.shop.Add('RSA.Elite Strider', 'job_rsaelst')
	:SetCat('Профессии')
	:SetPrice(999)
	:SetHidden(true)
	:SetDesc([[RSA.Elite Strider:
		- Уникальный внешний вид;
		- Улучшенные характеристики прочности и атакующих способностей;
		- Доступ к профессии по желанию, а не по голосованию;
		- Доступен на HL2:За Фримэном и HL:Alyx;
	]])
	:SetIcon('models/combine_elite_strider.mdl')

hook.Call('rp.AddUpgrades', GAMEMODE)

