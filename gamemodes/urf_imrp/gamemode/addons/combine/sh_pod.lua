

hook.Add("CanPlayerEnterVehicle", function(ply, veh)
	if veh:GetModel() == "models/vehicles/prisoner_pod_inner.mdl" then
		return ply:IsOTA()
	end
end)

hook.Add('ZAPC_CheckAccess', function(ply, action, apc)
	return ply:IsCombinePilot()
end)