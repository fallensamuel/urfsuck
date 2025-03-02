-- "gamemodes\\rp_base\\gamemode\\addons\\sync_hours\\cl_playervars.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
net.Receive( "playervariable", function()
    local ply = LocalPlayer();
    ply["Set" .. (net.ReadBool() and "Global" or "Local") .. "Variable"]( ply, net.ReadString(), net.ReadType() );
end );

----------------------------------------------------------------
hook.Add( "InitPostEntity", "PlayerVariables::Sync", function()
    net.Start( "playervariable" ); net.SendToServer();
end );

----------------------------------------------------------------
local PLAYER = FindMetaTable( "Player" );

function PLAYER:GetLocalVariable( key )
    return (self.m_LocalVariables or {})[key];
end

function PLAYER:SetLocalVariable( key, value )
    self.m_LocalVariables = self.m_LocalVariables or {};
    self.m_LocalVariables[key] = value;
end

function PLAYER:GetGlobalVariable( key )
    return (self.m_GlobalVariables or {})[key];
end

function PLAYER:SetGlobalVariable( key, value )
    self.m_GlobalVariables = self.m_GlobalVariables or {};
    self.m_GlobalVariables[key] = value;
end