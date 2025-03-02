-- "gamemodes\\darkrp\\entities\\entities\\ent_antirad.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Type = "anim"
ENT.Base = "base_entity"

ENT.Spawnable = true
ENT.AdminSpawnable = false

ENT.PrintName = "Антирад"

ENT.Model = "models/stalker/item/medical/antirad.mdl"

if SERVER then
	function ENT:Initialize()
		self:SetModel( self.Model )
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
		self:DrawShadow(false)
		
		local phys = self:GetPhysicsObject()
		phys:EnableMotion(false)

		self.PhysgunDisabled = true
	end

	function ENT:Use( ply,caller )
		if self.used then return end
		ply.anomaly_resistance = 0.2

		self:EmitSound('hgn/stalker/player/pl_pills.mp3')

		rp.Notify(ply, NOTIFY_GREEN, rp.Term("UseTablet"))

		self.used = true
		self:Remove()

	end
end