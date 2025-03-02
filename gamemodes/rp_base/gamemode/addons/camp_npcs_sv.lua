
rp.cfg.NPCs = rp.cfg.NPCs[game.GetMap()] or {}

for k, v in pairs(ents.GetAll()) do
	if v.npcID then
		SafeRemoveEntity(v)
	end
end

for k, v in pairs(rp.cfg.NPCs) do
	v.respawnAt = 0
	v.ent = nil
	v.moveBack = 0
end

timer.Create("rp.RespawnNPCs", 1, 0, function()
	for k, v in pairs(rp.cfg.NPCs) do
		--print(v.moveBack - CurTime())
		if !IsValid(v.ent) then
			if v.respawnAt < CurTime() then
				local npc = ents.Create(v.npcs)
				
				if IsValid(npc) then
					npc:SetPos(v.pos)
					npc:SetAngles(v.ang || Angle(0, math.random(360), 0))
					npc:Spawn()
					if v.health then
						npc:SetHealth(v.health)
					end
					npc.npcID = k
					v.ent = npc
				end
			end
		elseif v.moveBack < CurTime() then
			if v.ent:GetPos():DistToSqr(v.pos) > 250000 then
				v.ent:MarkEnemyAsEluded()--NPC_STATE_IDLE)
				v.ent:SetLastPosition( v.pos )
				v.ent:SetSchedule( SCHED_FORCED_GO_RUN )
				v.moveBack = v.moveBack + 10
			else
				v.moveBack = 0
			end
		end
	end
end)

local npc_data 
hook.Add("OnNPCKilled", function(npc, attacker)
	if npc.npcID then
		npc_data = rp.cfg.NPCs[npc.npcID]
		npc_data.respawnAt = CurTime() + npc_data.respawnTime
		
		if npc_data.bounty then
			if npc_data.rewardAll then
				for k, v in pairs(ents.FindInSphere(npc:GetPos(), 1000)) do
					if v:IsPlayer() then
						v:AddMoney(npc_data.bounty)
						rp.Notify(v, NOTIFY_GENERIC, rp.Term('NPCKilled'), npc_data.bounty)
					end
				end
			elseif npc_data.rewardCustom then
				for k, v in pairs(ents.FindInSphere(npc:GetPos(), 1000)) do
					if IsValid(v) and v:IsPlayer() and npc_data.rewardCustom(v) then
						v:AddMoney(npc_data.bounty)
						rp.Notify(v, NOTIFY_GENERIC, rp.Term('NPCKilled'), npc_data.bounty)
					end
				end
			elseif attacker:IsPlayer() && attacker:GetPos():DistToSqr(npc:GetPos()) < 10000 then
				attacker:AddMoney(npc_data.bounty)
				rp.Notify(attacker, NOTIFY_GENERIC, rp.Term('NPCKilled'), npc_data.bounty)
			end
		end

		npc_data.ent = nil
	end
end)

hook.Add("EntityTakeDamage", function(npc, attacker)
	if !(npc:IsNPC() && npc.npcID) then return end

	npc_data = rp.cfg.NPCs[npc.npcID]
	npc_data.moveBack = CurTime() + 60
end)

--lua_run Entity(2378):SetLastPosition( Vector(1119, 3650, 128) ) Entity(2378):SetSchedule( SCHED_FORCED_GO_RUN )