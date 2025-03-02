/*
rp.AddEntity( {
	name = "Велосипед",
    ent = "simfphys_vehicle_spawner",
    model = "models/truppenfahrrad.mdl",
    price = 100,
    max = 1,
    cmd = "/buycar",
    allowed = {TEAM_CURIER},
	onlyEntity = true, 
    onSpawn = function(ent, pl)
        ent:SpawnVehicle("truppenfahrrad", pl)
    end,
    noTake = true,
})
*/

rp.AddEntity( {
	name = "АПК",
    ent = "simfphys_vehicle_spawner",
    model = "models/ctvehicles/hla/prisoner_transport.mdl",
    price = 1500,
    max = 1,
    cmd = "/buyapc",
    allowed = {TEAM_PILOTGRID},
	onlyEntity = true, 
    onSpawn = function(ent, pl)
        ent:SpawnVehicle("ctv_hla_prisoner_transport", pl)
    end,
    noTake = true,
})

rp.AddEntity({
    name = "Персональный ящик",
    ent = "box_personal",
    model = "models/props_junk/wood_crate001a_damaged.mdl",
    price = 5000,
    max = 1,
    noTake = true,
    notTransfered = false,
    allowed = {false},
})

rp.AddEntity({
    name = "Производитель Боеприпасов",
    ent = "simpleprinter_ammo",
    model = "models/cmb-computer-main/cmb-computer-main.mdl",
    price = 5000,
    max = 1,
    noTake = true,
    allowed = {false},
})

rp.AddEntity({
    name = "Производитель Лекарства",
    ent = "simpleprinter_hp",
    model = "models/cmb-bio-computer-2/cmb-bio-computer-3.mdl",
    price = 5000,
    max = 1,
    noTake = true,
    allowed = {false},
})

rp.AddEntity({
	name = "Маленькое табло",
	ent = "bt_notiboard_small",
	model = "models/props_trainstation/tracksign08.mdl",
	price = 100,
	max = 3,
	cmd = "/buystabl",
	noTake = true,
	allowed = {false},
})

rp.AddEntity({
	name = "Среднее табло",
	ent = "bt_notiboard_medium",
	model = "models/hunter/plates/plate1x3.mdl",
	price = 150,
	max = 2,
	cmd = "/buymtabl",
	noTake = true,
	allowed = {false},
})

rp.AddEntity({
	name = "Большое табло",
	ent = "bt_notiboard_big",
	model = "models/hunter/plates/plate1x4.mdl",
	price = 200,
	max = 2,
	cmd = "/buybtabl",
	noTake = true,
	allowed = {false},
})

rp.AddEntity({
	name = "Картина",
	ent = "ent_picture",
	model = "models/hunter/plates/plate1x1.mdl",
	price = 50,
	max = 2,
	cmd = "/buypic",
	noTake = true,
	allowed = {false},
})

rp.AddEntity({
    name = "Большая Картина",
    ent = "ent_picture_big",
    model = "models/hunter/plates/plate1x1.mdl",
    price = 100,
    max = 1,
    cmd = "/buybigpic",
    noTake = true,
    allowed = {false},
})

rp.AddEntity({
	name = "Флаг",
	ent = "flag",
	model = "models/props_c17/signpole001.mdl",
	price = 700,
	max = 1,
	cmd = "/buyflag",
	noTake = true,
	allowed = {false},
})

-- Notes
rp.AddEntity({
	name = "Записка",
	ent = "ent_note",
	model = "models/props_c17/paper01.mdl",
	price = 50,
	max = 2,
	cmd = "/note",
	noTake = true,
	onSpawn = function(ent, pl)
		if (IsValid(pl.LastNote)) then
			pl.LastNote:Remove()
		end

		pl.LastNote = ent
		rp.Notify(pl, NOTIFY_GREEN, rp.Term("USENote"))
	end
}) 


rp.AddEntity({
	name = "Раздатчик Брони",
	ent = "armor_lab", 
	model = "models/props_combine/suit_charger001.mdl", 
	price = 250, 
	max = 1, 
	cmd = "/buyarmorlab", 
	noTake = true,
	allowed = {TEAM_KLEINER, TEAM_REBFIVE, TEAM_PILOTGRID, TEAM_STALKER}, 
})	

