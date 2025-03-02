if (CLIENT) then
	local AfkTime = 0
	local PropsRemoved = false
	local DoorsSold = false
	local LastPos = Vector(0, 0, 0)

	timer.Create('afk_check', 1, 0, function()
		local multiplayer = math.Clamp((player.GetCount() / game.MaxPlayers()) * 4, 1, 3)
		local pl = LocalPlayer()
		if not IsValid(pl) then return end

		if (LastPos:DistToSqr(pl:GetPos()) <= 25) then
			AfkTime = (AfkTime + 1)
			local realAfkTime = AfkTime --* multiplayer

			if (realAfkTime >= rp.cfg.AfkDemote) and (pl:GetTeamTable().max > 0) then

				rp.RunCommand('spawn')
			elseif (realAfkTime >= rp.cfg.AfkPropRemove) and (not PropsRemoved) then
				rp.RunCommand('removeprops')
				PropsRemoved = true
			elseif (realAfkTime >= rp.cfg.AfkDoorSell) and (not DoorsSold) then
				rp.RunCommand('sellall')
				DoorsSold = true
			elseif realAfkTime > rp.cfg.AfkKick then
				--RunConsoleCommand('connect', info.AltServerIP)
			end
		else
			AfkTime = 0
			PropsRemoved = false
			DoorsSold = false
		end

		LastPos = LocalPlayer():GetPos()
	end)
elseif (SERVER) then
	rp.AddCommand('/spawn', function(pl)
		if ((pl.LastSuicide ~= nil) and pl.LastSuicide >= CurTime()) then
			pl:Notify(NOTIFY_ERROR, rp.Term('CantSuicideLiveFor'))
			return
		end
		pl.LastSuicide = CurTime() + 300
		
		pl:ChangeTeam(rp.GetDefaultTeam(pl), true)
		pl:KillSilent()
		if not pl:Alive() then
			pl:Spawn()
		end
	end)

	rp.AddCommand('/removeprops', function(pl)
		for k, v in ipairs(ents.GetAll()) do
			if (v:CPPIGetOwner() == pl) then
				v:Remove()
			end
		end
	end)
end