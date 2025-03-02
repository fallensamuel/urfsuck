-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\zz_job_options.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal


-- utitlies.lua

rp.AddToRadioChannel(2, translates.Get("Фракционная Частота"), rp.GetFactionTeams(FACTION_ADMINS))

-- ВАНИЛЬНЫЕ ФРАКЦИЯ

-- ДОЛГ

rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_DOLG})))
rp.AddDoorGroup('Долг', rp.GetFactionTeams(FACTION_DOLG))
rp.AddToRadioChannel(2, translates.Get("Фракционная Частота"), rp.GetFactionTeams(FACTION_DOLG)) 

rp.AddRelationships(TEAM_PODDOLG, RANK_TRAINER, {FACTION_DOLG})
rp.AddRelationships(TEAM_GENDOLG, RANK_LEADER, {FACTION_DOLG})
rp.AddRelationships(TEAM_VORONIN, RANK_LEADER, {FACTION_DOLG})
rp.AddRelationships(TEAM_POLKDOLG, RANK_OFFICER, {FACTION_DOLG})

-- НИГ

rp.AddDoorGroup('НИГ', rp.GetFactionTeams({FACTION_ECOLOG}))
rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_ECOLOG})))
rp.AddToRadioChannel(2, translates.Get("Фракционная Частота"), rp.GetFactionTeams(FACTION_ECOLOG))

rp.AddRelationships(TEAM_ECOLOG_STAR, RANK_TRAINER, {FACTION_ECOLOG})
rp.AddRelationships(TEAM_UCHENIY, RANK_LEADER, {FACTION_ECOLOG})
rp.AddRelationships(TEAM_ECOLOG_OHRAN_STAR, RANK_OFFICER, {FACTION_ECOLOG})
rp.AddRelationships(TEAM_ECOLOG_SILI, RANK_OFFICER, {FACTION_ECOLOG})

-- НАЕМНИКИ

rp.AddDoorGroup('Наемники', rp.GetFactionTeams(FACTION_HITMANSOLO))
rp.addGroupChat(unpack(rp.GetFactionTeams(FACTION_HITMANSOLO)))
rp.AddToRadioChannel(2, translates.Get("Фракционная Частота"), rp.GetFactionTeams(FACTION_HITMANSOLO))

-- ВСУ

rp.AddDoorGroup('Армия Украины', rp.GetFactionTeams(FACTION_MILITARY))
rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_MILITARY})))
rp.AddToRadioChannel(2, translates.Get("Фракционная Частота"), rp.GetFactionTeams(FACTION_MILITARY)) 

rp.AddRelationships(TEAM_EPU, RANK_TRAINER, {FACTION_MILITARY})
rp.AddRelationships(TEAM_GENERAL, RANK_LEADER, {FACTION_MILITARY})
rp.AddRelationships(TEAM_SEC, RANK_OFFICER, {FACTION_MILITARY})

-- МОНОЛИТ

rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_MONOLITH})))
rp.AddDoorGroup('Монолит', rp.GetFactionTeams(FACTION_MONOLITH))
rp.AddToRadioChannel(2, translates.Get("Фракционная Частота"), rp.GetFactionTeams(FACTION_MONOLITH)) 

rp.AddRelationships(TEAM_HARON, RANK_LEADER, {FACTION_MONOLITH})
rp.AddRelationships(TEAM_SUPERVISOR, RANK_LEADER, {FACTION_MONOLITH})
rp.AddRelationships(TEAM_INKV, RANK_OFFICER, {FACTION_MONOLITH})
rp.AddRelationships(TEAM_SNIPMONOL, RANK_OFFICER, {FACTION_MONOLITH})

-- БАндосы

rp.AddDoorGroup('Бандиты', rp.GetFactionTeams(FACTION_REBEL))
rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_REBEL})))
rp.AddToRadioChannel(2, translates.Get("Фракционная Частота"), rp.GetFactionTeams({FACTION_REBEL, FACTION_REBELVIP}))

rp.AddRelationships(TEAM_REBEL_VETERAN, RANK_TRAINER, {FACTION_REBEL})
rp.AddRelationships(TEAM_SULTAN, RANK_LEADER, {FACTION_REBEL})
rp.AddRelationships(TEAM_BOROV, RANK_LEADER, {FACTION_REBEL})
rp.AddRelationships(TEAM_BRIGADIR, RANK_OFFICER, {FACTION_REBEL})

-- Свобода

rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_SVOBODA})))
rp.AddDoorGroup('Свобода', rp.GetFactionTeams(FACTION_SVOBODA))
rp.AddToRadioChannel(2, translates.Get("Фракционная Частота"), rp.GetFactionTeams(FACTION_SVOBODA)) 

rp.AddRelationships(TEAM_VETERSVOB, RANK_TRAINER, {FACTION_SVOBODA})
rp.AddRelationships(TEAM_LEADSVOB, RANK_LEADER, {FACTION_SVOBODA})
rp.AddRelationships(TEAM_LUKASH, RANK_LEADER, {FACTION_SVOBODA})
rp.AddRelationships(TEAM_MASTSVOB, RANK_OFFICER, {FACTION_SVOBODA})

-- Бармены

rp.AddToRadioChannel(2, translates.Get("Фракционная Частота"), {TEAM_SHUSTRIY, TEAM_SIDORIVENT}, rp.GetFactionTeams(FACTION_CITIZEN, FACTION_REFUGEES))
rp.AddDoorGroup('Бар', {TEAM_JEW, TEAM_KROT, TEAM_KOLPAK, TEAM_IOHAN, TEAM_SIDORIVENT,TEAM_GAVAECKEYS})
rp.addGroupChat(unpack(rp.GetFactionTeams({FACTION_CITIZEN, FACTION_REFUGEES})))