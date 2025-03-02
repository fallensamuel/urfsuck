function rp.TeamByID(t)
	return rp.teams[t]
end

function PLAYER:GetFaction()
	return rp.teams and rp.teams[self:Team() or 1] and rp.teams[self:Team() or 1].faction
end

function PLAYER:GetFactionTable()
	return rp.Factions[self:GetFaction() or -1]
end

function PLAYER:CanTeam(t)
	if !self:HasUpgrade('unlock_everything') then
		--if rp.EventIsRunning('vip') then
		--	return true
		--end
		if (t.unlockTime or 0) > self:GetPlayTime() then
			return false
		end
		if t.minUnlockTime and self:GetCustomPlayTime(t.minUnlockTimeTag) < t.minUnlockTime then
			return false
		end
		if !self:TeamUnlocked(t) then
			return false
		end
		return true
	else
		return true
	end
end


rp.Factions = {}

function rp.GetDefaultTeam(ply)
	for i=#rp.Factions[1].jobs, 1, -1 do
		if ply:CanTeam(rp.TeamByID(i)) then
			return i
		end
	end
end

function rp.AddFactionTeam(team, faction)
	if not faction or not team or not rp.Factions[faction] then return end

	rp.Factions[faction].jobs[team] = true
	table.insert(rp.Factions[faction].jobsMap, team)

	timer.Simple(0, function()
		if rp.teams[team] then
			rp.teams[team].faction = faction

			if istable(rp.Factions[faction].CustomJobRows) then
				for k, v in pairs(rp.Factions[faction].CustomJobRows) do
					if not rp.teams[team][k] then
						rp.teams[team][k] = v
					end
				end
			end
		end
	end)
end

function rp.GetFactionTeams(faction, teams)
	if istable(faction) then
		local t = {}
		for f=1, #faction do
			if not faction[f] or not rp.Factions[faction[f]] then continue end
			for i=1, #rp.Factions[faction[f]].jobsMap do
				table.insert(t, rp.Factions[faction[f]].jobsMap[i])
			end
		end

		if teams then
			for f=1, #teams do
				table.insert(t, teams[f])
			end
		end
		return t
	else
		return rp.Factions[faction] and rp.Factions[faction].jobsMap or {}
	end
end

function rp.GetFactionJobs(faction, removejobs)
	local output = table.Copy( rp.Factions[faction] and rp.Factions[faction].jobsMap or {} )

	if istable(removejobs) then
		for k, v in pairs(removejobs) do
			table.RemoveByValue(output, v)
		end
	elseif isnumber(removejobs) then
		table.RemoveByValue(output, removejobs)
	end

	return output
end

function rp.AddFaction(t)
	t.faction = #rp.Factions + 1

	t.jobs = {}
	t.jobsMap = {}
	t.teammates = {}

	rp.Factions[t.faction] = t
	return t.faction
end

function rp.GetFactionTeamsMap(factions, teams)
	local t = rp.GetFactionTeams(factions, teams)
	local map = {}
	for k, v in pairs(t) do
		map[v] = true
	end
	return map
end

function rp.IsValidFactionChange(ply, faction) 
	if not rp.cfg.CheckTeamChange or rp.cfg.EnableF4Jobs then return true end
	if not faction then return false end
	if faction == 1 then return true end
	
	faction = istable(faction) and faction or rp.Factions[faction]
	
	local pos = ply:GetPos()
	pos = Vector(pos.x, pos.y)
	
	if not (faction.npcs and faction.npcs[game.GetMap()] or faction.dialogue_npcs) then
		return true
	end
	
	if faction.npcs and faction.npcs[game.GetMap()] then
		for _, v in pairs(faction.npcs[game.GetMap()]) do
			if Vector(v[1].x, v[1].y):DistToSqr(pos) < 250000 then
				return true
			end
		end
	end
	
	if faction.teammates then 
		local fact
		
		for k, v in pairs(faction.teammates) do
			fact = rp.Factions[v]
			
			if not fact or not fact.npcs or not fact.npcs[game.GetMap()] then continue end
			
			for k1, v1 in pairs(fact.npcs[game.GetMap()]) do
				if Vector(v1[1].x, v1[1].y):DistToSqr(pos) < 250000 then
					return true
				end
			end
		end
	end
	
	if faction.dialogue_npcs then
		for _, v in pairs(faction.dialogue_npcs) do
			if v:DistToSqr(pos) < 250000 then
				return true
			end
		end
	end
	
	return false
