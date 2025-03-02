ENT.Type 		= "anim"
ENT.PrintName	= "C4"
ENT.Author		= "aStonedPenguin"
ENT.Spawnable 	= true
ENT.Category = "Half-Life Alyx RP"
ENT.AdminOnly	= true

function ENT:Initialize()
	self:EmitSound("C4.Plant")
end