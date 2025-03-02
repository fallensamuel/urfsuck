-- "gamemodes\\rp_base\\gamemode\\addons\\mood\\sh_mood.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.Mood = rp.Mood or {};

nw.Register("rp.mood"):Write(net.WriteUInt,4):Read(net.ReadUInt,4):SetLocalPlayer();

PLAYER_MOOD_NORMAL  = 0;
PLAYER_MOOD_GLOOMY  = 1;
PLAYER_MOOD_SERIOUS = 2;
PLAYER_MOOD_GOPNIK  = 3;
PLAYER_MOOD_PACE    = 4;
PLAYER_MOOD_HERO    = 5;
PLAYER_MOOD_HANDPAH = 6;
PLAYER_MOOD_SECURITY = 7;
PLAYER_MOOD_MERKEL = 8;

rp.Mood.HoldTypes = {
    [PLAYER_MOOD_NORMAL]  = { "mood-normal",  translates and translates.Get( "Нормальное" ) or "Нормальное" },
    [PLAYER_MOOD_GOPNIK]  = { "mood-gopnik",  translates and translates.Get( "Гопник" ) or "Гопник" },
    [PLAYER_MOOD_SERIOUS] = { "mood-serious", translates and translates.Get( "Серьёзное" ) or "Серьёзное" },
    [PLAYER_MOOD_GLOOMY]  = { "mood-gloomy",  translates and translates.Get( "Мудак" ) or "Мудак" },
    [PLAYER_MOOD_PACE]  = { "mood-pace",  translates and translates.Get( "Злой" ) or "Злой" },
    [PLAYER_MOOD_HERO]  = { "mood-hero",  translates and translates.Get( "Герой" ) or "Герой" },
    [PLAYER_MOOD_HANDPAH]  = { "mood-pah",  translates and translates.Get( "Напряжённый" ) or "Напряжённый" },
    [PLAYER_MOOD_SECURITY]  = { "mood-security",  translates and translates.Get( "Важный" ) or "Важный" },
    [PLAYER_MOOD_MERKEL]  = { "mood-merkel",  translates and translates.Get( "Задумчивый" ) or "Задумчивый" },
}

--[[
    [ACT_MP_STAND_IDLE]
    [ACT_MP_WALK]
    [ACT_MP_RUN]
    [ACT_MP_CROUCH_IDLE]
    [ACT_MP_CROUCHWALK]
    [ACT_MP_ATTACK_STAND_PRIMARYFIRE]
    [ACT_MP_ATTACK_CROUCH_PRIMARYFIRE]
    [ACT_MP_RELOAD_STAND]
    [ACT_MP_RELOAD_CROUCH]
    [ACT_MP_JUMP]
    [ACT_RANGE_ATTACK1]
    [ACT_MP_SWIM]
]]--

--[[------------------------------------------------
    Mood: Normal
------------------------------------------------]]--
local DATA = {
    Name         = "mood-normal",
    HoldType     = "mood-normal",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_JUMP] = "jump_slam",
    }
}
wOS.AnimExtension:RegisterHoldtype( DATA );

--[[------------------------------------------------
    Mood: Gloomy
------------------------------------------------]]--
local DATA = {
    Name         = "mood-gloomy",
    HoldType     = "mood-gloomy",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE]  = "pose_standing_01",
        [ACT_MP_CROUCH_IDLE] = "pose_ducking_02",
        [ACT_MP_JUMP]        = "jump_slam",
    }
}
wOS.AnimExtension:RegisterHoldtype( DATA );

--[[------------------------------------------------
    Mood: Serious
------------------------------------------------]]--
local DATA = {
    Name         = "mood-serious",
    HoldType     = "mood-serious",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE]  = "d1_t01_breakroom_watchbreen",
        [ACT_MP_JUMP]        = "jump_slam",
        [ACT_MP_WALK]        = "walk_d1_t01_breakroom_watchbreen",
    }
}
wOS.AnimExtension:RegisterHoldtype( DATA );

--[[------------------------------------------------
    Mood: Gopnik
------------------------------------------------]]--
local DATA = {
    Name         = "mood-gopnik",
    HoldType     = "mood-gopnik",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE]  = "d1_t02_playground_cit2_pockets",
        [ACT_MP_CROUCH_IDLE] = "plazaidle4",
        [ACT_MP_JUMP]        = "jump_slam",
        [ACT_MP_WALK]        = "walk_d1_t02_playground_cit2_pockets",
    }
}
wOS.AnimExtension:RegisterHoldtype( DATA );

--[[------------------------------------------------
    Mood: Pace
------------------------------------------------]]--
local DATA = {
    Name         = "mood-pace",
    HoldType     = "mood-pace",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE] = "idle_all_angry",
        [ACT_MP_CROUCH_IDLE] = "plazaidle4",
        [ACT_MP_JUMP]       = "jump_slam",
    }
}
wOS.AnimExtension:RegisterHoldtype( DATA );

--[[------------------------------------------------
    Mood: Hero
------------------------------------------------]]--
local DATA = {
    Name         = "mood-hero",
    HoldType     = "mood-hero",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE] = "pose_standing_02",
        [ACT_MP_CROUCH_IDLE] = "pose_ducking_01",
        [ACT_MP_JUMP]       = "jump_slam",
        [ACT_MP_WALK]        = "walk_pose_standing_02",
    }
}
wOS.AnimExtension:RegisterHoldtype( DATA );

--[[------------------------------------------------
    Mood: Pah
------------------------------------------------]]--
local DATA = {
    Name         = "mood-pah",
    HoldType     = "mood-pah",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE]  = "ruka_dick",
        [ACT_MP_JUMP] = "jump_slam",
        [ACT_MP_WALK]        = "walk_ruka_dick",
    }
}
wOS.AnimExtension:RegisterHoldtype( DATA );

--[[------------------------------------------------
    Mood: Security
------------------------------------------------]]--
local DATA = {
    Name         = "mood-security",
    HoldType     = "mood-security",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE]  = "idle_security",
        [ACT_MP_JUMP] = "jump_slam",
        [ACT_MP_WALK]        = "walk_security",
    }
}
wOS.AnimExtension:RegisterHoldtype( DATA );

--[[------------------------------------------------
    Mood: Merkel
------------------------------------------------]]--
local DATA = {
    Name         = "mood-merkel",
    HoldType     = "mood-merkel",
    BaseHoldType = "normal",
    Translations = {
        [ACT_MP_STAND_IDLE]  = "idle_merkel",
        [ACT_MP_JUMP] = "jump_slam",
        [ACT_MP_WALK]        = "walk_merkel",
    }
}
wOS.AnimExtension:RegisterHoldtype( DATA );

if rp.cfg.CustomMoods then
	for k, v in pairs(rp.cfg.CustomMoods) do
		local id = table.insert(rp.Mood.HoldTypes, {
			v.id, v.name
		})
		
		local DATA = {
			Name         = v.id,
			HoldType     = v.id,
			BaseHoldType = v.base or "normal",
			Translations = {
				[ACT_MP_STAND_IDLE] = v.sequence,
				[ACT_MP_JUMP]       = "jump_slam",
			}
		}
		wOS.AnimExtension:RegisterHoldtype( DATA );
	end
end

hook.Add( "PlayerSwitchWeapon", "hook.rp-mood.PlayerSwitchWeapon", function( ply, oldWep, newWep )
    if not (ply.IsProne and ply:IsProne()) and (newWep:GetClass() == "keys") then
        newWep:SetHoldType( rp.Mood.HoldTypes[ply:GetNetVar("rp.mood") or PLAYER_MOOD_NORMAL][1] );
    end
end );