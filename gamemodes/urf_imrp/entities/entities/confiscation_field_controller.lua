ENT.Type = "point"
ENT.Base = "base_point"
ENT.Category = "Half-Life Alyx RP"

function ENT:AcceptInput(name, activator, called, data)
	print(name, activator, called, data)
	for k,v in pairs(ents.FindInSphere(self:GetPos(), 70)) do
		if IsValid(v) and v:IsPlayer() and v:Alive() then
			local playerWeapons = v:GetWeapons()
			for c,d in pairs(playerWeapons) do
				if d.CW20Weapon or d.SWBWeapon or d.IsFAS2Weapon then
					v:StripWeapon(d:GetClass())
				end
			end
		end
	end
end