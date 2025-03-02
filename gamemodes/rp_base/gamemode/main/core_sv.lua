local ipairs = ipairs
local IsValid = IsValid
local string = string
local table = table
local ents = ents
local math = math

function GM:CanChangeRPName(ply, RPname)
	if string.find(RPname, "\160") or string.find(RPname, " ") == 1 then return false end -- disallow system spaces
	if table.HasValue({"ooc", "shared", "world", "n/a", "world prop", "STEAM", 'stoned', 'penguin'}, RPname) and (not pl:IsRoot()) then return false end
end

function GM:CanDemote(pl, target, reason)
end

function GM:CanVote(pl, vote)
end

function GM:OnPlayerChangedTeam(pl, oldTeam, newTeam)
end

function GM:CanDropWeapon(pl, weapon)
	if not IsValid(weapon) then return false end
	local class = string.lower(weapon:GetClass())
	if rp.cfg.DisallowDrop[class] then return false end
	if table.HasValue(pl.Weapons, weapon) then return false end

	for k, v in pairs(rp.shipments) do
		if v.entity ~= class then continue end

		return true
	end

	return false
end

function PLAYER:CanDropWeapon(weapon)
	return GAMEMODE:CanDropWeapon(self, weapon)
end

function GM:UpdatePlayerSpeed(pl)
	self:SetPlayerSpeed(pl, rp.cfg.WalkSpeed, rp.cfg.RunSpeed)
end

--[[---------------------------------------------------------
 Stuff we don't use
 ---------------------------------------------------------]]
timer.Simple(0.5, function()
	local GM = GAMEMODE
--	GM.CalcMainActivity = nil
--  GM.SetupMove = nil
	GM.FinishMove = nil
	GM.Move = nil
	GM.UpdateAnimation = nil
	GM.Think = nil
	GM.Tick = nil
	GM.PlayerTick = nil
	GM.PlayerPostThink = nil
	GM.KeyPress = nil
	GM.EntityRemoved = nil
	GM.EntityKeyValue = nil
	
	if not rp.cfg.RunHandlePlayerHooks then
		GM.HandlePlayerJumping = nil
		GM.HandlePlayerDucking = nil
		GM.HandlePlayerNoClipping = nil
		GM.HandlePlayerVaulting = nil
		GM.HandlePlayerSwimming = nil
		GM.HandlePlayerLanding = nil
		GM.HandlePlayerDriving = nil
	end
end)

--[[---------------------------------------------------------
 Gamemode functions
 ---------------------------------------------------------]]
function GM:PlayerLeaveVehicle(pl, veh)
	if veh:CanLockUnlock(pl) then
		veh:DoorLock(true)
	end
end

function GM:CanPlayerEnterVehicle(pl)
	return (not pl:IsBanned())
end

function GM:PlayerUse(pl, ent)
	return (not pl:IsBanned())
end

function GM:PlayerSpawnSENT(pl, ent)
	--return ent != "xmaxgifts" && pl:IsSuperAdmin() or pl:IsRoot()
	return ba.IsSuperAdmin(pl) or pl:IsRoot()
end

function GM:PlayerSpawnSWEP(pl, class, model)
	return ba.IsSuperAdmin(pl)
end

function GM:PlayerGiveSWEP(pl, class, model)
	return ba.IsSuperAdmin(pl)
end

function GM:PlayerSpawnVehicle(pl, model)
	return pl:HasFlag("e") or pl:IsRoot()
end

function GM:PlayerSpawnNPC(pl, model)
	return pl:HasFlag("e") or pl:IsRoot()
end

function GM:PlayerSpawnRagdoll(pl, model)
	return pl:HasAccess('*')
end

function GM:PlayerSpawnEffect(pl, model)
	return pl:HasAccess('*')
end

function GM:PlayerSpray(pl)
	return true
end

function GM:CanDrive(pl, ent)
	return false
end

function GM:CanProperty(pl, property, ent)
	return false
end

