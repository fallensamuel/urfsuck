
if CLIENT then
	timer.Create('Stats:CheckFPS', 60, 0, function()
		if not IsValid(LocalPlayer()) or not LocalPlayer():IsAdmin() or not system.HasFocus() or not FPSBoost or not FPSBoost.SelectedCFG then return end
		local fps = AverageFPS and AverageFPS()
		if not fps or fps <= 0 then return end
		
		--print(fps, FPSBoost.SelectedCFG)
		
		net.Start('Stats:CheckFPS')
			net.WriteUInt(math.ceil(fps), 10)
			net.WriteUInt(FPSBoost.SelectedCFG, 10)
		net.SendToServer()
	end)
else
	util.AddNetworkString('Stats:CheckFPS')
	local queue = {}
	
	hook.Add("InitPostEntity", function()
		rp._Stats:Query("CREATE TABLE IF NOT EXISTS `fps_log` (`time` int(12) NOT NULL,`steamid` bigint(20) NOT NULL,`fps` int(12) NOT NULL,`fps_config` int(12) NOT NULL,`players` int(12) NOT NULL,`playtime` int(12) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;")
	end)
	
	net.Receive('Stats:CheckFPS', function(_, ply)
		if not IsValid(ply) then return end
		--print('[FPS]', os.time(), ply:SteamID64(), net.ReadUInt(10))
		
		table.insert(queue, "(" .. os.time() .. "," .. ply:SteamID64() .. "," .. net.ReadUInt(10) .. "," .. net.ReadUInt(10) .. "," .. player.GetCount() .. "," .. (CurTime() - (ply:GetNetVar('FirstJoined') or CurTime())) .. ")")
		--print(queue[#queue])
	end)
	
	timer.Create("FPSCheck::Deload", 60, 0, function()
		if #queue == 0 then return end
		
		local query = "INSERT INTO `fps_log` VALUES" .. table.concat(queue, ",") .. ";"
		--print(query)
		
		rp._Stats:Query(query)
		
		table.Empty(queue)
	end)
end	

