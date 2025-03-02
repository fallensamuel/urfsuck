local math_floor 		= math.floor
local os_time 			= os.time
local IsValid 			= IsValid
local ents_FindInBox 	= ents.FindInBox
local timer 			= timer
local hook 				= hook


function rp.RedoCaptureSpawnPoints(ply)
	local points 		= ply.caprutedPoints
	local add_points 	= {}
	
	if points then
		for i = 1, #points do
			local point = points[i]
			
			if not point.IsWar and point.spawnPoint and (point.owner == ply:GetOrg() or point.owner == ply:GetAlliance()) then
				table.insert(add_points, point.spawnPoint)
				add_points[point.spawnPoint] = true
			end
		end
	end
	
	ply.capruteSpawnPoints = add_points
	
	if ply.isCaptureSpawnPoint and not add_points[ply.spawnPoint] then
		ply.isCaptureSpawnPoint = false
		ply.spawnPoint = nil
	end
end

function rp.RedoCapturePoints(ply)
	local points 		= rp.Capture.Points
	local add_points 	= {}
	
	if points then
		for i = 1, #points do
			local point = points[i]
			
			if point.owner and (point.owner == ply:GetOrg() or point.owner == ply:GetAlliance()) then
				table.insert(add_points, point)
			end
		end
	end
	
	ply.caprutedPoints = add_points
	rp.RedoCaptureSpawnPoints(ply)
end

function rp.CapturePlayerRespawn(ply)
	local points = ply.caprutedPoints
	if not points then return end

	local health = 0
	
	for _, point in pairs(points) do
		-- Regive ammo
		--if point.add_ammo then
		--	ply:GiveAmmo(point.add_ammo.amount, point.add_ammo.ammo)
		--end
		
		--if point.add_ammos then
		--	ply:GiveAmmos(point.add_ammos) 
		--end
		
		-- Regive weapons
		--if point.spWeapons then
		--	local cur_weps = (not point.isOrg) and point.spWeapons[ply:GetAlliance()] or point.spWeapons[0]
		--	
		--	if cur_weps then
		--		for j = 1, #cur_weps do
		--			ply:Give(cur_weps[j])
		--		end
		--	end
		--end
		
		-- Regive health
		health = health + (point.add_health or 0)
	end
	
	if health > 0 and ply.AddMaxHealth then
		ply:AddMaxHealth(health) 
	end
end

function rp.CapturePlayerCaptured(ply, point)
	ply.capture_map = ply.capture_map or {}
	ply.capture_map[point.name] = true
	
	-- Add speed
	local add_speed = point.add_speed or 0
	GAMEMODE:SetPlayerSpeed(ply, ply:GetWalkSpeed() + add_speed, ply:GetRunSpeed() + add_speed)
	
	-- Add health
	if ply.AddMaxHealth then
		ply:AddMaxHealth(point.add_health or 0) 
	end
	
	-- Add armor
	--ply:SetArmor(ply:Armor() + (point.add_armor or 0))
	
	-- Give ammo
	--if point.add_ammo then
	--	ply:GiveAmmo(point.add_ammo.amount, point.add_ammo.ammo)
	--end
	
	--if point.add_ammos then
	--	ply:GiveAmmos(point.add_ammos) 
	--end
	
	-- Add payments
	--ply.orgCapturePayment = (ply.orgCapturePayment or 0) + (point.payment or rp.cfg.CaptureIncomePerPoint or 0)
	
	-- Add noHunger
	if point.nohunger then
		ply.nohunger = (ply.nohunger or 0) + 1
	end
	
	-- Give weapons
	--if point.spWeapons then
	--	local cur_weps = (not point.isOrg) and point.spWeapons[ply:GetAlliance()] or point.spWeapons[0]
	--	
	--	if cur_weps then
	--		for i = 1, #cur_weps do
	--			ply:Give(cur_weps[i])
	--		end
	--	end
	--end
end

