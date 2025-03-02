AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_init.lua")
include("sh_init.lua")

function ENT:Initialize()
	self:SetModel( self.Model )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow(false)
	
	timer.Simple(1, function()
		if not IsValid(self) or self.PermaProps then return end 
		self:SetPos(self:GetPos() + Vector(0, 0, 11))
	end)
	
	local phys = self:GetPhysicsObject()
	
	if IsValid(phys) then
		phys:EnableMotion(false)
	end
	
	self:SetTimeHidden(0)
	self.next_use = 0
	self.PhysgunDisabled = true
end

function ENT:Think()
	self:SetAngles(self:GetAngles() + Angle(0, 1, 0))
end

function ENT:Use( ply )
	if self.next_use > CurTime() then return end
	self.next_use = CurTime() + self.Cooldown
	
	local inv = ply:getInv()
	if not inv then return end
	
	local rand = math.random(self.MinPumpkins, self.MaxPumpkins)
	
	self:EmitSound("zpn_candy_collect0" .. math.random(1, 3) .. ".wav")
	
	rp.Notify(ply, NOTIFY_GREEN, rp.Term('PumpkinsGot'), rand)
	inv:add(self.PumpkinItem, rand)
	
	self:SetNoDraw(true)
	self:SetTimeHidden(self.next_use)
	
	timer.Simple(self.Cooldown, function()
		if IsValid(self) then
			self:SetNoDraw(false)
			self:SetTimeHidden(0)
		end
	end)
end
