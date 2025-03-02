-- "gamemodes\\rp_base\\gamemode\\addons\\urf_heists\\sh_heists.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.Heists = rp.Heists or {
    IsHeistRunning   = false,
    HeistTimeLength  = rp.cfg.Heists and rp.cfg.Heists.HeistTimeLength or 600
};

if SERVER then
    AddCSLuaFile( "cl_heists.lua" );
    
    include( "sv_heists.lua" );
end

if CLIENT then
    include( "cl_heists.lua" );
end

table.insert( rp.cfg.Announcements, translates and translates.Get("Не хватает денег? Попробуйте собрать свою команду мечты и ограбить банк!") or "Не хватает денег? Попробуйте собрать свою команду мечты и ограбить банк!" );