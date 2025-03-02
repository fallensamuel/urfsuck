ba.AddTerm('EntityNoOwner', 'У данного предмета нет владельца.')
ba.AddTerm('CannotUnown', 'Вы не можете убрать владельца этой двери.')
ba.AddTerm('EntityOwnedBy', '# владелец данного предмета.')
ba.AddTerm('AdminUnownedYourDoor', '# убрал вас из владельцев двери.')
ba.AddTerm('AdminUnownedPlayerDoor', '# убрал # из владельцев двери.')
ba.AddTerm('AdminChangedYourJob', '# поменял вашу профессию на #.')
ba.AddTerm('AdminChangedPlayerJob', '# поменял профессию # на #.')
ba.AddTerm('AdminChangedYourModel', '# поменял вашу модель.')
ba.AddTerm('AdminChangedPlayerModel', '# поменял модель #.')
ba.AddTerm('JobNotFound', 'Профессия # не найдена!')
ba.AddTerm('AdminUnwantedYou', '# has force unwanted you.')
ba.AddTerm('AdminUnwantedPlayer', '# has force unwanted #.')
ba.AddTerm('PlayerNotWanted', '# не в розыске!')
ba.AddTerm('AdminUnarrestedYou', '# has force unarrested you.')
ba.AddTerm('AdminUnarrestedPlayer', '# has force unarrested #.')
ba.AddTerm('PlayerNotArrested', '# is not arrested!')
ba.AddTerm('AdminUnwarrantedYou', '# has force unwarranted you.')
ba.AddTerm('AdminUnwarrantedPlayer', '# has force unwarranted #.')
ba.AddTerm('PlayerNotWarranted', '# is not warranted!')
ba.AddTerm('EventInvalid', '# несуществующий ивент!')
ba.AddTerm('AdminStartedEvent', '# запустил ивент # на #.')
ba.AddTerm('AdminFrozePlayersProps', '# заморозил пропы #.')
ba.AddTerm('AdminFrozeAllProps', '# заморозил все пропы.')
ba.AddTerm('PlayerVoteInvalid', 'Нет голосований #!')
ba.AddTerm('AdminDeniedVote', '# отменил голосование #.')
ba.AddTerm('AdminDeniedTeamVote', '# отменил голосование #.')
ba.AddTerm('AdminAddedYourMoney', '# добавил $# в ваш кошелек.')
ba.AddTerm('AdminAddedMoney', 'Вы добавили $# в кошелек #.')
ba.AddTerm('AdminAddedYourCredits', '# добавил # кредитов на твой аккаунт.')
ba.AddTerm('AdminAddedCredits', '# выдал # кредитов #.')
ba.AddTerm('AdminMovedPlayers', 'Перемещено # игроков на другой сервер.')
ba.AddTerm('PlayerNotFound', '# не найден.')
ba.AddTerm('TargetCantJob', 'Профессия недоступна для игрока.')
ba.AddTerm('SetTimeCant', 'Кол-во часов не может быть меньше 0 или превышать ваше настоящее наигранное время.')
ba.AddTerm('SetTimeSuccess', 'Ваше время игры установлено на # часов!')

ba.AddTerm('NoobCreditsZero', 'Вы не можете выдать меньше #!')
ba.AddTerm('NoobCreditsExceedMax', 'В этом месяце вы можете выдать только #!')
ba.AddTerm('NoobCreditsExceedUser', 'В этом месяце вы можете выдать только # этому человеку!')
ba.AddTerm('NoobCreditsExceededMax', 'Вы уже выдали # в этом месяце!')
ba.AddTerm('NoobCreditsExceededUser', 'Вы уже выдали # # в этом месяце!')
ba.AddTerm('NoobCreditsGive', 'Вы выдали # #. В этом месяце можно выдать ещё # (# этому игроку).')

