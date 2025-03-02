local function CarEject(ply, _, args)
	local co = rp.FindPlayer(args[1])
	
	if(IsValid(co) and IsValid(co:GetVehicle())) then
		local v = co:GetVehicle():GetParent()
		
		if(IsValid(v) and v:IsDoor() and v:GetClass() == 'gmod_sent_vehicle_fphysics_base' and v:DoorGetOwner() == ply) then
			co:ExitVehicle()
			rp.Notify(co, NOTIFY_GENERIC, rp.Term('CarOwnerEjectedYou'), ply)
		end
	end
end
rp.AddCommand("/eject", CarEject)
