function rp.SelectSpawn(id)
	net.Start('rp.SelectSpawnPoint')
		net.WriteUInt(id, 4)
	net.SendToServer()
end