local term = ba.logs.Term

-- Kills
ba.logs.AddTerm('Killed', '#(#) killed #(#) with # #', {
	'Attacker Name',
	'Attacker SteamID',
	[3] = 'Name',
	[4] = 'SteamID',
})

ba.logs.Create 'Kills'
	:SetColor(Color(200,0,0))
	:Hook('PlayerDeath', function(self, pl, ent, killer)
		if killer:IsPlayer() and not pl:IsBanned() then
			local w = killer.ForceAttacker4Log or killer:GetActiveWeapon()
			if w and w:IsValid() then
				wep = w:GetClass()
			else
				wep = "none"
			end	
			self:PlayerLog({pl, killer}, term('Killed'), killer:Name(), killer:SteamID(), pl:Name(), pl:SteamID(), wep, ((killer:InSpawn() or pl:InSpawn()) and ' in spawn' or '') .. ((killer:IsHitman() and pl:HasHit()) and ' for a hit' or ''))
		end
		//print(pl);
	end)
	:Hook('OnDamagedByExplosion', function(self, ply, dmg)
		if (ply:IsPlayer() and dmg:IsExplosionDamage() and !ply:Alive()) then
			local attacker = dmg:GetAttacker();
			local weapon = 'explosion'
			self:PlayerLog({pl, attacker}, term('Killed'), attacker:Name(), attacker:SteamID(), ply:Name(), ply:SteamID(), weapon, ((attacker:InSpawn() or ply:InSpawn()) and ' in spawn' or '') .. ((attacker:IsHitman() and ply:HasHit()) and ' for a hit' or ''))
		end
	end)

-- Damage to player & vehicle
ba.logs.AddTerm('VehicleDamage', '#(#) did # damage to # with #', {'Attacker Name', 'Attacker SteamID'})
ba.logs.AddTerm('VehicleDamageByEnt', '# did # damage to #', {})

ba.logs.AddTerm('Damage', '#(#) did # damage to #(#) with # #', {
	'Attacker Name',
	'Attacker SteamID',
	[4] = 'Name',
	[5] = 'SteamID',
})

ba.logs.Create 'Damage'
	:Hook('EntityTakeDamage', function(self, ent, dmginfo)
		local attacker = dmginfo:GetAttacker();

		if ent:IsPlayer() and attacker:IsPlayer() and not ent:IsBanned() then
			local w = attacker.ForceAttacker4Log or attacker:GetActiveWeapon()
			if w and w:IsValid() then
				wep = w:GetClass()
			else
				wep = "none"
			end	
			self:Log(term('Damage'), attacker:Name(), attacker:SteamID(), math.Round(dmginfo:GetDamage(), 0), ent:Name(), ent:SteamID(), wep, ((dmginfo:GetAttacker():InSpawn() or ent:InSpawn()) and ' in spawn ' or ''))
		elseif (ent:GetClass() == 'gmod_sent_vehicle_fphysics_base' and attacker:IsPlayer()) then
			local w = attacker.ForceAttacker4Log or attacker:GetActiveWeapon()
			if w and w:IsValid() then
				wep = w:GetClass()
			else
				wep = "none"
			end	
			self:Log(term('VehicleDamage'), attacker:Name(), attacker:SteamID(), math.Round(dmginfo:GetDamage(), 0), ('"' .. list.Get('simfphys_vehicles')[ent:GetSpawn_List()].Name .. '"') or ent:GetClass(), wep)
		else
			//print(ent, attacker, dmginfo)
		end
	end)

--[[
ba.logs.Create 'Vehicle Damage'
	:Hook('EntityTakeDamage', function(self, ent, dmginfo)
		local attacker = dmginfo:GetAttacker();
		if ent:GetClass() == 'gmod_sent_vehicle_fphysics_base' and attacker:IsPlayer() then
			local w = attacker:GetActiveWeapon()
			if w and w:IsValid() then
				wep = w:GetClass()
			else
				wep = "none"
			end	
			self:Log(term('VehicleDamage'), attacker:Name(), attacker:SteamID(), math.Round(dmginfo:GetDamage(), 0), ent:GetClass(), wep)
		elseif (ent:GetClass() == 'gmod_sent_vehicle_fphysics_base' and !attacker:IsPlayer()) then
			local Class = ent:GetClass() or 'no_vehicle_class';
			local Class2 = attacker:GetClass() or 'no_attacker_class';
			self:Log(term('VehicleDamageByEnt'), Class2, math.Round(dmginfo:GetDamage(), 0), ent:GetClass())
		end
	end)
--]]

