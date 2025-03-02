-- "gamemodes\\rp_base\\gamemode\\addons\\setfaction_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
ba.AddTerm('PlayerAlreadyInFaction', 'Player already is in faction. He must leave it first.')
ba.AddTerm('FactionNameIsIncorrect', 'Faction name is incorrect.')
ba.AddTerm('FactionRankCannotBeFound', 'Faction rank can not be found. Contact the dev!')
ba.AddTerm('FactionColorCannotBeFound', 'Faction color can not be found. Contact the dev!')
ba.AddTerm('PlayerNotInValidFaction', 'Player is not in valid faction!')
ba.AddTerm('FactionKick', '# kicked # out of his faction!')


local function timedRetry( ply )
	if not IsValid( ply ) then return end
	timer.Simple( FrameTime(), function() ply:ConCommand( "retry" ); end );
end


if rp.cfg.OrgFactions then
	ba.cmd.Create('SetFactionLeader', function(pl, args)
		local db = rp._Stats

		if args.target:GetOrg() then
			ba.notify_err(pl, ba.Term('PlayerAlreadyInFaction'))
			return
		end

		db:Query("SELECT * FROM org_rank WHERE Org=? ORDER BY Weight DESC LIMIT 1,1", args.faction_name, function(data)
			data = data[1]
			
			--PrintTable(data)

			if !(data && data.RankName) then
				ba.notify_err(pl, ba.Term('FactionRankCannotBeFound'))
				return
			end

			local steamid = args.target:SteamID64()

			if (not rp.orgs.cached[args.faction_name]) then
				rp.orgs.GetMembers( args.faction_name, function()
					rp.orgs.Join( steamid, args.faction_name, data.RankName, function() args.target:SetOrg( args.faction_name ); timedRetry( args.target ); end );
				end );
			else
				rp.orgs.Join( steamid, args.faction_name, data.RankName, function() args.target:SetOrg( args.faction_name ); timedRetry( args.target ); end );
			end
		end)
	end)
	:AddParam('player_entity', 'target')
	:AddParam('faction', 'faction_name')
	:SetFlag('x')
	:SetHelp('Makes player a faction leader')
	:SetIcon('icon16/user_go.png')

	ba.cmd.Create('SetFactionOwner', function(pl, args)
		local db = rp._Stats

		if args.target:GetOrg() then
			ba.notify_err(pl, ba.Term('PlayerAlreadyInFaction'))
			return
		end

		local steamid = args.target:SteamID64()

		if (not rp.orgs.cached[args.faction_name]) then
			rp.orgs.GetMembers(args.faction_name, function()
				rp.orgs.Join( steamid, args.faction_name, "Owner", function() args.target:SetOrg( args.faction_name ); timedRetry( args.target ); end )
			end)
		else
			rp.orgs.Join( steamid, args.faction_name, "Owner", function() args.target:SetOrg( args.faction_name ); timedRetry( args.target ); end )
		end
	end)
	:AddParam('player_entity', 'target')
	:AddParam('faction', 'faction_name')
	:SetFlag('x')
	:SetHelp('Makes player a faction owner')
	:SetIcon('icon16/user_go.png')

	ba.cmd.Create('UnsetFaction', function(pl, args)
		--if !(args.target:GetOrg() && faction[args.target:GetOrg()]) then
		if !(args.target:GetOrg() and rp.cfg.OrgFactions and rp.cfg.OrgFactions[args.target:GetOrg()]) then
			ba.notify_err(pl, ba.Term('PlayerNotInValidFaction'))
			return
		end

		ba.notify_err(pl, ba.Term('FactionKick'), pl, args.target)
		ba.notify_err(args.target, ba.Term('FactionKick'), pl, args.target)

		rp.orgs.Kick( args.target:SteamID64(), function() timedRetry( args.target ); end )
	end)
	:AddParam('player_entity', 'target')
	:SetFlag('x')
	:SetHelp('Forces a player to leave his faction')
	:SetIcon('icon16/user_go.png')
end


if SERVER then
	hook.Add('Initialize', function()
		--for k, v in pairs(faction) do
		for k, v in pairs(rp.cfg.OrgFactions or {}) do
			rp.orgs.GetMembers(k)
		end
	end)
end


ba.cmd.Param('faction')
	:Parse(function(self, pl, cmd, arg, opts)
		--if (not faction[arg]) then
		if not (rp.cfg.OrgFactions and rp.cfg.OrgFactions[arg]) then
			return false, 'Invalid faction!'
		end
		return true, arg
	end)
	:Complete(function(self, arg, opts)
		local ret = {}
		--for k, v in pairs(faction) do
		for k, v in pairs(rp.cfg.OrgFactions or {}) do
			if (arg ~= nil) and string.find(k:lower(), arg:lower()) then
				ret[#ret + 1] = k
			elseif (arg == nil) then
				ret[#ret + 1] = k
			end
		end
		return ret
	end)
	:Menu(function(self, parent, w, h, opts)
		local lbl = ui.Create('DLabel', function(self)
			self:SetPos(7.5, h + 1)
			self:SetText(ba.str.Capital(opts.Key) .. ':')
			self:SizeToContents()
		end, parent)

		local factions = ui.Create('DComboBox', function(self)
			self:SetSize(w - 85, 25)
			self:SetPos(80, h)
			--for k, v in pairs(faction) do
			for k, v in pairs(rp.cfg.OrgFactions or {}) do
				self:AddChoice(k)
			end
		end, parent)
		return factions, (h + factions:GetTall())
	end)