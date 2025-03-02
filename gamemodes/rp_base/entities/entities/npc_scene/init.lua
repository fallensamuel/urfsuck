AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')
util.AddNetworkString('rp.CopshopMenu')

function ENT:Initialize()
	self:SetModel('models/breen.mdl')
	self:SetNPCState(NPC_STATE_SCRIPT)
	self:CapabilitiesAdd(CAP_ANIMATEDFACE)
	self:DropToFloor()
	self:SetMaxYawSpeed(90)

	self:SetNotSolid(true)
	--self:PlayScene('scenes/breencast/disruptor.vcd')
end

hook('InitPostEntity', function()
	for k, v in pairs(rp.cfg.Scenes[game.GetMap()] or {}) do
		local ent = ents.Create('npc_scene')
		ent:SetModel(v.Model)
		ent:SetPos(v.Pos)
		ent:SetAngles(v.Ang)
		ent:Spawn()
		timer.Create('npc_scene'..ent:EntIndex(), ent:PlayScene(v.Scene) + (v.Delay or 0), 0, function()
			ent:PlayScene(v.Scene)
		end)
	end
end)

function ENT:OnRemove()
	timer.Remove('npc_scene'..self:EntIndex())
end