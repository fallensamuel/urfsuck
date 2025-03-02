-- "gamemodes\\darkrp\\gamemode\\config\\pimp_cars\\uaz.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SIM = {}

--Индефикатор назначается в порядке исполнения PIMP.RegisterCustomData(...) автоматически

SIM.VehicleName = "Swelter_uaz469"                                

SIM.Name = "Uaz-469"        
                                            
SIM.tyresmoke = {Vector(180, 180, 180) / 255, Vector(1, 0, 0), Vector(0, 1, 0), Vector(0, 0, 1)}     --дым покрышек

SIM.booletproof = {true, false}                                                                      --пуленепробиваемые покрышки

SIM.Price = 200                                                                                   --цена

SIM.CanSpawn = function(pl) return table.HasValue({
    TEAM_GENERAL, TEAM_SEC, TEAM_EPU, TEAM_SNIPERMAY, TEAM_UNIONOFC, TEAM_VSU_VENDOR, TEAM_UNIONLEU1,
}, pl:Team()) end --возможность спавна

SIM.CustomPoses = {
    ['rp_stalker_urfim'] = {
        { pos = Vector(-10864.820312, -10541.233398, -334.539276), ang = Angle(0.255, 84.969, -0.111) },
     
    }
}

PIMP.RegisterCustomData(SIM)