function rp.CapturePlayerLost(ply, point)
	ply.capture_map = ply.capture_map or {}
	
	if ply.capture_map[point.name] then
		-- Loose payments
		-- ply.orgCapturePayment = (ply.orgCapturePayment or 0) - (point.payment or rp.cfg.CaptureIncomePerPoint or 0)
		
		-- Loose noHunger
		ply.nohunger = (ply.nohunger or 0) - (point.nohunger and 1 or 0)
		ply.nohunger = ply.nohunger > 0 and ply.nohunger or nil
	end
	
	ply.capture_map[point.name] = nil
end

local function playerChangedFaction(ply)
	local old_points = ply.caprutedPoints
	
	if old_points then
		for i = 1, #old_points do
			rp.CapturePlayerLost(ply, old_points[i])
		end
	end
	
	rp.RedoCapturePoints(ply)
end

local function captureVehicleSpawn(point, pos, angle, vehicle)
	local c = simfphys.SpawnVehicleSimple(vehicle, pos, angle)
	if point.isOrg then
		c:DoorSetOrg(point.owner)
	else
		c.Faction 			= rp.Capture.Alliances[point.owner].factions
		c:DoorSetGroup(rp.Capture.Alliances[point.owner].door_group)
	end
	c.captureSpawnPos 	= pos
	
	local cur_owner = point.owner
	
	c.OnDelete = function()
		if not c.captureNotRespawn and not point.IsWar then
			timer.Simple(rp.cfg.CaptureVehicleRespawnDuration, function()
				if point.owner ~= cur_owner then return end
				captureVehicleSpawn(point, pos, angle, vehicle)
			end)
		end
	end
	
	table.insert(point.spawned_vehicles, c)
	
	timer.Simple(0.2, function()
		if !c or not simfphys.RegisterEquipment then return end
		simfphys.RegisterEquipment(c)
	end)
end

----[[
for k, v in ipairs(ents.GetAll()) do
	if v.DriverSeat and v.captureSpawnPos then 
		v.captureNotRespawn = true
		
		if not IsValid(v.DriverSeat:GetDriver()) then
			v:Remove()
		end
	end
end
--]]


hook.Add("PlayerSpawn", "rp.Capture.player_Respawn", rp.CapturePlayerRespawn)

hook.Add("PlayerAuthed", "rp.Capture.player_Spawn", function(ply)
	nw.WaitForPlayer(ply, function(ply) 
		rp.RedoCapturePoints(ply)
		rp.CapturePlayerRespawn(ply)
		
		-- Add money
		--[[
		for k, v in ipairs(rp.Capture.Points) do
			if ply:GetOrg() == v.owner or ply:GetAlliance() == v.owner then
				ply.orgCapturePayment = (ply.orgCapturePayment or 0) + (v.payment or rp.cfg.CaptureIncomePerPoint or 0)
			end
		end
		]]
	end)
end)

hook.Add("OnPlayerChangedTeam", "rp.Capture.change_Team", playerChangedFaction)
hook.Add("PlayerOrgChanged", "rp.Capture.change_Org", playerChangedFaction)


hook.Add("PlayerLeaveVehicle", "rp.Capture.vehicle_runtimer", function(ply, vehicle)
	local veh = vehicle:GetParent()
	if not IsValid(veh) or not veh.captureSpawnPos or vehicle ~= veh.DriverSeat then return end
	
	timer.Create('rp.Capture.vehicle_remove' .. veh:EntIndex(), rp.cfg.CaptureVehicleRespawnDuration, 1, function()
		if IsValid(veh) then
			veh:Remove()
		end
	end)
end)

hook.Add("PlayerEnteredVehicle", "rp.Capture.vehicle_stoptimer", function(ply, vehicle)
	local veh = vehicle:GetParent()
	if not IsValid(veh) or not veh.captureSpawnPos or vehicle ~= veh.DriverSeat then return end
	
	timer.Remove('rp.Capture.vehicle_remove' .. veh:EntIndex())
end)

