ENT.Type = "point"
ENT.Base = "base_point"
ENT.InputsOn = {}
ENT.InputsOff = {}
ENT.AdminOnly	= true
function ENT:Initialize()
	for k, v in pairs(rp.cfg.Lockdowns) do
		self.InputsOn["Start"..v.uid] = k
		self.InputsOff["End"..v.uid] = k
	end
end

function ENT:AcceptInput(name, activator, called, data)
	--if !activator:IsMayor() then return end
	if self.InputsOn[name] then
		GAMEMODE:Lockdown(activator, self.InputsOn[name])
	elseif nw.GetGlobal('lockdown') && self.InputsOff[name] then 
		GAMEMODE:UnLockdown(activator)
	end
end