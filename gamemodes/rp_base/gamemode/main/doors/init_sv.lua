util.AddNetworkString('rp.keysMenu')
util.AddNetworkString("DoorsKnock")

local bell = {
	sound = Sound('ambient/alarms/warningbell1.wav'),
	delay = 10
}

local knock = {
	sound = Sound('physics/wood/wood_crate_impact_hard2.wav'),
	delay = 5
}

net.Receive("DoorsKnock", function(len, ply)
	--if not IsValid(ply:GetWeapon("keys")) then return end

	ply:LagCompensation(true)
	local ent = ply:GetEyeTrace().Entity
	ply:LagCompensation(false)

	if not IsValid(ent) or not ent:IsDoor() or ent:GetPos():Distance(ply:GetPos()) > 100 then return end
	local IsOwner = ent:DoorOwnedBy(ply) or ent:DoorCoOwnedBy(ply)

	if IsOwner then return end

	if IsValid(ent:DoorGetOwner()) and ( not ent.NextBell or ent.NextBell <= CurTime() ) then
		rp.Notify(ent:DoorGetOwner(), NOTIFY_GENERIC, rp.Term('PlayerRangDoorbell'))
		ply:EmitSound(bell.sound, 100, 110)
		ent.NextBell = CurTime() + bell.delay
	elseif not ent.NextKnock or ent.NextKnock <= CurTime() then
		ply:EmitSound(knock.sound, 100, math.random(90, 110))
		ent.NextKnock = CurTime() + knock.delay
	end

	ply:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_FIST, true)
end)

function ENTITY:DoorLock(locked)
	self.Locked = locked

	if(self:GetClass() == 'gmod_sent_vehicle_fphysics_base') then
		if(locked) then
			self:Lock()
		else
			self:UnLock()
		end
		
		return
	end

	if (locked == true) then
		self:Fire('lock', '', 0)
	elseif (locked == false) then
		self:Fire('unlock', '', 0)
	end
end

function ENTITY:DoorOwn(pl)
	pl:SetVar('doorCount', (pl:GetVar('doorCount') or 0) + 1, false, false)

	self:SetNetVar('DoorData', {
		Owner = pl
	})
end

function ENTITY:DoorUnOwn()
	if IsValid(self:DoorGetOwner()) then
		self:DoorGetOwner():SetVar('doorCount', (self:DoorGetOwner():GetVar('doorCount') or 0) - 1, false, false)
	end

	--if self:GetModel() == 'models/props_doors/door03_slotted_left.mdl' then
	--	self:SetModel('models/props_c17/door01_left.mdl')
	--end
	if self:GetModel() == 'models/props_c17/door01_left.mdl' and self:GetSkin() == 12 and (self:GetNetVar('DoorData') or {}).Upgraded then
		self:SetSkin(self.DefaultSkin or 1)
		self:DoorSetUpgraded(nil)
	end
	
	self:DoorLock(false)
	self:SetNetVar('DoorData', nil)
end