hook.Add('PlayerHasHunger', 'rp.Capture.NoHunger', function(ply)
	if ply.nohunger then return false end
end)


hook.Add("TerritoryOwnerChanged", "rp.Capture.rewards", function(point, attackers, defenders)
	if point.owner ~= attackers then return end
	
	-- Vehicles
	if point.vehicles then
		local data = !point.isOrg && point.vehicles[attackers] or point.vehicles[0] or {}
		
		for k, v in pairs(point.spawned_vehicles or {}) do
			v.captureNotRespawn = true

			if !IsValid(v) then continue end
			
			if v:GetPos():DistToSqr(v.captureSpawnPos) < 22500 and v.DriverSeat and not IsValid(v.DriverSeat:GetDriver()) then
				v:Remove()
			end
		end
		
		point.spawned_vehicles = {}
		
		for k, v in pairs(data) do
			captureVehicleSpawn(point, v.pos, v.angle, v.vehicle)
		end
	end
	
	-- Point entities
	if point.spEnts then
		local cur_ents = (not point.isOrg) and point.spEnts[attackers] or point.spEnts[0] or {}
		
		for k, v in pairs(point.spawned_entities or {}) do
			if IsValid(v) and not (v:IsVehicle() and IsValid(v:GetDriver())) then
				v:Remove()
			end
		end
		
		point.spawned_entities = {}
		
		for class, v in pairs(cur_ents) do
			for k, e in pairs(v) do
				local ent = ents.Create(class)
				
				ent:SetPos(e[1])
				ent:SetAngles(e[2])
				
				ent:Spawn()
				
				table.insert(point.spawned_entities, ent)
			end
		end
	end
	
	-- Point rewards
	for k, v in ipairs(point.rewards or {}) do
		if (not v[2]) or ((not point.isOrg) and v[2] == attackers) then
			v[1](point)
		end
	end
	
	-- Player rewards
	local doors_group
	
	for k, v in ipairs(player.GetAll()) do
		if defenders and (v:GetOrg() == defenders or v:GetAlliance() == defenders) then
			rp.CapturePlayerLost(v, point)
			rp.RedoCapturePoints(v)
		end
		
		if v:GetOrg() == attackers or v:GetAlliance() == attackers then
			rp.CapturePlayerCaptured(v, point)
			rp.RedoCapturePoints(v)
			
			for n, m in ipairs(point.ply_rewards or {}) do
				if (not m[2]) or ((not point.isOrg) and m[2] == attackers) then
					m[1](point, v)
				end
			end
		end
	end
	
	-- Old props
	if defenders and point.wipe then
		for _, v in ipairs(ents.FindInBox(point.box[1], point.box[2]) or {}) do
			local owner = IsValid(v) and v:CPPIGetOwner()
			
			if IsValid(owner) then
				if (point.isOrg and owner:GetOrg() == attackers) or (not point.isOrg and owner:GetAlliance() == defenders) then
					v:Remove()
				end
			end
		end
	end
	
	-- Doors
	if point.reset_doors then
		local dr_gr	= rp.Capture.Alliances[attackers] and rp.Capture.Alliances[attackers].door_group
		local isOrg	= point.isOrg
		
		for k, v in pairs(point.doors or {}) do
			if IsValid(v) then
				v:DoorUnOwn()
				
				if isOrg then
					v:DoorSetOrg(attackers)
				else 
					v:DoorSetGroup(dr_gr)
				end
			end
		end
	end
end)

local function setupDoors()
	local points = rp.Capture.Points
	
	for i = 1, #points do
		local point = points[i]
		point.doors = {}
		
		local entities = ents.FindInBox(point.box[1], point.box[2]) or {}
		
		for j = 1, #entities do
			local door = entities[j]
			
			if IsValid(door) and door:IsDoor() then
				table.insert(point.doors, door)
			end
		end
	end
end
setupDoors()

hook.Add("InitPostEntity", "rp.Capture.Doors", setupDoors)