util.AddNetworkString('PlayerDisguise')

local disguise_cooldowns = {}

function PLAYER:SetTeamSilent(newTeam, ReturnOldTeam, VisualOnly)
    local oldTeam = self:Team()
	
	if disguise_cooldowns[self] and disguise_cooldowns[self] + 2 > CurTime() then return end

    local job_tab = rp.teams[newTeam]
    if VisualOnly then
    	self:JobDisguise(newTeam, true)
    else
        self:SetTeam(newTeam)
    end
    
    local selected_model = self:GetModel()
    local selected_skin = 0
    
    if job_tab.appearance then
        local keys = table.GetKeys(job_tab.appearance)
        local needed_key = keys[math.random(#keys)]
        local mdl = job_tab.appearance[needed_key]
            
        if mdl then 
            --self:SetModel(istable(mdl.mdl) and table.Random(mdl.mdl) or isstring(mdl.mdl) and mdl.mdl)
            selected_model = istable(mdl.mdl) and table.Random(mdl.mdl) or isstring(mdl.mdl) and mdl.mdl or selected_model
            
            if mdl.skins then
                --self:SetSkin(mdl.skins[math.random(#mdl.skins)])
                selected_skin = mdl.skins[math.random(#mdl.skins)]
            end
        else
            local job_mdl = job_tab.model
            --self:SetModel(istable(job_mdl) and table.Random(job_mdl) or isstring(job_mdl) and job_mdl)
            selected_model = istable(job_mdl) and table.Random(job_mdl) or isstring(job_mdl) and job_mdl or selected_model
        end
    else
        local job_mdl = job_tab.model
        --self:SetModel(istable(job_mdl) and table.Random(job_mdl) or isstring(job_mdl) and job_mdl)
        selected_model = istable(job_mdl) and table.Random(job_mdl) or isstring(job_mdl) and job_mdl or selected_model
    end

    self:StripWeapons()

    timer.Simple(0.1, function()
        if not IsValid(self) then return end
        self:SetModel(selected_model)
        self:SetSkin(selected_skin)

        player_manager.SetPlayerClass(self, 'rp_player')
        self:SetNoCollideWithTeammates(false)
        self:UnSpectate()
        self:SetHealth(100)
        self:SetJumpPower(200)
        GAMEMODE:SetPlayerSpeed(self, rp.cfg.WalkSpeed, rp.cfg.RunSpeed)
        self:Extinguish()
        self:SetMaterial('')

        if IsValid(self:GetActiveWeapon()) then
            self:GetActiveWeapon():Extinguish()
        end
        self:GetTable().StartHealth = self:Health()
        gamemode.Call("PlayerSetModel", self)
        gamemode.Call("PlayerLoadout", self)
        local view1, view2 = self:GetViewModel(1), self:GetViewModel(2)

        if IsValid(view1) then
            view1:Remove()
        end

        if IsValid(view2) then
            view2:Remove()
        end

        if job_tab then
            if job_tab.PlayerSpawn then
                job_tab.PlayerSpawn(self)
            end
            if job_tab.armor then
                self:GiveArmor(job_tab.armor)
            end
            if job_tab.health then
                self:AddMaxHealth(job_tab.health < 100 && job_tab.health || job_tab.health - 100)
            end
            --if job_tab.SetBodygroups then
            --  job_tab.SetBodygroups(self)
            --end
            if job_tab.speed then
                GAMEMODE:SetPlayerSpeed(self, rp.cfg.WalkSpeed, rp.cfg.RunSpeed * job_tab.speed)
            end
        end

        self:AllowFlashlight(true)

        if ReturnOldTeam then
        	local hook_name = "SetTeamSilent".. self:SteamID64()
            hook.Add("PlayerSpawn", hook_name, function(ply)
            	hook.Remove("PlayerSpawn", hook_name)
                timer.Simple(0, function()
                    ply:ChangeTeam(oldTeam)
                end)
            end)
        end
    end)
end

function PLAYER:JobDisguise(team, resetOnDeath)
	if disguise_cooldowns[self] and disguise_cooldowns[self] + 2 > CurTime() then return end
	
	self:SetNetVar('DisguiseTeam', team)
	if self:GetNetVar('job') then
		self:SetNetVar('job', nil)
	end

	if resetOnDeath then
		timer.Simple(0, function()
			local hook_name = "JobDisguise".. self:SteamID64()
	        hook.Add("PlayerSpawn", hook_name, function(ply)
	        	hook.Remove("PlayerSpawn", hook_name)
	            timer.Simple(0, function()
	                ply:ChangeTeam(oldTeam)
	            end)
	        end)
	    end)
    end

	disguise_cooldowns[self] = CurTime()
    hook.Call('playerDisguised', GAMEMODE, self, self:Team(), team)
end

function PLAYER:Disguise(t, time)
	if not self:Alive() then return end
	
	if disguise_cooldowns[self] and disguise_cooldowns[self] + 2 > CurTime() then return end
	
	if rp.teams[t] and rp.teams[t].disableDisguise  then
		return false
	end

	self:SetNetVar('DisguiseTeam', t)
	-- self:SetNetVar('DisguiseTime', CurTime() + time)

	if self:GetNetVar('job') then
		self:SetNetVar('job', nil)
	end

	local mdl = team.GetModel(t)
	self:SetModel(mdl)

	local team_t = rp.teams[t]
	
	--PrintTable(team_t.appearance)
	--print(team_t.appearance, team_t.appearance[1])
	
	if team_t.SetBodygroups then
		team_t.SetBodygroups(self)
	elseif team_t.appearance then
		
		for k, v in pairs(team_t.appearance) do
			if v.mdl ~= mdl then continue end
			
			if v.skins and v.skins[1] then
				self:SetSkin(v.skins[1])
			end
			
			if v.bodygroups then
				for bgroup_id, bgroup_data in pairs(v.bodygroups) do
					self:SetBodygroup(bgroup_id, istable(bgroup_data) and bgroup_data[1] or bgroup_data)
				end
			end
		end
		
		/*
		if team_t.appearance[1].skins and team_t.appearance[1].skins[1] then
			self:SetSkin(team_t.appearance[1].skins[1])
		end
		
		if team_t.appearance[1].bodygroups then
			for k, v in pairs(team_t.appearance[1].bodygroups) do
				self:SetBodygroup(k, v)
			end
		end
		*/
	end
	
	-- if (time) then
	-- 	rp.Notify(self, NOTIFY_GREEN, rp.Term('NowDisguisedTime'), math.Round(time / 60, 0), rp.teams[t].name)
	-- else
	-- 	rp.Notify(self, NOTIFY_GREEN, rp.Term('NowDisguised'), rp.teams[t].name)
	-- end

	disguise_cooldowns[self] = CurTime()
	hook.Call('playerDisguised', GAMEMODE, self, self:Team(), t)
	-- if not time then return end

	-- timer.Create('Disguise_' .. self:UniqueID(), time, 1, function()
	-- 	if not IsValid(self) then return end
	-- 	self:SetNetVar('DisguiseTeam', nil)
	-- 	self:SetNetVar('DisguiseTime', nil)

	-- 	if self:GetNetVar('job') then
	-- 		self:SetNetVar('job', nil)
	-- 	end

	-- 	GAMEMODE:PlayerSetModel(self)
	-- 	rp.Notify(self, NOTIFY_ERROR, rp.Term('DisguiseWorn'))
	-- end)
end

timer.Create('ResetDisguiseCooldowns', 30 * 60, 0, function() 
	disguise_cooldowns = {} 
end)

function PLAYER:UnDisguise()
	--timer.Remove('Disguise_' .. self:UniqueID())
	self:SetNetVar('DisguiseTeam', nil)
	if self:GetNetVar('job') then
		self:SetNetVar('job', nil)
	end
	GAMEMODE:PlayerSetModel(self)
	--self:SetNetVar('DisguiseTime', nil)
end

util.AddNetworkString('rp.UnDisguise')
net('rp.UnDisguise', function(len, pl)
	pl:UnDisguise()
end)

function PLAYER:HirePlayer(pl)
	if pl:GetNetVar('job') then
		pl:SetNetVar('job', nil)
	end

	pl:SetNetVar('Employer', self)
	self:SetNetVar('Employee', pl)
	self:TakeMoney(pl:GetHirePrice())
	pl:AddMoney(pl:GetHirePrice())
	hook.Call('PlayerHirePlayer', GAMEMODE, self, pl)
end

hook('OnPlayerChangedTeam', 'Disguise.OnPlayerChangedTeam', function(pl, prevTeam, t)
	if pl:IsDisguised() then
		pl:UnDisguise()
	end

	if (pl:GetNetVar('Employer') ~= nil) then
		rp.Notify(pl:GetNetVar('Employer'), NOTIFY_ERROR, rp.Term('EmployeeChangedJob'))
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('EmployeeChangedJobYou'))
		pl:GetNetVar('Employer'):SetNetVar('Employee', nil)
		pl:SetNetVar('Employer', nil)
	end
end)

net('PlayerDisguise', function(len, pl)
	if pl.ZombieInfected then return end
	
	local t = net.ReadUInt(9)
	local team_t = rp.TeamByID(t)
	
	if (rp.teams[pl:Team()].candisguise) and pl:CanTeam(team_t) then
		if team_t.disableDisguise or not rp.teams[pl:Team()].disguise_faction or team_t.faction ~= rp.teams[pl:Team()].disguise_faction then return end
		
		if pl:IsDisguised() then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('AlreadyDisguised'))

			return
		end

		pl:Disguise(t)
		--pl.NextDisguise = CurTime() + 300
	end
end)

concommand.Add("~debug_dmgtypes", function(ply)
	if not ply:IsRoot() then return end
	ply.DebugDmgtypes = not ply.DebugDmgtypes

	ply:ChatPrint("Вы " ..(ply.DebugDmgtypes and "включили" or "выключили").. " отладочные принты типов урона!")
end)

hook.Add('EntityTakeDamage', 'rp.JobDamageReduction', function(target, dmginfo)
	if IsValid(target) and target:IsPlayer() and rp.teams[target:Team()] then
		local ply = dmginfo:GetAttacker()
		if IsValid(ply) and ply.DebugDmgtypes then
			ply:PrintMessage( HUD_PRINTTALK, dmginfo:GetDamageType() )
		end

		if not rp.teams[target:Team()].scaleDamage then return end

		local scale = rp.teams[target:Team()].scaleDamage
		if isnumber(scale) then
			dmginfo:ScaleDamage(scale)
		elseif istable(scale) then
            local s = scale[ dmginfo:GetDamageType() ]
            if isnumber(s) then
            	dmginfo:ScaleDamage(s)
            end
		end
	end
end)

hook('PlayerDeath', 'teams.PlayerDeath', function(pl)
	if pl:IsDisguised() then
		pl:UnDisguise()
	end

	if (pl:GetNetVar('Employer') ~= nil) then
		rp.Notify(pl:GetNetVar('Employer'), NOTIFY_ERROR, rp.Term('EmployeeDied'))
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('EmployeeDiedYou'))
		pl:GetNetVar('Employer'):SetNetVar('Employee', nil)
		pl:SetNetVar('Employer', nil)
	elseif (pl:GetNetVar('Employee') ~= nil) then
		rp.Notify(pl:GetNetVar('Employee'), NOTIFY_ERROR, rp.Term('EmployerDied'))
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('EmployerDiedYou'))
		pl:GetNetVar('Employee'):SetNetVar('Employer', nil)
		pl:SetNetVar('Employee', nil)
	end
end)

hook('PlayerDisconnected', 'employees.PlayerDisconnected', function(pl)
	if (pl:GetNetVar('Employer') ~= nil) then
		rp.Notify(pl:GetNetVar('Employer'), NOTIFY_ERROR, rp.Term('EmployeeLeft'))
		pl:GetNetVar('Employer'):SetNetVar('Employee', nil)
	elseif (pl:GetNetVar('Employee') ~= nil) then
		rp.Notify(pl:GetNetVar('Employee'), NOTIFY_ERROR, rp.Term('EmployerLeft'))
		pl:GetNetVar('Employee'):SetNetVar('Employer', nil)
	end
end)

--
-- Commands
--
rp.AddCommand('/model', function(pl, text, args)
	if not args[1] then return end
	
	local can_use = pl:IsRoot()
	local teamData = pl:GetJobTable()
	local needed_model = string.lower(args[1])
	
	if not can_use then
		if istable(teamData.model) then
			for k, v in pairs(teamData.model) do
				if v == needed_model then
					can_use = true
				end
			end
		else
			can_use = teamData.model == needed_model
		end
	end
	
	if not can_use then
		if teamData.appearance then
			for _, appearData in pairs(teamData.appearance) do
				if can_use then break end
				
				local mdls = istable(appearData.mdl) and appearData.mdl or {appearData.mdl}; 
				
				if istable(appearData.mdl) then
					for __, mdl in pairs(mdls) do
						if mdl == needed_model then
							can_use = true
							break
						end
					end
				elseif appearData.mdl == needed_model then
					can_use = true
					break
				end
			end
		end
    end
	
	if not can_use then
		local sub_can_use = true
		
		for _, uid in pairs(table.GetKeys(rp.shop.ModelsMap or {})) do
			if can_use then break end
			
			sub_can_use = not (rp.shop.ModelsMap[uid][2][teamData.team] or rp.shop.ModelsMap[uid][3][teamData.faction or 0])
			
			if sub_can_use and rp.shop.ModelsMap[uid][4] then
				sub_can_use = rp.shop.ModelsMap[uid][4][teamData.team] and true or false
			end
			if sub_can_use and rp.shop.ModelsMap[uid][5] then
				sub_can_use = rp.shop.ModelsMap[uid][5][teamData.faction or 0] and true or false
			end
			
			if
				(not pl:HasUpgrade(uid)) or
				(not sub_can_use) 
			then
				continue
			end

			for _, mdl in pairs(rp.shop.ModelsMap[uid][1]) do
				if mdl == needed_model then
					can_use = true
					break
				end
			end
		end
	end
	
	if can_use then
		pl:SetVar('Model', needed_model)
		pl:SetModel(needed_model)
	end
end)

rp.AddCommand('/hire', function(pl, text, args)
	local targ = pl:GetEyeTrace().Entity
	if not IsValid(targ) or not targ:IsPlayer() or (pl:EyePos():DistToSqr(targ:EyePos()) > 13225) then return end

	if !pl:GetJobTable().canUseHire && (!rp.cfg.AllCanUseHire || pl:GetJobTable().build == false) then
		return
	end

	if not targ:IsHirable() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PlayerNotHirable'), targ)

		return
	end

	if pl:IsHirable() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('EmployeeTriedEmploying'))

		return
	end

	if (pl:GetNetVar('Employee') ~= nil) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('HasEmployee'))

		return
	end

	if (pl:GetNetVar('Employer') ~= nil) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('AlreadyEmployed'))

		return
	end

	if (not pl:CanAfford(targ:GetHirePrice())) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('CannotAffordEmployee'))

		return
	end

	rp.Notify(pl, NOTIFY_GENERIC, rp.Term('EmployRequestSent'), targ)

	GAMEMODE.ques:Create('Would you like ' .. pl:Name() .. ' to hire you for ' .. rp.FormatMoney(targ:GetHirePrice()) .. '?', "hire" .. pl:UserID(), targ, 30, function(answer)
		if (tobool(answer) == true) and IsValid(pl) then
			rp.Notify(pl, NOTIFY_GREEN, rp.Term('YouHired'), targ, rp.FormatMoney(targ:GetHirePrice()))
			rp.Notify(targ, NOTIFY_GREEN, rp.Term('YouAreHired'), pl, rp.FormatMoney(targ:GetHirePrice()))
			pl:HirePlayer(targ)
		else
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('EmployRequestDen'), targ)
		end
	end)
