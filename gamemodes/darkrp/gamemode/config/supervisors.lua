-- "gamemodes\\darkrp\\gamemode\\config\\supervisors.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
 ---- Config: ----------------------------- 
rp.cfg.Supervisors = {};

-- Диспетчер:
    SUPERVISOR_ACTION_UPGRADE1 = 1;
    SUPERVISOR_ACTION_UPGRADE2 = 2;
    SUPERVISOR_ACTION_UPGRADE3 = 3;
    SUPERVISOR_ACTION_UPGRADE4 = 4;
    SUPERVISOR_ACTION_UPGRADE5 = 5;

-- Общие:
    SUPERVISOR_ACTION_LEAVEGLITCH = 62;
    SUPERVISOR_ACTION_LEAVE = 63;

rp.cfg.Supervisors.CanUse = {}

if TEAM_SUPERVISOR then
    rp.cfg.Supervisors.CanUse[TEAM_SUPERVISOR] = true
end

-- Helpers:
if SERVER then -- Pills support:
    hook.Add( "PreRegisterSENT", "rp.Supervisors::InjectPill", function( costume, class )
        if class ~= "pill_ent_costume" then return end

        costume.BaseThink = costume.Think;
        costume.Think = function( self )
            self:BaseThink();

            local ply, puppet = self:GetPillUser(), self:GetPuppet();

            if (not IsValid(ply)) or (not IsValid(puppet)) then return end

            if ply.SupervisorID and (not puppet.i_lastRenderMode) then
                puppet.i_lastRenderMode = puppet:GetRenderMode(); 
                puppet:SetRenderMode( RENDERMODE_NONE );
                return
            end

            if (not ply.SupervisorID) and puppet.i_lastRenderMode then
                puppet:SetRenderMode( puppet.i_lastRenderMode );
                puppet.i_lastRenderMode = nil;
                return
            end
        end

        hook.Remove( "PreRegisterSENT", "rp.Supervisors::InjectPill" );
    end );
end

local function giveUpgrades(master, slave, Upgrades)
    if not Upgrades or not IsValid(slave) then return end
    if not Upgrades[slave:GetFaction()]   then return end
    
    local wepNotify = {};
    
    Upgrades = Upgrades[slave:GetFaction()];
    if Upgrades.Weapons then
        for printName, wep in pairs( Upgrades.Weapons ) do
            slave:Give( wep );
            table.insert( wepNotify, printName );
        end
    end
    
    if Upgrades.Attachments then
        local attachments = istable(Upgrades.Attachments) and Upgrades.Attachments or {Upgrades.Attachments}
        
        if not CustomizableWeaponry:hasSpecifiedAttachments(slave, attachments) then
            CustomizableWeaponry.giveAttachments(slave, attachments)
        end
    end
    
    if Upgrades.Health then
        slave:SetHealth( math.Min(slave:Health() + Upgrades.Health, slave:GetMaxHealth()) )
    end
    
    if Upgrades.Armor then
        slave:SetArmor(math.min(slave:Armor() + Upgrades.Armor, rp.cfg.MaxArmor));
    end
    
    rp.Notify( slave, NOTIFY_GENERIC, rp.Term("SupervisorUpgradedInfo") );
    
    if #wepNotify > 0 then
        rp.Notify( slave, NOTIFY_GENERIC, rp.Term("SupervisorUpgradedWeps"), table.concat(wepNotify,", ") );
    end
end

local tracked = {};

local function friendCheck()
    local slave = rpSupervisor.Slave;
    if not IsValid( slave ) then return false end
    local c = rp.cfg.Supervisors.List[rpSupervisor.ID];
    return c.Factions.Friends[slave:GetFaction()];
end

local function enemyCheck()
    return not friendCheck()
end

rp.cfg.Supervisors.ForceDisableOnLost = true


if SERVER then
    hook.Add("PlayerDeath", "ShizoUnfreeze", function(ply)
        if IsValid(ply) and ply.b_shizoFreeze then
            timer.Remove(ply:EntIndex() .. "shizoFreeze")
            
            ply.b_shizoFreeze = nil;
            
            ply:Freeze( false );
            
            if tracked[ply] then
                tracked[ply][ply:EntIndex() .. "shizoFreeze"] = nil;
            end
        end
    end)
