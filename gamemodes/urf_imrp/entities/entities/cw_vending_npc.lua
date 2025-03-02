AddCSLuaFile()
DEFINE_BASECLASS('cw_vendingmachine')
ENT.PrintName = '[urf] NPC'
ENT.Spawnable = true;
ENT.AdminOnly	= true

if SERVER then
	ENT.lastSpeach = 0

	function ENT:Initialize()
		self.BaseClass.Initialize(self)

		self.stock = -1
	end

	local STATE_READY, STATE_WAIT, STATE_ERROR = 1, 2, 3
	function ENT:Use(activator, caller)
		if (activator:IsPlayer() and activator:GetEyeTraceNoCursor().Entity == self) then
			local curTime = CurTime();
			if (self:GetState() == STATE_READY) then
				self:EmitSound("buttons/button1.wav", 100, 50)
				if (self:GetStock() == 0 or !activator:CanAfford(self.Price)) then
					self:ChangeState(STATE_ERROR, self:GetStock() == 0 and STATE_WAIT or STATE_READY);
				elseif (!activator.nextVendingMachine or curTime >= activator.nextVendingMachine) then
					if self.lastSpeach < CurTime() then
						timer.Simple(2, function() 
							self.lastSpeach = CurTime() + 15
							if self.actor then
								self.actor:PlayScene('scenes/trainyard/cit_water.vcd')
							end
						end)
					end
					self:CreateWater(activator);
					
					activator.nextVendingMachine = curTime + 300;
					
					activator:AddMoney(-self.Price);
				else
					self:ChangeState(STATE_ERROR, self:GetStock() == 0 and STATE_WAIT or STATE_READY);
				end;
			end
		end;
	end;

	hook('InitPostEntity', function()
		for k, v in pairs(rp.cfg.VendingMachinesNPC[game.GetMap()] or {}) do
			local ent = ents.Create('cw_vending_npc')
			ent:SetPos(v.Pos)
			ent:SetAngles(v.Ang)
			ent:Spawn()

			local npc = ents.Create('npc_actor')
			npc:SetPos(v.NPCPos)
			npc:SetAngles(v.NPCAng)
			npc:Spawn()

			ent.actor = npc

		end
	end)
end
