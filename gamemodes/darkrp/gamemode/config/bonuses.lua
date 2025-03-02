-- "gamemodes\\darkrp\\gamemode\\config\\bonuses.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.abilities.Add('1skillpts', 'Стать Лучше')
	:SetDescription([[Добавляет 1 очко навыков]])
	:SetIcon('rpui/bonus_menu/upgrade')
	:SetSound(Sound("vo/npc/male01/yeah02.wav"))
	:SetColor(Color(97, 42, 166))
	:SetContentColor(Color(63, 30, 104), 120)
	:SetCooldown(4 * 3600)
	:SetModel('models/props_lab/bindergreen.mdl')
	:SetPlayTime(4 * 3600)
	:OnUse(function(self, ply) ply:AddAttributeSystemPoints(1) end)

rp.abilities.Add('Money', 'Деньги')
	:SetDescription([[Добавляет 3000 гривен]])
	:SetSound(Sound("vo/npc/male01/yeah02.wav"))
	:SetIcon('rpui/bonus_menu/cash')
	:SetColor(Color(242, 242, 242), 80)
	:SetContentColor(Color(0, 0, 0))
	:SetCooldown(17 * 3600)
	:SetModel('models/props_c17/cashregister01a.mdl')
	:SetPlayTime(0 * 3600)
	:OnUse(function(self, ply) ply:AddMoney(300) end)

local weps = {"srp_colt1911", "srp_ak74su", "srp_ak74", "srp_makarov"}
rp.abilities.Add('Gun', 'Оружие')
	:SetDescription([[Выдает случайное оружие]])
	:SetIcon('ping_system/give_gun.png')
	:SetCooldown(35 * 3600)
	:SetModel('models/weapons/w_ak47.mdl')
	:SetColor(Color(165, 109, 38))
	:SetContentColor(Color(104, 72, 30), 120)
	:SetPlayTime(50 * 3600)
	:SetSound(Sound('items/ammo_pickup.wav'))
	:OnUse(function(self, ply) ply:Give(table.Random(weps)) end)


/*
rp.abilities.Add('5skillpts', 'Повзрослеть')
	:SetDescription([[Добавляет вам 5 очков навыков.
(потратить их можно в F4->Навыки)

Можно использовать раз в месяц.
]])
	:SetSound(Sound("vo/npc/male01/yeah02.wav"))
	:SetColor(Color(70, 130, 180))
	:SetCooldown(30 * 24 * 3600)
	:SetModel('models/props_c17/doll01.mdl')
	:SetPlayTime(0)
	:OnUse(function(self, ply) ply:AddAttributeSystemPoints(5) end)

	
rp.abilities.Add('Time', 'Получить Время')
	:SetDescription([[Добавляет 1 час к твоему игровому времени.

Можно использовать раз в 18 часов.
]])
	:SetCooldown(18 * 3600)
	:SetSound(Sound("vo/coast/odessa/male01/nlo_cheer02.wav"))
	:SetColor(Color(0, 255, 255))
	:SetModel('models/stalker/item/handhelds/pda.mdl')
	:SetPlayTime(1 * 3600)
	:OnUse(function(self, ply) ply:AddPlayTime(1 * 3600) end)



rp.abilities.Add('Heal', 'Вылечиться')
	:SetDescription([[Моментально восстанавливает здоровье до 200.

Можно использовать раз в 2 часа.
]])
	:SetCooldown(2 * 3600)
	:SetSound(Sound( "HealthKit.Touch" ))
	:SetColor(Color(127, 255, 0))
	:SetModel('models/stalker/item/medical/medkit1.mdl')
	:SetPlayTime(5 * 3600)
	:SetCanUse(function(self, ply) return ply:Health() < 200 end)
	:SetCantUseReason(function(self, ply) return 'Вы здоровы' end)
	:OnUse(function(self, ply) ply:SetHealth(200) end)



rp.abilities.Add('Armor', 'Получить Броню')
	:SetDescription([[Дает 20-70 брони в случайном порядке на 1 жизнь.

Можно использовать раз в 2.5 часа.
]])
	:SetCooldown(2.5 * 3600)
	:SetSound(Sound('items/suitchargeok1.wav'))
	:SetColor(Color(70, 130, 180))
	:SetModel('models/stalkertnb/outfits/exo_duty.mdl')
	:SetPlayTime(10 * 3600)
	:OnUse(function(self, ply) ply:GiveArmor(math.random(20, 70)) end)



rp.abilities.Add('Event', 'Начать ивент ЗП')
	:SetDescription([[Запускает Ивент Зарплаты, при котором все получают двойную зарплату в пятнадцати минут.

Можно использовать раз в Неделю.
]])
	:SetCooldown(7 * 24 * 3600)
	:SetModel('models/stalker/item/handhelds/files3.mdl')
	:SetPlayTime(30 * 3600)
	:SetSound(Sound('vo/coast/odessa/male01/nlo_cheer04.wav'))
	:SetColor(Color(85, 107, 47))
	:SetCanUse(function() return !rp.EventIsRunning('Salary') end)
	:SetCantUseReason(function(self, ply) return 'Ивент уже идёт.' end)
	:OnUse(function(self, ply) RunConsoleCommand('urf', 'startevent', 'salary', '15mi') end)
*/