function GM:OnPhysgunFreeze(weapon, phys, ent, pl)
	if ent.PhysgunFreeze and (ent:PhysgunFreeze(pl) == false) then return false end
	if (ent:GetPersistent()) then return false end
	-- Object is already frozen (!?)
	if (not phys:IsMoveable()) then return false end
	if (ent:GetUnFreezable()) then return false end
	phys:EnableMotion(false)

	-- With the jeep we need to pause all of its physics objects
	-- to stop it spazzing out and killing the server.
	if (ent:GetClass() == "prop_vehicle_jeep") then
		local objects = ent:GetPhysicsObjectCount()

		for i = 0, objects - 1 do
			local physobject = ent:GetPhysicsObjectNum(i)
			physobject:EnableMotion(false)
		end
	end

	-- Add it to the player's frozen props
	pl:AddFrozenPhysicsObject(ent, phys)

	return true
end

function GM:PlayerShouldTaunt(pl, actid)
	return true
end

function GM:CanTool(pl, trace, mode)
	return (not pl:IsBanned()) and (not pl:IsJailed()) and (not pl:IsArrested())
end

function GM:CanPlayerSuicide(pl)
	if rp.cfg.Serious then
		return false
	end
	
	if pl:IsArrested() then
		pl:Notify(NOTIFY_ERROR, rp.Term('CantSuicideJail'))
	elseif (pl.IsWantedAnyFaction and pl:IsWantedAnyFaction() or pl:IsWanted()) then
		pl:Notify(NOTIFY_ERROR, rp.Term('CantSuicideWanted'))
	elseif pl:IsFrozen() then
		pl:Notify(NOTIFY_ERROR, rp.Term('CantSuicideFrozen'))
	elseif ((pl.LastSuicide ~= nil) and pl.LastSuicide >= CurTime()) then
		if pl:IsRoot() then return true end
		pl:Notify(NOTIFY_ERROR, rp.Term('CantSuicideLiveFor'))
	elseif (not pl:IsBanned()) and (not pl:IsJailed()) and (not (pl.IsHandcuffed and pl:IsHandcuffed())) then
		pl:Notify(NOTIFY_ERROR, rp.Term('YouSuicided'))
		--pl:EmitSound(rp.cfg.DeathSound and (istable(rp.cfg.DeathSound) and rp.cfg.DeathSound[math.random(#rp.cfg.DeathSound)] or rp.cfg.DeathSound) or 'ambient/creatures/town_child_scream1.wav')
		pl.LastSuicide = CurTime() + 300

		return true
	end

	return false
end

function GM:PlayerSpawnProp(ply, model)
	if ply:IsBanned() or ply:IsJailed() or ply:IsArrested() or ply:IsFrozen() then return false end
	model = string.gsub(tostring(model), "\\", "/")
	model = string.gsub(tostring(model), "//", "/")

	return ply:CheckLimit('props')
end

function GM:ShowSpare1(ply)
	if rp.teams[ply:Team()] and rp.teams[ply:Team()].ShowSpare1 then return rp.teams[ply:Team()].ShowSpare1(ply) end
end

function GM:ShowSpare2(ply)
	if rp.teams[ply:Team()] and rp.teams[ply:Team()].ShowSpare2 then return rp.teams[ply:Team()].ShowSpare2(ply) end
end

function GM:OnNPCKilled(victim, ent, weapon)
	---- If something killed the npc
	--if ent then
	--	if ent:IsVehicle() and ent:GetDriver():IsPlayer() then
	--		ent = ent:GetDriver()
	--	end
--
	--	-- If we know by now who killed the NPC, pay them.
	--	if IsValid(ent) and ent:IsPlayer() then
	--		local xp = rp.Karma(ent, 5, 75) -- TODO: FIX
	--		local money = rp.Karma(ent, 5, 100)
	--		ent:AddMoney(money)
	--		rp.Notify(ent, NOTIFY_GREEN, rp.Term('+Money'), money)
	--	end
	--end
end

local player_GetAll = player.GetAll
local GetShootPos = PLAYER.GetShootPos
local DistToSqr = VECTOR.DistToSqr
local hook_Run = hook.Run

local channels = rp.RadioChanels

local thisisbool = isbool

local CanHear, NotRadio = {}, {}

local pls, distCahce, ply1, ply2, isRadio1, isRadio2, _a, _b, ply1pos, ply1rch

timer.Create('PlayerHearVoice', 0.5, 0, function()
    pls = player_GetAll()

    for a = 1, #pls - 1 do
		ply1 = pls[a]
		ply1pos = GetShootPos(ply1)
		ply1rch = channels and channels[ply1:Team()] and ply1:GetNetVar('RC_RadioOnHear')
		
        if not CanHear[ply1] or not NotRadio[ply1] then
            CanHear[ply1] = {}
            NotRadio[ply1] = {}
        end
		
        for b = a + 1, #pls do
        	ply2 = pls[b]
			
            if not CanHear[ply2] or not NotRadio[ply2] then
                CanHear[ply2] = {}
                NotRadio[ply2] = {}
            end
			
			isRadio1 = ply1rch and channels[ply1:Team()][ply2:Team()] and ply2:GetNetVar('RC_RadioOnSpeak')
			isRadio2 = channels and channels[ply2:Team()] and channels[ply2:Team()][ply1:Team()] and ply2:GetNetVar('RC_RadioOnHear') and ply1:GetNetVar('RC_RadioOnSpeak')
			
			distCahce = DistToSqr(ply1pos, GetShootPos(ply2)) <= 302500
			
			if (isRadio1 or distCahce) and not ply2:IsBanned() then
				CanHear[ply1][ply2] = true
				NotRadio[ply1][ply2] = not isRadio1
			else
				CanHear[ply1][ply2] = nil
				NotRadio[ply1][ply2] = true
			end
			
			if (isRadio2 or distCahce) and not ply1:IsBanned() then
				CanHear[ply2][ply1] = true
				NotRadio[ply2][ply1] = not isRadio2
			else
				CanHear[ply2][ply1] = nil
				NotRadio[ply2][ply1] = true
			end
			
			_a, _b = hook_Run("PlayerHearVoice", ply1, ply2, CanHear[ply1][ply2], NotRadio[ply1][ply2])
			if thisisbool(_a) then CanHear[ply1][ply2] = _a end
			if thisisbool(_b) then NotRadio[ply1][ply2] = _b end
			
			_a, _b = hook_Run("PlayerHearVoice", ply2, ply1, CanHear[ply2][ply1], NotRadio[ply2][ply1])
			if thisisbool(_a) then CanHear[ply2][ply1] = _a end
			if thisisbool(_b) then NotRadio[ply2][ply1] = _b end
        end
    end

end)

local GetCanHear = function(p1, p2)
	return CanHear[p1] and CanHear[p1][p2] or false
end

local GetNotRadio = function(p1, p2)
	return not NotRadio[p1] or NotRadio[p1][p2]
end

function GM:PlayerCanHearPlayersVoice(p1, p2)
	return GetCanHear(p1, p2), GetNotRadio(p1, p2)
end

function string.StripPort(ip)
	local p = string.find(ip, ':')
	if (not p) then return ip end

	return string.sub(ip, 1, p - 1)
end

function GM:DoPlayerDeath(pl, attacker, dmginfo)
	if !pl:GetJobTable().headcrab then
		pl:CreateRagdoll()
	end
	pl.LastRagdoll = (CurTime() + rp.cfg.RagdollDelete)
end

timer.Create('RemoveRagdolls', 10, 0, function()
	local pls = player.GetAll()

	for i = 1, #pls do
		local ply = pls[i]

		if IsValid(ply) and ply.LastRagdoll and ply.LastRagdoll <= CurTime() then
			local rag = ply:GetRagdollEntity()

			if IsValid(rag) then
				rag:Remove()
			end
		end
	end
end)

function GM:PlayerDeathThink(pl)
	if (not pl.NextReSpawn or pl.NextReSpawn < SysTime()) and (pl:KeyPressed(IN_ATTACK) or pl:KeyPressed(IN_ATTACK2) or pl:KeyPressed(IN_JUMP) or pl:KeyPressed(IN_FORWARD) or pl:KeyPressed(IN_BACK) or pl:KeyPressed(IN_MOVELEFT) or pl:KeyPressed(IN_MOVERIGHT) or pl:KeyPressed(IN_JUMP)) then
		pl:Spawn()
	end
end

function GM:PlayerDeath(ply, weapon, killer)
	if rp.teams[ply:Team()] and rp.teams[ply:Team()].PlayerDeath then
		rp.teams[ply:Team()].PlayerDeath(ply, weapon, killer)
	end

	ply:Extinguish()

	if ply:GetNetVar('HasGunlicense') then
		ply:SetNetVar('HasGunlicense', nil)
	end

	if ply:InVehicle() then
		ply:ExitVehicle()
	end

	ply.NextReSpawn = SysTime() + 1
end

function GM:PlayerCanPickupWeapon(ply, weapon)
	if ply:IsBanned() or ply:IsJailed() then return false end
	if ply:IsArrested() and weapon:GetClass() ~= "weapon_hands" then return false end
	if weapon and weapon.PlayerUse == false then return false end

	if rp.teams[ply:Team()] then
		if rp.teams[ply:Team()].build == false then
			if not rp.teams[ply:Team()].weaponsMap then
				rp.teams[ply:Team()].weaponsMap = {}
				
				for k, v in pairs(rp.teams[ply:Team()].weapons or {}) do
					rp.teams[ply:Team()].weaponsMap[v] = true
				end
			end
			
			return rp.teams[ply:Team()].weaponsMap[weapon:GetClass()]
		end
		
		if rp.teams[ply:Team()].PlayerCanPickupWeapon then
			return rp.teams[ply:Team()].PlayerCanPickupWeapon(ply, weapon)
		end
	end

	return true
end

local function HasValue(t, val)
	for k, v in ipairs(t) do
		if (string.lower(v) == string.lower(val)) then return true end
	end
end

function GM:PlayerSetModel(pl)
	if rp.teams[pl:Team()] and rp.teams[pl:Team()].PlayerSetModel then return rp.teams[pl:Team()].PlayerSetModel(pl) end

	if (pl:GetVar('Model') ~= nil) and (istable(rp.teams[pl:Team()].model) and HasValue(rp.teams[pl:Team()].model, pl:GetVar('Model')) or pl:GetVar('IsCustomModel')) then
		pl:SetModel(pl:GetVar('Model'))
	else
		pl:SetModel(team.GetModel(pl:GetJob() or 1))
	end

	pl:SetupHands()
end

local default_hands = {["models/weapons/c_arms_citizen.mdl"] = true}

local function SetCustomHands(hands_ent, jtab)
	if jtab.HandsModel then hands_ent:SetModel(jtab.HandsModel) end
	if jtab.HandsSkin then hands_ent:SetSkin(jtab.HandsSkin) end
	if jtab.HandsBodygroups then hands_ent:SetBodyGroups(jtab.HandsBodygroups) end

	return jtab.HandsModel and true
end

local function SetDefaultHands(hands_ent, info)
	hands_ent:SetModel(info.model)
	hands_ent:SetSkin(info.skin)
	hands_ent:SetBodyGroups(info.body)
end

function GM:PlayerSetHandsModel(ply, hands_ent)
	local jtab = ply:GetJobTable()

	if jtab.ForceCustomHands and SetCustomHands(hands_ent, jtab) then return end

	local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
	local info = player_manager.TranslatePlayerHands(simplemodel)

	if info and default_hands[info.model] == nil then
		SetDefaultHands(hands_ent, info)
	else
		local s = SetCustomHands(hands_ent, jtab) or SetDefaultHands(hands_ent, info)
	end
end

hook('PlayerDataLoaded', function(ply)
	ply:SetTeam(rp.GetDefaultTeam(ply), true)
	ply:Spawn()
end)

function GM:PlayerInitialSpawn(ply)
	ply:SetTeam(1)

	for k, v in ipairs(ents.GetAll()) do
		if IsValid(v) and (v.deleteSteamID == ply:SteamID()) then
			ply:_AddCount(v:GetClass(), v)
			v.ItemOwner = ply

			if v.Setowning_ent then
				v:Setowning_ent(ply)
			end

			v.deleteSteamID = nil
			timer.Remove("Remove" .. v:EntIndex())
		end
	end
end

local map = game.GetMap()
local lastpos = 1
local TeamSpawns = rp.cfg.TeamSpawns[map]
local JailSpawns = rp.cfg.JailPos[map]
local NormalSpawns = rp.cfg.SpawnPos[map]
local SpawnPoints = rp.cfg.SpawnPoints

local function ensureEmptyPos(pos, ent, area)
	area = (area or 50) * .8
	local half_area = area * .5
	
	local tr = util.TraceHull({
		start = pos,
		endpos = pos,
		maxs = Vector(half_area, half_area, area),
		mins = Vector(-half_area, -half_area, 1),
		filter = ent
	})
	
	--print(tr.Entity)
	return not tr.Hit
end

function GM:PlayerSelectSpawn(pl)
	local pos

	if pl:IsArrested() then
		if rp.cfg.NewWanted then
			local faction = rp.ArrestedPlayers[pl:SteamID64()]
			local poses = rp.police.Factions[faction].jail[game.GetMap()].poses
			pos = poses[math.random(1, #poses)]
			
		else
			pos = JailSpawns[math.random(1, #JailSpawns)]
		end
		
	elseif pl.spawnPoint then
		pos = table.Random(SpawnPoints[pl.spawnPoint].Spawns)
	elseif (TeamSpawns[pl:Team()] ~= nil) then
		pos = TeamSpawns[pl:Team()][math.random(1, #TeamSpawns[pl:Team()])]
	else
		lastpos = (lastpos % #NormalSpawns) + 1 
		pos = util.FindEmptyPos(NormalSpawns[lastpos], 50, 8)

		--pos = NormalSpawns[math.random(1, #NormalSpawns)]
		--if (pos == lastpos) then
		--	pos = NormalSpawns[math.random(1, #NormalSpawns)]
		--end

		--lastpos = pos
		
		if not ensureEmptyPos(pos, pl) then
			lastpos = (lastpos % #NormalSpawns) + 1 
			pos = util.FindEmptyPos(NormalSpawns[lastpos], 50, 8)
			--print('Selected new pos')
		end
		
		return self.SpawnPoint, pos
	end

	return self.SpawnPoint, util.FindEmptyPos(pos)
end

local team_table
function GM:PlayerSpawn(ply)
	player_manager.SetPlayerClass(ply, 'rp_player')
	ply:SetNoCollideWithTeammates(false)
	ply:UnSpectate()
	ply:SetHealth(100)
	ply:SetJumpPower(200)
	GAMEMODE:SetPlayerSpeed(ply, rp.cfg.WalkSpeed, rp.cfg.RunSpeed)
	ply:Extinguish()

	ply:SetMaterial('')

	if IsValid(ply:GetActiveWeapon()) then
		ply:GetActiveWeapon():Extinguish()
	end

	if ply.demotedWhileDead then
		ply.demotedWhileDead = nil
		ply:ChangeTeam(rp.GetDefaultTeam(ply))
	end

	ply:ShouldDropWeapon(false) -- Вероятно это решит баг с дропом оружия после смерти (судя по тестам на аликс)

	ply:GetTable().StartHealth = ply:Health()
	gamemode.Call("PlayerSetModel", ply)
	gamemode.Call("PlayerLoadout", ply)
	local _, pos = self:PlayerSelectSpawn(ply)
	
	ply:Teleport(pos)
	local view1, view2 = ply:GetViewModel(1), ply:GetViewModel(2)

	if IsValid(view1) then
		view1:Remove()
	end

	if IsValid(view2) then
		view2:Remove()
	end

	team_table = rp.teams[ply:Team()]
	if team_table then
		if team_table.PlayerSpawn then
			team_table.PlayerSpawn(ply)
		end
		if team_table.armor then
			ply:GiveArmor(team_table.armor)
		end
		if team_table.health then
			ply:AddMaxHealth(team_table.health < 100 && team_table.health || team_table.health - 100)
		end
		--if team_table.SetBodygroups then
		--	team_table.SetBodygroups(ply)
		--end
		if team_table.speed then
			GAMEMODE:SetPlayerSpeed(ply, rp.cfg.WalkSpeed, rp.cfg.RunSpeed * team_table.speed)
		end
	end

	ply:AllowFlashlight(true)
end

function GM:PlayerLoadout(ply)
	if ply:IsArrested() then
		ply:Give("weapon_hands")
		return
	end
	player_manager.RunClass(ply, "Spawn")
	local Team = ply:Team() or 1
	if not rp.teams[Team] then ply.Weapons = {} return end

	if rp.teams[ply:Team()].PlayerLoadout then
		rp.teams[ply:Team()].PlayerLoadout(ply)
	end

	for k, v in ipairs(rp.teams[Team].weapons or {}) do
		ply:Give(v)
	end

	if rp.teams[ply:Team()].DontHaveDefaultSWEPS then
		ply.Weapons = {}
		return
	end

	for k, v in ipairs(rp.cfg.DefaultWeapons) do
		ply:Give(v)
	end

	if ply:IsAdmin() then
		ply:Give("weapon_keypadchecker")
	end

	ply:SelectWeapon('pocket')

	if rp.teams[ply:Team()].PostPlayerLoadout then
		rp.teams[ply:Team()].PostPlayerLoadout(ply)
	end

	ply.Weapons = ply:GetWeapons()
end

local function removeDelayed(ent, ply)
	ent.deleteSteamID = ply:SteamID()

	timer.Create("Remove" .. ent:EntIndex(), (ent.RemoveDelay or math.random(180, 900)), 1, function()
		SafeRemoveEntity(ent)
	end)
end

-- Remove shit on disconnect
function GM:PlayerDisconnected(ply)
	if ply:IsAgendaManager() then
		nw.SetGlobal('Agenda;' .. ply:Team(), nil)
	end

	if ply:IsMayor() then
		nw.SetGlobal('mayorGrace', nil)
		rp.resetLaws()
	end

	for k, v in ipairs(ents.GetAll()) do
		-- Remove right away or delayed
		if (v.ItemOwner == ply) and not v.RemoveDelay or v.Getrecipient and (v:Getrecipient() == ply) then
			v:Remove()
		elseif (v.RemoveDelayed or v.RemoveDelay) and (v.ItemOwner == ply) then
			removeDelayed(v, ply)
		end

		-- Unown all doors
		if IsValid(v) and v:IsDoor() then
			if v:DoorOwnedBy(ply) then
				v:DoorUnOwn()
				if v:IsVehicle() then
					v:Remove()
				end
			elseif v:DoorCoOwnedBy(ply) then
				v:DoorUnCoOwn(ply)
			end
		end

		-- Remove all props
		if IsValid(v) and ((v:CPPIGetOwner() ~= nil) and not IsValid(v:CPPIGetOwner())) or (v:CPPIGetOwner() == ply) then
			v:Remove()
		end
	end

	rp.inv.Data[ply:SteamID64()] = nil
	GAMEMODE.vote.DestroyVotesWithEnt(ply)

	if rp.teams[ply:Team()].mayor and nw.GetGlobal('lockdown') then
		GAMEMODE:UnLockdown(ply)
	end

	-- Stop the lockdown
	if rp.teams[ply:Team()] and rp.teams[ply:Team()].PlayerDisconnected then
		rp.teams[ply:Team()].PlayerDisconnected(ply)
	end
end

function GM:GetFallDamage(pl, speed)
	local dmg = (speed / 15)
	local ground = pl:GetGroundEntity()

	if ground:IsPlayer() and (not pl:IsBanned()) and pl:GetJobTable().build != false then
		ground:TakeDamage(dmg * 1.3, pl, pl)
	end

	return dmg
end

--[[
	['env_fire'] = true,
	['trigger_hurt'] = true,
	['prop_door_rotating'] = true,
	['light'] = true,
	['spotlight_end'] = true,
	['beam'] = true,
	['env_sprite'] = true,
	['light_spot'] = true,
	['point_template'] = true,
	['func_brush'] = true,
	['func_door_rotating'] = true,
	['prop_dynamic'] = true,
	['prop_physics'] = true,
	['prop_physics_multiplayer'] = true,
	['prop_ragdoll'] = true,
	['ambient_generic'] = true,
	['func_tracktrain'] = true,
	['func_reflective_glass'] = true,
	['info_player_terrorist'] = true,
	['info_player_counterterrorist'] = true,
	['prop_physics_multiplayer'] = true,
	['env_soundscape'] = true,
	['point_spotlight'] = true,
	['ai_network'] = true,
	['lua_run'] = true,
	['logic_timer'] = true,
	['trigger_multiple'] = true
]]

local remove = {
	rp_c18_divrp = {
		['func_brush'] = true,
		['func_door_rotating'] = true,
		['prop_dynamic'] = true,
		['prop_physics'] = true,
		['prop_physics_multiplayer'] = true,
		['prop_ragdoll'] = true,
		['ambient_generic'] = true,
		['func_reflective_glass'] = true,
		['info_player_terrorist'] = true,
		['info_player_counterterrorist'] = true,
		['env_soundscape'] = true,
		['point_spotlight'] = true,
		['ai_network'] = true,
		['lua_run'] = true,
		['logic_timer'] = true,
		['trigger_multiple'] = true
	},
	rp_city17_build210 = {
		['prop_ragdoll'] = true,
		['prop_physics'] = true,
		['prop_physics_multiplayer'] = true,
		['lua_run'] = true,
	},
	rp_industrial17_v1 = {
		['prop_physics'] = true,
	--	['prop_dynamic'] = true,
	},
	rp_city8_urfim = {
		['prop_ragdoll'] = true,
		['prop_physics'] = true,
		['prop_physics_multiplayer'] = true,
	},
}

local exclude_models = {
	rp_city17_build210 = {
		['models/props_c17/playgroundtick-tack-toe_block01a.mdl'] = true,
		['models/props_c17/playground_swingset_seat01a.mdl'] = true,
		['models/props_c17/playground_teetertoter_seat.mdl'] = true,
		['models/props_c17/tv_monitor01.mdl'] = true
	},
	rp_industrial17_v1 = {
		['models/props_combine/combinebutton.mdl'] = true,
	}
}

local freeze = {}




function GM:InitPostEntity()
	local physData = physenv.GetPerformanceSettings()
	physData.MaxVelocity = 1700
	physData.MaxCollisionChecksPerTimestep = 10000
	physData.MaxCollisionsPerObjectPerTimestep = 2
	physData.MaxAngularVelocity = 3636
	physenv.SetPerformanceSettings(physData)
	game.ConsoleCommand("sv_allowcslua 0\n")
	game.ConsoleCommand("physgun_DampingFactor 0.9\n")
	game.ConsoleCommand("sv_sticktoground 0\n")
	game.ConsoleCommand("sv_airaccelerate 100\n")

	remove = remove[game.GetMap()] or {}
	freeze = freeze[game.GetMap()] or {}
	exclude_models = exclude_models[game.GetMap()] or {}

	for _, ent in ipairs(ents.GetAll()) do
		if ent:CreatedByMap() then
			if remove[ent:GetClass()] && !exclude_models[ent:GetModel()] then
				ent:Remove()
			elseif freeze[ent:GetClass()] then

			end
		end
	end

	for k, v in ipairs(ents.FindByClass('info_player_start')) do
		if util.IsInWorld(v:GetPos()) and (not self.SpawnPoint) then
			self.SpawnPoint = v
		else
			v:Remove()
		end
	end


	for k, v in pairs(rp.cfg.Static[game.GetMap()] or {}) do
		local ent = ents.Create('prop_physics')
		ent:SetPos(v.pos)
		ent:SetModel(v.mdl)
		ent:SetAngles(v.ang)
		ent:SetMaterial(v.mat)
		ent:Spawn()
		local p = ent:GetPhysicsObject()
		if IsValid(p) then
			p:EnableMotion(false)
		end
	end
end