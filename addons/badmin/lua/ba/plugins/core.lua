-------------------------------------------------
-- Setid
-------------------------------------------------
ba.AddTerm('SerevrIDSet', 'Server ID set to #')

ba.cmd.Create('SetID', function(pl, args)
	ba.svar.Set('sv_id', args.id)
	ba.notify(pl, ba.Term('SerevrIDSet'), args.id)
end)
:AddParam('string', 'id')
:SetFlag('*')
:SetHelp('Sets the server ID | Don\'t fuck with this one.')

-------------------------------------------------
-- Set Group
-------------------------------------------------
ba.AddTerm('SetRank', '# has set #\'s rank to # # #')

local ranks_nabor = {
	['superadmin*'] = true,
	['globaladmin*'] = true,
}

local ranks_can_give = {
	['user'] = true,
	['vip'] = true,
	['moderator*'] = true,
	['adminplus'] = true,
	['admin*'] = true,
}

local ranks_can_target = {
	['user'] = true,
	['vip'] = true,
	['premium'] = true,
	['admin'] = true,
	['moderator'] = true,
	['adminplus'] = true,
	['headadmin'] = true,
	['admin*'] = true,
	['moderator*'] = true,
	['headadmin*'] = true,
}

local function set_group(pl, args)
	if pl:IsPlayer() && ba.ranks.Get(args.old_rank).Immunity >= pl:GetImmunity() and !pl:IsRoot() then ba.notify(pl, ba.Term('SameWeight')) return end
	
	--if pl:IsPlayer() and not pl:IsRoot() and not ranks_can_give[args.rank] and not ranks_can_target[args.old_rank] then ba.notify(pl, ba.Term('SameWeight')) return end
	--if pl:IsPlayer() and not pl:IsRoot() and not (ranks_nabor[args.rank] or ranks_nabor[args.old_rank]) then ba.notify(pl, ba.Term('SameWeight')) return end
	
	if pl:IsPlayer() and not pl:IsRoot() and ranks_nabor[pl:GetRank()] then 
		if not ranks_can_give[args.rank] or not ranks_can_target[args.old_rank] then
			ba.notify(pl, ba.Term('SameWeight')) 
			return 
		end
	end
	
	if isentity(args.target) and IsValid(args.target) and args.rank == 'user' and (
	   args.target:HasUpgrade('vip') or 
	   args.target:HasUpgrade('VIP') or 
	   args.target:HasUpgrade('vip_package')) then
		args.rank = 'vip'
	end
	
	ba.data.SetRank(args.target, args.rank, (args.exp_rank or args.rank) , (args.exp_time and os.time() + args.exp_time or 0), function(data) 
		ba.logAction(pl, args.target, 'setgroup', args.rank)
		ba.notify_all(ba.Term('SetRank'), pl, args.target, args.rank, (args.exp_rank and 'expiring to ' .. args.exp_rank or ''), (args.exp_time and 'in ' .. args.raw.exp_time or ''))
	end)
end

