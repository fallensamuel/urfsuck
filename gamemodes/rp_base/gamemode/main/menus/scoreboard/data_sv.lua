if CLIENT then return end
local PMETA = FindMetaTable("Player")

util.AddNetworkString("rp.ScoreboardStats")

net('rp.ScoreboardStats', function(len, pl)
	if (not pl:GetNetVar('OS')) and (not pl:GetNetVar('Country')) then
		local cc = net.ReadString()
		local o = net.ReadUInt(2)

		if (o ~= 1) then
			pl:SetNetVar('OS', o)
		end

		if (cc ~= 'RU') then
			pl:SetNetVar('Country', cc)
		end
	end
end)

hook('PlayerEntityCreated', 'sui', function(pl)
	net.Start('rp.ScoreboardStats')
	net.WriteString(pl:NiceIP())
	net.Send(pl)
end)

util.AddNetworkString("rp.ScoreboardReact")

local function process_react(ply, target)
	if not IsValid(target) or not IsValid(ply) then return end	
	
	local ply_sid = ply:SteamID64()
	local tar_sid = target:SteamID64()
	
	if target.processing_react and target.processing_react[ply_sid] then return end
	
	target.processing_react = target.processing_react or {}
	target.processing_react[ply_sid] = true
	
	
	rp.syncHours.db:Query("SELECT 1 as exist FROM player_reacts WHERE steamid_from = ? AND steamid_to = ?;", ply_sid, tar_sid, function(data)
		if not data then 
			if IsValid(target) and target.processing_react then
				target.processing_react[ply_sid] = nil
			end
			
			return
		end
		
		if data[1] and tonumber(data[1].exist) == 1 then
			rp.syncHours.db:Query("DELETE FROM player_reacts WHERE steamid_from = ? AND steamid_to = ?;", ply_sid, tar_sid, function()
				if not IsValid(target) then return end
				
				target.processing_react[ply_sid] = nil
				
				if IsValid(ply) then
					rp.Notify(ply, NOTIFY_GENERIC, rp.Term('ScoreboardReactUnset'), target:Nick())
				end
				
				net.Start("rp.ScoreboardReact")
				net.WriteBool(false)
				net.WriteEntity(ply)
				net.Send(target)
			end)
		else
			rp.syncHours.db:Query("INSERT INTO player_reacts VALUES(?, ?);", ply_sid, tar_sid, function()
				if not IsValid(target) then return end
				
				target.processing_react[ply_sid] = nil
				
				if IsValid(ply) then
					rp.Notify(ply, NOTIFY_GREEN, rp.Term('ScoreboardReactSet'), target:Nick())
					rp.Notify(target, NOTIFY_GREEN, rp.Term('ScoreboardReacted'), ply:Nick())
				end
				
				net.Start("rp.ScoreboardReact")
				net.WriteBool(true)
				net.WriteEntity(ply)
				net.Send(target)
			end)
		end
	end, function()
		if IsValid(target) and target.processing_react then
			target.processing_react[ply_sid] = nil
		end
	end)
end

concommand.Add("like_react", function(ply, cmd, args)
	if not args then return end 
	
	if (ply.ReactDelay or 0) > CurTime() then return end
	ply.ReactDelay = CurTime() + 0.45

	local sid64 = args[1]

	if sid64 == ply:SteamID64() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ScoreboardReactMyself'))
		return 
	end

	local target = player.GetBySteamID64(sid64)
	
	if not IsValid(target) then return end
	process_react(ply, target)
end)