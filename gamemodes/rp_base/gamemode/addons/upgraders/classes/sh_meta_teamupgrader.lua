-- "gamemodes\\rp_base\\gamemode\\addons\\upgraders\\classes\\sh_meta_teamupgrader.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
CTeamUpgrader = {};
CTeamUpgrader.__index  = CTeamUpgrader;

function CTeamUpgrader:Create( uid, name )
    if not uid then return false end

    local teamupgrader = {
        ["uid"] = uid,
        ["Name"] = name,
        ["Abilities"] = {},
        ["Cooldown"] = 0,
    };

    rp.Upgraders.List = rp.Upgraders.List or {};
    rp.Upgraders.List[teamupgrader.uid] = teamupgrader;

    rp.Upgraders.Map = rp.Upgraders.Map or {};
    teamupgrader.id = table.insert( rp.Upgraders.Map, teamupgrader );
    
    setmetatable( teamupgrader, CTeamUpgrader );
    return teamupgrader;
end

setmetatable( CTeamUpgrader, {__call = CTeamUpgrader.Create} );

----------------------------------------------------------------
-- [Get/Set] Name():
----------------------------------------------------------------
function CTeamUpgrader:GetName()
    return self["Name"];
end

function CTeamUpgrader:SetName( name )
    self["Name"] = name;
    return self;
end

----------------------------------------------------------------
-- [Get/Add/Remove] Abilities():
----------------------------------------------------------------
function CTeamUpgrader:GetAbilities()
    return self["Abilities"];
end

function CTeamUpgrader:AddAbility( ability )
    self["Abilities"][istable(ability) and ability.uid or tostring(ability)] = true;
    return self;
end

function CTeamUpgrader:RemoveAbility( ability )
    self["Abilities"][istable(ability) and ability.uid or tostring(ability)] = nil;
    return self;
end

----------------------------------------------------------------
-- [Get/Set] GlobalCooldown():
----------------------------------------------------------------
function CTeamUpgrader:GetGlobalCooldown()
    return tonumber( self["Cooldown"] ) or 0;
end

function CTeamUpgrader:SetGlobalCooldown( cooldown )
    self["Cooldown"] = tonumber( cooldown ) or 0;
    return self;
end