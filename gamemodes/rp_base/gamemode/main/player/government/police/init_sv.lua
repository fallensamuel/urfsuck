rp.ArrestedPlayers = rp.ArrestedPlayers or {}

local last_action = {}

function PLAYER:IsWarranted()
	return (self.HasWarrant == true)
end

function PLAYER:Warrant(actor, reason)
	if IsValid(actor) then
		if last_action[actor] and last_action[actor] > CurTime() then 
			return rp.Notify(actor, NOTIFY_ERROR, rp.Term('WarrantTooMuch'))
		end
		
		last_action[actor] = CurTime() + 50
	end
	
	self.HasWarrant = true
	timer.Simple(rp.cfg.WarrantTime, function()
		if IsValid(self) then
			self:UnWarrant()
		end
	end)
	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('Warranted'), self:Name(), reason, (IsValid(actor) and actor:Name() or translates.Get('АвтоРозыск')))
	hook.Call('PlayerWarranted', GAMEMODE, self, actor, reason)
end

function PLAYER:UnWarrant(actor)
	rp.Notify(self, NOTIFY_GREEN, rp.Term('WarrantExpired'))
	self.HasWarrant = nil
	hook.Call('PlayerUnWarranted', GAMEMODE, self, actor)
end

hook('PlayerEntityCreated', function(pl)
	if pl:IsArrested() then
		pl:Arrest(nil, 'Disconnecting to avoid arrest')
	end
end)


if rp.cfg.NewWanted then return end


function PLAYER:Wanted(actor, reason)
	if (type(actor) == 'Player' and IsValid(actor)) then
		if last_action[actor] and last_action[actor] > CurTime() then 
			return rp.Notify(actor, NOTIFY_ERROR, rp.Term('WantedTooMuch'))
		end
		
		last_action[actor] = CurTime() + 50
	end
	
	if utf8.len(reason) > 64 then
		reason = utf8.sub(reason, 1, 64) .. '...'
	end
	
	if self:IsBanned() || (self.IsZombie and self:IsZombie()) then return end
	self.CanEscape = nil
	self:SetNetVar('IsWanted', true)
	self:SetNetVar('WantedReason', reason)
	timer.Create('Wanted' .. self:SteamID64(), rp.cfg.WantedTime, 1, function()
		if IsValid(self) then
			self:UnWanted()
		end
	end)
	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('Wanted'), self:Name(), reason, (IsValid(actor) and actor:Name() or translates.Get('АвтоРозыск')))
	hook.Call('PlayerWanted', GAMEMODE, self, actor, reason)
end

function PLAYER:UnWanted(actor)
	self:SetNetVar('IsWanted', nil)
	self:SetNetVar('WantedReason', nil)
	timer.Destroy('Wanted' .. self:SteamID64())
	hook.Call('PlayerUnWanted', GAMEMODE, self, actor)
end

