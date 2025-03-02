
if not rp.cfg.Arena then return end

rp.Arena = rp.Arena or {}

local function notify_players(players, notify, ...)
	for k, v in pairs(istable(players) and players or {players}) do
		rp.Notify(v, NOTIFY_GENERIC, rp.Term(notify), ...)
	end
end

local function change_job(ply, job)
	local prevTeam = ply:Team()
	
	if prone and prone.Exit then
		prone.Exit(ply, true)
	end

	if ply:GetNetVar("HasGunlicense") then
		ply:SetNetVar("HasGunlicense", nil)
	end

	net.Start('EmoteActions.SetupModel')
	net.Send(ply)
	
	ply:RemoveAllHighs()
	ply.PlayerModel = nil
	ply.LastJob = CurTime()

	if (ply:GetNetVar('job') ~= nil) then
		ply:SetNetVar('job', nil)
	end

	ply:SetVar('lastpayday', CurTime() + 180, false, false)
	ply:SetTeam(job)
	hook.Call("OnPlayerChangedTeam", GAMEMODE, ply, prevTeam, job)

	if ply:InVehicle() then
		ply:ExitVehicle()
	end

	ply:KillSilent()
	
	gamemode.Call( "PlayerSetModel", ply );
	ply:UpdateAppearance();

	net.Start("rp.OnTeamChanged")
		net.WriteUInt(prevTeam, 32)
	net.Send(ply)
end

local function setup_player(ply, job)
	ply.PA_job = ply:Team()
	ply.PA_weps = {}
	
	local inv = ply:getInv();
	local not_save = {}
	
	if inv and inv.getItems then
		for _, v in pairs( inv:getItems() ) do
			if v.isWeapon and v:getData("equip") then
				local wep = ply:GetWeapon(v.class)
				
				if IsValid(wep) then
					v:setData("equip", false, ply)
					not_save[wep:GetClass()] = true
					--if not ply:IsBot() then
					--	PrintTable(not_save)
					--	print('ignoring', wep:GetClass())
					--end
					ply:StripWeapon(wep:GetClass())
					wep:Remove()
				end
			end
		end
	end
	
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('ArenaStarted'))
	
	for _, wep in pairs(ply:GetWeapons()) do
		if not not_save[wep:GetClass()] then
			--if not ply:IsBot() then
			--	print('Saving', wep:GetClass())
			--end
			table.insert(ply.PA_weps, wep:GetClass())
		end
	end
	
	ply.PA_hp = ply:Health()
	ply.PA_armor = ply:Armor()
	
	change_job(ply, job)
	
	--ply:ChangeTeam(job, true, true)
	ply:Spawn()
	
	timer.Simple(0, function()
		ply:StripWeapons()
		
		for k, v in pairs(rp.teams[job].weapons) do
			ply:Give(v)
		end
	end)
end

