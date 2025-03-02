
if not rp.cfg.NewWanted then return end

local last_action = {}

local function notify_faction(faction, mode, term, ...)
	local police_f = rp.police.GetFaction(faction)
	
	for k, v in pairs(player.GetAll()) do
		if IsValid(v) and v:GetFaction() and rp.police.GetFaction(v:GetFaction()) == police_f then
			rp.Notify(v, mode, term, ...)
		end
	end
end


function PLAYER:AddWantedStar(initiator, reason, faction, silent)
	local stars_table = self:GetNetVar('WantedStars') or {}
	stars_table[rp.police.GetFaction(faction).ID] = (stars_table[rp.police.GetFaction(faction).ID] or 0) + 1
	self:SetNetVar('WantedStars', stars_table)
	
	if not silent then
		notify_faction(faction, NOTIFY_GENERIC, rp.Term('WantedStar'), self:Name(), reason, (IsValid(initiator) and initiator:Name() or translates.Get('АвтоРозыск')))
	end
	
	hook.Call('PlayerFactionWantedStar', GAMEMODE, self, initiator, reason, stars_table[rp.police.GetFaction(faction).ID])
end

function PLAYER:Wanted(initiator, reason, faction, silent)
	if not faction then
		if IsValid(initiator) and initiator:IsPlayer() and initiator:GetFaction() and rp.police.GetFaction(initiator:GetFaction()) then
			faction = initiator:GetFaction()
			
		else
			return
		end
	end
	
	if not faction then
		return
	end
	
	if IsValid(initiator) and initiator:IsPlayer() then
		if self:IsWantedBy(initiator) then
			return rp.Notify(initiator, NOTIFY_ERROR, rp.Term('PlayerAlreadyWantedByYou'))
		end
		
		if self:GetWantedStars(faction) >= 5 then
			return rp.Notify(initiator, NOTIFY_ERROR, rp.Term('WantedFactionTooManyStars'))
		end
		
		if last_action[initiator:SteamID()] and last_action[initiator:SteamID()] > CurTime() then 
			return rp.Notify(initiator, NOTIFY_ERROR, rp.Term('WantedTooMuch'))
		end
		
		last_action[initiator:SteamID()] = CurTime() + 50
	else
		if self:GetWantedStars(faction) >= 5 then
			return
		end
	end
	
	if self:IsBanned() or self.IsZombie and self:IsZombie() then return end
	
	if utf8.len(reason) > 64 then
		reason = utf8.sub(reason, 1, 64) .. '...'
	end
	
	self:AddWantedStar(initiator, reason, faction, silent)
	
	local police_f_id = rp.police.GetFaction(faction).ID
	
	timer.Create('WantedFaction' .. self:SteamID64() .. '-' .. police_f_id, rp.cfg.WantedTime, 1, function()
		if IsValid(self) then
			self:UnWanted(nil, faction)
		end
	end)
	
	local wanted_table = self:GetNetVar('FactionWanted') or {}
	
	if wanted_table[police_f_id] then
		return
	end
	
	wanted_table[police_f_id] = reason
	self:SetNetVar('FactionWanted', wanted_table)
	
	if IsValid(initiator) and initiator:IsPlayer() then
		self.WantedFactionBy = self.WantedFactionBy or {}
		self.WantedFactionBy[police_f_id] = self.WantedFactionBy[police_f_id] or {}
		self.WantedFactionBy[police_f_id][initiator:SteamID()] = true
	end
	
	--notify_faction(faction, NOTIFY_GENERIC, rp.Term('Wanted'), self:Name(), reason, (IsValid(initiator) and initiator:Name() or translates.Get('АвтоРозыск')))
	
	--rp.Notify(self, NOTIFY_GENERIC, rp.Term('Wanted'), self:Name(), reason, (IsValid(initiator) and initiator:Name() or translates.Get('АвтоРозыск')))
	
	hook.Call('PlayerFactionWanted', GAMEMODE, self, initiator, reason)
end

