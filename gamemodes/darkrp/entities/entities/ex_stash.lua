-- "gamemodes\\darkrp\\entities\\entities\\ex_stash.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
AddCSLuaFile()
DEFINE_BASECLASS( "base_anim" )
ENT.Type = "anim"
ENT.Base = "base_entity"
ENT.RenderGroup = RENDERGROUP_BOTH
ENT.Spawnable = true
ENT.AdminSpawnable = true
ENT.AdminOnly = true
ENT.PrintName = "Extra Stash"
ENT.Model = "models/props_junk/cardboard_box003b.mdl"

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
		
		ply:AddMoney(5000)
		ply:Give('swb_sayga_kekler')
		

		rp.Notify(ply, NOTIFY_GREEN, rp.Term("ExtraStash"))

		self:Disable()

		self.disabled = CurTime() + 1200
	end

	function ENT:Think()
		if self.disabled && self.disabled < CurTime() then
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