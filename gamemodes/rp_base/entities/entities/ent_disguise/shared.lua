ENT.Type 		= 'anim'
ENT.Base 		= 'base_anim'
ENT.PrintName 	= 'Disguise'
ENT.Author 		= 'aStonedPenguin'
ENT.Spawnable 	= true
ENT.Category 	= 'RP'

ENT.AdminOnly = true

nw.Register "VortDisguise"
	:Write(net.WriteBool)
	:Read(net.ReadBool)

local PLAYER = FindMetaTable("Player")

function PLAYER:IsVortDisguised()
	return self:GetNetVar('VortDisguise')
end