local function return_player(ply)
	if IsValid(ply) and ply.PA_job then
		local t = ply.PA_job
		local max = rp.teams[t] and rp.teams[t].max
		
		if rp.teams[t] and ply:ChangeAllowed(t) and (max == 0 or max >= 1 and team.NumPlayers(t) < max or max < 1 and (team.NumPlayers(t) + 1) / #player.GetAll() < max) then
			--ply:ChangeTeam(t, true, true)
			change_job(ply, t)
		else
			--ply:ChangeTeam(rp.GetDefaultTeam(ply), true, true)
			change_job(ply, rp.GetDefaultTeam(ply))
		end
		
		timer.Simple(0, function()
			ply:Spawn()
			
			ply:SetHealth(ply.PA_hp)
			ply:SetArmor(ply.PA_armor)
			
			for _, wep in pairs(ply.PA_weps) do
				ply:Give(wep)
			end
			
			ply.PA_job = nil
			ply.PA_weps = nil
			ply.PA_hp = nil
			ply.PA_armor = nil
		end)
	end
end

local function end_arena(notify_to, notify, ...)
	if notify then
		notify_players(notify_to, notify, ...)
	end
	
	timer.UnPause('rp.Arena.Ask')
	timer.Remove('rp.Arena.Ongoing')
	
	rp.Arena.ongoing = nil
	
	for k, v in pairs(rp.Arena.players or {}) do
		return_player(v)
	end
	
	rp.Arena.players = nil
	
	for k, v in pairs(ents.GetAll()) do
		if IsValid(v) and v.IsArenaWeapon then
			v:SetCustomCollisionCheck(false)
		end
	end
end

local function start_arena()
	local ply_amount = 0 
	
	for k, v in pairs(rp.Arena.players or {}) do
		if IsValid(v) and v:Alive() and not v.DeathAction then
			ply_amount = ply_amount + 1
		else
			rp.Arena.players[k] = nil
		end
	end
	
	if ply_amount < rp.cfg.Arena.min_players then
		return end_arena(rp.Arena.players or {}, 'ArenaNoPlayers')
	end
	
	rp.Arena.reward = math.min((rp.cfg.Arena.MoneyMin or 500) + (ply_amount - rp.cfg.Arena.min_players) * (rp.cfg.Arena.MoneyPerPlayer or 200), (rp.cfg.Arena.MoneyMax or 5000))
	
	local job = rp.cfg.Arena.job()
	
	for k, v in pairs(rp.Arena.players or {}) do
		setup_player(v, job)
	end
	
	rp.Arena.ongoing = true
	
	timer.Create('rp.Arena.Ongoing', 20 * 60, 1, function()
		if rp.Arena.ongoing then
			end_arena()
		end
	end)
	
	for k, v in pairs(ents.GetAll()) do
		if IsValid(v) and v.IsArenaWeapon then
			v:SetCustomCollisionCheck(true)
		end
	end
end

local function check_if_end()
	if rp.Arena.players and table.Count(rp.Arena.players) <= rp.cfg.Arena.winners_count then
		for k, v in pairs(rp.Arena.players) do
			v:AddMoney(rp.Arena.reward)
			notify_players(player.GetAll(), 'ArenaWinner', v:Name(), rp.FormatMoney(rp.Arena.reward))
		end
		
		end_arena()
		
		return true
	end
end

local function arena_ask()
	local plys = player.GetAll()
	
	if #plys < rp.cfg.Arena.min_players then
		return 
	end
	
	timer.Pause('rp.Arena.Ask')
	
	rp.Arena.players = {}
	
	for k, v in pairs(player.GetAll()) do
		if not (IsValid(v) and v:Alive()) or v:IsBanned() or v.DeathAction then continue end
		
		if v:IsBot() then
			rp.Arena.players[table.Count(rp.Arena.players)] = v
		else
			GAMEMODE.ques:Create("Принять участие в сражении на арене?", 'arena' .. k, v, 20, 
				function(yn, ply) 
					if yn and yn ~= 0 then
						if table.Count(rp.Arena.players) >= rp.cfg.Arena.max_players then
							rp.Notify(ply, NOTIFY_ERROR, rp.Term('ArenaMaxPlayers'))
						else
							rp.Arena.players[ply:SteamID()] = ply
						end
					end
				end
			)
		end
	end
	
	timer.Simple(21, start_arena)
end


hook.Add('InitPostEntity', 'rp.Arena.Initialize', function()
	timer.Create('rp.Arena.Ask', rp.cfg.Arena.interval, 0, arena_ask)
end)

local function check_player(ply)
	if rp.Arena.players and rp.Arena.ongoing then
		local participant_key = ply:IsBot() and table.KeyFromValue(rp.Arena.players, ply) or not ply:IsBot() and ply:SteamID()
		
		if participant_key and rp.Arena.players[participant_key] then
			rp.Arena.players[participant_key] = nil
			return_player(ply)
			
			if not check_if_end() then
				notify_players(rp.Arena.players, 'ArenaLost', ply:Name(), table.Count(rp.Arena.players))
				rp.Notify(ply, NOTIFY_ERROR, rp.Term('ArenaYouLost'))
			end
		end
	end
end

hook.Add('PlayerDeath', 'rp.Arena.PlayerDeath', check_player)
hook.Add('PlayerChangedTeam', 'rp.Arena.PlayerChangedTeam', check_player)

hook.Add('PlayerDisconnected', 'rp.Arena.PlayerDisconnected', function(ply)
	if rp.Arena.players and rp.Arena.ongoing then
		local participant_key = ply:IsBot() and table.KeyFromValue(rp.Arena.players, ply) or not ply:IsBot() and ply:SteamID()
		
		if participant_key and rp.Arena.players[participant_key] then
			rp.Arena.players[participant_key] = nil
			
			if not check_if_end() then
				notify_players(rp.Arena.players, 'ArenaLost', ply:Name(), table.Count(rp.Arena.players))
			end
		end
	end
end)

concommand.Add('arena_start', function(ply)
	if ply:IsRoot() then
		arena_ask()
	end
end)
