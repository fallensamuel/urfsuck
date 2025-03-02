-- "gamemodes\\rp_base\\gamemode\\addons\\characters\\player_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
nw.Register( "CharactersPremium" )
	:Write( net.WriteBool )
	:Read( net.ReadBool )

nw.Register( "CharacterID" )
	:Write( net.WriteUInt, 32 )
	:Read( net.ReadUInt, 32 )

local PLAYER = FindMetaTable( "Player" );

function PLAYER:HasCharactersPremium()
	return tobool( self:GetNetVar("CharactersPremium") );
end

function PLAYER:GetMaxCharacters()
	return rp.CharacterSystem.MaxCharacters + ((self:HasPremium() or self:HasCharactersPremium()) and 2 or 0)
end

function PLAYER:CharacterID()
	return self:GetNetVar( "CharacterID" ) or 0;
end