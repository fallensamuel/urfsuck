
local function getCurCapture()
	return LocalPlayer().current_capture
end

local tr = translates
local cached = {
	tr.Get( 'без владельца' ), 
	tr.Get( 'к зарплате' ), 
	tr.Get( 'к здоровью' ), 
	tr.Get( 'к скорости' ), 
	tr.Get( 'к броне' ), 
	tr.Get( 'доп. боеприпасы' ), 
	tr.Get( 'отсутсвует голод' ), 
	tr.Get( 'доп. техника' ), 
	tr.Get( 'переезд' ), 
	tr.Get( 'Оружие' ), 
	tr.Get( 'Неизвестно' )
}

function rp.Capture.GetCurrentCapture()
	if getCurCapture() and #rp.Capture.ActiveCaptures == 0 then
		LocalPlayer().current_capture = nil
	end
	
	return getCurCapture()
end

function rp.Capture.GetActiveCapturePointName()
	return getCurCapture() and getCurCapture():GetPoint().printName
end

function rp.Capture.GetActiveCapturePointOwnerName()
	return getCurCapture() and (getCurCapture():IsOrg() and getCurCapture():GetPoint().printName or rp.Capture.Alliances[getCurCapture():GetDefender()].printName or cached[1])
end

function rp.Capture.GetActiveCapturePoint()
	return getCurCapture() and getCurCapture():GetPoint()
end

function rp.Capture.GetRemainingPoints()
	return getCurCapture() and (getCurCapture():IsPointAttacker(LocalPlayer()) and (getCurCapture():GetMaxScore() + getCurCapture():GetScore()) or (getCurCapture():GetMaxScore() - getCurCapture():GetScore()))
end

function rp.Capture.IsLocalPlayerWinning()
	return getCurCapture() and (getCurCapture():IsPointAttacker(LocalPlayer()) and getCurCapture():GetScore() < 0 or getCurCapture():IsPointDefender(LocalPlayer()) and getCurCapture():GetScore() > 0)
end

function rp.Capture.GetMaxPoints()
	return getCurCapture() and getCurCapture():GetMaxScore()
end

function rp.Capture.GetRemainingTime()
	return getCurCapture() and math.floor(getCurCapture():GetEndingTime() - CurTime())
end

function rp.Capture.GetAttacker()
	return getCurCapture() and getCurCapture():GetAttacker()
end

function rp.Capture.GetDefender()
	return getCurCapture() and getCurCapture():GetDefender()
end

function rp.Capture.GetOwnerName(point)
	return rp.Capture.Points[point].isOrg and rp.Capture.Points[point].owner or not rp.Capture.Points[point].isOrg and rp.Capture.Alliances[rp.Capture.Points[point].owner] and rp.Capture.Alliances[rp.Capture.Points[point].owner].printName or 'Неизвестно'
end

function rp.Capture.CheckFlagEntity(point) 
	if not point.flag_ent then
		for k, v in pairs(ents.GetAll()) do
			if IsValid(v) and (v:GetClass() == 'ent_capture_flag') and v.GetCapturePoint and (v:GetCapturePoint() == point.id) then
				point.flag_ent = v
				break
			end
		end
	end
end

function rp.Capture.GetPointBonuses(point) 
	local bonuses = point.print_bonuses
	
	if not bonuses then
		local bons = {}
		
		local payment = 0
		local add_health = 0
		local add_speed = 0
		local add_armor = 0
		local add_ammo = false
		
		if #point.Boxes > 0 then
			for k, v in pairs(point.Boxes) do 
				if v.payment then
					--table.insert(bons, '+' .. rp.FormatMoney(point.payment) .. ' к зарплате')
					payment = payment + v.payment
				end
				
				if v.add_health then
					add_health = add_health + v.add_health
				end
				
				if v.add_speed then
					add_speed = math.max(add_speed, v.add_speed)
				end
				
				if v.add_armor then
					add_armor = add_armor + v.add_armor
				end
				
				if v.add_ammos or v.add_ammo then
					add_ammo = true
				end
				
				if v.spWeapons and table.Count(v.spWeapons) > 0 then
					for _, wep in pairs(v.spWeapons) do
						local wep_t = weapons.Get(wep)
						table.insert(bons, '+ ' .. (wep_t and wep_t.PrintName or cached[10]))
					end
				end
			end
		end
		
		-- Box bonuses
		if payment > 0 then
			table.insert(bons, '+' .. rp.FormatMoney(payment) .. ' ' .. cached[2])
		end
		
		if add_health > 0 then
			table.insert(bons, '+' .. add_health .. '% ' .. cached[3])
		end
		
		if add_speed > 0 then
			table.insert(bons, '+' .. add_speed .. '% ' .. cached[4])
		end
		
		if add_armor > 0 then
			table.insert(bons, '+' .. add_armor .. '% ' .. cached[5])
		end
		
		if add_ammo then
			table.insert(bons, cached[6])
		end
		
		-- Point bonuses
		if point.nohunger then
			table.insert(bons, cached[7])
		end
		
		if point.vehicles then
			table.insert(bons, cached[8])
		end
		
		if point.spawnPoint then
			table.insert(bons, cached[9])
		end
		
		if point.customBonusText then
			table.insert(bons, point.customBonusText)
		end
		
		point.print_bonuses = table.concat(bons, ', ')
		bonuses = point.print_bonuses
	end
	
	return bonuses
end


local function getCurrentPoint(ply)
	for i = 1, #rp.Capture.Points do
		v = rp.Capture.Points[i]
		
		if ply:InBox(v.box[1], v.box[2]) then
			return v
		end
	end
end

