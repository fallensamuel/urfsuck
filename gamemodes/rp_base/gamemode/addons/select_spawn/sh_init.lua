function rp.GetSpawnPoint(point)
	return point && rp.cfg.SpawnPoints[point] && rp.cfg.SpawnPoints[point].Spawns || nil
end
