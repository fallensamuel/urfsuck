
util.AddNetworkString('CapturePointData')
util.AddNetworkString('CapturePointEnded')
util.AddNetworkString('rp.Capture.GetActiveCaptures')

local IsValid 			= IsValid
local ents_FindInBox 	= ents.FindInBox
local timer 			= timer
local hook 				= hook


local function loadCapturePoints(mapStart)
	local owner
	
	rp._Stats:Query('SELECT Name FROM orgs', function(orgs)
		rp._Stats:Query('SELECT * FROM capture_data', function(data)
			local find = {}
			for k, v in pairs(data or {}) do
				if !rp.Capture.PointsMap[v.name] or find[v.name] then continue end
				find[v.name] = true
				
				if rp.Capture.PointsMap[v.name].isOrg then
					rp.Capture.PointsMap[v.name].owner = v.owner
				else
					owner = rp.Capture.GetAllianceByName(v.owner)
					if !owner then
						Error('Found unused alliance ' .. v.owner .. '. Get rid of it!')
						continue
					end

					rp.Capture.PointsMap[v.name].owner = owner.id
				end

				if mapStart then
					hook.Call('TerritoryOwnerChanged', nil, rp.Capture.PointsMap[v.name], rp.Capture.PointsMap[v.name].owner)
				end
			end

			for k, v in pairs(rp.Capture.PointsMap) do
				if !find[k] then
					if v.isOrg then
						owner = orgs[math.random(1, #orgs)].Name
						
						rp._Stats:Query('INSERT INTO capture_data VALUES("'..k..'", ?)', owner)
						v.owner = owner
					else
						owner = table.Random(rp.Capture.Alliances)
						
						rp._Stats:Query('INSERT INTO capture_data VALUES("'..k..'", ?)', owner.name)
						v.owner = owner.id
					end
					
					if mapStart then
						hook.Call('TerritoryOwnerChanged', nil, rp.Capture.PointsMap[v.name], rp.Capture.PointsMap[v.name].owner)
					end
				end

				hook.Call("PointOwnerChanged", nil, v.owner)
			end

			nw.SetGlobal('CapturePoints', true)
		end)
	end)
end

hook("InitPostEntity", function() loadCapturePoints(true) end)
hook("CapturePointsLoaded", function() loadCapturePoints() end)
loadCapturePoints()


function rp.Capture.NewCaptureAction(uid)
	local t = {}
	setmetatable(t, rp.meta.capture_action)
	
	t:SetScore(0)
	
	t.ID 	= table.insert(rp.Capture.ActiveCaptures, t)
	t.UID 	= uid
	
	rp.Capture.ActiveCapturesMap[uid] = t
	
	return t
end

function rp.Capture.RegisterCaptureAction(capture_mode, ...)
	local data = {...}
	local capture
	
	local point 	= data[1]
	local attacker 	= data[2]
	
	capture = rp.Capture.NewCaptureAction('p' .. point.id)
	capture.ActionMode = capture_mode
	
	capture:SetPoint(point)
	capture:SetAttacker(attacker)
	
	capture:SetIsOrg(point.isOrg)
	
	capture:SetMaxDuration(rp.cfg.CaptureDurationMax)
	
	capture.MaxScore = rp.Capture.CalcMaxPoints(point, attacker)
	
	capture:SetCaptureTime(-1)
	capture:SetScore(0)
	
	capture.numAttackers = 0
	capture.numDefenders = 0
	
	capture.State = 0
	
	timer.Create('CaptureVisitors_' .. capture.UID, 1, 0, function()
		local ents_f	= ents_FindInBox(point.box[1], point.box[2])
		local v 		= nil
		local scs 		= 0
		
		capture.numAttackers = 0
		capture.numDefenders = 0
		
		for i = 1, #ents_f do
			v = ents_f[i]
			
			if IsValid(v) and v:IsPlayer() and v:Alive() then
				if capture:IsPointAttacker(v) then
					scs = scs + 1
					capture.numAttackers = capture.numAttackers + 1
					
				elseif capture:IsPointDefender(v) then
					scs = scs - 1
					capture.numDefenders = capture.numDefenders + 1
				end
			end
		end
		
		if scs ~= capture:GetScore() then
			capture:SetScore(scs)
			capture:TransferScores()
		end
	end)
	
	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('CaptureStarted'), point.isOrg and attacker or not point.isOrg and rp.Capture.Alliances[attacker] and rp.Capture.Alliances[attacker].printName or translates.Get("Неизвестные"), point.printName, point.isOrg and capture:GetDefender() or not point.isOrg and rp.Capture.Alliances[capture:GetDefender()] and rp.Capture.Alliances[capture:GetDefender()].printName or translates.Get("Неизвестные"))
	
	capture:Start(rp.cfg.CaptureDurationMin)
end

function rp.Capture.StartPointCapture(point, ply)
	if not point then return end
	if (point.isOrg and not ply:OrgCanCapture()) or not ply:CanCapture() then return end
	
	local attacker = point.isOrg and ply:GetOrg() or not point.isOrg and ply:GetAlliance()
	local defender = point.owner
	
	if not attacker then return end
	
	--PrintTable(rp.Capture.IsBusy(attacker))
	
	if defender == attacker then 
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CantCaptureOwnTerritory')) 
		return 
	end
	
	if rp.Capture.IsPointBusy(point) then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('TooEarlyToCapture')) 
		return
	end
	
	local busy = rp.Capture.IsBusy(attacker) or defender and rp.Capture.IsBusy(defender)
	
	if busy and busy:GetEndingTime() < CurTime() then
		rp.Capture.ActiveCaptures[busy.ID] = nil
		busy = nil
	end
	
	if busy then 
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('NotYourTurnToCapture'), math.ceil(busy:GetEndingTime() - CurTime()))
		return 
	end
	
	if not point.isOrg and rp.ConjGet(attacker, defender) == CONJ_UNION then 
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ConjunctionCantCapture')) 
		return 
	end
	
	point.isWar = true
	
	rp.Capture.RegisterCaptureAction(rp.Capture.CAPTURE_POINT, point, attacker)
	
	if rp.ConjGet(attacker, defender) ~= CONJ_WAR then
		rp.ConjSet(attacker, defender, CONJ_WAR)
	end