function ENTITY:DoorCoOwn(pl)
	local data = self:GetNetVar('DoorData') or {}
	data.CoOwners = data.CoOwners or {}
	data.CoOwners[#data.CoOwners + 1] = pl
	self:SetNetVar('DoorData', data)
end

function ENTITY:DoorUnCoOwn(pl)
	local data = self:GetNetVar('DoorData') or {}
	table.RemoveByValue(data.CoOwners or {}, pl)
	self:SetNetVar('DoorData', data)
end

function ENTITY:DoorSetOrgOwn(bool)
	local data = self:GetNetVar('DoorData') or {}
	data.OrgOwn = bool
	self:SetNetVar('DoorData', data)
end

function ENTITY:DoorSetOrg(org)
	self:SetNetVar('DoorData', {Org = org})
end

function ENTITY:DoorSetUpgraded(upgraded)
	local data = self:GetNetVar('DoorData') or {}
	data.Upgraded = upgraded
	self:SetNetVar('DoorData', data)
end

function ENTITY:DoorSetTitle(title)
	local data = self:GetNetVar('DoorData') or {}
	data.Title = title
	self:SetNetVar('DoorData', data)
end

function ENTITY:DoorSetTeam(t)
	self:SetNetVar('DoorData', {
		Team = t
	})
end

function ENTITY:DoorSetGroup(g)
	self:SetNetVar('DoorData', {
		Group = g
	})
end

function ENTITY:DoorSetOwnable(ownable)
	if (ownable == true) then
		self:SetNetVar('DoorData', false)
	elseif (ownable == false) then
		self:SetNetVar('DoorData', nil)
	end
end

function PLAYER:DoorUnOwnAll()
	for k, v in ipairs(ents.GetAll()) do
		if IsValid(v) and v:IsDoor() then
			if v:DoorOwnedBy(self) then
				v:DoorUnOwn()
			elseif v:DoorCoOwnedBy(self) then
				v:DoorUnCoOwn(self)
			end
		end
	end
end

--
-- Load door data
--
local db = rp._Stats

local f = math.floor
local FloorFormat = function(x, y, z)
	return f(x).." "..f(y).." "..f(z)
end

local load_debug = false

local LoadData = function(v, ent)
	local test = 0

	if (v.Title ~= nil) and (v.Title ~= 'NULL') then
		ent:DoorSetTitle(v.Title)
		if load_debug then test = test + 1; print("Title") end
	end -- fuck you if you rethink im redoing the door data

	if (v.Team ~= nil) and (v.Team ~= 'NULL') then
		ent:DoorSetTeam(tonumber(v.Team))
		if load_debug then test = test + 1; print("Team") end
	end

	if (v.Group ~= nil) and (v.Group ~= 'NULL') then
		ent:DoorSetGroup(v.Group)
		if load_debug then test = test + 1; print("Group") end
	end

	if (v.Ownable ~= nil) and (v.Team == nil or v.Team == 'NULL') and (v.Group == nil or v.Group == 'NULL') then
		ent:DoorSetOwnable(tobool(v.Ownable))
		if load_debug then test = test + 1; print("Ownable") end
	end

	if (v.Locked ~= nil) and (v.Locked ~= 'NULL') then
		ent:DoorLock(tobool(v.Locked))
		if load_debug then test = test + 1; print("Lock") end
	end

	if load_debug then print("Загружено ".. test .." свойств!") end
end

local SearchDistance = 64^2
local function loadDoorData(ply, debug)
	local debug_counter = 0

	local DoorsTable = {}
	local DoorsByPos = {}

	for k, v in ipairs(ents.GetAll()) do
		if v:IsDoor() then
			v:Fire('unlock', '', 0)
			v.Locked = false

			local pos = v:GetPos()
			local index = FloorFormat(pos.x, pos.y, pos.z)
			DoorsTable[index] = v
			DoorsByPos[v] = pos
		end
	end

	db:Query('SELECT * FROM new_rp_doordata WHERE Map="' .. string.lower(rp.cfg.ServerMapId) .. '";', function(data)
		print("[_ Начата загрузка дверей! _]")
		print("Дверей на карте: "..table.Count(DoorsTable))
		print("Дверей в БД: "..#data)

		local loaded = 0

		for k, v in ipairs(data or {}) do
			--local ent = ents.GetMapCreatedEntity(v.Index) --Entity(v.Index + game.MaxPlayers())
			local index = v.X.." "..v.Y.." "..v.Z
			local ent = DoorsTable[index]

			if IsValid(ent) == false then
				local door_pos = Vector(v.X, v.Y, v.Z)
--[[
				local min_dist = 9999999
				local min_dit_door = NULL

				for door, pos in pairs(DoorsByPos) do
					local dist = door_pos:DistToSqr(pos)
					min_dist = math.min(min_dist, dist)
					if dist == min_dist then
						min_dit_door = door
					end
				end

				if min_dist <= SearchDistance then
					ent = min_dit_door
					print("Дверь в этих координатах не найдена. Самая близкая из допустимых находиться на расстоянии: ".. min_dist, "загружаю её!")
				else
					print("Не удалось найти дверь по указанным координатам! ["..index.."]", "Расстояние до самой близкой двери: ".. min_dist)
]]--
					if debug == 1 then
						timer.Simple(debug_counter, function()
							ply:SetPos(door_pos)
							ply:ChatPrint("По идеи тут должна быть дверь. "..index)
						end)
						debug_counter = debug_counter + 1
					end
--[[
					continue
				end
]]--
			end

			if IsValid(ent) then
				LoadData(v, ent)
				loaded = loaded + 1

				print("Дверь загруженна! ["..index.."]")

				if debug == 2 then
					timer.Simple(debug_counter, function()
						ply:SetPos(Vector(v.X, v.Y, v.Z))
						ply:ChatPrint("По идеи тут должна быть дверь. "..index)
					end)
					debug_counter = debug_counter + 1
				end
			else
				print("Не удалось найти дверь по указанным координатам! ["..index.."]")

				if debug == 1 then
					timer.Simple(debug_counter, function()
						ply:SetPos(Vector(v.X, v.Y, v.Z))
						ply:ChatPrint("По идеи тут должна быть дверь. "..index)
					end)
					debug_counter = debug_counter + 1
				end
			end
		end

		print("[_ Загруженно "..loaded.." дверей! _]")
		DoorsTable = nil
	end)
end

hook('InitPostEntity', 'DoorData.InitPostEntity', loadDoorData)

local Floor = math.floor

local debugDoorSave = false

local function storeDoorData(ent)
	if !ent:IsVehicle() then
		-- TODO:
		-- Придумать способ сохранения выезжающих дверей.
		-- Судя по всему энтити дверей меняют позицию при открытии/закрытии :(
		-- прежде всего надо потестить
		
		local pos = ent:GetPos()

		if debugDoorSave then
			PrintTable({
		        ['Map']     = string.lower(rp.cfg.ServerMapId),
		        ['X']       = Floor(pos.x),
		        ['Y']       = Floor(pos.y),
		        ['Z']       = Floor(pos.z),
		        ['Team']    = ent:DoorGetTeam() or 'NULL',
		        ['Title']   = ent:DoorGetTitle() or 'NULL',
		        ['Ownable'] = ent:DoorIsOwnable() and 0 or 1,
		        ['Locked']  = ent.Locked and 1 or 0,
		        ['Group']   = ent:DoorGetGroup() or 'NULL',
		    })
		end

		db:Query('REPLACE INTO new_rp_doordata(`X`,`Y`,`Z`,`Map`,`Title`,`Team`,`Group`,`Ownable`,`Locked`) VALUES(?,?,?,?,?,?,?,?,?)', Floor(pos.x), Floor(pos.y), Floor(pos.z), string.lower(rp.cfg.ServerMapId), ent:DoorGetTitle() or 'NULL', ent:DoorGetTeam() or 'NULL', ent:DoorGetGroup() or 'NULL', (ent:DoorIsOwnable() and 0 or 1), (ent.Locked and 1 or 0))
	end
end

concommand.Add("~reload_doors", function(ply, cmd, args)
	if IsValid(ply) and not ply:IsRoot() then return end

	if IsValid(ply) then
		loadDoorData(ply, tonumber(args[1]) or 0)
		ply:ChatPrint("Двери пезагруженны! см console.log или консоль сервера что-бы узнать детали! :smile:")
	else
		loadDoorData()
	end
end)

concommand.Add("~reload_trace_door", function(ply)
	if not IsValid(ply) or not ply:IsRoot() then return end

	local door = ply:GetEyeTrace().Entity
	if not IsValid(door) or not door:IsDoor() then ply:ChatPrint("Мб ты наведёшь прицел на дверь прежде чем использовать эту команду? :upsidedown:") return end

	local base_query = 'SELECT * FROM `new_rp_doordata` WHERE `Map` = %q AND `X` = %s AND `Y` = %s AND `Z` = %s;'
	local pos = door:GetPos()
	db:Query(string.format(base_query, string.lower(rp.cfg.ServerMapId), Floor(pos.x), Floor(pos.y), Floor(pos.z)), function(data)
		PrintTable(data)
	end)
end)

concommand.Add("~rebuild_doorsdata", function(ply)
	if not ply:IsRoot() then return end
	ply:ChatPrint("[_ Начало переноса дверей со старого формата на новый! _]")

	print("СОЗДАНИЕ БД!")
	rp._Stats:Query([[CREATE TABLE IF NOT EXISTS `new_rp_doordata` (
		`X` int NOT NULL,
		`Y` int NOT NULL,
		`Z` int NOT NULL,
		`Map` varchar(50) NOT NULL,
		`Title` varchar(50) DEFAULT NULL,
		`Team` varchar(50) DEFAULT NULL,
		`Group` varchar(50) DEFAULT NULL,
		`Ownable` int(1) DEFAULT NULL,
		`Locked` int(1) DEFAULT NULL,
		PRIMARY KEY (`X`,`Y`,`Z`,`Map`)
	) ENGINE=MyISAM DEFAULT CHARSET=utf8;]], function()
		print("ПЕРЕНОС СО СТАРОГО ФОРМАТА НА НОВЫЙ!")

		rp._Stats:Query('SELECT * FROM rp_doordata WHERE Map="' .. string.lower(rp.cfg.ServerMapId) .. '";', function(data)
			for k, v in ipairs(data or {}) do
				local ent = Entity(v.Index + game.MaxPlayers())
				if not IsValid(ent) then
					print("ОШИБКА! Похоже что дверь с индексом "..v.Index.." Не существует на карте!")
					continue
				elseif not ent:IsDoor() then
					print("ОШИБКА! Энтити с индексом "..v.Index.." Не являеться!")
					continue
				end
				local pos = ent:GetPos()

				print("Готово!", "Старое айди: `"..v.Index.."`")
				rp._Stats:Query('REPLACE INTO new_rp_doordata(`X`,`Y`,`Z`,`Map`,`Title`,`Team`,`Group`,`Ownable`,`Locked`) VALUES(?,?,?,?,?,?,?,?,?)', Floor(pos.x), Floor(pos.y), Floor(pos.z), string.lower(rp.cfg.ServerMapId), ent:DoorGetTitle() or 'NULL', ent:DoorGetTeam() or 'NULL', ent:DoorGetGroup() or 'NULL', (ent:DoorIsOwnable() and 0 or 1), (ent.Locked and 1 or 0))
			end

			print("[_ ДАННЫЕ ДВЕРЕЙ ОБНОВЛЕННЫ! _]")
			print("ПЕРЕЗАГРУЗКА ДВЕРЕЙ!")
			loadDoorData()

			if IsValid(ply) then
				ply:ChatPrint("Перенос заверщён! см console.log или консоль сервера что-бы получить детальную информацию о переносе данных!")
			end
		end)
	end)
end)

--
-- Admin Commands
--
rp.AddCommand('/setownable', function(pl, text, args)
	if ba.IsSuperAdmin(pl) and pl:HasFlag('H') then
		local ent = pl:GetEyeTrace().Entity

		if IsValid(ent) and ent:IsDoor() then
			ent:DoorSetOwnable(ent:DoorIsOwnable())
			storeDoorData(ent)
		end
	end
end)

rp.AddCommand('/setteamown', function(pl, text, args)
	if ba.IsSuperAdmin(pl) and pl:HasFlag('H') then
		local ent = pl:GetEyeTrace().Entity

		if IsValid(ent) and ent:IsDoor() then
			ent:DoorUnOwn()
			ent:DoorSetTeam(tonumber(args[1]))
			storeDoorData(ent)
		end
	end
end)

rp.AddCommand('/setgroupown', function(pl, text, args)
	if ba.IsSuperAdmin(pl) and pl:HasFlag('H') then
		local ent = pl:GetEyeTrace().Entity

		if IsValid(ent) and ent:IsDoor() then
			ent:DoorUnOwn()
			ent:DoorSetGroup(text)
			storeDoorData(ent)
		end
	end
end)

rp.AddCommand('/setlocked', function(pl, text, args)
	if ba.IsSuperAdmin(pl) and pl:HasFlag('H') then
		local ent = pl:GetEyeTrace().Entity

		if IsValid(ent) and ent:IsDoor() then
			rp.Notify(pl, NOTIFY_GENERIC, (ent.Locked and rp.Term('DoorUnlocked') or rp.Term('DoorLocked')))
			ent:DoorLock(not ent.Locked)
			storeDoorData(ent)
		end
	end
end)

--
-- Commands
--
rp.AddCommand('/buydoor', function(pl, text, args)
	if (pl:GetVar('doorCount') or 0) > 20 then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('MaxDoors'))

		return
	end

	local cost = pl:Wealth(rp.cfg.DoorCostMin, rp.cfg.DoorCostMax)

	if not pl:CanAfford(cost) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('CannotAfford'))

		return
	end

	local ent = pl:GetEyeTrace().Entity

	if IsValid(ent) and ent:IsDoor() and ent:DoorIsOwnable() and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) then
		pl:TakeMoney(cost)
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('DoorBought'), rp.FormatMoney(cost))
		ent:DoorOwn(pl)
	end
