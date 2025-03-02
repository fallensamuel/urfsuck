
util.AddNetworkString('NpcController::WaitForLoot')

rp.npc.ChangeRelations = function(ply, npc)
	if not IsValid(npc) or not IsValid(ply) then return end
	
	local data = rp.npc.Templates[npc:GetClass()]
	
	if data and data.relation_filter then
		if data.relation_filter(ply) then
			if npc.IsVJBaseSNPC then
				if npc:GetEnemy() == ply then 
					npc.ResetedEnemy = true
					npc:ResetEnemy(false)
				end

				ply.VJ_NoTarget = true
				npc:AddEntityRelationship(ply, D_LI, 999) 
				
				npc.DisableSelectSchedule = nil
				
			else
				npc:AddEntityRelationship(ply, D_NU, 999)
			end
			
			--print('NpcController::ChangeRelation', npc, ply, 'neutral') 
		else
			if npc.IsVJBaseSNPC then
				if npc.FollowingPlayer == true && npc.FollowPlayer_Entity == ply then npc:FollowPlayerReset() end
				
				ply.VJ_NoTarget = nil
				npc.DisableSelectSchedule = nil
				
				npc.VJ_AddCertainEntityAsEnemy[#npc.VJ_AddCertainEntityAsEnemy+1] = ply
				npc:AddEntityRelationship(ply, D_HT, 999)
				npc.TakingCoverT = CurTime() + 2
				
				if !IsValid(npc:GetEnemy()) then
					npc:StopMoving()
					npc:SetTarget(ply)
					npc:VJ_TASK_FACE_X("TASK_FACE_TARGET")
				end
				
				--npc:PlaySoundSystem("BecomeEnemyToPlayer")
				
			else
				npc:AddEntityRelationship(ply, D_HT, 999)
			end
			
			--print('NpcController::ChangeRelation', npc, ply, 'hate') 
		end
	end
end

rp.npc.ChangeAllRelations = function(ply)
	local garbage_collect = false
	
	for k, v in pairs(rp.npc.Entities) do
		if not IsValid(v) then
			garbage_collect = true
			continue
		end
		
		rp.npc.ChangeRelations(ply, v)
	end
	
	if garbage_collect then
		local k = 1
		
		while k <= #rp.npc.Entities do
			if IsValid(rp.npc.Entities[k]) then
				k = k + 1
			else
				table.remove(rp.npc.Entities, k)
			end
		end
	end
end

rp.npc.RegisterEntity = function(npc, kill_callback, raid_type)
	if not IsValid(npc) then return end
	
	local data = rp.npc.Templates[npc:GetClass()]
	
	if data then
		npc.Controlled = true
		npc.KillCallback = kill_callback or function() end
		
		npc.RaidType = raid_type
		
		if data.health_custom then
			local hp = data.health_custom(player.GetCount(), raid_type)
			
			npc:SetMaxHealth(hp)
			npc:SetHealth(hp)
			
		elseif data.health then
			npc:SetMaxHealth(data.health)
			npc:SetHealth(data.health)
		end
		
		if data.weapon then
			npc:Give(data.weapon)
		end
		
		if data.skin then
			if isnumber(data.skin) then
				npc:SetSkin(data.skin)
				
			elseif istable(data.skin) and raid_type then
				npc:SetSkin(data.skin[raid_type] or 1)
			end
		end
		
		for k, v in pairs(player.GetAll()) do
			rp.npc.ChangeRelations(v, npc)
		end
		
		--print('NpcController::RegisteredEntity', npc) 
		table.insert(rp.npc.Entities, npc)
		
		--print('IsVJBaseSNPC', npc.IsVJBaseSNPC)
		
		if npc.IsVJBaseSNPC then
			npc.BecomeEnemyToPlayer = false
			npc.Behavior = VJ_BEHAVIOR_AGGRESSIVE
			npc.DisableTakeDamageFindEnemy = false
			
			npc.CustomOnDamageByPlayer = function(self, dmginfo, hitgroup)
				--print(dmginfo:GetAttacker(), self)
				
				if IsValid(dmginfo:GetAttacker()) and dmginfo:GetAttacker():IsPlayer() and data.relation_filter and not data.relation_filter(dmginfo:GetAttacker()) then
					dmginfo:GetAttacker().VJ_NoTarget = nil
					
					if !IsValid(self:GetEnemy()) then
						self.DisableSelectSchedule = nil
					end
				end
			end
			
			--print('With patrols?', data.patrol_poses)
			
			if data.patrol_poses then
				npc:ClearSchedule()
				
				npc.cur_node = npc.cur_node or 1
				npc.goto_next_root = function(self)
					self.cur_node = self.cur_node + 1
					
					if self.cur_node > #data.patrol_poses then
						self.cur_node = 1
					end
					
					self:SetLastPosition(data.patrol_poses[self.cur_node]) 
					self:VJ_TASK_GOTO_LASTPOS(nil, function(shed)
						shed.RunCode_OnFinish = goto_next_root
					end)
				end

				npc.DisableSelectSchedule = true
				npc:SetLastPosition(data.patrol_poses[npc.cur_node]) 
				npc:VJ_TASK_GOTO_LASTPOS(nil, function(shed)
					shed.RunCode_OnFinish = goto_next_root
				end)

				npc.ScheduleFinished = function(self)
					if !IsValid(self:GetEnemy()) then
						self:goto_next_root()
					end
				end
			end
		end
	end
end

rp.npc.CreateLoot = function(ply, ent, is_instant)
	local steamid = ply:SteamID64()
	
	local gener_loot = rp.GenerateLoot(ent.GeneratedLootCount, ent.GeneratedLootType)
	local time_loading = table.Count(gener_loot) * (is_instant and 0.1 or 0.5) + 1
	
	if not is_instant then
		net.Start('NpcController::WaitForLoot')
			net.WriteFloat(ent.LoadingLoot[steamid] or (CurTime() + time_loading))
			net.WriteFloat(time_loading)
		net.Send(ply)
	end
	
	if not ent.LoadingLoot[steamid] then
		ent.LoadingLoot[steamid] = CurTime() + time_loading
		ent.LoadingLootTime[steamid] = time_loading
		
		rp.item.newInv(steamid, 'npc_loot', 5, 5, function(inventory)
			if not IsValid(ent) or not IsValid(ply) then
				return
			end
			
			inventory.entity = ent
			inventory.vars.isBag = 'npc_loot'
			
			for k, v in pairs(gener_loot) do
				timer.Simple(k * 0.1, function()
					inventory:add(v.uniqueID)
				end)
			end
			
			timer.Simple(time_loading, function()
				if not IsValid(ent) then return end
				
				ent.LoadingLoot[steamid] = nil
				ent.StoredLoot[steamid] = inventory
				
				if IsValid(ply) and not is_instant then
					--print('NpcController::SendLoot - Loaded!')
					netstream.Start(ply, "rpOpenBag", inventory:getID())
				end
			end)
		end)
	end
end

/*
hook.Add("OnEntityCreated", "InitNPCTemplates", function(ent)
	if IsValid(ent) == false then rp.npc.RegisterEntity(ent) end
end)
*/

hook.Add("ConfigLoaded", "LoadNpcControll", function()
	if table.Count(rp.npc.Templates) > 0 then
		RunConsoleCommand('ai_serverragdolls', '1')
	end
end)

hook.Add('InitPostEntity', 'NpcController::Setup', function()
	for k, v in pairs(rp.cfg.Raids or {}) do
		if not v.btn_name then continue end
		
		local btn = ents.FindByName(v.btn_name)[1]
		if IsValid(btn) then
			btn._BlockBtnPress = true
		end
	end
end)

hook.Add('OnPlayerChangedTeam', 'NpcController::ChangeRelations', function(ply)
	rp.npc.ChangeAllRelations(ply)
end)

hook.Add('playerDisguised', 'NpcController::ChangeRelations', function(ply)
	rp.npc.ChangeAllRelations(ply)
end)

hook.Add('EntityTakeDamage', 'NpcController::ChangeDamage', function(target, dmginfo)
	local attacker = dmginfo:GetAttacker()
	
	if target:IsNPC() and target.Controlled then
		if IsValid(attacker) and attacker:IsPlayer() and target:Disposition(attacker) ~= D_HT then
			dmginfo:ScaleDamage(0)
		end
		
		if rp.npc.Templates[target:GetClass()].damage_filter then
			rp.npc.Templates[target:GetClass()].damage_filter(target, dmginfo)
		end
		
	elseif target:IsPlayer() then
		if IsValid(attacker) and attacker:IsNPC() and attacker.Controlled then
			local data = rp.npc.Templates[attacker:GetClass()]
			
			if data then
				if data.damage_multiplier_custom then
					local dmg_mult = data.damage_multiplier_custom(player.GetCount(), attacker.RaidType)
					dmginfo:ScaleDamage(dmg_mult)
				
				else
					dmginfo:ScaleDamage(data.damage_multiplier or 1)
				end
			end
		end
	end
end)

hook.Add('OnNPCKilled', 'NpcController::RewardControl', function(npc, killer)
	if npc.Controlled then
		local data = rp.npc.Templates[npc:GetClass()]
		
		if data.reward_money then
			local reward_money = npc.RaidType and istable(data.reward_money) and (data.reward_money[npc.RaidType] or data.reward_money.default) or data.reward_money
			
			if data.reward_radius then
				local sqr_radius = data.reward_radius * data.reward_radius
				
				for k, v in pairs(player.GetAll()) do
					if IsValid(v) and v:Alive() and v:GetPos():DistToSqr(npc:GetPos()) <= sqr_radius then
						v:AddMoney(reward_money)
						rp.Notify(v, NOTIFY_GREEN, rp.Term('CaptureRewardsBox.GiveMoney'), rp.FormatMoney(reward_money))
					end
				end
				
			elseif killer:IsPlayer() then
				killer:AddMoney(reward_money)
				rp.Notify(killer, NOTIFY_GREEN, rp.Term('CaptureRewardsBox.GiveMoney'), rp.FormatMoney(reward_money))
			end
		end
		
		npc.Killer = killer
		npc:KillCallback()
	end
end)

hook.Add('CreateEntityRagdoll', 'NpcController::LootControl', function(npc, ragdoll)
	ragdoll.NpcControllerSee = true

	if IsValid(npc) and npc.Controlled then
		local data = rp.npc.Templates[npc:GetClass()]
		
		if data.loot then
			timer.Simple(4, function()
				if not IsValid(ragdoll) then return end
				ragdoll:DropToFloor()
				local phys = ragdoll:GetPhysicsObject()
				ragdoll:SetCollisionGroup(COLLISION_GROUP_WORLD)
				
				if IsValid(phys) then
					for i = 1, ragdoll:GetPhysicsObjectCount() do
						local phys = ragdoll:GetPhysicsObjectNum(i)
						
						if IsValid(phys) then
							phys:EnableMotion(false)
						end
					end
				end
			end)
			
			local loot_table = npc.RaidType and istable(data.loot) and (data.loot[npc.RaidType] or data.loot.default) or {
				type = data.loot,
				count = data.loot_count,
				time = data.loot_time,
			}
			
			ragdoll.WasNpcControlled = true
			ragdoll:SetUseType( SIMPLE_USE )
			
			ragdoll.StoredLoot = {}
			ragdoll.LoadingLoot = {}
			ragdoll.LoadingLootTime = {}
			
			ragdoll.IsPersonal = data.loot_is_personal
			
			ragdoll.GeneratedLootCount = loot_table.count
			ragdoll.GeneratedLootType = loot_table.type
			
			timer.Simple(loot_table.time or 60, function()
				if IsValid(ragdoll) then
					SafeRemoveEntity(ragdoll)
				end
			end)
			
			if data.loot_is_personal then
				ragdoll.Killer = npc.Killer
				rp.npc.CreateLoot(npc.Killer, ragdoll, true)
			end
			
			ragdoll:SetNetworkedInt('TimeLeft', math.ceil(CurTime()) + (loot_table.time or 60))
		else
			SafeRemoveEntity(ragdoll)
		end
	else
		SafeRemoveEntity(ragdoll)
	end
end)

-- lua_run for k,v in pairs(ents.GetAll())do if IsValid(v)and v:IsRagdoll()then print(v)v:Remove() end end
hook.Add("OnEntityCreated", "NpcController::startControlled", function(ent)
	if IsValid(ent) and (rp.npc.Templates[ent:GetClass()] or {}).startControlled then
		timer.Simple(0.1, function()
			if IsValid(ent) then rp.npc.RegisterEntity(ent) end
		end)
	elseif ent:IsRagdoll() then
		timer.Simple(1, function()
			if IsValid(ent) and not ent.NpcControllerSee then
				SafeRemoveEntity(ent)
			end
		end)
	end
end)

hook.Add('PlayerUse', 'NpcController::LootControl', function(ply, ent)
	if IsValid(ent) and ent._BlockBtnPress then return false end

	local steamid = ply:SteamID64()
	
	if IsValid(ent) and ent.WasNpcControlled and (not ent['LastUse' .. steamid] or ent['LastUse' .. steamid] < CurTime()) then
		ent['LastUse' .. steamid] = CurTime() + 1
		
		if ent.IsPersonal and ent.Killer ~= ply then
			if IsValid(ent.Killer) then
				rp.Notify(ply, NOTIFY_ERROR, rp.Term('NpcController::PersonalLoot'), translates.Get('игроку ' .. ent.Killer:Name()))
				
			else
				rp.Notify(ply, NOTIFY_ERROR, rp.Term('NpcController::PersonalLoot'), translates.Get('не вам'))
			end
			
			return
		end
		
		if not ent.StoredLoot[steamid] then
			--print('NpcController::StartLoading')
			
			if ent.LoadingLoot[steamid] and ent.LoadingLoot[steamid] > CurTime() then
				net.Start('NpcController::WaitForLoot')
					net.WriteFloat(ent.LoadingLoot[steamid] or (CurTime() + ent.LoadingLootTime[steamid]))
					net.WriteFloat(ent.LoadingLootTime[steamid])
				net.Send(ply)
				
			else
				rp.npc.CreateLoot(ply, ent, ent.IsPersonal)
			end
			
		else
			--print('NpcController::SendLoot - Already loaded!')
			netstream.Start(ply, "rpOpenBag", ent.StoredLoot[steamid]:getID())
		end
	end
end)