end)

rp.AddCommand('/fire', function(pl, text, args)
	local targ = rp.FindPlayer(args[1])
	if not IsValid(targ) or not (targ:GetNetVar('Employer') == pl) then return end
	rp.Notify(pl, NOTIFY_GREEN, rp.Term('EmployeeFired'), targ)
	rp.Notify(targ, NOTIFY_ERROR, rp.Term('EmployeeFiredYou'), pl)
	targ:SetNetVar('Employer', nil)
	pl:SetNetVar('Employee', nil)
end)

rp.AddCommand('/quitjob', function(pl, text, args)
	if not IsValid(pl:GetNetVar('Employer')) then return end
	rp.Notify(pl, NOTIFY_GREEN, rp.Term('EmployeeQuitYou'), pl:GetNetVar('Employer'))
	rp.Notify(pl:GetNetVar('Employer'), NOTIFY_ERROR, rp.Term('EmployeeQuet'), pl)
	pl:GetNetVar('Employer'):SetNetVar('Employee', nil)
	pl:SetNetVar('Employer', nil)
end)




hook.Add('PlayerDeath', function(ply, inf, attacker)
	if ply:IsPlayer() && (ply:IsDisguised() or ply:IsVortDisguised()) then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('DisguiseWorn'))
		GAMEMODE:PlayerSetModel(ply)
		ply:UnDisguise()
		if target:IsVortDisguised() then
			ply:GetNetVar('VortDisguise', false)
		end
	end