function PLAYER:UnWanted(initiator, faction)
	if not faction then
		if IsValid(initiator) and initiator:IsPlayer() and initiator:GetFaction() and rp.police.GetFaction(initiator:GetFaction()) then
			faction = initiator:GetFaction()
			
		else
			return
		end
	end
	
	if not faction then
		return
	end
	
	local wanted_table = self:GetNetVar('FactionWanted') or {}
	wanted_table[rp.police.GetFaction(faction).ID] = nil
	self:SetNetVar('FactionWanted', wanted_table)
	
	local stars_table = self:GetNetVar('WantedStars') or {}
	stars_table[rp.police.GetFaction(faction).ID] = nil
	self:SetNetVar('WantedStars', stars_table)
	
	self.WantedFactionBy = self.WantedFactionBy or {}
	self.WantedFactionBy[rp.police.GetFaction(faction).ID] = nil
	self.WantedRewardGiven = nil
	
	timer.Destroy('WantedFaction' .. self:SteamID64() .. '-' .. rp.police.GetFaction(faction).ID)
	hook.Call('PlayerFactionUnWanted', GAMEMODE, self, initiator)
end

function PLAYER:UnWantedAllFactions()
	for k, v in pairs(self:GetNetVar('FactionWanted') or {}) do
		timer.Destroy('WantedFaction' .. self:SteamID64() .. '-' .. k)
	end
	
	self:SetNetVar('FactionWanted', {})
	self:SetNetVar('WantedStars', {})
	
	self.WantedFactionBy = {}
	self.WantedRewardGiven = nil
	
	hook.Call('PlayerFactionUnWanted', GAMEMODE, self, initiator)
end

function PLAYER:IsWantedAnyFaction()
	for k, v in pairs(self:GetNetVar('FactionWanted') or {}) do
		if v then
			return true
		end
	end
	
	return false
end

function PLAYER:IsWantedBy(ply)
	if not IsValid(ply) or not ply:GetFaction() then
		return false
	end
	
	local mf = rp.police.GetFaction(ply:GetFaction())
	
	if not mf then
		return false
	end
	
	return self.WantedFactionBy and self.WantedFactionBy[mf.ID] and self.WantedFactionBy[mf.ID][ply:SteamID()]
end

function PLAYER:Arrest(actor, reason)
	if self:IsBanned() or self:IsArrested() then return end

	local isHandCuffed, HandCuff = self:IsHandcuffed()
	if isHandCuffed then
		HandCuff:Remove()
	end

	local time = rp.Karma(self, rp.cfg.ArrestTimeMax, rp.cfg.ArrestTimeMin)
	timer.Create('Arrested' .. self:SteamID64(), time, 1, function()
		if IsValid(self) then
			self:UnArrest()
		end
	end)
	
	local faction = IsValid(actor) and actor:IsPlayer() and actor:GetFaction() and rp.police.GetFaction(actor:GetFaction()) and rp.police.GetFaction(actor:GetFaction()).ID or 1
	
	self:SetNetVar('ArrestedInfo', {Reason = (reason or self:GetWantedReason(faction) or 'АвтоАрест'), Release = CurTime() + time})
	
	if self:IsWanted(faction) then 
		self:UnWanted(nil, faction) 
	end
		
	rp.ArrestedPlayers[self:SteamID64()] = faction or true
	
	self:StripWeapons()
	self:SetHunger(100)
	self:SetHealth(100)
	self:SetArmor(0)

	self:Give("weapon_hands")

	if faction then
		if IsValid(actor) then
			local add_money = rp.cfg.PoliceArrestReward[math.Clamp(self:GetWantedStars(actor:GetFaction()), 1, 5)]
			
			actor:AddMoney(add_money)
			rp.Notify(actor, NOTIFY_GREEN, rp.Term('ArrestedFactionReward'), rp.FormatMoney(add_money))
		end
		
		if not rp.cfg.Serious then
			rp.NotifyAll(NOTIFY_GENERIC, rp.Term('ArrestedFaction'), self:Name(), rp.police.Factions[faction].Name)
		end
		
	else
		if not rp.cfg.Serious then
			rp.NotifyAll(NOTIFY_GENERIC, rp.Term('Arrested'), self:Name())
		end
	end
	
	
	hook.Call('PlayerArrested', GAMEMODE, self, actor)

	local jails = faction and rp.police.Factions[faction].jail[game.GetMap()] and rp.police.Factions[faction].jail[game.GetMap()].poses or rp.cfg.JailPos[game.GetMap()]
	self:Teleport(util.FindEmptyPos(jails[math.random(#jails)]))

	timer.Simple(1, function() 
		if IsValid(self) then 
			self.CanEscape = true 
		end 
	end)
end

function PLAYER:UnArrest(actor)
	timer.Destroy('Arrested' .. self:SteamID64())
	
	self:SetNetVar('ArrestedInfo', nil)
	rp.ArrestedPlayers[self:SteamID64()] = nil
	
	self:ExitVehicle()
	
	timer.Simple(0.3, function() 
		if not IsValid(self) then return end
		local _, pos = GAMEMODE:PlayerSelectSpawn(self)
		self:Teleport(pos)
		self:SetHealth(100)
		
		hook.Call('PlayerLoadout', GAMEMODE, self)
		rp.NotifyAll(NOTIFY_GENERIC, rp.Term('UnArrested'), self:Name())
		hook.Call('PlayerUnArrested', GAMEMODE, self, actor)
	end)
end



rp.AddCommand('/want', function(pl, text, args)
	if not pl:IsCP() or not args[1] or not args[2] then return end
	
	local targ = rp.FindPlayer(args[1])
	
	if not IsValid(targ) then 
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('WantedPlayerNotFound'), args[1])
		
	elseif not pl:CanPoliceFaction(targ:GetFaction()) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('CantWantFaction'), targ:GetFactionTable().printName)
		
	else
		local reason = table.concat(args, ' ', 2)
		targ:Wanted(pl, reason, pl:GetFaction())
	end
end)

rp.AddCommand('/unwant', function(pl, text, args)
	if not pl:IsCP() then return end
	
	local targ = rp.FindPlayer(args[1])
	
	if not IsValid(targ) then 
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('WantedPlayerNotFound'), args[1])
		
	elseif not pl:CanPoliceFaction(targ:GetFaction()) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('CantUnWantFaction'), targ:GetFactionTable().printName)
		
	elseif not targ:IsWanted(pl:GetFaction()) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PlayerNotWanted'), args[1])
		
	else
		targ:UnWanted(pl, pl:GetFaction())
	end
end)