ba.cmd.Create('Set Time', function(pl, args)
	local new_time_hrs = tonumber(args.amount or 0)
	local new_time = math.floor(new_time_hrs) * 3600
	
	pl._ActualTime = pl._ActualTime or pl:GetPlayTime()
	
	if new_time < 0 or new_time > pl._ActualTime then
		ba.notify_err(pl, ba.Term('SetTimeCant'))
		return
	end
	
	pl:SetNetVar('PlayTime', new_time)
	ba.notify(pl, ba.Term('SetTimeSuccess'), new_time_hrs)
end)
:AddParam('string', 'amount')
:SetFlag('X')
:SetHelp('Temporary sets your playtime (in hours)')

ba.cmd.Create('Go', function(pl, args)
	local ent = pl:GetEyeTrace().Entity
	if IsValid(ent) and (ent:CPPIGetOwner() or ent.ItemOwner) then
		ba.notify(pl, ba.Term('EntityOwnedBy'), (ent:CPPIGetOwner() or ent.ItemOwner))
	else
		ba.notify_err(pl, ba.Term('EntityNoOwner'))
	end
end)
:SetFlag('U')
:SetHelp('Shows the owner of a prop')

ba.cmd.Create('Unown', function(pl, args)
	local ent = pl:GetEyeTrace().Entity
	if IsValid(ent) and ent:IsDoor() and ent:DoorGetOwner() then
		ba.notify(ent:DoorGetOwner(), ba.Term('AdminUnownedYourDoor'), pl)
		ba.notify_staff(ba.Term('AdminUnownedPlayerDoor'), pl, ent:DoorGetOwner())
		ent:DoorUnOwn()
	else
		ba.notify_err(pl, ba.Term('CannotUnown'))
	end
end)
:SetFlag('M')
:SetHelp('Force unowns a door')

ba.cmd.Create('Setjob', function(pl, args)
	for k, v in ipairs(rp.teams) do
		if string.find(v.name:lower(), args.name:lower()) then
			if !args.target:CanTeam(v) then
				ba.notify_err(pl, ba.Term('TargetCantJob'), args.name)
				return
			end
			ba.notify(args.target, ba.Term('AdminChangedYourJob'), pl, v.name)
			ba.notify_staff(ba.Term('AdminChangedPlayerJob'), pl, args.target, v.name)
			if not args.target:Alive() then
				args.target:Spawn()
			end
			args.target:ChangeTeam(k, true)
			args.target:Spawn()
			return
		end
	end
	ba.notify_err(pl, ba.Term('JobNotFound'), args.name)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'name')
:SetFlag('A')
:SetHelp('Forces a players job')

ba.cmd.Create('Forcesetjob', function(pl, args)
	for k, v in ipairs(rp.teams) do
		if string.find(v.name:lower(), args.name:lower()) then
			ba.notify(args.target, ba.Term('AdminChangedYourJob'), pl, v.name)
			ba.notify_staff(ba.Term('AdminChangedPlayerJob'), pl, args.target, v.name)
			if not args.target:Alive() then
				args.target:Spawn()
			end
			args.target:ChangeTeam(k, true)
			args.target:Spawn()
			return
		end
	end
	ba.notify_err(pl, ba.Term('JobNotFound'), args.name)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'name')
:SetFlag('C')
:SetHelp('Forces a players job ignoring unlock state')

ba.cmd.Create('Setmodel', function(pl, args)
	args.target:SetModel(args.model)
	ba.notify_staff(ba.Term('AdminChangedPlayerModel'), pl, args.target)
	ba.notify(args.target, ba.Term('AdminChangedYourModel'), pl)
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'model')
:SetFlag('C')
:SetHelp('Changes player model')

