-- "gamemodes\\darkrp\\gamemode\\config\\randomize_job_npc.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local Color = Color
local translates_Get = translates.Get


rp.cfg.RandomizeJobNpc = rp.cfg.RandomizeJobNpc or {}

-- Модель нпс
rp.cfg.RandomizeJobNpc.Model = "models/player/stalker_lone/lone_seva/lone_seva.mdl"

-- Название в бабле
rp.cfg.RandomizeJobNpc.BubbleLabel = translates_Get("Случайная Профессия")

-- Цвет заголовка бабла
rp.cfg.RandomizeJobNpc.BubbleTitleColor = Color(255, 255, 255)

-- Цвет иконки бабла
rp.cfg.RandomizeJobNpc.BubbleIconColor = Color(255, 255, 255)

-- Кулдаун смены профы (в секундах)
rp.cfg.RandomizeJobNpc.RandomJobCooldown = 18000

-- Количество смертей за профу
rp.cfg.RandomizeJobNpc.DeathsCount = 3

-- Списко проф для рандома
rp.cfg.RandomizeJobNpc.JobsList = {
    TEAM_GENDOLG,
    TEAM_POLKDOLG,
    TEAM_PODDOLG,
    TEAM_LEADSVOB,
    TEAM_MASTSVOB,
    TEAM_VETERSVOB,
    TEAM_HARON,
    TEAM_SULTAN,
    TEAM_BRIGADIR,
    TEAM_REBEL_VETERAN,
    TEAM_GAVAECKEYS,
    TEAM_SHUSTRIY,
    TEAM_GENERAL,
    TEAM_SEC,
    TEAM_SNIPERMAY, 
}
