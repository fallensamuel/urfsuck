-- "gamemodes\\darkrp\\gamemode\\config\\q_menu_objects.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.cfg.WorldObjectLimit = 500
rp.cfg.LocalObjectLimit = 1
rp.cfg.PlayerObjectLimit = 5

rp.AddQCategory("Стулья", "icon16/linux.png")

rp.AddQChair("Chair_Wood", {
    time = 10 * 3600,
    limit = 1,
    worldlimit = 20,
    price = 1500,
    ListIcon = 'ent_pic/wood_chair.png',
    icoMinusScale = -1,
    name = 'Деревянный Стул',
   -- model = 'models/nova/chair_wood01.mdl',
    category = "Стулья",
})

rp.AddQChair("Chair_Stool_01", {
    time = 16 * 3600,
    limit = 1,
    worldlimit = 20,
    price = 200,
    ListIcon = 'ent_pic/bar_chair.png',
    icoMinusScale = -1,
    name = 'Барный Стул',
   -- model = 'models/nova/chair_wood01.mdl',
    category = "Стулья",
})

rp.AddQChair("Couch_Furniture_01", {
    time = 24 * 3600,
    limit = 1,
    worldlimit = 10,
    price = 250,
    ListIcon = 'ent_pic/basic_chair.png',
    icoMinusScale = -1,
    name = 'Комфортное Кресло',
   -- model = 'models/nova/chair_wood01.mdl',
    category = "Стулья",
})

rp.AddQChair("Chair_Office2", {
    time = 72 * 3600,
    limit = 1,
    worldlimit = 10,
    price = 3500,
    ListIcon = 'ent_pic/boss_chair.png',
    icoMinusScale = -1,
    name = 'Кресло Босса',
    --model = 'models/nova/chair_wood01.mdl',
    category = "Стулья",
})

rp.AddQChair("Chair_Armchair_02", {
    time = 96 * 3600,
    limit = 1,
    worldlimit = 10,
    price = 450,
    ListIcon = 'ent_pic/king_chair.png',
    icoMinusScale = -1,
    name = 'Королевское Кресло',
    --model = 'models/nova/chair_wood01.mdl',
    category = "Стулья",
})

rp.AddQChair("Toilet_Furniture_01", {
    time =  120 * 3600,
    limit = 1,
    worldlimit = 20,
    price = 100,
    ListIcon = 'ent_pic/toilet.png',
    icoMinusScale = -1,
    name = 'Грязный Унитаз',
   -- model = 'models/nova/chair_wood01.mdl',
    category = "Стулья",
})

rp.AddQEntity({
    ent = 'urf_craftable',
    --time = 10 * 3600,
    limit = 1,
    worldlimit = 10,
    name = 'Верстак',
    --model = 'models/props_junk/ravenholmsign.mdl',
    --is_item = true,
    ListIcon = 'ent_pic/crafttable.png',
    icoMinusScale = 0,
})

rp.AddQEntity({
    ent = 'ent_picture',
    time = 300,
    limit = 2,
    worldlimit = 25,
    name = 'Картина',
    --model = 'models/hunter/plates/plate1x1.mdl',
    ListIcon = 'ent_pic/picture.png',
    icoMinusScale = 0,
})

rp.AddQEntity({
    ent = 'ent_picture_big',
    time = 15 * 3600,
    limit = 1,
    worldlimit = 15,
    name = 'Большая Картина',
    --model = 'models/hunter/plates/plate1x4.mdl',
    ListIcon = 'ent_pic/big_picture.png',
    icoMinusScale = 0,
})

rp.AddQEntity({
    ent = 'urfim_radio',
    time = 15 * 3600,
    limit = 1,
    worldlimit = 10,
    name = 'Радио',
    --model = 'models/props_lab/citizenradio.mdl',
    ListIcon = 'ent_pic/radio.png',
    icoMinusScale = 0,
})

rp.AddQEntity({
    name = "Флаг",
    ent = "flag",
    model = "models/props_c17/signpole001.mdl",
    time = 2 * 3600,
    limit = 1,
    worldlimit = 4,
    is_item = true,
})


rp.AddQEntity({
    name = "Записка",
    ent = "ent_note",
    model = "models/props_c17/paper01.mdl",
    time = 0,
    limit = 2,
    worldlimit = 15,
    is_item = true,
})


rp.AddQEntity({
    name = "Ремонтный Набор",
    ent = "money_printer_fix",
    model = "models/props_c17/tools_wrench01a.mdl",
    time = 0,
    limit = 2,
    worldlimit = 6,
    is_item = true,
})
/*
rp.AddQEntity({
    ent = 'antirad_pills',
    time = 80 * 3600,
    limit = 1,
    worldlimit = 10,
    name = 'Антирадиационные таблетки',
    model = 'models/hunt_down_the_freeman/weapons/w_pills.mdl',
    is_item = true,
})
*/

