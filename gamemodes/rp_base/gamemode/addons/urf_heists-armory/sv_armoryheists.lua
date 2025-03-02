
util.AddNetworkString( "rp.ArmoryHeists.NetworkMsg" );

rp.ArmoryHeists.WriteHeistSync = function( id )
    net.WriteUInt( id, 4 );
    net.WriteBool( rp.ArmoryHeists.List[id].IsInProgress );
    net.WriteFloat( rp.ArmoryHeists.List[id].Timestamp );
	
	if rp.ArmoryHeists.GetHeistCfg( id ).Stealth then
		net.WriteBool(rp.ArmoryHeists.List[id].StealthBreak or false)
	end
end

local function notifyDefenders(id, heist_data, activator)
	if heist_data.Attackers.Territory._onstart then
		local t = heist_data.Attackers.Territory;
		
		for _, ply in pairs( ents.FindInBox(t.mins,t.maxs) ) do
			if not ply:IsPlayer() then continue end

			if heist_data.Attackers.Filter( ply ) then
				heist_data.Attackers.Territory._onstart( ply );
			end
		end
		
		if IsValid(activator) then
			heist_data.Attackers.Territory._onstart( activator );
		end
	end
	
	for _, ply in pairs( player.GetAll() ) do
		if heist_data.Defenders.Filter( ply ) then
			rp.Notify( ply, NOTIFY_ERROR, rp.Term('HeistGoing'), heist_data.Name );
		end
	end
	
    net.Start( "rp.ArmoryHeists.NetworkMsg" );
        rp.ArmoryHeists.WriteHeistSync( id );
    net.Broadcast();
	
	local filter = RecipientFilter(); 
	filter:AddAllPlayers();
			
	rp.ArmoryHeists.List[id].AlarmSound = CreateSound( rp.ArmoryHeists.List[id].InvEntity, heist_data.AlarmSound or "ambient/alarms/alarm1.wav", filter );
	rp.ArmoryHeists.List[id].AlarmSound:SetSoundLevel( 40 );
	rp.ArmoryHeists.List[id].AlarmSound:Play();
end

rp.ArmoryHeists.StartHeist = function( id, caller )
    local HeistData = rp.ArmoryHeists.GetHeistCfg( id );
	
	if not HeistData.Attackers.Filter( caller ) then
		caller:Notify( NOTIFY_ERROR, rp.Term("ArmHeistNotBadGuy") );
		return false
	end
	
    if rp.ArmoryHeists.List[id].IsInProgress then
		caller:Notify( NOTIFY_ERROR, rp.Term("ArmHeistInProgress") );
		return false
	end
	
	if rp.ArmoryHeists.List[id].Timestamp > CurTime() then
		caller:Notify( NOTIFY_ERROR, rp.Term("ArmHeistCooldown") );
		return false
	end
	
    if not HeistData.Attackers.CanStart or HeistData.Attackers.CanStart( rp.ArmoryHeists.List[id], caller ) then
        rp.ArmoryHeists.List[id].IsInProgress = true;
        rp.ArmoryHeists.List[id].Timestamp    = CurTime() + HeistData.Duration;

        net.Start( "rp.ArmoryHeists.NetworkMsg" );
            rp.ArmoryHeists.WriteHeistSync( id );
        net.Broadcast();

        if not HeistData.Stealth then
            notifyDefenders(id, HeistData)
        end

        local inv = rp.ArmoryHeists.List[id].InvItem:getInv();

        for k, v in pairs( inv:getItems() ) do
            v:remove();
        end
	end
end


rp.ArmoryHeists.EndHeist = function( id )
    local HeistData = rp.ArmoryHeists.GetHeistCfg( id );
    
    rp.ArmoryHeists.List[id].IsInProgress = false;
	
    local DefenderCount = table.Count(rp.ArmoryHeists.List[id].Defenders);
    
	local cooldown = HeistData.Cooldown;
	cooldown = cooldown * (DefenderCount == 0 and 3 or DefenderCount < 2 and 2 or 1)
	
    if HeistData.Hooks then
        if HeistData.Hooks.OnEnd then
            HeistData.Hooks.OnEnd( rp.ArmoryHeists.List[id] );
        end
    end

    rp.ArmoryHeists.List[id].Timestamp    		= CurTime() + cooldown;
    rp.ArmoryHeists.List[id].Defenders    		= {};
	
    rp.ArmoryHeists.List[id].LastAttackersCount	= nil;
    rp.ArmoryHeists.List[id].LastAttackers		= nil;
    rp.ArmoryHeists.List[id].StealthBreak		= nil;

    net.Start( "rp.ArmoryHeists.NetworkMsg" );
        rp.ArmoryHeists.WriteHeistSync( id );
    net.Broadcast();

	if rp.ArmoryHeists.List[id].AlarmSound then
		rp.ArmoryHeists.List[id].AlarmSound:Stop();
	end