end)

rp.AddCommand('/addcoowner', function(pl, text, args)
	local ent = pl:GetEyeTrace().Entity
	local co = rp.FindPlayer(args[1])

	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(pl) and (co ~= nil) and (co ~= pl) and not ent:DoorCoOwnedBy(co) and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) then
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('DoorOwnerAdded'), co)
		rp.Notify(co, NOTIFY_GREEN, rp.Term('DoorOwnerAddedYou'), pl)
		ent:DoorCoOwn(co)
	end
end)

rp.AddCommand('/doorgrade', function(pl, text, args)
	local ent 	= pl:GetEyeTrace().Entity
	local cost 	= pl:Wealth(rp.cfg.DoorCostMin, rp.cfg.DoorCostMax) * 2

	if not pl:CanAfford(cost) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('DoorCantUpgrade'))
		return
	end
	
	if IsValid(ent) and ent:IsDoor() and not ent:IsVehicle() and not string.find(string.lower(ent:GetClass()), "vehicle") and ent:DoorOwnedBy(pl) and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) then
		pl:TakeMoney(cost)
		
		--if ent:GetModel() == 'models/props_c17/door01_left.mdl' then
		--	ent:SetModel('models/props_doors/door03_slotted_left.mdl')
		--end
		if ent:GetModel() == 'models/props_c17/door01_left.mdl' then
			ent.DefaultSkin = ent.DefaultSkin or ent:GetSkin()
			ent:SetSkin(12)
		end
		
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('DoorUpgraded'))
		ent:DoorSetUpgraded(true)
	end