local temp
hook.Add("InitPostEntity", function()
	timer.Simple(1, function()
		net.Start('rp.Capture.GetActiveCaptures')
		net.SendToServer()
	end)
	
	timer.Create("GetCurrentPoint", 1, 0, function()
		temp = getCurrentPoint(LocalPlayer())
		
		if temp ~= rp.Capture.CurrentPoint then
			rp.Capture.CurrentPoint = temp
			
			/*
			local attacker = temp and (temp.isOrg and LocalPlayer():GetOrg() or LocalPlayer():GetAlliance())
			if not attacker or (temp.isOrg and not LocalPlayer():OrgCanCapture() or not temp.isOrg and not LocalPlayer():CanCapture()) then return end
			
			if not rp.Capture.IsPointBusy(temp) and temp.owner ~= attacker and (temp.isOrg or (rp.ConjGet(attacker, temp.owner) ~= CONJ_UNION)) and not rp.Capture.IsBusy(attacker) and not rp.Capture.IsBusy(temp.owner) then
				--rp.RunCommand('capture', rp.Capture.CurrentPoint.id) 
				rp.Notify(NOTIFY_GENERIC, tr.Get("Нажмите Е на флаг, чтобы начать захват (владелец - %s)", temp.isOrg and temp.owner or rp.Capture.Alliances[temp.owner] and rp.Capture.Alliances[temp.owner].printName or cached[11]))
			end
			*/
		end
	end)
	
	timer.Create('GetCurrentCapture', 2, 0, function()
		for _, v in pairs(rp.Capture.ActiveCaptures) do 
			if v:GetEndingTime() < CurTime() then 
				rp.Capture.ActiveCaptures[v.ID] = nil
				rp.Capture.ActiveCapturesMap[v.UID] = nil
				
			elseif v:IsPlayerParticipating(LocalPlayer()) then
				LocalPlayer().current_capture = v
				break
			end
		end
	end)
end)

function PLAYER:GetCurrentPoint()
	if self == LocalPlayer() then
		return rp.Capture.CurrentPoint
	else
		return getCurrentPoint(self)
	end
end



net.Receive('CapturePointData', function()
	local capture_uid	= net.ReadString()
	local is_initial 	= net.ReadBool()
	
	if is_initial then
		local t = {}
		setmetatable(t, rp.meta.capture_action)
		
		local capture_mode = net.ReadUInt(3)
		t.ActionMode = capture_mode
		
		t.ID 	= table.insert(rp.Capture.ActiveCaptures, t)
		t.UID 	= capture_uid
		
		rp.Capture.ActiveCapturesMap[capture_uid] = t
		
		local is_org 	= net.ReadBool()
		local attacker  = net.ReadString()
		local defender  = net.ReadString()
		
		t:SetAttacker(is_org and attacker or tonumber(attacker))
		t:SetDefender(is_org and defender or tonumber(defender))
		
		t:SetIsOrg(is_org)
		
		t.Score    = 0
		t.MaxScore = net.ReadUInt(6)
		
		--if capture_mode == rp.Capture.CAPTURE_POINT then
			t:SetPoint(rp.Capture.Points[tonumber(string.Right(capture_uid, string.len(capture_uid) - 1))])
			t:GetPoint().isWar = true
		--end
		
		if t:IsPlayerParticipating(LocalPlayer()) then
			LocalPlayer().current_capture = t
		end
	end
	
	local capture = rp.Capture.GetCaptureByUID(capture_uid)
	if not capture then return end
	
	local state			= net.ReadInt(2)
	local isGoingDown	= net.ReadBool()
	local scores		= net.ReadFloat()
	capture.Progress 	= net.ReadFloat()
	
	capture:SetScore(scores)
	
	capture.TimeLeft 	= net.ReadFloat()
	capture.TimeDone 	= (capture.TimeLeft > -1) and (capture.TimeLeft - CurTime()) or -1
	
	if capture.TimeLeft > -1 then
		capture.IsGoingDown = isGoingDown or false
	else
		capture.IsGoingDown = capture.IsGoingDown or false
	end
	
	capture:SetEndingTime(net.ReadFloat())
	
	
	--print(capture.IsGoingDown, capture.Progress, capture.TimeLeft, capture:GetEndingTime())
	
	
	local point = capture:GetPoint()
	rp.Capture.CheckFlagEntity(point)
	
	if IsValid(point.flag_ent) then
		point.flag_ent.State = state
		point.flag_ent.CurState = capture.IsGoingDown
		point.flag_ent.TimeRemain = capture.TimeLeft
		point.flag_ent.TimeDone = capture.TimeDone
		point.flag_ent.Progress = capture.Progress
	end
	
end)

net.Receive('CapturePointEnded', function()
	local capture = rp.Capture.GetCaptureByUID(net.ReadString())
	if not capture then return end
	
	if capture:GetActionMode() == rp.Capture.CAPTURE_POINT then
		capture:GetPoint().isWar = nil
	end
	
	if capture:GetPoint() and IsValid(capture:GetPoint().flag_ent) then
		capture:GetPoint().flag_ent.CurState = nil
		capture:GetPoint().flag_ent.TimeRemain = nil
		capture:GetPoint().flag_ent.TimeDone = nil
		capture:GetPoint().flag_ent.Progress = nil
	end
	
	if getCurCapture() and getCurCapture().UID == capture.UID then
		LocalPlayer().current_capture = nil
	end
	
	capture:Remove()
end)

hook.Add("CapturePointsLoaded", function()
	local get = nw.GetGlobal('CapturePoints')
	
	if get and #get > 0 then
		for k, v in pairs(rp.Capture.Points) do
			v.owner = get[k]
		end
	end
end)
