-- "gamemodes\\darkrp\\gamemode\\config\\cfg.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.cfg.DisableF4Crafting = true;

rp.cfg.AutoEvents = {
        ['rp_limanskhospital_urfim'] = {
        {
            name = 'Лиманская Больница',
            start_score = 2000, -- Стартовое кол-во очков у сторон
            score_per_death = 1, -- Сколько очков отнимается при респавне игрока

            default_points_owner = function() return ALLIANCE_BANDITS end,

            npc = {
                name = 'Выбери Сторону',
                pos = Vector(1008, -2810, 20),
                ang = Angle(0, 173, 0),
                model = 'models/player/stalker_lone/lone_jacket/lone_jacket.mdl',
            },

            commands = {
                {
                    name = 'Чистое Небо',
                    img = Material('stalker/icons/clearsky_logo.png', 'smooth noclamp'), -- Лого стороны
                    color = Color(220, 20, 60), -- Цвет стороны
                    alliance = function() return ALLIANCE_CLEAR end, -- Альянс стороны
                    on_select = function(ply)
                      ply:ChangeTeam(TEAM_EVENTNEBOONE, true, true) -- Стартовая профессия после выбора стороны
                    end,
                },
                {
                    name = 'Монолит',
                    img = Material('stalker/icons/monolith_logo.png', 'smooth noclamp'),
                    color = Color(128, 128, 128),
                    alliance = function() return ALLIANCE_MONOLIT end,
                    on_select = function(ply)
                      ply:ChangeTeam(TEAM_EVENTMONONE, true, true)
                    end,
                },
            },
        },
    },
}

rp.cfg.Scoreboard = {
    Socials = {
        ["urf_discord"] = false,
        ["urf_media"] = false,
        ["vk"] = {
            icon = "vk",
            label = "Наш ВК",
            color = Color( 0, 119, 255 ),
            url = "https://vk.com/stalkerrp"
        },
        ["discord"] = {
            icon = "discord",
            label = "Наш Discord",
            color = Color( 114, 137, 218 ),
            url = "https://urf.im/discord"
        },
        ["youtube"] = {
            icon = "youtube",
            label = "Наш YouTube",
            color = Color( 255, 0, 0 ),
            url = "https://www.youtube.com/@urfim_gmod"
        },
    },

    Columns = {
        ["playtime"] = {
            order = 45,
            label = "Онлайн",
            align = TEXT_ALIGN_CENTER,
            grow = 2,
            paint = function( this, w, h, data )
                local ply = data["player"];
                draw.SimpleText( rp.Scoreboard.Utils.FormattedTime(ply:GetPlayTime() or 0), "rpui.Fonts.ScoreboardDefault", w * 0.5, h * 0.5, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER );
            end,
        }
    },
};

rp.cfg.Pimp = {
    {
        name = "// ВСУ",
        model = "models/player/stalker_soldier/soldier_bulat_proto/soldier_bulat_proto.mdl",
        pos = Vector(-11036, -10653, -384),
        ang = Angle(0, -4, 0),
        onSpawn = function( ent )
        end,
    },
}

/*rp.cfg.RPS.MaxBet = 1000000

-- Звук ожидания игрока
rp.cfg.RPS.IdleSound = ""

-- Звук старта игры
rp.cfg.RPS.GameSound = ""

-- Звук окончания игры
rp.cfg.RPS.ResultSound = ""*/

rp.cfg.Broom = {
    Cooldown = 5,
    Radius = math.pow(64, 2),
    Amount = 5,
    CleanedAmount = 5,

    MoneyRewards = {
        [70] = {5, 10},
        [25] = {11, 20},
        [5] = {21, 35}
    },

    ItemRewards = {
        --[20] = {"rpitem_steel", "rpitem_battery", "rpitem_procc"},
        --[5] = {"ent_medpack", "armor_piece_full", "rpitem_procc"},
       -- [1] = {"rpitem_comb_list", "rpitem_comb_procc", "rpitem_comb_caps"}
    },
};

rp.cfg.Stashing = {
    Messages = {
        ["ERR_ALREADY_IN_CHALLENGE"] = translates.Get( "Вы уже спрятали секретную документацию" ),
        ["ERR_SPOTS_NOT_AVAILABLE"] = translates.Get( "Вы не можете спрятать секретную документацию" ),
        ["ERR_NO_SPOT"] = translates.Get( "Нет доступного места захоронения" ),
        ["ERR_INTERRUPT"] = translates.Get( "Вам помешали спрятать секретную документацию" ),
        ["ERR_NOT_ALIVE"] = translates.Get( "Вы не можете спрятать секретную документацию мертвым" ),
        ["ERR_KNOCKED_DOWN"] = translates.Get( "Вы не можете спрятать спрятать секретную документацию находять при смерти!" ),
        ["ERR_TOO_FAR"] = translates.Get( "Точка захоронения была отмечена на экране" ),
        ["ERR_NOT_IN_CHALLENGE"] = translates.Get( "Вы не прячите секретную документацию" ),
    },

    Spots = {
        Radius = 76,
        ["rp_stalker_urfim"] = {
      Vector(4301, 6716, -364),
      Vector(6663, 1538, -315),
      Vector(11973, -1886, -122),
      Vector(-5104, -6891, -128),
      Vector(5490, -3952, 223),
      Vector(8569, -10480, -375),
      Vector(2850, -6815, 32),
      Vector(659, 9747, -384),
    },
    },

    Challenge = {
        Rate = 1 / 4,
        Length = 30,
        Alert = {
            Rate = 2 / 1,
            Chance = 0.75,
            Sounds = { "physics/cardboard/cardboard_box_shake1.wav", "physics/cardboard/cardboard_box_shake2.wav", "physics/cardboard/cardboard_box_shake3.wav" }
        }
    },

    Circles = {
        Rate = 1 / 2,
        Radius = 0.075,
        Overscale = 6,
        Lifetime = 1.33,
        Bonus = 0.1,
        Sound = "ui/buttonclick.wav"
    },
};

--rp.cfg.Gifts = {
--    ["rp_stalker_urfim_v3"] = {
--        {
--            type = "points_credits",
--            origin = Vector(-5557, -13759, -4112),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(-7325, -12239, -3874),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(-4005, -13461, -3738),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(25, -12233, -4242),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(6631, -11444, -3664),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(8503, -9286, -3385),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(8302, -6434, -3824),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(3268, -1005, -4267),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(370, 604, -3929),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(-6323, 1852, -3840),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(-11910, -657, -4236),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(-10422, 2451, -4341),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(-14994, 8401, -3860),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(3900, 10258, -3822),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(624, 8433, -4096),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(2868, 6193, -3916),
--            cooldown = 300,
--        },
--        {
--            type = "points_credits",
--            origin = Vector(-1643, 1606, -3803),
--            cooldown = 300,
--        },
--    }
--};

rp.cfg.ReferralRewards = {
    ["Referrer"] = { -- Награды приглашающего игрока
        { -- Первая награда
            type = "AWARD_CASE",
            name = "Кейс Наставника", -- Название награды
            icon = Material("cases_icons/ref_old", "smooth"), -- Иконка награды
            colors = {Color(240, 181, 25), Color(254, 121, 4)}, -- (необязательно) Цвет награды
            value = 'ref_old', -- Что/количество выдаваемой награды
        },

        { -- Вторая награда
            type = "AWARD_CREDITS", -- Тип награды
            name = "25 Кредитов", -- Название награды
            icon = Material("cases_icons/credits.png", "smooth"), -- Иконка награды
            colors = {Color(240, 181, 25), Color(254, 121, 4)}, -- (необязательно) Цвет награды
            value = 25, -- Что/количество выдаваемой награды
        },
    },

    ["Referee"] = { -- Награды приглашенного игрока
        { -- Первая награда
            type = "AWARD_CASE",
            name = "Кейса Мега Буста", -- Название награды
            icon = Material("cases_icons/ref_new", "smooth"), -- Иконка награды
            colors = {Color(76, 204, 89), Color(0, 102, 0)}, -- (необязательно) Цвет награды
            value = 'ref_new', -- Что/количество выдаваемой награды
        },

        { -- Вторая награда
            type = "AWARD_CREDITS", -- Тип награды
            name = "25 Кредитов", -- Название награды
            icon = Material("cases_icons/credits.png", "smooth"), -- Иконка награды
            colors = {Color(76, 204, 89), Color(0, 102, 0)}, -- (необязательно) Цвет награды
            value = 25, -- Что/количество выдаваемой награды
        },
    }
};

rp.cfg.SoulAltar = {
	["swb_doubleshotgun"] = 6,
	["swb_eliminator_greh"] = 12,
	["swb_mephistophel"] = 8,
	["swb_psg1_greh"] = 10,
	["swb_hound"] = 3,
};

rp.cfg.EnableUIRedesign = true;

rp.cfg.DisableMinimap = game.GetMap() == 'rp_limanskhospital_urfim'
rp.cfg.ServerUID             = "stalker_vanilla";

-- 30 лвл
rp.cfg.SeasonpassPrices = {
    oneSeason       = 249,
    threeSeasons    = 599,
    allSeasons      = 999,

    levels          = { 149, 399, 649, 999 },
}


rp.cfg.CustomTerminalBans = { 7, 14, 21 }
rp.cfg.MaxBanTime = { 24 * 60 * 60, '24h' }

rp.cfg.DisableCustomRun = true
rp.cfg.DisableRPUILoots = true

rp.cfg.DisableProneMod = true

rp.cfg.EnableGlobalChat = true
rp.cfg.DisableEmployersHide = true

rp.cfg.EnableUIRedesign      = true;

rp.cfg.EnableAttributes = true
rp.cfg.EnableDiplomacy = true

rp.cfg.ServerContentWorkshop = "https://steamcommunity.com/sharedfiles/filedetails/?id=1569141045";
rp.cfg.VKGroup               = "https://vk.com/stalkerrp";

rp.cfg.AutoGhostAllEnts = false
rp.cfg.AllowGhostingAllEntities = true

rp.cfg.Social = {
	/*steam = {
		bonus_text = '30 кредитов',
		bonus_func = function(ply) ply:AddCredits(30, 'steam join') end,
		bonus_info = 'Подпишитесь на нашу группу Steam, чтобы мгновенно\nполучить награду.',

		link = 'http://steamcommunity.com/groups/urfimofficial',
		handler = 'http://api.urf.im/handler/steam_group.php?sv=stalker',
	},*/
	discord = {
		bonus_text = '30 кредитов',
		bonus_func = function(ply) ply:AddCredits(30, 'discord join') end,
		bonus_info = 'Подпишитесь на наш Discord и бот пришлёт вам промокод\nв личные сообщения. Если вы уже подписаны, нажмите на смайлик\nракеты в канале "Промокоды".',
		is_promo = true,

		link = 'https://discord.gg/6Xfhrjy',
	},
	vk = {
		bonus_text = function(ply) return (ply:GetRankTable().ID > 1) and '30 кредитов' or 'VIP на 12 часов' end,
		bonus_func = function(ply)
			if ply:GetRankTable().ID > 1 then
				ply:AddCredits(30, 'vk join')

			else
				RunConsoleCommand("urf", "setgroup", ply:SteamID(), 'vip', "12h", ply:GetUserGroup())
			end
		end,
		bonus_info = 'Подпишитесь на нашу группу ВК и напишите "Начать" в\nсообщения сообщества, чтобы бот прислал вам промокод.',
		is_promo = true,

		link = 'https://vk.com/im?sel=-134450780',
	},
	vk_bday_vip = {
		bonus_text = 'Временный VIP',
		bonus_func = function(ply)
			if ply:GetRank() == 'user' then
				RunConsoleCommand("urf", "setgroup", ply:SteamID(), 'vip', "24h", ply:GetUserGroup())
			end
		end,
	},
	vk_bday_credits = {
		bonus_text = '75 кредитов',
		bonus_func = function(ply)
			ply:AddCredits(75, 'vk bday promo')
		end,
	},
	vk_bday_time = {
		bonus_text = 'x10 времени на час',
		bonus_func = function(ply)
			ply:AddTimeMultiplayerSaved('vk_bday_time', 9, 60 * 60)
		end,
	},
	teleg = {
		bonus_text = 'Кейс',
		bonus_func = function(ply) rp.lootbox.Give(ply, 'tg_case') end,
		bonus_info = 'Открой ссылку в браузере или на телефоне, после\nчего нажми кнопку Start. Наш бот отправит тебе\nпромокод на кейс.',
		is_promo = true,

		link = 'https://t.me/HelperUrfIm_bot',
	},
	youtube = {
        {
        channel_id = 'UCrATiSPFbfR1aRV3CsTqPwQ',
        bonus_text = 'YouTube Кейс',
        bonus_func = function(ply) rp.lootbox.Give(ply, 'youtube_case') end,
        bonus_info = 'Подпишись на наш YouTube канал и получи YouTube Кейс!',
        }
    };
}

-- Верстак
--rp.cfg.WorkbenchWhitelist = true