end


rp.ArmoryHeists.ProcessDefendersReward = function( id )
    local HeistData = rp.ArmoryHeists.GetHeistCfg( id );

    for ply, _ in pairs( rp.ArmoryHeists.List[id].Defenders ) do
        if not IsValid( ply ) then continue end

		if isnumber(HeistData.Defenders.Reward) then
			ply:Notify( NOTIFY_GREEN, rp.Term("ArmHeistPoliceHelp"), rp.FormatMoney(HeistData.Defenders.Reward) );
			ply:AddMoney( HeistData.Defenders.Reward );
		else
			HeistData.Defenders.Reward( ply );
		end
    end
end


rp.ArmoryHeists.ProcessAttackersReward = function( id )
    local HeistData = rp.ArmoryHeists.GetHeistCfg( id );
    
    local OutLoot       = {};
    local DefenderCount = 0;
    
    for k, ply in pairs( player.GetAll() ) do
        if HeistData.Defenders.Filter( ply ) then
            DefenderCount = DefenderCount + 1;
        end
    end
    
    for wep_class, data in pairs( HeistData.LootTable.Content ) do
        local rate = (data.DropRate + data.RatePerDefender * DefenderCount) / 100;
        
        for i = 1, (data.Amount or 1) do
            if math.random() <= rate then
                OutLoot[wep_class] = (OutLoot[wep_class] or 0) + 1;
            end
        end
    end
    
	rp.ArmoryHeists.List[id].InvItem.StillLoading = true
    local inv = rp.ArmoryHeists.List[id].InvItem:getInv();

	local weps_to_spawn = {}
	
    for wep, amount in pairs( OutLoot ) do
		table.insert(weps_to_spawn, {wep, amount})
	end
	
	local function callback(i)
		if weps_to_spawn[i] then
			inv:add( weps_to_spawn[i][1], weps_to_spawn[i][2], nil, nil, nil, nil, nil, function()
				callback(i + 1)
			end );
		else
			rp.ArmoryHeists.List[id].InvItem.StillLoading = nil
		end
	end
	callback(1)
	
	--local i = 0
    --for wep, amount in pairs( OutLoot ) do
        --timer.Simple( i * 0.1, function()
            --inv:add( wep, amount );
			--i = i + 1;
        --end );
    --end
end


