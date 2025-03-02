-- "gamemodes\\rp_base\\gamemode\\addons\\stamina\\sh_stamina_legacy.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local PLAYER = FindMetaTable( "Player" );
local CurTime, hook_Add, net_WriteUInt, net_ReadUInt = CurTime, hook.Add, net.WriteUInt, net.ReadUInt;

----------------------------------------------------------------
nw.Register( "LastDamageTime" )
	:Write( net_WriteUInt, 32 )
	:Read( net_ReadUInt, 32 )
	:SetLocalPlayer()

----------------------------------------------------------------
function PLAYER:GetLastDamageTime()
	return CurTime() - (self:GetNetVar("LastDamageTime") or 0)
end

if SERVER then
	local function UpdateLastDamageTime( ply )
		if not ply:IsPlayer() then return end
		ply:SetNetVar( "LastDamageTime", CurTime() );
	end

	hook_Add( "PlayerSpawn", "nw_LastDamageTime", UpdateLastDamageTime );
	hook_Add( "PlayerInitialSpawn", "nw_LastDamageTime", UpdateLastDamageTime );
	hook_Add( "EntityTakeDamage", "nw_LastDamageTime", UpdateLastDamageTime );
end