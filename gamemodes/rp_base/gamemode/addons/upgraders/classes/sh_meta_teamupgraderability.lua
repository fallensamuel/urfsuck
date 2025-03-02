-- "gamemodes\\rp_base\\gamemode\\addons\\upgraders\\classes\\sh_meta_teamupgraderability.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
CTeamUpgraderAbility = {};
CTeamUpgraderAbility.__index  = CTeamUpgraderAbility;

function CTeamUpgraderAbility:Create( uid, name, icon )
    if not uid then return false end

    local ability = {
        ["uid"] = uid,
        
        ["Icon"] = Material( icon ) or Material( "error" ),
        ["Name"] = name,
        ["Duration"] = 0,
        ["Cooldown"] = 1,
        ["Radius"] = 0,
        ["Keybindings"] = {},
        ["Filter"] = function( ply ) end,

        ["OnStart"] = function( ply ) end,
        ["OnEnd"] = function( ply ) end,

        ["OnEffectStart"] = function() end,
        ["OnEffectEnd"] = function() end,
    };
    
    rp.Upgraders.Abilities = rp.Upgraders.Abilities or {};
    
    rp.Upgraders.Abilities.List = rp.Upgraders.Abilities.List or {};
    rp.Upgraders.Abilities.List[ability.uid] = ability;
    
    rp.Upgraders.Abilities.Map = rp.Upgraders.Abilities.Map or {};
    ability.id = table.insert( rp.Upgraders.Abilities.Map, ability );

    setmetatable( ability, CTeamUpgraderAbility );
    return ability;
end

setmetatable( CTeamUpgraderAbility, {__call = CTeamUpgraderAbility.Create} );

----------------------------------------------------------------
-- [Get/Set] Icon():
----------------------------------------------------------------
function CTeamUpgraderAbility:GetIcon()
    return self["Icon"];
end

function CTeamUpgraderAbility:SetIcon( icon )
    self["Icon"] = Material( icon );
    return self;
end

----------------------------------------------------------------
-- [Get/Set] Name():
----------------------------------------------------------------
function CTeamUpgraderAbility:GetName()
    return self["Name"];
end

function CTeamUpgraderAbility:SetName( name )
    self["Name"] = name;
    return self;
end

----------------------------------------------------------------
-- [Get/Set] Duration():
----------------------------------------------------------------
function CTeamUpgraderAbility:GetDuration()
    return self["Duration"];
end

function CTeamUpgraderAbility:SetDuration( duration )
    self["Duration"] = tonumber( duration ) or 0;
    return self;
end

----------------------------------------------------------------
-- [Get/Set] Cooldown():
----------------------------------------------------------------
function CTeamUpgraderAbility:GetCooldown()
    return self["Cooldown"];
end

function CTeamUpgraderAbility:SetCooldown( cooldown )
    self["Cooldown"] = tonumber( cooldown ) or 0;
    return self;
end

----------------------------------------------------------------
-- [Get/Set] Radius():
----------------------------------------------------------------
function CTeamUpgraderAbility:GetRadius()
    return self["Radius"];
end

function CTeamUpgraderAbility:SetRadius( radius )
    self["Radius"] = tonumber( radius ) or 0;
    return self;
end

----------------------------------------------------------------
-- [Get/Set] Keybindings():
----------------------------------------------------------------
function CTeamUpgraderAbility:GetKeybindings()
    return self["Keybindings"];
end

function CTeamUpgraderAbility:SetKeybindings( ... )
    self["Keybindings"] = { ... };
    return self;
end

----------------------------------------------------------------
-- [Get/Set/*] Filter():
----------------------------------------------------------------
function CTeamUpgraderAbility:GetFilter()
    return self["Filter"];
end

function CTeamUpgraderAbility:SetFilter( func )
    self["Filter"] = func;
    return self;
end

----------------------------------------------------------------
-- [Get/Set] OnStart():
----------------------------------------------------------------
function CTeamUpgraderAbility:GetOnStart()
    return self["OnStart"];
end

function CTeamUpgraderAbility:SetOnStart( func )
    self["OnStart"] = func;
    return self;
end

----------------------------------------------------------------
-- [Get/Set] OnEnd():
----------------------------------------------------------------
function CTeamUpgraderAbility:GetOnEnd()
    return self["OnEnd"];
end

function CTeamUpgraderAbility:SetOnEnd( func )
    self["OnEnd"] = func;
    return self;
end

----------------------------------------------------------------
-- [Get/Set] OnEffectStart():
----------------------------------------------------------------
function CTeamUpgraderAbility:GetOnEffectStart()
    return self["OnEffectStart"];
end

function CTeamUpgraderAbility:SetOnEffectStart( func )
    self["OnEffectStart"] = func;
    return self;
end

----------------------------------------------------------------
-- [Get/Set] OnEffectEnd():
----------------------------------------------------------------
function CTeamUpgraderAbility:GetOnEffectEnd()
    return self["OnEffectEnd"];
end

function CTeamUpgraderAbility:SetOnEffectEnd( func )
    self["OnEffectEnd"] = func;
    return self;
end