end

rp.cfg.Supervisors.Actions = {
    [SUPERVISOR_ACTION_UPGRADE1] = {
        Name     = "Выдача Дробовика",
        Cooldown = 240,
        Execute  = function( master, slave )
            giveUpgrades(master, slave, rp.cfg.Supervisors.List[master.SupervisorID].Upgrade1)
        end
    },

    [SUPERVISOR_ACTION_UPGRADE2] = {
        Name     = "Выдача Пулемета",
        Cooldown = 240,
        Execute  = function( master, slave )
            giveUpgrades(master, slave, rp.cfg.Supervisors.List[master.SupervisorID].Upgrade2)
        end
    },

    [SUPERVISOR_ACTION_UPGRADE3] = {
        Name     = "Выдача Пистолета Пулемёта",
        Cooldown = 240,
        Execute  = function( master, slave )
            giveUpgrades(master, slave, rp.cfg.Supervisors.List[master.SupervisorID].Upgrade3)
        end
    },

    [SUPERVISOR_ACTION_UPGRADE4] = {
        Name     = "Выдача Снайперской Винтовки",
        Cooldown = 280,
        Execute  = function( master, slave )
            giveUpgrades(master, slave, rp.cfg.Supervisors.List[master.SupervisorID].Upgrade4)
        end
    },

    [SUPERVISOR_ACTION_UPGRADE5] = {
        Name     = "Выдача Винтовки",
        Cooldown = 240,
        Execute  = function( master, slave )
            giveUpgrades(master, slave, rp.cfg.Supervisors.List[master.SupervisorID].Upgrade5)
        end
    },

    [SUPERVISOR_ACTION_LEAVE] = {
        Name    = "Покинуть Монолит",
        Execute = function( master, slave )
            rp.ExitSupervisorMode( master.SupervisorID );
        end
    }
}

rp.cfg.Supervisors.List = {
    [1] = {
        Name    = "[001]",
        Desc    = "n/a",
        Actions = {
            [SUPERVISOR_ACTION_UPGRADE1] = true,
            [SUPERVISOR_ACTION_UPGRADE2] = true,
            [SUPERVISOR_ACTION_UPGRADE3] = true,
            [SUPERVISOR_ACTION_UPGRADE4] = true,
            [SUPERVISOR_ACTION_UPGRADE5] = true,
            [SUPERVISOR_ACTION_LEAVE] = true,
        },
        Upgrade1 = {
            [FACTION_MONOLITH] = {
                Weapons = {
                    ["SPAS-12"]          = "tfa_anomaly_spas12",
                },
            },  
        },
        Upgrade2 = {
            [FACTION_MONOLITH] = {
                Weapons = {
                    ["M249"]          = "tfa_anomaly_m249",
                },
            },  
        },
        Upgrade3 = {
            [FACTION_MONOLITH] = {
                Weapons = {
                    ["P90"]          = "tfa_anomaly_p90",
                },
            },  
        },
        Upgrade4 = {
            [FACTION_MONOLITH] = {
                Weapons = {
                    ["SV98"]          = "tfa_anomaly_sv98",
                },
            },  
        },
        Upgrade5 = {
            [FACTION_MONOLITH] = {
                Weapons = {
                    ["FN2000"]          = "tfa_anomaly_fn2000_nimble",
                },
            },  
        },

        Filter = function( ent )
            --print(ent:IsPlayer(), ent:IsMonolit(), !ent.SupervisorID)
            if IsValid(ent) then
                if ent:IsPlayer() and (ent:IsMonolit() or ent:GetFaction() == FACTION_CITIZEN) and !ent.SupervisorID then return true end
            end

            return false
        end
    }
};

if SERVER then
    hook.Add('PlayerSpawn', 'rp.Supervisors.RespawnCanUseUpg', function(ply)
        if IsValid(ply) then
            ply.GotSupervisorUpg = nil
        end
    end)
end

rp.cfg.Supervisors.List[2] = table.Copy(rp.cfg.Supervisors.List[1]);
rp.cfg.Supervisors.List[2].Name = "[002]";

rp.cfg.Supervisors.List[3] = table.Copy(rp.cfg.Supervisors.List[1]);
rp.cfg.Supervisors.List[3].Name = "[003]";