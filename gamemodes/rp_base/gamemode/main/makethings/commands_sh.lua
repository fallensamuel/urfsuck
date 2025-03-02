-- "gamemodes\\rp_base\\gamemode\\main\\makethings\\commands_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
-----------------------------------------------------------
-- TOGGLE COMMANDS --
-----------------------------------------------------------
if CLIENT then
	local net = net
	local CurDrawingEnt

	local function draw_employer_npc(npc_data)
		if CurDrawingEnt and CurDrawingEnt.IsClientside then
			CurDrawingEnt:Remove()
		end

		CurDrawingEnt = nil

		local pos = npc_data[1]
		local ang = npc_data[2]
		local model = npc_data[3]

		CurDrawingEnt = ClientsideModel( model )
		CurDrawingEnt.AutomaticFrameAdvance = true
		CurDrawingEnt.IsClientside = true
		CurDrawingEnt:SetPos( pos or Vector(0, 0, 0) )
		CurDrawingEnt:SetAngles( ang or Angle(0, 0, 0) )
		CurDrawingEnt:SetRenderMode( RENDERMODE_TRANSCOLOR )
		CurDrawingEnt:SetColor( Color(0, 0, 0, 0) )
		CurDrawingEnt.ParentEntIndex = ent_ind
        CurDrawingEnt:ResetSequence( "idle_all_01" )
		CurDrawingEnt:Spawn()

		CurDrawingEnt.HaloColor = npc_data[4] or Color(255, 255, 255)
		CurDrawingEnt.HaloMaterial = Material(npc_data[5] or "rpui/standart.png", "smooth noclamp")

		rp.Notify(NOTIFY_GREEN, translates.Get("Ближайший NPC профессий был подсвечен"))
	end

	local halo_mat = Material("rpui/halo_guy.png", "smooth noclamp")

	local cam_Start3D2D = cam.Start3D2D
	local cam_End3D2D = cam.End3D2D
	local surface_SetDrawColor = surface.SetDrawColor
	local surface_SetMaterial = surface.SetMaterial
	local surface_DrawTexturedRect = surface.DrawTexturedRect
	local ColorAlpha = ColorAlpha
	local Angle = Angle
	local math_Clamp = math.Clamp

	local dist, screenPos, size

	hook.Add("HUDPaint", "Base::Employer::HaloRenderer", function()
		if IsValid(CurDrawingEnt) then
			dist = CurDrawingEnt:GetPos():Distance(LocalPlayer():GetPos())
			screenPos = CurDrawingEnt:GetPos():ToScreen()
			size = 100 * 505 / dist

			surface_SetDrawColor(ColorAlpha(CurDrawingEnt.HaloColor, math_Clamp((dist - 200) * 0.05, 0, 236)))
			surface_SetMaterial(halo_mat)
			surface_DrawTexturedRect(screenPos.x - size * 0.5, screenPos.y - size * 0.9, size, size)

			if dist < 250 then
				if CurDrawingEnt.IsClientside then
					CurDrawingEnt:Remove()
				end

				CurDrawingEnt = nil

			else
				if not CurDrawingEnt.offsetz then
					CurDrawingEnt.offset_z = select( 2, CurDrawingEnt:GetModelRenderBounds() ).z;
				end

				rp.DrawInfoBubbleTexture(
					100,
					CurDrawingEnt.HaloMaterial,
					nil,
					nil,
					CurDrawingEnt.HaloColor,
					false,
					nil,
					nil,
					CurDrawingEnt:LocalToWorld( CurDrawingEnt:GetUp() * CurDrawingEnt.offset_z ):ToScreen(),
					nil,
					nil,
					false,
					true
				)
			end
		end
	end)

	function rp.ChangeTeam(team, only_show)
		CurDrawingEnt = nil

		if only_show and not rp.cfg.EnableF4Jobs then
			local CTeam = rp.teams[team]

			if not CTeam.faction then
				net.Start('rp.ChangeTeam')
					net.WriteInt(team, 11)
				net.SendToServer()

				return
			end

			local closest_nps
			local closest_dist

			local ply_pos = LocalPlayer():GetPos()
			local cur_dist

			local fact_npcs = rp.GetFactionNPCs(CTeam.faction) or {}

			for k, v in pairs(fact_npcs) do
				cur_dist = v[1]:DistToSqr(ply_pos)

				if not closest_nps or cur_dist < closest_dist then
					closest_nps = v
					closest_dist = cur_dist
				end
			end

			if not closest_nps then
				net.Start('rp.ChangeTeam')
					net.WriteInt(team, 11)
				net.SendToServer()

				return
			end

			draw_employer_npc(closest_nps)

		else
			net.Start('rp.ChangeTeam')
				net.WriteInt(team, 11)
			net.SendToServer()
		end
	end
