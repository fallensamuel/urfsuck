util.AddNetworkString('rp.ConjSendAll')
util.AddNetworkString('rp.ConjChange')

local function conjSaveInDb(alli1, alli2, state)
	local alliance1 = math.min(alli1, alli2)
	local alliance2 = math.max(alli1, alli2)
	
	rp._Stats:Query('DELETE FROM `capture_conjunctions` WHERE `alliance1` = ? AND `alliance2` = ?', 
		rp.Capture.Alliances[alliance1].name, 
		rp.Capture.Alliances[alliance2].name, 
		function()
			rp._Stats:Query('INSERT INTO `capture_conjunctions`(`alliance1`, `alliance2`, `state`) VALUES (?, ?, ?)', 
				rp.Capture.Alliances[alliance1].name, 
				rp.Capture.Alliances[alliance2].name, 
				state)
		end)
end

hook("CapturePointsLoaded", function()
	rp._Stats:Query('SELECT * FROM `capture_conjunctions`', function(data)
		local find = {}
		
		for k, v in pairs(data or {}) do
			v.alliance1 = rp.Capture.GetAllianceByName(v.alliance1)
			v.alliance2 = rp.Capture.GetAllianceByName(v.alliance2)

			if !(v.alliance1 && v.alliance2) then continue end

			v.alliance1 = v.alliance1.id
			v.alliance2 = v.alliance2.id
			
			find[v.alliance1] = find[v.alliance1] or {}
			find[v.alliance1][v.alliance2] = true
			
			rp.ConjSet(v.alliance1, v.alliance2, v.state, true)
		end
		
		for i = 1, #rp.Capture.Alliances - 1 do
			for j = i + 1, #rp.Capture.Alliances do
				if (find[i] and find[i][j]) or (find[j] and find[j][i]) then continue end
				
				local valid_states = {}
				
				if not rp.ConjIsInvalid(i, j, CONJ_WAR) then table.insert(valid_states, CONJ_WAR) end
				if not rp.ConjIsInvalid(i, j, CONJ_NEUTRAL) then table.insert(valid_states, CONJ_NEUTRAL) end
				if not rp.ConjIsInvalid(i, j, CONJ_UNION) then table.insert(valid_states, CONJ_UNION) end
				
				local state = table.Random(valid_states)
				
				rp.ConjSet(i, j, state, true)
				conjSaveInDb(i, j, state)
			end
		end
	end)
end)

local function sendAllConjes(ply)
	net.Start('rp.ConjSendAll')
		for i = 1, #rp.Capture.Alliances - 1 do
			for j = i + 1, #rp.Capture.Alliances do
				net.WriteUInt(rp.Capture.Alliances[i].conjes[j] or 0, 2)
			end
		end
	net.Send(ply)
end

hook.Add("PlayerAuthed", "rp.Conjunctions", function(ply)
	nw.WaitForPlayer(ply, function(ply)
		sendAllConjes(ply)
	end)
end)

net.Receive('rp.ConjSendAll', function(_, ply)
	sendAllConjes(ply)
end)

--sendAllConjes(ply)

local function conjFindRequestPlayer(alliance)
	local max_found
	
	for k, v in ipairs(player.GetAll()) do
		if alliance == v:GetAlliance() then
			if v:GetJobTable().canDiplomacy then 
				return v 
			end
			
			if not max_found or max_found:Team() < v:Team() then 
				max_found = v 
			end
		end
	end
	
	return max_found
end

function rp.ConjSet(alliance1, alliance2, state, is_silent)
	local allc1 = rp.Capture.Alliances[alliance1]
	local allc2 = rp.Capture.Alliances[alliance2]
	
	if not allc1 or not allc2 then return end
	if rp.ConjGet(alliance1, alliance2) == state then return end
	if rp.ConjIsInvalid(alliance1, alliance2, state) then return end
	
	allc1.conjes[alliance2] = state
	allc2.conjes[alliance1] = state
	
	allc1.lastConjChange = os.time()
	allc2.lastConjChange = os.time()
	
	if not is_silent then
		rp.NotifyAll(NOTIFY_GENERIC, rp.Term('ConjunctionChanged'), allc1.printName, allc2.printName, rp.ConjGetName(state))
		conjSaveInDb(alliance1, alliance2, state)
	end
	
	net.Start('rp.ConjChange')
		net.WriteUInt(alliance1, 8)
		net.WriteUInt(alliance2, 8)
		net.WriteUInt(state, 2)
	net.Broadcast()
end


rp.AddCommand("/conjunction", function(ply, _, params)
	if not IsValid(ply) then 
		rp.NotifyAll(NOTIFY_ERROR, rp.Term('ConjunctionInvalid'), translates.Get('игрок не найден'))
		return 
	end
	
	if not (ply:GetJobTable() and ply:GetJobTable().canDiplomacy) then 
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ConjunctionInvalid'), translates.Get('игрок - не дипломат'))
		return 
	end
	
	local current 	= ply:GetAlliance()
	local alliance 	= tonumber(params[1])
	local state		= tonumber(params[2])
	
	if state ~= CONJ_WAR and state ~= CONJ_NEUTRAL and state ~= CONJ_UNION then 
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ConjunctionInvalid'), translates.Get('неизвестное отношение'))
		return 
	end
	
	local allc = rp.Capture.Alliances[alliance]
	if not allc then 
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ConjunctionInvalid'), translates.Get('неизвестный альянс'))
		return 
	end
	
	local old_state = rp.ConjGet(current, alliance)
	
	if (old_state == state) or rp.ConjIsInvalid(current, alliance, state) then 
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ConjunctionInvalid'), translates.Get('невозможно установить это отношение'))
		return 
	end
	
	if (state ~= CONJ_NEUTRAL) and (old_state ~= CONJ_NEUTRAL) then 
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ConjunctionInvalid'), translates.Get('сначала надо поменять отношение на нейтралитет'))
		return 
	end
	
	if allc.lastConjChange and rp.cfg.ConjunctionTimeout and (os.time() - allc.lastConjChange < rp.cfg.ConjunctionTimeout) then 
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ConjunctionTooEarly'), rp.cfg.ConjunctionTimeout - os.time() + allc.lastConjChange)
		return
	end
	
	if (old_state == CONJ_UNION) or (old_state == CONJ_NEUTRAL) and (state == CONJ_WAR) then
		rp.ConjSet(current, alliance, state)
	else
		local target = conjFindRequestPlayer(alliance)
		
		if not IsValid(target) then
			rp.ConjSet(current, alliance, state)
			return
		end
		
		rp.Notify(ply, NOTIFY_GENERIC, rp.Term('ConjunctionRequest'), rp.Capture.Alliances[alliance].printName)
		
		allc.lastConjChange = os.time()
		
		GAMEMODE.ques:Create(translates.Get("%s\nпредлагают сменить отношение на\n%s\nВы согласны?", rp.Capture.Alliances[current].printName, rp.ConjGetName(state)), 'conjunction', target, 20, 
			function(yn) 
				if yn and yn ~= 0 then
					rp.ConjSet(current, alliance, state)
				else
					rp.Notify(ply, NOTIFY_GENERIC, rp.Term('ConjunctionDecline'), rp.Capture.Alliances[alliance].printName)
				end
			end
		)
	end
end)