local jails = rp.cfg.JailPos[game.GetMap()]
function PLAYER:Arrest(actor, reason)
	if self:IsBanned() then return end

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

	self:SetNetVar('ArrestedInfo', {Reason = (reason or self:GetWantedReason()), Release = CurTime() + time})
	if self:IsWanted() then self:UnWanted() end
		
	rp.ArrestedPlayers[self:SteamID64()] = true
		
	self:StripWeapons()
	self:SetHunger(100)
	self:SetHealth(100)
	self:SetArmor(0)

	self:Give("weapon_hands")

	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('Arrested'), self:Name())
	hook.Call('PlayerArrested', GAMEMODE, self, actor)

	self:Teleport(util.FindEmptyPos(jails[math.random(#jails)]))

	timer.Simple(1, function() if IsValid(self) then self.CanEscape = true end end)
end

function PLAYER:UnArrest(actor)
	self:SetNetVar('ArrestedInfo', nil)
	timer.Destroy('Arrested' .. self:SteamID64())
	rp.ArrestedPlayers[self:SteamID64()] = nil
	self:ExitVehicle()
	timer.Simple(0.3, function() -- fucks up otherwise
		if not IsValid(self) then return end
		local _, pos = GAMEMODE:PlayerSelectSpawn(self)
		self:Teleport(pos)
		self:SetHealth(100)
		hook.Call('PlayerLoadout', GAMEMODE, self)
		rp.NotifyAll(NOTIFY_GENERIC, rp.Term('UnArrested'), self:Name())
		hook.Call('PlayerUnArrested', GAMEMODE, self, actor)
	end)
end


-- Commands
rp.AddCommand('/911', function(pl, text)
	if (text == '') then return end
	for k, v in ipairs(player.GetAll()) do
		if v:IsCP() or (v == pl) then
			rp.Chat(CHAT_NONE, v, Color(255,255,51), '[911]', pl, text)
		end
	end
end)

rp.AddCommand('/want', function(pl, text, args)
	if not pl:IsCombine() and not pl:IsMayor() or not args[1] or not args[2] then return end
	local targ = rp.FindPlayer(args[1])
	if not IsValid(targ) then 
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('WantedPlayerNotFound'), args[1])
	elseif targ:IsWanted() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PlayerAlreadyWanted'), args[1])
	else
		local reason = table.concat(args, ' ', 2)
		targ:Wanted(pl, reason)
	end
end)

rp.AddCommand('/quickwant', function(pl, text, args)
	if not pl:IsCombine() and not pl:IsMayor() then return end
	local targ = pl:GetEyeTrace(pl).Entity
	if not IsValid(targ) or not targ:IsPlayer() or targ:IsWanted() then return end
	targ:Wanted(pl, 'Quickwanted')
end)

rp.AddCommand('/unwant', function(pl, text, args)
	if not pl:IsCombine() and not pl:IsMayor() then return end
	local targ = rp.FindPlayer(args[1])
	if not IsValid(targ) then 
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('WantedPlayerNotFound'), args[1])
	elseif not targ:IsWanted() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PlayerNotWanted'), args[1])
	else
		targ:UnWanted(pl)
	end
end)

--rp.AddCommand('/warrant', function(pl, text, args)
--	if not pl:IsCP() and not pl:IsMayor() or not args[1] or not args[2] then return end
--	local targ = rp.FindPlayer(args[1])
--	if not IsValid(targ) then 
--		rp.Notify(pl, NOTIFY_ERROR, rp.Term('WantedPlayerNotFound'), args[1])
--	elseif targ:IsWarranted() then
--		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PlayerAlreadyWarranted'), args[1])
--	else
--		local reason = table.concat(args, ' ', 2)
--		for k, v in pairs(rp.teams) do
--			if v.mayor then
--				mayors = team.GetPlayers(k)
--			end
--		end
--		if (#mayors > 1) and not pl:IsMayor() then
--			GAMEMODE.ques:Create(pl:Name() .. ' has requested a search warrant on ' .. targ:Name() .. ' for ' ..  reason, targ:EntIndex() .. 'warrant', mayors[1], 40, function(ret)
--				if IsValid(targ) and tobool(ret) then
--					rp.Notify(pl, NOTIFY_GREEN, rp.Term('WarrantRequestAcc'))
--					targ:Warrant(pl, reason)
--				else
--					rp.Notify(pl, NOTIFY_ERROR, rp.Term('WarrantRequestDen'))
--				end
--			end, pl, targ, reason)
--		else
--			targ:Warrant(pl, reason)
--			rp.Notify(pl, NOTIFY_GREEN, rp.Term('WarrantRequestAcc'))
--		end
--	end
--end)

--rp.AddCommand('/unwarrant', function(pl, text, args)
--	if not pl:IsCP() and not pl:IsMayor() or not args[1] then return end
--	local targ = rp.FindPlayer(args[1])
--	if not IsValid(targ) then 
--		rp.Notify(pl, NOTIFY_ERROR, rp.Term('WantedPlayerNotFound'), args[1])
--	elseif not targ:IsWarranted() then
--		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PlayerNotWarranted'), args[1])
--	else
--		targ:UnWarrant(pl)
--	end
--end)


local bounds = rp.cfg.Jails[game.GetMap()]
if bounds then
	hook('PlayerThink', function(pl)
		if IsValid(pl) and pl:IsArrested() and pl.CanEscape and (not pl:InBox(bounds[1], bounds[2])) then
			rp.ArrestedPlayers[pl:SteamID64()] = nil
			pl:SetNetVar('ArrestedInfo', nil)
			timer.Destroy('Arrested' .. pl:SteamID64())
					
			--pl:Wanted(nil, 'Побег из Тюрьмы')

			hook.Call('PlayerLoadout', GAMEMODE, pl)
		end
	end)
end

hook('PlayerDeath', function(pl, killer, dmginfo)
	if (!killer:IsPlayer()) then return end
	
	if pl:IsWanted() and killer:IsCombine() and (pl ~= killer) and (killer ~= game.GetWorld()) then
		pl:Arrest(killer)
	end
end)
