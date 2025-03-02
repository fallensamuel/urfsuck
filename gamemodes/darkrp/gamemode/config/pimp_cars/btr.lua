-- "gamemodes\\darkrp\\gamemode\\config\\pimp_cars\\btr.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local SIM = {}

--Индефикатор назначается в порядке исполнения PIMP.RegisterCustomData(...) автоматически

SIM.VehicleName = "simfphys_btr80"                                

SIM.Name = "BTR80"        
                                            
SIM.tyresmoke = {Vector(180, 180, 180) / 255, Vector(1, 0, 0), Vector(0, 1, 0), Vector(0, 0, 1)}     --дым покрышек

SIM.booletproof = {true, false}                                                                      --пуленепробиваемые покрышки

SIM.Price = 350                                                                                   --цена

SIM.CanSpawn = function(pl) return table.HasValue({
    TEAM_GENERAL, TEAM_SEC, TEAM_EPU, TEAM_UNIONLEU1,
}, pl:Team()) end --возможность спавна

SIM.CustomPoses = {
    ['rp_stalker_urfim'] = {
        { pos = Vector(-10879.955078, -10579.626953, -338.350037), ang = Angle(0.003, 90.000, 0.002) },
     
    }
}

PIMP.RegisterCustomData(SIM)