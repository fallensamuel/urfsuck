rp.Heists.HeistEndTime = rp.Heists.HeistEndTime or 0;
rp.Heists.BagIssues    = rp.Heists.BagIssues or {};

util.AddNetworkString( "rp.Heists.NetworkMsg" );


net.Receive( "rp.Heists.NetworkMsg", function( len, ply )
    if ply.HeistsSynced then return end

    ply.HeistsSynced = true;

    net.Start( "rp.Heists.NetworkMsg" );
        net.WriteBool( rp.Heists.IsHeistRunning );
    net.Send( ply );
end );


rp.Heists.CanStartHeist = function( caller )
    if not IsValid( caller ) then return false end

    if rp.Heists.IsHeistRunning then
        caller:Notify( NOTIFY_ERROR, rp.Term("HeistAlreadyRunning") );
        return false
    end

    return true        
end


rp.Heists.StartHeist = function( caller )
    if not rp.Heists.CanStartHeist( caller ) then return end

    rp.Heists.IsHeistRunning = true;
    rp.Heists.HeistEndTime   = CurTime() + rp.cfg.Heists.HeistTimeLength;

    timer.Create( "rp.Heists.BagIssues", 0.5, 0, function()
        local money = 0;

	for k, v in pairs( ents.FindByClass("ent_heists_moneypallet") ) do
            money = money + v:GetMoney();
        end

        if money == 0 then return end

        local zone = rp.cfg.Heists.BagIssuesZone[game.GetMap()];
        for k, ply in pairs( ents.FindInBox(zone[1], zone[2]) ) do
            if not ply:IsPlayer() then continue end

            local f = ply:GetFaction();

            if rp.cfg.Heists.IsBadGuy(f) then
                if not rp.Heists.BagIssues[ply] then
                    rp.Heists.BagIssues[ply] = 2;
                end

                if not ply:GetNWBool( "HasLootbag" ) and rp.Heists.BagIssues[ply] > 0 then
                    rp.Heists.BagIssues[ply] = rp.Heists.BagIssues[ply] - 1;

                    ply:Give( "weapon_heists_lootbag_default" );
                    ply:SelectWeapon( "weapon_heists_lootbag_default" );
                end
            end
        end
    end );

    net.Start( "rp.Heists.NetworkMsg" );
        net.WriteBool( rp.Heists.IsHeistRunning );
    net.Broadcast();

    caller:Wanted( NULL, translates and translates.Get("Ограбление банка") or "Ограбление банка", 120 );

    for k, v in pairs( player.GetAll() ) do
        local f = v:GetFaction();

        if rp.cfg.Heists.IsGoodGuy(f) then
            v:Notify( NOTIFY_ERROR, rp.Term("HeistWarning") );
        end
    end

    local filter = RecipientFilter(); filter:AddAllPlayers();
    //rp.Heists.AlarmSound = CreateSound( ents.GetMapCreatedEntity(rp.cfg.Heists.SirenMapEnt[game.GetMap()]), "ambient/alarms/alarm1.wav", filter );
    rp.Heists.AlarmSound = CreateSound(ents.FindByClass('ent_heists_moneypallet')[1], "ambient/alarms/alarm1.wav", filter );
    rp.Heists.AlarmSound:SetSoundLevel( 90 );
    rp.Heists.AlarmSound:Play();
end


hook.Add( "Tick", "rp.Heists.Logic", function()
    if rp.Heists.IsHeistRunning then
        local money = 0;

        for k, v in pairs( ents.FindByClass("ent_heists_moneypallet") ) do
            money = money + v:GetMoney();
        end

        local lootbags = 0;

        for k, v in pairs( ents.FindByClass("weapon_heists_lootbag_*") ) do
            lootbags = lootbags + 1;
        end

        for k, v in pairs( ents.FindByClass("spawned_weapon") ) do
            if string.StartWith( v.weaponclass or "", "weapon_heists_lootbag" ) then
                if v.ValueAmount < 0 then
                    lootbags = lootbags + 1;
                end
            end
        end

        if (money == 0 and lootbags == 0) or rp.Heists.HeistEndTime <= CurTime() then
            rp.Heists.EndHeist();
        end
    end
end );


rp.Heists.EndHeist = function()
    if rp.Heists.IsHeistRunning then
        rp.Heists.IsHeistRunning = false;

        for k, v in pairs( ents.FindByClass("weapon_heists_lootbag_*") ) do
            v.Owner:SetNWBool( "HasLootbag", false );
            v:Remove();
        end

        for k, v in pairs( ents.FindByClass("spawned_weapon") ) do
            if string.StartWith( v.weaponclass or "", "weapon_heists_lootbag" ) then
                v:Remove()
            end
        end

        timer.Stop( "rp.Heists.BagIssues" );
        rp.Heists.BagIssues = {};

        net.Start( "rp.Heists.NetworkMsg" );
            net.WriteBool( rp.Heists.IsHeistRunning );
        net.Broadcast();

        rp.Heists.AlarmSound:Stop();
    end
end


hook.Add( "InitPostEntity", "rp.Heists.LoadEntities", function()
    for class, data in pairs( rp.cfg.Heists and rp.cfg.Heists.EntSpawns and rp.cfg.Heists.EntSpawns[game.GetMap()] or {} ) do
        for k, v in pairs( ents.FindByClass(class) ) do
            v:Remove();
        end

        for _, loc in pairs( data ) do
            local ent = ents.Create( class );
            ent:SetPos( loc.Pos );
            ent:SetAngles( loc.Ang );
            ent:Spawn();

            local phys = ent:GetPhysicsObject();
            if IsValid( phys ) then
                phys:EnableMotion( false );
            end
        end
    end
end );
