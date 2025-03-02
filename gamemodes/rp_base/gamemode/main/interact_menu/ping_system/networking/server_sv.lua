util.AddNetworkString("PIS.PlacePing")
util.AddNetworkString("PIS.RemovePing")
util.AddNetworkString("PIS.ReactPing")

net.Receive("PIS.PlacePing", function(len, ply)
	if (!PIS.Gamemode:GetPingCondition()(ply)) then return end

	local tbl = net.ReadTable()
	local id = tbl.id
	local pos = tbl.pos
	local directedAt = tbl.directedAt

	if (IsValid(tbl.directedAt)) then
		if (!PIS.Gamemode:GetCommandCondition()(ply, tbl.directedAt)) then return end
	end

	PIS:AddPing(ply, id, pos, directedAt)

	net.Start("PIS.PlacePing")
		net.WriteTable({
			author = ply,
			id = id,
			pos = pos,
			directedAt = directedAt
		})
	net.Send(PIS.Gamemode:GetPlayers()(ply))
end)





net.Receive("PIS.RemovePing", function(len, ply)
	if (!PIS.Gamemode:GetPingCondition()(ply)) then return end

	local ping = PIS:GetPing(ply)

	if (ping) then
		PIS:RemovePing(ply)

		net.Start("PIS.RemovePing")
			net.WriteEntity(ply)
		-- Send it to everyone in-case
		net.Broadcast()
	end
end)

net.Receive("PIS.ReactPing", function(len, ply)
	if (!PIS.Gamemode:GetInteractionCondition()(ply)) then return end

	local command = net.ReadUInt(8)
	local ping = PIS:GetPing(pingId)

	if (ping) then
		local command = tbl.command
		if (!command) then return end

		if (command == PING_COMMAND_CONFIRM and ping.directedAt == ply) then
			ping.status = PING_STATUS_CONFIRMED

			net.Start("PIS.ReactPing")
				net.WriteTable({
					id = ply:SteamID64(),
					command = command
				})
			net.Send(PIS.Gamemode:GetPlayers()(ply))
		end
	end
end)



concommand.Add("do_arrest", function(ply, cmd, args)
	if not ply:IsCP() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term("UNotPolice"))
		return
	end

	local tr_ent = ply:GetEyeTrace().Entity
	if not IsValid(tr_ent) or not tr_ent:IsPlayer() then return end

	if tr_ent:IsCP() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term("UCantWithPolice"), translates.Get(tr_ent:IsArrested() and "выпустить из тюрьмы" or "арестовать"))
		return
	end

	if ply:GetPos():DistToSqr(tr_ent:GetPos()) > 6000 then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term("PlyTooFar"))
		return
	end

	if tr_ent:IsArrested() then
		tr_ent:UnArrest(ply)
		rp.Notify(tr_ent, NOTIFY_ERROR, rp.Term('UnarrestBatonTarg'), ply)
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('UnarrestBatonOwn'), tr_ent)
	else
		tr_ent:Arrest(ply)
		rp.Notify(tr_ent, NOTIFY_ERROR, rp.Term('ArrestBatonArrested'), ply)
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('ArrestBatonYouArrested'), tr_ent)
	end
end)


concommand.Add("do_wanted", function(ply, cmd, args)
	if not ply:IsCP() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term("UNotPolice"))
		return
	end
	
	local reason = args[1]
	if not reason or string.len(reason) < 1 then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term("NeedsWantedReason"))
		return
	end

	local tr_ent = args[2] and player.GetBySteamID(args[2]) or ply:GetEyeTrace().Entity
	if not IsValid(tr_ent) or not tr_ent:IsPlayer() then return end

	if ply:GetPos():DistToSqr(tr_ent:GetPos()) > 40000 then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term("PlyTooFar"))
		return
	end

	if tr_ent:IsCP() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term("UCantWithPolice"), translates.Get("объявить в розыск"))
		return
	end

	if not tr_ent:IsWanted() and not tr_ent:IsArrested() then
		tr_ent:Wanted(ply, reason)
	end
end)


concommand.Add("do_unwanted", function(ply, cmd, args)
	if not ply:IsCP() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term("UNotPolice"))
		return
	end
	
	local tr_ent = args[1] and player.GetBySteamID(args[1]) or ply:GetEyeTrace().Entity
	print('Unwant', tr_ent)
	if not IsValid(tr_ent) or not tr_ent:IsPlayer() then return end

	if ply:GetPos():DistToSqr(tr_ent:GetPos()) > 40000 then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term("PlyTooFar"))
		return
	end

	if tr_ent:IsWanted(ply:GetFaction()) then
		tr_ent:UnWanted(ply)
	end
end)