-- "gamemodes\\darkrp\\gamemode\\addons\\radiation\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--——————————————————D A T A —▬— T A B L E S——————————————————--

rp.Radiation = rp.Radiation or {}
rp.Radiation.Zones = rp.Radiation.Zones or {}
rp.Radiation.ZombieJobs = rp.Radiation.ZombieJobs or {}
rp.Radiation.ZombieFactions = rp.Radiation.ZombieFactions or {}
rp.Radiation.Contact = "beelzebub@incredible-gmod.ru"
rp.Radiation.Enable = rp.Radiation.Enable or true
rp.Radiation.ZombieFaction = rp.Radiation.ZombieFaction or 1
rp.Radiation.DefaultJob = rp.Radiation.DefaultJob or 1 -- Стандартная профессия зомби для всех профессий не имеюших уникальную зомби профессию в rp.Radiation.ZombieJobs
rp.Radiation.InfectChance = rp.Radiation.InfectChance or 50 -- % шанса на заражение/смерть от максимального уровня радиации
rp.Radiation.MaxRadiationDamage = rp.Radiation.MaxRadiationDamage or 2
rp.Radiation.ImmunityJobs = rp.Radiation.ImmunityJobs or {}
rp.Radiation.ImmunityFactions = rp.Radiation.ImmunityFactions or {}