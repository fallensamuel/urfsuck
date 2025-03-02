rp.Capture = rp.Capture or {}

rp.Capture.Points = {}
rp.Capture.PointsMap = {}

rp.Capture.Alliances = {}
rp.Capture.AlliancesFactionMap = {}

rp.Capture.CAPTURE_POINT = 1

nw.Register'CapturePoints':Write(function()
	for k, v in pairs(rp.Capture.Points) do
		if v.isOrg then
			net.WriteString(v.owner or translates.Get('без владельца'))
		else
			net.WriteUInt(v.owner, 4)
		end
	end
end):Read(function()
	local owners = {}
	
	for k, v in pairs(rp.Capture.Points) do
		if v.isOrg then
			v.owner = net.ReadString()
		else
			v.owner = net.ReadUInt(4)
		end
		
		owners[k] = v.owner
	end
	
	return owners
end):SetGlobal()



function rp.Capture.AddAlliance(t)
	t.captured 	= 0
	t.conjes 	= {}
	t.conj_invalid = {}
	
	t.flagMaterial = t.flagMaterial or 'https://kianews24.ru/wp-content/uploads/2017/09/kotiki.jpeg'
	
	t.id = table.insert(rp.Capture.Alliances, t)

	for faction, _ in pairs(t.factions) do
		rp.Capture.AlliancesFactionMap[faction] = t.id
	end
	
	if not t.door_group then
		local facs = {}
		for k, v in pairs(t.factions) do
			table.insert(facs, k)
		end
		
		rp.AddDoorGroup(t.printName, rp.GetFactionTeams(facs))
		t.door_group = t.printName
	end
	
	return t.id
end


function rp.Capture.CalcMaxPoints(point, attacker)
	local defender = point.owner
	local i = 0
	
	for k, v in pairs(player.GetAll()) do
		if point.isOrg and (v:GetOrg() == attacker or v:GetOrg() == defender) or not point.isOrg and (v:GetAlliance() == attacker or v:GetAlliance() == defender) then
			i = i + 1
		end
	end
	return i
end

function rp.Capture.GetAllianceByName(name)
	for k, v in pairs(rp.Capture.Alliances) do
		if v.name == name then return v end
	end
end


rp.include('point_mt_sh.lua')
rp.include('player_mt_sh.lua')
rp.include('bonusbox_mt_sh.lua')

rp.include('captures/capture_mt_sh.lua')
rp.include('captures/capture_mt_sv.lua')

rp.include('captures/capture_sh.lua')
rp.include('captures/capture_sv.lua')
rp.include('captures/capture_cl.lua')
rp.include('captures/rewards_sv.lua')

rp.include('conjunctions/conj_sh.lua')
rp.include('conjunctions/conj_sv.lua')
rp.include('conjunctions/conj_cl.lua')