ba.cmd.Create('SetGroup', function(pl, args)
	if args.exp_time and (not args.exp_rank) then
		ba.notify_err(pl, ba.Term('MissingArg'), 'exp_rank')
		return
	end
	
	if pl:IsPlayer() and not pl:IsRoot() and not ba.cmd.IsValidAmount(pl, 'setgroup') then return end

	if pl:IsPlayer() && ba.ranks.Get(args.rank).Immunity >= pl:GetImmunity() and !pl:IsRoot() then ba.notify(pl, ba.Term('SameWeight')) return end -- Был CantSetRankImmunity
	if pl:IsPlayer() && args.exp_rank && ba.ranks.Get(args.exp_rank).Immunity >= pl:GetImmunity() and !pl:IsRoot() then ba.notify(pl, ba.Term('SameWeight')) return end
	if pl:IsPlayer() && pl:GetImmunityGiveRank() && pl:GetImmunityGiveRank() != -1 && ba.ranks.Get(args.rank).Immunity > pl:GetImmunityGiveRank() and !pl:IsRoot() then ba.notify(pl, ba.Term('SameWeight')) return end
	
	if not isstring(args.target) and IsValid(args.target) and args.target:IsPlayer() then
		args.old_rank = args.target:GetRank()
		set_group(pl, args)
		
	elseif isstring(args.target) then
		local steamid = ba.InfoTo64(args.target)
		
		ba.data.GetDB():query_ex('SELECT `rank` FROM ba_ranks WHERE `steamid` = ?;', {steamid}, function(data)
			if data and data[1] then
				args.old_rank = ba.ranks.Get(data[1].rank).Name
				set_group(pl, args)
			end
		end)
	end
	
	/*
	if pl:IsPlayer() and not pl:IsRoot() and not ranks_can_give[args.rank] then ba.notify(pl, ba.Term('SameWeight')) return end

	ba.data.SetRank(args.target, args.rank, (args.exp_rank or args.rank) , (args.exp_time and os.time() + args.exp_time or 0), function(data) 
		ba.logAction(pl, args.target, 'setgroup', args.rank)
		ba.notify_all(ba.Term('SetRank'), pl, args.target, args.rank, (args.exp_rank and 'expiring to ' .. args.exp_rank or ''), (args.exp_time and 'in ' .. args.raw.exp_time or ''))
	end)
	*/
end)
:AddParam('player_steamid', 'target')
:AddParam('rank', 'rank')
:AddParam('time', 'exp_time', 'optional')
:AddParam('rank', 'exp_rank', 'optional')
:SetFlag('H')
:SetHelp('Sets a players rank')
:SetIcon('icon16/group.png')

-------------------------------------------------
-- Adminmode
-------------------------------------------------
ba.AddTerm('EnterAdminmode', '# включил Админмод.')
ba.AddTerm('ExitAdminmode', '# выключил Админмод.')

ba.cmd.Create('AdminMode', function(pl, args)
	if pl:GetBVar('adminmode') then
		ba.notify_staff(ba.Term('ExitAdminmode'), pl)
	else
		ba.notify_staff(ba.Term('EnterAdminmode'), pl)
	end
	pl:SetBVar('adminmode', not (pl:GetBVar('adminmode') or false))
end)
:SetFlag('A')
:SetHelp('Enables noclip and objects moving')

-------------------------------------------------
-- Help
-------------------------------------------------
ba.cmd.Create('Help')
:RunOnClient(function() -- ehhhhh
	local fr = ui.Create('ui_frame', function(self)
		self:SetSize(600, ScrH() * 0.5)
		self:SetTitle('Command help')
		self:Center()
		self:MakePopup()
	end)

	local cont = ui.Create('ui_scrollpanel', function(self, p)
		self:SetPos(5, 32)
		self:SetSize(p:GetWide() - 10, p:GetTall() - 37)
		self:SetPadding(-1)
		self:SetScrollSize(4)
	end, fr)

	for k, v in pairs(ba.cmd.GetTable()) do
		if LocalPlayer():HasFlag(v:GetFlag()) then
			local p = ui.Create('ui_panel')

			local l = ba.ui.Label(v:GetNiceName() .. ':', p, {font = 'ba.ui.22', color = ui.col.Close})
			l:SizeToContents()
			l:SetPos(26, 5)

			local h = l:GetTall()

			l = ba.ui.Label('Help: ' .. v:GetHelp(), p, {font = 'ba.ui.22', color = ui.col.Close})
			l:SizeToContents()
			l:SetPos(50, 25)

			h = h + l:GetTall()

			local a = ''
			for k, arg in ipairs(v:GetArgs()) do
				a = a .. arg.Key .. (k == #v:GetArgs() and '' or ', ')
			end

			if (#v:GetArgs() < 1) then
				a = 'No Args'
			else
				a = 'Args: ' .. a
			end

			l = ba.ui.Label(a, p, {font = 'ba.ui.22', color = ui.col.Close})
			l:SizeToContents()
			l:SetPos(50, 50)

			h = h + l:GetTall() + 10

			p:SetTall(h)

			local i = ui.Create('DImage', function(self)
				self:SetPos(5, 5)
				self:SetImage(v:GetIcon())
				self:SetSize(16,16)
			end, p)

			cont:AddItem(p)
		end
	end
end)
:SetHelp('Tells you helpful info about itself and other commands')