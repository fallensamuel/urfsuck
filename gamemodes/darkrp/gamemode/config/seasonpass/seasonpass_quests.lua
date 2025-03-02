-- "gamemodes\\darkrp\\gamemode\\config\\seasonpass\\seasonpass_quests.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
------------------------------------------------------------
------------------------- 1 Звезда -------------------------
------------------------------------------------------------

rp.seasonpass.AddQuest( "easy_quest_10", "Поднимите 1-го игрока" )
	:SetDifficulty(1)
	:SetLevelScores(400)
    :SetCompleteProgress(1)
    :SetType( "revive_players" )

rp.seasonpass.AddQuest( "easy_quest_20", "Поднимите 2-ух игроков" )
	:SetDifficulty(1)
	:SetLevelScores(400)
    :SetCompleteProgress(2)
    :SetType( "revive_players" )

rp.seasonpass.AddQuest( "easy_quest_30", "Поднимите 3-ех игроков" )
	:SetDifficulty(1)
	:SetLevelScores(400)
    :SetCompleteProgress(3)
    :SetType( "revive_players" )

rp.seasonpass.AddQuest( "easy_quest_40", "Передайте Игрокам " .. (rp.cfg.StartMoney * 0.5) .. " т." )
	:SetDifficulty(1)
	:SetLevelScores(400)
	:SetCompleteProgress( (rp.cfg.StartMoney * 0.5) )
	:SetType( "transfer_money_amount" )

rp.seasonpass.AddQuest( "easy_quest_50", "Передайте Игрокам " .. (rp.cfg.StartMoney * 0.7) .. " т." )
	:SetDifficulty(1)
	:SetLevelScores(400)
	:SetCompleteProgress( (rp.cfg.StartMoney * 0.7) )
	:SetType( "transfer_money_amount" )

rp.seasonpass.AddQuest( "easy_quest_60", "Передайте Игрокам " .. (rp.cfg.StartMoney * 0.8) .. " т." )
	:SetDifficulty(1)
	:SetLevelScores(400)
	:SetCompleteProgress( (rp.cfg.StartMoney * 0.8) )
	:SetType( "transfer_money_amount" )

rp.seasonpass.AddQuest( "easy_quest_70", "Передайте Игрокам " .. (rp.cfg.StartMoney * 0.9) .. " т." )
	:SetDifficulty(1)
	:SetLevelScores(400)
	:SetCompleteProgress( (rp.cfg.StartMoney * 0.9) )
	:SetType( "transfer_money_amount" )

rp.seasonpass.AddQuest( "easy_quest_80", "Найди 2 любых предметов в Ящиках с Лутом" )
	:SetDifficulty(1)
	:SetLevelScores(400)
	:SetCompleteProgress(2)
	:SetType('take_loot')

rp.seasonpass.AddQuest( "easy_quest_90", "Найди 3 любых предметов в Ящиках с Лутом" )
	:SetDifficulty(1)
	:SetLevelScores(400)
	:SetCompleteProgress(3)
	:SetType('take_loot')

rp.seasonpass.AddQuest( "easy_quest_100", "Найди 5 любых предметов в Ящиках с Лутом" )
	:SetDifficulty(1)
	:SetLevelScores(400)
	:SetCompleteProgress(5)
	:SetType('take_loot')


------------------------------------------------------------
------------------------- 2 Звезды -------------------------
------------------------------------------------------------

rp.seasonpass.AddQuest("medium_quest_10", "Захвати 1 любую контрольную точку")
	:SetDifficulty(2)
	:SetLevelScores(700)
	:SetCompleteProgress(1)
	:SetType('captured_point')

rp.seasonpass.AddQuest("medium_quest_20", "Захвати 2 любых контрольных точки")
	:SetDifficulty(2)
	:SetLevelScores(700)
	:SetCompleteProgress(2)
	:SetType('captured_point')

rp.seasonpass.AddQuest("medium_quest_30", "Поиграй за любую профессию ВСУ 30 минут")
	:SetDifficulty(2)
	:SetLevelScores(700)
	:SetCompleteProgress(1800)
	:SetType('faction_played_10_sec', {
		faction = FACTION_MILITARY,
	})

rp.seasonpass.AddQuest("medium_quest_40", "Поиграй за любую профессию НИГ 30 минут")
	:SetDifficulty(2)
	:SetLevelScores(700)
	:SetCompleteProgress(1800)
	:SetType('faction_played_10_sec', {
		faction = FACTION_ECOLOG,
	})

rp.seasonpass.AddQuest("medium_quest_50", "Облутайте 3-их игроков")
	:SetDifficulty(2)
	:SetLevelScores(700)
	:SetCompleteProgress(3)
	:SetType('loot_players')

rp.seasonpass.AddQuest("medium_quest_60", "Облутайте 4-ых игроков")
	:SetDifficulty(2)
	:SetLevelScores(700)
	:SetCompleteProgress(4)
	:SetType('loot_players')

rp.seasonpass.AddQuest("medium_quest_70", "Облутайте 5-ых игроков")
	:SetDifficulty(2)
	:SetLevelScores(700)
	:SetCompleteProgress(5)
	:SetType('loot_players')

rp.seasonpass.AddQuest("medium_quest_80", "Проведи успешное ограбление")
	:SetDifficulty(2)
	:SetLevelScores(700)
	:SetCompleteProgress(1)
	:SetType('start_hesit')

rp.seasonpass.AddQuest( "medium_quest_120", "Найди 10 любых предметов в Ящиках с Лутом" )
	:SetDifficulty(2)
	:SetLevelScores(700)
	:SetCompleteProgress(10)
	:SetType('take_loot')

rp.seasonpass.AddQuest( "medium_quest_130", "Найди 15 любых предметов в Ящиках с Лутом" )
	:SetDifficulty(2)
	:SetLevelScores(700)
	:SetCompleteProgress(15)
	:SetType('take_loot')

rp.seasonpass.AddQuest( "medium_quest_140", "Найди 20 любых предметов в Ящиках с Лутом" )
	:SetDifficulty(2)
	:SetLevelScores(700)
	:SetCompleteProgress(20)
	:SetType('take_loot')
------------------------------------------------------------
------------------------- 3 Звезды -------------------------
------------------------------------------------------------
rp.seasonpass.AddQuest("hard_quest_10", "Отыграйте 90 минут")
  :SetDifficulty(3)
  :SetLevelScores(1400)
  :SetCompleteProgress(90)
  :SetType('game_played_1_min')

rp.seasonpass.AddQuest("hard_quest_20", "Отыграйте 120 минут")
  :SetDifficulty(3)
  :SetLevelScores(1400)
  :SetCompleteProgress(120)
  :SetType('game_played_1_min')

rp.seasonpass.AddQuest("hard_quest_30", "Отыграйте 150 минут")
  :SetDifficulty(3)
  :SetLevelScores(1400)
  :SetCompleteProgress(150)
  :SetType('game_played_1_min')