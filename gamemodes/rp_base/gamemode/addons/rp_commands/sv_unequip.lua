local function Equip(pl)
	if !pl:GetJobTable().canWear then return end
	if !pl.wear then return end
	if (pl:GetBodygroup(4) == 1 || pl:GetBodygroup(4) == 2) then return end

	pl:SetBodygroup(4, pl.wear)
	pl:SetBodygroup(1, 1)
	pl:SetBodygroup(3, 1)
	
	pl:Notify(NOTIFY_GREEN, rp.Term('WearUsed'))
end

local function Unequip(pl)
	if !pl:GetJobTable().canWear then return end
	--if !pl.wear then return end
	if pl:GetBodygroup(4) != 1 && pl:GetBodygroup(4) != 2 then return "" end

	pl.wear = pl:GetBodygroup(4)
	pl:UpdateAppearance()
	
	pl:Notify(NOTIFY_GREEN, rp.Term('WearReset'))
end

rp.AddCommand("/unequip", Unequip)
rp.AddCommand("/equip", Equip)

util.AddNetworkString("Mask.Equip")
util.AddNetworkString("Mask.Unequip")

net.Receive("Mask.Equip",function(len, ply)
	Equip(ply)
end)

net.Receive("Mask.Unequip",function(len, ply)
	Unequip(ply)
end)