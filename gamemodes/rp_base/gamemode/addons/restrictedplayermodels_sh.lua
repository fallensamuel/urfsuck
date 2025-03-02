-- "gamemodes\\rp_base\\gamemode\\addons\\restrictedplayermodels_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local fn_false = function() return false end;

rp.RestrictedPlayerModels = rp.RestrictedPlayerModels or {};

function rp.RestrictPlayerModel( mdl, check )
    if not isfunction( check ) then
        check = fn_false;
    end

    mdl = string.lower( mdl );
    rp.RestrictedPlayerModels[mdl] = check;
end

if SERVER then
    hook.Add( "OnAdminChangedPlayerModel", "rp.RestrictPlayerModel", function( caller, target, mdl )
        mdl = string.lower( mdl );

        local fn = rp.RestrictedPlayerModels[mdl];
        if fn then
            return fn( target, caller ), translates.Get( "Модель является заблокированной для использования на этом игроке." )
        end
    end );
end