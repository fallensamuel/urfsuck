/* ---- Config: ----------------------------- */
rp.cfg.Supervisors = {};
rp.cfg.Supervisors.DisplayDeadPeople = false;

SUPERVISOR_ACTION_UPGRADE1  = 58;
SUPERVISOR_ACTION_UPGRADE2  = 59;
SUPERVISOR_ACTION_UPGRADE3  = 60;
SUPERVISOR_ACTION_UPGRADE4  = 61;
SUPERVISOR_ACTION_UPGRADE5 = 62;
SUPERVISOR_ACTION_LEAVE = 63;

rp.cfg.Supervisors.CanUse = {}

if TEAM_DISPATCH then
	rp.cfg.Supervisors.CanUse[TEAM_DISPATCH] = true
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

if TEAM_RASSEL then
	rp.cfg.Supervisors.CanUse[TEAM_RASSEL] = true
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

rp.cfg.Supervisors.Actions = {
    [SUPERVISOR_ACTION_UPGRADE1] = {
        Name     = "Выдача Дробовика",
        Cooldown = 240,
        Execute  = function( master, slave )
            giveUpgrades(master, slave, rp.cfg.Supervisors.List[master.SupervisorID].Upgrade1)
        end
    },
    [SUPERVISOR_ACTION_UPGRADE2] = {
        Name     = "Выдача AR2",
        Cooldown = 240,
        Execute  = function( master, slave )
            giveUpgrades(master, slave, rp.cfg.Supervisors.List[master.SupervisorID].Upgrade2)
        end
    },
    [SUPERVISOR_ACTION_UPGRADE3] = {
        Name     = "Выдача AR3",
        Cooldown = 240,
        Execute  = function( master, slave )
            giveUpgrades(master, slave, rp.cfg.Supervisors.List[master.SupervisorID].Upgrade3)
        end
    },
    [SUPERVISOR_ACTION_UPGRADE4] = {
        Name     = "Выдача O.I.C.W v.2",
        Cooldown = 240,
        Execute  = function( master, slave )
            giveUpgrades(master, slave, rp.cfg.Supervisors.List[master.SupervisorID].Upgrade4)
        end
    },
    [SUPERVISOR_ACTION_UPGRADE5] = {
        Name     = "Выдача RPG",
        Cooldown = 240,
        Execute  = function( master, slave )
            giveUpgrades(master, slave, rp.cfg.Supervisors.List[master.SupervisorID].Upgrade5)
        end
    },

    [SUPERVISOR_ACTION_LEAVE] = {
        Name    = "Выйти из терминала",
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
            [SUPERVISOR_ACTION_UPGRADE5] = true,
            [SUPERVISOR_ACTION_LEAVE] = true,
        },
        Upgrade1 = {
            [FACTION_MPF] = {
                Weapons = {
                    ["Shotgun"]      = "swb_shotgun",
                },
            },
            [FACTION_HELIX] = {
                Weapons = {
                    ["Shotgun"]      = "swb_shotgun",
                },
            },
            [FACTION_OTA] = {
                Weapons = {
                    ["Shotgun"]      = "swb_shotgun",
                },
            },    
        },
        Upgrade2 = {
            [FACTION_MPF] = {
                Weapons = {
                    ["AR2"]           = "swb_ar2",
                },
            },
            [FACTION_HELIX] = {
                Weapons = {
                    ["AR2"]           = "swb_ar2",
                },
            },
            [FACTION_OTA] = {
                Weapons = {
                    ["AR2"]           = "swb_ar2",
                },
            },    
        },
        Upgrade3 = {
            [FACTION_MPF] = {
                Weapons = {
                    ["AR3"]           = "swb_ar3",
                },
            },
            [FACTION_HELIX] = {
                Weapons = {
                    ["AR3"]           = "swb_ar3",
                },
            },
            [FACTION_OTA] = {
                Weapons = {
                    ["AR3"]           = "swb_ar3",
                },
            },    
        },
        Upgrade5 = {
            [FACTION_MPF] = {
                Weapons = {
                    ["RPG"]         = "weapon_rpg",
                },
            },
            [FACTION_HELIX] = {
                Weapons = {
                    ["RPG"]         = "weapon_rpg",
                },
            },
            [FACTION_OTA] = {
                Weapons = {
                    ["RPG"]         = "weapon_rpg",
                },
            },    
        },
        Filter = function( ent )
            if IsValid(ent) then
                if ent:IsPlayer() and ent:IsCombine() and !ent.SupervisorID then return true end
            end

            return false
        end
    },
    [2] = {
        Name    = "[002]",
        Desc    = "n/a",
        Actions = {
            [SUPERVISOR_ACTION_UPGRADE1]    = true,
            [SUPERVISOR_ACTION_UPGRADE4]    = true,
            [SUPERVISOR_ACTION_UPGRADE5]    = true,
            [SUPERVISOR_ACTION_LEAVE]       = true,
                },
        Upgrade1 = {
            [FACTION_REBEL] = {
                Weapons = {
                    ["Shotgun"]      = "swb_shotgun",
                },
            },
        },
        Upgrade4 = {
            [FACTION_REBEL] = {
                Weapons = {
                    ["O.I.C.W v2"]   = "swb_oicw_v2",
                },
            },
        },
        Upgrade5 = {
            [FACTION_REBEL] = {
                Weapons = {
                    ["RPG"]         = "weapon_rpg",
                },
            },
        },
        Filter = function( ent )
            return IsValid(ent) and ent:IsPlayer() and ent:GetFaction() == FACTION_REBEL and !ent.SupervisorID
        end
    }
}

rp.cfg.Supervisors.List[2] = table.Copy(rp.cfg.Supervisors.List[2]);
rp.cfg.Supervisors.List[2].Name = "[002]";

rp.cfg.Supervisors.List[3] = table.Copy(rp.cfg.Supervisors.List[1]);
rp.cfg.Supervisors.List[3].Name = "[003]";