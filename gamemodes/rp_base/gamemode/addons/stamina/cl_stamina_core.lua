-- "gamemodes\\rp_base\\gamemode\\addons\\stamina\\cl_stamina_core.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local noop = function() end;
local net_Receive, net_Start, net_SendToServer, net_ReadUInt, net_ReadFloat, hook_Add = net.Receive, net.Start, net.SendToServer, net.ReadUInt, net.ReadFloat, hook.Add;

----------------------------------------------------------------
STAMINA_NETWORKING_RECV = {
    [STAMINA_DMG] = function( ply )
        ply:SetStaminaLastDamagedTime( net_ReadFloat() or 0 );
    end,

    [STAMINA_MAX] = function( ply )
        ply:SetMaxStamina( net_ReadFloat() or 0 );
    end,

    [STAMINA_VAL] = function( ply )
        ply:SetStamina( net_ReadFloat() or 0 );
    end,
};

if STAMINA_DISABLED then return end

net_Receive( STAMINA_NETMESSAGE, function()
    (STAMINA_NETWORKING_RECV[net_ReadUInt(3)] or noop)( LocalPlayer() );
end );

hook_Add( "InitPostEntity", "Stamina::Initialize", function()
    net_Start( STAMINA_NETMESSAGE ); net_SendToServer();
end );