util.AddNetworkString('rp.SelectSpawnPoint')

net.Receive('rp.SelectSpawnPoint', function(len, ply)
	local id = net.ReadUInt(4)
	if !rp.cfg.SpawnPoints[id] then return end

	local point = rp.cfg.SpawnPoints[id]
	if (not ply.capruteSpawnPoints or not ply.capruteSpawnPoints[id]) and (not ply:GetJobTable().spawn_points or not ply:GetJobTable().spawn_points[id]) then return end

	print('PlyChangePoint', point.Name)
	rp.Notify(ply, NOTIFY_GENERIC, rp.Term('SpawnPointChanged'), point.Name)

	ply.spawnPoint = id
end)

local table_Random = table.Random
hook.Add('PlayerSelectSpawn', function(ply)
	if ply.spawnPoint then
		return nil, table_Random(rp.cfg.SpawnPoints[ply.spawnPoint].Spawns)
	end
end)

hook.Add('OnPlayerChangedTeam', function(ply, prevTeam, t)
	if ply.spawnPoint and not (rp.teams[t].spawn_points and rp.teams[t].spawn_points[ply.spawnPoint]) and (not ply.capruteSpawnPoints or not ply.capruteSpawnPoints[ply.spawnPoint]) then
		ply.spawnPoint = nil
	end
end)