end)

hook.Add('EntityTakeDamage', function(target, dmginfo)
	if target:IsPlayer() and (target:IsDisguised() or target:IsVortDisguised()) then
		print(target)
		if target.DisguiseDamage == nil then target.DisguiseDamage = 0 end
		print(target.DisguiseDamage, target, dmginfo:GetAttacker())
		if target.DisguiseDamage >= 50 then
			rp.Notify(target, NOTIFY_ERROR, rp.Term('DisguiseWorn'))
			GAMEMODE:PlayerSetModel(target)
			target:UnDisguise()
			if target:IsVortDisguised() then
				target:GetNetVar('VortDisguise', false)
			end
			target.DisguiseDamage = 0
		else
			target.DisguiseDamage = target.DisguiseDamage + dmginfo:GetDamage()
			if !timer.Exists("DisguiseDamage"..target:SteamID64()) then
				timer.Create("DisguiseDamage"..target:SteamID64(), 20, 1, function()
					if !IsValid(target) then return end
					target.DisguiseDamage = 0
				end)
			end
		end
	end
end)

if !isWhiteForest then
	util.AddNetworkString("rp.VortigontDisguise")
	util.AddNetworkString("rp.UnVortigontDisguise")

	net.Receive("rp.VortigontDisguise", function(len, ply)
		if not ply:GetTeamTable().vort_disguise then return end
		if ply:IsVortDisguised() then return end

		if not TEAM_VORTI then
			for i = 1, #rp.teams do
				if rp.teams[i].command == "vortigaunt_slave" then
					TEAM_VORTI = i
					break
				end
			end
		end

		ply:Disguise(TEAM_VORTI)
		ply:GetNetVar('VortDisguise', true)
	end)

	net.Receive("rp.UnVortigontDisguise", function(len, ply)
		if not ply:GetTeamTable().vort_disguise then return end
		if not ply:IsVortDisguised() then return end
		ply:UnDisguise()
		ply:GetNetVar('VortDisguise', false)
	end)
end