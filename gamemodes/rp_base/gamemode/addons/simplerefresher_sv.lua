local FindClass, FindSphere = ents.FindByClass, ents.FindInSphere;
local tsimple = timer.Simple;

rp.CapturePointRefreshing = rp.CapturePointRefreshing or false;

hook.Add('OnReloaded', 'AutoRefreshRespawns', function()
	if not rp.cfg.DontRefreshPositions and not rp.cfg.DontAutoRefresh then
		-- Remove all cn_npc then
		-- Remove all cn_npc
		for k, v in pairs(FindClass('cn_npc')) do SafeRemoveEntity(v); end

		-- Remove capture flags & bonuses
		if (!rp.CapturePointRefreshing) then
			for k, v in pairs(FindClass('ent_capture_bonuses')) do SafeRemoveEntity(v); end
			for k, v in pairs(FindClass('ent_capture_flag')) do SafeRemoveEntity(v); end
		end

		-- Remove loots
		for k, v in pairs(rp.cfg.SpawnPositionLoot[game.GetMap()] or {}) do
			for j, e in pairs(FindSphere(v.pos, 5)) do
				if (IsValid(e) and e:GetClass() == 'rp_item') then
					SafeRemoveEntity(e);
					break
				end
			end
		end

		-- Respawn Vendor NPC
		RunConsoleCommand('respawn_vendor_npcs');

		-- Spawn Chessnut's NPC
		hook.GetTable()['InitPostEntity']['cnLoadNPC']();

		-- Refresh CapturePoints
		if (!rp.CapturePointRefreshing) then
			rp.CapturePointsReload(5);
			rp.CapturePointRefreshing = true;
			tsimple(5, function() rp.CapturePointRefreshing = false; end)
		end

		-- Spawn loot
		rp.SpawnLoot();
	end
end);