-- Props
ba.logs.AddTerm('Prop', '#(#) spawned #', {
	'Name',
	'SteamID',
})

ba.logs.Create 'Props'
	:SetColor(Color(50,175,255))
	:Hook('PlayerSpawnProp', function(self, pl, mdl)
		if (not pl:IsBanned()) and (not pl:IsJailed()) and (not pl.SpawningDupeProp) then 
			self:PlayerLog(pl, term('Prop'), pl:Name(), pl:SteamID(), mdl)
		end
	end)

-- Dupes
ba.logs.AddTerm('Dupe', '#(#) spawned a dupe with # entities and # constraints', {
	'Name',
	'SteamID',
})

ba.logs.Create 'Dupes'
	:SetColor(Color(153,102,255))
	:Hook('PlayerSpawnDupe', function(self, pl, file, ents, constraints)
		self:PlayerLog(pl, term('Dupe'), pl:Name(), pl:SteamID(), #ents, #constraints)
	end)


-- Tools
ba.logs.AddTerm('Tool', '#(#) tooled # owned by #(#) with #', {
	'Name',
	'SteamID',
})

ba.logs.Create 'Tools'
	:Hook('PlayerToolEntity', function(self, pl, ent, tool)
		if IsValid(ent) then
			if IsValid(ent:CPPIGetOwner()) then
				self:PlayerLog(pl, term('Tool'), pl:Name(), pl:SteamID(), ent:GetClass(), ent:CPPIGetOwner():Name(), ent:CPPIGetOwner():SteamID(), tool)
			else
				self:PlayerLog(pl, term('Tool'), pl:Name(), pl:SteamID(), ent:GetClass(), 'Unknown', 'STEAM:0:0', tool)
			end
		end
	end)


-- Physgun
ba.logs.AddTerm('Physgun', '#(#) physgunned # owned by #(#)', {
	'Name',
	'SteamID',
})

ba.logs.Create('Physgun', false)
	:Hook('PlayerPhysgunEntity', function(self, pl, ent)
		if IsValid(ent:CPPIGetOwner()) then
			self:PlayerLog(pl, term('Physgun'), pl:Name(), pl:SteamID(), ent:GetClass(), ent:CPPIGetOwner():Name(), ent:CPPIGetOwner():SteamID(), tool)
		else
			self:PlayerLog(pl, term('Physgun'), pl:Name(), pl:SteamID(), ent:GetClass(), 'Unknown', 'STEAM:0:0', tool)
		end
	end)


-- Actions
ba.logs.AddTerm('RunRPCommand', '#(#) ran # #', {
	'Name',
	'SteamID',
})

ba.logs.Create 'RP Commands'
	:Hook('PlayerRunRPCommand', function(self, pl, cmd, args, arg_str)
		if (cmd ~= '/weaponcolor') and (cmd ~= '/playercolor') then
			self:PlayerLog(pl, term('RunRPCommand'), pl:Name(), pl:SteamID(), cmd, arg_str)
		end
	end)
	

-- Transactions
ba.logs.AddTerm('DropMoney', '#(#) dropped $# (New wallet: $#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('PickupMoney', '#(#) picked up $# (New wallet: $#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('DropCheck', '#(#) dropped a check to #(#) for $# (New wallet: $#)', {
	'Name',
	'SteamID',
	'Target Name',
	'Target SteamID'
})

ba.logs.AddTerm('PickupCheck', '#(#) picked up a check from #(#) for $# (New wallet: $#)', {
	'Name',
	'SteamID',
	'Giver Name',
	'Giver SteamID'
})

