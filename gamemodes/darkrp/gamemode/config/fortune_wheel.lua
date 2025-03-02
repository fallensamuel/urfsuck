-- "gamemodes\\darkrp\\gamemode\\config\\fortune_wheel.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.cfg.FortuneWheel = rp.cfg.FortuneWheel or {}

-- Таблица иконок для наград
local icons = {
    global = Material("rpui/icons/globaladmin", "smooth noclamp"),
    job = Material("rpui/icons/magicianmangle", "smooth noclamp"),
    gun = Material("rpui/seasonpass/item/weapon", "smooth noclamp"),
    case = Material("rpui/icons/case", "smooth noclamp"),
    money = Material("rpui/icons/money", "smooth noclamp"),
    credits = Material("rpui/icons/credits", "smooth noclamp"),
    hours_5 = Material("rpui/icons/5h", "smooth noclamp"),
    hours_10 = Material("rpui/icons/10h", "smooth noclamp"),
    hours_30 = Material("rpui/icons/30h", "smooth noclamp"),
    time_x3 = Material("rpui/icons/x3", "smooth noclamp"),    
    time_x5 = Material("rpui/icons/x5", "smooth noclamp"),
}

-- Модель колеса (путь)
rp.cfg.FortuneWheel.Model = "models/freeman/owain_mystery_wheel_urfim.mdl"

-- Скин колеса (индекс)
rp.cfg.FortuneWheel.Skin = 4

-- Звук прокрутки колеса (щелчки)
rp.cfg.FortuneWheel.SpinSound = "pcasino/other/mystery_spin.wav"

-- Второй звук прокрутки
rp.cfg.FortuneWheel.OtherSpinSound = "fortune_music.mp3"

-- Стоимость прокрутки
rp.cfg.FortuneWheel.SpinCost = 29

-- Необходимое время для бесплатной прокрутки (в секундах)
rp.cfg.FortuneWheel.FreeSpinTime = 15 * 3600

-- Названия редкости награды (для отображения в тултипе)
rp.cfg.FortuneWheel.Rarities = {
    [1] = "Обычный",
    [2] = "Редкий",
    [3] = "Мифический",
    [4] = "Легендарный",
    [5] = "Артефакт",
}

-- Цвета редкости награды (для текста тултипа и нотифая в чат, а также градиента)
rp.cfg.FortuneWheel.Colors = {
    [1] = Color(218, 218, 218),
    [2] = Color(97, 255, 58),
    [3] = Color(117, 49, 227),
    [4] = Color(240, 181, 25),
    [5] = Color(213, 88, 80),
}

