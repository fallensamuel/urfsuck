include("sh_init.lua")

--function ENT:Initialize()
	--ParticleEffectAttach("zpn_candy0" .. math.random(1, 3) .. "_fx", PATTACH_POINT_FOLLOW, self, 0)
--end

function ENT:Draw()
	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) < 500000 then 
		self:DrawModel()
	end
end

function ENT:Think()
	if not self.Inited then
		self.Inited = true
		timer.Simple(0, function()
			ParticleEffectAttach("zpn_candy0" .. math.random(1, 3) .. "_fx", PATTACH_POINT_FOLLOW, self, 0)
		end)
	end
		
	if self:GetTimeHidden() and self:GetTimeHidden() > CurTime() and self.EffectDrawn then
		self:StopParticles()
		self.EffectDrawn = nil
		
	elseif self:GetTimeHidden() and self:GetTimeHidden() < CurTime() and not self.EffectDrawn then
		ParticleEffectAttach("zpn_candy0" .. math.random(1, 3) .. "_fx", PATTACH_POINT_FOLLOW, self, 0)
		self.EffectDrawn = true
	end
end