ba.logs.AddTerm('VoideCheck', '#(#) voided their check to #(#) for $# (New wallet: $#)', {
	'Name',
	'SteamID',
	'Target Name',
	'Target SteamID'
})

ba.logs.AddTerm('BuyItem', '#(#) bought # for $# (New wallet: $#)', {
	'Name',
	'SteamID',
})

ba.logs.Create 'Money History'
	:Hook('PlayerDropRPMoney', function(self, pl, amt, newcash)
		self:PlayerLog(pl, term('DropMoney'), pl:Name(), pl:SteamID(), amt, newcash)
	end)
	:Hook('PlayerPickupRPMoney', function(self, pl, amt, newcash)
		self:PlayerLog(pl, term('PickupMoney'), pl:Name(), pl:SteamID(), amt, newcash)
	end)
	:Hook('PlayerDropRPCheck', function(self, pl, topl, amt, newcash)
		self:PlayerLog(pl, term('DropCheck'), pl:Name(), pl:SteamID(), topl:Name(), topl:SteamID(), amt, newcash)
	end)
	:Hook('PlayerPickupRPCheck', function(self, pl, frompl, amt, newcash)
		self:PlayerLog(pl, term('PickupCheck'), pl:Name(), pl:SteamID(), frompl:Name(), frompl:SteamID(), amt, newcash)
	end)
	:Hook('PlayerVoidedRPCheck', function(self, pl, topl, amt, newcash)
		self:PlayerLog(pl, term('VoideCheck'), pl:Name(), pl:SteamID(), topl:Name(), topl:SteamID(), amt, newcash)
	end)
	:Hook('PlayerBoughtItem', function(self, pl, item, amt, newcash)
		self:PlayerLog(pl, term('BuyItem'), pl:Name(), pl:SteamID(), item, amt, newcash)
	end)
	

-- Police
ba.logs.AddTerm('Warranted', '#(#) warranted #(#) for #', {
	'Officer Name',
	'Officer SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('UnWarranted', '#(#) unwarranted #(#)', {
	'Officer Name',
	'Officer SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('Wanted', '#(#) wanted #(#) for #', {
	'Officer Name',
	'Officer SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('UnWanted', '#(#) unwarranted #(#)', {
	'Officer Name',
	'Officer SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('Arrested', '#(#) arrested #(#)', {
	'Officer Name',
	'Officer SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('UnArrested', '#(#) unarrested #(#)', {
	'Officer Name',
	'Officer SteamID',
	'Name',
	'SteamID',
})

ba.logs.Create 'Police'
	:SetColor(Color(20,0,255))
	:Hook('PlayerWarranted', function(self, pl, actor, reason)
		if IsValid(actor) then
			self:PlayerLog({pl, actor}, term('Warranted'), actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID(), reason)
		end
	end)
	:Hook('PlayerUnWarranted', function(self, pl, actor)
		if IsValid(actor) then
			self:PlayerLog({pl, actor}, term('UnWarranted'), actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID())
		end
	end)
	:Hook('PlayerWanted', function(self, pl, actor, reason)
		if IsValid(actor) then
			self:PlayerLog({pl, actor}, term('Wanted'), actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID(), reason)
		end
	end)
	:Hook('PlayerUnwanted', function(self, pl, actor, reason)
		if IsValid(actor) then
			self:PlayerLog({pl, actor}, term('UnWanted'), actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID())
		end
	end)
	:Hook('PlayerArrested', function(self, pl, actor, reason)
		if IsValid(actor) then
			self:PlayerLog({pl, actor}, term('Arrested'), actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID())
		end
	end)
	:Hook('PlayerUnArrested', function(self, pl, actor, reason)
		if IsValid(actor) then
			self:PlayerLog({pl, actor}, term('UnArrested'), actor:Name(), actor:SteamID(), pl:Name(), pl:SteamID())
		end
	end)


