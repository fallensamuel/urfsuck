ENT.Type 		= 'anim'
ENT.Base 		= 'base_anim'
ENT.PrintName 	= 'Ammo Box'
ENT.Author 		= 'SerGun'
ENT.Spawnable 	= true
ENT.AdminSpawnable 	= false
ENT.Category 	= 'Half-Life Alyx RP'
ENT.AdminOnly = true

ENT.AutomaticFrameAdvance = true
ENT.ReuseTimeout = 60 * 5

function ENT:HasAccess(ply)
	return IsValid(ply) and ply:GetFaction() and self.Factions and self.Factions[ply:GetFaction()]
end
