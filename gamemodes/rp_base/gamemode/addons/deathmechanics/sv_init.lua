local DeathMechanics = {};

-----------------------------------

util.AddNetworkString('DeathMechanics');
util.AddNetworkString('DeathMechanics.Broadcast');

-----------------------------------

local Ceil = math.ceil;
local Clamp = math.Clamp;
local RepsLeft = timer.RepsLeft;
local Random = math.random;

-----------------------------------

DeathMechanics.MonsterSounds = {
    'npc/zombie/claw_strike1.wav',
    'npc/zombie/claw_strike2.wav',
    'npc/zombie/claw_strike3.wav'
};

DeathMechanics.MonsterFinished = {
    'npc/barnacle/barnacle_gulp1.wav',
    'npc/barnacle/barnacle_gulp2.wav'
};

-----------------------------------

local Sort = {
    [1] = {
        Check = function(Player) return Player:GetJobTable() and Player:GetJobTable().CanSelfRevive or Player:GetFactionTable() and Player:GetFactionTable().CanSelfRevive or hook.Call('ShouldDMRevive', nil, Player) or false; end,
        Action = function(Player) DeathMechanics.StartRevive(Player); end
    },
    [2] = {
        Check = function(Player) return Player.DeathAction end,
        Action = function(Player) DeathMechanics.StartDoubleDeath(Player); end
    },
    [3] = {
        Check = function(Player) return Player:Alive() and not (Player.DeathAction or IsValid(Player.HealPlayer) or timer.Exists('Death.' .. Player:SteamID64() .. '.Heal')) end,
        Action = function(Player) DeathMechanics.StartHeal(Player); end
    },
    [4] = {
        Check = function(Player) return timer.Exists('Death.' .. Player:SteamID64() .. '.Revive') end,
        Action = function(Player) DeathMechanics.DropRevive(Player); end
    },
    [5] = {
        Check = function(Player) return timer.Exists('Death.' .. Player:SteamID64() .. '.x2') end,
        Action = function(Player) DeathMechanics.DropDoubleDeath(Player); end
    },
    [6] = {
        Check = function(Player) return timer.Exists('Death.' .. Player:SteamID64() .. '.Heal') end,
        Action = function(Player) DeathMechanics.DropHeal(Player); end
    }
};

-----------------------------------

function DeathMechanics.Network(Length, Player)
    if (!IsValid(Player)) then return end
    local Action = net.ReadUInt(3);
    if (!Sort[Action] or !Sort[Action].Check(Player)) then return end
    Sort[Action].Action(Player);
end

-----------------------------------

function DeathMechanics.Answer(Player, Main, Time, Additional)
	net.Start('DeathMechanics');
        net.WriteUInt(Main, 3);
        net.WriteUInt(Time, 8);
        net.WriteUInt(Additional or 0, 8);
    net.Send(Player);
end

-----------------------------------

function DeathMechanics.Broadcast(Player, Operation)
    net.Start('DeathMechanics.Broadcast');
        net.WriteBool(Operation);
        net.WriteEntity(Player);
    net.Broadcast();
end

-----------------------------------

function DeathMechanics.UnpauseThread(Player)
    local Name = 'Death.' .. Player:SteamID64();
    if (timer.Exists(Name) and timer.TimeLeft(Name) < 0) then
        timer.UnPause(Name);
    end
    local Time = timer.TimeLeft(Name) or 0;
    DeathMechanics.Answer(Player, 1, Ceil(Time), (rp.cfg.dm_DeathTimer or 20));
end

-----------------------------------