end)

rp.AddCommand('/removecoowner', function(pl, text, args)
	local ent = pl:GetEyeTrace().Entity
	local co = rp.FindPlayer(args[1])

	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(pl) and (co ~= nil) and ent:DoorCoOwnedBy(co) and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) then
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('DoorOwnerRemoved'), co)
		rp.Notify(co, NOTIFY_GREEN, rp.Term('DoorOwnerRemovedYou'), pl)
		ent:DoorUnCoOwn(co)
	end
end)

rp.AddCommand('/selldoor', function(pl, text, args)
	local ent = pl:GetEyeTrace().Entity

	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(pl) and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) then
		pl:AddMoney(rp.cfg.DoorCostMin)
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('DoorSold'), rp.FormatMoney(rp.cfg.DoorCostMin))
		ent:DoorUnOwn(pl)
	end
end)

rp.AddCommand('/settitle', function(pl, text, args)
	if (text == '') then return end
	local ent = pl:GetEyeTrace().Entity

	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(pl) and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) then
		rp.Notify(pl, NOTIFY_GENERIC, rp.Term('DoorTitleSet'))
		ent:DoorSetTitle(string.sub(text, 1, 25))
	end
end)

rp.AddCommand('/orgown', function(pl, text, args)
	local ent = pl:GetEyeTrace().Entity

	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(pl) and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) and pl:GetOrg() then
		rp.Notify(pl, NOTIFY_GENERIC, (ent:DoorOrgOwned() and rp.Term('OrgDoorDisabled') or rp.Term('OrgDoorEnabled')))
		ent:DoorSetOrgOwn(not ent:DoorOrgOwned())
	end
end)

rp.AddCommand('/sellall', function(pl, text, args)
	if (pl:GetVar('doorCount') or 0) <= 0 then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('NoDoors'))

		return
	end

	local count = pl:GetVar('doorCount')
	local amt = (count * rp.cfg.DoorCostMin)
	pl:DoorUnOwnAll()
	pl:AddMoney(amt)

	pl:SetVar('doorCount', 0)

	rp.Notify(pl, NOTIFY_GREEN, rp.Term('DoorsSold'), count, rp.FormatMoney(amt))
end)

hook('nw.EntityRemoved', 'rp.doors.EntityRemove', function(ent)
	if ent:IsVehicle() && IsValid(ent:DoorGetOwner()) then
		local pl = ent:DoorGetOwner()
		pl:SetVar('doorCount', pl:GetVar('doorCount')-1, false, false)
	end
end)