hook.Add( "Tick", "rp.ArmoryHeists.Logic", function()
    for id, Heist in pairs( rp.ArmoryHeists.List ) do
        if Heist.IsInProgress then
            local HeistData = rp.ArmoryHeists.GetHeistCfg( id );
            
            local AttackerTerritory = HeistData.Attackers.Territory;
            local DefenderTerritory = HeistData.Defenders.Territory;

            for _, ply in pairs( ents.FindInBox(DefenderTerritory.mins,DefenderTerritory.maxs) ) do
                if not ply:IsPlayer() then continue end

                if not Heist.Defenders[ply] and HeistData.Defenders.Filter( ply ) then
                    Heist.Defenders[ply] = true;
					
					local enter_reward = isnumber(HeistData.Defenders.Reward) and math.floor(HeistData.Defenders.Reward / 10) or HeistData.Defenders.EnterReward
					
					if enter_reward then
						ply:AddMoney( enter_reward );
						ply:Notify( NOTIFY_GREEN, rp.Term("ArmHeistPoliceEntered"), rp.FormatMoney(enter_reward) );
					end
					
					if HeistData.Stealth and not Heist.StealthBreak then
						--print('Stealth revealed 1')
						
						Heist.StealthBreak = true
						notifyDefenders(id, HeistData)
					end
                end
            end

            if not timer.Exists( "timer.ArmoryHeists" .. id .. "ZeroAttackers" ) then
                local AttackerCount = 0;
				local CurAttackers = {}

                for _, ply in pairs( ents.FindInBox(AttackerTerritory.mins,AttackerTerritory.maxs) ) do
                    if not ply:IsPlayer() then continue end

                    if HeistData.Attackers.Filter( ply ) then
                        AttackerCount = AttackerCount + 1;
						CurAttackers[ply:SteamID()] = ply
                    end
					
					if HeistData.Stealth and not Heist.StealthBreak and HeistData.Defenders.Filter( ply ) then
						--print('Stealth revealed 2')
						
						Heist.StealthBreak = true;
						notifyDefenders(id, HeistData);
					end
                end
				
				
				if HeistData.Stealth and not Heist.StealthBreak and Heist.LastAttackersCount and Heist.LastAttackersCount > AttackerCount then
					local attacker
					
					if Heist.LastAttackers then
						for k, v in pairs(Heist.LastAttackers) do
							if not CurAttackers[k] then
								attacker = v
								break
							end
						end
					end
					
					--print('Stealth revealed 3', attacker)
					
					Heist.StealthBreak = true;
					notifyDefenders(id, HeistData, attacker);
				end
				
				Heist.LastAttackers = CurAttackers;
				Heist.LastAttackersCount = AttackerCount;

                if AttackerCount == 0 then
                    timer.Create( "timer.ArmoryHeists" .. id .. "ZeroAttackers", HeistData.IdleDuration, 1, function()
                        rp.ArmoryHeists.ProcessDefendersReward( id );
                        rp.ArmoryHeists.EndHeist( id );
                    end );
                end

                if Heist.Timestamp <= CurTime() then
                    rp.ArmoryHeists.ProcessAttackersReward( id );
                    rp.ArmoryHeists.EndHeist( id );
                end
            else
                for _, ply in pairs( ents.FindInBox(AttackerTerritory.mins,AttackerTerritory.maxs) ) do
                    if not ply:IsPlayer() then continue end

                    if HeistData.Attackers.Filter( ply ) then
                        timer.Remove( "timer.ArmoryHeists" .. id .. "ZeroAttackers" );
                        break
                    end
                end
            end
        end
    end
end );

local spawnEnts = function()
    for id, HeistData in pairs( rp.cfg.ArmoryHeists and rp.cfg.ArmoryHeists.List[game.GetMap()] or {} ) do
        local LootTable = HeistData.LootTable;

		--PrintTable(LootTable)
		--print(LootTable.Position)
		
        rp.item.spawn( "box_heist", LootTable.Position, function( item, ent ) 
			
            ent:SetAngles( LootTable.Angles );
            ent:SetModel( LootTable.Model or "models/Items/ammocrate_smg1.mdl" );

            ent:PhysicsInit( SOLID_VPHYSICS );
            --ent:SetMoveType( MOVETYPE_VPHYSICS );
			ent:SetMoveType(MOVETYPE_NONE)
			ent:SetCollisionGroup(COLLISION_GROUP_NONE)

            local PhysObj = ent:GetPhysicsObject();
            if IsValid( PhysObj ) then
				PhysObj:Sleep()
                PhysObj:EnableMotion( false );
            end

            ent:SetNWInt( "HeistID", id );
            rp.ArmoryHeists.List[id].InvEntity = ent;
            rp.ArmoryHeists.List[id].InvItem   = item;
        end );
    end
end

hook.Add( "InitPostEntity", "rp.ArmoryHeists.InitializeLootEntities", spawnEnts );
--spawnEnts()

hook.Add( "EntityFireBullets", "rp.ArmoryHeists.StealthReveal", function( ent )
	if IsValid(ent) and ent:IsPlayer() then
		for id, Heist in pairs( rp.ArmoryHeists.List ) do
			if Heist.IsInProgress and not Heist.StealthBreak then
				local HeistData = rp.ArmoryHeists.GetHeistCfg( id );
				
				if HeistData.Stealth and HeistData.Attackers.Filter( ent ) then
					local AttackerTerritory = HeistData.Attackers.Territory;
					
					if ent:GetPos():WithinAABox( AttackerTerritory.mins - Vector(0, 0, 50), AttackerTerritory.maxs ) then
						Heist.StealthBreak = true;
						notifyDefenders( id, HeistData );
					end
				end
			end
		end
	end
end)

net.Receive( "rp.ArmoryHeists.NetworkMsg", function( len, ply )
    if not ply.__ArmoryHeistsInitialized then
        for id in pairs( rp.ArmoryHeists.List ) do
            net.Start( "rp.ArmoryHeists.NetworkMsg" );
                rp.ArmoryHeists.WriteHeistSync( id );
            net.Send( ply );
        end
        
        ply.__ArmoryHeistsInitialized = true;
    end
end );