-- "gamemodes\\darkrp\\entities\\entities\\tikva.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = false
ENT.AdminSpawnable = false
ENT.PrintName = "daun"
ENT.Author = "ClemensProduction aka Zerochain"
ENT.Information = "info"
ENT.Category = "borislu"
ENT.Model = "models/Gibs/HGIBS.mdl"

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
		if self.disabled then return end
		
		ply:AddCredits(1)

		self:Disable()

		self.disabled = CurTime() + 600
	end

	function ENT:Think()
		if self.disabled && self.disabled < CurTime() && player.GetCount() < 3 then
			self:Enable()
		end
	end

	function ENT:Enable()
		self:SetNotSolid(false)
		self:SetNoDraw(false)
		self.disabled = false
	end

	function ENT:Disable()
		self:SetNotSolid(true)
		self:SetNoDraw(true)
		self.disabled = true
	end
else
	function ENT:Draw()
		self:DrawModel()
		if(self:GetPos():Distance(LocalPlayer():GetPos()) > 300) then return end
	end
end