-- Таблица наград
rp.cfg.FortuneWheel.Rewards = {
    [20] = {
        title = "★", text = "3250 ГРН", func = "money", rarity = 1,
        value = 3250,
        icon = icons.money,
        sound = "wheel_win.mp3",
        chance = 19,
        desc_title = "3250 ГРН",
        desc = "3250 гривен на твой аккаунт!",
        hideChatNotify = true,
    },
    [19] = {
        title = "ВРЕМЯ", text = "5 Часов", func = "time", rarity = 1,
        value = 5,
        icon = icons.hours_5,
        sound = "wheel_win.mp3",
        chance = 17.41,
        desc_title = "5 Часов",
        desc = "5 игровых часов на твой аккаунт!",
        hideChatNotify = true,
    },
    [18] = {
        title = "УМНОЖЕНИЕ", text = "х3 Время на 3 Часа", func = "time_mult", rarity = 1,
        value = {count = 3, time = "3h"},
        icon = icons.time_x3,
        sound = "wheel_win.mp3",
        chance = 11.5,
        desc_title = "х3 Время на 3 Часа",
        desc = "Прирост игрового времени будет увеличен в 3 раза на 3 часа!",
        isTemporary = true,
        hideChatNotify = true,
    },
    [17] = {
        title = "★", text = "29 Кредитов", func = "credit", rarity = 1,
        value = 29,
        icon = icons.credits,
        sound = "wheel_win.mp3",
        chance = 8.9,
        desc_title = "29 Кредитов",
        desc = "29 игровых кредитов на твой аккаунт!",
        hideChatNotify = true,
    },
    [16] = {
        title = "КЕЙС ★", text = "Кейс Умножения", func = "case", rarity = 1,
        value = "time_case",
        icon = icons.case,
        sound = "wheel_win.mp3",
        chance = 7.9,
        desc_title = "Кейс Умножения",
        desc = "Кейс Умножения на твой аккаунт!",
        hideChatNotify = true,
    },
    [15] = {
        title = "КЕЙС ★", text = "Кейс Бандитов", func = "case", rarity = 1,
        value = "cadet_case",
        icon = icons.case,
        sound = "wheel_win.mp3",
        chance = 4.7,
        desc_title = "Кейс Бандитов",
        desc = "Кейс Вечного Новичка на твой аккаунт!",
        hideChatNotify = true,
    },
    [14] = {
        title = "УМНОЖЕНИЕ", text = "х5 Время на 3 Часа", func = "time_mult", rarity = 2,
        value = {count = 5, time = "3h"},
        icon = icons.time_x5,
        sound = "wheel_win.mp3",
        chance = 4.69,
        desc_title = "х5 Время на 3 Часа",
        desc = "Прирост игрового времени будет увеличен в 5 раз на 3 часа!",
        isTemporary = true,
        hideChatNotify = true,
    },
    [13] = {
        title = "ВРЕМЯ", text = "10 Часов", func = "time", rarity = 2,
        value = 10,
        icon = icons.hours_10,
        sound = "wheel_win.mp3",
        chance = 4.6,
        desc_title = "10 Часов",
        desc = "10 игровых часов на твой аккаунт!",
        hideChatNotify = true,
    },
    [12] = {
        title = "★★", text = "6500 ГРН", func = "money", rarity = 2,
        value = 6500,
        icon = icons.money,
        sound = "wheel_win.mp3",
        chance = 3.7,
        desc_title = "6500 ГРН",
        desc = "6500 ГРН на твой аккаунт!",
        hideChatNotify = true,
    },
    [11] = {
        title = "★★", text = "50 Кредитов", func = "credit", rarity = 2,
        value = 50,
        icon = icons.credits,
        sound = "wheel_win.mp3",
        chance = 3.3,
        desc_title = "50 Кредитов",
        desc = "50 игровых кредитов на твой аккаунт!",
        hideChatNotify = true,
    },
    [10] = {
        title = "КЕЙС ★★", text = "Кейс Наставника", func = "case", rarity = 2,
        value = "rep_case",
        icon = icons.case,
        sound = "wheel_win.mp3",
        chance = 2.74,
        desc_title = "Кейс Наставника",
        desc = "Кейс Наставника на твой аккаунт!",
        hideChatNotify = true,
    },
    [9] = {
        title = "★★★", text = "100 Кредитов", func = "credit", rarity = 3,
        value = 100,
        icon = icons.credits,
        sound = "wheel_win.mp3",
        chance = 2.5,
        desc_title = "100 Кредитов",
        desc = "100 игровых кредитов на твой аккаунт!",
    },
    [8] = {
        title = "★★★", text = "18000 ГРН", func = "money", rarity = 3,
        value = 18000,
        icon = icons.money,
        sound = "wheel_win.mp3",
        chance = 2.5,
        desc_title = "18000 ГРН",
        desc = "18000 ГРН на твой аккаунт!",
    },
    [7] = {
        title = "ВРЕМЯ", text = "30 Часов", func = "time", rarity = 3,
        value = 30,
        icon = icons.hours_30,
        sound = "wheel_win.mp3",
        chance = 2.3,
        desc_title = "30 Часов",
        desc = "30 игровых часов на твой аккаунт!",
    },
    [6] = {
        title = "КЕЙС ★★★", text = "Кейс «Счастливый Шанс»", func = "case", rarity = 3,
        value = "bot_lucky_case",
        icon = icons.case,
        sound = "wheel_win.mp3",
        chance = 1.52,
        desc_title = "Кейс «Счастливый Шанс»",
        desc = "Кейс «Счастливый Шанс» на твой аккаунт!",
    },
    [5] = {
        title = "КЕЙС ★★★", text = "Кейс Легенды ЧЗО", func = "case", rarity = 3,
        value = "galactic_case",
        icon = icons.case,
        sound = "wheel_win.mp3",
        chance = 1.2,
        desc_title = "Кейс Легенды ЧЗО",
        desc = "Кейс Легенды ЧЗО на твой аккаунт!",
    },
    [4] = {
        title = "★★★★", text = "199 Кредитов", func = "credit", rarity = 4,
        value = 199,
        icon = icons.credits,
        sound = "wheel_win.mp3",
        chance = 0.52,
        desc_title = "199 Кредитов",
        desc = "199 игровых кредитов на твой аккаунт!",
    },
    [3] = {
        title = "ОРУЖИЕ", text = "ВСС Прибой", func = "weapon", rarity = 4,
        value = {time = "14d", class = "tfa_anomaly_vintorez_nimble"},
        icon = icons.gun,
        sound = "wheel_win.mp3",
        chance = 1.0099,
        desc_title = "ВСС Прибой",
        desc = "Мощнейший ВСС Прибой на 14 дней!",
        isTemporary = true,
    },
    [2] = {
        title = "★★★★★", text = "5000 Кредитов", func = "credit", rarity = 5,
        value = 5000,
        icon = icons.credits,
        sound = "wheel_win.mp3",
        chance = 0.01,
        desc_title = "5000 Кредитов",
        desc = "5000 игровых кредитов на твой аккаунт!",
    },
    [1] = {
        title = "ГЛОБАЛ", text = "Global Admin", func = "rank", rarity = 5,
        value = {time = "9999d", rank = "globaladmin"},
        icon = icons.global,
        sound = "wheel_win.mp3",
        chance = 0.0001,
        desc_title = "Global Admin",
        desc = "Привелегия - Global Admin навсегда на твой аккаунт!",
        isTemporary = true,
    },
}