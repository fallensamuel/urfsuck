-- TODO, SORT, CLEANUP AND MOVE EVERYTHING IN HERE TO IT'S PROPPER PLACE
function PLAYER:AddHealth(amt)
	self:SetHealth(math.min(self:Health() + amt, rp.cfg.MaxHealth))
end

function PLAYER:GiveAmmos(multiplayer, show)
	for k, v in ipairs(rp.ammoTypes) do
		self:GiveAmmo(multiplayer*v.amountGiven, v.ammoType, show)
	end
end

--[[---------------------------------------------------------
 Variables
 ---------------------------------------------------------]]
local previousname = "N/A"
local newname = "N/A"

function PLAYER:CanAfford(amount)
	if not amount or self.DarkRPUnInitialized then return false end

	return math.floor(amount) >= 0 and self:GetMoney() - math.floor(amount) >= 0
end

--[[---------------------------------------------------------
 RP names
 ---------------------------------------------------------]]
rp.AddCommand("/randomname", function(ply)
	if ply.NextNameChange and ply.NextNameChange > CurTime() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('PleaseWaitX'), math.ceil(ply.NextNameChange - CurTime()))

		return ""
	end

	local name = rp.names.Random()
	hook.Call("playerChangedRPName", GAMEMODE, ply, name)
	ply:SetRPName(name)
	ply.NextNameChange = CurTime() + 20
end)

local function RPName(ply, args)
	if ply.NextNameChange and ply.NextNameChange > CurTime() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('PleaseWaitX'), math.ceil(ply.NextNameChange - CurTime()))

		return ""
	end

	local len = utf8.len(args)
	local low = utf8.lower(args)

	if len > 20 then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('RPNameLong'), 21)

		return ""
	elseif len < 3 then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('RPNameShort'), 2)

		return ""
	end

	local canChangeName = hook.Call("CanChangeRPName", GAMEMODE, ply, low)

	if canChangeName == false then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotRPName'))

		return ""
	end

	local allowed = {
		['1'] = true, ['2'] = true, ['3'] = true, ['4'] = true, ['5'] = true, ['6'] = true, ['7'] = true, ['8'] = true, ['9'] = true, ['0'] = true,
		[' '] = true, ['('] = true, [')'] = true, ['['] = true, [']'] = true, ['!'] = true, ['@'] = true, ['#'] = true, ['$'] = true, ['%'] = true, ['^'] = true, ['&'] = true, ['*'] = true, ['-'] = true, ['_'] = true, ['='] = true, ['+'] = true, ['|'] = true, ['\\'] = true,
		['a'] = true, ['b'] = true, ['c'] = true, ['d'] = true, ['e'] = true, ['f'] = true, ['g'] = true, ['h'] = true, ['i'] = true, ['j'] = true, ['k'] = true, ['l'] = true, ['m'] = true, ['n'] = true, ['o'] = true, ['p'] = true, ['q'] = true, ['r'] = true, ['s'] = true, ['t'] = true, ['u'] = true, ['v'] = true, ['w'] = true, ['x'] = true, ['y'] = true, ['z'] = true,
		['а'] = true, ['б'] = true, ['в'] = true, ['г'] = true, ['д'] = true, ['е'] = true, ['ё'] = true, ['ж'] = true, ['з'] = true, ['и'] = true, ['й'] = true, ['к'] = true, ['л'] = true, ['м'] = true, ['н'] = true, ['о'] = true, ['п'] = true, ['р'] = true, ['с'] = true, ['т'] = true, ['у'] = true, ['ф'] = true, ['х'] = true, ['ц'] = true, ['ч'] = true, ['ш'] = true, ['щ'] = true, ['ъ'] = true, ['ы'] = true, ['ь'] = true, ['э'] = true, ['ю'] = true, ['я'] = true
	};

	for k in string.gmatch(args, utf8.charpattern) do
		if !allowed[utf8.lower(k)] then
			rp.Notify(ply, NOTIFY_ERROR, rp.Term('RPNameUnallowed'), k)

			return ""
		end
	end

	args = string.Replace(args, '_', ' ');
    local Words = string.Explode(' ', args);

	local utf8_codepoint = utf8.codepoint;

	local function IsLatin(Code) return (Code >= 65 and Code <= 90) or (Code >= 97 and Code <= 122) or (Code >= 48 and Code <= 57) end
    local function IsCyrillic(Code) return (Code >= 1040 and Code <= 1103) or (Code >= 48 and Code <= 57) end
    local Symbols = {32, 40, 41, 91, 93, 33, 64, 35, 36, 37, 94, 38, 42, 45, 95, 61, 43, 124, 92};

	local Position, Code = 1, 0;
    local Language = -1; -- en = 0, ru = 1, unknown = -1, 
    for Index, Word in pairs(Words) do
		Position = 1;
        Language = -1;
		for Char in string.gmatch(Word, utf8.charpattern) do
            Code = utf8_codepoint(Char);
			if (Language == -1) then
                Language = (IsLatin(Code) and 0) or (IsCyrillic(Code) and 1) or -1;
			else
				if !table.HasValue(Symbols, Code) and (Language == 0 and !IsLatin(Code)) or (Language == 1 and !IsCyrillic(Code)) then
                    rp.Notify(ply, NOTIFY_ERROR, rp.Term('RPNameWordLanguage'));
                    return ''
				end
            end
			Position = Position + 1;
		end
    end


	hook.Call("playerChangedRPName", GAMEMODE, ply, args)
	ply:SetRPName(args)
	ply.NextNameChange = CurTime() + 20

	return ""