rp.cfg.WhitelistedProps = [[ [{"Model":"models/balloons/balloon_classicheart.mdl"}, {"Model":"models/balloons/balloon_dog.mdl"}, {"Model":"models/balloons/balloon_star.mdl"}, {"Model":"models/bin.mdl"}, {"Model":"models/box_black.mdl"}, {"Model":"models/domitibingen/foliage/deciduous_tree/weepingwillow_01/weepingwillow_01.mdl"}, {"Model":"models/griim/christmas/reindeer_1.mdl"}, {"Model":"models/griim/christmas/reindeer_2.mdl"}, {"Model":"models/hgn/srp/items/backpack-1.mdl"}, {"Model":"models/hgn/srp/items/backpack-2.mdl"}, {"Model":"models/hgn/srp/items/guitar.mdl"}, {"Model":"models/hunter/blocks/cube025x025x025.mdl"}, {"Model":"models/hunter/blocks/cube025x05x025.mdl"}, {"Model":"models/hunter/blocks/cube025x075x025.mdl"}, {"Model":"models/hunter/blocks/cube025x125x025.mdl"}, {"Model":"models/hunter/blocks/cube025x150x025.mdl"}, {"Model":"models/hunter/blocks/cube025x1x025.mdl"}, {"Model":"models/hunter/blocks/cube025x2x025.mdl"}, {"Model":"models/hunter/blocks/cube025x3x025.mdl"}, {"Model":"models/hunter/blocks/cube025x4x025.mdl"}, {"Model":"models/hunter/blocks/cube025x5x025.mdl"}, {"Model":"models/hunter/blocks/cube025x6x025.mdl"}, {"Model":"models/hunter/blocks/cube025x7x025.mdl"}, {"Model":"models/hunter/blocks/cube025x8x025.mdl"}, {"Model":"models/hunter/blocks/cube05x05x025.mdl"}, {"Model":"models/hunter/blocks/cube05x05x05.mdl"}, {"Model":"models/hunter/blocks/cube05x075x025.mdl"}, {"Model":"models/hunter/blocks/cube05x105x05.mdl"}, {"Model":"models/hunter/blocks/cube05x1x025.mdl"}, {"Model":"models/hunter/blocks/cube05x1x05.mdl"}, {"Model":"models/hunter/blocks/cube05x2x025.mdl"}, {"Model":"models/hunter/blocks/cube05x2x05.mdl"}, {"Model":"models/hunter/blocks/cube05x3x025.mdl"}, {"Model":"models/hunter/blocks/cube05x3x05.mdl"}, {"Model":"models/hunter/blocks/cube05x4x025.mdl"}, {"Model":"models/hunter/blocks/cube05x4x05.mdl"}, {"Model":"models/hunter/blocks/cube05x5x025.mdl"}, {"Model":"models/hunter/blocks/cube05x5x05.mdl"}, {"Model":"models/hunter/blocks/cube05x6x025.mdl"}, {"Model":"models/hunter/blocks/cube05x6x05.mdl"}, {"Model":"models/hunter/blocks/cube05x7x025.mdl"}, {"Model":"models/hunter/blocks/cube05x7x05.mdl"}, {"Model":"models/hunter/blocks/cube05x8x025.mdl"}, {"Model":"models/hunter/blocks/cube05x8x05.mdl"}, {"Model":"models/hunter/blocks/cube075x075x025.mdl"}, {"Model":"models/hunter/blocks/cube075x075x075.mdl"}, {"Model":"models/hunter/blocks/cube075x1x025.mdl"}, {"Model":"models/hunter/blocks/cube075x2x025.mdl"}, {"Model":"models/hunter/blocks/cube075x2x075.mdl"}, {"Model":"models/hunter/blocks/cube075x3x025.mdl"}, {"Model":"models/hunter/blocks/cube075x4x025.mdl"}, {"Model":"models/hunter/blocks/cube075x6x025.mdl"}, {"Model":"models/hunter/blocks/cube075x8x025.mdl"}, {"Model":"models/hunter/blocks/cube1x150x1.mdl"}, {"Model":"models/hunter/blocks/cube1x1x025.mdl"}, {"Model":"models/hunter/blocks/cube1x2x025.mdl"}, {"Model":"models/hunter/blocks/cube1x3x025.mdl"}, {"Model":"models/hunter/blocks/cube1x4x025.mdl"}, {"Model":"models/hunter/blocks/cube1x5x025.mdl"}, {"Model":"models/hunter/blocks/cube1x6x025.mdl"}, {"Model":"models/hunter/blocks/cube1x7x025.mdl"}, {"Model":"models/hunter/blocks/cube1x8x025.mdl"}, {"Model":"models/hunter/blocks/cube2x2x025.mdl"}, {"Model":"models/hunter/blocks/cube2x3x025.mdl"}, {"Model":"models/hunter/blocks/cube2x4x025.mdl"}, {"Model":"models/hunter/blocks/cube2x6x025.mdl"}, {"Model":"models/hunter/blocks/cube3x3x025.mdl"}, {"Model":"models/hunter/blocks/cube3x4x025.mdl"}, {"Model":"models/hunter/blocks/cube3x6x025.mdl"}, {"Model":"models/hunter/blocks/cube3x8x025.mdl"}, {"Model":"models/hunter/blocks/cube4x4x025.mdl"}, {"Model":"models/hunter/blocks/cube8x8x1.mdl"}, {"Model":"models/hunter/geometric/hex025x1.mdl"}, {"Model":"models/hunter/geometric/hex1x1.mdl"}, {"Model":"models/hunter/geometric/pent1x1.mdl"}, {"Model":"models/hunter/geometric/tri1x1eq.mdl"}, {"Model":"models/hunter/misc/lift2x2.mdl"}, {"Model":"models/hunter/misc/platehole1x1a.mdl"}, {"Model":"models/hunter/misc/platehole4x4.mdl"}, {"Model":"models/hunter/misc/shell2x2c.mdl"}, {"Model":"models/hunter/misc/shell2x2d.mdl"}, {"Model":"models/hunter/misc/stair1x1.mdl"}, {"Model":"models/hunter/plates/plate1x1.mdl"}, {"Model":"models/hunter/plates/plate1x2.mdl"}, {"Model":"models/hunter/plates/plate1x3.mdl"}, {"Model":"models/hunter/plates/plate1x4.mdl"}, {"Model":"models/hunter/plates/plate1x5.mdl"}, {"Model":"models/hunter/plates/plate1x6.mdl"}, {"Model":"models/hunter/plates/plate1x7.mdl"}, {"Model":"models/hunter/plates/plate1x8.mdl"}, {"Model":"models/hunter/plates/plate2x2.mdl"}, {"Model":"models/hunter/plates/plate2x3.mdl"}, {"Model":"models/hunter/plates/plate2x4.mdl"}, {"Model":"models/hunter/plates/plate2x5.mdl"}, {"Model":"models/hunter/plates/plate3x3.mdl"}, {"Model":"models/hunter/plates/plate3x4.mdl"}, {"Model":"models/hunter/plates/plate3x5.mdl"}, {"Model":"models/hunter/plates/plate3x6.mdl"}, {"Model":"models/hunter/plates/plate4x4.mdl"}, {"Model":"models/hunter/plates/plate5x5.mdl"}, {"Model":"models/hunter/plates/platehole1x1.mdl"}, {"Model":"models/hunter/plates/platehole1x2.mdl"}, {"Model":"models/hunter/plates/platehole2x2.mdl"}, {"Model":"models/hunter/plates/platehole3.mdl"}, {"Model":"models/hunter/triangles/025x025.mdl"}, {"Model":"models/hunter/triangles/025x025mirrored.mdl"}, {"Model":"models/hunter/triangles/05x05.mdl"}, {"Model":"models/hunter/triangles/05x05mirrored.mdl"}, {"Model":"models/hunter/triangles/075x075.mdl"}, {"Model":"models/hunter/triangles/075x075mirrored.mdl"}, {"Model":"models/hunter/triangles/1x05x1.mdl"}, {"Model":"models/hunter/triangles/1x1.mdl"}, {"Model":"models/hunter/triangles/1x1mirrored.mdl"}, {"Model":"models/hunter/triangles/1x1x1.mdl"}, {"Model":"models/hunter/triangles/1x1x5.mdl"}, {"Model":"models/hunter/triangles/2x2.mdl"}, {"Model":"models/hunter/triangles/2x2mirrored.mdl"}, {"Model":"models/hunter/triangles/3x3.mdl"}, {"Model":"models/hunter/triangles/3x3mirrored.mdl"}, {"Model":"models/hunter/triangles/4x4.mdl"}, {"Model":"models/hunter/triangles/4x4mirrored.mdl"}, {"Model":"models/hunter/triangles/5x5.mdl"}, {"Model":"models/hunter/tubes/circle2x2.mdl"}, {"Model":"models/hunter/tubes/circle2x2b.mdl"}, {"Model":"models/hunter/tubes/circle2x2c.mdl"}, {"Model":"models/hunter/tubes/circle2x2d.mdl"}, {"Model":"models/hunter/tubes/circle4x4.mdl"}, {"Model":"models/hunter/tubes/tube1x1x1.mdl"}, {"Model":"models/hunter/tubes/tube1x1x1b.mdl"}, {"Model":"models/hunter/tubes/tube1x1x1c.mdl"}, {"Model":"models/hunter/tubes/tube1x1x2.mdl"}, {"Model":"models/hunter/tubes/tube1x1x2b.mdl"}, {"Model":"models/hunter/tubes/tube1x1x2c.mdl"}, {"Model":"models/hunter/tubes/tube1x1x3.mdl"}, {"Model":"models/hunter/tubes/tube1x1x3c.mdl"}, {"Model":"models/hunter/tubes/tube1x1x4.mdl"}, {"Model":"models/hunter/tubes/tube1x1x4c.mdl"}, {"Model":"models/hunter/tubes/tube1x1x4d.mdl"}, {"Model":"models/hunter/tubes/tube1x1x5.mdl"}, {"Model":"models/hunter/tubes/tube1x1x5b.mdl"}, {"Model":"models/hunter/tubes/tube1x1x5c.mdl"}, {"Model":"models/hunter/tubes/tube1x1x5d.mdl"}, {"Model":"models/hunter/tubes/tube1x1x6.mdl"}, {"Model":"models/hunter/tubes/tube1x1x6b.mdl"}, {"Model":"models/hunter/tubes/tube1x1x6c.mdl"}, {"Model":"models/hunter/tubes/tube1x1x6d.mdl"}, {"Model":"models/hunter/tubes/tube1x1x8.mdl"}, {"Model":"models/hunter/tubes/tube1x1x8b.mdl"}, {"Model":"models/hunter/tubes/tube1x1x8c.mdl"}, {"Model":"models/hunter/tubes/tube1x1x8d.mdl"}, {"Model":"models/hunter/tubes/tube2x2x+.mdl"}, {"Model":"models/hunter/tubes/tube2x2x025.mdl"}, {"Model":"models/hunter/tubes/tube2x2x025c.mdl"}, {"Model":"models/hunter/tubes/tube2x2x05.mdl"}, {"Model":"models/hunter/tubes/tube2x2x05b.mdl"}, {"Model":"models/hunter/tubes/tube2x2x05c.mdl"}, {"Model":"models/hunter/tubes/tube2x2x05d.mdl"}, {"Model":"models/hunter/tubes/tube2x2x1.mdl"}, {"Model":"models/hunter/tubes/tube2x2x1b.mdl"}, {"Model":"models/hunter/tubes/tube2x2x1c.mdl"}, {"Model":"models/hunter/tubes/tube2x2x1d.mdl"}, {"Model":"models/hunter/tubes/tube2x2x2.mdl"}, {"Model":"models/hunter/tubes/tube2x2x2b.mdl"}, {"Model":"models/hunter/tubes/tube2x2x2c.mdl"}, {"Model":"models/hunter/tubes/tube2x2x2d.mdl"}, {"Model":"models/hunter/tubes/tube2x2x4.mdl"}, {"Model":"models/hunter/tubes/tube2x2x4b.mdl"}, {"Model":"models/hunter/tubes/tube2x2x4c.mdl"}, {"Model":"models/hunter/tubes/tube2x2x4d.mdl"}, {"Model":"models/hunter/tubes/tube2x2x8.mdl"}, {"Model":"models/hunter/tubes/tube2x2x8b.mdl"}, {"Model":"models/hunter/tubes/tube2x2x8c.mdl"}, {"Model":"models/hunter/tubes/tube2x2x8d.mdl"}, {"Model":"models/hunter/tubes/tube2x2xt.mdl"}, {"Model":"models/hunter/tubes/tube2x2xta.mdl"}, {"Model":"models/hunter/tubes/tube2x2xtb.mdl"}, {"Model":"models/hunter/tubes/tube4x4x05.mdl"}, {"Model":"models/hunter/tubes/tube4x4x05b.mdl"}, {"Model":"models/hunter/tubes/tube4x4x05c.mdl"}, {"Model":"models/hunter/tubes/tube4x4x1.mdl"}, {"Model":"models/hunter/tubes/tube4x4x1b.mdl"}, {"Model":"models/hunter/tubes/tube4x4x1c.mdl"}, {"Model":"models/hunter/tubes/tube4x4x1d.mdl"}, {"Model":"models/hunter/tubes/tube4x4x1to2x2.mdl"}, {"Model":"models/hunter/tubes/tube4x4x2b.mdl"}, {"Model":"models/hunter/tubes/tube4x4x2c.mdl"}, {"Model":"models/hunter/tubes/tube4x4x2d.mdl"}, {"Model":"models/hunter/tubes/tubebend1x1x90.mdl"}, {"Model":"models/hunter/tubes/tubebend1x2x90b.mdl"}, {"Model":"models/hunter/tubes/tubebend2x2x90.mdl"}, {"Model":"models/hunter/tubes/tubebend2x2x90outer.mdl"}, {"Model":"models/hunter/tubes/tubebend2x2x90square.mdl"}, {"Model":"models/hunter/tubes/tubebendinsidesquare2.mdl"}, {"Model":"models/hunter/tubes/tubebendoutsidesquare.mdl"}, {"Model":"models/hunter/tubes/tubebendoutsidesquare2.mdl"}, {"Model":"models/instrument.mdl"}, {"Model":"models/items/ammocrate_grenade.mdl"}, {"Model":"models/items/boxmrounds.mdl"}, {"Model":"models/items/boxsrounds.mdl"}, {"Model":"models/items/car_battery01.mdl"}, {"Model":"models/mechanics/gears2/pinion_20t1.mdl"}, {"Model":"models/mechanics/gears2/pinion_20t2.mdl"}, {"Model":"models/mechanics/gears2/pinion_20t3.mdl"}, {"Model":"models/mechanics/solid_steel/box_beam_4.mdl"}, {"Model":"models/mechanics/solid_steel/i_beam_4.mdl"}, {"Model":"models/phxtended/tri1x1x1solid.mdl"}, {"Model":"models/phxtended/tri2x1x2solid.mdl"}, {"Model":"models/phxtended/tri2x2x2solid.mdl"}, {"Model":"models/props/cs_office/shelves_metal1.mdl"}, {"Model":"models/props/cs_office/shelves_metal2.mdl"}, {"Model":"models/props/cs_office/tv_plasma.mdl"}, {"Model":"models/props/stalker_urfim_building/copyright1.mdl"}, {"Model":"models/props/stalker_urfim_building/decal01.mdl"}, {"Model":"models/props/stalker_urfim_building/decal02.mdl"}, {"Model":"models/props/stalker_urfim_building/decal03.mdl"}, {"Model":"models/props/stalker_urfim_building/decal04.mdl"}, {"Model":"models/props/stalker_urfim_building/decal05.mdl"}, {"Model":"models/props/stalker_urfim_building/decal06.mdl"}, {"Model":"models/props/stalker_urfim_building/decal07.mdl"}, {"Model":"models/props/stalker_urfim_building/map01.mdl"}, {"Model":"models/props/stalker_urfim_building/map02.mdl"}, {"Model":"models/props/stalker_urfim_building/map03.mdl"}, {"Model":"models/props/stalker_urfim_building/map04.mdl"}, {"Model":"models/props/stalker_urfim_building/sign01.mdl"}, {"Model":"models/props/stalker_urfim_building/sign02.mdl"}, {"Model":"models/props/stalker_urfim_building/sign03.mdl"}, {"Model":"models/props/stalker_urfim_building/sign04.mdl"}, {"Model":"models/props/stalker_urfim_building/sign05.mdl"}, {"Model":"models/props/stalker_urfim_building/sign06.mdl"}, {"Model":"models/props/stalker_urfim_building/sign07.mdl"}, {"Model":"models/props/stalker_urfim_building/sign08.mdl"}, {"Model":"models/props/stalker_urfim_building/sign09.mdl"}, {"Model":"models/props/stalker_urfim_building/sign10.mdl"}, {"Model":"models/props/stalker_urfim_building/sign12.mdl"}, {"Model":"models/props/stalker_urfim_building/sign14.mdl"}, {"Model":"models/props/stalker_urfim_building/sign15.mdl"}, {"Model":"models/props/stalker_urfim_building/sign16.mdl"}, {"Model":"models/props/stalker_urfim_building/sign20.mdl"}, {"Model":"models/props_borealis/bluebarrel001.mdl"}, {"Model":"models/props_borealis/borealis_door001a.mdl"}, {"Model":"models/props_borealis/mooring_cleat01.mdl"}, {"Model":"models/props_c17/bench01a.mdl"}, {"Model":"models/props_c17/briefcase001a.mdl"}, {"Model":"models/props_c17/chair02a.mdl"}, {"Model":"models/props_c17/chair_kleiner03a.mdl"}, {"Model":"models/props_c17/computer01_keyboard.mdl"}, {"Model":"models/props_c17/concrete_barrier001a.mdl"}, {"Model":"models/props_c17/display_cooler01a.mdl"}, {"Model":"models/props_c17/door01_left.mdl"}, {"Model":"models/props_c17/door02_double.mdl"}, {"Model":"models/props_c17/fence01a.mdl"}, {"Model":"models/props_c17/fence01b.mdl"}, {"Model":"models/props_c17/fence02a.mdl"}, {"Model":"models/props_c17/fence02b.mdl"}, {"Model":"models/props_c17/fence03a.mdl"}, {"Model":"models/props_c17/furniturechair001a.mdl"}, {"Model":"models/props_c17/furniturecouch001a.mdl"}, {"Model":"models/props_c17/furniturecouch002a.mdl"}, {"Model":"models/props_c17/furniturecupboard001a.mdl"}, {"Model":"models/props_c17/furnituredrawer001a.mdl"}, {"Model":"models/props_c17/furnituredrawer001a_chunk05.mdl"}, {"Model":"models/props_c17/furnituredrawer002a.mdl"}, {"Model":"models/props_c17/furnituredrawer003a.mdl"}, {"Model":"models/props_c17/furnituredresser001a.mdl"}, {"Model":"models/props_c17/furniturefireplace001a.mdl"}, {"Model":"models/props_c17/furniturefridge001a.mdl"}, {"Model":"models/props_c17/furnitureradiator001a.mdl"}, {"Model":"models/props_c17/furnitureshelf001a.mdl"}, {"Model":"models/props_c17/furnitureshelf001b.mdl"}, {"Model":"models/props_c17/furnitureshelf002a.mdl"}, {"Model":"models/props_c17/furnituresink001a.mdl"}, {"Model":"models/props_c17/furniturestove001a.mdl"}, {"Model":"models/props_c17/furnituretable001a.mdl"}, {"Model":"models/props_c17/furnituretable002a.mdl"}, {"Model":"models/props_c17/furnituretable003a.mdl"}, {"Model":"models/props_c17/furnituretoilet001a.mdl"}, {"Model":"models/props_c17/gaspipes006a.mdl"}, {"Model":"models/props_c17/gate_door01a.mdl"}, {"Model":"models/props_c17/gravestone002a.mdl"}, {"Model":"models/props_c17/gravestone003a.mdl"}, {"Model":"models/props_c17/gravestone004a.mdl"}, {"Model":"models/props_c17/gravestone_cross001b.mdl"}, {"Model":"models/props_c17/lockers001a.mdl"}, {"Model":"models/props_c17/metalladder001.mdl"}, {"Model":"models/props_c17/metalpot001a.mdl"}, {"Model":"models/props_c17/metalpot002a.mdl"}, {"Model":"models/props_c17/oildrum001.mdl"}, {"Model":"models/props_c17/playground_teetertoter_seat.mdl"}, {"Model":"models/props_c17/playground_teetertoter_stan.mdl"}, {"Model":"models/props_c17/shelfunit01a.mdl"}, {"Model":"models/props_c17/streetsign001c.mdl"}, {"Model":"models/props_c17/streetsign002b.mdl"}, {"Model":"models/props_c17/streetsign003b.mdl"}, {"Model":"models/props_c17/streetsign004e.mdl"}, {"Model":"models/props_c17/streetsign004f.mdl"}, {"Model":"models/props_c17/streetsign005b.mdl"}, {"Model":"models/props_c17/streetsign005c.mdl"}, {"Model":"models/props_c17/streetsign005d.mdl"}, {"Model":"models/props_c17/suitcase001a.mdl"}, {"Model":"models/props_c17/tools_wrench01a.mdl"}, {"Model":"models/props_c17/tv_monitor01.mdl"}, {"Model":"models/props_debris/metal_panel01a.mdl"}, {"Model":"models/props_debris/metal_panel02a.mdl"}, {"Model":"models/props_debris/wall001a_base.mdl"}, {"Model":"models/props_docks/dock01_pole01a_128.mdl"}, {"Model":"models/props_docks/dock01_pole01a_256.mdl"}, {"Model":"models/props_doors/door03_slotted_left.mdl"}, {"Model":"models/props_interiors/elevatorshaft_door01a.mdl"}, {"Model":"models/props_interiors/furniture_chair01a.mdl"}, {"Model":"models/props_interiors/furniture_chair03a.mdl"}, {"Model":"models/props_interiors/furniture_couch01a.mdl"}, {"Model":"models/props_interiors/furniture_couch02a.mdl"}, {"Model":"models/props_interiors/furniture_desk01a.mdl"}, {"Model":"models/props_interiors/furniture_lamp01a.mdl"}, {"Model":"models/props_interiors/furniture_shelf01a.mdl"}, {"Model":"models/props_interiors/pot01a.mdl"}, {"Model":"models/props_interiors/pot02a.mdl"}, {"Model":"models/props_interiors/radiator01a.mdl"}, {"Model":"models/props_interiors/refrigerator01a.mdl"}, {"Model":"models/props_interiors/refrigeratordoor01a.mdl"}, {"Model":"models/props_interiors/refrigeratordoor02a.mdl"}, {"Model":"models/props_interiors/sinkkitchen01a.mdl"}, {"Model":"models/props_interiors/vendingmachinesoda01a_door.mdl"}, {"Model":"models/props_junk/cardboard_box001a.mdl"}, {"Model":"models/props_junk/cardboard_box001b.mdl"}, {"Model":"models/props_junk/cardboard_box002a.mdl"}, {"Model":"models/props_junk/cardboard_box002b.mdl"}, {"Model":"models/props_junk/cinderblock01a.mdl"}, {"Model":"models/props_junk/garbage128_composite001b.mdl"}, {"Model":"models/props_junk/garbage128_composite001c.mdl"}, {"Model":"models/props_junk/harpoon002a.mdl"}, {"Model":"models/props_junk/metalbucket01a.mdl"}, {"Model":"models/props_junk/metalbucket02a.mdl"}, {"Model":"models/props_junk/metalgascan.mdl"}, {"Model":"models/props_junk/plasticbucket001a.mdl"}, {"Model":"models/props_junk/plasticcrate01a.mdl"}, {"Model":"models/props_junk/pushcart01a.mdl"}, {"Model":"models/props_junk/shovel01a.mdl"}, {"Model":"models/props_junk/trafficcone001a.mdl"}, {"Model":"models/props_junk/trashdumpster01a.mdl"}, {"Model":"models/props_junk/trashdumpster02b.mdl"}, {"Model":"models/props_junk/wheebarrow01a.mdl"}, {"Model":"models/props_junk/wood_crate001a.mdl"}, {"Model":"models/props_junk/wood_crate001a_damaged.mdl"}, {"Model":"models/props_junk/wood_crate002a.mdl"}, {"Model":"models/props_junk/wood_pallet001a.mdl"}, {"Model":"models/props_lab/bewaredog.mdl"}, {"Model":"models/props_lab/bindergreen.mdl"}, {"Model":"models/props_lab/blastdoor001a.mdl"}, {"Model":"models/props_lab/blastdoor001b.mdl"}, {"Model":"models/props_lab/blastdoor001c.mdl"}, {"Model":"models/props_lab/cactus.mdl"}, {"Model":"models/props_lab/desklamp01.mdl"}, {"Model":"models/props_lab/frame002a.mdl"}, {"Model":"models/props_lab/harddrive01.mdl"}, {"Model":"models/props_lab/kennel_physics.mdl"}, {"Model":"models/props_lab/monitor01a.mdl"}, {"Model":"models/props_lab/monitor01b.mdl"}, {"Model":"models/props_lab/monitor02.mdl"}, {"Model":"models/props_lab/partsbin01.mdl"}, {"Model":"models/props_lab/plotter.mdl"}, {"Model":"models/props_lab/reciever01a.mdl"}, {"Model":"models/props_lab/reciever_cart.mdl"}, {"Model":"models/props_lab/securitybank.mdl"}, {"Model":"models/props_lab/servers.mdl"}, {"Model":"models/props_lab/workspace001.mdl"}, {"Model":"models/props_lab/workspace002.mdl"}, {"Model":"models/props_lab/workspace003.mdl"}, {"Model":"models/props_lab/workspace004.mdl"}, {"Model":"models/props_phx/construct/concrete_barrier00.mdl"}, {"Model":"models/props_phx/construct/concrete_barrier01.mdl"}, {"Model":"models/props_phx/construct/glass/glass_angle180.mdl"}, {"Model":"models/props_phx/construct/glass/glass_angle360.mdl"}, {"Model":"models/props_phx/construct/glass/glass_angle90.mdl"}, {"Model":"models/props_phx/construct/glass/glass_curve180x1.mdl"}, {"Model":"models/props_phx/construct/glass/glass_curve180x2.mdl"}, {"Model":"models/props_phx/construct/glass/glass_curve360x1.mdl"}, {"Model":"models/props_phx/construct/glass/glass_curve360x2.mdl"}, {"Model":"models/props_phx/construct/glass/glass_curve90x1.mdl"}, {"Model":"models/props_phx/construct/glass/glass_curve90x2.mdl"}, {"Model":"models/props_phx/construct/glass/glass_dome180.mdl"}, {"Model":"models/props_phx/construct/glass/glass_dome90.mdl"}, {"Model":"models/props_phx/construct/glass/glass_plate1x1.mdl"}, {"Model":"models/props_phx/construct/glass/glass_plate1x2.mdl"}, {"Model":"models/props_phx/construct/glass/glass_plate2x2.mdl"}, {"Model":"models/props_phx/construct/glass/glass_plate2x4.mdl"}, {"Model":"models/props_phx/construct/glass/glass_plate4x4.mdl"}, {"Model":"models/props_phx/construct/metal_angle180.mdl"}, {"Model":"models/props_phx/construct/metal_angle360.mdl"}, {"Model":"models/props_phx/construct/metal_angle90.mdl"}, {"Model":"models/props_phx/construct/metal_dome180.mdl"}, {"Model":"models/props_phx/construct/metal_dome90.mdl"}, {"Model":"models/props_phx/construct/metal_plate1.mdl"}, {"Model":"models/props_phx/construct/metal_plate1x2.mdl"}, {"Model":"models/props_phx/construct/metal_plate1x2_tri.mdl"}, {"Model":"models/props_phx/construct/metal_plate1_tri.mdl"}, {"Model":"models/props_phx/construct/metal_plate2x2.mdl"}, {"Model":"models/props_phx/construct/metal_plate2x2_tri.mdl"}, {"Model":"models/props_phx/construct/metal_plate2x4.mdl"}, {"Model":"models/props_phx/construct/metal_plate2x4_tri.mdl"}, {"Model":"models/props_phx/construct/metal_plate4x4.mdl"}, {"Model":"models/props_phx/construct/metal_plate4x4_tri.mdl"}, {"Model":"models/props_phx/construct/metal_plate_curve.mdl"}, {"Model":"models/props_phx/construct/metal_plate_curve180.mdl"}, {"Model":"models/props_phx/construct/metal_plate_curve180x2.mdl"}, {"Model":"models/props_phx/construct/metal_plate_curve2.mdl"}, {"Model":"models/props_phx/construct/metal_plate_curve2x2.mdl"}, {"Model":"models/props_phx/construct/metal_plate_curve360.mdl"}, {"Model":"models/props_phx/construct/metal_plate_curve360x2.mdl"}, {"Model":"models/props_phx/construct/metal_plate_pipe.mdl"}, {"Model":"models/props_phx/construct/metal_tube.mdl"}, {"Model":"models/props_phx/construct/metal_tubex2.mdl"}, {"Model":"models/props_phx/construct/metal_wire1x1.mdl"}, {"Model":"models/props_phx/construct/metal_wire1x1x1.mdl"}, {"Model":"models/props_phx/construct/metal_wire1x1x2.mdl"}, {"Model":"models/props_phx/construct/metal_wire1x1x2b.mdl"}, {"Model":"models/props_phx/construct/metal_wire1x2.mdl"}, {"Model":"models/props_phx/construct/metal_wire1x2b.mdl"}, {"Model":"models/props_phx/construct/metal_wire1x2x2b.mdl"}, {"Model":"models/props_phx/construct/metal_wire2x2.mdl"}, {"Model":"models/props_phx/construct/metal_wire2x2b.mdl"}, {"Model":"models/props_phx/construct/metal_wire2x2x2b.mdl"}, {"Model":"models/props_phx/construct/metal_wire_angle180x1.mdl"}, {"Model":"models/props_phx/construct/metal_wire_angle180x2.mdl"}, {"Model":"models/props_phx/construct/metal_wire_angle360x1.mdl"}, {"Model":"models/props_phx/construct/metal_wire_angle90x1.mdl"}, {"Model":"models/props_phx/construct/metal_wire_angle90x2.mdl"}, {"Model":"models/props_phx/construct/plastic/plastic_angle_360.mdl"}, {"Model":"models/props_phx/construct/windows/window1x1.mdl"}, {"Model":"models/props_phx/construct/windows/window1x2.mdl"}, {"Model":"models/props_phx/construct/windows/window2x2.mdl"}, {"Model":"models/props_phx/construct/windows/window2x4.mdl"}, {"Model":"models/props_phx/construct/windows/window4x4.mdl"}, {"Model":"models/props_phx/construct/windows/window_angle180.mdl"}, {"Model":"models/props_phx/construct/windows/window_angle360.mdl"}, {"Model":"models/props_phx/construct/windows/window_angle90.mdl"}, {"Model":"models/props_phx/construct/windows/window_curve180x1.mdl"}, {"Model":"models/props_phx/construct/windows/window_curve180x2.mdl"}, {"Model":"models/props_phx/construct/windows/window_curve360x1.mdl"}, {"Model":"models/props_phx/construct/windows/window_curve90x1.mdl"}, {"Model":"models/props_phx/construct/windows/window_curve90x2.mdl"}, {"Model":"models/props_phx/construct/wood/wood_angle180.mdl"}, {"Model":"models/props_phx/construct/wood/wood_angle360.mdl"}, {"Model":"models/props_phx/construct/wood/wood_angle90.mdl"}, {"Model":"models/props_phx/construct/wood/wood_boardx1.mdl"}, {"Model":"models/props_phx/construct/wood/wood_boardx2.mdl"}, {"Model":"models/props_phx/construct/wood/wood_curve180x1.mdl"}, {"Model":"models/props_phx/construct/wood/wood_curve180x2.mdl"}, {"Model":"models/props_phx/construct/wood/wood_curve360x1.mdl"}, {"Model":"models/props_phx/construct/wood/wood_curve360x2.mdl"}, {"Model":"models/props_phx/construct/wood/wood_curve90x1.mdl"}, {"Model":"models/props_phx/construct/wood/wood_curve90x2.mdl"}, {"Model":"models/props_phx/construct/wood/wood_dome180.mdl"}, {"Model":"models/props_phx/construct/wood/wood_dome90.mdl"}, {"Model":"models/props_phx/construct/wood/wood_panel1x1.mdl"}, {"Model":"models/props_phx/construct/wood/wood_panel1x2.mdl"}, {"Model":"models/props_phx/construct/wood/wood_panel2x2.mdl"}, {"Model":"models/props_phx/construct/wood/wood_panel2x4.mdl"}, {"Model":"models/props_phx/construct/wood/wood_panel4x4.mdl"}, {"Model":"models/props_phx/construct/wood/wood_wire1x1.mdl"}, {"Model":"models/props_phx/construct/wood/wood_wire1x1x1.mdl"}, {"Model":"models/props_phx/construct/wood/wood_wire1x1x2.mdl"}, {"Model":"models/props_phx/construct/wood/wood_wire1x1x2b.mdl"}, {"Model":"models/props_phx/construct/wood/wood_wire1x2.mdl"}, {"Model":"models/props_phx/construct/wood/wood_wire1x2b.mdl"}, {"Model":"models/props_phx/construct/wood/wood_wire1x2x2b.mdl"}, {"Model":"models/props_phx/construct/wood/wood_wire2x2.mdl"}, {"Model":"models/props_phx/construct/wood/wood_wire2x2b.mdl"}, {"Model":"models/props_phx/construct/wood/wood_wire2x2x2b.mdl"}, {"Model":"models/props_phx/rt_screen.mdl"}, {"Model":"models/props_rooftop/satellitedish02.mdl"}, {"Model":"models/props_trainstation/benchoutdoor01a.mdl"}, {"Model":"models/props_trainstation/bench_indoor001a.mdl"}, {"Model":"models/props_trainstation/payphone001a.mdl"}, {"Model":"models/props_trainstation/tracksign02.mdl"}, {"Model":"models/props_trainstation/tracksign07.mdl"}, {"Model":"models/props_trainstation/tracksign10.mdl"}, {"Model":"models/props_trainstation/traincar_seats001.mdl"}, {"Model":"models/props_trainstation/trashcan_indoor001b.mdl"}, {"Model":"models/props_vehicles/apc001.mdl"}, {"Model":"models/props_vehicles/carparts_tire01a.mdl"}, {"Model":"models/props_vehicles/carparts_wheel01a.mdl"}, {"Model":"models/props_wasteland/barricade001a.mdl"}, {"Model":"models/props_wasteland/barricade002a.mdl"}, {"Model":"models/props_wasteland/cafeteria_table001a.mdl"}, {"Model":"models/props_wasteland/cargo_container01b.mdl"}, {"Model":"models/props_wasteland/controlroom_chair001a.mdl"}, {"Model":"models/props_wasteland/controlroom_desk001a.mdl"}, {"Model":"models/props_wasteland/controlroom_desk001b.mdl"}, {"Model":"models/props_wasteland/controlroom_filecabinet001a.mdl"}, {"Model":"models/props_wasteland/controlroom_filecabinet002a.mdl"}, {"Model":"models/props_wasteland/controlroom_storagecloset001a.mdl"}, {"Model":"models/props_wasteland/exterior_fence001a.mdl"}, {"Model":"models/props_wasteland/exterior_fence001b.mdl"}, {"Model":"models/props_wasteland/exterior_fence002a.mdl"}, {"Model":"models/props_wasteland/exterior_fence002b.mdl"}, {"Model":"models/props_wasteland/exterior_fence002c.mdl"}, {"Model":"models/props_wasteland/exterior_fence002d.mdl"}, {"Model":"models/props_wasteland/exterior_fence003a.mdl"}, {"Model":"models/props_wasteland/exterior_fence003b.mdl"}, {"Model":"models/props_wasteland/interior_fence001a.mdl"}, {"Model":"models/props_wasteland/interior_fence001b.mdl"}, {"Model":"models/props_wasteland/interior_fence001c.mdl"}, {"Model":"models/props_wasteland/interior_fence001d.mdl"}, {"Model":"models/props_wasteland/interior_fence001e.mdl"}, {"Model":"models/props_wasteland/interior_fence001g.mdl"}, {"Model":"models/props_wasteland/interior_fence002a.mdl"}, {"Model":"models/props_wasteland/interior_fence002b.mdl"}, {"Model":"models/props_wasteland/interior_fence002d.mdl"}, {"Model":"models/props_wasteland/interior_fence002e.mdl"}, {"Model":"models/props_wasteland/interior_fence002f.mdl"}, {"Model":"models/props_wasteland/interior_fence003a.mdl"}, {"Model":"models/props_wasteland/interior_fence003b.mdl"}, {"Model":"models/props_wasteland/interior_fence003d.mdl"}, {"Model":"models/props_wasteland/interior_fence003e.mdl"}, {"Model":"models/props_wasteland/kitchen_counter001a.mdl"}, {"Model":"models/props_wasteland/kitchen_counter001b.mdl"}, {"Model":"models/props_wasteland/kitchen_counter001c.mdl"}, {"Model":"models/props_wasteland/kitchen_shelf001a.mdl"}, {"Model":"models/props_wasteland/kitchen_shelf002a.mdl"}, {"Model":"models/props_wasteland/kitchen_stove001a.mdl"}, {"Model":"models/props_wasteland/kitchen_stove002a.mdl"}, {"Model":"models/props_wasteland/laundry_cart001.mdl"}, {"Model":"models/props_wasteland/laundry_cart002.mdl"}, {"Model":"models/props_wasteland/light_spotlight01_lamp.mdl"}, {"Model":"models/props_wasteland/prison_bedframe001b.mdl"}, {"Model":"models/props_wasteland/prison_celldoor001b.mdl"}, {"Model":"models/props_wasteland/prison_cellwindow002a.mdl"}, {"Model":"models/props_wasteland/prison_heater001a.mdl"}, {"Model":"models/props_wasteland/prison_shelf002a.mdl"}, {"Model":"models/props_wasteland/wood_fence02a.mdl"}, {"Model":"models/psihelem.mdl"}, {"Model":"models/raviool/flashlight.mdl"}, {"Model":"models/sadtrixie/2103.mdl"}, {"Model":"models/stalker/ammo/12x70.mdl"}, {"Model":"models/stalker/ammo/545x39.mdl"}, {"Model":"models/stalker/ammo/556x45.mdl"}, {"Model":"models/stalker/ammo/762x39.mdl"}, {"Model":"models/stalker/ammo/762x54.mdl"}, {"Model":"models/stalker/ammo/9x18.mdl"}, {"Model":"models/stalker/item/food/bread.mdl"}, {"Model":"models/stalker/item/food/drink.mdl"}, {"Model":"models/stalker/item/food/sausage.mdl"}, {"Model":"models/stalker/item/food/tuna.mdl"}, {"Model":"models/stalker/item/food/vokda.mdl"}, {"Model":"models/stalker/item/handhelds/datachik1.mdl"}, {"Model":"models/stalker/item/handhelds/datachik2.mdl"}, {"Model":"models/stalker/item/handhelds/datachik3.mdl"}, {"Model":"models/stalker/item/handhelds/decoder.mdl"}, {"Model":"models/stalker/item/handhelds/files1.mdl"}, {"Model":"models/stalker/item/handhelds/pda.mdl"}, {"Model":"models/stalker/item/handhelds/radio.mdl"}, {"Model":"models/stalker/item/medical/antirad.mdl"}, {"Model":"models/stalker/item/medical/medkit1.mdl"}, {"Model":"models/stalker/item/medical/medkit2.mdl"}, {"Model":"models/stalker/item/medical/medkit3.mdl"}, {"Model":"models/stalkertnb/outfits/bandit2.mdl"}, {"Model":"models/stalkertnb/outfits/bandit3.mdl"}, {"Model":"models/unconid/xmas/snowman_u.mdl"}, {"Model":"models/unconid/xmas/snowman_u_big.mdl"}, {"Model":"models/unconid/xmas/xmas_tree.mdl"}, {"Model":"models/vertel_boar.mdl"}, {"Model":"models/weapons/custom/w_rad15.mdl"}, {"Model":"models/weapons/hl2meleepack/w_pickaxe.mdl"}, {"Model":"models/weapons/w_sr3m.mdl"}, {"Model":"models/z-o-m-b-i-e/st/army_base/st_army_base_01_1.mdl"}, {"Model":"models/z-o-m-b-i-e/st/army_base/st_army_base_07.mdl"}, {"Model":"models/z-o-m-b-i-e/st/barikada/st_blockpost_01.mdl"}, {"Model":"models/z-o-m-b-i-e/st/barikada/st_blockpost_02.mdl"}, {"Model":"models/z-o-m-b-i-e/st/barikada/st_blockpost_03.mdl"}, {"Model":"models/z-o-m-b-i-e/st/barikada/st_blockpost_04.mdl"}, {"Model":"models/z-o-m-b-i-e/st/bed/st_matras_01.mdl"}, {"Model":"models/z-o-m-b-i-e/st/cover/st_cover_metal_shield_05.mdl"}, {"Model":"models/z-o-m-b-i-e/st/cover/st_cover_metal_shield_07.mdl"}, {"Model":"models/z-o-m-b-i-e/st/ograda/st_ston_zabor_01_1.mdl"}, {"Model":"models/z-o-m-b-i-e/st/ograda/st_ston_zabor_02.mdl"}, {"Model":"models/z-o-m-b-i-e/st/shelf/st_shelf_village_01.mdl"}, {"Model":"models/z-o-m-b-i-e/st/shelf/st_shelf_village_02.mdl"}, {"Model":"models/z-o-m-b-i-e/st/stol/st_stol_02.mdl"}, {"Model":"models/z-o-m-b-i-e/st/stol/st_stol_obedenniy_02.mdl"}, {"Model":"models/z-o-m-b-i-e/st/vagon/st_vagon_04.mdl"}, {"Model":"models/z-o-m-b-i-e/wood_fence_03.mdl"}, {"Model":"models/z-o-m-b-i-e/wood_fence_04.mdl"}, {"Model":"models/zavod_yantar/zabor_kirpich.mdl"}, {"Model":"models/zavod_yantar/zabor_metal.mdl"}] ]]

