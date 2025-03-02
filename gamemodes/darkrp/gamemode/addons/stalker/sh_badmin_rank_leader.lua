-- "gamemodes\\darkrp\\gamemode\\addons\\stalker\\sh_badmin_rank_leader.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local db = rp._Stats

local rankName = 'Owner'

ba.cmd.Create('Set org leader', function(ply, args)
	local steamid 	= args.target
	local orgname	= args.orgname
	
	if not steamid or not orgname then 
		rp.Notify(ply, NOTIFY_ERROR, 'Wrong steamid or org name')
		return 
	end
	
	--if not (rp.cfg.OrgsAllowedToSpawn or {})[orgname] then
	--	rp.Notify(ply, NOTIFY_ERROR, 'You are not allowed to do this in org #', orgname)
	--	return
	--end
	
	rp.orgs.Exists(orgname, function(exists)
		if not exists then 
			rp.Notify(ply, NOTIFY_ERROR, 'Wrong org name')
			return 
		end
		
		local pl = player.GetBySteamID64(steamid)
		
		rp.orgs.GetMembers(orgname, function(mems, ranks)
			local found
			local rank
			
			for l, m in ipairs(ranks) do
				if m.Weight == 100 then
					rank = m
					break
				end
			end
					
			if not rank then return end
			
			for k, v in ipairs(mems) do
				if v.SteamID == steamid then
					if v.Rank == rank.RankName then
						rp.Notify(ply, NOTIFY_ERROR, 'Player (#) is already #', steamid, v.Rank)
						return
					end
					
					db:Query("UPDATE org_player SET Rank=? WHERE SteamID=?;", rank.RankName, steamid)
					
					local targ = rp.FindPlayer(args[1])
					if targ then
						local od = targ:GetOrgData()
						
						targ:SetOrgData({
							Rank 	= rank.RankName,
							MoTD 	= od.MoTD,
							Perms 	= {
								Weight 		= rank.Weight,
								Owner 		= (rank.Weight == 100),
								Invite 		= rank.Invite,
								Kick 		= rank.Kick,
								Rank 		= rank.Rank,
								MoTD 		= rank.MoTD,
								CanCapture 	= rank.CanCapture
							}
						})
						
						if IsValid(pl) then
							rp.Notify(targ, NOTIFY_GENERIC, rp.Term('OrgYourRank'), pl, rank.RankName)
							rp.Notify(pl, NOTIFY_GENERIC, rp.Term('OrgSetRank'), targ, rank.RankName)
						end
					else		
						if IsValid(pl) then			
							rp.Notify(pl, NOTIFY_GENERIC, rp.Term('OrgSetRank'), steamid, rank.RankName)
						end
					end
					
					rp.orgs.cached[orgname].Members[steamid].Rank = rank.RankName
					found = true
					break
				end
			end
			
			if not found then
				--rp.Notify(ply, NOTIFY_ERROR, 'Player (#) is not in org #', steamid, orgname)
				
				rp.orgs.Join(steamid, orgname, rank.RankName, function()
					if not IsValid(pl) then return end
						
					pl:SetOrg(orgname)
					local orgdata = {
						Rank = rank.RankName,
						MoTD = rank.MoTD,
						Perms = {
							Weight = rank.Weight,
							Owner = (rank.Weight == 100),
							Invite = rank.Invite,
							Kick = rank.Kick,
							Rank = rank.Rank,
							MoTD = rank.MoTD,
							CanCapture = rank.CanCapture
						}
					}
					
					pl:SetOrgData(orgdata)
					
					rp.orgs.cached[orgname].Members[steamid] = {
						SteamID = steamid,
						Org = orgname,
						Rank = rank.RankName
					}
					
					rp.Notify(rp.orgs.GetOnlineMembers(orgname), NOTIFY_GREEN, rp.Term('OrgMemberJoined'), pl, orgname)
					
					local invites = pl.OrgInvites or {}
					invites[orgname] = nil
				end)
			end
		end)
	end)
end)
:AddParam('string', 'target')
:AddParam('string', 'orgname')
:SetFlag('*')
:SetHelp('Sets player as org leader')
