/* ---- Core: ------------------------------- */
hook.Add( "PostGamemodeLoaded", "supervisors", function()
    rp.Supervisor = rp.Supervisor or {};

    for SupervisorID, SupervisorData in pairs( rp.cfg.Supervisors.List ) do
        rp.Supervisor[SupervisorID] = rp.Supervisor[SupervisorID] or {};
        local this = rp.Supervisor[SupervisorID];

        this.Master     = this.Master or NULL;
        this.Slave      = this.Slave or NULL;
        this.Cooldowns  = {};
        this.Filter     = SupervisorData.Filter;
        this.EnteredPos = this.EnteredPos or Vector(0,0,0);
        this.Weapons    = this.Weapons or {};
    end

    hook.Remove( "PostGamemodeLoaded", "supervisors" );
end );

/* ---- Networking: ------------------------- */
util.AddNetworkString( "rp.job.supervisor" );

net.Receive( "rp.job.supervisor", function( len, ply )
    if not rp.cfg.Supervisors.CanUse[ply:Team()] then return end
    if not ply.SupervisorID        then return end
    
    local SupervisorData = rp.Supervisor[ply.SupervisorID];
    if SupervisorData.Master ~= ply then return end

    local cmd = net.ReadUInt(2);
    if cmd == SUPERVISOR_CMD_SPECTATE then
        local target = net.ReadEntity();

        if SupervisorData.Filter(target) then
            SupervisorData.Slave = target;
            ply:SpectateEntity( target );

            net.Start( "rp.job.supervisor" );
                net.WriteUInt( SUPERVISOR_CMD_SPECTATE, 2 );
                net.WriteEntity( SupervisorData.Slave );
            net.Send( ply );
        end
    elseif cmd == SUPERVISOR_CMD_ACTION then
        local action_id = net.ReadUInt(6);

        if not rp.cfg.Supervisors.List[ply.SupervisorID].Actions[action_id] then return end
        if (SupervisorData.Cooldowns[action_id] or 0) > CurTime()           then return end

        local ActionData = rp.cfg.Supervisors.Actions[action_id];
        ActionData.Execute( SupervisorData.Master, SupervisorData.Slave );

        if ActionData.Cooldown then
            SupervisorData.Cooldowns[action_id] = CurTime() + ActionData.Cooldown;

            net.Start( "rp.job.supervisor" );
                net.WriteUInt( SUPERVISOR_CMD_ACTION, 2 );
                net.WriteUInt( action_id, 6 );
                net.WriteFloat( SupervisorData.Cooldowns[action_id] );
            net.Send( ply );
        end
    end 
end );


/* ---- Functions: -------------------------- */
rp.EnterSupervisorMode = function( id, ply )
    if not IsValid(ply)            then return false end
    if not ply:IsPlayer()          then return false end
    if not rp.cfg.Supervisors.CanUse[ply:Team()] then return false end
    if ply.SupervisorID            then return false end

    if not rp.Supervisor[id] then return false end

    local SupervisorData = rp.Supervisor[id];
    if IsValid(SupervisorData.Master) then return false end

    SupervisorData.Master     = ply;
    SupervisorData.Slave      = NULL;
    SupervisorData.EnteredPos = ply:GetPos();

    net.Start( "rp.job.supervisor" );
        net.WriteUInt( SUPERVISOR_CMD_ENABLE, 2 );
        net.WriteUInt( id, 3 );
    net.Send( ply );

    local jobName = team.GetName(ply:Team()) .. " (" .. rp.cfg.Supervisors.List[id].Name .. ")";
    ply:SetNetVar( "job", jobName );
    rp.NotifyAll( NOTIFY_GENERIC, rp.Term("ChangeJob"), ply, jobName );

    for k, wep in pairs( ply:GetWeapons() ) do
        SupervisorData.Weapons[wep:GetClass()] = {
            ammo_p = wep:GetPrimaryAmmoType() or 0,
            ammo_s = wep:GetSecondaryAmmoType() or 0,
            ammo1 = ply:GetAmmoCount(wep:GetPrimaryAmmoType() or 0),
            ammo2 = ply:GetAmmoCount(wep:GetSecondaryAmmoType() or 0)
        };
    end
    ply:StripWeapons();
    ply:SetNoDraw( true );
    ply:Spectate( OBS_MODE_CHASE );

    ply.SupervisorID = id;
    nw.SetGlobal( "nw.rp.SupervisorStatus", {id,true} );

    return true
end