rp.cfg.MaxRenderDistance = 3000;

rp.cfg.HoursDbServerName = 'Stalker RP'

		rp.cfg.DeathSound = {
			Sound("Death_Stalker/death1.wav"),
			Sound("Death_Stalker/death2.wav"),
			Sound("Death_Stalker/death3.wav"),
			Sound("Death_Stalker/death4.wav"),
			Sound("Death_Stalker/death5.wav"),
			Sound("Death_Stalker/death6.wav"),
			Sound("Death_Stalker/death7.wav"),
			Sound("Death_Stalker/death8.wav"),
			Sound("Death_Stalker/death9.wav"),
			Sound("Death_Stalker/death10.wav"),
			Sound("Death_Stalker/death11.wav"),
			Sound("Death_Stalker/death12.wav"),
			Sound("Death_Stalker/death13.wav"),
			Sound("Death_Stalker/death14.wav")
		}

		rp.cfg.DisableModules = {
			daynight 		= true,
			quest 			= true
		}

		rp.cfg.ScoreboardName = 'Stalker RP'

		rp.cfg.VolumeSettingName = 'Громкость громкоговорителя'

		rp.cfg.MaxArmor 	= 600
		rp.cfg.MaxHealth 	= 250

		rp.cfg.ServerMapId = game.GetMap() .. string.Right(game.GetIPAddress(), 5)

		rp.cfg.DisableCores = {
			--attributes 		= true,
			--inventory 		= true
		}

		rp.cfg.AllCanUseHire = true

		rp.cfg.GroupChatPrefix = '[Групповой PDA]' -- Remove to make it `[Group]`

		rp.cfg.ShowWarWallhack = false

		rp.AtmosphericSounds = {}

		rp.cfg.HudHitsOffset = 265
		rp.cfg.HudShowLaws = false
		rp.cfg.HudShowAgenda = false
		rp.cfg.HudShowLockdown = false

		rp.cfg.NPCs = {}

		rp.cfg.DoorsSignaling = {}


		rp.cfg.MoTD = {
			{"Правила", "https://docs.google.com/document/d/1tkhX6PYMQ1Mwm835RvveEqljdxiXfoZneEfLFFUj8ig"},
			{"Группа ВК", "https://vk.com/stalkerrp"},
			{"Группа Steam", "http://steamcommunity.com/groups/urfimofficial"},
			{"Контент", "https://steamcommunity.com/sharedfiles/filedetails/?id=1569141045"},
		}

		rp.cfg.Scenes = {}

		rp.cfg.AppearanceScaleMin = 0.9
		rp.cfg.AppearanceScaleMax = 1.1

		rp.cfg.DoorColorWhite 	= Color(255, 248, 63)
		rp.cfg.DoorColorBlack 	= Color(0, 0, 0)
		rp.cfg.DoorColorGreen 	= Color(255, 255, 245)

		rp.cfg.NewWanted = true




--isNoDonate = string.Right(game.GetIPAddress(), 5) == "27017"
isNoDonate = false
hook.Run('ServerIdPersistsLoaded')

rp.cfg.MinimapSettings = {
	rp_stalker_urfim_v3 = {
		power = 29.5, -- From map image: (gmod units) / (image pixels)
		off_x = 0,    -- (real map center on image X) - (map image center X)    (pixels)
		off_y = 0,      -- (real map center on image Y) - (map image center Y)   (pixels)
		map = "rp_stalker_urfim_v3_new.png"
	},

	rp_pripyat_urfim = {
		power = 29.5,
		off_x = -23,
		off_y = -34,
		map = "stalker/maps/rp_pripyatmap_urfim.png"
	},

	rp_stalker_urfim = {
		power = 35.662,
		off_x = 2,
		off_y = 0,
		map = "stalker/maps/rp_stalker_urfim.png"
	},
	rp_st_pripyat_urfim = {
		power = 26,
		off_x = 0,
		off_y = 0,
		map = "pripyat_old.png"
	},
}

rp.cfg.MinimapIcons = {
	microwave = {
		icon = "stalker/icons/microwave_logo.png",
	},

	cw_vendingmachine = {
		icon = "stalker/icons/microwave_logo.png",
	},

	armor_lab = {
		icon = "stalker/icons/armor_logo.png",
		distance = 5000
	},

	med_lab = {
		icon = "stalker/icons/med_logo.png",
		distance = 5000
	}
}

rp.cfg.PremiumConfig = {
	{
		job = function() return TEAM_HITMANM end,
		sequence = 'd1_t01_breakroom_watchbreen',
	},
	{
		job = function() return TEAM_EPU end,
		sequence = 'pose_standing_02',
	},
	{
		job = function() return TEAM_SHUSTRIY end,
		sequence = 'idle_all_01',
	},
	{
		job = function() return TEAM_INKV end,
		sequence = 'pose_standing_01',
	},
	}