rp.AddEntity({
	name = "Раздатчик Здоровья",
	ent = "med_lab", 
	model = "models/props_combine/health_charger001.mdl", 
	price = 100, 
	max = 1, 
	cmd = "/buymedlab", 
	noTake = true,
	allowed = {TEAM_CWU_MEDIC, TEAM_OFCHELIX, TEAM_KLEINER, TEAM_REBFIVE, TEAM_PILOTGRID}, 
})

rp.AddEntity({
	name = "Горшок",
	ent = "weed_plant",
	model = "models/alakran/marijuana/pot_empty.mdl",
	price = 500,
	max = 5,
	cmd = "/buypot",
	allowed = rp.GetFactionTeams({FACTION_REBEL}, {TEAM_HOBO}),
	noTake = true,
})
/*
rp.AddEntity({
	name = "Семена",
	ent = "seed_weed",
	model = "models/Items/AR2_Grenade.mdl",
	price = 10,
	max = 20,
	cmd = "/buyseed",
	allowed = rp.GetFactionTeams({FACTION_REBEL}, {TEAM_HOBO}),
})

rp.AddEntity({
    name = "Микроволновка",
    ent = "microwave",
    model = "models/props/cs_office/microwave.mdl",
    price = 500,
    max = 1,
    cmd = "/buymicrowave",
    allowed = {TEAM_CWU_LEADER},
    noTake = true
})
*/

-- Money Printers
local money_printers = {}

local function reachedMoneyPrinterLimit(ply)
	local i = 0
	for k=1, #money_printers do
		i = i + ply:GetCount(money_printers[k]) or 0
		if i >= rp.cfg.MaxPrinters then
			return false, 'MaxMoneyPrinterReached'
		end
	end
	return true
end

local function addPrinter(t)
	money_printers[#money_printers+1] = t.ent
	if SERVER then
		t.customCheck = reachedMoneyPrinterLimit
	end
	t.max = t.max or 1
	t.price = math.floor(t.price * 0.7)
	t.cmd = '/'..t.ent
	t.customCheckFailMsg = rp.Term('MaxMoneyPrinterReached')
	rp.AddEntity(t)
end

addPrinter({
    name = "Мини Генератор токенов",
	ent = "simpleprint1",
	model = "models/urf/bitminer_2.mdl",
	price = 100,
	max = 2,
	allowed = rp.GetFactionTeams({FACTION_CITIZEN, FACTION_REBEL, FACTION_CWU}, {TEAM_HOBO}),
	unlockTime = 0,5 * 3600
})

rp.AddEntity({
	name = "Ремонтный Набор",
	ent = "money_printer_fix",
	model = "models/props_c17/tools_wrench01a.mdl",
	max = 3,
	cmd = "/buyprintfix"
})

-- Ammo
rp.AddAmmoType({
	name = "Пистолетные патроны",
	ent = "Pistol",
	model = "models/Items/BoxSRounds.mdl",
	price = 10,
	ammoType = "Pistol",
	amountGiven = 50,
})

rp.AddAmmoType({
	name = "Картечь для дробовика",
	ent = "Buckshot",
	model = "models/Items/BoxBuckshot.mdl",
	price = 75,
	ammoType = "Buckshot",
	amountGiven = 25,
})

rp.AddAmmoType({
	name = "СМГ Патроны",
	ent = "smg1",
	model = "models/Items/BoxMRounds.mdl",
	price = 50,
	ammoType = "smg1",
	amountGiven = 120,
})

rp.AddAmmoType({
	name = "Патроны для AR2",
	ent = "ar2",
	model = "models/Items/combine_rifle_cartridge01.mdl",
	price = 50,
	ammoType = "ar2",
	amountGiven = 120,
})

rp.AddAmmoType({
	name = "Патроны для револьвера",
	ent = "357",
	model = "models/Items/357ammobox.mdl",
	price = 25,
	ammoType = "357",
	amountGiven = 35,
})

rp.AddAmmoType({
	name = "Болты для арбалета",
	ent = "XBowBolt",
	model = "models/Items/CrossbowRounds.mdl",
	price = 50,
	ammoType = "XBowBolt",
	amountGiven = 25,
})

rp.AddAmmoType({
	name = "Патроны для РПГ",
	ent = "RPG_Round",
	model = "models/weapons/w_missile.mdl",
	price = 500,
	ammoType = "RPG_Round",
	amountGiven = 2,
	allowed = {false},
})