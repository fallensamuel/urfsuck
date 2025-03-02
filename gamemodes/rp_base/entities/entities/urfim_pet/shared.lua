-- "gamemodes\\rp_base\\entities\\entities\\urfim_pet\\shared.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Pet"
ENT.Category = "Fun + Games"
ENT.Author = ""

ENT.Spawnable = false

--ENT.RenderGroup = RENDERGROUP_OTHER
--ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.AutomaticFrameAdvance = true

ENT.RunDistance = 65 * 65
ENT.TeleportDistance = 800 * 800

ENT.Sequences = {
	[0] = 'idle',
	[1] = 'walk',
	[2] = 'run',
	[3] = 'kill',
	[4] = 'down',
	[5] = 'wait',
}

ENT.IsPet = true

--util.PrecacheModel("models/hunter/blocks/cube075x075x075.mdl")