rp.AddQEntity({
    ent = 'synthesizer_piano',
    time = 20 * 3600,
    Access = function( ply )
        return ply:IsRoot()
            or ply:IsRank('executiveleader')
            or ply:IsRank('globalcontributor')
            or ply:IsRank('platinumcontributor')
            or ply:IsRank('premium')
            or ply:IsRank('vip+')
            or ply:HasPremium()
            or rp.PlayerHasAccessToCustomJob({'sponsor'}, ply:SteamID64())
    end,
    limit = 1,
    worldlimit = 3,
    name = 'Синтезатор - Пианино',
    ListIcon = 'ent_pic/piano.png',
    icoMinusScale = 0,
})

rp.AddQEntity({
    ent = 'synthesizer_organ',
    time = 30 * 3600,
    Access = function( ply )
        return ply:IsRoot()
            or ply:IsRank('executiveleader')
            or ply:IsRank('globalcontributor')
            or ply:IsRank('platinumcontributor')
            or ply:IsRank('premium')
            or ply:IsRank('vip+')
            or ply:HasPremium()
            or rp.PlayerHasAccessToCustomJob({'sponsor'}, ply:SteamID64())
    end,
    limit = 1,
    worldlimit = 2,
    name = 'Синтезатор - Орган',
    ListIcon = 'ent_pic/organ.png',
    icoMinusScale = 0,
})

rp.AddQEntity({
    ent = 'urfim_radio_giga',
    Access = function( ply )
        return ply:IsRoot()
            or ply:IsRank('executiveleader')
            or ply:IsRank('globalcontributor')
            or ply:IsRank('platinumcontributor')
            or ply:IsRank('premium')
            or ply:IsRank('vip+')
            or ply:IsRank('root')
            or ply:HasPremium()
            or rp.PlayerHasAccessToCustomJob({'sponsor'}, ply:SteamID64())
    end,
    limit = 1,
    worldlimit = 3,
    name = 'Патибокс',
    ListIcon = 'ent_pic/urfim_radio_giga.png',
    icoMinusScale = 0,
})

rp.AddQCategory("Патроны", "icon16/box.png")

rp.AddQAmmo("Pistol", {
    name = 'Пистолетные патроны',
    ListIcon = 'ent_pic/pistol.png',
    icoMinusScale = 0.7,
    category = "Патроны",
    price = 250,
    amout = 25,
})

rp.AddQAmmo("357", {
    name = 'Патроны для Револьвера',
    ListIcon = 'ent_pic/357.png',
    icoMinusScale = 0.7,
    category = "Патроны",
    price = 200,
    amout = 16,
})

rp.AddQAmmo("SMG1", {
    name = 'Патроны для ПП',
    ListIcon = 'ent_pic/smg.png',
    icoMinusScale = 0.7,
    category = "Патроны",
    price = 250,
    amout = 30,
})

rp.AddQAmmo("Buckshot", {
    name = 'Картечь для Дробовика',
    ListIcon = 'ent_pic/shotgun.png',
    icoMinusScale = 0.7,
    category = "Патроны",
    price = 350,
    amout = 25,
})

rp.AddQAmmo("ar2", {
    name = 'Патроны для Автомата',
    ListIcon = 'ent_pic/ar2.png',
    icoMinusScale = 0.7,
    category = "Патроны",
    price = 380,
    amout = 30,
})

rp.AddQAmmo("XBowBolt", {
    name = 'Патроны для Винтовок',
    ListIcon = 'ent_pic/bolt.png',
    icoMinusScale = 0.7,
    category = "Патроны",
    price = 45,
    amout = 20,
})

if StormFox then
rp.AddQEntity({
    ent = 'stormfox_campfire_nodamage',
    //time = 24 * 3600,
    //allowed = {},
    Access = function( ply )
        return ply:IsRoot()
            or ply:IsRank('globaladmin')
            or ply:IsRank('globaladmin*')
            or ply:IsRank('executivespecialist')
            or ply:IsRank('executiveleader')
            or ply:IsRank('globalcontributor')
            or ply:IsRank('platinumcontributor')
            or ply:IsRank('vip+')
            or rp.PlayerHasAccessToCustomJob({'sponsor'}, ply:SteamID64())
    end,
    limit = 1,
    worldlimit = 4,
    name = 'Костёр',
    ListIcon = 'ent_pic/fire.png',
    icoMinusScale = 0,
})
end

/*rp.AddQEntity({
    ent = 'simpleprinter_ammo',
    time = 85 * 3600,
    limit = 1,
    worldlimit = 20,
    name = 'Ящик с боеприпасами',
    model = 'models/z-o-m-b-i-e/st/cover/st_cover_wood_box_01.mdl',
    is_item = true,
})

rp.AddQEntity({
    ent = 'simpleprinter_ammo',
    time = 85 * 3600,
    limit = 1,
    worldlimit = 20,
    name = 'Ящик с боеприпасами',
    model = 'models/z-o-m-b-i-e/st/cover/st_cover_wood_box_01.mdl',
    is_item = true,
})*/