-- "gamemodes\\darkrp\\gamemode\\config\\jobs\\mutants.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
/*local empty = {}
local  mutant_spawns = {
rp_pripyat_urfim = {Vector(-2567, 2819, -192), Vector(9852, 9494, 0), Vector(6721, 6052, 17), Vector(-609, -1044, 0)},
rp_stalker_urfim_v3 = {Vector(-4928, 1367, -3840), Vector(3395, -845, -4264), Vector(584, 8312, -4094), Vector(-11772, -9618, -4992)},
rp_stalker_urfim = {Vector(755, 9521, -350)},
rp_st_pripyat_urfim = {Vector(3701, -50, -7), Vector(729, 6727, -8)},
}

local  kontrol_spawns = {
rp_pripyat_urfim = {Vector(-2567, 2819, -192), Vector(-3719, 3461, -192), Vector(-3598, 3122, -192), Vector(-5123, -4377, -512), Vector(6276, 13741, 29)},
rp_stalker_urfim_v3 = {Vector(-5808, -683, -4480), Vector(977, -13503, -4088), Vector(-1032, 3178, -3837)},
rp_stalker_urfim = {Vector(4151, -12079, -80)},
rp_st_pripyat_urfim = {Vector(-1902, 11297, 128)},
}

local playerDeathHook = function(ply, killer, item)
    if IsValid(killer) and killer:IsPlayer() and killer:GetFaction() == FACTION_CITIZEN then
        --killer:AddMoney(rp.cfg.MutantKillReward or 50)
        --rp.Notify(killer, NOTIFY_GENERIC, rp.Term('MutantKilled'), rp.FormatMoney(rp.cfg.MutantKillReward or 50))

        local inv = killer:getInv()

        if inv then
            local itemShop = rp.item.list[item]
            local countItem = inv:getItemCount(item)

            if itemShop.maxStack and itemShop.maxStack ~= 0 and itemShop.maxStack <= countItem then
                return
            end

            killer:getInv():add(item, 1, nil, nil, nil, nil, nil, function(failed)
                if not failed then
                    rp.Notify(killer, NOTIFY_GREEN, rp.Term('MutantKilled'), rp.item.list[item].name or 'item')
                end
            end)
        end
    end
end

TEAM_DOG2 = rp.addTeam("Слепой пёс", {
    color = Color(178, 34, 34),
    model = {"models/stalkertnb/dog1.mdl", "models/stalkertnb/dog2.mdl"},
    description = [[ Cамый привычный представитель фауны Зоны. В прошлом обычная дворовая шавка, лишившаяся зрения, но обладающая развитым обонянием. Как правило, доставить проблемы Сталкерам эти псы способны только собравшись в стаю.]],
    weapons = {'weapon_dogswep'},
    deathSound = Sound('hgn/stalker/creature/dog/bdog_die_3.wav'),
    command = 'dog2',
    build = false,
    salary = 25,
    admin = 0,
    candemote = false,
    CantUseDisguise = true,
    reversed = true,
    disableDisguise = true,
    spawns = mutant_spawns,
    monster = true,
    eatHp = 20,
    hpRegen = 5,
    stamina = 75,
    unlockTime = 10*3600,
    unlockPrice = 60000,
    faction = FACTION_MUTANTS,
    PlayerDeath = function(ply, _, killer)
        if math.random(0, 100) > 50 then
            playerDeathHook(ply, killer, 'rpitem_mutant_sobaka')
        end
    end
})

rp.addTeam("Тушканчик", {
    color = Color(178, 34, 34),
    model = "models/monsters/tushkan.mdl",
    description = [[ Маленькое крысоподобное существо, безумно быстрое и юркое, еще более опасно когда перемещается большими стаями. Благодаря своим размерам может пролезть в труднодоступные места, да и попасть в него из оружия зачастую очень не просто.]],
    salary = 5,
    spawn_points = empty,
    --stamina = 150,
    hpRegen = 5,
    command = "tushcan",
    build = false,
    CantUseDisguise = true,
    reversed = true,
    disableDisguise = true,
    spawn_points = {},
    footstepSound = Sound('wick/snork/earth02gr.wav'),
    weapons = {"weapon_tushkan"},
    armor = 100,
    monster = true,
    eatHp = 20,
    spawns = mutant_spawns,
    faction = FACTION_MUTANTS,
    unlockTime = 75*3600,
    unlockPrice = 10000,
    max = 5,
    --vip = true,
    PlayerDeath = function(ply, _, killer)
        if math.random(0, 100) > 50 then
            playerDeathHook(ply, killer, 'rpitem_mutant_tushkan')
        end
    end
})


rp.addTeam("НедоСнорк", {
    color = Color(178, 34, 34),
    model = "models/stalkertnb/bandit6.mdl",
    description = [[ Именно ты после аварии на АЭС стал снорком.
    Все другие снорки над тобой издеваются за твой внешний вид.
]],
    salary = 6,
    spawn_points = empty,
    punchMin = 50,
    punchMax = 80,
    critMin = 50,
    critMax = 100,
    stamina = 300,
    hpRegen = 5,
    command = "nedosnork",
    build = false,
    spawn_points = {},
    weapons = {"weapon_zombie_fists"},
    PlayerSpawn = function(ply) ply:SetWalkSpeed(80) ply:SetRunSpeed(400) end,
    armor = 300,
    monster = true,
    eatHp = 20,
    spawns = mutant_spawns,
    faction = FACTION_MUTANTS,
    unlockTime = 150*3600,
    unlockPrice = 300000,
    PlayerDeath = function(ply, _, killer)
        if math.random(0, 100) > 50 then
            playerDeathHook(ply, killer, 'rpitem_mutant_zombi')
        end
    end
})


rp.addTeam("Снорк", {
    color = Color(178, 34, 34),
    --model = "models/wick/snork/wick_snork.mdl",
    model = "models/wick/snork/wick_snork.mdl",
    description = [[ Таинственным образом мутировавший человек, перемещается на 4 конечностях и способен совершать прыжки на невероятные дистанции, в отличии от печально известных НедоСнорков. Как ни странно, всегда встречается в противогазе на половину головы.]],
    salary = 10,
    stamina = 5,
    --hpRegen = 15,
    command = "snork",
    build = false,
    CantUseDisguise = true,
    reversed = true,
    disableDisguise = true,
    spawn_points = {},
    --weapons = {"weapon_snork"},
    weapons = {"weapon_snork"},
    armor = 400,
    heal_animation = "dm_heal_sn",
    heal_sound = Sound("npc/snork/snork_attack_hit_2.ogg"),
    spawns = mutant_spawns,
    faction = FACTION_MUTANTS,
    unlockTime = 250*3600,
    unlockPrice = 25000,
    max = 3,
    forceLimit = true,
    monster = true,
    tpCamOffset = {
    UD = -20, -- Up / Down
    RL = 10, -- Right / Left
    FB = -85 -- Forward / Backward
},
    eatHp = 20,
    PlayerDeath = function(ply, _, killer)
        if math.random(0, 100) > 50 then
            playerDeathHook(ply, killer, 'rpitem_mutant_snork')
        end
    end
})

rp.addTeam("Кровосос", {
    color = Color(178, 34, 34),
    --model = "models/bloodsucker1.mdl",
    model = "models/wick/krovo/krovosos_little.mdl",
    description = [[Полулегендарный мутант,известный своими способностями к полному высасыванию жидкого содержимого жертвы и становления невидимым.
Тебя боятся даже самые матерые сталкеры.
]],
    salary = 10,
    punchMin = 70,
    punchMax = 90,
    critMin = 80,
    critMax = 120,
    stamina = 9999,
    command = "bloods",
    build = false,
    CantUseDisguise = true,
    reversed = true,
    disableDisguise = true,
    spawn_points = {},
    --weapons = {"weapon_krovosos", "weapon_zombie_fists"},
    weapons = { "weapon_bloodsucker" },
    armor = 600,
    health = 170,
    heal_animation = "dm_heal_ks",
    heal_sound = Sound("npc/bloodsucker/eat_1.ogg"),
    --hpRegen = 35,
    spawns = mutant_spawns,
    faction = FACTION_MUTANTS,
    footstepSound = false,
    forceLimit = true,
    PlayerSpawn = function(ply) ply:SetRunSpeed(264) end,
    unlockTime = 600*3600,
    unlockPrice = 50000,
    max = 3,
    --vip = true,
    speed = 1.2,
    monster = true,
    eatHp = 20,
    PlayerDeath = function(ply, _, killer)
        if math.random(0, 100) > 50 then
            playerDeathHook(ply, killer, 'rpitem_mutant_krovosos')
        end
    end
})

TEAM_BERRER = rp.addTeam( "Бюррер", {
    color = Color(178, 34, 34),
    model = {"models/monsters/burer.mdl"},
    description = [[Бюррер - Результат генетических экспериментов Секретной службы над преступниками по программе развития человеческого телекинеза. Гуманоидное существо с гипертрофированным цветом лица, одетое в клочья потрепанного комбинезона. Боясь яркого света, бюррер живет в темных и мрачных подземельях и пещерах. Питается мертвыми телами.]],
    salary = 15,
    armor = 500,
    spawn_points = empty,
    command = "berre",
    build = false,
    max = 2,
    forceLimit = true,
    monster = true,
    hpRegen = 10,
    scaleDamage = 0.75,
    unlockTime = 700*3600,
    minUnlockTime = 15 * 3600,
    unlockPrice = 65000,
    stamina = 9999,
    CantDeathmechanics = true,
    CantUseDisguise = true,
    reversed = true,
    disableDisguise = true,
    weapons = {"weapon_burer"},
    spawns = mutant_spawns,
    faction = FACTION_MUTANTS,
    PlayerSpawn = function( ply ) ply:SetWalkSpeed( 230 ); ply:SetRunSpeed( 230 ); ply:SetHealth(200); ply:SetMaxHealth(200); ply:SetJumpPower(0) end,
    heal_animation = "dm_heal_ks",
} );

rp.addTeam("Химера", {
    color = Color(178, 34, 34),
    model = "models/stalkertnb/chimera2.mdl",
    description = [[ Самое опасное существо зоны отчуждения, которое очень умно, проворно и до жути живучая. Убившие данную тварь, являются реально везучими!

    ]],
    salary = 15,
    spawn_points = empty,
    stamina = 9999,
    command = "himera",
    build = false,
    spawn_points = {},
    weapons = {"weapon_chimera2"},
    hpRegen = 5,
   -- scaleDamage = 0.80,
    armor = 400,
    forceLimit = true,
    monster = true,
    eatHp = 10,
    CantUseDisguise = true,
    reversed = true,
    disableDisguise = true,
    deathSound = Sound('hgn/stalker/creature/boar/boar_death_3.wav'),
    spawns = mutant_spawns,
    faction = FACTION_MUTANTS,
    CustomCheckFailMsg = 'himera',
    customCheck = function(ply) return CLIENT or ply:IsRoot() or #player.GetAll() >= 30  end,
    PlayerSpawn = function( ply ) ply:SetWalkSpeed( 450 ); ply:SetRunSpeed( 450 ); ply:SetHealth(200); ply:SetMaxHealth(200); end,
    unlockTime = 950*3600,
    max = 2,
    vip = true,
})

TEAM_IZLOM = rp.addTeam( "Излом", {
    color = Color(178, 34, 34),
    model = {"models/monsters/izlom.mdl"},
    description = [[Мутант, произошедший от человека. Выглядит как бродяга или горбатый старичок в разодранной одежде, хотя на самом деле он почти двухметрового роста. Сильный удар по спине может парализовать жертву. Бесцельно бродит по Зоне в поисках пищи.]],
    salary = 15,
    armor = 450,
    spawn_points = empty,
    command = "dev_izlom",
    build = false,
    hpRegen = 25,
    stamina = 9999,
    max = 2,
    monster = true,
    vip = true,
    weapons = {"weapon_izlom"},
    spawns = mutant_spawns,
    CantUseDisguise = true,
    reversed = true,
    disableDisguise = true,
    PlayerSpawn = function(ply) ply:SetMaxHealth(100); end,
    faction = FACTION_MUTANTS,
    unlockTime = 800*3600,
    heal_animation = "dm_heal_ks",
} );

TEAM_PSEV = rp.addTeam("Псевдогигант", {
    color = Color(178, 34, 34),
    model = "models/monsters/gigant.mdl",
    description = [[ Псевдогигант - Огромная туша, состоящая из каплеобразного туловища и пары гипертрофированных конечностей, достигает веса в две тонны. Внешняя неуклюжесть очень обманчива — псевдогиганты стремительны в движениях и обладают поразительным умением формировать на поверхности земли локальные ударные волны, поражающие в ограниченном радиусе всё живое.]],
    salary = 15,
    spawn_points = empty,
    stamina = 9999,
    command = "gigant",
    build = false,
    monster = true,
    spawn_points = {},
    weapons = {"weapon_gigant"},
    hpRegen = 22,
    scaleDamage = 0.25,
    armor = 1000,
    arrivalMessage = true,
    health = 500,
    CantUseDisguise = true,
    reversed = true,
    disableDisguise = true,
    deathSound = Sound('hgn/stalker/creature/boar/boar_death_3.wav'),
    footstepSound = Sound('wick/snork/large1.wav'),
    spawns = mutant_spawns,
    faction = FACTION_MUTANTS,
    CustomCheckFailMsg = 'gigant',
    --customCheck = function(ply) return CLIENT or ply:IsRoot() or #player.GetAll() >= 50 end,
    PlayerSpawn = function( ply )
        ply:SetJumpPower(0); ply:SetHealth(300); ply:SetMaxHealth(300);
        timer.Simple( 30 * 60, -- 15 минут
            function()
                if IsValid(ply) and (ply:Team() == TEAM_PSEV) then
                    ply:SetTeam( rp.GetDefaultTeam(ply) );
                    ply:KillSilent();
                    ply.JobEvent_Psevdo = nil;
                end
            end
        );
    end,
    PlayerDeath = function( ply, _, killer )
        if math.random(0, 100) > 50 then
            playerDeathHook(ply, killer, 'legend_jeton')
        end

        ply:SetTeam( rp.GetDefaultTeam(ply) );
        ply.JobEvent_Psevdo = nil;
    end,
    customCheck = function( ply )
        if SERVER and ply.JobEvent_Psevdo then
            return true
        end

        return false
    end,
    CustomCheckFailMsgVisible = true,
    CustomCheckFailMsg = CLIENT and "Участвуй в голосовании, чтобы стать Псевдогигантом" or "psevdo",
    max = 1,
})


TEAM_CONTROLER = rp.addTeam( "Контролёр", {
    color = Color(178, 34, 34),
    model = {"models/monsters/controler.mdl"},
    description = [[Один из самых опасных мутантов, встречающихся в Зоне. Результат генетических экспериментов, проводимых учеными по программе развития в человеке телепатических способностей.]],
    salary = 15,
    spawn_points = empty,
    command = "dev_kontroler",
    build = false,
    armor = 500,
    hpRegen = 35,
    monster = true,
   -- vip = true,
    max = 1,
    stamina = 9999,
    scaleDamage = 0.8,
    CantUseDisguise = true,
    reversed = true,
    disableDisguise = true,
    weapons = {"weapon_controller"},
    spawns = kontrol_spawns,
    faction = FACTION_MUTANTS,
    PlayerSpawn = function( ply ) ply:SetWalkSpeed( 115 ); ply:SetRunSpeed( 115 ); ply:SetHealth(300); ply:SetMaxHealth(300); end,
    heal_animation = "dm_heal_ks",
    likeReactions = 30,
} );

TEAM_BURER = rp.addTeam("C"..map..".RSA.Strider", {
  color = rsa_color,
  model = {"models/combine_strider.mdl"},
  description = [[
Страйдер - тяжелый штурмовой синтет с медленной скоростью.
Специализирован для большей проходимости, уничтожения защитников и укреплений.

Управление:
ЛКМ - Стрельба из импульсного пулемета;
ПКМ - Аннигиляторная пушка;

Прямые обязанности:
- Уничтожение нарушителей;
- Помощь в Зачистке;

Особенности:
- Преодоление высоких препятствий;
- Боевая мощь;

Запрещается:
- Использовать микрофон;
- Покидать D2 без приказа, кроме случаев атаки противников Альянса на D6 или D4;

В подчинении у CMD, OTA.KING.ElS и выше;
Не имеет права командовать;

Доступ к Нексус Надзору:
Полный Доступ;

Лояльность Альянса: Максимальная;
  ]],
  weapons = {""},
  command = "rsast",
  pill = "urfim_strider",
  spawns = mutant_spawns,
  salary = 1000,
  max = 1,
  forceLimit = true,
  faction = FACTION_MUTANTS,
  DontHaveDonateSWEPS = true,
  reversed = true,
  randomName = true,
  disableDisguise = true,
  CantUseInventorySWEPS = true,
  CantUseDisguise = true,
  CantDeathmechanics = true,
  CantBeMorphed = true,
  loyalty = 4,
  noReProgrammer = true,
  stamina = 9999,
  ignoreHeadcrab = true,
  build = false,
  arrivalMessage = true,
  PlayerSpawn = function( ply )
    timer.Simple( 15 * 60, -- 15 минут
      function()
        if IsValid(ply) and (ply:Team() == TEAM_RSAST) then
          ply:SetTeam( rp.GetDefaultTeam(ply) );
          ply:KillSilent();
          ply.JobEvent_Strider = nil;
        end
      end
    );
  end,
  PlayerDeath = function( ply )
    ply:SetTeam( rp.GetDefaultTeam(ply) );
    ply.JobEvent_Strider = nil;
  end,
  customCheck = function( ply )
    if SERVER and ply.JobEvent_Strider then
      return true
    end

    return false
  end,
  CustomCheckFailMsgVisible = true,
  CustomCheckFailMsg = "Участвуй в голосовании, чтобы стать Страйдером",
})

-- Настроить:
TEAM_DEV_CONTROLER = rp.addTeam( "Контролёр", {
    color = Color(178, 34, 34),
    model = {"models/monsters/controler.mdl"},
    description = [[Один из самых опасных мутантов, встречающихся в Зоне. Результат генетических экспериментов, проводимых учеными по программе развития в человеке телепатических способностей.
    Открываеться за 15 лайков.]],
    salary = 15,
    spawn_points = empty,
    command = "dev_kontroler",
    build = false,
    armor = 450,
    hpRegen = 15,
    stamina = 9999,
    weapons = {"weapon_controller"},
    spawns = kontrol_spawns,
    faction = FACTION_MUTANTS,
    PlayerSpawn = function( ply ) ply:SetWalkSpeed( 100 ); ply:SetRunSpeed( 100 ); end,
} );

TEAM_DEV_IZLOM = rp.addTeam( "(dev) Излом", {
    color = Color(178, 34, 34),
    model = {"models/monsters/izlom.mdl"},
    description = [[Излом- Мутант, произошедший от человека. Выглядит как бродяга или горбатый старичок в разодранной одежде, хотя на самом деле он почти двухметрового роста. Сильный удар по спине может парализовать жертву. Бесцельно бродит по Зоне в поисках пищи.]],
    salary = 15,
    armor = 450,
    spawn_points = empty,
    command = "dev_izlom",
    build = false,
    hpRegen = 35,
    stamina = 9999,
    weapons = {"weapon_izlom"},
    spawns = mutant_spawns,
    faction = FACTION_MUTANTS,
} );

local speed = rp.cfg.RunSpeed
local team_NumPlayers = team.NumPlayers
hook.Add("PlayerLoadout", function(ply)
if (ply:GetFaction() == FACTION_ZOMBIE1 or ply:GetFaction() == FACTION_ZOMBIE) && team_NumPlayers(TEAM_CONTROLER) > 0 then
    rp.Notify(ply, NOTIFY_GREEN, rp.Term('ControlerBoost'))
    ply:SetRunSpeed(speed * 1.2)
    ply:GiveArmor(25)
    ply:AddHealth(20)
    end
end)

--rp.addGroupChat( unpack(rp.GetFactionTeams({FACTION_MUTANTS})) );
--rp.AddDoorGroup( "Мутанты", rp.GetFactionTeams(FACTION_MUTANTS) );

rp.SetFactionVoices( {FACTION_MUTANTS}, {

} );
*/