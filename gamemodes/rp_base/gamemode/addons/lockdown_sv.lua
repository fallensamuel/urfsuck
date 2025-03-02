local IsLockdownActive, IsLockdownCooldown = false, false;
local LockdownCmds = {
    Lockdown   = { "lockdown", "ld", "комчас", "кч" },
    UnLockdown = { "unlockdown", "uld" },
};


local last = 0

function GM:CanLockdown(ply, checkonly)
    if last > CurTime() then
        if not checkonly then
            if IsValid(ply) then
                rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotLockdown'))
            end
        end
        
        return false
    end
    return true
end

--]] GAMEMODE Functions:
    function GM:LockdownStarted( ply, id )
    end

    function GM:Lockdown( ply, id )
        if ply:IsMayor() or ply:GetJobTable().CanStartLockdown then
            if IsLockdownActive then
                rp.Notify( ply, NOTIFY_ERROR, rp.Term("CannotLockdown") );
                return ""  
            end

            IsLockdownActive = true;
            
            last = CurTime() + (rp.cfg.LockdownDelay or 20)

            id = rp.cfg.Lockdowns[id] and id or 1;
            
            nw.SetGlobal( "lockdown", id );
            nw.SetGlobal( "mayorGrace", nil );

            hook.Call( "LockdownStarted", GAMEMODE, ply, id );

            timer.Create( "rp.Lockdown.Stop", 600, 1, function()
                GAMEMODE:UnLockdown( ply );
            end );

            rp.NotifyAll( NOTIFY_ERROR, rp.Term("LockdownStarted"), rp.cfg.Lockdowns[id].name );
        else
            rp.Notify( ply, NOTIFY_ERROR, rp.Term("IncorrectJob") );
        end

        return ""
    end

    function GM:UnLockdown( ply )
        if not IsValid(ply) or ply:IsMayor() or ply:GetJobTable().CanStartLockdown then
            if IsValid(ply) and (not IsLockdownActive or IsLockdownCooldown) then
                rp.Notify( ply, NOTIFY_ERROR, rp.Term("CannotUnlockdown") );
                return ""
            end

            last = CurTime() + (rp.cfg.LockdownDelay or 20)

            IsLockdownCooldown = true;

            if timer.Exists( "rp.Lockdown.Stop" ) then
                timer.Destroy( "rp.Lockdown.Stop" );
            end

            timer.Simple((rp.cfg.LockdownDelay or 20), function()
                IsLockdownActive   = false;
                IsLockdownCooldown = false;
			end );
			
			hook.Call( "LockdownEnded", GAMEMODE, ply, nw.GetGlobal("lockdown") );

            rp.NotifyAll( NOTIFY_GREEN, rp.Term("LockdownEnded"), rp.cfg.Lockdowns[nw.GetGlobal("lockdown")].name );
			nw.SetGlobal( "lockdown", nil );
		else
            rp.Notify( ply, NOTIFY_ERROR, rp.Term("IncorrectJob") );
        end

        return ""
    end


--]] Chat Commands:
    local function cmdLockdown( ply, id ) GAMEMODE:Lockdown( ply, tonumber(id) ); end
    local function cmdUnLockdown( ply ) GAMEMODE:UnLockdown( ply ); end

    for _, alias in pairs( LockdownCmds.Lockdown ) do
        rp.AddCommand( "/" .. alias, cmdLockdown );
    end
    
    for _, alias in pairs( LockdownCmds.UnLockdown ) do
        rp.AddCommand( "/" .. alias, cmdUnLockdown );
    end


--]] Hooks:
    hook( "OnPlayerChangedTeam", "mayorgrace.OnPlayerChangedTeam", function( ply, before, after )
        if rp.teams[after].mayor then
            nw.SetGlobal( "mayorGrace", CurTime() + 300 );
        elseif rp.teams[before].mayor then
            nw.SetGlobal( "mayorGrace", nil );
        end
    end );

    hook( "PlayerDeath", "DemoteOnDeath", function( ply )
        if ply:Team() == TEAM_MAYOR then
            GAMEMODE:UnLockdown( ply );

            nw.SetGlobal( "mayorGrace", nil );
            rp.resetLaws();

			timer.Simple(0, function()
				ply:ChangeTeam( 1, true );
				ply:TeamBan( TEAM_MAYOR, 180 );
			end)

            --rp.FlashNotifyAll( "Городские Новости", rp.Term("MayorHasDied") );
            rp.NotifyAll(NOTIFY_ERROR, rp.Term("MayorHasDied"))
        end
    end );

	hook( "PlayerDisconnected", "DemoteOnDisconnect", function( ply )
		if ply:Team() == TEAM_MAYOR then
            GAMEMODE:UnLockdown( ply );

            nw.SetGlobal( "mayorGrace", nil );
			rp.resetLaws();

            --rp.FlashNotifyAll( "Городские Новости", rp.Term("MayorHasDied") );
             rp.NotifyAll(NOTIFY_ERROR, rp.Term("MayorHasDied"))
        end
    end );