end


rp.AddCommand("/givepoint", function(ply, text)
	text = string.Explode(' ', text)
	
	local point = rp.Capture.Points[tonumber(text[1])]
	
	if point.isWar or point.isOrg and not (ply:GetOrg() and ply:GetOrg() == point.owner and ply:GetOrgData().CanDiplomacy) or not point.isOrg and not (ply:GetAlliance() and ply:GetAlliance() == point.owner and ply:GetJobTable().canDiplomacy) then
		return
	end
	
	local to = point.isOrg and text[2] or rp.Capture.Alliances[tonumber(text[2])]
	
	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('PointWasGiven'), point.printName, point.isOrg and to or to.printName)
	
	rp._Stats:Query('UPDATE capture_data SET owner = "' .. (point.isOrg and to or to.name) .. '" WHERE name = "' .. point.name .. '"')
	
	hook.Call('PointOwnerChanged', nil, point.isOrg and to or to.id, point.owner)
	point.owner = point.isOrg and to or to.id
	
	--PrintTable(point)
	
	-- FLAG SETURL OWNERS
	point.flag_ent:SetURL(point.isOrg and 'ORG:' .. point.owner or to.org and 'ORG:' .. to.org or to.flagMaterial)
	point.flag_ent:SetFlagMaterial('')
	
	nw.SetGlobal('CapturePoints', true)
end)

rp.AddCommand("/capture", function(ply, text)
	local point = rp.Capture.Points[tonumber(text) or -1]
	if not IsValid(ply) or not point or not ply:InBox(point.box[1], point.box[2]) then return end
	
	rp.Capture.StartPointCapture(point, ply)
end)