ba.cmd.Create('Force Unwant', function(pl, args)
	if args.target.IsWantedAnyFaction and args.target:IsWantedAnyFaction() or args.target:IsWanted() then
		ba.notify(args.target, ba.Term('AdminUnwantedYou'), pl)
		ba.notify_staff(ba.Term('AdminUnwantedPlayer'), pl, args.target)
		
		if args.target.UnWantedAllFactions then
			args.target:UnWantedAllFactions()
		else
			args.target:UnWanted(pl, false)
		end
	else
		ba.notify_err(pl, ba.Term('PlayerNotWanted'), args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag('A')
:SetHelp('Force unwants a player')
:AddAlias('funwant')

ba.cmd.Create('Force Unarrest', function(pl, args)
	if args.target:IsArrested() then
		ba.notify(args.target, ba.Term('AdminUnarrestedYou'), pl)
		ba.notify_staff(ba.Term('AdminUnarrestedPlayer'), pl, args.target)
		args.target:UnArrest(pl, false)
	else
		ba.notify_err(pl, ba.Term('PlayerNotArrested'), args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag('A')
:SetHelp('Force unarrests a player')
:AddAlias('funarrest')

ba.cmd.Create('Force UnWarrant', function(pl, args)
	if args.target:IsWarranted() then
		ba.notify(args.target, ba.Term('AdminUnwarrantedYou'), pl)
		ba.notify_staff(ba.Term('AdminUnwarrantedPlayer'), pl, args.target)
		args.target:UnWarrant(pl)
	else
		ba.notify_err(pl, ba.Term('PlayerNotWarranted'), args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag('A')
:SetHelp('Force unwants a player')
:AddAlias('funwarrant')

ba.cmd.Create('Start Event', function(pl, args)
	if IsValid(pl) and not pl:HasFlag('H') then return end
	
	local event = string.lower(args.event)
	if (rp.Events[event] == nil) then
		ba.notify_err(pl, ba.Term('EventInvalid'), event)
	else
		rp.StartEvent(event, args.time)
		ba.notify_all(ba.Term('AdminStartedEvent'), pl, event, args.raw.time)
	end
end)
:AddParam('string', 'event')
:AddParam('time', 'time')
:SetFlag('G')
:SetHelp('Starts and event')

ba.cmd.Create('Freeze Props', function(pl, args)
	if IsValid(args.target) then
		ba.notify_staff(ba.Term('AdminFrozePlayersProps'), pl, args.target)
		for k, v in ipairs(ents.GetAll()) do
	        if IsValid(v) and v:IsProp() and (v:CPPIGetOwner() == args.target) then
	            local phys = v:GetPhysicsObject()
	            if IsValid(phys) then
	                phys:EnableMotion(false)
	            end
	            constraint.RemoveAll(v)
	        end
	    end
	else
		ba.notify_staff(ba.Term('AdminFrozeAllProps'), pl)
		for k, v in ipairs(ents.GetAll()) do
	        if IsValid(v) and v:IsProp() then
	            local phys = v:GetPhysicsObject()
	            if IsValid(phys) then
	                phys:EnableMotion(false)
	            end
	            constraint.RemoveAll(v)
	        end
	    end
	end
end)
:AddParam('player_entity', 'target', 'optional')
:SetFlag('A')
:SetHelp('Freezes all props')

ba.cmd.Create('Deny Vote', function(pl, args)
	if (not rp.VoteExists(args.target)) then
		ba.notify_err(pl, ba.Term('PlayerVoteInvalid'), args.target)
	else
		GAMEMODE.vote.DestroyVotesWithEnt(args.target)
		ba.notify_staff(ba.Term('AdminDeniedVote'), pl, args.target)
	end
end)
:AddParam('player_entity', 'target')
:SetFlag('M')
:SetHelp('Denies a vote for the target')

ba.cmd.Create('Deny Team Vote', function(pl, args)
	if (!rp.teamVote.Votes[args.target]) then
		ba.notify_err(pl, ba.Term('PlayerVoteInvalid'), args.target)
	else
		rp.teamVote.Votes[args.target] = nil
		for k, v in ipairs(rp.teams) do
			if (v.name == args.target) then
				v.CurVote = nil
			end
		end
		ba.notify_staff(ba.Term('AdminDeniedTeamVote'), pl, args.target)
	end
end)
:AddParam('string', 'target')
:SetFlag('M')
:SetHelp('Denies a team vote')

ba.cmd.Create('Donate')
:RunOnClient(function()
	gui.OpenURL(rp.cfg.CreditsURL .. "?sid=" .. LocalPlayer():SteamID())
end)
:SetFlag('U')
:SetHelp('Opens our credit shop')
:AddAlias('shop')


local restricted = {
	['noob-diamondcontributor'] = true,
}

ba.cmd.Create('Add Money', function(pl, args)
	local real_amount = tonumber(args.amount)
	
	local function success(restricted_amount, restricted_amount_user)
		args.target:AddMoney(real_amount)
		
		ba.logAction(pl, args.target, 'addmoney', real_amount .. '')
		
		ba.notify(args.target, ba.Term('AdminAddedYourMoney'), pl, real_amount)
		
		if IsValid(pl) then
			if restricted_amount then
				ba.notify(pl, ba.Term('NoobCreditsGive'), rp.FormatMoney(real_amount), args.target, rp.FormatMoney(restricted_amount), rp.FormatMoney(restricted_amount_user))
			else
				ba.notify(pl, ba.Term('AdminAddedMoney'), real_amount, args.target)
			end
		end
	end
	
	if IsValid(pl) and (restricted[pl:GetRank()] or not pl:HasFlag('x')) then
		if real_amount <= 0 then
			ba.notify(pl, ba.Term('NoobCreditsZero'), rp.FormatMoney(1))
			return
		end
		
		local max_all = (rp.cfg.MaxNoobMoneyGive or 50) * rp.cfg.StartMoney
		local max_user = (rp.cfg.MaxNoobMoneyPerUser or 10) * rp.cfg.StartMoney
		
		--local estimated_month = '`Time` >= UNIX_TIMESTAMP(LAST_DAY(CURDATE()) + INTERVAL 1 DAY - INTERVAL 1 MONTH) AND `Time` < UNIX_TIMESTAMP(LAST_DAY(CURDATE()) + INTERVAL 1 DAY)'
		
		rp._Credits:Query('SELECT COALESCE(SUM(`value`), 0) AS `Money` FROM `ba_logs` WHERE `action` = "addmoney" AND `value` > 0 AND `initiator` = ' .. pl:SteamID64() .. ';', function(data)
			local restrict_summ = data and data[1] and data[1].Money or 0
			
			print('restrict_summ', restrict_summ)
			
			if restrict_summ >= max_all then
				ba.notify(pl, ba.Term('NoobCreditsExceededMax'), rp.FormatMoney(restrict_summ) .. ' / ' .. rp.FormatMoney(max_all))
				return
				
			elseif restrict_summ + real_amount > max_all then
				ba.notify(pl, ba.Term('NoobCreditsExceedMax'), rp.FormatMoney(max_all - restrict_summ))
				return
			end
			
			--rp._Credits:Query('SELECT COALESCE(SUM(`Change`), 0) AS `Credits` FROM `kshop_credits_transactions` WHERE `Note` LIKE "%' .. pl:SteamID() .. '%" AND `SteamID` = "' .. (ba.IsPlayer(args.target) and args.target:SteamID() or ba.InfoTo32(args.target)) .. '" AND `Change` > 0 AND ' .. estimated_month .. ';', function(data_user)
			
			
			rp._Credits:Query('SELECT COALESCE(SUM(`value`), 0) AS `Money` FROM `ba_logs` WHERE `action` = "addmoney" AND `value` > 0 AND `initiator` = ' .. pl:SteamID64() .. ' AND `target` = ' .. (ba.IsPlayer(args.target) and args.target:SteamID64() or ba.InfoTo64(args.target)) .. ';', function(data_user)
				local restrict_summ_user = data_user and data_user[1] and data_user[1].Money or 0
				
				print('restrict_summ_user', restrict_summ_user)
				
				if restrict_summ_user >= max_user then
					ba.notify(pl, ba.Term('NoobCreditsExceededUser'), args.target, rp.FormatMoney(restrict_summ_user) .. ' / ' .. rp.FormatMoney(max_user))
					return
					
				elseif restrict_summ_user + real_amount > max_user then
					ba.notify(pl, ba.Term('NoobCreditsExceedUser'), rp.FormatMoney(max_user - restrict_summ_user))
					return
				end
				
				success(max_all - restrict_summ - real_amount, max_user - restrict_summ_user - real_amount)
			end)
		end)
	else
		success()
	end
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'amount')
:SetFlag('f')
:SetHelp('Gives a player money')

ba.cmd.Create('Add Credits', function(pl, args)
	local real_amount = tonumber(args.amount)
	
	local function success(restricted_amount, restricted_amount_user)
		if ba.IsPlayer(args.target) then
			if real_amount < 0 then
				real_amount = -math.min(args.target:GetCredits(), -real_amount)
				args.target:AddCredits(real_amount, 'Given by ' .. (IsValid(pl) and pl:NameID() or 'Unknown'), function()
					ba.notify(args.target, ba.Term('AdminAddedYourCredits'), pl, real_amount)
				end)
			else
				args.target:AddCredits(real_amount, 'Given by ' .. (IsValid(pl) and pl:NameID() or 'Unknown'), function()
					ba.notify(args.target, ba.Term('AdminAddedYourCredits'), pl, real_amount)
				end)
			end
			
			if IsValid(pl) then
				if restricted_amount then
					ba.notify(pl, ba.Term('NoobCreditsGive'), real_amount .. ' кредитов', args.target, restricted_amount .. ' кредитов', restricted_amount_user .. ' кредитов')
				else
					ba.notify(pl, ba.Term('AdminAddedCredits'), pl, real_amount, args.target)
				end
			end
		else
			local steamid = ba.InfoTo32(args.target)
			
			if real_amount < 0 then
				rp._Credits:Query('SELECT COALESCE(SUM(`Change`), 0) AS `Credits` FROM `kshop_credits_transactions` WHERE `SteamID`="' .. steamid .. '";', function(data)
					local cur_amount = tonumber(data and data[1] and data[1]['Credits'] or 0) or 0
					real_amount = -math.min(cur_amount, -real_amount)
					
					rp.data.AddCredits(steamid, real_amount, 'Given by ' .. (IsValid(pl) and pl:NameID() or 'Unknown'))
					
					if IsValid(pl) then
						if restricted_amount then
							ba.notify(pl, ba.Term('NoobCreditsGive'), real_amount .. ' кредитов', args.target, restricted_amount .. ' кредитов', restricted_amount_user .. ' кредитов')
						else
							ba.notify(pl, ba.Term('AdminAddedCredits'), pl, real_amount, args.target)
						end
					end
				end)
			else
				rp.data.AddCredits(steamid, real_amount, 'Given by ' .. (IsValid(pl) and pl:NameID() or 'Unknown'))
				
				if IsValid(pl) then
					if restricted_amount then
						ba.notify(pl, ba.Term('NoobCreditsGive'), real_amount .. ' кредитов', args.target, restricted_amount .. ' кредитов', restricted_amount_user .. ' кредитов')
					else
						ba.notify(pl, ba.Term('AdminAddedCredits'), pl, real_amount, args.target)
					end
				end
			end
		end
		
		ba.logAction(pl, args.target, 'addcredits', real_amount)
	end
	
	if IsValid(pl) and (restricted[pl:GetRank()] or not pl:HasFlag('x')) then
		if real_amount <= 0 then
			ba.notify(pl, ba.Term('NoobCreditsZero'), '1 кредита')
			return
		end
		
		local max_all = rp.cfg.MaxNoobCreditsGive or 500
		local max_user = rp.cfg.MaxNoobCreditsPerUser or 100
		
		local estimated_month = '`Time` >= UNIX_TIMESTAMP(LAST_DAY(CURDATE()) + INTERVAL 1 DAY - INTERVAL 1 MONTH) AND `Time` < UNIX_TIMESTAMP(LAST_DAY(CURDATE()) + INTERVAL 1 DAY)'
		
		rp._Credits:Query('SELECT COALESCE(SUM(`Change`), 0) AS `Credits` FROM `kshop_credits_transactions` WHERE `Note` LIKE "%' .. pl:SteamID() .. '%" AND `Change` > 0 AND ' .. estimated_month .. ';', function(data)
			local restrict_summ = data and data[1] and data[1].Credits or 0
			
			if restrict_summ >= max_all then
				ba.notify(pl, ba.Term('NoobCreditsExceededMax'), restrict_summ .. ' / ' .. max_all .. ' кредитов')
				return
				
			elseif restrict_summ + real_amount > max_all then
				ba.notify(pl, ba.Term('NoobCreditsExceedMax'), (max_all - restrict_summ) .. ' кредитов')
				return
			end
			
			rp._Credits:Query('SELECT COALESCE(SUM(`Change`), 0) AS `Credits` FROM `kshop_credits_transactions` WHERE `Note` LIKE "%' .. pl:SteamID() .. '%" AND `SteamID` = "' .. (ba.IsPlayer(args.target) and args.target:SteamID() or ba.InfoTo32(args.target)) .. '" AND `Change` > 0 AND ' .. estimated_month .. ';', function(data_user)
				local restrict_summ_user = data_user and data_user[1] and data_user[1].Credits or 0
				
				if restrict_summ_user >= max_user then
					ba.notify(pl, ba.Term('NoobCreditsExceededUser'), args.target, (restrict_summ_user .. ' / ' .. max_user) .. ' кредитов')
					return
					
				elseif restrict_summ_user + real_amount > max_user then
					ba.notify(pl, ba.Term('NoobCreditsExceedUser'), (max_user - restrict_summ_user) .. ' кредитов')
					return
				end
				
				success(max_all - restrict_summ - real_amount, max_user - restrict_summ_user - real_amount)
			end)
		end)
	else
		success()
	end
end)
:AddParam('player_steamid', 'target')
:AddParam('string', 'amount')
:SetFlag('f')
:SetHelp('Gives a player credits')

if (SERVER) then util.AddNetworkString('Pocket.Inspect') end
ba.cmd.Create('View Pocket', function(pl, args)
	net.Start('Pocket.Inspect')
		net.WriteEntity(args.target)
		net.WriteTable(rp.inv.Data[args.target:SteamID64()] or {})
	net.Send(pl)
end)
:AddParam('player_entity', 'target')
:SetFlag('A')
:SetHelp('Displays the target\'s pocket contents on your screen')


local moveCmdCategories = {
	['afk'] = function(pl) return (pl:IsAFK()) end,
	['banned'] = function(pl) return pl:IsBanned() end,
	['dead'] = function(pl) return !pl:Alive() end,
	['all'] = function() return true end
}
ba.cmd.Create('Move', function(ply, args)
	local str = args["Category/Player/Evaluator"]
	local cat = str:lower()
	local eval
	
	if (moveCmdCategories[cat]) then
		eval = moveCmdCategories[cat]
		
		local count = 0
		for k, v in ipairs(player.GetAll()) do
			if (eval(v)) then
				count = count + 1
				
				v:SendLua([[LocalPlayer():ConCommand('connect ]] .. info.AltServerIP .. [[')]])
			end
		end
		
		ba.notify(ply, ba.Term('AdminMovedPlayers'), tostring(count))
	else
		local targ = ba.FindPlayer(str)
		
		if (targ) then
			targ:SendLua([[LocalPlayer():ConCommand('connect ]] .. info.AltServerIP .. [[')]])
			return
		else
			ba.notify(ply, ba.Term('PlayerNotFound'), str)
		end
	end
end)
:AddParam('string', 'Category/Player/Evaluator')
:SetFlag('*')
:SetHelp('Moves the given set of players to the other server. Categories: ' .. table.ConcatKeys(moveCmdCategories, ', ') .. '.')





ba.cmd.Create('setteam', function(ply, args)
	local n = tonumber(args.index)
	if n then
		args.index = n
	elseif isnumber(_G[args.index]) then
		args.index = _G[args.index]
	end

	if not rp.teams[args.index] then
		ba.notify_err(ply, ba.Term('JobNotFound'), args.index)
		return
	end

	if not args.target:Alive() then
		args.target:Spawn()
	end
	args.target:ChangeTeam(args.index, true)
	args.target:Spawn()
end)
:AddParam('player_entity', 'target')
:AddParam('string', 'index')
:SetFlag('*')
:SetHelp('Forces a players job ignoring unlock state')