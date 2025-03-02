-- "gamemodes\\rp_base\\entities\\entities\\ent_c4\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type 		= "anim"
ENT.PrintName	= "C4"
ENT.Author		= "aStonedPenguin"
ENT.Spawnable 	= false

function ENT:Initialize()
	self:EmitSound("C4.Plant")
end