rp.AddCommand("/setpointowner", function(ply, text)
	if !ply:IsRoot() then return end

	local v, current
	for i=1, #rp.Capture.Points do
		v = rp.Capture.Points[i].box
		if ply:InBox(v[1], v[2]) then
			current = rp.Capture.Points[i]
			break
		end
	end

	if !current then rp.Notify(ply, NOTIFY_ERROR, rp.Term('StayOnPointYouWishToCapture')) return end

	current.owner = tonumber(text)
	nw.SetGlobal('CapturePoints', true)
end)

local function CapturePointsPrepare(delay)
	local flag, box, color
	
	timer.Simple(delay or 5, function()
		for k, v in pairs(rp.Capture.Points) do
			if #v.Boxes > 0 then 
				for l, m in pairs(v.Boxes) do 
					box = ents.Create('ent_capture_bonuses')
					box:SetPos(m.pos + Vector(0, 0, 0))
					box:SetAngles(m.ang)
					box:Spawn()
					
					box:SetModel(m.model)
					
					box:SetCapturePoint(k)
					box:SetBoxId(l)
					
					m.entity = box
				end
			end
			
			if v.flag_pos then
				flag = ents.Create('ent_capture_flag')
				flag:SetPos(v.flag_pos + Vector(0, 0, 200))
				--flag:SetAngles(Angle(90, 0, 0))
				flag:Spawn()
				
				flag:SetCapturePoint(k)
				v.flag_ent = flag
				
				if v.owner then
					flag:SetURL(v.isOrg and 'ORG:' .. v.owner or rp.Capture.Alliances[v.owner].org and 'ORG:' .. rp.Capture.Alliances[v.owner].org or rp.Capture.Alliances[v.owner].flagMaterial)
					flag:SetFlagMaterial('')
				else
					flag:SetFlagMaterial('models/shiny')
				end
			end
		end
	end)
end

rp.CapturePointsReload = CapturePointsPrepare;
hook.Add('InitPostEntity', CapturePointsPrepare)

local function rearrangeCaptureEntities()
	timer.Simple(0, function()
		for k, v in pairs(ents.GetAll()) do
			if IsValid(v) then
				if v:GetClass() == 'ent_capture_bonuses' then
					if rp.Capture.Points[v:GetCapturePoint()] and rp.Capture.Points[v:GetCapturePoint()].Boxes[v:GetBoxId()] then
						rp.Capture.Points[v:GetCapturePoint()].Boxes[v:GetBoxId()].entity = v
					end
					
				elseif v:GetClass() == 'ent_capture_flag' and rp.Capture.Points[v:GetCapturePoint()] then
					rp.Capture.Points[v:GetCapturePoint()].flag_ent = v
				end
			end
		end
	end)
end
rearrangeCaptureEntities()


local sent_captures_on_ply_startup = {}
net.Receive('rp.Capture.GetActiveCaptures', function(_, ply)
	if sent_captures_on_ply_startup[ply] then return end
	
	sent_captures_on_ply_startup[ply] = true
	
	for k, v in pairs(rp.Capture.ActiveCaptures) do
		net.Start('CapturePointData')
			net.WriteString(v.UID)
			net.WriteBool(true)
			
			net.WriteUInt(v:GetActionMode(), 3)
			net.WriteBool(v:IsOrg())
			
			net.WriteString(v:GetAttacker() or '')
			net.WriteString(v:GetDefender() or '')
			
			net.WriteUInt(v:GetMaxScore(), 6)
			
			net.WriteBool(v.State == 0 and v.Score > 0 or v.State == 1 and v.Score < 0 or false)
			net.WriteFloat(v.PreviousProgress or 0)
			net.WriteFloat(v.PreviousTimeLeft and (CurTime() + v.PreviousTimeLeft) or -1)
			net.WriteFloat(v.EndingTime or 0)
		net.Send(ply)
	end
end)

hook.Add("PlayerDisconnected", "rp.Capture.PlayerDisconnected", function(ply)
	sent_captures_on_ply_startup[ply] = nil
end)