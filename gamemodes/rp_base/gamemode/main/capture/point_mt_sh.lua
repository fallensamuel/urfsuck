
local capture_point = {}
capture_point.__index = capture_point

function capture_point:SetIsOrg(isOrg) 
	self.isOrg 	= isOrg and true or false
	self.owner 	= not isOrg and 1 or nil
	
	if isOrg && self.name then
		rp.Capture.PointsMap[self.name] = nil
		self.name = self.name .. '_org'
		rp.Capture.PointsMap[self.name] = self
	end
	
	return self
end

function capture_point:SetPos(box, mapPos) 
	local box_start = Vector()
	local box_end 	= Vector()

	box_start.x = box[1].x < box[2].x && box[1].x || box[2].x
	box_start.y = box[1].y < box[2].y && box[1].y || box[2].y
	box_start.z = box[1].z < box[2].z && box[1].z || box[2].z

	box_end.x = box[1].x > box[2].x && box[1].x || box[2].x
	box_end.y = box[1].y > box[2].y && box[1].y || box[2].y
	box_end.z = box[1].z > box[2].z && box[1].z || box[2].z
	
	self.box 	= {box_start, box_end}
	self.mapPos = mapPos
	
	return self
end

function capture_point:SetFlagPos(pos)
	self.flag_pos = pos
	return self
end

function capture_point:SetFlagHeight(height)
	self.flag_height = height
	return self
end

function capture_point:AddVehicleAlliance(alliance, pos, angle, vehicle) 
	self.vehicles 			= self.vehicles or {}
	self.vehicles[alliance]	= self.vehicles[alliance] or {}
	
	table.insert(self.vehicles[alliance], {
		pos 	= pos, 
		angle 	= angle, 
		vehicle	= vehicle
	})
	
	return self
end

function capture_point:AddVehicleDefault(pos, angle, vehicle) 
	return self:AddVehicleAlliance(0, pos, angle, vehicle) 
end

function capture_point:SetSpawnPoint(point) 
	self.spawnPoint = point
	
	local point_info = rp.cfg.SpawnPoints[point]
	if point_info then
		point_info.isCapturePoint = true
	end
	
	return self
end

function capture_point:SetPrintName(printName) 
	self.printName = printName
	return self
end

function capture_point:SetIcon(icon) 
	self.icon = icon
	return self
end

function capture_point:AddPlayerRewardAlliance(alli, func) 
	self.ply_rewards = self.ply_rewards or {}
	table.insert(self.ply_rewards, {func, alli})
	return self
end

function capture_point:AddPlayerReward(func) 
	return self:AddPlayerRewardAlliance(false, func) 
end

function capture_point:AddRewardAlliance(alli, func) 
	self.rewards = self.rewards or {}
	table.insert(self.rewards, {func, alli})
	return self
end

function capture_point:AddReward(func) 
	return self:AddRewardAlliance(false, func) 
end

function capture_point:SetAddHealth(hp) 
	self.add_health = hp
	return self
end

function capture_point:SetAddSpeed(speed) 
	self.add_speed = speed
	return self
end

function capture_point:SetOwnDoors()
	self.reset_doors = true
	return self
end

function capture_point:AddEntityAlliance(alliance, class, poses)
	local pos = istable(poses[1]) and poses or {poses}
	
	self.spEnts = self.spEnts or {}
	self.spEnts[alliance] = self.spEnts[alliance] or {}
	self.spEnts[alliance][class] = self.spEnts[alliance][class] or {}
	
	table.Add(self.spEnts[alliance][class], pos)
	
	return self
end

function capture_point:AddEntityDefault(class, poses)
	return self:AddEntityAlliance(0, class, poses)
end

function capture_point:SetWipe()
	self.wipe = true
	return self
end

function capture_point:SetNoHunger()
	self.nohunger = true
	return self
end

function capture_point:AddBonusBox(model) 
	if not self.Boxes then return setmetatable({}, rp.meta.capture_bbox) end
	
	local t = { model = model }
	
	t.id = table.insert(self.Boxes, t)
	
	setmetatable(t, rp.meta.capture_bbox)
	return t
end

function capture_point:SetCustomBonusText(text) 
	self.customBonusText = text
	return self
end



function rp.AddCapturePoint(map, name)
	if map != game.GetMap() then 
		return setmetatable({}, capture_point)
	end
	
	local n_name = string.Right(game.GetIPAddress(), 5) .. '_' .. map .. '_' .. name
	
	local t = { 
		name = n_name, 
		owner = 1, 
		visitors = {}, 
		price = rp.cfg.DefaultPointPrice, 
		Boxes = {},
	}
	
	rp.Capture.PointsMap[n_name] = t
	t.id = table.insert(rp.Capture.Points, t)
	
	setmetatable(t, capture_point)
	return t
end
