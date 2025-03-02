rp.orgs = rp.orgs or {}

function PLAYER:GetOrg()
	return self:GetNetVar('Org')
end

function PLAYER:GetOrgData()
	return self:GetNetVar('OrgData')
end

function PLAYER:GetOrgColor()
	local c = self:GetNetVar('OrgColor')

	return (c and Color(c.r, c.g, c.b) or Color(255, 255, 255))
end

rp.orgs.BaseData = {
	['Owner'] = {
		Rank = 'Owner',
		Perms = {
			Weight = 100,
			Owner = true,
			Invite = true,
			Kick = true,
			Rank = true,
			MoTD = true, 
			CanCapture = true, 
			CanDiplomacy = true
		}
	}
}

function rp.orgs.GetOnlineMembers(org)
	return table.Filter(player.GetAll(), function(pl) return (pl:GetOrg() == org) end)
end

-- Networking
nw.Register'Org':Write(net.WriteString):Read(net.ReadString):SetPlayer()

nw.Register'OrgColor':Write(function(v)
	net.WriteUInt(v.r, 8)
	net.WriteUInt(v.g, 8)
	net.WriteUInt(v.b, 8)
end):Read(function() return Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8)) end):SetPlayer()

nw.Register'OrgData':Write(function(v)
	net.WriteString(v.Rank)
	net.WriteString(v.MoTD)
	net.WriteUInt(v.Perms.Weight, 7)
	net.WriteBool(v.Perms.Owner)
	net.WriteBool(v.Perms.Invite)
	net.WriteBool(v.Perms.Kick)
	net.WriteBool(v.Perms.Rank)
	net.WriteBool(v.Perms.MoTD)
	net.WriteBool(v.Perms.CanCapture)
	net.WriteBool(v.Perms.CanDiplomacy)
end):Read(function()
	return {
		Rank = net.ReadString(),
		MoTD = net.ReadString(),
		Perms = {
			Weight = net.ReadUInt(7),
			Owner = net.ReadBool(),
			Invite = net.ReadBool(),
			Kick = net.ReadBool(),
			Rank = net.ReadBool(),
			MoTD = net.ReadBool(),
			CanCapture = net.ReadBool(), 
			CanDiplomacy = net.ReadBool()
		}
	}
end):SetLocalPlayer()

local function get_org_detailed(org_name, cback)
	rp._Stats:Query('SELECT t1.RankName, t1.Weight, COUNT(t2.SteamID) as ct FROM `org_rank` t1 LEFT JOIN `org_player` t2 ON t1.Org = t2.Org AND t1.RankName = t2.Rank WHERE t1.Org = ? GROUP BY t1.RankName, t1.Weight ORDER BY t1.Weight;', org_name, function(data)
		if data then
			cback(data)
			
		else
			cback({})
		end
	end)
end

local cooldowns = {}
ba.cmd.Create('Org Info', function(pl, args)
	local org_name = args.target
	
	if not org_name then
		return
	end
	
	get_org_detailed(org_name, function(orginfo)
		if table.Count(orginfo) == 0 then
			if not IsValid(pl) then 
				print('====================')
				print('Организации ' .. org_name .. ' не существует!')
				print('====================')
				
			else
				net.Start('ba.getorg.info')
					net.WriteBool(false)
					net.WriteBool(false)
					net.WriteString(org_name)
				net.Send(pl)
			end
			
		else
			if not IsValid(pl) then 
				print('====================')
				print('Ранги организации ' .. org_name .. ':')
				print('')
				
				for k, v in pairs(orginfo) do
					print(v.RankName .. ': значимость ' .. v.Weight .. ', ' .. v.ct .. ' участник(ов)')
				end
				
				print('====================')
				
			else
				net.Start('ba.getorg.info')
					net.WriteBool(false)
					net.WriteBool(true)
					net.WriteString(org_name)
					
					net.WriteUInt(table.Count(orginfo), 7)
					
					for k, v in pairs(orginfo) do
						net.WriteString(v.RankName)
						net.WriteUInt(v.Weight, 7)
						net.WriteUInt(v.ct, 10)
					end
				net.Send(pl)
			end
		end
	end)
end)
:AddParam('string', 'target')
:SetFlag('*')
:SetHelp('Gets org info')

