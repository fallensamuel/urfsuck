AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetUseType(SIMPLE_USE)
	self:SetModel(self.PrinterModel)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetTrigger(true)
	local phys = self:GetPhysicsObject()
	if IsValid(phys) then
		phys:Wake()
	end
	
	self.clck = CurTime()
	
	self.HP = 100
	
	self:SetCurAmount(0)
	self:SetIsWorking(true)
	self:SetIsBroken(false)
	self:SetNextPrint(self.PrinterSpeed + CurTime())
	
	timer.Simple(self.PrinterSpeed, function() if IsValid(self) then self:Work() end end)
	self:StartSound()
end

function ENT:StartSound()
	self:EmitSound('printer_noise')
	
	timer.Create('rp.printer_noise_' .. self:EntIndex(), 10.5, 0, function()
		self:EmitSound('printer_noise')
	end)
end

function ENT:EndSound()
	self:StopSound('printer_noise')
	timer.Remove('rp.printer_noise_' .. self:EntIndex())
end

function ENT:Use(ply)
	if(ply:IsPlayer() and self.clck+1 < CurTime()) then
		self.clck = CurTime()

		if self.UseFunc then
			self:UseFunc(ply)
		end

		if not self:GetIsWorking() and self:GetCurAmount() < self.MaxMoney then
			self:SetIsWorking(true)
			self:SetNextPrint(self.PrinterSpeed + CurTime())
			
			timer.Simple(self.PrinterSpeed, function() if IsValid(self) then self:Work() end end)
			self:StartSound()
		end	
	end
end

function ENT:Work()
	local amount = (hook.Call('calcPrintAmount', GAMEMODE, self.Rate) or self.Rate)
	
	self:SetCurAmount(math.Clamp(self:GetCurAmount() + amount, 0, self.MaxMoney))
	self:SetIsWorking(self:GetCurAmount() < self.MaxMoney)
	
	if self:GetIsWorking() then
		self:SetNextPrint(self.PrinterSpeed + CurTime())
		timer.Simple(self.PrinterSpeed, function() if IsValid(self) then self:Work() end end)
	else
		self:EndSound()
	end
end

function ENT:Destruct()
    local effectdata = EffectData()
    effectdata:SetStart(self:GetPos())
    effectdata:SetOrigin(self:GetPos())
    effectdata:SetScale(1)
	
	if IsValid(self:Getowning_ent()) then
		rp.Notify(self:Getowning_ent(), NOTIFY_ERROR, rp.Term('PrinterExploded'))
	end
	
    util.Effect("Explosion", effectdata)
end

function ENT:OnTakeDamage(dmg)
    self:TakePhysicsDamage(dmg)
    self.HP = self.HP - dmg:GetDamage()
	
    if self.HP <= 0 then
        self:Destruct()
        self:Remove()
    elseif self.HP <= 30 then
		self:SetIsBroken(true)
	end
end

function ENT:OnRemove()
	self:EndSound()
end

function ENT:StartTouch(hitEnt)
	if hitEnt:GetClass() == "money_printer_fix" and self.HP < 100 then
		self.HP = 100
		self:SetIsBroken(false)
		
		if IsValid(self:Getowning_ent()) then
			rp.Notify(self:Getowning_ent(), NOTIFY_GREEN, rp.Term('PrinterFixed'))
		end
		
		self:EmitSound('ambient/energy/weld1.wav')
		
		hitEnt:Remove()
	end
end