rp.ExitSupervisorMode = function( id )
    if not rp.Supervisor[id] then return false end

    local SupervisorData = rp.Supervisor[id];
    if not IsValid(SupervisorData.Master) then return false end
    local ply = SupervisorData.Master;

    SupervisorData.Master   = NULL;
    SupervisorData.Slave    = NULL;

    ply:UnSpectate();

    if ply:Alive() then
        ply:Spawn();

        ply:Teleport( SupervisorData.EnteredPos );

        for wep, v in pairs( SupervisorData.Weapons ) do
            if !ply:HasWeapon(wep) then
                ply:Give( wep );
            end
        end

        ply:StripAmmo();

        for k, v in pairs(SupervisorData.Weapons) do
            if (!v.ammo1 or !v.ammo_p or !v.ammo2 or !v.ammo_s) then continue end
            ply:SetAmmo(v.ammo1 or 0, v.ammo_p or 0);
            ply:SetAmmo(v.ammo2 or 0, v.ammo_s or 0);
        end
    end

    SupervisorData.EnteredPos = nil;
    SupervisorData.Weapons = {};

    net.Start( "rp.job.supervisor" );
        net.WriteUInt( SUPERVISOR_CMD_DISABLE, 2 );
    net.Send( ply );

    ply:SetNetVar( "job", team.GetName(ply:Team()) );
    rp.NotifyAll( NOTIFY_GENERIC, rp.Term("ChangeJob"), ply, team.GetName(ply:Team()) );
    
    ply:SetNoDraw( false );
    
    ply.SupervisorID = nil;
    nw.SetGlobal( "nw.rp.SupervisorStatus", {id,false} );

    return true
end


/* ---- Hooks: ------------------------------ */
hook.Add( "PlayerDisconnected", "rp.Supervisor::DisconnectedCheck", function( ply )
    if ply.SupervisorID then
        rp.ExitSupervisorMode( ply.SupervisorID );
    end
end );

hook.Add( "Think", "rp.Supervisor::PlayerVisibilityFix", function()
    for k, SupervisorData in pairs( rp.Supervisor ) do
        if not IsValid(SupervisorData.Master) then continue end
        if not IsValid(SupervisorData.Slave)  then continue end

        SupervisorData.Master:SetPos( SupervisorData.Slave:GetPos() ); -- simple as hell?
		
		if not SupervisorData.Master:GetNoDraw() then
			SupervisorData.Master:SetNoDraw( true )
		end
    end
end );

hook.Add( "CanPlayerSuicide", "rp.Supervisor::PreventSuicide", function( ply )
    if ply.SupervisorID then
        return false
    end
end );

hook.Add( "PostPlayerDeath", "rp.Supervisor::PostPlayerDeath", function( ply )
    if ply.SupervisorID then
        rp.ExitSupervisorMode( ply.SupervisorID );
    end
end );

hook.Add( "OnPlayerChangedTeam", "rp.Supervisor::OnPlayerChangedTeam", function( ply, before, after )
    if ply.SupervisorID and not rp.cfg.Supervisors.CanUse[after] then
        rp.ExitSupervisorMode( ply.SupervisorID );
    end
    
    for k, SupervisorData in pairs( rp.Supervisor ) do
        if !IsValid(SupervisorData.Master) then continue end

        if SupervisorData.Slave == ply then
            SupervisorData.Slave = NULL;
            
            net.Start( "rp.job.supervisor" );
                net.WriteUInt( SUPERVISOR_CMD_SPECTATE, 2 );
                net.WriteEntity( SupervisorData.Slave );
            net.Send( SupervisorData.Master );
        end
    end
end );


/* ---- Block PlayerSpawns: ----------------- */
local function PlayerSpawnBlock( ply )
    if ply.SupervisorID then return false end
end

hook.Add( "PlayerSpawnObject",  	"rp.Supervisor::PlayerSpawnObject",  		PlayerSpawnBlock );
hook.Add( "PlayerSpawnProp",    	"rp.Supervisor::PlayerSpawnProp",    		PlayerSpawnBlock );
hook.Add( "PlayerSpawnRagdoll", 	"rp.Supervisor::PlayerSpawnRagdoll", 		PlayerSpawnBlock );
hook.Add( "PlayerSpawnSENT",    	"rp.Supervisor::PlayerSpawnSENT",    		PlayerSpawnBlock );
hook.Add( "PlayerSpawnSWEP",    	"rp.Supervisor::PlayerSpawnSWEP",    		PlayerSpawnBlock );
hook.Add( "PlayerSpawnVehicle", 	"rp.Supervisor::PlayerSpawnVehicle", 		PlayerSpawnBlock );
hook.Add( "CanPlayerEnterVehicle", 	"rp.Supervisor::CanPlayerEnterVehicle", 	PlayerSpawnBlock );