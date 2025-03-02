
local disguise_team = TEAM_CITIZEN or rp.DefaultTeam or 1
local disguise_rank = 'Admin'

local function setName(self, name, firstRun)
	name = string.Trim(name)
	name = string.sub(name, 1, 20)

	local lowername = string.lower(tostring(name))
	
	rp.data.GetNameCount(name, function(taken)
		if string.len(lowername) < 2 and not firstrun then return end
		if taken then
			if firstRun then
				self:SetRPName(name .. "1", firstRun)
			else
				return ""
			end
		else	
			rp.data.SetName(self, name)
		end
	end)
end

local function setRank(self, rank)
	rank = ba.ranks.Get(rank)
	
	if rank:GetID() == 1 then
		self:SetNetVar('UserGroup', nil)
	else
		self:SetNetVar('UserGroup', rank:GetID())
	end
end

ba.cmd.Create('Disguise', function(pl)
	pl.undisguise_team = pl:Team()
	pl.undisguise_nick = pl:Nick()
	pl.undisguise_rank = pl:GetRank()
	
	pl:SetTeam(disguise_team)
	setName(pl, rp.names.Random(), true)
	setRank(pl, disguise_rank)
end)
:SetFlag('*')
:SetHelp('Disguises you as an admin')

ba.cmd.Create('Undisguise', function(pl)
	if not pl.undisguise_team then return end
	
	pl:SetTeam(pl.undisguise_team)
	setName(pl, pl.undisguise_nick)
	setRank(pl, pl.undisguise_rank)
	
	pl.undisguise_team = nil
	pl.undisguise_nick = nil
	pl.undisguise_rank = nil
end)
:SetFlag('*')
:SetHelp('Undisguises you after ba disguise')