end

rp.AddCommand("/rpname", RPName)
rp.AddCommand("/name", RPName)
rp.AddCommand("/nick", RPName)

function PLAYER:SetRPName(name, firstRun)
	name = string.Trim(name)
	name = utf8.sub(name, 1, 20)
	-- Make sure nobody on this server already has this RP name
	local lowername = utf8.lower(tostring(name))

	rp.data.GetNameCount(name, function(taken)
		if utf8.len(lowername) < 2 and not firstrun then return end

		-- If we found that this name exists for another player
		if taken then
			if firstRun then
				-- If we just connected and another player happens to be using our steam name as their RP name
				-- Put a 1 after our steam name
				self:SetRPName(name .. "1", firstRun)
				rp.Notify(self, NOTIFY_ERROR, rp.Term('SteamRPNameTaken'))
			else
				rp.Notify(self, NOTIFY_ERROR, rp.Term('RPNameTaken'))

				return ""
			end
		else
			rp.NotifyAll(NOTIFY_GENERIC, rp.Term('ChangeName'), self:SteamName(), name)
			rp.data.SetName(self, name)
		end
	end)
end

--[[---------------------------------------------------------
 Admin/automatic stuff
 ---------------------------------------------------------]]
function PLAYER:ChangeAllowed(t)
	if not self.bannedfrom then return true end

	if self.bannedfrom[t] == 1 then
		return false
	else
		local tTab = rp.teams[t]
		if not tTab or not tTab.faction then return true end

		for team, val in pairs(self.bannedfrom) do
			if val ~= 1 then continue end

			local tTab2 = rp.teams[team]
			local f1, f2 = tTab.faction, tTab2.faction
			if tTab2 and f2 and f1 == f2 then
				return false
			end

			local fac1, fac2 = rp.Factions[f1], rp.Factions[f2]
			if fac1 and fac2 then
				if (fac1.teammates and table.HasValue(fac1.teammates, f2)) or (fac2.teammates and table.HasValue(fac2.teammates, f1)) then
					return false
				end
			end
		end

		return true
	end
end

function PLAYER:TeamUnBan(Team)
	if not IsValid(self) then return end

	if not self.bannedfrom then
		self.bannedfrom = {}
	end

	self.bannedfrom[Team] = 0
end

function PLAYER:TeamBan(t, time)
	if not self.bannedfrom then
		self.bannedfrom = {}
	end

	t = t or self:Team()
	self.bannedfrom[t] = 1
	if time == 0 then return end

	timer.Simple(time or 180, function()
		if not IsValid(self) then return end
		self:TeamUnBan(t)
	end)
end

util.AddNetworkString("rp.OnTeamChanged")
--[[---------------------------------------------------------
 Teams/jobs
 ---------------------------------------------------------]]