-- Mayor
ba.logs.AddTerm('StartLotto', '#(#) has started a lottery', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('StartLockdown', '#(#) has started a lockdown', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('EndLockdown', '#(#) has ended a lockdown', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('ChangeLaws', '#(#) has changed the laws', {
	'Name',
	'SteamID',
})

ba.logs.Create 'Mayor'
	:SetColor(Color(200,0,0))
	:Hook('lotteryStarted', function(self, pl)
		if IsValid(pl) then
			self:PlayerLog(pl, term('StartLotto'), pl:Name(), pl:SteamID())
		end
	end)
	:Hook('LockdownStarted', function(self, pl)
		if IsValid(pl) then
			self:PlayerLog(pl, term('StartLockdown'), pl:Name() || 'console', pl:SteamID())
		end
	end)
	:Hook('LockdownEnded', function(self, pl)
		if IsValid(pl) then
			self:PlayerLog(pl, term('EndLockdown'), pl:Name() || 'console', pl:SteamID())
		end
	end)
	:Hook('mayorSetLaws', function(self, pl)
		if IsValid(pl) then
			self:PlayerLog(pl, term('ChangeLaws'), pl:Name(), pl:SteamID())
		end
	end)
	:Hook('mayorResetLaws', function(self, pl)
		if IsValid(pl) then
			self:PlayerLog(pl, term('ChangeLaws'), pl:Name(), pl:SteamID())
		end
	end)


-- Hit logs
ba.logs.AddTerm('RequestHit', '#(#) requested a hit on #(#)', {
	'Requester Name',
	'Requester SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('CompleteHit', '#(#) completed a hit on #(#)', {
	'Hitman Name',
	'Hitman SteamID',
	'Name',
	'SteamID',
})

ba.logs.Create 'Hits'
	:SetColor(Color(204,204,0))
	:Hook('playerRequestedHit', function(self, pl, target)
		self:PlayerLog({pl, target}, term('RequestHit'), pl:Name(), pl:SteamID(), target:Name(), target:SteamID())
	end)
	:Hook('playerCompletedHit', function(self, pl, target)
		self:PlayerLog({pl, target}, term('CompleteHit'), pl:Name(), pl:SteamID(), target:Name(), target:SteamID())
	end)


-- RP
ba.logs.AddTerm('ChangeName', '#(#) changed their RP name to "#"', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('DemotePlayer', '#(#) has started a demotion vote on #(#) for "#"', {
	'Demoter Name',
	'Demoter SteamID',
	'Name',
	'SteamID',
})

ba.logs.AddTerm('Disguise', '#(#) has disguised as a # from a #', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('Chnage', '#(#) has changed jobs to # from a #', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('HirePlayer', '#(#) has hired #(#)', {
	'Name',
	'SteamID',
	'Employee Name',
	'Employee SteamID',
})

ba.logs.AddTerm('Bailed', '#(#) has bailed #(#) for $#', {
	'Name',
	'SteamID',
	'Target Name',
	'Target SteamID',
})

ba.logs.Create 'Roleplay'
	:SetColor(Color(100,50,20))
	:Hook('playerChangedRPName', function(self, pl, newname)
		self:PlayerLog(pl, term('ChangeName'), pl:Name(), pl:SteamID(), newname)
	end)
	:Hook('playerDemotePlayer', function(self,  pl, target, reason)
		self:PlayerLog({pl, target}, term('DemotePlayer'), pl:Name(), pl:SteamID(), target:Name(), target:SteamID(), reason)
	end)
	:Hook('playerDisguised', function(self, pl, oldt, newt)
		self:PlayerLog(pl, term('Disguise'), pl:Name(), pl:SteamID(), team.GetName(newt), team.GetName(oldt))
	end)
	:Hook('OnPlayerChangedTeam', function(self, pl, oldt, newt)
		self:PlayerLog(pl, term('Chnage'), pl:Name(), pl:SteamID(), team.GetName(newt), team.GetName(oldt))
	end)
	:Hook('PlayerHirePlayer', function(self, employer, employee)
		self:PlayerLog({employer, employer}, term('HirePlayer'), employer:Name(), employer:SteamID(), employee:Name(), employee:SteamID())
	end)
	:Hook('PlayerBailPlayer', function(self, pl, targ, cost)
		self:PlayerLog({pl, targ}, term('Bailed'), pl:Name(), pl:SteamID(), targ:Name(), targ:SteamID(), cost)
	end)


-- NLR
ba.logs.AddTerm('EnterNLR', '#(#) entered an NLR zone with # seconds left', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('ExitNLR', '#(#) left an NLR zone with # seconds left', {
	'Name',
	'SteamID',
})


ba.logs.Create 'NLR'
	:SetColor(Color(255,100,0))
	:Hook('PlayerEnterNLRZone', function(self, pl, time)
		self:PlayerLog(pl, term('EnterNLR'), pl:Name(), pl:SteamID(), math.Round(time, 0))
	end)
	:Hook('PlayerLeaveNLRZone', function(self, pl, time)
		self:PlayerLog(pl, term('ExitNLR'), pl:Name(), pl:SteamID(), math.Round(time, 0))
	end)


-- Raid
ba.logs.AddTerm('PlaceC4', '#(#) placed a c4 on #', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('PlaceC4On', '#(#) placed a c4 on # owned by #(#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('DropC4', '#(#) dropped a c4', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('StartKeypadCrack', '#(#) started cracking a keypad owned by #(#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('FinishKeypadCrack', '#(#) finished cracking a keypad owned by #(#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('StartLockpickOwner', '#(#) started lockpicking a door owned by #(#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('StartLockpickGroup', '#(#) started lockpicking a door owned by #', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('FinishLockpickOwner', '#(#) finished lockpicking a door owned by #(#)', {
	'Name',
	'SteamID',
})

ba.logs.AddTerm('FinishLockpickGroup', '#(#) finished lockpicking a door owned by #', {
	'Name',
	'SteamID',
})


ba.logs.Create 'Raids'
	:Hook('PlayerPlaceC4', function(self, pl, ent)
		if IsValid(ent) then
			local owner = ent:CPPIGetOwner() or ent.ItemOwner or ent:DoorGetOwner()
			if IsValid(owner) then
				self:PlayerLog(pl, term('PlaceC4On'), pl:Name(), pl:SteamID(), ent:GetClass(), owner:Name(), owner:SteamID())
			else
				self:PlayerLog(pl, term('PlaceC4'), pl:Name(), pl:SteamID(), ent:GetClass())
			end
		else
			self:PlayerLog(pl, term('DropC4'), pl:Name(), pl:SteamID())
		end
	end)

	:Hook('PlayerStartKeypadCrack', function(self, pl, ent)
		if ent:GetClass() == "keypad" or ent:GetClass() == "keypad_wire" then
			self:PlayerLog(pl, term('StartKeypadCrack'), pl:Name(), pl:SteamID(), ent:CPPIGetOwner():Name(), ent:CPPIGetOwner():SteamID())
		end
	end)
	:Hook('PlayerFinishKeypadCrack', function(self, pl, ent)
		self:PlayerLog(pl, term('FinishKeypadCrack'), pl:Name(), pl:SteamID(), ent:CPPIGetOwner():Name(), ent:CPPIGetOwner():SteamID())
	end)

	:Hook('PlayerStartLockpicking', function(self, pl, ent)
		if IsValid(ent:DoorGetOwner()) then
			self:PlayerLog(pl, term('StartLockpickOwner'), pl:Name(), pl:SteamID(), ent:DoorGetOwner():Name(), ent:DoorGetOwner():SteamID())
		else
			self:PlayerLog(pl, term('StartLockpickGroup'), pl:Name(), pl:SteamID(), (ent:DoorGetGroup() or team.GetName(ent:DoorGetTeam())))
		end
	end)
	:Hook('PlayerFinishLockpicking', function(self, pl, ent)
		if IsValid(ent:DoorGetOwner()) then
			self:PlayerLog(pl, term('FinishLockpickOwner'), pl:Name(), pl:SteamID(), ent:DoorGetOwner():Name(), ent:DoorGetOwner():SteamID())
		else
			self:PlayerLog(pl, term('FinishLockpickGroup'), pl:Name(), pl:SteamID(), (ent:DoorGetGroup() or team.GetName(ent:DoorGetTeam())))
		end
	end)