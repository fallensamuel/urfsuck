
local function process_expires(steamid, present_type, present_id)
	--print('PRESENT EXPIRE', steamid, present_type, present_id)
	
	if present_type == 0 then
		rp.JobsWhitelist.RemoveAccess(steamid, present_id)
		
	else
		local ply = player.GetBySteamID64(steamid)
		
		if IsValid(ply) then
			ply.PresentWeapons = ply.PresentWeapons or {}
			ply.PresentWeapons[present_id] = nil
		end
	end
end

hook.Add('InitPostEntity', 'Halloween:Init', function()
	rp._Stats:Query("CREATE TABLE IF NOT EXISTS `halloween_temp_presents` (`created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,`steamid` bigint(20) NOT NULL,`present_type` int(8) NOT NULL,`present_id` varchar(32) NOT NULL,`expire_time` bigint(20) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8;")
	
	timer.Simple(2, function()
		rp._Stats:Query("SELECT * FROM `halloween_temp_presents`;", function(data)
			rp._Stats:Query("DELETE FROM `halloween_temp_presents` WHERE `expire_time` < ?;", os.time())
			
			for k, v in pairs(data) do
				--print(tonumber(v.expire_time), os.time(), tonumber(v.expire_time) < os.time())
				
				if tonumber(v.expire_time) < os.time() then
					process_expires(v.steamid, tonumber(v.present_type), v.present_id)
				
				else
					if tonumber(v.present_type) == 1 then
						local ply = player.GetBySteamID64(v.steamid)
						
						if IsValid(ply) then
							ply.PresentWeapons = ply.PresentWeapons or {}
							ply.PresentWeapons[v.present_id] = true
							
							ply:Give(v.present_id)
						end
					end
					
					timer.Simple(tonumber(v.expire_time) - os.time(), function()
						rp._Stats:Query("DELETE FROM `halloween_temp_presents` WHERE `steamid` = ? AND `present_type` = ? AND `present_id` = ? AND `expire_time` = ?;", steamid, v.present_type, v.present_id, v.expire_time, function()
							process_expires(v.steamid, tonumber(v.present_type), v.present_id)
						end)
					end)
				end
			end
		end)
	end)
end)

hook.Add('PlayerAuthed', 'Halloween::LoadWeapons', function(ply)
	rp._Stats:Query("SELECT * FROM `halloween_temp_presents` WHERE `steamid` = ? AND `present_type` = 1;", ply:SteamID64(), function(data)
		if not IsValid(ply) then return end
		
		ply.PresentWeapons = ply.PresentWeapons or {}
		
		for k, v in pairs(data or {}) do
			ply.PresentWeapons[v.present_id] = true
			ply:Give(v.present_id)
		end
	end)
end)

hook.Add('PlayerLoadout', 'Halloween::GiveWeapons', function(ply)
	if IsValid(ply) and ply.PresentWeapons then
		for k, v in pairs(ply.PresentWeapons) do
			ply:Give(k)
		end
	end
end)


ba.cmd.Create("givetempjob", function(pl, args)
		if IsValid(pl) then return end
		local steamid = ba.InfoTo64(args.target)
		local exp_time = os.time() + args.time
		
		rp._Stats:Query("INSERT INTO `halloween_temp_presents`(`steamid`, `present_type`, `present_id`, `expire_time`) VALUES(?, 0, ?, ?);", steamid, args.job_id, exp_time, function()
			rp.JobsWhitelist.GiveAccess(steamid, args.job_id)
			
			--print('PRESENT GIVE', steamid, 0, args.job_id)
			
			timer.Simple(args.time, function()
				rp._Stats:Query("DELETE FROM `halloween_temp_presents` WHERE `steamid` = ? AND `present_type` = 0 AND `present_id` = ? AND `expire_time` = ?;", steamid, args.job_id, exp_time, function()
					process_expires(steamid, 0, args.job_id)
				end)
			end)
		end)
	end)
	:AddParam('player_steamid', 'target')
	:AddParam('string', 'job_id')
	:AddParam('time', 'time')
	:SetFlag('*')
	:SetHelp('Halloween event cmd job')
	
ba.cmd.Create("givetempweapon", function(pl, args)
		if IsValid(pl) then return end
		local steamid = ba.InfoTo64(args.target)
		local exp_time = os.time() + args.time
		
		rp._Stats:Query("INSERT INTO `halloween_temp_presents`(`steamid`, `present_type`, `present_id`, `expire_time`) VALUES(?, 1, ?, ?);", steamid, args.weapon, exp_time, function()
			
			local ply = player.GetBySteamID64(steamid)
			
			if IsValid(ply) then
				ply.PresentWeapons = ply.PresentWeapons or {}
				ply.PresentWeapons[args.weapon] = true
				
				ply:Give(args.weapon)
			end
			
			--print('PRESENT GIVE', steamid, 1, args.weapon)
			
			timer.Simple(args.time, function()
				rp._Stats:Query("DELETE FROM `halloween_temp_presents` WHERE `steamid` = ? AND `present_type` = 1 AND `present_id` = ? AND `expire_time` = ?;", steamid, args.weapon, exp_time, function()
					process_expires(steamid, 1, args.weapon)
				end)
			end)
		end)
	end)
	:AddParam('player_steamid', 'target')
	:AddParam('string', 'weapon')
	:AddParam('time', 'time')
	:SetFlag('*')
	:SetHelp('Halloween event cmd weapon')