ba.cmd.Create('Get Org', function(pl, args)
	local steamid = ba.InfoTo64(args.target)
	
	if IsValid(pl) then
		if cooldowns[pl:SteamID()] and cooldowns[pl:SteamID()] > CurTime() then
			return rp.Notify(pl, NOTIFY_ERROR, rp.Term('DontUseCommandsSoFast'))
		end
		
		cooldowns[pl:SteamID()] = CurTime() + 3
	end
	
	rp._Stats:Query('SELECT * FROM `org_player` WHERE `SteamID` = ?;', steamid, function(data)
		if data and data[1] then
			get_org_detailed(data[1].Org, function(orginfo)
				if not IsValid(pl) then 
					print('====================')
					print(steamid .. ' состоит в организации "' .. data[1].Org .. '", ранг "' .. data[1].Rank .. '"')
					print('====================')
					print('Ранги организации ' .. data[1].Org .. ':')
					print('')
					
					for k, v in pairs(orginfo) do
						print(v.RankName .. ': значимость ' .. v.Weight .. ', ' .. v.ct .. ' участник(ов)')
					end
					
					print('====================')
					return
				end
				
				net.Start('ba.getorg.info')
					net.WriteBool(true)
					net.WriteBool(true)
					net.WriteString(steamid)
					net.WriteString(data[1].Org)
					net.WriteString(data[1].Rank)
					
					net.WriteUInt(table.Count(orginfo), 7)
					
					for k, v in pairs(orginfo) do
						net.WriteString(v.RankName)
						net.WriteUInt(v.Weight, 7)
						net.WriteUInt(v.ct, 10)
					end
				net.Send(pl)
			end)
		else
			if not IsValid(pl) then 
				print('====================')
				print(steamid .. ' не состоит в организации')
				print('====================')
				
				return
			end
			
			net.Start('ba.getorg.info')
				net.WriteBool(true)
				net.WriteBool(false)
				net.WriteString(steamid)
			net.Send(pl)
		end
	end)
end)
:AddParam('player_steamid', 'target')
:SetFlag('*')
:SetHelp('Gets players org info')

if SERVER then
	util.AddNetworkString('ba.getorg.info')
	
else
	local divider_color = Color(100, 100, 100)
	local system_color = Color(255, 255, 255)
	local found_text_color = Color(100, 190, 255)
	local not_found_text_color = Color(255, 125, 35)
	
	net.Receive('ba.getorg.info', function()
		local with_player = net.ReadBool()
		local state = net.ReadBool()
		
		if with_player then
			local steamid = net.ReadString()
			
			if state then
				local org_name = net.ReadString()
				
				MsgC(divider_color, '====================\n', found_text_color, steamid .. '', system_color, ' состоит в организации "', found_text_color, org_name, system_color, '", ранг "', found_text_color, net.ReadString(), system_color, '"\n', divider_color, '====================\n', system_color, 'Ранги организации ', found_text_color, org_name, system_color, ':\n\n')
				
				for i = 1, net.ReadUInt(7) do
					MsgC(found_text_color, net.ReadString(), system_color, ': значимость ', found_text_color, net.ReadUInt(7) .. '', system_color, ', ', found_text_color, net.ReadUInt(10) .. '', system_color, ' участник(ов)\n')
				end
				
				MsgC(divider_color, '====================\n')
				
			else
				MsgC(divider_color, '====================\n', not_found_text_color, steamid .. '', system_color, ' не состоит в организации\n', divider_color, '====================\n')
			end
			
		else
			local org_name = net.ReadString()
			
			if state then
				MsgC(divider_color, '====================\n', system_color, 'Ранги организации ', found_text_color, org_name, system_color, ':\n\n')
				
				for i = 1, net.ReadUInt(7) do
					MsgC(found_text_color, net.ReadString(), system_color, ': значимость ', found_text_color, net.ReadUInt(7) .. '', system_color, ', ', found_text_color, net.ReadUInt(10) .. '', system_color, ' участник(ов)\n')
				end
				
				MsgC(divider_color, '====================\n')
				
			else
				MsgC(divider_color, '====================\n', system_color, 'Организации ', not_found_text_color, org_name, system_color, ' не существует\n', divider_color, '====================\n')
			end
		end
	end)
end