rp.cfg.BodyLooting = {
    Cooldown = 60, -- КД Облутывания (сек)

    Items = {
        [25] = { "rpitem_metal", "rpitem_steel","rpitem_battery"},
        [25] = { "rpitem_comb_list"},
        [4] = { "simpleprint2"},
        [1] = { "simpleprint4"},
        [5] = {"health_kit_normal","health_kit_best","health_kit_bad","armor_kit"},
        [10] = {"pass_vsu","pass_vsu_fake","rpitem_dockx18","rpitem_dockx8","rpitem_dockx16","rpitem_dockpripat","rpitem_dockgaus","rpitem_secret_book"},
        [10] = {"psi_field","control","dummy_battery","ballon","compass","crystal","eye","fireball","glass","fire","electra_flash","goldfish","gravi","medusa","fuzz kolobok","dummy_glassbeads","mincer_meat","electra_moonlight","nightstar","dummy_dummy","ice","soul","electra_sparkler","blood","crystal_flower","crystal_plant","vyvert"},
        [10] = {"tfa_anomaly_groza_nimble","tfa_anomaly_val","tfa_anomaly_aks","tfa_anomaly_ak74","tfa_anomaly_ak101","tfa_anomaly_aug_a1","tfa_anomaly_lr300","tfa_anomaly_l85","tfa_anomaly_hk416","tfa_anomaly_galil","tfa_anomaly_g36","tfa_anomaly_scar","tfa_anomaly_famas","tfa_anomaly_fn2000","tfa_anomaly_fal","tfa_anomaly_rpd","tfa_anomaly_rpk","tfa_anomaly_pkm","tfa_anomaly_sig550_sniper","tfa_anomaly_svu","tfa_anomaly_mosin","tfa_anomaly_svt","tfa_anomaly_svd","tfa_anomaly_protecta","tfa_anomaly_mp133","tfa_anomaly_spas12","tfa_anomaly_bm16","tfa_anomaly_saiga","tfa_anomaly_toz34_sawedoff","tfa_anomaly_toz34","tfa_anomaly_bm16_full","tfa_anomaly_fort500","tfa_anomaly_p90","tfa_anomaly_bizon","tfa_anomaly_pp2000","tfa_anomaly_ump45","tfa_anomaly_vz61","tfa_anomaly_mp5sd","tfa_anomaly_mp5","tfa_anomaly_mp7","tfa_anomaly_9a91","tfa_anomaly_pm","tfa_anomaly_tt33","tfa_anomaly_glock","tfa_anomaly_fnx45","tfa_anomaly_fn57","tfa_anomaly_cz75_auto","tfa_anomaly_desert_eagle","tfa_anomaly_beretta","tfa_anomaly_colt1911","tfa_anomaly_hpsa"},
        [10] = {"Одежда 1","Одежда 2","Одежда 4","Одежда 5","Одежда 6","Одежда 7","Уплотненный Экзоскелет","Камуфляжная Заря"};
	},

    CustomRender = {
		["rpitem_metal"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/fallout/components/glass.mdl", -- Модель предмета
				origin = Vector(2, 0, -1), -- Настройка позиции модели в руке
				angles = Angle(45, 45, -90), -- Настройка угла модели в руке
				scale = scale * 2, -- Общее увеличение размера предмета в руке;
			};
		end,
		["rpitem_steel"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/fallout/components/ingot.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["rpitem_battery"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/fallout/components/jar.mdl",
				origin = Vector(-1.5, 1, -4),
				angles = Angle(45, 45, -10),
				scale = scale * 2,
			};
		end,
		["rpitem_comb_list"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/props_lab/clipboard.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(90, 90, 245),
				scale = scale * 2,
			};
		end,
		["simpleprint2"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/urf/bitminer_3.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["simpleprint4"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/urf/bitminer_3.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["pass_vsu"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/kerry/dea_pass.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["pass_vsu_fake"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/kerry/dea_pass.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["Одежда 6"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalkertnb2/outfits/seva_freedom.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["Одежда 5"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalkertnb/outfits/seva_merc.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["Одежда 4"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalkertnb/outfits/io7a_merc4.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["Одежда 3"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalkertnb2/outfits/sunrise_loner.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["Одежда 2"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalkertnb2/outfits/sunrise_bandit1.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["Уплотненный Экзоскелет"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalkertnb/outfits/exo_dave.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["Камуфляжная Заря"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalkertnb/outfits/psz9d_free.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["Одежда 7"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalkertnb/outfits/exo_dave.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["Одежда 1"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalkertnb2/outfits/io7a_merc3.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["rpitem_dockx18"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalker/item/handhelds/files4.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["rpitem_dockx8"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalker/item/handhelds/files4.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["rpitem_dockpripat"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalker/item/handhelds/files4.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["rpitem_dockx16"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalker/item/handhelds/files4.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["rpitem_dockgaus"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalker/item/handhelds/files4.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["rpitem_secret_book"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalker/item/handhelds/files4.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["health_kit_normal"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalker/item/medical/medkit2.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["health_kit_best"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalker/item/medical/medkit3.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["health_kit_bad"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/stalker/item/medical/medkit1.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["armor_kit"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/items/tfa/boxar2grenades.mdl",
				origin = Vector(-1, 1, -3),
				angles = Angle(210, 25, 0),
				scale = scale * 2,
			};
		end,
		["psi_field"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["dummy_battery"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["ballon"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["compass"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["crystal"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["eye"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["fireball"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["glass"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["fire"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["electra_flash"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["goldfish"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["gravi"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["medusa"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["fuzzkolobok"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["dummy_battery"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["dummy_dummy"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["dummy_glassbeads"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["mincer_meat"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["electra_moonlight"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["nightstar "] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["ice"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["soul"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["electra_sparkler"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["blood"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["crystal_flower"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["crystal_plant"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["vyvert"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/sal/fallout4/toolbox.mdl",
				origin = Vector(2, 0, -1),
				angles = Angle(45, 45, -90),
				scale = scale * 2,
			};
		end,
		["swb_aa_12_test"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
				["swb_abaton"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_awm"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_ak103"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_ak107"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_ak47_mod"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_ak54"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_ak74"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_ak74su"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_aksilens"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_ak74_u"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_aug_kekler"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_beretta_kekler"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_bizonsilens"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_deagle"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_winchester"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_eliminator"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_fnfal"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_fort_12"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_f2000"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_g3_mod"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_g36c"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_g36k"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_gauss2"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_gauss"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_g36"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_mp5"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_browning"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_enfield"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_colt1911"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_colt"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_ksvk"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_l85"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_lr300"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_lr300_mod"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_m14"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_m16"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_m21emr"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_m249"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_m240"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_m4_kekler"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_m4mod_kekler"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_m4desert"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_m82"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_baretta_single"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_masada"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_mt9"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_groza"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_p90_kekler"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_pb"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_pkm"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_pkp"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_makarov"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_pp2000"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_ppsh41"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_psg1"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_rp74"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_abaton"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_rpd"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_sayga_kekler"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_asvalscoped"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_mosinsniper"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_scorpion"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_sg552"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_sg550"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_sig552_mod"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_p220"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_abaton"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_spas14"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_sten_kekler"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_sv10"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_svd"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_svdk"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_dragunov"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_svu"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_svumk2"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_tar_kekler"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_taurus"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_ots"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_uzi"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_vepr"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_vss_kekler"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_p99"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_val_shturm"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["swb_double_long_shotgun"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/hgn/srp/items/backpack-1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["stalker_grenade_f1"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/weapons/w_stalker_grenade_f_1.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["stalker_grenade_gd"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/weapons/w_stalker_grenade_gd.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["stalker_grenade_rgd"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/weapons/w_stalker_grenade_rgd.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end,
		["weapon_c4"] = function( mdl, origin, angles, scale )
			return {
				mdl = "models/weapons/w_sb_planted.mdl",
				origin = Vector(2, 0, -3),
				angles = Angle(45, 45, -90),
				scale = scale * 1.5,
			};
		end
	}
};

rp.cfg.MaxPrinters = 3

rp.cfg.ConsultUrl = 'https://vk.com/consultantstalker'

rp.cfg.ZombieReward = 45

rp.cfg.RewardCooldown = 2 * 60
rp.cfg.DemoteCooldown = 3 * 60

rp.cfg.MaxPrinters = 3


rp.cfg.MayorKillReward = 600
rp.cfg.MayorDelay = 300

rp.cfg.VendingPopcanPrice = 30

rp.cfg.StartMoney 		= 1000
rp.cfg.StartKarma		= 50

rp.cfg.OrgCost 			= 5000

rp.cfg.HungerRate 		= 1200

rp.cfg.DoorCostMin		= 10
rp.cfg.DoorCostMax 		= 50
rp.cfg.PropertyTax		= 10

rp.cfg.PropLimit 		= 30

rp.cfg.RagdollDelete	= 60

-- Speed
rp.cfg.WalkSpeed 		= 180
rp.cfg.RunSpeed 		= 260

-- Printers
rp.cfg.PrintDelay 		= 60
rp.cfg.PrintAmount = 250
rp.cfg.InkCost 			= 10

-- Hits
rp.cfg.HitExpire		= 600
rp.cfg.HitCoolDown 		= 150
rp.cfg.HitMinCost 		= 350
rp.cfg.HitMaxCost 		= 10000

-- Afk
rp.cfg.AfkDemote 		= (60 * 30) * 1
rp.cfg.AfkPropRemove 	= (60 * 60) * 1
rp.cfg.AfkDoorSell 		= (60 * 30) * 1
rp.cfg.AfkKick			= (60 * 90) * 1

-- Stamina
rp.cfg.MaxStamina = 30
rp.cfg.StaminaRestoreTime = 20

-- Lotto
rp.cfg.MinLotto 		= 100
rp.cfg.MaxLotto 		= 5000

rp.cfg.PsiEmittion = {
	Damage = 40,
	Delay  = 60 * 60 * 1.5,
	Length = 60 + 45,
	Phrases = {
        OnStart = {
            {"Отец Диодор", "Начинается Пси-Шторм, все скорее ищите укрытие, если не хотите стать безмозглым зомби!"}
        },

        OnEnd = {
            {"Отец Диодор", "Пси-Шторм закончился, надеюсь никто не пострадал?"}
        }
	},
	Filter = function( ply )
		local f = ply:GetFaction();
		local t = ply:Team();
		return (f ~= FACTION_MONOLITH) and (f ~= FACTION_ZOMBIE) and (f ~= FACTION_ZOMBIE1) and (f ~= FACTION_MUTANTS) and (t ~= TEAM_LAZSCOR) and (t ~= TEAM_DOG) and (t ~= TEAM_STRELOK) and (t ~= TEAM_SKAR)
	end
};

rp.cfg.AdminBase = {
 ['rp_stalker_urfim_v3'] = Vector(-1426, 64, -1280),
 ['rp_pripyat_urfim'] = Vector(9684, 472, 4821),
 ['rp_stalker_urfim'] = Vector(9487, -3, 11264),
 ['rp_st_pripyat_urfim'] = Vector(-2948, -11542, 3648),
}

rp.cfg.Backweapons = {
    WeaponTag = {
        ['swb'] = true,
        ['srp'] = true,
        ['m9k'] = true,
        ['stalker'] = true,
    },
    MaxHolsted = 3,
    MaxDraw = 3,
	IsStalker = true,
}

rp.cfg.Methlab = {
	NeededMethylamin = 2,
	NeededAluminium = 3,
	MethylaminCookingTime = 100,

	TrayCountTilEmpty = 5,
	TrayFillTime = 10,

	FreezeTime = 70,
}

-- back weapons
rp.cfg.RT_WeaponPos = {
	['stalker_winchester'] = {
		AxScale = Angle(0, 90, -8),
		TfScale = Vector(5, -5, 0)
	},
	['stalker_dragunov'] = {
		AxScale = Angle(0, -90, -8),
		TfScale = Vector(10, 6, 0)
	},
	['stalker_ots'] = {
		TfScale = Vector(5, -13, 1)
	},
	['srp_chaser13'] = {
		AxScale = Angle(0, 90, -8),
		TfScale = Vector(5, -5, 0)
	},
	['srp_g36c'] = {
		AxScale = Angle(0, 90, -8)
	},
	['srp_l85'] = {
		TfScale = Vector(5, 10, 0)
	},
	['srp_lr300'] = {
		TfScale = Vector(5, 5, 1)
	},
	['srp_m249'] = {
		TfScale = Vector(5, 3, 1)
	},
	['srp_groza'] = {
		TfScale = Vector(5, -5, 1)
	},
	['srp_svd'] = {
		AxScale = Angle(0, -90, -8),
		TfScale = Vector(10, 6, 0)
	},
	['srp_uzi'] = {
		TfScale = Vector(5, -6, 1)
	},
	['swb_aksilens'] = {
		TfScale = Vector(5, 5, 1)
	},
	['swb_winchester'] = {
		AxScale = Angle(0, 90, -8),
		TfScale = Vector(5, -5, 0)
	},
	['swb_f2000'] = {
		TfScale = Vector(5, -4, 1)
	},
	['swb_g36c'] = {
		AxScale = Angle(0, 90, -8),
		TfScale = Vector(5, -5, 1)
	},
	['swb_mp5'] = {
		TfScale = Vector(5, 4, 1)
	},
	['swb_l85'] = {
		TfScale = Vector(5, 10, 0)
	},
	['swb_lr300'] = {
		TfScale = Vector(5, 5, 1)
	},
	['swb_m4mod_kekler'] = {
		TfScale = Vector(5, 5, 1)
	},
	['swb_m82'] = {
		TfScale = Vector(8, 0, 1)
	},
	['swb_p90_kekler'] = {
		TfScale = Vector(5, 12, 1)
	},
	['swb_pp2000'] = {
		TfScale = Vector(5, -4, 1)
	},
	['swb_svd'] = {
		AxScale = Angle(0, -90, -8),
		TfScale = Vector(10, 6, 0)
	},
	['swb_dragunov'] = {
		AxScale = Angle(0, -90, -8),
		TfScale = Vector(10, 6, 0)
	},
	['swb_tar_kekler'] = {
		AxScale = Angle(0, -90, -8),
		TfScale = Vector(-10, 6, 0)
	},
	['swb_ots'] = {
		TfScale = Vector(5, -13, 1)
	},
	['swb_svdk'] = {
		AxScale = Angle(0, -90, -8),
		TfScale = Vector(10, 6, 0)
	},
    ['swb_ks23m'] = {
		AxScale = Angle(0, -90, 0),
		TfScale = Vector(10, 4, 10)
	},
	['swb_serp'] = {
		AxScale = Angle(0, -90, -8),
		TfScale = Vector(10, 6, 0)
	},
}

rp.cfg.RT_WeaponBlacklist = {
	['stalker_baretta_dual'] = true,
	['stalker_grenade_f1'] = true,
	['stalker_grenade_gd'] = true,
	['stalker_knife'] = true,
	['stalker_grenade_rgd'] = true,
	['stalker_fort_12'] = true,
	['stalker_colt'] = true,
	['stalker_browning'] = true,
	['stalker_baretta_single'] = true,
	['stalker_pb'] = true,
	['stalker_makarov'] = true,
	['stalker_p220'] = true,
	['stalker_usp'] = true,
	['stalker_p99'] = true,
	['srp_fort12'] = true,
	['srp_colt1911'] = true,
	['srp_pb'] = true,
	['srp_fort12'] = true,
	['srp_colt1911'] = true,
	['srp_pb'] = true,
	['srp_makarov'] = true,
	['srp_taurus'] = true,
}

rp.cfg.CampNPCBounty = 100
rp.cfg.CampNPCRespawnTime = 300

rp.cfg.StartReward = {}
rp.cfg.StartReward.Weapon = {"tfa_anomaly_beretta","tfa_anomaly_fn2000"}
rp.cfg.StartReward.Money = 1000
rp.cfg.StartReward.PlayTime = 5 * 3600
rp.cfg.StartReward.Armor = 100


-- Nigh time
rp.cfg.StartNightTimeMultiplier	= 23
rp.cfg.EndNightTimeMultiplier	= 9
rp.cfg.NightTimeMultiplier 		= 1 -- 100%
/*
rp.cfg.NPCs = {
	rp_pripyat_fixed = {
--		{npcs = "npc_mutant_pseudogiant", pos = Vector(4174, 3623, -384), respawnTime = rp.cfg.CampNPCRespawnTime * 2, bounty = rp.cfg.CampNPCBounty * 20}, --ГИГАНТ
--		{npcs = "npc_mutant_pseudogiant", pos = Vector(13725, -13741, -6), respawnTime = rp.cfg.CampNPCRespawnTime * 2, bounty = rp.cfg.CampNPCBounty * 20}, --ГИГАНТ
		--
		{npcs = "npc_wick_mutant_bloodsucker_young", pos = Vector(-14115, -717, -64), respawnTime = rp.cfg.CampNPCRespawnTime, bounty = rp.cfg.CampNPCBounty * 8}, --кровосос
		{npcs = "npc_wick_mutant_bloodsucker_young", pos = Vector(-11415, -1138, -76), respawnTime = rp.cfg.CampNPCRespawnTime, bounty = rp.cfg.CampNPCBounty * 8}, --кровосос
		{npcs = "npc_wick_mutant_bloodsucker_young", pos = Vector(-9578, -370, -75), respawnTime = rp.cfg.CampNPCRespawnTime, bounty = rp.cfg.CampNPCBounty * 8}, --кровосос
		{npcs = "npc_wick_mutant_bloodsucker_young", pos = Vector(-9314, 5088, -69), respawnTime = rp.cfg.CampNPCRespawnTime, bounty = rp.cfg.CampNPCBounty * 8}, --кровосос
		{npcs = "npc_wick_mutant_bloodsucker_young", pos = Vector(-13437, 4948, -86), respawnTime = rp.cfg.CampNPCRespawnTime, bounty = rp.cfg.CampNPCBounty * 8}, --кровосос
		--
		{npcs = "npc_wick_mutant_dog", pos = Vector(1095, 3483, -41), respawnTime = rp.cfg.CampNPCRespawnTime, bounty = rp.cfg.CampNPCBounty * 5}, --всевдопес
		{npcs = "npc_wick_mutant_dog", pos = Vector(813, 3762, -45), respawnTime = rp.cfg.CampNPCRespawnTime, bounty = rp.cfg.CampNPCBounty * 5}, --пес
		{npcs = "npc_wick_mutant_dog", pos = Vector(735, 3166, -32), respawnTime = rp.cfg.CampNPCRespawnTime, bounty = rp.cfg.CampNPCBounty * 5}, --пес
		--
		{npcs = "npc_wick_mutant_zombiecit_fast", pos = Vector(74, -3409, 0), respawnTime = rp.cfg.CampNPCRespawnTime, bounty = rp.cfg.CampNPCBounty * 3}, --кровосос
		{npcs = "npc_wick_mutant_zombiecit_fast", pos = Vector(-5414, -9248, 1), respawnTime = rp.cfg.CampNPCRespawnTime, bounty = rp.cfg.CampNPCBounty * 3}, --кровосос
		{npcs = "npc_wick_mutant_zombiecit_fast", pos = Vector(3191, -446, -11), respawnTime = rp.cfg.CampNPCRespawnTime, bounty = rp.cfg.CampNPCBounty * 3}, --кровосос
		{npcs = "npc_wick_mutant_zombiecit_fast", pos = Vector(2327, -9815, -8), respawnTime = rp.cfg.CampNPCRespawnTime, bounty = rp.cfg.CampNPCBounty * 3}, --кровосос
		{npcs = "npc_wick_mutant_zombiecit_fast", pos = Vector(-4354, -4522, 2), respawnTime = rp.cfg.CampNPCRespawnTime, bounty = rp.cfg.CampNPCBounty * 3}, --кровосос
		--
		{npcs = "npc_wick_mutant_snork", pos = Vector(9229, -325, -48), respawnTime = rp.cfg.CampNPCRespawnTime * 2, bounty = rp.cfg.CampNPCBounty * 5}, --сноук
		{npcs = "npc_wick_mutant_snork", pos = Vector(8963, -3115, 0), respawnTime = rp.cfg.CampNPCRespawnTime * 2, bounty = rp.cfg.CampNPCBounty * 5}, --сноук
 }
}
*/

/*
rp.cfg.DialogueNPCs = {
    rp_pripyat_urfim = {
         {Vector(7289.301270, -3120.356445, 8), Angle(0.000, -90, 0.000), "infobarmen", icon = "stalker/icons/info_logo.png", iconDistance = 5000},
         {Vector(4710, -6870, 31), Angle(0, 90, 0), "vsy", icon = "stalker/icons/army_logo.png", iconDistance = 5000},
         {Vector(5214, -6530, 178), Angle(0, -180, 0), "vs"},
         {Vector(-2110.632324, -12540, 32), Angle(0, 0, 0), "bandit", icon = "stalker/icons/bandit_logo.png", iconDistance = 5000},
         {Vector(11564, 7640, -124), Angle(0, 180, 0), "altclearsky", icon = "stalker/icons/clearsky_logo.png", iconDistance = 5000},
         {Vector(-4192, -9630, 0), Angle(0, 0, 0), "nig", icon = "stalker/icons/scientis_logo.png", iconDistance = 5000},
         {Vector(755, 5313, 79), Angle(0, 180, 0), "svoboda", icon = "stalker/icons/freedom_logo.png", iconDistance = 5000},
         {Vector(-3484, -3031, 32), Angle(0.000, 90.000, 0.000), "dolg", icon = "stalker/icons/duty_logo.png", iconDistance = 5000},
         {Vector(2192, 14129, 32), Angle(0, 0, 0), "monolit", icon = "stalker/icons/monolith_logo.png", iconDistance = 5000},
         {Vector(-460, -4368, 12), Angle(0.000, -125.000, 0.000), "renegati", icon = "stalker/icons/renegats_logo.png", iconDistance = 5000},
         {Vector(7434.789551, -3728.931885, 8.323016), Angle(0.000, 90, 0.000), "naemniki", icon = "stalker/icons/merc_logo.png", iconDistance = 5000},
         {Vector(-3962, 6833, 10), Angle(0.000, 180.000, 0.000), "mutant", icon = "stalker/icons/psi.png", iconDistance = 5000},
		 {Vector(1279.990967, -9875.494141, 32), Angle(0.000, 90.000, 0.000), "orden", icon = "stalker/icons/orden.png", iconDistance = 10000},
		 {Vector(1279.990967, -9875.494141, 32), Angle(0.000, 90.000, 0.000), "orden", icon = "stalker/icons/orden.png", iconDistance = 10000},
		 {Vector(3669.779297, 14634.916992, 49.714806), Angle(-0.000, 180.000, 0.000), "monolith_dispatch", icon = "stalker/icons/zombies_logo.png", iconDistance = 5000},
	},
	rp_stalker_urfim = {
		{Vector(-948, -12368, -384), Angle(0, 90, 0), "infobarmen", icon = "stalker/icons/info_logo.png", iconDistance = 5000},
		{Vector(-11432, -12326, -384), Angle(0, 0, 0), "altvsy", icon = "stalker/icons/army_logo.png", iconDistance = 5000},
		{Vector(-11432, -12510, -384), Angle(0, 0, 0), "vs"},
		{Vector(-8111, -5150, -34), Angle(0, -90, 0), "bandit", icon = "stalker/icons/bandit_logo.png", iconDistance = 5000},
		{Vector(10833, 4001, -534), Angle(0, -45, 0), "altclearsky", icon = "stalker/icons/clearsky_logo.png", iconDistance = 5000},
		{Vector(2151, -11838, -128), Angle(0, 90, 0), "nig", icon = "stalker/icons/scientis_logo.png", iconDistance = 5000},
		{Vector(8776, -774, -122), Angle(0, 90, 0), "svoboda", icon = "stalker/icons/freedom_logo.png", iconDistance = 5000},
		{Vector(345, -4210, 128), Angle(0.000, -180.000, 0.000), "dolg", icon = "stalker/icons/duty_logo.png", iconDistance = 5000},
		{Vector(796, 2776, -896), Angle(0, 90, 0), "monolit", icon = "stalker/icons/monolith_logo.png", iconDistance = 5000},
		{Vector(3943, 6978, -369), Angle(0.000, 80, 0.000), "renegati", icon = "stalker/icons/renegats_logo.png", iconDistance = 5000},
		{Vector(-2293, -7243, 136), Angle(0.000, 90, 0.000), "naemniki", icon = "stalker/icons/merc_logo.png", iconDistance = 5000},
		{Vector(1533, 3525, 384), Angle(0.000, -135.000, 0.000), "mutant", icon = "stalker/icons/psi.png", iconDistance = 5000}, --stalker/icons/zombies_logo.png
   },
  	rp_stalker_urfim_v3 = isNoDonate and {
		{Vector(-5960, -14115, -4152), Angle(0, 90, 0), "infobarmen", icon = "stalker/icons/info_logo.png", iconDistance = 5000},
		{Vector(-13702, -11752, -4064), Angle(0, 90, 0), "altvsy", icon = "stalker/icons/army_logo.png", iconDistance = 5000},
		{Vector(-13725, -10021, -4080), Angle(0, -90, 0), "vs"},
		{Vector(-5960, -14115, -4152), Angle(0, 90, 0), "infobarmen", icon = "stalker/icons/info_logo.png", iconDistance = 5000},
		{Vector(-12828, -6645, -3951), Angle(0, 0, 0), "bandit", icon = "stalker/icons/bandit_logo.png", iconDistance = 5000},
		{Vector(6763, 1178, -4248), Angle(0, 180, 0), "altclearsky", icon = "stalker/icons/clearsky_logo.png", iconDistance = 5000},
		{Vector(-4205, -13181, -3962), Angle(0, 0, 0), "nig", icon = "stalker/icons/scientis_logo.png", iconDistance = 5000},
		{Vector(5345, -3041, -4088), Angle(0, 0, 0), "svoboda", icon = "stalker/icons/freedom_logo.png", iconDistance = 5000},
		{Vector(-4523, -8120, -3824), Angle(0.000, 90.000, 0.000), "dolg", icon = "stalker/icons/duty_logo.png", iconDistance = 5000},
		{Vector(-5149, 2642, -4080), Angle(0, 0, 0), "monolit", icon = "stalker/icons/monolith_logo.png", iconDistance = 5000},
		{Vector(3822, 6441, -3955), Angle(0.000, 180, 0.000), "renegati", icon = "stalker/icons/renegats_logo.png", iconDistance = 5000},
		{Vector(-7528, -8200, -3936), Angle(0.000, 90, 0.000), "naemniki", icon = "stalker/icons/merc_logo.png", iconDistance = 5000},
		{Vector(-5925, 1431, -3840), Angle(0.000, -45.000, 0.000), "mutant", icon = "stalker/icons/psi.png", iconDistance = 5000},
		{Vector(-14618.188477, 4351.602539, -3823), Angle(0.000, 0.000, 0.000), "orden", icon = "stalker/icons/orden.png", iconDistance = 15000},
		{Vector(-5914.608887, 2566.827148, -4131.625488), Angle(0.014, 0.217, -0.008), "monolith_dispatch", icon = "stalker/icons/zombies_logo.png", iconDistance = 5000},
	} or {
		{Vector(-5960, -14115, -4152), Angle(0, 90, 0), "infobarmen", icon = "stalker/icons/info_logo.png", iconDistance = 5000},
		{Vector(-13702, -11752, -4064), Angle(0, 90, 0), "altvsy", icon = "stalker/icons/army_logo.png", iconDistance = 5000},
		{Vector(-13725, -10021, -4080), Angle(0, -90, 0), "vs"},
		{Vector(-12828, -6645, -3951), Angle(0, 0, 0), "bandit", icon = "stalker/icons/bandit_logo.png", iconDistance = 5000},
		{Vector(6763, 1178, -4248), Angle(0, 180, 0), "altclearsky", icon = "stalker/icons/clearsky_logo.png", iconDistance = 5000},
		{Vector(-4205, -13181, -3962), Angle(0, 0, 0), "nig", icon = "stalker/icons/scientis_logo.png", iconDistance = 5000},
		{Vector(5345, -3041, -4088), Angle(0, 0, 0), "svoboda", icon = "stalker/icons/freedom_logo.png", iconDistance = 5000},
		{Vector(-4523, -8120, -3824), Angle(0.000, 90.000, 0.000), "dolg", icon = "stalker/icons/duty_logo.png", iconDistance = 5000},
		{Vector(-5149, 2642, -4080), Angle(0, 0, 0), "monolit", icon = "stalker/icons/monolith_logo.png", iconDistance = 5000},
		{Vector(3822, 6441, -3955), Angle(0.000, 180, 0.000), "renegati", icon = "stalker/icons/renegats_logo.png", iconDistance = 5000},
		{Vector(-7528, -8200, -3936), Angle(0.000, 90, 0.000), "naemniki", icon = "stalker/icons/merc_logo.png", iconDistance = 5000},
		{Vector(-5925, 1431, -3840), Angle(0.000, -45.000, 0.000), "mutant", icon = "stalker/icons/psi.png", iconDistance = 5000}, --stalker/icons/zombies_logo.png
		{Vector(-14618.188477, 4351.602539, -3823), Angle(0.000, 0.000, 0.000), "orden", icon = "stalker/icons/orden.png", iconDistance = 15000},
		{Vector(-5914.608887, 2566.827148, -4131.625488), Angle(0.014, 0.217, -0.008), "monolith_dispatch", icon = "stalker/icons/zombies_logo.png", iconDistance = 5000},
	},
}
*/

rp.cfg.DialogueNPCs = {
    rp_pripyat_urfim = {
        {Vector(3122.286133, 14640.269531, 23.961222), Angle(0.000, 180.000, 0.000), "terminal", iconDistance = 5000},
    },
    rp_stalker_urfim_v3 = {
        {Vector(-5984.842773, 2566.921875, -4180.241699), Angle(0.000, 8.868, 0.000), "terminal", iconDistance = 5000},
        {Vector(-6900, -14836, -4336), Angle(0, 89, 0), "provodnik", icon = "stalker/icons/info_logo.png", iconDistance = 5000},
        {Vector(-1420, 11143, -3788), Angle(0, -3, 0), "provodniktwo", icon = "stalker/icons/info_logo.png", iconDistance = 5000},
        --{Vector(1991, -4880, -3840), Angle(0, -92, 0), "stalker", icon = "stalker/icons/info_logo.png", iconDistance = 5000},
    },
    rp_stalker_urfim = {
        {Vector(-126, 2880, -1008), Angle(0, -179, 0), "terminal", iconDistance = 5000},
    },
}


rp.RadioChanels = {}

rp.cfg.ArtefactsPos = {
        ['rp_limanskhospital_urfim'] = {
    },
	['rp_stalker_urfim'] = {
        --Ночная звезда
        {'art_nightstar', Vector(-7120, -952, -160), Angle(0.000, 117.924, 0.000)},
        {'art_nightstar', Vector(12086, -11860, -483), Angle(0, -83, 0)},
        --Грави
        {'art_gravi', Vector(6560.879395, -12744.955078, -248.976761), Angle(0.984, 83.467, 1.435)},
        {'art_gravi', Vector(-7343.560059, 76.862633, -100.322258), Angle(0.984, 83.467, 1.435)},
        --Ломоть Мяса
        {'art_mincermeat', Vector(2036.836792, -7724.962891, 24.081631), Angle(0.000, -87.580, 0.000)},
        {'art_mincermeat', Vector(516, -6588, 24), Angle(0.000, -87.580, 0.000)},
        --Колобок
        {'art_kolobok', Vector(576.777710, 6292.254395, 154.559052), Angle(0.000, 171.938, 0.000)},
        {'art_kolobok', Vector(-2079, -6699, 161), Angle(0, -178, 0)},
        {'art_kolobok', Vector(7912, 2995, -574), Angle(-0.000, 140.521, 0.000)},
        {'art_kolobok', Vector(4449.146973, -843.234009, -788.436829), Angle(0.000, -126.806, 0.000)},
        --Глаз
		{'art_eye', Vector(-7491.297363, -7734.304688, -191.990311), Angle(0.000, -38.898, 0.000)},
        {'art_eye',  Vector(-6037.759277, -7968.894531, -178.900589), Angle(-0.000, -90.405, 0.000)},
        --Кристал
        {'art_crystal', Vector(5842.756348, -810.034180, -31.766428), Angle(-6.432, -176.603, 5.145)},
        {'art_crystal', Vector(-7491.101074, 10571.894531, -112.412514), Angle(0.000, -179.913, 0.000)},
        --Душа
        {'art_soul', Vector(-1399.122070, 12078.118164, -174.161377), Angle(0.000, 89.438, 0.000)},
        {'art_soul', Vector(7340.778320, 130.072830, -812.732910), Angle(0.000, 0.000, 0.000)},
        --Пузырь
        {'art_ballon',  Vector(-4542, -6942, -807), Angle(0.000, 156.060, 0.000)},
        {'art_ballon',  Vector(1565.986328, -11440.149414, -889.383667), Angle(-0.000, -90.405, 0.000)},
        {'art_ballon',  Vector(8520.371094, -10267.448242, -820.622986), Angle(-0.570, 31.785, 0.571)},
        --Медуза
        {'art_medusa', Vector(-7683.950684, 1540.963257, -175.057251), Angle(0.000, -90.044, 0.000)},
        --Цветок
        {'art_crystalflower', Vector(772.190002, 5650.432617, 154.715027), Angle(-53.182, -83.233, -32.651)},
        {'art_crystalflower', Vector(9352.024414, 9410.886719, -198.617249), Angle(0.000, -95.447, 0.000)},
        --Компас
        {'art_compass', Vector(7206.582031, 4856.301270, -137.239670), Angle(0.000, -0.000, 0.000)},
        {'art_compass', Vector(7580.462891, -1327.923950, -780.934509), Angle(0.000, 0.000, 0.000)},
        --Штурвал
        {'art_control', Vector(7721.242676, 13512.273438, -137.511856), Angle(20.971, -179.791, 0.687)},
        --Выверт
        {'art_vyvert', Vector(-4580.646973, 6819.607422, -310.268127), Angle(-0.000, 179.550, 0.000)},
        --Вспышка
		{'art_electra', Vector(-3001.423096, 3371.456787, 240.570557), Angle(0.000, -46.268, 0.000)},
        --Кровь Камня
        {'art_blood', Vector(9357.569336, 8733.936523, -236.521835), Angle(-0.000, -81.364, 0.000)},
        {'art_blood', Vector(2572, -4574, 92), Angle(0, -121, 0)},
        --Золотая Рыбка
        {'art_goldfish', Vector(-630.764038, 13114.739258, -305.167969), Angle(-0.642, -3.261, 0.098)},
        --Батарейка
        {'art_dummybattary', Vector(8160.515137, -4866.995605, -799.318726), Angle(0.000, -45.000, 0.000)},
        {'art_dummybattary', Vector(12242.234375, -7277.341309, -554.922363), Angle(0.000, 160.156, 0.000)},
        --Пламя
        {'art_fire',  Vector(8334.160156, -2449.988037, -825.739868), Angle(0.493, -90.824, 0.006)},
        {'art_fire', Vector(-7442.479980, 10298.339844, -104.776169), Angle(0.000, -164.890, 0.000)},
        --Ледышка
		{'art_ice', Vector(6598, -653, 165), Angle(0.000, 45.000, 0.000)},
        --Сучья Погремушка
		{'art_antiexplosion', Vector(2756.659424, -6130.688477, 1034.011230), Angle(-0.000, -0.615, 0.000)},
        --Светляк
        {'art_electraflash', Vector(-3546.092041, 3246.985840, 320.767426), Angle(0.000, -53.057, 0.000)},
	},
	['rp_stalker_urfim_v3'] = {
        -- Подземка Электро
		{'art_dummybattary', Vector(-8028.318359, -853.989319, -4431.968750), Angle(0.000, 0.000, 0.000)},
		{'art_ice', Vector(-7855.940430, -843.518250, -4401.955078), Angle(0.000, 1.674, 0.000)},
		-- Свалка Техники
		{'art_electraflash', Vector(9314.519531, -7696.846680, -3820.723877), Angle(0.000, 5.680, 0.000)},
		{'art_electraflash', Vector(9316.353516, -9142.230469, -3775.964600), Angle(-0.000, -159.088, 0.000)},
		{'art_control', Vector(9951.667969, -7205.343262, -3562.415039), Angle(0.000, 58.815, 0.000)},
        -- Разрушенный Мост
        {'art_kolobok', Vector(-10685.623047, 4053.607422, -3833.916504), Angle(-0.000, -165.617, 0.000)},
        -- Карьер
        {'art_gravi', Vector(31.641876, -12267.918945, -4227.431152), Angle(3.945, 327.077, 0.000)},
        {'art_gravi', Vector(-6.681959, -13157.958008, -4145.262695), Angle(4.004, 40.186, 0.000)},
        -- Свалка
        {'art_soul', Vector(-10415.073242, -747.463257, -4080.178467), Angle(-0.000, -120.176, 0.000)},
        {'art_soul', Vector(-10665.222656, -1257.499634, -4074.412109), Angle(0.000, -89.040, 0.000)},
        {'art_medusa', Vector(-12057.025391, 2095.591064, -3758.171631), Angle(-0.000, -140.544, 0.000)},
        {'art_medusa', Vector(-11649.118164, 2878.989014, -3896.402100), Angle(11.501, 196.888, 0.000)},
        {'art_ballon', Vector(-12566.464844, -108.925911, -4241.043457), Angle(26.450, 254.019, 0.000)},
        {'art_ballon', Vector(-12277.368164, 110.673721, -4162.237305), Angle(3.079, 287.719, 0.000)},
        -- Подвал АТП
        {'art_blood',Vector(-14731, 4384, -4001),Angle(0, -141, 0)},
        {'art_ballon',Vector(-14850.871094, 4284.496094, -3996.541992),Angle(0.629, -34.217, 0.000)},
        -- Детская Площадка
        {'art_dummybattary', Vector(-8040.481934, 2980.894287, -3851.909424), Angle(4.685, 239.450, 0.000)},
        {'art_ice', Vector(-8314.417969, 2774.538574, -3764.250732), Angle(0.000, 143.672, 0.000)},
        -- Зеленный Лес
        {'art_ballon', Vector(-1901.514282, 8292.122070, -3829.447998), Angle(0.785, 185.494, 0.000)},
        {'art_goldfish', Vector(-2292.936523, 8071.215332, -3830.953613), Angle(-0.000, 150.346, 0.000)},
        -- Переход
        {'art_dummybattary', Vector(-1143.342529, 4764.519043, -3805.623535), Angle(-0.000, -150.816, 0.000)},
        {'art_dummy', Vector(-1166.023193, 3983.935791, -3801.991699), Angle(0.000, 96.305, 0.000)},
        -- Разрыв
        {'art_compass', Vector(6021.076660, 6809.633789, -3965.182861), Angle(0.000, 135.000, 0.000)},
        {'art_crystal', Vector(6022.995117, 6806.750000, -4041.178711), Angle(1.655, 270.706, 0.000)},
        -- Снег
        {'art_ice', Vector(1244.147461, -2617.868164, -3973.266846), Angle(0.000, 23.232, 0.000)},
        -- Горящий Хутор
        {'art_dummyglass', Vector(-10263.096680, -8581.513672, -4031.102539), Angle(-0.000, -134.016, 0.000)},
        {'art_eye', Vector(-10923.717773, -9439.125977, -4057.692627), Angle(0.000, -138.225, 0.000)},
        {'art_medusa', Vector(-10708.569336, -9339.211914, -4063.416504), Angle(0.000, 2.267, 0.000)},
        {'art_medusa', Vector(-10695.934570, -9480.243164, -4009.612305), Angle(0.000, 60.081, 0.000)},
        -- Котлован
        {'art_crystal', Vector(-12679.914062, 8707.657227, -3765.210693), Angle(0.374, 36.257, 0.000)},
        {'art_nightstar', Vector(-12504.571289, 8198.067383, -3758.455566), Angle(0.000, 83.352, 0.000)},
        {'art_eye', Vector(-13075.026367, 8206.648438, -3771.353271), Angle(2.773, 101.748, 0.000)},
        -- Поезд Спышка
        {'art_soul', Vector(-4950.915039, 9479.733398, -3757.375244), Angle(0.000, 177.856, 0.000)},
        {'art_ice', Vector(-4950.915039, 9479.733398, -3757.375244), Angle(0.000, 177.856, 0.000)},
        -- Хим Завод
        {'art_mincermeat',Vector(854.037476, 614.132812, -3958.757080), Angle(-0.000, -87.368, 0.000)},
        {'art_mincermeat',Vector(1019.254395, 543.792786, -3961.572754), Angle(0.000, -33.180, 0.000)},
        -- Пространка
        {'art_crystalflower',Vector(3215.235840, 623.251892, -156.764267), Angle(0.000, -33.211, 0.000)},
        -- Лаборатория
        {'art_compass', Vector(5614, -10617, -4428),Angle(0, 89, 0)},
        {'art_mincermeat', Vector(5781.013184, -10550.944336, -4281.329590),Angle(0.000, 179.564, 0.000)},
        {'art_mincermeat', Vector(5455.370605, -10279.642578, -4449.966797),Angle(-0.000, -48.525, 0.000)},
        -- Подземка газ
        {'art_blood', Vector(-3640.382324, -485.871338, -4372.770996), Angle(0.000, -349.539, 0.000)},
        {'art_blood', Vector(-3484.051270, -307.618286, -4369.340332), Angle(0.000, -0.767, 0.000)},
		},
}


rp.cfg.GreenZones = {
	rp_stalker_urfim_v3 = {
		{Vector(-5230, 11574, 66), Vector(-4327, 12229, 88)},
		{Vector(-3588, 4107, -396), Vector(-2056, 5113, -384)},
		{Vector(-4362, -14018, -557), Vector(-635, -10248, -334)},
--		{Vector(243, -12228, -621), Vector(925, -11076, -93),},
	},
	rp_pripyat_urfim = {
		--{Vector(-2558, -13276, -104), Vector(-177, -10102, 678)},
		{Vector(6058, -5513, -397), Vector(8979, -3497, 636)},
		{Vector(6058, -3497, -400), Vector(7802.365723, -3049, 636)},
		--{Vector(7802.365723, -3767, -400), Vector(8316.314453, -3497.006836, 636)},
	},
	rp_stalker_urfim = {
--		{Vector(-3784, -14495, -500), Vector(329, -9925, 790)},
        {Vector(-1964, -12009, -515), Vector(-3062, -10159, 522)}, -- Здание
        {Vector(-619, -301, 209), Vector(-1049, -859, 676)}, -- Крот
        {Vector(-10249, 11921, -352), Vector(-11019, 12946, -38)}, -- Еврей
        {Vector(-1019, -11931, -553), Vector(-12, -13338, -14)}, -- Колпак
	},
	rp_stalker_urfim_v3 = {
--		{Vector(-10264, -15512, -4320), Vector(-4760, -11974, -2871)},
        {Vector(-7648, -14896, -4270), Vector(-6122, -13923, -4450)}, -- Подвал
        {Vector(-6252, -14218, -4025), Vector(-5345, -13455, -4272)}, -- Колпак
        {Vector(-6650, -3569, -4003), Vector(-5700, -2201, -3450)}, -- Крот
        {Vector(-15488, 9778, -4007), Vector(-14545, 10675, -4166)}, -- Еврей
        {Vector(-1966, 10544, -3792), Vector(-183, 12247, -3449)}, -- Ферма
        {Vector(-9752, 9862, -3836), Vector(-8723, 10383, -3680)}, -- Гаваец
	},
	rp_st_pripyat_urfim = {
		{Vector(-3846, -12739, 8), Vector(-1801, -9470, 941)},
	},
}

rp.cfg.PhrasesBeforeEmittion = {
	{'Доктор Магнус', 'Сталкеры, внимание! Выброс начнётся с минуты на минуту! Ищите глубокую нору, если жить охото!'},
	{'Лебедев', 'Всем бойцам внимание! Приближается выброс! Бегом в укрытия! Бего-ом!!!'},
}

rp.cfg.PhrasesAfterEmittion = {
	{'Неизвестный', 'Всё, ребята, выброс, слава Богу, закончился! Надеюсь, никто не пострадал?'},
}

rp.cfg.timeJobRecovery = 600

rp.cfg.saveProps = {
	timeSave = 600,
	timeRecovery = 600,
	timeFileDelete = 60 * 30,
	ents = {
		["ent_picture"] = {
			save = function(ent) return util.TableToJSON({url = ent:GetURL(), color = ent:GetColor()}) end,
            load = function(ent, arg) args = util.JSONToTable(args) if istable(args) then ent:SetURL(args[1]) ent:SetColor(args[2]) end end,
		},
		["armor_lab"] = {},
		["microwave"] = {},
		["media_radio"] = {},
		["media_projector"] = {},
		["media_tv"] = {},
		["money_printer"] = {},
		["mp_basic_1lvl"] = {},
		["mp_basic_2lvl"] = {},
		["mp_basic_3lvl"] = {},
		["mp_basic_4lvl"] = {},
		["mp_basic_5lvl"] = {},
		["mp_basic_6lvl"] = {},
		["mp_basic_7lvl"] = {},
		["mp_basic_8lvl"] = {},
		["mp_basic_9lvl"] = {},
	},
}


rp.cfg.DrawMultiplayer = 5000
rp.cfg.Fog = {
	Day = {
		fogStart = 8600,
		fogEnd = 10200,
		col = Color(49, 45, 44),
		fogDensity = 1
	},
	Night = {
		fogStart = 5000,
		fogEnd = 5300,
		col = Color(0, 0, 0),
		fogDensity = 1
	}
}

rp.EmissionButtonName = {
	rp_stalker_urfim = "blowout_button", --Выброс
	rp_pripyat_urfim = "blowout_button", --Выброс
	rp_stalker_urfim_v3 = "blowout_button", --Выброс
	rp_st_pripyat_urfim = "blowout_button", --Выброс
}

rp.cfg.SurviveTimeMultiplayer = {
	{duration = 10 * 60, multiplayer = 0.1},
	{duration = 25 * 60, multiplayer = 0.25},
	{duration = 50 * 60, multiplayer = 0.5},
	{duration = 80 * 60, multiplayer = 0.7},
	{duration = 120 * 60, multiplayer = 1},
}

rp.cfg.ArtTpPos = {
	rp_stalker_urfim_v3 = {Vector(521, -11793, -219), Vector(10608, -11111, 155), Vector(7361, 3727, -261), Vector(11339, 13165, -101), Vector(-3426, 13187, 522), Vector(-7757, -3247, -31), Vector(-1249, 2679, -63), Vector(-672, 9787, 35)},
	rp_pripyat_urfim = {Vector(1134, 975, 0), Vector(7150, -3212, 0), Vector(6828, -11490, 0), Vector(-5637, -13457, 0), Vector(-9735, -4412, 0), Vector(-6325, 1851, 0), Vector(-6904, 7847, 1630), Vector(-3775, 9731, 580), Vector(1584, 9952, 1359), Vector(5460, 7312, 1344), Vector(5903, 11901, 240), Vector(4923, 14888, 40), Vector(11312, 12728, -185), Vector(7853, 2176, 25), Vector(-2963, 2725, 752), Vector(-3516, 3808, 45), Vector(-2993, 3317, -180), Vector(-3427, 4298, -180), Vector(-5311, 1899, 25), Vector(-5311, 1899, 25), Vector(-4650, -9513, 215), Vector(6197, -12769, -110), Vector(4492, -8076, 1075), Vector(1389, -5232, 600), Vector(1032, 4649, -500), Vector(3548, 14635, 15), Vector(-3959, -4565, -498), Vector(-8274, -6755, 255), Vector(113, -11868, 15), Vector(-2012, -11450, 300)},
	rp_stalker_urfim = {Vector(-1358, 12084, -176), Vector(8794, -1704, 1027), Vector(2874, -6755, 950), Vector(439, 3631, 1790), Vector(9348, 9363, -160), Vector(12734, -7023, -11), Vector(-9112, -5578, 1181), Vector(3281, 9791, 130), Vector(6305, 9532, 433), Vector(9698, 13291, -172), Vector(-9579, 14638, -126), Vector(-4863, 6386, -365), Vector(-5346, -69, 120), Vector(-12033, -10538, 307), Vector(-6868, -11999, -437), Vector(-507, -11422, -375), Vector(10796, -9171, -358), Vector(1563, -1892, 400), Vector(1556, -1903, 398), Vector(-665, -406, 397), Vector(-2739, -4178, 159), Vector(-5950, -4751, -225), Vector(5818, -10930, -781), Vector(3800, 540, -810), Vector(-142, 2876, -890), Vector(-6642, -4495, 11536), Vector(6956, -570, -812)},
	rp_stalker_urfim_v3 = {Vector(-11029, -5806, -3845), Vector(-12408, 99, -4169), Vector(5397, 3138, -4221), Vector(4214, 1194, -3199), Vector(-5991, -3069, -3786)},
	rp_st_pripyat_urfim = {Vector(996, -1919, 543), Vector(-3134, 2449, -272), Vector(-10965, 12499, 62), Vector(11303, -11820, 451), Vector(2157, -12480, 63)},
}

rp.cfg.StashContent = {
	{'models/weapons/w_spas12.mdl', 'swb_spas14', 1, 1},
    {'models/weapons/w_ak74su_mod.mdl', 'swb_ak74su', 1, 1},
	{'models/weapons/w_rif_abakan.mdl', 'swb_abaton', 1, 1},
	{'models/weapons/w_uzi.mdl', 'swb_uzi', 1, 1},
	{'models/weapons/w_masada.mdl', 'swb_masada', 1, 1},
	{'models/weapons/w_stalker_pb.mdl', 'swb_pb', 1, 1},
	{'models/weapons/w_ak74.mdl', 'swb_ak74', 1, 1},
	{'models/weapons/w_sv10.mdl', 'swb_sv10', 1, 1},
	{'models/weapons/w_mt9.mdl', 'swb_mt9', 1, 1},
	{'models/weapons/w_g36c.mdl', 'swb_g36c', 1, 1},
	{'models/weapons/w_stalker_m1911.mdl', 'swb_colt', 1, 1},
	{'models/weapons/w_stalker_makarov.mdl', 'swb_makarov', 1, 1},
	{'models/weapons/w_extreme_ratio.mdl', 'swb_knife', 1, 1},
	{'models/stalker/item/medical/medkit1.mdl', 'ent_medpack', 1, 1},
	{'models/stalkertnb/outfits/sunrise_loner.mdl', 'armor_piece_full', 1, 1},
	{'models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl', 'durgz_weed', 1, 1},
	{'models/katharsmodels/contraband/zak_wiet/zak_wiet.mdl', 'drugs_spice', 1, 1},
	{'models/cocn.mdl', 'durgz_cocaine', 1, 1},
	{'models/boxopencigshib.mdl', 'durgz_cigarette', 1, 1},
	{'models/weapons/w_c4.mdl', 'keypad_cracker', 1, 1},
	{'models/weapons/w_crowbar.mdl', 'lockpick', 1, 1},
	{'models/weapons/w_mosin_sniper.mdl', 'swb_mosinsniper', 1, 1},
	{'models/tnb/weapons/w_detector_bear.mdl', 'detector_bear', 1, 1},
	{'models/weapons/w_skorpion.mdl', 'swb_scorpion', 1, 1},
	{'models/weapons/w_snip_vinto.mdl', 'swb_vss_kekler', 1, 1},
	{'models/weapons/w_ppsh.mdl', 'swb_ppsh41', 1, 1},
	{'models/weapons/w_l85.mdl', 'swb_l85', 1, 1},
	{'models/weapons/w_stalker_winchester.mdl', 'swb_winchester', 1, 1},
	{'models/weapons/w_stalker_ak74u.mdl', 'swb_ak74_u', 1, 1},
	{'models/weapons/w_taurus.mdl', 'swb_taurus', 1, 1},
	{'models/weapons/w_stalker_m9.mdl', 'swb_baretta_single', 1, 1},
	{'models/weapons/w_m14.mdl', 'swb_m21emr', 1, 1},
	{'models/stalkertnb2/outfits/io7a_merc3.mdl', 'ent_cloth1', 1, 1},
	{'models/stalkertnb2/outfits/sunrise_bandit1.mdl', 'ent_cloth2', 1, 1},
	{'models/stalkertnb2/outfits/sunrise_loner.mdl', 'ent_cloth3', 1, 1},
	{'models/stalkertnb2/outfits/io7a_merc2.mdl', 'ent_cloth4', 1, 1},
	{'models/stalkertnb2/outfits/seva_freedom.mdl', 'ent_cloth6', 1, 1},
	{'models/stalkertnb/outfits/exo_dave.mdl', 'ent_cloth7', 1, 1},
	{'models/stalker/item/food/vokda.mdl', 'drugz_vodka', 1, 1},
	{'models/stalker/item/medical/antirad.mdl', 'ent_antirad', 1, 1},
	{'models/weapons/w_stalker_grenade_f_1.mdl', 'stalker_grenade_f1', 1, 1},
	{'models/weapons/w_dragunov__.mdl', 'swb_svd', 1, 1},
	{'models/weapons/w_lr300.mdl', 'swb_lr300', 1, 1},
	{'models/weapons/w_mp5.mdl', 'swb_mp5', 1, 1},
	{'models/weapons/w_groza.mdl', 'swb_groza', 1, 1},
	{'models/custom/guitar/m_d_45.mdl', 'guitar_stalker', 1, 1},
	{'models/kali/miscstuff/stalker/detector_veles.mdl', 'detector_veles', 1, 1},
	{'models/weapons/w_stalker_grenade_rgd.mdl', 'stalker_grenade_rgd', 1, 1},
	{'models/weapons/w_stalker_grenade_gd.mdl', 'stalker_grenade_gd', 1, 1},
	{'models/weapons/w_knife_stalker.mdl', 'stalker_knife', 1, 1},
	{'models/stalker/item/medical/medkit2.mdl', 'weapon_medkit', 1, 1},
	{'models/stalker/item/medical/medkit1.mdl', 'health_kit_bad', 1, 1},
	{'models/weapons/w_slam.mdl', 'weapon_slam', 1, 1},
	{'models/weapons/w_m61_fraggynade.mdl', 'm9k_m61_frag', 1, 1},
	{'models/weapons/w_sticky_grenade_thrown.mdl', 'm9k_sticky_grenade', 1, 1},
	{'models/weapons/w_fc2_machete.mdl', 'm9k_machete', 1, 1},
	{'models/predatorcz/stalker/artifacts/medusa.mdl', 'art_medusa', 1, 1},
	{'models/predatorcz/stalker/artifacts/crystal_plant.mdl', 'art_crystalplant', 1, 1},
	{'models/predatorcz/stalker/artifacts/compass.mdl', 'art_compass', 1, 1},
	{'models/predatorcz/stalker/artifacts/gold_fish.mdl', 'art_goldfish', 1, 1},
	{'models/predatorcz/stalker/artifacts/gravi.mdl', 'art_gravi', 1, 1},
	{'models/predatorcz/stalker/artifacts/fuzz kolobok.mdl', 'art_kolobok', 1, 1},
	{'models/predatorcz/stalker/artifacts/dummy_battery.mdl', 'art_dummybattary', 1, 1},
	{'models/weapons/w_awm.mdl', 'swb_awm', 1, 1},
	{'models/weapons/w_ak103.mdl', 'swb_ak103', 1, 1},
	{'models/weapons/w_ak107.mdl', 'swb_ak107', 1, 1},
	{'models/weapons/w_ak54.mdl', 'swb_ak54', 1, 1},
	{'models/weapons/w_ak74su_mod.mdl', 'swb_ak74su_mod', 1, 1},
	{'models/weapons/w_sr3m.mdl', 'swb_aksilens', 1, 1},
	{'models/weapons/w_styer.mdl', 'swb_aug_kekler', 1, 1},
	{'models/weapons/w_m92_silenced.mdl', 'swb_beretta_kekler', 1, 1},
	{'models/weapons/w_bizon.mdl', 'swb_bizonsilens', 1, 1},
	{'models/weapons/w_stalker_deagle.mdl', 'swb_deagle', 1, 1},
	{'models/weapons/w_stalker_striker.mdl', 'swb_eliminator', 1, 1},
	{'models/weapons/w_stalker_fort12.mdl', 'swb_fort_12', 1, 1},
	{'models/weapons/w_stalker_f2000.mdl', 'swb_f2000', 1, 1},
	{'models/weapons/w_g3_mod.mdl', 'swb_g3_mod', 1, 1},
	{'models/weapons/w_g36k.mdl', 'swb_g36k', 1, 1},
	{'models/weapons/w_gauss.mdl', 'swb_gauss', 1, 1},
	{'models/weapons/w_stalker_g36.mdl', 'swb_g36', 1, 1},
	{'models/weapons/w_stalker_browning.mdl', 'swb_browning', 1, 1},
	{'models/weapons/w_stalker_enfield.mdl', 'swb_enfield', 1, 1},
	{'models/weapons/w_stalker_m1911.mdl', 'swb_colt1911', 1, 1},
	{'models/weapons/w_ksvk.mdl', 'swb_ksvk', 1, 1},
	{'models/weapons/w_m240.mdl', 'swb_m240', 1, 1},
	{'models/weapons/w_m4_desert.mdl', 'swb_m4desert', 1, 1},
	{'models/weapons/w_pp2000.mdl', 'swb_pp2000', 1, 1},
	{'models/weapons/w_psg1.mdl', 'swb_psg1', 1, 1},
	{'models/weapons/w_rpd.mdl', 'swb_rpd', 1, 1},
	{'models/weapons/w_saiga12mod.mdl', 'swb_sayga_kekler', 1, 1},
	{'models/weapons/w_stalker_as_val.mdl', 'swb_asvalscoped', 1, 1},
	{'models/weapons/w_mosin_sniper.mdl', 'swb_mosinsniper', 1, 1},
	{'models/weapons/w_stalker_sg550.mdl', 'swb_sg550', 1, 1},
	{'models/weapons/w_stalker_p220.mdl', 'swb_p220', 1, 1},
	{'models/weapons/w_sten.mdl', 'swb_sten_kekler', 1, 1},
	{'models/weapons/w_stalker_svd_npc.mdl', 'swb_dragunov', 1, 1},
	{'models/weapons/w_stalker_svu.mdl', 'swb_svu', 1, 1},
	{'models/weapons/w_vepr.mdl', 'swb_vepr', 1, 1},
	{'models/weapons/w_stalker_p99.mdl', 'swb_p99', 1, 1},
	{'models/weapons/w_doublebarrel.mdl', 'swb_double_long_shotgun', 1, 1},

}

rp.cfg.SpawnPos = rp.cfg.SpawnPos or {
	rp_stalker_urfim = {
		Vector(-2210, -11726, -240),
		Vector(-2318, -11716, -240),
		Vector(-2459, -11717, -240),
		Vector(-2526, -11714, -240),
		Vector(-2645, -11718, -240),
		Vector(-2763, -11718, -240),
		Vector(-2893, -11719, -240),
		Vector(-2928, -11068, -240),
		Vector(-2849, -11068, -240),
		Vector(-2713, -11057, -240),
		Vector(-2561, -11059, -240),
		Vector(-2375, -11053, -240),
		Vector(-2201, -11057, -240),
		Vector(-2980, -10398, -240),
		Vector(-2839, -10400, -240),
		Vector(-2676, -10402, -240),
		Vector(-2502, -10394, -240),
		Vector(-2349, -10398, -240),
		Vector(-2202, -10373, -240),
		Vector(-2931, -10404, -240),
		Vector(-2318, -10384, -240),
		Vector(-2210, -11726, -24),
		Vector(-2318, -11716, -24),
		Vector(-2459, -11717, -24),
		Vector(-2526, -11714, -24),
		Vector(-2645, -11718, -24),
		Vector(-2763, -11718, -24),
		Vector(-2893, -11719, -24),
		Vector(-2928, -11068, -24),
		Vector(-2849, -11068, -24),
		Vector(-2713, -11057, -24),
		Vector(-2561, -11059, -24),
		Vector(-2375, -11053, -24),
		Vector(-2201, -11057, -24),
		Vector(-2980, -10398, -24),
		Vector(-2839, -10400, -24),
		Vector(-2676, -10402, -24),
		Vector(-2502, -10394, -24),
		Vector(-2349, -10398, -24),
		Vector(-2202, -10373, -24),
		Vector(-2931, -10404, -24),
		Vector(-2318, -10384, -24),
		Vector(-2210, -11726, -384),
		Vector(-2318, -11716, -384),
		Vector(-2459, -11717, -384),
		Vector(-2526, -11714, -384),
		Vector(-2645, -11718, -384),
		Vector(-2763, -11718, -384),
		Vector(-2893, -11719, -384),
		Vector(-2928, -11068, -384),
		Vector(-2849, -11068, -384),
		Vector(-2713, -11057, -384),
		Vector(-2561, -11059, -384),
		Vector(-2375, -11053, -384),
		Vector(-2201, -11057, -384),
		Vector(-2980, -10398, -384),
		Vector(-2839, -10400, -384),
		Vector(-2676, -10402, -384),
		Vector(-2502, -10394, -384),
		Vector(-2349, -10398, -384),
		Vector(-2202, -10373, -384),
		Vector(-2931, -10404, -384),
		Vector(-2318, -10384, -384),
	},
	rp_pripyat_urfim = {
		/*
		Vector(-2214, -10273, 32),
		Vector(-2107, -10276, 32),
		Vector(-1955, -10279, 32),
		Vector(-1769, -10282, 32),
		Vector(-1614, -10280, 32),
		Vector(-1408, -10263, 32),
		Vector(-2214, -10440, 32),
		Vector(-2034, -10443, 32),
		Vector(-1828, -10430, 32),
		Vector(-1643, -10435, 32),
		Vector(-1434, -10435, 32),
		Vector(-2202, -10599, 32),
		Vector(-2022, -10606, 32),
		Vector(-1821, -10592, 32),
		Vector(-1646, -10596, 32),
		Vector(-1460, -10599, 32),
		Vector(-1193, -10275, 32),
		Vector(-1052, -10282, 32),
		Vector(-889, -10284, 32),
		Vector(-703, -10282, 32),
		Vector(-506, -10268, 32),
		Vector(-1168, -10431, 32),
		Vector(-970, -10434, 32),
		Vector(-762, -10437, 32),
		Vector(-565, -10439, 32),
		Vector(-367, -10439, 32),
		Vector(-788, -11952, 32),
		Vector(-783, -11795, 32),
		Vector(-778, -11592, 32),
		Vector(-773, -11406, 32),
		Vector(-770, -11231, 32),
		Vector(-569, -11922, 32),
		Vector(-564, -11725, 32),
		Vector(-556, -11528, 32),
		Vector(-356, -11929, 32),
		Vector(-351, -11744, 32),
		Vector(-345, -11569, 32),
		Vector(-340, -11417, 32),
		*/
		Vector(7552, -4240, -176),
		Vector(7552, -4352, -176),
		Vector(7552, -4464, -176),
		Vector(8688, -4240, -176),
		Vector(8688, -4352, -176),
		Vector(8688, -4464, -176),
		Vector(8576, -4240, -176),
		Vector(8576, -4352, -176),
		Vector(8576, -4464, -176),
		Vector(8464, -4240, -176),
		Vector(8464, -4352, -176),
		Vector(8464, -4464, -176),
		Vector(8352, -4240, -176),
		Vector(8352, -4352, -176),
		Vector(8352, -4464, -176),
		Vector(8240, -4240, -176),
		Vector(8240, -4352, -176),
		Vector(8240, -4464, -176),
		Vector(8128, -4240, -176),
		Vector(8128, -4352, -176),
		Vector(8128, -4464, -176),
		Vector(8016, -4240, -176),
		Vector(8016, -4352, -176),
		Vector(8016, -4464, -176),
		Vector(7904, -4240, -176),
		Vector(7904, -4352, -176),
		Vector(7904, -4464, -176),
		Vector(7792, -4240, -176),
		Vector(7792, -4352, -176),
		Vector(7792, -4464, -176),
		Vector(7680, -4240, -176),
		Vector(7680, -4352, -176),
		Vector(7680, -4464, -176),
		Vector(7552, -5008, -176),
		Vector(7552, -5120, -176),
		Vector(7552, -5232, -176),
		Vector(8688, -5008, -176),
		Vector(8688, -5120, -176),
		Vector(8688, -5232, -176),
		Vector(8576, -5008, -176),
		Vector(8576, -5120, -176),
		Vector(8576, -5232, -176),
		Vector(8464, -5008, -176),
		Vector(8464, -5120, -176),
		Vector(8464, -5232, -176),
		Vector(8352, -5008, -176),
		Vector(8352, -5120, -176),
		Vector(8352, -5232, -176),
		Vector(8240, -5008, -176),
		Vector(8240, -5120, -176),
		Vector(8240, -5232, -176),
		Vector(8128, -5008, -176),
		Vector(8128, -5120, -176),
		Vector(8128, -5232, -176),
		Vector(8016, -5008, -176),
		Vector(8016, -5120, -176),
		Vector(8016, -5232, -176),
		Vector(7904, -5008, -176),
		Vector(7904, -5120, -176),
		Vector(7904, -5232, -176),
		Vector(7792, -5008, -176),
		Vector(7792, -5120, -176),
		Vector(7792, -5232, -176),
		Vector(7680, -5008, -176),
		Vector(7680, -5120, -176),
		Vector(7680, -5232, -176),
	},
	rp_stalker_urfim_v3 = {
		Vector(-6726, -13950, -4408),
		Vector(-6726, -14000, -4408),
		Vector(-6726, -14050, -4408),
		Vector(-6726, -14100, -4408),
		Vector(-6726, -14150, -4408),
		Vector(-6726, -14200, -4408),
		Vector(-6726, -14250, -4408),
		Vector(-6726, -14300, -4408),
		Vector(-6726, -14350, -4408),
		Vector(-6726, -14400, -4408),
		Vector(-6726, -14409, -4408),
		Vector(-6890, -13950, -4408),
		Vector(-6890, -14000, -4408),
		Vector(-6890, -14050, -4408),
		Vector(-6890, -14100, -4408),
		Vector(-6890, -14150, -4408),
		Vector(-6890, -14200, -4408),
		Vector(-6890, -14250, -4408),
		Vector(-6890, -14300, -4408),
		Vector(-6890, -14350, -4408),
		Vector(-6890, -14400, -4408),
		Vector(-6890, -14409, -4408),
		Vector(-7050, -13950, -4408),
		Vector(-7050, -14000, -4408),
		Vector(-7050, -14050, -4408),
		Vector(-7050, -14100, -4408),
		Vector(-7050, -14150, -4408),
		Vector(-7050, -14200, -4408),
		Vector(-7050, -14250, -4408),
		Vector(-7050, -14300, -4408),
		Vector(-7050, -14350, -4408),
		Vector(-7050, -14400, -4408),
		Vector(-7050, -14409, -4408),
		Vector(-7404, -14051, -4408),
		Vector(-7450, -14051, -4408),
        Vector(-1783, 11907, -3776),
        Vector(-1664, 11815, -3776),
        Vector(-1764, 11630, -3776),
        Vector(-1611, 11452, -3776),
        Vector(-1763, 11309, -3776),
        Vector(-1617, 11157, -3776),
        Vector(-1766, 11003, -3776),
        Vector(-1601, 10939, -3776),
        Vector(-1607, 10758, -3776),
        Vector(-1726, 10763, -3776),
        Vector(-734, 10989, -3776),
        Vector(-495, 11294, -3776),
        Vector(-727, 11490, -3776),
        Vector(-548, 11621, -3776),
        Vector(-409, 11468, -3776),
        Vector(-544, 11380, -3776),
        Vector(-564, 11121, -3776),
        Vector(-552, 11121, -3776),
        Vector(-571, 11341, -3776),
        Vector(-692, 11564, -3776),
        Vector(-406, 11604, -3776),
        Vector(-567, 11391, -3776),
        Vector(-577, 11120, -3776),
        Vector(-1504, 11322, -3776),
        Vector(-1466, 11222, -3776),
        Vector(-1829, 11170, -3776),
        Vector(-1826, 11288, -3776),
        Vector(-1824, 11384, -3776),
	},
rp_limanskhospital_urfim = {
        Vector(690, -2850, 94),
        Vector(547, -2834, 115),
        Vector(561, -2716, 119),
        Vector(708, -2725, 96),
        Vector(550, -2846, 115),
        Vector(452, -2746, 116),
        Vector(286, -2830, 114),
        Vector(203, -2732, 108),
        Vector(17, -2709, 96),
   },

	rp_st_pripyat_urfim = {
		Vector(-1896, -11407, 0),
		Vector(-1950, -11407, 0),
		Vector(-2000, -11407, 0),
		Vector(-2050, -11407, 0),
		Vector(-2100, -11407, 0),
		Vector(-2150, -11407, 0),
		Vector(-2200, -11407, 0),
		Vector(-2250, -11407, 0),
		Vector(-2300, -11407, 0),
		Vector(-2350, -11407, 0),
		Vector(-2400, -11407, 0),
		Vector(-2450, -11407, 0),
		Vector(-2500, -11407, 0),
		Vector(-2550, -11407, 0),
		Vector(-2650, -11407, 0),
		Vector(-2669, -11407, 0),
		Vector(-1896, -11536, 0),
		Vector(-1950, -11536, 0),
		Vector(-2000, -11536, 0),
		Vector(-2050, -11536, 0),
		Vector(-2100, -11536, 0),
		Vector(-2150, -11536, 0),
		Vector(-2200, -11536, 0),
		Vector(-2250, -11536, 0),
		Vector(-2300, -11536, 0),
		Vector(-2350, -11536, 0),
		Vector(-2400, -11536, 0),
		Vector(-2450, -11536, 0),
		Vector(-2500, -11536, 0),
		Vector(-2550, -11536, 0),
		Vector(-2650, -11536, 0),
		Vector(-2669, -11536, 0),
		Vector(-1896, -11620, 0),
		Vector(-1950, -11620, 0),
		Vector(-2000, -11620, 0),
		Vector(-2050, -11620, 0),
		Vector(-2100, -11620, 0),
		Vector(-2150, -11620, 0),
		Vector(-2200, -11620, 0),
		Vector(-2250, -11620, 0),
		Vector(-2300, -11620, 0),
		Vector(-2350, -11620, 0),
		Vector(-2400, -11620, 0),
		Vector(-2450, -11620, 0),
		Vector(-2500, -11620, 0),
		Vector(-2550, -11620, 0),
		Vector(-2650, -11620, 0),
		Vector(-2669, -11620, 0),
		Vector(-1896, -11720, 0),
		Vector(-1950, -11720, 0),
		Vector(-2000, -11720, 0),
		Vector(-2050, -11720, 0),
		Vector(-2100, -11720, 0),
		Vector(-2150, -11720, 0),
		Vector(-2200, -11720, 0),
		Vector(-2250, -11720, 0),
		Vector(-2300, -11720, 0),
		Vector(-2350, -11720, 0),
		Vector(-2400, -11720, 0),
		Vector(-2450, -11720, 0),
		Vector(-2500, -11720, 0),
		Vector(-2550, -11720, 0),
		Vector(-2650, -11720, 0),
		Vector(-2669, -11720, 0),

	},
}

  rp.cfg.MaxCharacters = 1
  rp.cfg.EnableCharacters = true;
  rp.cfg.EnableHats = true;
  rp.cfg.CharactersChangeName = true;

 rp.cfg.CharacterMenu = {
    -- Задники
    Background = {
        { -- Первый слой
            -- Материал
            mat = Material("backgrounds/stalkerreg2.png"),
            -- (необязательно) Цвет
            color = Color(255, 255, 255),
            -- (необязательно) Насколько далеко слой будет двигаться при движении мышкой (от -любого до +любого числа)
            range = 0.01,
            -- (необязательно) Насколько быстро слой будет перемещаться (от 0 до любого положительного числа)
            speed = 0.005,
            -- (необязательно) Во сколько раз растягиваем слой по ширине (1 - без изменений)
            sizew = 1.9,
            -- (необязательно) Во сколько раз растягиваем слой по высоте (1 - без изменений)
            sizeh = 1.9,
        },
    },

    -- Цвета обводки/рамки
    Colors = {
        -- Основной цвет обводки (по умолчанию: rpui.UIColors.BackgroundGold, свой цвет: Color(r,g,b,a))
        [1] = Color( 255, 110, 0, 255 ),
        -- Дополнительный цвет обводки (по умолчанию: rpui.UIColors.Gold, свой цвет: Color(r,g,b,a))
        [2] = Color( 255, 185, 0, 255 ),
    }
}

rp.cfg.Stashes = {
	/*
	rp_pripyat_urfim = {
		{pos = Vector(-6118.851074, -13614.778320, 29.658224), ang = Angle(-0.203, -77.100, -0.418), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-6817.507812, -13177.950195, 292.416351), ang = Angle(-0.060, 90.580, -0.259), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-6984.901855, -10454.847656, 25.600895), ang = Angle(-2.026, 51.339, 3.650), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(26.505388, -11497.711914, 4.597931), ang = Angle(-0.053, -82.779, -0.095), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(3985.799805, -12744.188477, -88.166946), ang = Angle(-2.715, 77.385, 10.581), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(5092.112793, -12831.831055, -60.525345), ang = Angle(-0.055, -90.978, -0.168), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(5588.900879, -7946.327148, 4.472501), ang = Angle(-0.003, 2.825, -0.822), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(4510.485840, -8094.954590, 976.879822), ang = Angle(-0.095, -159.392, 0.061), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(4118.746582, -5481.815918, 4.477257), ang = Angle(-0.043, 146.823, -0.059), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-278.623169, -7215.344727, 4.466107), ang = Angle(-0.076, -159.668, -0.287), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-6469.656250, -6744.127930, 4.516504), ang = Angle(-0.065, 82.329, -0.034), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-7464.416992, -4510.487305, 70.757904), ang = Angle(-1.925, 61.859, -1.283), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-2896.433594, -492.519836, 4.581563), ang = Angle(-0.057, 166.248, -0.176), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-7197.754883, 1548.072144, 6.228988), ang = Angle(19.429, 95.568, 20.970), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-9138.183594, 3751.672363, 24.039236), ang = Angle(-2.174, -40.545, 80.338), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-4539.662109, 3829.216309, 66.011307), ang = Angle(-4.816, -88.748, -1.500), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-3653.129883, 8101.785645, 20.983465), ang = Angle(66.417, 89.573, -0.076), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-1439.172974, 5511.489746, 19.510334), ang = Angle(-0.288, 68.934, -5.449), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-749.017578, 7544.398438, 38.171654), ang = Angle(66.458, 88.536, -0.117), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(2006.992798, 7653.442871, 67.497276), ang = Angle(-0.082, 153.727, -0.297), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(3400.918701, 8158.476074, 12.157824), ang = Angle(66.680, 9.015, 7.892), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(1643.298096, 10136.082031, 1348.192505), ang = Angle(72.448, -90.603, -0.753), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(3755.996826, 8737.593750, 1084.534668), ang = Angle(-0.048, -122.176, -0.193), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-217.318359, 2497.960938, 6.495538), ang = Angle(-0.030, 88.103, -0.319), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		--{pos = Vector(3565.540039, 5017.014648, 292.543976), ang = Angle(0.213, 98.913, -0.743), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(1067.278687, 4780.518066, 5.336771), ang = Angle(0.524, 124.629, -0.970), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-222.685043, 12244.500977, 12.000937), ang = Angle(56.063, 87.933, -7.379), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(604.504761, 12743.431641, 396.404388), ang = Angle(40.990, 10.801, -23.641), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(4764.156250, 14622.815430, 44.515602), ang = Angle(78.381, 102.174, 11.557), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(6372.455078, 9019.168945, 61.104504), ang = Angle(-0.092, -15.569, -0.127), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(10097.282227, 13563.446289, 58.742645), ang = Angle(74.786, 110.948, -0.473), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(5654.498047, 6306.689941, 24.494307), ang = Angle(-0.102, -162.676, -0.119), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(11314.803711, 12679.110352, -189.710281), ang = Angle(3.180, 112.018, -0.497), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(9602.961914, 7420.055176, -52.082783), ang = Angle(-13.202, -102.634, -7.662), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(6741.452637, 2497.059814, 644.464661), ang = Angle(-0.072, -5.727, 0.235), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		--{pos = Vector(7006.157715, -3390.105713, 15.612417), ang = Angle(72.261, -57.442, -10.918), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-689.621826, -10773.058594, 43.776161), ang = Angle(59.441, -0.186, -0.812), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(2231.034180, 3929.166748, -500.121674), ang = Angle(73.506, 48.635, 1.009), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-2254.328369, -735.098328, -667.532898), ang = Angle(-0.038, 177.710, -0.268), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(1241.292603, -1047.467407, -488.134674), ang = Angle(22.805, 129.945, 9.265), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-3405.538574, -5741.162598, -634.400757), ang = Angle(-0.054, 115.396, -0.055), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-5478.017090, -7562.827637, -493.794891), ang = Angle(51.176, -176.968, 22.103), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-4160.545410, -11581.314453, -507.435974), ang = Angle(0.105, -173.391, -1.390), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(9888.255859, 13139.648438, 678.874695), ang = Angle(45.803, -42.817, -0.099), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-3819.576416, 3895.862793, 940.252930), ang = Angle(71.787, -90.772, -0.566), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-2839.451172, 3223.752197, 756.528137), ang = Angle(-0.043, -140.488, -0.107), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-2655.861084, 3479.332764, 109.135773), ang = Angle(-0.000, 90.000, 0.000), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-3657.345703, 3927.512695, -179.855362), ang = Angle(80.297, -109.104, -176.662), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-2651.218506, 3021.192627, -167.444778), ang = Angle(-0.067, 69.805, -0.278), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
	},
	rp_stalker_urfim = {
		{pos = Vector(-13105.940430, -13952.473633, -81.076515), ang = Angle(-3.399, 150.464, 4.635),  mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-6554.747070, -11819.877930, -474.517792), ang = Angle(-1.259, -18.476, -4.861), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-4000.414062, -11433.231445, -65.278206), ang = Angle(64.756, 88.385, -2.375), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(5370.421387, -12939.449219, -241.332748), ang = Angle(-3.276, -96.987, -7.668), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(7273.100586, -12629.796875, -179.477600), ang = Angle(3.512, -171.290, -1.593), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(12323.686523, -13361.614258, -366.877411), ang = Angle(74.781, -3.744, -5.287), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(9923.795898, -1679.151367, -88.766159), ang = Angle(66.627, 83.852, 1.155), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(8736.123047, -2970.793945, 180.498520), ang = Angle(-0.055, 90.083, -0.172), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(8294.268555, -2556.361084, -146.043716), ang = Angle(61.849, -177.639, 1.296), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(9138.314453, -1549.015869, 881.182617), ang = Angle(-0.052, -155.930, -0.171), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(9628.785156, 1550.005493, -13.930792), ang = Angle(1.195, -89.587, 54.420), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(3027.253418, -6663.013184, 43.871414), ang = Angle(65.437, -86.195, -0.383), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(2572.479248, -498.959900, 204.964249), ang = Angle(0.310, -22.768, -2.768), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(630.742554, 634.793518, 419.868530), ang = Angle(-0.044, 147.947, -7.504), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-2146.310547, -7510.210938, 316.621643), ang = Angle(-0.093, 177.389, 0.864), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-4486.458984, -5960.610352, -308.443970), ang = Angle(-32.775, 95.049, 107.351), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-4792.776367, -4407.742188, -72.154060), ang = Angle(20.508, -177.817, 0.381), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-7309.575684, 38.322102, -178.263336), ang = Angle(79.036, 170.878, 14.944), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-8341.981445, -451.703583, -314.045502), ang = Angle(69.774, -156.777, -3.482), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-8475.312500, 2349.722656, -410.729767), ang = Angle(3.302, -60.200, -0.964), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-3465.365234, 6505.391602, -43.482910), ang = Angle(-0.056, 85.434, -0.166), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-2373.611328, 8495.164062, -323.006561), ang = Angle(-0.063, -151.097, -0.104), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-5152.126465, 6586.016113, 132.486832), ang = Angle(-0.040, 156.126, -0.245), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-9590.569336, 14843.138672, -123.816841), ang = Angle(-1.175, 89.685, 11.285), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-6920.157227, 12266.855469, -249.000061), ang = Angle(-0.058, 178.984, -0.209), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-3236.852783, 10674.079102, 833.348755), ang = Angle(-3.347, -166.637, 7.049), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-285.771820, 9830.599609, -299.468628), ang = Angle(-0.327, 58.573, -4.689), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(3132.916992, 13405.936523, 177.743515), ang = Angle(0.118, -98.841, -7.957), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(12380.985352, 12305.338867, -199.510818), ang = Angle(-8.586, -95.785, 68.735), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(4652.100586, 7303.522949, -380.700134), ang = Angle(3.638, -144.333, -5.814), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(6141.804199, 4288.902344, -603.749512), ang = Angle(7.870, 129.804, -0.930), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(570.198547, 3757.289307, 1494.800415), ang = Angle(-0.000, 175.270, 0.000), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-6999.766113, -8542.587891, -197.865540), ang = Angle(-1.035, -82.413, -0.952), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-3255.908203, -9374.274414, -775.799622), ang = Angle(0.040, 2.272, -1.457), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(-1731.290894, -13003.673828, -828.461792), ang = Angle(0.449, 7.282, -0.109), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(4089.258545, -10738.679688, -694.193787), ang = Angle(-0.037, -2.103, -0.174), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(4260.349609, -9995.737305, -802.254333), ang = Angle(61.780, -177.268, 2.256), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(7524.463867, -10317.845703, -827.932434), ang = Angle(-0.048, -179.137, 0.457), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(6014.645020, -5883.238281, -767.280701), ang = Angle(-1.639, -65.075, 0.346), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(6784.068359, -3333.731445, -789.550232), ang = Angle(-0.027, -67.692, -0.112), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(6026.470703, -2834.481201, -851.669006), ang = Angle(77.748, 90.087, -0.652), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(6957.460938, -639.797791, -817.777649), ang = Angle(55.690, 142.795, 102.613), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(6516.829102, -1264.929810, -797.230774), ang = Angle(0.288, 2.458, -1.969), mdl = 'models/hgn/srp/items/backpack-1.mdl', respawn = {10 * 60, 50 * 60}},
		{pos = Vector(7310.959473, -1168.025391, -821.887756), ang = Angle(-0.054, -127.076, -0.040), mdl = 'models/instrument.mdl', respawn = {10 * 60, 50 * 60}},
	},
	*/
}

rp.cfg.DefaultVoices = {
	{
		label = 'Привет брат',
		sound = 'stalker/priv.wav',
		text = 'Привет брат',
	},
	{
		label = 'Я их вижу!',
		sound = 'stalker/vizhu.wav',
		text = 'Вот, вот, я их вижу!',
	},
	{
		label = 'Враг!',
		sound = {'stalker/vrag1.wav', 'stalker/vrag2.wav'},
		text = 'Враг!',
	},
	{
		label = 'Вали их!',
		sound = 'stalker/vpered.wav',
		text = 'Вперёд, вали их!',
	},
	{
		label = 'Убьём!',
		sound = {'stalker/ubyem1.wav', 'stalker/ubyem2.wav'},
		text = 'Убьём!',
	},
	{
		label = 'Бей их!',
		sound = {'stalker/vinosi1.wav', 'stalker/vinosi2.wav'},
		text = 'Бей их!',
	},
	{
		label = 'Ты труп!',
		sound = {'stalker/ti_trup1.wav', 'stalker/ti_trup2.wav'},
		text = 'Ты труп!',
	},
	{
		label = 'Оружие убери',
		sound = {'stalker/oruzhie1.wav', 'stalker/oruzhie2.wav'},
		text = 'Оружие убери',
	},
	{
		label = 'Прикрываю',
		sound = {'stalker/prikro1.wav', 'stalker/prikro2.wav'},
		text = 'Прикрываю!',
	},
	{
		label = 'Дерьмо!',
		sound = 'stalker/dermo.wav',
		text = 'Дерьмо!',
	},
	{
		label = 'Смех',
		sound = 'stalker/ahaha.wav',
		text = '*Ржёт*',
	},
	{
		label = 'Отвали',
		sound = {'stalker/otvali1.wav','stalker/otvali2.wav'},
		text = 'Отвали',
	},
	{
		label = 'Не стреляй!',
		sound = 'stalker/ne_strel.wav',
		text = 'Не стреляй!',
	},
	{
		label = 'Отбой',
		sound = 'stalker/otboi.wav',
		text = 'Всё мужики, отбой',
	},
}

rp.cfg.DefaultLaws 		= [[
]]

rp.cfg.DefaultLaws = ""; -- watchout

rp.cfg.DisallowDrop = {
	arrest_stick 	= true,
	door_ram 		= true,
	gmod_camera 	= true,
	gmod_tool 		= true,
	keys 			= true,
	med_kit 		= true,
	pocket 			= true,
	stunstick 		= false,
	unarrest_stick 	= false,
	weapon_keypadchecker = true,
	weapon_physcannon = true,
	weapon_physgun 	= true,
	weaponchecker 	= true,
	weapon_fists 	= true,
	weapon_zombie_fists 	= true,
}

rp.cfg.Artefacts = {
	art_ballon = true,
	art_blood = true,
	art_compass = true,
	art_control = true,
	art_crystal = true,
	art_crystalflower = true,
	art_crystalplant = true,
	art_dummy = true,
	art_dummybattary = true,
	art_dummyglass = true,
	art_electra = true,
	art_electraflash = true,
	art_eye = true,
	art_fire = true,
	art_goldfish = true,
	art_gravi = true,
	art_ice = true,
	art_kolobok = true,
	art_medusa = true,
	art_mincermeat = true,
	art_nightstar = true,
	art_psi = true,
	art_soul = true,
	art_vyvert = true,
	art_antiexplosion = true,
}

rp.cfg.Detectors = {
	[1] = {
		unlockTime = 0 * 3600,
		class = 'detector_echo'
	},
	[2] = {
		unlockTime = 300 * 3600,
		class = 'detector_bear'
	},
	[3] = {
		unlockTime = 600 * 3600,
		class = 'detector_veles'
	}
}

rp.cfg.SpawnPoints = {}

function rp.AddSpawnPoint(name, t)
	t = t[game.GetMap()]
	if t then
		local id = #rp.cfg.SpawnPoints+1
		rp.cfg.SpawnPoints[id] = {
			Name = name,
			Spawns = t.Spawns,
			Model = t.Model,
			Pos = t.Pos,
			Ang = t.Ang,
			ID = id,
			Price = t.Price
		}
		return id
	end
	return 0
end

SPAWN_JEW = rp.AddSpawnPoint('Бар Еврея', {
	rp_stalker_urfim = {
		Spawns = {Vector(-9840, 12301, -252), Vector(-9649, 12199, -244)},
		Model = 'models/player/stalker_bandit/bandit_cloak/bandit_cloak.mdl',
		Pos = Vector(-10347, 11984, -242),
		Ang = Angle(0, 90, 0),
	},
})

SPAWN_KROT = rp.AddSpawnPoint('Бар Крота', {
	rp_stalker_urfim_v3 = {
		Spawns = {Vector(-6571, -2348, -3832),Vector(-6510, -2478, -3832),Vector(-6388, -2325, -3832)},
		Model = 'models/stalkertnb/npc/npc_banditheavy_black.mdl',
		Pos = Vector(-6672, -2406, -3832),
		Ang = Angle(0, 0, 0),
	},
	rp_stalker_urfim = {
		Spawns = {Vector(-408, -562, 384)},
		Model = 'models/player/stalker_bandit/bandit_gear/bandit_gear.mdl',
		Pos = Vector(-886, -564, 388),
		Ang = Angle(0, -90, 0),
	},
})

SPAWN_KOLPACK = rp.AddSpawnPoint('Бар Колпака', {
	rp_stalker_urfim_v3 = {
		Spawns = rp.cfg.SpawnPos['rp_stalker_urfim_v3'],
		Model = "models/stalkertnb/npc/npc_banditheavy_black.mdl",
		Pos = Vector(-6205, -13638, -4152),
		Ang = Angle(0, 0, 0),
	},
	rp_stalker_urfim = {
		Spawns = {Vector(-862, -12563, -384)},
		Model = 'models/player/stalker_bandit/bandit_gp5/bandit_gp5.mdl',
		Pos = Vector(-1040, -12143, -384),
		Ang = Angle(0, -180, 0),
	},
})

SPAWN_DYAK = rp.AddSpawnPoint('Бар Оплот Изгоя', {
	rp_stalker_urfim_v3 = {
		Spawns = {Vector(-6, -5734, -4200), Vector(-268, -5860, -4200), Vector(-393, -6030, -4200)},
		Model = "models/stalkertnb/npc/npc_banditheavy_black.mdl",
		Pos = Vector(-432, -4611, -3896),
		Ang = Angle(0, 180, 0),
	},
})

SPAWN_CH = rp.AddSpawnPoint('База Чистое Небо - 95гр', {
    rp_stalker_urfim_v3 = {
        Spawns = {
            Vector(6453, 1604, -4255),

        },
        --Model = 'models/player/guard_whiterun_npc.mdl',
        --Pos = Vector(-6904, -8635, -905),
        --Ang = Angle(0, -91, 0),
        Price = 95, -- цена телепорта
    }
})

SPAWN_MONOL = rp.AddSpawnPoint('Окрестности базы Монолита - 75гр', {
    rp_stalker_urfim_v3 = {
        Spawns = {
            Vector(-7224, 827, -3840),

        },
        --Model = 'models/player/guard_whiterun_npc.mdl',
        --Pos = Vector(-6904, -8635, -905),
        --Ang = Angle(0, -91, 0),
        Price = 75, -- цена телепорта
    }
})

SPAWN_BAND = rp.AddSpawnPoint('База Бандитов - 65гр', {
    rp_stalker_urfim_v3 = {
        Spawns = {
            Vector(-13222, 2820, -3840),

        },
        --Model = 'models/player/guard_whiterun_npc.mdl',
        --Pos = Vector(-6904, -8635, -905),
        --Ang = Angle(0, -91, 0),
        Price = 65, -- цена телепорта
    }
})

SPAWN_DOLG = rp.AddSpawnPoint('База Долга - 75гр', {
    rp_stalker_urfim_v3 = {
        Spawns = {
            Vector(-4336, -7857, -3840),

        },
        --Model = 'models/player/guard_whiterun_npc.mdl',
        --Pos = Vector(-6904, -8635, -905),
        --Ang = Angle(0, -91, 0),
        Price = 75, -- цена телепорта
    }
})

SPAWN_RENEG = rp.AddSpawnPoint('База Ренегата - 125гр', {
    rp_stalker_urfim_v3 = {
        Spawns = {
            Vector(3423, 6257, -3967),

        },
        --Model = 'models/player/guard_whiterun_npc.mdl',
        --Pos = Vector(-6904, -8635, -905),
        --Ang = Angle(0, -91, 0),
        Price = 125, -- цена телепорта
    }
})

SPAWN_SVOBOD = rp.AddSpawnPoint('База Свободы - 85гр', {
    rp_stalker_urfim_v3 = {
        Spawns = {
            Vector(6004, -4260, -4103),

        },
        --Model = 'models/player/guard_whiterun_npc.mdl',
        --Pos = Vector(-6904, -8635, -905),
        --Ang = Angle(0, -91, 0),
        Price = 85, -- цена телепорта
    }
})

SPAWN_GAVAEC = rp.AddSpawnPoint('Бар Гавайца - 85гр', {
    rp_stalker_urfim_v3 = {
        Spawns = {
            Vector(-9225, 9354, -3840),

        },
        --Model = 'models/player/guard_whiterun_npc.mdl',
        --Pos = Vector(-6904, -8635, -905),
        --Ang = Angle(0, -91, 0),
        Price = 85, -- цена телепорта
    }
})

SPAWN_FERMA = rp.AddSpawnPoint('Ферма - 85гр', {
    rp_stalker_urfim_v3 = {
        Spawns = {
            Vector(-1155, 10172, -3799),

        },
        --Model = 'models/player/guard_whiterun_npc.mdl',
        --Pos = Vector(-6904, -8635, -905),
        --Ang = Angle(0, -91, 0),
        Price = 85, -- цена телепорта
    }
})

SPAWN_DERNO = rp.AddSpawnPoint('Деревня Новичков - 85гр', {
    rp_stalker_urfim_v3 = {
        Spawns = {
            Vector(-6600, -14245, -4155),

        },
        --Model = 'models/player/guard_whiterun_npc.mdl',
        --Pos = Vector(-6904, -8635, -905),
        --Ang = Angle(0, -91, 0),
        Price = 85, -- цена телепорта
    }
})

SPAWN_JEWUSI= rp.AddSpawnPoint('Бар Еврея - 85гр', {
    rp_stalker_urfim_v3 = {
        Spawns = {
            Vector(-15244, 9554, -3836),

        },
        --Model = 'models/player/guard_whiterun_npc.mdl',
        --Pos = Vector(-6904, -8635, -905),
        --Ang = Angle(0, -91, 0),
        Price = 85, -- цена телепорта
    }
})

rp.cfg.TeleportNPC = {
	rp_stalker_urfim_v3 = {
		{
			Name = 'База Свободы',
			Points = {SPAWN_SVOBOD},
			Price = 85,
		},
		{
			Name = 'База Ренегата',
			Points = {SPAWN_RENEG},
			Price = 125,
		},
		{
			Name = 'База Долга',
			Points = {SPAWN_DOLG},
			Price = 75,
		},
		{
			Name = 'База Бандитов',
			Points = {SPAWN_BAND},
			Price = 65,
		},
		{
			Name = 'Окрестности базы Монолита',
			Points = {SPAWN_MONOL},
			Price = 75,
		},
		{
			Name = 'База Чистое Небо',
			Points = {SPAWN_CH},
			Price = 95,
		},
		{
			Name = 'Бар Гавайца',
			Points = {SPAWN_GAVAEC},
			Price = 85,
		},
		{
			Name = 'Ферма',
			Points = {SPAWN_FERMA},
			Price = 85,
		},
		{
			Name = 'Деревня Новичков',
			Points = {SPAWN_DERNO},
			Price = 85,
		},
		{
			Name = 'Бар Еврея',
			Points = {SPAWN_JEWUSI},
			Price = 85,
		},
	}
}

rp.cfg.NoFreezeHalos = true

rp.cfg.DefaultSpawnPoints = {
	[SPAWN_KOLPACK] = true,
	[SPAWN_KROT] = true,
	[SPAWN_JEW] = true,
	[SPAWN_DYAK] = true,
}

rp.cfg.DefaultWeapons = {
	'weapon_physcannon',
	'weapon_physgun',
	'gmod_tool',
	'keys',
}

rp.cfg.Static = {
	rp_evonexus_city = {
		{
			mdl = 'models/props_lab/blastdoor001b.mdl',
			pos = Vector(-11218.671875, 11832.563477, 28.732141),
			ang = Angle(-89.998, -179.992, 180.000),
			mat = 'phoenix_storms/metalfence004a',
		},
		{
			mdl = 'models/props_c17/gate_door01a.mdl',
			pos = Vector(-9740.323242, 12600.328125, -743.648743),
			ang = Angle(0.000, 90.000, -0.000),
			mat = '',
		}
	}
}

rp.cfg.MaterialOverride = {
	rp_downtown_sup_b5c = {
		{'logos/sup', 'https://pp.vk.me/c625727/v625727756/104e5/K5FpATRXJxw.jpg'},
	//	{'logos/sup', 'http://skr.su/var/files/125027.jpg/uploaded-files/125027/1462495685.6679.252957962.jpg'}, -- 9 мая
	},
	rp_evonexus_city = {
		{'nexusrp/nexusmlgsign', 'https://pp.vk.me/c625727/v625727756/104e5/K5FpATRXJxw.jpg'},
	//	{'nexusrp/nexusmlgsign', 'http://skr.su/var/files/125027.jpg/uploaded-files/125027/1462495685.6679.252957962.jpg'}, -- 9 мая
	}
}

rp.cfg.CustomMapPoints = {
  ['rp_st_pripyat_urfim'] =
  {
    {
      icon = "stalker/icons/duty_logo.png",
      pos = Vector(3997, 5069, 0),
      iconDistance = 3000,
    },
    {
      icon = "stalker/icons/freedom_logo.png",
      pos = Vector(-11484, 3233, -2),
      iconDistance = 3000,
    },
    {
      icon = "stalker/icons/army_logo.png",
      pos = Vector(-2160, -6506, 0),
      iconDistance = 3000,
    },
    {
      icon = "stalker/icons/monolith_logo.png",
      pos = Vector(-2053, 11277, 128),
      iconDistance = 3000,
    },
    {
      icon = "stalker/icons/bandit_logo.png",
      pos = Vector(5804, -2922, 0),
      iconDistance = 3000,
    },
    {
      icon = "stalker/icons/info_logo.png",
      pos = Vector(757, -7592, 0),
      iconDistance = 500,
    },
    {
      icon = "stalker/icons/info_logo.png",
      pos = Vector(4637, -9092, -320),
      iconDistance = 500,
    },
    {
      icon = "stalker/icons/info_logo.png",
      pos = Vector(-2075, -12337, 8),
      iconDistance = 500,
    },
    {
      icon = "stalker/icons/clearsky_logo.png",
      pos = Vector(12403, 2546, -9),
      iconDistance = 3000,
    },
    {
      icon = "stalker/icons/renegats_logo.png",
      pos = Vector(-9588, 13736, 8),
      iconDistance = 3000,
    },
  }
}

-- Cop shops
rp.cfg.CopShops = {
	rp_stalker_urfim = {
	},
	rp_pripyat_urfim = {
	},
	rp_stalker_urfim_v3 = {
	},
	rp_st_pripyat_urfim = {
	},
    rp_limanskhospital_urfim = {},
}


-- Drug buyers
rp.cfg.DrugBuyers = {
	rp_stalker_urfim_v3 = {},
	rp_pripyat_urfim = {},
	rp_stalker_urfim = {},
	rp_st_pripyat_urfim = {},
    rp_limanskhospital_urfim = {},
}


-- Arcade
rp.cfg.Arcades = {
	rp_pripyat_urfim = {},
	rp_stalker_urfim = {},
	rp_stalker_urfim_v3 = {},
	rp_st_pripyat_urfim = {},
    rp_limanskhospital_urfim = {},
}



-- Spawn
rp.cfg.SpawnDisallow = {
	prop_physics		= true,
	media_radio 		= true,
	media_tv 			= true,
	ent_textscreen 		= true,
	ent_picture 		= true,
	gmod_rtcameraprop	= true,
	metal_detector		= true,
	flag 				= true,
}

rp.cfg.Spawns = {
	rp_stalker_urfim = {Vector(-3784, -14495, -533), Vector(329, -9925, 790)}
}



rp.cfg.TeamSpawns = rp.cfg.TeamSpawns or {
	rp_stalker_urfim_v3 = {
	},
	rp_pripyat_urfim = {
	},
	rp_stalker_urfim = {
	},
	rp_newstalker_urfim = {
	},
    rp_limanskhospital_urfim = {
    },
	rp_st_pripyat_urfim = {},
}




-- Jail
rp.cfg.WantedTime		= 180
rp.cfg.WarrantTime		= 180
rp.cfg.ArrestTimeMin 	= 30
rp.cfg.ArrestTimeMax 	= 200

rp.cfg.Jails = {
	rp_pripyat_urfim = {
		Vector(3711, -2185, -182),
		Vector(7161, 432, 5905),
	},
	rp_stalker_urfim_v3 = {},
	rp_stalker_urfim = {},
	rp_st_pripyat_urfim = {},
    rp_limanskhospital_urfim = {},
}


rp.cfg.JailPos = {
	rp_stalker_urfim_v3 = {},
	rp_pripyat_urfim = {},
	rp_stalker_urfim = {},
	rp_st_pripyat_urfim = {},
    rp_limanskhospital_urfim = {},
}


-- Theater
rp.cfg.Theaters = {
	rp_pripyat_urfim = {
	},
	rp_stalker_urfim = {},
	rp_stalker_urfim_v3 = {},
	rp_st_pripyat_urfim = {},
    rp_limanskhospital_urfim = {},
}

rp.cfg.MaxInvHeight = 8

rp.cfg.InventoryDefault = {5,5}
rp.cfg.TimeRespawnLoot = 120
rp.cfg.SpawnPositionLoot = {
	["rp_stalker_urfim"] = {
        --Деревня новичков + НИГ
        {model = "models/flaymi/anomaly/dynamics/box/box_wood_01_break.mdl", pos = Vector(2346.123535, -13098.190430, -127.750381), ang = Angle(0.000, -147.080, 0.000), maxCount = 3, type = "medium_loot"},
        {model = "models/flaymi/anomaly/dynamics/box/box_wood_01_break.mdl", pos = Vector(2338.403564, -13075.647461, -95.557930), ang = Angle(-0.000, 179.999, 0.000), maxCount = 3, type = "low_loot"},
        {model = "models/flaymi/anomaly/dynamics/box/box_wood_01_break.mdl", pos = Vector(2342.645996, -13053.277344, -127.750381), ang = Angle(0.000, 158.096, 0.000), maxCount = 3, type = "low_loot"},
        {model = "models/flaymi/anomaly/dynamics/box/box_1b.mdl", pos = Vector(-178.832962, -12725.440430, -215.723221), ang = Angle(0.000, 90.000, 0.000), maxCount = 3, type = "low_loot"},
        {model = "models/flaymi/anomaly/dynamics/box/box_1b.mdl", pos = Vector(-658.053162, -13240.200195, -215.606339), ang = Angle(-0.000, 90.000, 0.000), maxCount = 3, type = "low_loot"},
        {model = "models/flaymi/anomaly/dynamics/box/box_1b.mdl", pos = Vector(-336.916626, -13021.261719, -353.435364), ang = Angle(0.000, 46.063, 0.000), maxCount = 3, type = "low_loot"},
        {model = "models/flaymi/anomaly/dynamics/box/box_wood_01_break.mdl", pos = Vector(-327.509552, -12999.479492, -383.558502), ang = Angle(-0.003, -52.337, -0.002), maxCount = 3, type = "medium_loot"},
        {model = "models/flaymi/anomaly/dynamics/box/box_wood_01_break.mdl", pos = Vector(-356.984436, -13033.938477, -383.604187), ang = Angle(0.089, -25.499, -0.120), maxCount = 3, type = "low_loot"},
        {model = "models/flaymi/anomaly/dynamics/box/box_metall_01.mdl", pos = Vector(-60.772930, -13301.897461, 286.483459), ang = Angle(0.343, 118.107, 1.603), maxCount = 3, type = "super_loot"},
        {model = "models/flaymi/anomaly/objects/dynamics/box/box_wood_011.mdl", pos = Vector(-570.513916, -11344.982422, -352.643982), ang = Angle(-0.000, -45.000, -0.000), maxCount = 3, type = "low_loot"},
        {model = "models/flaymi/anomaly/objects/dynamics/box/box_wood_011.mdl", pos = Vector(-566.487976, -11345.759766, -383.997040), ang = Angle(-1.281, -44.428, 0.133), maxCount = 3, type = "medium_loot"},
        {model = "models/flaymi/anomaly/dynamics/devices/dev_merger.mdl", pos = Vector(-671.484985, -11024.329102, -230.300064), ang = Angle(1.863, 68.944, 2.958), maxCount = 3, type = "super_loot"},
        {model = "models/flaymi/anomaly/dynamics/equipments/quest/safe_container.mdl", pos = Vector(-1473.320435, -10917.920898, -371.081268), ang = Angle(-3.776, 132.841, 0.179), maxCount = 3, type = "low_loot"},
        {model = "models/flaymi/anomaly/dynamics/equipments/sumka7.mdl", pos = Vector(-3074.482178, -12311.731445, -383.506958), ang = Angle(0.460, -48.032, -6.940), maxCount = 3, type = "shron_loot"},
        {model = "models/flaymi/anomaly/dynamics/box/box_1c.mdl", pos = Vector(-1081.516235, -11131.097656, -353.230957), ang = Angle(0.000, -40.732, 0.000), maxCount = 3, type = "medium_loot"},
        {model = "models/flaymi/anomaly/dynamics/box/box_wood_01_break.mdl", pos = Vector(-1084.520264, -11134.768555, -383.887726), ang = Angle(-0.273, 52.332, -0.116), maxCount = 3, type = "low_loot"},
        {model = "models/flaymi/anomaly/dynamics/equipments/blue_box.mdl", pos = Vector(-983.056030, -10294.638672, -375.500275), ang = Angle(0.000, -179.720, 0.000), maxCount = 3, type = "medium_loot"},
        --ВОЕНКА
        {model = "models/flaymi/anomaly/dynamics/equipments/blue_box.mdl", pos = Vector(4424.294434, -9138.031250, -343.070648), ang = Angle(-1.005, -135.005, -1.377), maxCount = 3, type = "shron_loot"},
        {model = "models/flaymi/anomaly/dynamics/box/box_1a.mdl", pos = Vector(-6589.965332, -11859.531250, -474.622864), ang = Angle(6.777, 94.477, 2.768), maxCount = 3, type = "shron_loot"},
        {model = "models/flaymi/anomaly/dynamics/box/expl_dinamit.mdl", pos = Vector(-10838.737305, -9084.140625, -333.700775), ang = Angle(0.365, -143.517, 0.451), maxCount = 3, type = "shron_loot"},
        {model = "models/flaymi/anomaly/dynamics/box/box_metall_01.mdl", pos = Vector(-9895.916992, -10800.399414, -161.541351), ang = Angle(12.703, -0.422, -0.314), maxCount = 3, type = "shron_loot"},
        {model = "models/flaymi/anomaly/dynamics/equipments/blue_box.mdl", pos = Vector(-11421.456055, -13127.728516, -376.648895), ang = Angle(-0.229, 69.297, -0.105), maxCount = 3, type = "shron_loot"},
        {model = "models/flaymi/anomaly/dynamics/equipments/blue_box.mdl", pos = Vector(-11382.955078, -13136.145508, -376.675995), ang = Angle(-0.104, 115.916, 0.008), maxCount = 3, type = "shron_loot"},
        {model = "models/flaymi/anomaly/objects/dynamics/box/box_wood_011.mdl", pos = Vector(-11641.826172, -10471.575195, -383.661896), ang = Angle(0.000, -23.144, 0.000), maxCount = 3, type = "low_loot"},
        {model = "models/flaymi/anomaly/objects/dynamics/box/box_wood_011.mdl", pos = Vector(-11658.462891, -10479.173828, -352.311096), ang = Angle(0.000, -49.368, 0.000), maxCount = 3, type = "low_loot"},
        {model = "models/flaymi/anomaly/objects/dynamics/box/box_wood_011.mdl", pos = Vector(-11677.583984, -10488.201172, -383.661896), ang = Angle(0.000, -71.192, 0.000), maxCount = 3, type = "low_loot"},
        --МОНОЛИТ
        {model = "models/flaymi/anomaly/dynamics/equipments/green_box.mdl", pos = Vector(1126.447266, 3589.373779, 384.340973), ang = Angle(-0.000, -0.338, 0.001), maxCount = 3, type = "monolit_loot"},
        {model = "models/flaymi/anomaly/dynamics/equipments/green_box.mdl", pos = Vector(562.517578, 3777.538818, 607.353394), ang = Angle(0.052, 87.989, 0.014), maxCount = 3, type = "monolit_loot"},
        {model = "models/flaymi/anomaly/dynamics/equipments/green_box.mdl", pos = Vector(1715.647705, 2497.218262, 607.303040), ang = Angle(-0.092, 89.070, -0.109), maxCount = 3, type = "monolit_loot"},
        {model = "models/flaymi/anomaly/dynamics/equipments/blue_box.mdl", pos = Vector(363.564148, 2715.906738, 384.476746), ang = Angle(-0.008, 113.448, 0.096), maxCount = 3, type = "low_loot"},

    },
    ["rp_stalker_urfim_v3"] = {
	},
	["rp_st_pripyat_urfim"] = {
		{model = "models/z-o-m-b-i-e/st/shkaf/st_seif_03.mdl", pos = Vector(-1949.026855, -6824.154785, 160.327621), ang = Angle(0.020, -0.005, -0.085),  maxCount = 4, type = "army_loot"},
		{model = "models/z-o-m-b-i-e/st/shkaf/st_seif_03.mdl", pos = Vector(-1708.961426, -6824.058594, 160.456345), ang = Angle(-0.203, -0.001, 0.024),  maxCount = 4, type = "army_loot"},
		{model = "models/z-o-m-b-i-e/st/shkaf/st_seif_03.mdl", pos = Vector(-2575.823730, -6119.971680, 160.368134), ang = Angle(0.006, 179.904, -0.087),  maxCount = 4, type = "army_loot"},
		{model = "models/z-o-m-b-i-e/st/shkaf/st_seif_03.mdl", pos = Vector(-1990.977661, -6823.944336, 0.493824), ang = Angle(-0.000, -0.000, -0.023),  maxCount = 4, type = "army_loot"},
		{model = "models/z-o-m-b-i-e/st/shkaf/st_seif_02.mdl", pos = Vector(-2705.053711, 11307.616211, 320.453369), ang = Angle(0.000, 90.003, 0.000),  maxCount = 4, type = "monolit_loot"},
		{model = "models/z-o-m-b-i-e/st/shkaf/st_seif_02.mdl", pos = Vector(-1763.796753, 11626.721680, 143.983292), ang = Angle(-0.019, 55.822, 89.986),  maxCount = 4, type = "monolit_loot"},
		{model = "models/z-o-m-b-i-e/st/shkaf/st_seif_02.mdl", pos = Vector(-1132.072754, 11069.340820, 464.041962), ang = Angle(-0.000, 117.707, 89.986),  maxCount = 4, type = "monolit_loot"},
		{model = "models/hgn/srp/items/backpack-2.mdl", pos = Vector(-770.557434, 8768.329102, 56.736950), ang = Angle(-0.517, 57.988, -0.257), maxCount = 4, type = "shron_loot"},
		{model = "models/hgn/srp/items/backpack-2.mdl", pos = Vector(601.255737, 5961.195312, 57.997768), ang = Angle(-0.030, 14.890, -0.268), maxCount = 4, type = "shron_loot"},
		{model = "models/hgn/srp/items/backpack-2.mdl", pos = Vector(876.926025, -160.798752, 12.072494), ang = Angle(68.901, -1.650, 1.834), maxCount = 4, type = "shron_loot"},
		{model = "models/hgn/srp/items/backpack-2.mdl", pos = Vector(1567.270264, -1476.910278, 520.462341), ang = Angle(-0.047, 121.022, -0.087), maxCount = 4, type = "shron_loot"},
		{model = "models/hgn/srp/items/backpack-2.mdl", pos = Vector(2101.789062, -4443.556641, 756.487915), ang = Angle(-0.000, -143.237, 0.133), maxCount = 4, type = "shron_loot"},
		{model = "models/hgn/srp/items/backpack-2.mdl", pos = Vector(-1768.327148, -8386.758789, 55.9820635), ang = Angle(-0.002, -129.535, 0.166), maxCount = 4, type = "shron_loot"},
		{model = "models/hgn/srp/items/backpack-2.mdl", pos = Vector(-1738.955688, 3095.895752, 4.584859), ang = Angle(-0.046, 43.969, -0.154), maxCount = 4, type = "shron_loot"},
		{model = "models/hgn/srp/items/backpack-2.mdl", pos = Vector(6012.212891, -4702.367676, 24.547447), ang = Angle(-0.070, 120.703, -0.173), maxCount = 4, type = "shron_loot"},
		{model = "models/hgn/srp/items/backpack-2.mdl", pos = Vector(3883.801270, -8571.399414, 8.463785), ang = Angle(-0.060, -74.082, 0.145), maxCount = 4, type = "shron_loot"},
		{model = "models/hgn/srp/items/backpack-2.mdl", pos = Vector(9143.768555, -7835.267090, -4.485019), ang = Angle(-0.283, -160.293, -1.139), maxCount = 4, type = "shron_loot"},
		{model = "models/hgn/srp/items/backpack-2.mdl", pos = Vector(9436.635742, -11889.045898, 36.638088), ang = Angle(-0.094, 133.047, 0.035), maxCount = 4, type = "shron_loot"},
		{model = "models/hgn/srp/items/backpack-2.mdl", pos = Vector(-3382.666504, -7039.953613, 0.542829), ang = Angle(-0.036, 128.817, -0.938), maxCount = 4, type = "shron_loot"},
	},
}
rp.cfg.PropDynamicLootModels = {
	["rp_stalker_urfim"] = {
	},
	["rp_pripyat_urfim"] = {
	},
	["rp_stalker_urfim_v3"] = {
		["models/z-o-m-b-i-e/st/box/st_box_wood_01.mdl"] = {maxCount = 2, type = "low_loot"},
		["models/z-o-m-b-i-e/st/equipment_cache/st_equipment_instrument_01.mdl"] = {maxCount = 2, type = "low_loot"},
		["models/z-o-m-b-i-e/st/box/st_box_metall_01.mdl"] = {maxCount = 2, type = "low_loot"},
		["models/z-o-m-b-i-e/st/equipment_cache/st_equipment_box_01.mdl"] = {maxCount = 2, type = "low_loot"},
		["models/z-o-m-b-i-e/st/equipment_cache/st_equipment_box_02.mdl"] = {maxCount = 4, type = "medium_loot"},
		["models/z-o-m-b-i-e/st/box/st_box_01.mdl"] = {maxCount = 4, type = "medium_loot"},
		["models/z-o-m-b-i-e/st/equipment_cache/st_equipment_seif_04.mdl"] = {maxCount = 4, type = "medium_loot"},
		["models/z-o-m-b-i-e/st/box/st_expl_dinamit_01.mdl"] = {maxCount = 4, type = "medium_loot"},
		["models/z-o-m-b-i-e/st/shkaf/st_seif_02.mdl"] = {maxCount = 4, type = "super_loot"},
		["models/z-o-m-b-i-e/st/shkaf/st_seif_03.mdl"] = {maxCount = 4, type = "super_loot"},
		["models/z-o-m-b-i-e/metro_2033/props/m_33_wood_box_01.mdl"] = {maxCount = 4, type = "super_loot"},
	},
	["rp_st_pripyat_urfim"] = {
		["models/z-o-m-b-i-e/st/box/st_box_wood_01.mdl"] = {maxCount = 2, type = "low_loot"},
		["models/z-o-m-b-i-e/st/trash_box/st_trash_box_05.md"] = {maxCount = 2, type = "low_loot"},
		["models/z-o-m-b-i-e/st/equipment_cache/st_equipment_box_02.mdl"] = {maxCount = 2, type = "medium_loot"},
		["models/z-o-m-b-i-e/st/shkaf/st_seif_03.mdl"] = {maxCount = 2, type = "medium_loot"},
		["models/z-o-m-b-i-e/st/shkaf/st_seif_02.mdl"] = {maxCount = 2, type = "super_loot"},
	},
}

rp.cfg.InitialAttributePoints = 1


--[[-- Бэкграунды для Джобслиста: ------------------------------
	[<название фракции>] = Material( <путь до материала> );
		где	<название фракции> - rp.Factions[<нужная нам фракция>].name

	Пример:
		["police"] = "rpui/backgrounds/darkrp/police",
------------------------------------------------------------]]--
rp.cfg.JobsListBackgrounds = {
	["default"] = "rpui/backgrounds/blank/orange",
	["staff"]   = "rpui/backgrounds/blank/navy",

	["citizens"]   = "rpui/backgrounds/stalker/citizens",
	["ms"]         = "rpui/backgrounds/stalker/ms",
	["svoboda"]    = "rpui/backgrounds/stalker/svoboda",
	["svobvip"]    = "rpui/backgrounds/stalker/svoboda",
	["dolg"]       = "rpui/backgrounds/stalker/dolg",
	["dolgvip"]    = "rpui/backgrounds/stalker/dolg",
	["monolith"]   = "rpui/backgrounds/stalker/monolith",
	["military"]   = "rpui/backgrounds/stalker/military",
	["MT"]		   = "rpui/backgrounds/stalker/military",
	["zombie"]     = "rpui/backgrounds/stalker/zombie",
	["mutants"]    = "rpui/backgrounds/stalker/mutants",
	["hitmansolo"] = "rpui/backgrounds/stalker/hitmansolo",
	["nebo"]       = "rpui/backgrounds/stalker/nebo",
	["ecolog"]     = "rpui/backgrounds/stalker/ecolog",
	["topol"]     = "rpui/backgrounds/stalker/ecolog",
	["barman"] = 	"rpui/backgrounds/stalker/citizens",
	["netral"] = 	"rpui/backgrounds/stalker/citizens",
    ["eventmonolith"] =    "rpui/backgrounds/stalker/monolith",
    ["eventnebo"] =    "rpui/backgrounds/stalker/nebo",

	--["concord"] = "rpui/backgrounds/stalker/concord",
	--["gydra"] = "rpui/backgrounds/stalker/gydra",
	--["fantom"] = "rpui/backgrounds/stalker/fantom",
	["bandity"] = "rpui/backgrounds/stalker/bandit",
	--["orden"] = "rpui/backgrounds/stalker/orden",
	--["renegades"] = "rpui/backgrounds/stalker/renegades",
	--["sunshine"] = "rpui/backgrounds/stalker/sunshine",
	--["greh"] = "rpui/backgrounds/stalker/greh",
	--["berserk"] = "rpui/backgrounds/stalker/berserk",
	--["vozmezdie"] = "rpui/backgrounds/stalker/vozmezdie",
	--["un contingent"] = "rpui/backgrounds/stalker/un_contingent",
	--["kochevniki"] = "rpui/backgrounds/stalker/kochevniki",
	--["lost partisans"] = "rpui/backgrounds/stalker/lost_partisans",
	--["dark angels"] = "rpui/backgrounds/stalker/dark_angels",
	--["dark brothers"] = "rpui/backgrounds/stalker/dark_brothers",
	--["$black market$"] = "rpui/backgrounds/stalker/black_market",
	--["wind"] = "rpui/backgrounds/stalker/wind",
	--["mst"] = "rpui/backgrounds/stalker/mst",
	--["division of death"] = "rpui/backgrounds/stalker/division_of_death",
	--["infernal inquisition"] = "rpui/backgrounds/stalker/infernal_inquisition",
	--["united security"] = "rpui/backgrounds/stalker/united_security",
	--["bounty hunters"] = "rpui/backgrounds/stalker/bounty_hunters",
	--["nemesis"] = "rpui/backgrounds/stalker/nemesis",
	--["poisk"] = "rpui/backgrounds/stalker/poisk",
	--["gis"] = "rpui/backgrounds/stalker/gis",
};


--[[-- Кастомные иконки для свойств работы: --------------------
	Если необходимо добавить/изменить иконку для свойства,
	которая расписана в таблице работы. (должна быть либо
	булевым типом, либо числом)

	Существующие иконки:
		armor, admin, candisguise, canCapture,
		canOrgCapture, cook, hasLicense, hirable, hitman,
		mayor, medic, canDiplomacy, hpRegen, police

	Пример:
		["armor"] = Material( "rpui/icons/armor" );

	Иконка обязательно должна быть ".vtf" формата,
		Normal/Alpha Format: RGBA8888
		Resize:
			Resize Method  - Nearest Power Of 2,
			Resize Filter  - Point,
			Sharpen Filter - None
		Mipmaps'ы отключены

	если трудно - звоните ббк
------------------------------------------------------------]]--
rp.cfg.JobsListStatsIcons = {
	["capCapture"] = false,
};


--[[-- Кастомный текст подсказки для иконки: -------------------
	Если необходимо добавить/изменить подсказку для существующей
	иконки.

	Пример:
		["armor"] = "Броня"
------------------------------------------------------------]]--
rp.cfg.JobsListStatsTooltips = {};


--[[-- Кастомная иконка, которая зависит от значения: ----------
	[<название параметра>] = {
		ScalingFactor = <число> <необзяталельный параметр, по умолчанию: 1>
			- Отвечает за размер иконки, должна возвращать <number>
		Check = <функция, td - таблица команды>
			- Функция проверки,
			  должна возвращать <boolean>
		GetMaterial = <функция, td - таблица команды>
			- Функция возврата иконки,
			  должна возвращать <Material>
		GetTooltip = <функция, td - таблица команды>
			- Функция возврата текста,
			  должна возвращать <string>
	}

	Пример:
		["speed"] = {
			Check = function( td )
				return td.speed and true or false;
			end,
			GetMaterial = function( td )
				return Material( "rpui/icons/speed" );
			end,
			GetTooltip = function( td )
				return ((td.speed >= 1) and "Увеличенная" or "Уменьшенная") .. " скорость передвижения";
			end,
		}

	Более наглядные примеры есть в
		"rp_base/gamemode/core/menus/f4menu/controls/rpui_jobslist_cl.lua" @ PANEL.CustomStats
------------------------------------------------------------]]--
rp.cfg.JobsListCustomStats = {};

-- AirDrop
rp.cfg.AirDropSpawn = {
	rp_stalker_urfim = {
		{name = "Военная амуниция", pos = Vector(-4214, 6381, 128)},
		{name = "Военная амуниция", pos = Vector(8091, 4451, -591)},
		{name = "Военная амуниция", pos = Vector(9227, -9750, -384)},
		{name = "Военная амуниция", pos = Vector(-1361, 1477, 355)},
        {name = "Военная амуниция", pos = Vector(5383, 9088, 176)},
        {name = "Военная амуниция", pos = Vector(7973, 3009, -575)},
        {name = "Военная амуниция", pos = Vector(12583, -13203, -369)},
	},
}
rp.cfg.AirDropDelay = 1200
rp.cfg.AirDropTimeOpen = 20
rp.cfg.AirDropDelete = 300
rp.cfg.AirDropLoot = {type = "airdrop_loot", min = 5, max = 15}



-- Automated announcements
rp.cfg.AnnouncementDelay = 300
rp.cfg.Announcements = {
	'Радио слишком громкое? Лагает из-за дыма? Все эти проблемы и многое другое можно решить в настройках (F4->Настройки).',
	'Кто-то ДМит? Блочит? Летает на пропах? Напиши @ <текст обращения> в чат, чтобы вызвать администратора.',
	'Есть какие-то вопросы? Наша команда администраторов с радостью тебе поможет! Напиши @ <текст обращения> в чат, чтобы вызвать администратора.',
	'Ознакомиться с правилами, подписаться на наши группы ВК и Steam, а также скачать контент сервера можно нажав F1.',
	'Подпишись на наш контент сервера, чтобы ускорить время загрузки (F1->Контент).',
	'Ждём Вас в нашем Discord сервере, введи в браузере www.urf.im/discord/ чтобы подключиться.',
	'Если Вы устали можно присесть нажав ALT и E или введя /sit в чат.',
	'Уважаемые игроки, у нас 2 сервера по тематике STALKER RP - Настоящая Зона и Сердце Зоны. ',
}



rp.cfg.EnableFactionGroupsUI = true;
rp.cfg.MinLotto = 500
rp.cfg.MaxLotto = 50000

rp.cfg.OrgBannerUrl = 'http://api.urf.im/handler/orgs_banner.php?sv=' .. rp.cfg.ServerUID
rp.cfg.whitelistHandler = 'http://api.urf.im/handler/props_whitelist.php?sv=' .. rp.cfg.ServerUID

rp.cfg.StreamBanners = { -- пресеты баннеров для `ba streambanner Player PresetID`
	[1] = {
		delay = 30, -- раз в сколько секунд будет меняться текст?
		phrases = { -- фразы сменяющие друг-друга раз в delay секунд
			"Ссылка на подключение в описании",
			"промокод в описании видео",
			"garry's mod — значит urf.im"
		},
		textcolor = Color(255, 255, 255), -- цвет текста
		decor_color = Color(67, 255, 1, 255 * 0.65), -- цвет декорации/тени
		textshadow = true, -- включить тень?
		logo_shadow = true, -- включить тень под логотипом?
		italic_text = true, -- наклонный шрифт?
		textshadow_distance = 4, -- дистация тени текста
		text_decoration = "gradient", -- декорация текста (фон под текстом). false = отключить, animeborder = анимированная обводка как кнопка ДОНАТ в F4, blurshadow = guassian blur тень по центру текста, gradient = говорит само за себя, градиент из центра
		scale = 0.4, -- изменение размера баннера. 0.5 = половина размера, 1 = полный размер
		margin = 10 -- отступ баннера от краёв экрана
	},
	[2] = {
		delay = 30,
		phrases = {
			"Ссылка на подключение в описании",
			"промокод в описании видео",
			"garry's mod — значит urf.im"
		},
		textcolor = Color(255, 255, 255),
		decor_color = Color(67, 255, 1, 255 * 0.65),
		textshadow = true,
		logo_shadow = true,
		italic_text = true,
		textshadow_distance = 4,
		text_decoration = "blurshadow",
		scale = 0.4,
		margin = 10
	},
	[3] = {
		delay = 30,
		phrases = {
			"Ссылка на подключение в описании",
			"промокод в описании видео",
			"garry's mod — значит urf.im"
		},
		textcolor = Color(255, 255, 255),
		decor_color = Color(204, 0, 0, 255 * 0.75),
		textshadow = true,
		logo_shadow = true,
		italic_text = true,
		textshadow_distance = 4,
		text_decoration = "blurshadow",
		scale = 0.4,
		margin = 10
	},
	[4] = {
		delay = 30,
		phrases = {
			"Ссылка на подключение в описании",
			"промокод в описании видео",
			"garry's mod — значит urf.im"
		},
		textcolor = Color(255, 255, 255),
		decor_color = Color(255, 185, 0),
		textshadow = true,
		logo_shadow = true,
		italic_text = true,
		textshadow_distance = 4,
		text_decoration = "animeborder",
		scale = 0.4,
		margin = 10
	},
	[5] = {
		delay = 30,
		phrases = {
			"Ссылка на подключение в описании",
			"промокод в описании видео",
			"garry's mod — значит urf.im"
		},
		textcolor = Color(255, 255, 255),
		decor_color = Color(67, 255, 1, 255 * 0.65),
		textshadow = true,
		logo_shadow = true,
		italic_text = true,
		textshadow_distance = 4,
		text_decoration = "animeborder",
		scale = 0.4,
		margin = 10
	},
	[6] = {
		delay = 30,
		phrases = {
			{
				text 			= "Промокод на КЕЙС в описании видео!",
				text_decoration = "animeborder",
				decor_color     = Color(67, 255, 1, 255 * 0.65)
			},
			{
				text 			= "Подключись сейчас! Ссылка в описании.",
				text_decoration = "blurshadow",
				decor_color     = Color(204, 0, 0, 255 * 0.75)
			},
			{
				text 			= "garry's mod — значит urf.im",
				text_decoration = "animeborder",
				decor_color     = Color(255, 185, 0)
			},
		},
		textcolor = Color(255, 255, 255),
		decor_color = Color(67, 255, 1, 255 * 0.65),
		textshadow = true,
		logo_shadow = true,
		italic_text = true,
		textshadow_distance = 4,
		text_decoration = "gradient",
		scale = 0.4,
		margin = 10
	},
}
/*
rp.cfg.ZombieEvent = {
    FirstZombie = "TEAM_BZV", -- Главный заражала
    Zombies = { -- Зараженные
        ['TEAM_ZV_1'] = true,
        ['TEAM_ZV_2'] = true,
        ['TEAM_ZV_3'] = true,
        ['TEAM_ZV_4'] = true,
    },
    ZombiesMap = { 'TEAM_ZV_1', 'TEAM_ZV_2', 'TEAM_ZV_3', 'TEAM_ZV_4' },
    KillReward = 150, -- Награда за убийство зараженного
    InfectReward = 75, -- Награда за заражение
    Duration = 600, -- Время ивента
    Cooldown = 10800, -- КД на следующий ивент
    SoundStart = "minion/minion-start.mp3", -- Начало ивента
    SoundEnd = "minion/minion-konec.mp3", -- Конец ивента
    HUDIcon = "zombie_ivent_logo.png", -- Иконка в худе
    Fog = { -- Настройки Тумана
        fog_start = 500,
        fog_end = 2000,
        fog_density = 1,
        fog_color = {255,0,0},
    },
    Shake = {
        amplitude = 5,
        frequency = 5,
        duration = 5,
    },
    EndFactionsIgnore = { -- Фракции которые не заразить
        ['FACTION_ADMINS'] = true,
        ['FACTION_ZOMBIE1'] = true,
        ['FACTION_ZOMBIE'] = true,
        ['FACTION_MUTANTS'] = true,
        ['FACTION_MONOLITH'] = true,
    },
};
*/
hook.Run("CfgLuaLoaded")


rp.cfg.CaptureMinAttackers = 1;

rp.cfg.Arena = {
  interval = 1200, -- Временной интервал между последним сражением и опросом на новое сражение (секунды)
  job = function() return TEAM_ARENA end, -- Профессия, на которую устанавливаются участники
  min_players = 2, -- Минимальное кол-во участников для начала сражения
  max_players = 8, -- Максимальное кол-во участников сражения
  winners_count = 1, -- Количество оставшихся игроков, считающихся победителями

  MoneyMin = 300,
  MoneyMax = 1000,
  MoneyPerPlayer = 100,

  weapon_spawns = { -- Спавнеры оружия на арене
    rp_stalker_urfim = {
	{
	pos = Vector(-1484, -11136, -1944),
	weapon = 'tfa_anomaly_colt1911',
	respawn = 55,
	},
	{
	pos = Vector(-2699, -10902, -1918),
	weapon = 'tfa_anomaly_colt1911',
	respawn = 55,
	},
	{
	pos = Vector(-3105, -11003, -1944),
	weapon = 'tfa_anomaly_usp_nimble',
	respawn = 45,
	},
	{
	pos = Vector(-1793, -11230, -1854),
	weapon = 'tfa_anomaly_usp_nimble',
	respawn = 45,
	},
	{
	pos = Vector(-1960, -10754, -1887),
	weapon = 'tfa_anomaly_kiparis',
	respawn = 30,
	},
	{
	pos = Vector(-2781, -11002, -1804),
	weapon = 'tfa_anomaly_kiparis',
	respawn = 30,
	},
	{
	pos = Vector(-3340, -11199, -1944),
	weapon = 'tfa_anomaly_kiparis',
	respawn = 30,
	},
	{
	pos = Vector(-1755, -10852, -1937),
	weapon = 'tfa_anomaly_pp2000',
	respawn = 20,
	},
	{
	pos = Vector(-2459, -11223, -1944),
	weapon = 'tfa_anomaly_pp2000',
	respawn = 20,
	},
	{
	pos = Vector(-1769, -10784, -1944),
	weapon = 'tfa_anomaly_pp2000',
	respawn = 30,
	},
	{
	pos = Vector(-1466, -11198, -1773),
	weapon = 'tfa_anomaly_pp2000',
	respawn = 30,
	},
	{
	pos = Vector(-2874, -10592, -1766),
	weapon = 'tfa_anomaly_aks',
	respawn = 55,
	},
	{
	pos = Vector(-3400, -11225, -1798),
	weapon = 'tfa_anomaly_aks',
	respawn = 55,
	},
    },
  },
}