function DeathMechanics.StartDeath(Player, Killer)
	local wep = Player:GetWeapon("weapon_handcuffed")
    wep = IsValid(wep) and wep or Player:GetWeapon('weapon_hands')
	
	if not IsValid(wep) then return end
	
    hook.Run("DeathMechanics.StartDeath", Player, Killer)

    Player:GodEnable();
    Player:SetHealth(rp.cfg.dm_DeathHP or 50);
    Player:SetArmor(0);
	
    local act_w = Player:GetActiveWeapon()
    Player:SetActiveWeapon(wep);
    timer.Simple(2, function()
        Player:GodDisable();
        --Player:ForceStartEmoteAction('dm_fall');
    end);
	Player:ForceStartEmoteAction('dm_fall');
	
    Player.DeathAction = true;
    Player.ReviveStatus = false;
	
    DeathMechanics.Broadcast(Player, true);

    local Name = 'Death.' .. Player:SteamID64();
    timer.Remove(Name);
    Player:SetNetVar("deathmech_t", CurTime() + (rp.cfg.dm_DeathTimer or 20))
    --timer.Create(Name, rp.cfg.dm_DeathTimer or 20, 1, function()
    --    if (IsValid(Player)) then DeathMechanics.EndDeath(Player); end
    --end);
    timer.Create(Name .. '.AutoPause', 1, rp.cfg.dm_DeathTimer or 20, function()
        --if (IsValid(Player) and Player:IsArrested()) then
        --    DeathMechanics.EndDeath(Player, false);
        --    return
        --end
		
		if not IsValid(Player) then return end
		
		--if not Player.DeathAction then
		--	DeathMechanics.EndDeath(Player)
		--	return
		--end
		
        if timer.Exists(Name .. '.Revive') or timer.Exists(Name .. '.x2') or Player.ReviveStatus then
            local Time = timer.TimeLeft(Name) or 0;
            if (Time > 0 and Time <= ((rp.cfg.dm_ReviveTimer or 10) * .5)) then
                timer.Pause(Name);
            end
        end
    end);

    DeathMechanics.Answer(Player, 1, rp.cfg.dm_DeathTimer or 20);
	
	if IsValid(Killer) then
		Player.DeathKiller = Killer;
		Player.DeathKillerWeapon = Killer:IsPlayer() and Killer:GetActiveWeapon() or Killer;
	end

    if IsValid(act_w) and act_w.Think then act_w:Think() end
	
	return true
    --Player:SetNetVar("InDeathMechanics", true)
end

-----------------------------------

function DeathMechanics.StartRevive(Player)
    local Name = 'Death.' .. Player:SteamID64();

    timer.Remove(Name .. '.Revive');
    timer.Create(Name .. '.Revive', rp.cfg.dm_ReviveTimer or 7, 1, function()
        if (IsValid(Player)) then DeathMechanics.EndRevive(Player); end
    end);

    DeathMechanics.Answer(Player, 2, rp.cfg.dm_ReviveTimer or 10, rp.cfg.dm_DeathTimer or 20);
end

-----------------------------------