else
	util.AddNetworkString('rp.ChangeTeam')
	net.Receive('rp.ChangeTeam', function(len, ply)
		if ply:IsBanned() then return end
		local k = net.ReadInt(11)
		if !k then return end
		local CTeam = rp.teams[k]
		if !CTeam then return end
		if not GAMEMODE:CustomObjFitsMap(CTeam) then return end

		if CTeam.faction and not rp.IsValidFactionChange(ply, CTeam.faction) then
			--if not ply.UsedEmployer then
				--ba.bans.Ban(ply, '[Anticheat] Team abuse', 600)

			--else
				rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotChangeJob'), translates.Get('дальней дистанции от NPC'))
			--end

			return
		end

		timer.Simple(0, function()
			if not ply:IsValid() then return end
			ply.UsedEmployer = nil
		end)

		if CTeam.vote then
			if (#player.GetAll() == 1) then
				rp.Notify(ply, NOTIFY_GREEN, rp.Term('VoteAlone'))
				ply:ChangeTeam(k)

				return ""
			end

			-- Banned from job
			if (not ply:ChangeAllowed(k)) then
				rp.Notify(ply, NOTIFY_ERROR, rp.Term('BannedFromJob'))

				return ""
			end

			-- Voted too recently
			if (ply:GetTable().LastVoteTime and CurTime() - ply:GetTable().LastVoteTime < 80) then
				rp.Notify(ply, NOTIFY_ERROR, rp.Term('VotedTooSoon'), math.ceil(80 - (CurTime() - ply:GetTable().LastVoteTime)))

				return
			end

			-- Can't vote to become what you already are
			if (ply:Team() == k) then
				rp.Notify(ply, NOTIFY_GENERIC, rp.Term('AlreadyThisJob'))

				return
			end

			-- Max players reached
			local max = CTeam.max

			if (max ~= 0 and ((max % 1 == 0 and team.NumNonAfkPlayers(k) >= max) or (max % 1 ~= 0 and (team.NumNonAfkPlayers(k) + 1) / #player.GetAll() > max))) then
				rp.Notify(ply, NOTIFY_ERROR, rp.Term('JobLimit'))

				return
			end

			if (CTeam.CurVote) then
				if (not CTeam.CurVote.InProgress) then
					table.insert(CTeam.CurVote.Players, ply)
					rp.Notify(ply, NOTIFY_GREEN, rp.Term('RegisteredForVote'))
				else
					rp.Notify(ply, NOTIFY_ERROR, rp.Term('AlreadyVoting'))

					return
				end
			else
				-- Setup a new vote
				CTeam.CurVote = {
					InProgress = false,
					Players = {ply}
				}

				rp.teamVote.CountDown(CTeam.name, 45, function()
					CTeam.CurVote.InProgress = true

					rp.teamVote.Create(CTeam.name, 45, CTeam.CurVote.Players, function(winner, breakdown)
						if (not winner or team.NumNonAfkPlayers(k) >= max) then
							rp.GlobalChat(CHAT_NONE, rp.col.White, 'No winner for the ', CTeam.color, CTeam.name, rp.col.White, ' vote!')
						else
							rp.GlobalChat(CHAT_NONE, CTeam.color, winner:Name(), rp.col.White, translates.Get(' has won the vote for %s!', CTeam.name))
							winner:ChangeTeam(k)
						end

						CTeam.CurVote = nil
					end)
				end)

				rp.Notify(ply, NOTIFY_GREEN, rp.Term('RegisteredForVote'))
			end

			ply:GetTable().LastVoteTime = CurTime()
		else
			if CTeam.admin == 1 and not ply:IsAdmin() then
				rp.Notify(ply, NOTIFY_ERROR, rp.Term('JobNeedsAdmin'))
				return
			end

			if CTeam.admin > 1 and not ba.IsSuperAdmin(ply) then
				rp.Notify(ply, NOTIFY_ERROR, rp.Term('JobNeedsSA'))
				return
			end

			if !ply:CanTeam(CTeam) then
				return false
			end

			ply:ChangeTeam(k)
		end
	end)
end

function GM:AddEntityCommands(tblEnt)
	if CLIENT then return end

	local function buythis(ply, args)
		if ply:IsArrested() then return "" end

		if table.Count(tblEnt.allowed) > 0 and tblEnt.allowed[ply:Team()] != true and not table.HasValue(tblEnt.allowed, ply:Team()) then
			rp.Notify(ply, NOTIFY_ERROR, rp.Term('IncorrectJob'))

			return ""
		end

		if tblEnt.customCheck and not tblEnt.customCheck(ply) then
			if tblEnt.customCheckFailMsg then
				if isfunction(tblEnt.customCheckFailMsg) then
					rp.Notify(ply, NOTIFY_ERROR, tblEnt.customCheckFailMsg())
				else
					rp.Notify(ply, NOTIFY_ERROR, tblEnt.customCheckFailMsg)
				end
			else
				rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotPurchaseItem'))
			end

			return ""
		end

		if tblEnt.unlockTime && tblEnt.unlockTime > ply:GetPlayTime() then
			rp.Notify(ply, NOTIFY_ERROR, rp.Term('NotEnoughTime'))
			return
		end

		local max = tonumber(tblEnt.max or 3)

		if ply:GetCount(tblEnt.ent) >= tonumber(max) then
			rp.Notify(ply, NOTIFY_ERROR, rp.Term('ItemLimit'), tblEnt.name)

			return ""
		end

		local discounted_price;
		discounted_price = ply.GetAttributeAmount and (ply:GetAttributeAmount('trader') and math.ceil(tblEnt.price * (1 - ply:GetAttributeAmount('trader') / 100)) or ply:GetAttributeAmount('italiane') and math.ceil(tblEnt.price * (1 - (0.25 * ply:GetAttributeAmount('italiane') / 100)))) or tblEnt.price

		if not ply:CanAfford(discounted_price) then
			rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotAfford'))

			return ""
		end


		ply:AddMoney(-discounted_price)
		local trace = {}
		trace.start = ply:EyePos()
		trace.endpos = trace.start + ply:GetAimVector() * 85
		trace.filter = ply
		local tr = util.TraceLine(trace)
		local item = ents.Create(tblEnt.ent)
		item:SetPos(tr.HitPos)
		item.allowed = tblEnt.allowed
		item.ItemOwner = ply
		item:Spawn()
		item:PhysWake()

		timer.Simple(0, function()
			if item.Setowning_ent then
				item:Setowning_ent(ply)
			end

			if (tblEnt.onSpawn) then
				tblEnt.onSpawn(item, ply)
			end
		end)

		rp.Notify(ply, NOTIFY_GREEN, rp.Term('RPItemBought'), tblEnt.name, rp.FormatMoney(discounted_price))
		hook.Call('PlayerBoughtItem', GAMEMODE, ply, tblEnt.name, discounted_price, ply:GetMoney(), item)
		ply:_AddCount(tblEnt.ent, item)

		return ""
	end

	rp.AddCommand(tblEnt.cmd, buythis)
end

if SERVER then
	rp.AddCommand('/copbuy', function(pl, text, args)
		if (not args[1]) or (not (pl:IsCP() or pl:IsMayor())) then return end
		local exploiter = true

		for k, v in ipairs(ents.FindInSphere(pl:GetPos(), 200)) do
			if IsValid(v) and (v:GetClass() == 'npc_copshop') then
				exploiter = false
				break
			end
		end

		if exploiter then return end
		local item = rp.CopItems[args[1]]

		if not pl:CanAfford(item.Price) then
			pl:Notify(NOTIFY_ERROR, rp.Term('CannotAfford'))
		else
			pl:Notify(NOTIFY_GENERIC, rp.Term('RPItemBought'), item.Name, rp.FormatMoney(item.Price))
			pl:TakeMoney(item.Price)

			if item.Weapon then
				pl:Give(item.Weapon)
			else
				item.Callback(pl)
			end
		end
	end)
end
