rp.AddVendor("Дежурный Альянса", "models/rrp/metropolice/pm/gofcmetropolicepm.mdl", "idle_all_01", {  -- Скупщик Альянса
	rp_city17_alyx_urfim = {
		Vector(4664, 4753, 64),
        Angle(0, 180, 0),
	}
}) 

rp.AddVendor("Майк - Скупщик", "models/daemon_alyx/players/male_citizen_01.mdl", "idle_all_01", {  	-- Скупщик Мусора
	rp_city17_alyx_urfim = {
		Vector(3770, 2196, 64),
        Angle(0, 90, 0),
	}
}, { 
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
	[6] = 0,
	[7] = 0,
	[8] = 0,
}, 0)  

rp.AddVendor("Алекс", "models/daemon_alyx/players/male_citizen_03.mdl", "idle_all_01", {	-- Продавец расходников на ГП
	rp_city17_alyx_urfim = {
		Vector(4144, 2196, 64),
        Angle(0, 110, 0),
	}
}, { 
	[1] = 3,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
	[6] = 11,
	[7] = 0,
	[8] = 3,
}, 0) 

rp.AddVendor("Ден - Снабженец", "models/daemon_alyx/players/male_citizen_03.mdl", "idle_all_01", {	-- Продавец Сопротивления Лаба
	rp_city17_alyx_urfim = {
		Vector(-5581, 620, 0),
        Angle(0, -90, 0),
	}
}, { 
	[1] = 2,
	[2] = 0,
	[3] = 3,
	[4] = 0,
	[5] = 0,
	[6] = 7,
	[7] = 0,
	[8] = 0,
}, 0) 

rp.AddVendor("Дин - Снабженец", "models/daemon_alyx/players/male_citizen_02.mdl", "idle_all_01", {	-- Продавец Сопротивления Бункер
	rp_newcity_urfim = {
		Vector(-1085, 6072, -466),
        Angle(0, -90, 0),
	}
}, { 
	[1] = 12,
	[2] = 4,
	[3] = 1,
	[4] = 1,
}, 0) 

rp.AddVendor("Скупой Яков", "models/daemon_alyx/players/male_citizen_01.mdl", "idle_all_01", {	-- Торговец Нелегалом D4
	rp_city17_alyx_urfim = {
		Vector(3082, 5568, -384),
        Angle(0, 125, 0),
	}
}, { 
	[1] = 2,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
	[6] = 10,
	[7] = 0,
	[8] = 1,
}, 2) 

rp.AddVendor("Щедрый Абрам", "models/daemon_alyx/players/male_citizen_03.mdl", "idle_all_01", {	-- Торговец Нелегалом D3
	rp_city17_alyx_urfim = {
		Vector(3668, 6317, 64),
        Angle(0, 0, 0),
	}
}, { 
	[1] = 5,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
	[6] = 10,
	[7] = 0,
	[8] = 1,
}, 2) 

rp.AddVendor("Томми", "models/teslacloud/citizens/male07.mdl", "idle_all_01", {	-- Бармен D6
	rp_newcity_urfim = {
		Vector(2518, -35, 32),
        Angle(0, -90, 0),
	}
}, { 
	[1] = 3,
	[2] = 3,
	[3] = 0,
	[4] = 0,
}, 0) 

rp.AddVendor("Весельчак Боб", "models/daemon_alyx/players/male_citizen_01.mdl", "idle_all_01", {	-- Бармен D5
	rp_city17_alyx_urfim = {
		Vector(-1164, 150, -96),
        Angle(0, 0, 0),
	}
}, { 
	[1] = 1,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
	[6] = 0,
	[7] = 0,
	[8] = 0,
}, 0) 

rp.AddVendor("Старший Курьер", "models/daemon_alyx/players/male_citizen_03.mdl", "idle_all_01", {	-- Бармен D5
	rp_city17_alyx_urfim = {
		Vector(3505, 1411, 64),
        Angle(0, -135, 0),
	}
}, { 
	[1] = 3,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 2,
	[6] = 11,
	[7] = 0,
	[8] = 3,
}, 0, 
{
	[TEAM_CURIER] = true,
}, 'NotACurier')

rp.AddVendor("Секретарь Нексус Надзора", "models/teslacloud/cityadmin/female02.mdl", "idle_all_01", {	-- Бармен D5
	rp_city17_alyx_urfim = {
		Vector(6668, 3545, 64),
        Angle(0, -180, 0),
	}
}, { 
	[1] = 1,
	[2] = 0,
}, 0)  

rp.AddVendor("Джон - Приемщик", "models/daemon_alyx/players/male_citizen_03.mdl", "idle_all_01", {	-- Прием Металла
	rp_city17_alyx_urfim = {
		Vector(-449, -1555, 64),
        Angle(0, -90, 0),
	}
}, { 
	[1] = 1,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
	[6] = 1,
	[7] = 0,
	[8] = 0,
}, 0) 

rp.AddVendor("Подмастерье", "models/daemon_alyx/players/male_citizen_03.mdl", "idle_all_01", {
	rp_city17_alyx_urfim = {
		Vector(-1032, 717, -144),
        Angle(0, -90, 0),
	}
}, { 
	[1] = 2,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
	[6] = 1,
	[7] = 0,
	[8] = 0,
}, 0, 
{
	[TEAM_VORTGUN] = true,
}, 'NotAGunner')
