
local use = {}
use['+use'] = true
use['-use'] = true


local lastAction = 0
hook.Add('PlayerBindPress', 'rp.CombineBindPress', function(ply, bind)
	if lastAction < CurTime() then
		if use[bind] then
			local ent = ply:GetEyeTrace().Entity
			if IsValid(ent) and ent:GetClass() == 'func_door' and LocalPlayer():GetShootPos():DistToSqr(ply:GetEyeTrace().HitPos) <= 15000 and LocalPlayer():CanLockUnlock(ent) then
				net.Start("rp.CombineOpenDoor")
				net.SendToServer()
				lastAction = CurTime() + 0.3
				return true
			end
		end
	end
end)