function DeathMechanics.StartHeal(Player)
	if Player.SupervisorID then return end
	
    local Trace = Player:GetEyeTrace();
    local Ents = ents.FindInSphere(Trace.HitPos, rp.cfg.dm_ReviveDistance or 60);
    local HasPlayer = false;
    for Index, Ent in pairs(Ents) do
        if (IsValid(Ent) and Ent:IsPlayer() and !Ent.ReviveStatus and Ent.DeathAction and Ent:Alive()) then
            if (Player:GetPos():Distance(Ent:GetPos()) <= (rp.cfg.dm_ReviveDistance or 60)) then
                HasPlayer = Ent;
            end
        end
    end

    if (!HasPlayer) then return end
    Player.HealPlayer = HasPlayer;
	
    local heal_time = hook.Run("DeathMechanics.StartHealGetTime", Player, Player.HealPlayer) or (rp.cfg.dm_ReviveTimer or 10)

    DeathMechanics.Answer(Player, 4, heal_time);
    Player:ForceStartEmoteAction('dm_heal');

    HasPlayer.ReviveStatus = true;

    local Name1, Name2 = 'Death.' .. Player:SteamID64(), 'Death.' .. HasPlayer:SteamID64();

    timer.Remove(Name1 .. '.Heal');
    timer.Create(Name1 .. '.Heal', heal_time, 1, function()
        if (IsValid(Player)) then
            local jtab = Player:GetJobTable()
            if (jtab.monster) and Player.HealPlayer:GetFaction() ~= Player:GetFaction() then
                Player:SetHealth(Clamp(Player:Health() + (jtab.eatHp or 25), 0, Player:GetMaxHealth()));
                Player:EmitSound(DeathMechanics.MonsterFinished[Random(1, #DeathMechanics.MonsterFinished)]);

                if jtab.MonsterEatTeam and (Player:GetNetVar("NextMonsterEat", 0) or 0) < CurTime() then
                    DeathMechanics.EndHeal(Player);
                    Player:SetNetVar("NextMonsterEat", CurTime() + (jtab.MonsterEatCooldown or 5*60))
                    timer.Simple(0, function()
                        local newteam
                        if istable(jtab.MonsterEatTeam) then
                            newteam = table.Random(jtab.MonsterEatTeam)
                        elseif isfunction(jtab.MonsterEatTeam) then
                            newteam = jtab.MonsterEatTeam(Player, HasPlayer)
                        else
                            newteam = jtab.MonsterEatTeam
                        end

                        if newteam then
                            HasPlayer:SetTeamSilent(newteam, true, true)
                        end
                    end)
                else
                    DeathMechanics.EndDeath(Player.HealPlayer);
                end
            else
                DeathMechanics.EndHeal(Player);
            end
        end
    end);
    timer.Remove(Name1 .. '.HealAutoDrop');
    timer.Create(Name1 .. '.HealAutoDrop', 1, heal_time, function()
        if (!IsValid(Player.HealPlayer) or !Player.HealPlayer:Alive() or timer.Exists(Name2 .. '.x2') or timer.Exists(Name2 .. '.Revive')) then 
            DeathMechanics.DropHeal(Player); 
        elseif (Player:GetJobTable().monster) and Player.HealPlayer:GetFaction() ~= Player:GetFaction() then
            if ((RepsLeft(Name1 .. '.HealAutoDrop') or 1) % 2 == 0) then
                Player:SetHealth(Clamp(Player:Health() + (Player:GetJobTable().eatHp or 25), 0, Player:GetMaxHealth()));
                Player:EmitSound(DeathMechanics.MonsterSounds[Random(1, #DeathMechanics.MonsterSounds)]);
            end
        end
    end);
end

-----------------------------------



function DeathMechanics.StartDoubleDeath(Player)
--[[
    local Name = 'Death.' .. Player:SteamID64();
    local Time = timer.TimeLeft(Name);

    if (Time <= 2) then return end

    timer.Remove(Name .. '.x2');
    timer.Create(Name .. '.x2', Time / (rp.cfg.dm_DeathMultiply or 2), 1, function()
        if (IsValid(Player)) then DeathMechanics.EndDeath(Player); end
    end);
    
    DeathMechanics.Answer(Player, 3, math.ceil(Time / (rp.cfg.dm_DeathMultiply or 2)), 10);
]]--
end

-----------------------------------

function DeathMechanics.EndDeath(Player, Kill)
    if (Kill == nil) then Kill = true; end

    local Name = 'Death.' .. Player:SteamID64();
    timer.Remove(Name);
    timer.Remove(Name .. '.Revive');
    timer.Remove(Name .. '.x2');

    Player:SetNetVar("deathmech_t", nil)

	Player:DropEmoteAction();
	
    Player.DeathAction = nil;
    Player.ReviveStatus = nil;
    Player.DeathTimer = nil;

    DeathMechanics.Answer(Player, 0, 0);
    DeathMechanics.Broadcast(Player, false);
	
    if (Kill) then 
		local killer = Player.DeathKiller
		Player.DeathKiller = nil
		
		if IsValid(killer) and killer:IsPlayer() then
			--print(Player, 'killed by', killer)
			
			Player.DeathInstantDamage = true
			Player:TakeDamage(Player:Health() * 5, killer, IsValid(Player.DeathKillerWeapon) and Player.DeathKillerWeapon)
			Player.DeathKillerWeapon = nil
		elseif Player:Alive() then
			--print('Kill player')
			Player:Kill(); 
		end
	end
	
    --Player:SetNetVar("InDeathMechanics", false)
end

-----------------------------------

function DeathMechanics.EndRevive(Player)
    Player:SetHealth(Player:GetMaxHealth() * .5);
    Player:ForceStartEmoteAction('dm_getup');
    timer.Simple(1.15, function() Player:DropEmoteAction(); end);
    DeathMechanics.EndDeath(Player, false);
end

concommand.Add("~dev_tests", function(ply)
    if ply:IsRoot() then
        DeathMechanics.EndRevive(ply)
    end
end)
-----------------------------------

function DeathMechanics.EndHeal(Player)
    local Name = 'Death.' .. Player:SteamID64() .. '.Heal';
    timer.Remove(Name);
    Player:DropEmoteAction();
    DeathMechanics.Answer(Player, 0, 0);

    if (!IsValid(Player.HealPlayer)) then return end
    Name = 'Death.' .. Player.HealPlayer:SteamID64() .. '.Heal';
    DeathMechanics.EndRevive(Player.HealPlayer);
    hook.Run("DeathMechanics.OnEndHeal", Player, Player.HealPlayer)
	Player.HealPlayer = nil
end

-----------------------------------

function DeathMechanics.DropRevive(Player)
    local Name = 'Death.' .. Player:SteamID64();
    timer.Remove(Name .. '.Revive');
    DeathMechanics.UnpauseThread(Player);
end

-----------------------------------

function DeathMechanics.DropDoubleDeath(Player)
    local Name = 'Death.' .. Player:SteamID64();
    timer.Remove(Name .. '.x2');
    DeathMechanics.UnpauseThread(Player);
end

-----------------------------------

function DeathMechanics.DropHeal(Player)
    local Name = 'Death.' .. Player:SteamID64() .. '.Heal';
    timer.Remove(Name);
    Player:DropEmoteAction();
    
    if (!IsValid(Player.HealPlayer)) then return end
    Name = 'Death.' .. Player.HealPlayer:SteamID64();
    DeathMechanics.UnpauseThread(Player.HealPlayer);
    Player.HealPlayer.ReviveStatus = false;
    DeathMechanics.Answer(Player, 0, 0);
	Player.HealPlayer = nil
end

-----------------------------------

hook.Add('PlayerDeath', 'DeathMechanics.PlayerDeath', function(Player)
    if (IsValid(Player) and Player.DeathAction) then
        DeathMechanics.EndDeath(Player);
		
	elseif IsValid(Player.HealPlayer) or timer.Exists('Death.' .. Player:SteamID64() .. '.Heal') then
		timer.Simple(0.1, function()
			Player:DropEmoteAction();
		end)
    end
end);

hook.Add('EntityTakeDamage', 'DeathMechanics.EntityTakeDamage', function(Player, Damage)
    if IsValid(Player) and Player:IsPlayer() and Player:Alive() then
		if not Player.DeathInstantDamage then 
			local Health = math.floor(Player:Health() + (Damage:IsFallDamage() and 0 or Player:Armor()) - Damage:GetDamage());
			
			--print(Damage:GetDamage(), Player:Health(), Player:Armor())
			
			if Health <= 0 and not Player:GetJobTable().CantDeathmechanics and not Player:HasGodMode() and not (Player.InSafeZone and Player:InSafeZone()) then 
				if (Player.DeathAction or !Player:IsFlagSet(FL_ONGROUND) or Player:IsFlagSet(FL_FLY) or Player:InVehicle()) then 
					--print('Death End')
					DeathMechanics.EndDeath(Player); 
				elseif not Player.DeathAction then
					--print('Death Start')
					return DeathMechanics.StartDeath(Player, Damage:GetAttacker());
				end
			end
		else
			Player.DeathInstantDamage = nil
		end
	end
end);

-----------------------------------

hook.Add('SetupMove', 'DeathMechanics.SetupMove', function(Player, MoveData, UserData)
    if (IsValid(Player) and Player:IsPlayer() and Player.DeathAction) then
        MoveData:SetOrigin(Player:GetPos());
        MoveData:SetVelocity(Vector(0, 0, 0));
        return true
    end
end);

-----------------------------------

net.Receive('DeathMechanics', DeathMechanics.Network);

hook.Add('PlayerArrested', 'DeathMechanics.PlayerArrested', function(Player)
    if (IsValid(Player) and Player.DeathAction) then
        Player:DropEmoteAction();
        DeathMechanics.EndDeath(Player, false);
    end
end);

local function reset_death_mechanics(ply)
	ply:DropEmoteAction()

    timer.Simple(0, function()
        if IsValid(ply) and ply.InDeathMechanics and ply:InDeathMechanics() then
            DeathMechanics.EndDeath(ply, false)
        end
    end)
end

hook.Add("PlayerSpawn", "DeathMechanics.ResetAnim", reset_death_mechanics)
hook.Add("OnPlayerChangedTeam", "DeathMechanics.TeamChange", reset_death_mechanics)

local DoubeDeathCD = {}

hook.Add("KeyRelease", "DeathMechanics.KeyRelease", function(ply, key)
    if key == IN_ATTACK then 
		if Sort[4].Check(ply) then
			Sort[4].Action(ply)
		end
		
    elseif key == IN_USE then 
		if Sort[6].Check(ply) then
			Sort[6].Action(ply)
		end
    end
end)

hook.Add("PlayerPostThink", "DeathMechanics.PlayerThink", function(ply)
    if not ply:IsInDeathMechanics() then 
		if ply:KeyDown(IN_USE) and Sort[3].Check(ply) then
			Sort[3].Action(ply)
		end
		
		return 
	end

    local nw = ply:GetNetVar("deathmech_t")
    if nw and CurTime() >= nw then
		if not ply.ReviveStatus then
			DeathMechanics.EndDeath(ply)
		end
    end
	
    if ply:IsHandcuffed() then return end
	
	if ply:KeyDown(IN_ATTACK2) then
		if DoubeDeathCD[ply] then return end
		DoubeDeathCD[ply] = true
		timer.Simple(0.25, function()
			DoubeDeathCD[ply] = nil
		end)

		ply:SetNetVar("deathmech_t", (ply:GetNetVar("deathmech_t") or 0) - 0.25)
	
	elseif ply:KeyDown(IN_ATTACK) then
		if Sort[1].Check(ply) and not timer.Exists('Death.' .. Player:SteamID64() .. '.Revive') then
			Sort[1].Action(ply)
		end
	end
end)