local bounds = rp.cfg.Jails[game.GetMap()]
hook.Add('PlayerThink', 'Jail::Escape', function(pl)
	if IsValid(pl) and pl:IsArrested() and pl.CanEscape then
		local faction = rp.ArrestedPlayers[pl:SteamID64()]
		local bnds = faction ~= true and rp.police.Factions[faction].jail[game.GetMap()] and rp.police.Factions[faction].jail[game.GetMap()].box or bounds
		
		if not pl:InBox(bnds[1], bnds[2]) then
			rp.ArrestedPlayers[pl:SteamID64()] = nil
			
			pl:SetNetVar('ArrestedInfo', nil)
			timer.Destroy('Arrested' .. pl:SteamID64())
			
			hook.Call('PlayerLoadout', GAMEMODE, pl)
		end
	end
end)

hook('PlayerDeath', function(pl, killer, dmginfo)
	if not killer:IsPlayer() or not killer:GetFaction() or not pl:GetFaction() then return end
	
	if pl ~= killer and pl:IsWanted(killer:GetFaction()) and killer:CanPoliceFaction(pl:GetFaction()) then
		pl:Arrest(killer)
	end
end)

hook.Add('DeathMechanics.StartDeath', function(ply, killer)
	if IsValid(killer) and killer:IsPlayer() and ply:GetFaction() and killer:GetFaction() then
		local mf = rp.police.GetFaction(killer:GetFaction())
		
		if mf and killer:CanPoliceFaction(ply:GetFaction()) and not (ply.WantedRewardGiven and ply.WantedRewardGiven[killer:SteamID()]) then
			local stars = ply:IsWanted(killer:GetFaction()) and ply:GetWantedStars(killer:GetFaction()) or 0
			
			if stars > 0 then
				local add_money = rp.cfg.PoliceKnockReward[math.Clamp(stars, 1, 5)]
				
				ply.WantedRewardGiven = ply.WantedRewardGiven or {}
                ply.WantedRewardGiven[killer:SteamID()] = true
				
				killer:AddMoney(add_money)
				rp.Notify(killer, NOTIFY_GREEN, rp.Term('KnockedFactionReward'), rp.FormatMoney(add_money))
			end
		end
	end
end)
