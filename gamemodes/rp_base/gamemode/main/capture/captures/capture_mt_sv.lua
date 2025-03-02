
function rp.meta.capture_action:Transfer(is_initial) 
	net.Start('CapturePointData')
		net.WriteString(self.UID)
		net.WriteBool(is_initial)
		
		if is_initial then
			net.WriteUInt(self:GetActionMode(), 3)
			net.WriteBool(self:IsOrg())
			
			net.WriteString(self:GetAttacker())
			net.WriteString(self:GetDefender() or '')
			
			net.WriteUInt(self:GetMaxScore(), 6)
		end
		
		net.WriteInt(self.State or -1, 2)
		net.WriteBool(self.State == 0 and (self.Score > 0) or self.State == 1 and (self.Score < 0) or false)
		net.WriteFloat((self.numDefenders + self.numAttackers) and (self.numAttackers / (self.numDefenders + self.numAttackers)) or 0.5)
		net.WriteFloat(self.PreviousProgress or 0)
		net.WriteFloat(self.PreviousTimeLeft and (CurTime() + self.PreviousTimeLeft) or -1)
		net.WriteFloat(self.EndingTime or 0)
	net.Broadcast()
end 

function rp.meta.capture_action:TransferEnd() 
	net.Start('CapturePointEnded')
		net.WriteString(self.UID)
	net.Broadcast()
end

function rp.meta.capture_action:OnPlayerKill(func) 
	hook.Add('PlayerDeath', 'CapturePlyDie_' .. self.UID, function(victim, _, killer)
		if not self:GetEndingTime() then return end
		func(victim, killer)
	end)
end

function rp.meta.capture_action:AddjustTime()
	if self.TimerReachedMaximum or not rp.cfg.CaptureDurationIncrease then return end
	if not timer.TimeLeft('CaptureEnd_' .. self.UID) then return end
	
	local time_end = timer.TimeLeft('CaptureEnd_' .. self.UID) + rp.cfg.CaptureDurationIncrease
	
	self:SetEndingTime(CurTime() + time_end)
	
	if time_end >= self:GetMaxDuration() then
		self.TimerReachedMaximum = true
		--self:NotifyCapturePlayers(rp.Term('CaptureTimerFrozen'))
	end
	
	timer.Create('CaptureEnd_' .. self.UID, time_end, 1, function()
		self:EndCaptureAction(false)
	end)
	
	--if time_end > 60 then timer.Create('Capture60SecLeft' .. self.UID, time_end - 60, 1, function() self:NotifyCapturePlayers(rp.Term(self:GetActionMode() == rp.Capture.CAPTURE_POINT and "Capture60SecLeft" or "CaptureWar60SecLeft")) end) end
	--if time_end > 30 then timer.Create('Capture30SecLeft' .. self.UID, time_end - 30, 1, function() self:NotifyCapturePlayers(rp.Term(self:GetActionMode() == rp.Capture.CAPTURE_POINT and "Capture30SecLeft" or "CaptureWar30SecLeft")) end) end
	--if time_end > 10 then timer.Create('Capture10SecLeft' .. self.UID, time_end - 10, 1, function() self:NotifyCapturePlayers(rp.Term(self:GetActionMode() == rp.Capture.CAPTURE_POINT and "Capture10SecLeft" or "CaptureWar10SecLeft")) end) end
end

function rp.meta.capture_action:TransferScores()
	if self:GetScore() == 0 then
		if timer.TimeLeft('CaptureChangeState' .. self.UID) then
			self.PreviousProgress = self.PreviousProgress * timer.TimeLeft('CaptureChangeState' .. self.UID) / self.PreviousTimeLeft
			self.PreviousTimeLeft = nil
		end
		
		timer.Remove('CaptureChangeState' .. self.UID)
	else 
		local rem_progress
		
		if timer.TimeLeft('CaptureChangeState' .. self.UID) then
			rem_progress = self.PreviousProgress * timer.TimeLeft('CaptureChangeState' .. self.UID) / self.PreviousTimeLeft
			
		elseif self.PreviousProgress then
			rem_progress = self.PreviousProgress
			
		else
			rem_progress = (self:GetScore() > 0) and 1 or 0
		end
		
		if self.PreviousState ~= nil and self.PreviousState ~= (self:GetScore() > 0) then
			rem_progress = 1 - rem_progress
		end
		
		self.PreviousProgress 	= rem_progress
		self.PreviousTimeLeft 	= self.PreviousProgress * rp.cfg.CaptureFlagSpeed / math.abs(self:GetScore())
		self.PreviousState 		= (self:GetScore() > 0)
		
		timer.Create('CaptureChangeState' .. self.UID, self.PreviousTimeLeft, 1, function()
			local point = self:GetPoint()
			
			if self:GetScore() > 0 then
				if self.State == 0 then
					timer.Remove('CaptureChangeState' .. self.UID)
					
					self.PreviousProgress = 1
					self.State = 1
					
					-- FLAG SETMATERIAL MODELS/SHINY
					point.flag_ent:SetURL('')
					point.flag_ent:SetFlagMaterial('models/shiny')
					
					--print('setting to', 'models/shiny')
					
					--for i = 0, 31 do
					--	point.flag_ent:SetSubMaterial(i, 'models/shiny')
					--end
					
					self:TransferScores()
				else 
					self:EndCaptureAction(true)
				end
			else
				if self.State == 0 then
					self.PreviousProgress 	= nil
					self.PreviousTimeLeft 	= nil
					self.PreviousState 		= nil
				else
					timer.Remove('CaptureChangeState' .. self.UID)
					
					self.PreviousProgress = 1
					self.State = 0
					
					-- FLAG SETURL DEFENDERS
					point.flag_ent:SetURL(point.isOrg and 'ORG:' .. self:GetDefender() or rp.Capture.Alliances and rp.Capture.Alliances[self:GetDefender()] and rp.Capture.Alliances[self:GetDefender()].org and 'ORG:' .. rp.Capture.Alliances[self:GetDefender()].org or rp.Capture.Alliances and rp.Capture.Alliances[self:GetDefender()] and rp.Capture.Alliances[self:GetDefender()].flagMaterial or '')
					point.flag_ent:SetFlagMaterial('')
					
					--print('setting to', '!wmat_' .. util.CRC(point.flag_ent:EntIndex() .. '.' .. point.flag_ent:GetURL()))
					
					--for i = 0, 31 do
					--	point.flag_ent:SetSubMaterial(i, '!wmat_' .. util.CRC(point.flag_ent:EntIndex() .. '.' .. point.flag_ent:GetURL()))
					--end
					
					self:TransferScores()
				end
			end
		end)
	end
	
	self:AddjustTime()
	self:Transfer() 