function PLAYER:ChangeTeam(t, force, is_silent)
	local prevTeam = self:Team()

	if self.DeathAction or IsValid(self.HealPlayer) then
		self:Notify(NOTIFY_ERROR, rp.Term('CannotChangeJob'), 'механики возрождения')
		return false
	end
	
	if self:IsArrested() and not force then
		self:Notify(NOTIFY_ERROR, rp.Term('CannotChangeJob'), 'arrested')

		return false
	end

	if self:IsFrozen() and not force then
		self:Notify(NOTIFY_ERROR, rp.Term('CannotChangeJob'), 'frozen')

		return false
	end

	if (not self:Alive()) and not force then
		self:Notify(NOTIFY_ERROR, rp.Term('CannotChangeJob'), 'dead')

		return false
	end

	if (self.IsWantedAnyFaction and self:IsWantedAnyFaction() or self:IsWanted()) and not force then
		self:Notify(NOTIFY_ERROR, rp.Term('CannotChangeJob'), 'wanted')

		return false
	end

	if rp.agendas[prevTeam] and (rp.agendas[prevTeam].manager == prevTeam) then
		nw.SetGlobal('Agenda;' .. self:Team(), nil)
	end

	if t ~= rp.DefaultTeam and not self:ChangeAllowed(t) and not force then
		rp.Notify(self, NOTIFY_ERROR, rp.Term('BannedFromJob'))
		--print('Fail job', 1)
		return false
	end

	if self.LastJob and 1 - (CurTime() - self.LastJob) >= 0 and not force then
		self:Notify(NOTIFY_ERROR, rp.Term('NeedToWait'), math.ceil(1 - (CurTime() - self.LastJob)))

		return false
	end

	if self.IsBeingDemoted then
		self:TeamBan()
		self.IsBeingDemoted = false
		self:ChangeTeam(1, true)
		GAMEMODE.vote.DestroyVotesWithEnt(self)
		rp.Notify(self, NOTIFY_ERROR, rp.Term('EscapeDemotion'))

		return false
	end

	if prevTeam == t then
		rp.Notify(self, NOTIFY_ERROR, rp.Term('AlreadyThisJob'))

		return false
	end

	local TEAM = rp.teams[t]
	if not TEAM then return false end

	if TEAM.vip and (not self:IsVIP()) then
		rp.Notify(self, NOTIFY_ERROR, rp.Term('NeedVIP'))

		return
	end

	if TEAM.likeReactions and self:GetLikeReacts() < TEAM.likeReactions then
		rp.Notify(self, NOTIFY_ERROR, rp.Term('JobLikeReactsRequired'), TEAM.likeReactions, TEAM.likeReactions - self:GetLikeReacts())
		return
	end

	if TEAM.customCheck and not TEAM.customCheck(self) then
		rp.Notify(self, NOTIFY_ERROR, rp.Term(TEAM.CustomCheckFailMsg or 'BannedFromJob'))
		--print('Fail job', 2)

		return false
	end

	local max = TEAM.max
	if not force and (!(self:IsVIP() and max != 1 and !TEAM.vip) or (TEAM.forceLimit)) then
		

		if max ~= 0 and (max >= 1 and team.NumPlayers(t) >= max or max < 1 and (team.NumPlayers(t) + 1) / #player.GetAll() > max) then
			-- absolute maximum
			-- fractional limit (in percentages)
			rp.Notify(self, NOTIFY_ERROR, rp.Term('JobLimit'))

			return false
		end -- No limit
	end

	if TEAM.PlayerChangeTeam then
		local val = TEAM.PlayerChangeTeam(self, prevTeam, t)
		if val ~= nil then return val end
	end

	local hookValue = hook.Call("playerCanChangeTeam", nil, self, t, force)
	if hookValue == false then return false end

	if prone and prone.Exit then
		prone.Exit(self, true)
	end

	local isMayor = rp.teams[prevTeam] and rp.teams[prevTeam].mayor
	if isMayor then
		rp.resetLaws()
	end

	if not is_silent and not rp.cfg.Serious then
		rp.NotifyAll(NOTIFY_GENERIC, rp.Term('ChangeJob'), self, TEAM.name)
	end
	
	print(self, 'ChangeJob to', TEAM.name, 'faction', TEAM.faction and rp.Factions[TEAM.faction] and rp.Factions[TEAM.faction].printName or TEAM.faction)

	if self:GetNetVar("HasGunlicense") then
		self:SetNetVar("HasGunlicense", nil)
	end

	net.Start('EmoteActions.SetupModel')
	net.Send(self)
	
	self:RemoveAllHighs()
	self.PlayerModel = nil
	self.LastJob = CurTime()

	--[[
	for k, v in ipairs(ents.GetAll()) do
		if (v.ItemOwner == self) and v.RemoveOnJobChange then
			v:Remove()
		end
	end
	]]--

	if (self:GetNetVar('job') ~= nil) then
		self:SetNetVar('job', nil)
	end

	self:SetVar('lastpayday', CurTime() + 180, false, false)
	self:SetTeam(t)
	hook.Call("OnPlayerChangedTeam", GAMEMODE, self, prevTeam, t)

	if self:InVehicle() then
		self:ExitVehicle()
	end

	self:KillSilent()
	
	gamemode.Call( "PlayerSetModel", self );
	self:UpdateAppearance();

	net.Start("rp.OnTeamChanged")
		net.WriteUInt(prevTeam, 32)
	net.Send(self)

	return true
end

hook('PlayerThink', function(pl)
	if (pl:GetVar('lastpayday') ~= nil) and (pl:GetVar('lastpayday') < CurTime()) then
		pl:PayDay()
	end
end)

--[[---------------------------------------------------------
 Money
 ---------------------------------------------------------]]
function PLAYER:PayDay()
	if not IsValid(self) then return end

	if not self:IsArrested() then
		local amount = self:GetSalary() or 0
		local amount_event = hook.Call("PlayerPayDay", GAMEMODE, self, amount)

		if amount_event then
			amount = amount_event
		end

		if amount == 0 then
			rp.Notify(self, NOTIFY_ERROR, rp.Term('PayDayUnemployed'))
		else
			local tax = (self:GetVar('doorCount') or 0) * rp.cfg.PropertyTax
			local add = amount - tax
			
			if add < 0 and self:GetMoney() + add < 0 then
				add = -self:GetMoney()
			end
			
			self:AddMoney(add)

			if (tax > 0) then
				rp.Notify(self, NOTIFY_GREEN, rp.Term('PaydayTax'), amount, tax)
			else
				rp.Notify(self, NOTIFY_GREEN, rp.Term('Payday'), amount)
			end
		end

		--if self.isGood != false then
		--	rp.Notify(self, NOTIFY_GREEN, rp.Term('GoodKarmaGain'), 2)
		--	self:AddKarma(2)
		--else
		--	self.isGood = true
		--end
	else
		rp.Notify(self, NOTIFY_ERROR, rp.Term('PayDayMissed'))
	end

	self:SetVar('lastpayday', CurTime() + 180, false, false)
end

--[[---------------------------------------------------------
 Items
 ---------------------------------------------------------]]
function PLAYER:DropDRPWeapon(weapon)
	local ammo = self:GetAmmoCount(weapon:GetPrimaryAmmoType())
	local in_inv = false
	
	if self.getInvID and self:getInvID() then
		for k, v in pairs(rp.item.getInv(self:getInvID()):getItems()) do
			if (v.isWeapon and v.class == weapon:GetClass() and v:getData("equip")) then
				local count = v:getCount()
				
				if (count == nil or count == 1) then
					v:remove()
				else
					v:addCount(-1)
					v:setData("equip", false, self)
				end
				
				in_inv = true
				break
			end
		end
	end
	
	if in_inv then
		rp.item.spawn(weapon:GetClass(), self, function(item, entity)
			entity:GetPhysicsObject():EnableMotion(true)
			entity:GetPhysicsObject():Wake()
		end)
	else
		local ent = ents.Create("spawned_weapon")
		local model = (weapon:GetModel() == "models/weapons/v_physcannon.mdl" and "models/weapons/w_physics.mdl") or weapon:GetModel()
		ent.ShareGravgun = true
		ent:SetPos(self:GetShootPos() + self:GetAimVector() * 30)
		ent:SetModel(model)
		ent:SetSkin(weapon:GetSkin())
		ent.weaponclass = weapon:GetClass()
		ent.nodupe = true
		ent.clip1 = weapon:Clip1()
		ent.clip2 = weapon:Clip2()
		ent.ammoadd = ammo
		ent:Spawn()
	end
	
	self:RemoveAmmo(ammo, weapon:GetPrimaryAmmoType())
	self:DropWeapon(weapon) -- Drop it so the model isn't the viewmodel
	weapon:Remove()
end

timer.Create('PlayerThink', 5, 0, function()
	local pls = player.GetAll()

	for i = 1, #pls do
		if IsValid(pls[i]) then
			hook.Call('PlayerThink', GAMEMODE, pls[i])
		end
	end
end)

--hook('PlayerDeath', 'Karma.PlayerDeath', function(victim, inflictor, attacker)
--	if attacker:IsPlayer() and (attacker ~= victim) and (not victim:IsBanned()) then
--		attacker:AddKarma(-2)
--		attacker.isGood = false
--		rp.Notify(attacker, NOTIFY_ERROR, rp.Term('LostKarma'), '2', 'убийство')
--	end
--end)