end

function rp.CombineFactionTeammates( ... )
	local factions = {...};

	for _, f in ipairs( factions ) do
		local faction = rp.Factions[f];
		if not faction then continue end
		
		for _, tmf in ipairs( factions ) do
			if tmf ~= f then
				local teammate_faction = rp.Factions[tmf];
				if not teammate_faction then continue end

				table.insert( faction.teammates, tmf );
			end
		end
	end
end


rp.FactionGroups = {};

function rp.RegisterFactionGroup( name )
	local id = table.insert( rp.FactionGroups, {
		printName = name,
		factions  = {}
	} );

	rp.FactionGroups[id].group = id;
	return id;
end

function rp.SetFactionGroup( group, factions )
	if not istable(factions) then factions = {factions}; end

	for _, f in ipairs( factions ) do
		local faction = rp.Factions[f];
		if not faction then continue end

		table.insert( rp.FactionGroups[group].factions, f );
		faction.group = group;
	end
end

rp.FactionKeypadGroups = {}
function rp.RegisterFactionKeypadGroup(...)
	local factions = {...}

	local assoc = {}
	for k, v in pairs(factions) do assoc[v] = true end

	for k, v in pairs(factions) do
		rp.FactionKeypadGroups[v] = assoc
	end
end


hook.Add('ConfigLoaded', 'SetupFactionDialogueNPCs', function()
	if not (rp.cfg.CheckTeamChange and cnQuests and table.Count(cnQuests) > 0) then return end
	local faction_table
	
	for _, v in pairs(rp.cfg.DialogueNPCs[game.GetMap()] or {}) do
		local data = cnQuests[v[3]]
		
		if data and data.Factions then
			for __, f in pairs(data:Factions()) do
				faction_table = rp.Factions[f]
				
				if not faction_table then continue end
				
				--print(f, v[1])
				
				faction_table.dialogue_npcs = faction_table.dialogue_npcs or {}
				table.insert(faction_table.dialogue_npcs, Vector(v[1].x, v[1].y))
			end
		end
	end
	--PrintTable(rp.Factions)
end)

if CLIENT then
	local size_w, size_h = 1221, 837
	local matFrame = Material( "stalker_pda_frame.png") -- background png
	local w, h = math.min(1221, ScrW() * 0.8), math.min(837, ScrW() * 0.8 * size_h / size_w) -- background size
	local offsetX, offsetY = w * 123 / size_w, h * 100 / size_h -- panel-content offset
	local panelW, panelH = w * 922 / size_w, h * 635 / size_h -- panel-content size
	local btnCloseX, btnCloseY = w * 1022 / size_w, h * 42 / size_h

	function rp.OpenEmployerMenu(faction)
		local fr = ui.Create('ui_frame', function(self, p)
			self:SetSize(w, h)
			self:SetTitle('')
			--self:SetPos(pos.x, pos.y)
			self:MakePopup()
			self:Center()

			local keydown = false

			function self:Think()
				if !LocalPlayer():Alive() then
					self:Remove()
				elseif input.IsKeyDown(KEY_F4) and keydown then
					self:Remove()
				elseif (not input.IsKeyDown(KEY_F4)) then
					keydown = true
				end
			end

			function self:Paint(x, y)
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial( matFrame )
				surface.DrawTexturedRect( 0,0,x,y )

			end

			function self:PerformLayout()
				self.lblTitle:SizeToContents()
				self.lblTitle:SetPos(5, 3)
				
				self.btnClose:SetPos(btnCloseX, btnCloseY)
				self.btnClose:SetSize(50, 28)
			end
		end)

		ui.Create('rp_faction_jobslist', function(self, p)
			self:SetFaction(faction)
			self:SetPos(offsetX, offsetY)
			self:SetSize(panelW, panelH)
		end, fr)
	end
end