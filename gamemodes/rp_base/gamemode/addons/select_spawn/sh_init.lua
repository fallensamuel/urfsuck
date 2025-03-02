-- "gamemodes\\rp_base\\gamemode\\addons\\select_spawn\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
function rp.GetSpawnPoint( point )
	return point and rp.cfg.SpawnPoints[point] and rp.cfg.SpawnPoints[point].Spawns or nil
end
