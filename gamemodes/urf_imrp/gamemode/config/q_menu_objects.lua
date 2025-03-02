rp.cfg.WorldObjectLimit = 500
rp.cfg.LocalObjectLimit = 1
rp.cfg.PlayerObjectLimit = 5

rp.AddQEntity({
    ent = 'sent_soccerball',
    time = 300,
    limit = 1,
    worldlimit = 30,
    ListIcon = 'ent_pic/ball.png',
    icoMinusScale = 0,
    name = 'Мяч',
    no_freeze = true,
    --model = 'models/props_phx/misc/soccerball.mdl',
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
    ent = 'bt_notiboard_small',
    time = 5 * 3600,
    limit = 1,
    worldlimit = 20,
    name = 'Маленькое Табло',
    --model = 'models/props_trainstation/tracksign08.mdl',
    is_item = true,
    ListIcon = 'ent_pic/tablo_min.png',
    icoMinusScale = 0,
})

rp.AddQEntity({
    ent = 'bt_notiboard_medium',
    time = 10 * 3600,
    limit = 1,
    worldlimit = 20,
    name = 'Среднее Табло',
    --model = 'models/hunter/plates/plate1x3.mdl',
    is_item = true,
    ListIcon = 'ent_pic/tablo_medium.png',
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
    ent = 'bt_notiboard_big',
    time = 20 * 3600,
    limit = 1,
    worldlimit = 20,
    name = 'Большое Табло',
    --model = 'models/props_junk/ravenholmsign.mdl',
    is_item = true,
    ListIcon = 'ent_pic/tablo_medium.png',
    icoMinusScale = 0,
})

rp.AddQEntity({
    ent = 'box_personal',
    time = 25 * 3600,
    limit = 1,
    worldlimit = 20,
    name = 'Персональный Ящик',
    --model = 'models/props_marines/ammocrate01_static.mdl',
    is_item = true,
    ListIcon = 'ent_pic/box.png',
    icoMinusScale = 0,
})

rp.AddQEntity({
    ent = 'simpleprinter_hp',
    time = 50 * 3600,
    limit = 1,
    worldlimit = 15,
    price = 500,
    name = 'Производитель Лекарства',
    model = 'models/cmb-bio-computer-2/cmb-bio-computer-3.mdl',
    is_item = true,
    ListIcon = 'ent_pic/armor_creator.png',
    icoMinusScale = 0,
})

rp.AddQEntity({
    ent = 'simpleprinter_ammo',
    time = 75 * 3600,
    limit = 1,
    worldlimit = 15,
    price = 500,
    name = 'Производитель Патронов',
    model = 'models/cmb-computer-main/cmb-computer-main.mdl',
    is_item = true,
    ListIcon = 'ent_pic/ammo_creator.png',
    icoMinusScale = 0,
})



rp.AddQCategory("Патроны", "icon16/box.png")

rp.AddQAmmo("Pistol", {
    name = 'Для Пистолета',
    ListIcon = 'ent_pic/pistol.png',
    icoMinusScale = 0.7,
    category = "Патроны",
    price = 10,
    amout = 25,
})

rp.AddQAmmo("357", {
    name = 'Для Револьвера',
    ListIcon = 'ent_pic/357.png',
    icoMinusScale = 0.7,
    category = "Патроны",
    price = 20,
    amout = 16,
})

rp.AddQAmmo("SMG1", {
    name = 'Для СМГ',
    ListIcon = 'ent_pic/smg.png',
    icoMinusScale = 0.7,
    category = "Патроны",
    price = 25,
    amout = 30,
})

rp.AddQAmmo("Buckshot", {
    name = 'Для Дробовика',
    ListIcon = 'ent_pic/shotgun.png',
    icoMinusScale = 0.7,
    category = "Патроны",
    price = 25,
    amout = 25,
})

rp.AddQAmmo("ar2", {
    name = 'Для AR-#',
    ListIcon = 'ent_pic/ar2.png',
    icoMinusScale = 0.7,
    category = "Патроны",
    price = 40,
    amout = 30,
})

rp.AddQAmmo("XBowBolt", {
    name = 'Для Арбалета',
    ListIcon = 'ent_pic/bolt.png',
    icoMinusScale = 0.7,
    category = "Патроны",
    price = 40,
    amout = 20,
})

rp.AddQCategory("Стулья", "icon16/linux.png")

rp.AddQChair("Chair_Wood", {
    time = 10 * 3600,
    limit = 1,
    worldlimit = 20,
    price = 150,
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
    price = 350,
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

