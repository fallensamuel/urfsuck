local spawns = rp.cfg.Spawns and rp.cfg.Spawns[game.GetMap()] or {}

if spawns[1] and spawns[2] then
	timer.Create('SpawnClean', 0.5, 0, function()
		for k, v in ipairs(ents.FindInBox(spawns[1], spawns[2])) do
			if IsValid(v) then
				v.IsInSpawn = CurTime() + 1
				local owner = v.ItemOwner or v:CPPIGetOwner()
				if rp.cfg.SpawnDisallow[v:GetClass()] && IsValid(owner) && !owner:HasFlag('p') then
					rp.Notify(v.ItemOwner or v:CPPIGetOwner(), NOTIFY_ERROR, rp.Term('NotAllowedInSpawn'), v:GetClass())
					v:Remove()
				end
			end
		end
	end)
end
