-- "gamemodes\\rp_base\\gamemode\\addons\\upgraders\\classes\\sh_meta_player.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PLAYER = debug.getregistry()["Player"];

function PLAYER:GetUpgraderTable()
    return (self:GetJobTable() or {}).upgrader or false;
end