end

function rp.meta.capture_action:NotifyCapturePlayers(msg)
	for k, v in pairs(player.GetAll()) do
		if self:IsPlayerParticipating(v) then
			rp.Notify(v, NOTIFY_GENERIC, msg)
		end
	end
end

function rp.meta.capture_action:Start(time)
	self:SetEndingTime(CurTime() + time)
	
	timer.Create('CaptureEnd_' .. self.UID, time, 1, function()
		self:EndCaptureAction(false)
	end)
	
	self:Transfer(true) 
end

function rp.meta.capture_action:EndCaptureAction(attackers_won)
	timer.Remove('CaptureEnd_' .. self.UID)
	timer.Remove('CaptureVisitors_' .. self.UID)
	timer.Remove('CaptureChangeState' .. self.UID)
	
	--timer.Remove('Capture60SecLeft' .. self.UID)
	--timer.Remove('Capture30SecLeft' .. self.UID)
	--timer.Remove('Capture10SecLeft' .. self.UID)
	
	local attackers = self:GetAttacker()
	local defenders = self:GetDefender()
	
	local point = self:GetPoint()
	
	point.isWar = false
		
	if attackers_won then 
		rp.NotifyAll(NOTIFY_GENERIC, rp.Term('PointWasCaptured'), point.isOrg and attackers or rp.Capture.Alliances and rp.Capture.Alliances[attackers] and rp.Capture.Alliances[attackers].printName or translates.Get("Неизвестные"), point.printName)
			
		if point.owner then
			rp._Stats:Query('UPDATE capture_data SET owner = "' .. (point.isOrg and attackers or rp.Capture.Alliances and rp.Capture.Alliances[attackers] and rp.Capture.Alliances[attackers].name or '') .. '" WHERE name = "' .. point.name .. '"')
		else
			rp._Stats:Query('INSERT INTO capture_data VALUES("' .. point.name .. '", ?)', point.isOrg and attackers or rp.Capture.Alliances and rp.Capture.Alliances[attackers] and rp.Capture.Alliances[attackers].name or '')
		end
		
		point.owner = attackers
		
		hook.Call('PointOwnerChanged', nil, attackers, defenders)
	else
		rp.NotifyAll(NOTIFY_GENERIC, rp.Term('PointWasDefended'), point.isOrg and defenders or rp.Capture.Alliances and rp.Capture.Alliances[defenders] and rp.Capture.Alliances[defenders].printName or translates.Get("Неизвестные"), point.printName)
	end
	
	-- FLAG SETURL OWNERS
	if point.owner then
		point.flag_ent:SetURL(point.isOrg and 'ORG:' .. point.owner or rp.Capture.Alliances and rp.Capture.Alliances[point.owner] and rp.Capture.Alliances[point.owner].org and 'ORG:' .. rp.Capture.Alliances[point.owner].org or rp.Capture.Alliances and rp.Capture.Alliances[point.owner] and rp.Capture.Alliances[point.owner].flagMaterial or '')
		
		--print('setting to', '!wmat_' .. util.CRC(point.flag_ent:EntIndex() .. '.' .. point.flag_ent:GetURL()))
		
		--for i = 0, 31 do
		--	point.flag_ent:SetSubMaterial(i, '!wmat_' .. util.CRC(point.flag_ent:EntIndex() .. '.' .. point.flag_ent:GetURL()))
		--end
	end
	
	point.flag_ent:SetFlagMaterial('')
	
	timer.Simple(0, function()
		hook.Call('TerritoryOwnerChanged', nil, point, attackers, defenders)
			
		if #point.Boxes == 0 then return end
			
		for _, v in pairs(player.GetAll()) do
			if point.owner and (v:GetOrg() == point.owner or v:GetAlliance() == point.owner) then
				for __, m in pairs(point.Boxes) do
					m.entity.PlayersUseTime[v] = CurTime() + 2
					
					net.Start('Capture.Rewards.BoxUse')
						net.WriteEntity(m.entity)
						net.WriteFloat(m.entity.PlayersUseTime[v])
					net.Send(v)
				end
			end
		end
	end)
	
	self:TransferEnd()
	self:Remove()
	
	nw.SetGlobal('CapturePoints', true)
end