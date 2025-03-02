hook.Add("PlayerUse", "ItemInteract_Fix", function(ply, ent)
	if not IsValid(ent) or not ent:GetNWBool("isInvItem") then return end

	local tr_ent = ply:GetEyeTrace().Entity
	if ent.DisableUse or ent ~= tr_ent then return false end
end)
--[[
	Такое происходит когда игрок кликает [E] рядом с энтити.
	ПО невероятному стечению обстоятельств [E] рядом с item энтити вызвает ent:use
	Мне не удалось выяявить причину, но такой фикс выходит не хуже.
]]--

hook.Add( "PlayerDisconnected", "rp.UnEquipAllItems", function( client )
	--[[ seems like its not working?
	local invID = client:getInvID()
	for k,v in pairs(rp.item.instances) do
		if v.invID == invID then
			v:setData("equip", nil)
		end
	end
	]]--

	local inv = client:getInv();
	if not inv or not inv.getItems then return end

	for k, v in pairs( inv:getItems() or {} ) do
		if v.data.equip then
			v:setData( "equip", nil );
		end

		rp.item.instances[v.id] = nil;
	end
end );

local function weighted_random(obj)
	local rand_sum = 0
	
	for k, v in pairs(obj) do
		rand_sum = rand_sum + v.procent
	end
	
	local rand = math.Rand(0, rand_sum)
	local prev = 0
	
	for k, v in pairs(obj) do
		if rand >= prev and rand <= v.procent + prev then
			return v
		end
		
		prev = prev + v.procent
	end
end

function rp.GenerateLoot(count, type_loot)
	local listLoot = rp.item.loot[type_loot]
	local bagLoot = {}

	count = count or 1
	for i=1,count do
		local randomItem = weighted_random(listLoot.items)
		if randomItem then 
			bagLoot[i] = randomItem.item
		end
	end
	return bagLoot
end

local SpawnedDynamicLoot = SpawnedDynamicLoot or {};

function SpawnLootEntity(item_type, model, pos, ang, maxCount, type_loot, cback, iterator, hide_when_empty)
	rp.item.spawn(item_type, pos, function(item, entity)
		if IsValid(entity) then
			entity:SetNWBool("islootentity", true)
			entity.LootType = type_loot
		end

		local i1 = iterator;
		item.accessCallback = function()
		--timer.Simple(5, function()
			--print('box spawned', entity, item:getInv())
			if not IsValid(entity) then return end
			
			item:getInv().owner = -1;

			for b,x in pairs(rp.GenerateLoot(maxCount, type_loot)) do
				timer.Simple(b,function()
					item:getInv():add(x.uniqueID)
				end)
			end
			timer.Create("respawnLoot"..entity:EntIndex(), rp.cfg.TimeRespawnLoot, 0, function()
				local inv = item:getInv()
				if inv:getCountItems() >= maxCount then return end
				for b,x in pairs(rp.GenerateLoot(1, type_loot)) do
					timer.Simple(b,function()
						inv:add(x.uniqueID)
					end)
				end
			end)

			if hide_when_empty then
				timer.Create("checkLootBodyGroup"..entity:EntIndex(), 1, 0, function()
					local inv = item:getInv()
					if not IsValid(entity) then return end

					local b = inv:IsEmpty()
					entity:SetNoDraw(b)
					entity:SetNotSolid(b)
					entity.DisableUse = b
				end)
			else
				timer.Create("checkLootBodyGroup"..entity:EntIndex(), 1, 0, function()
					local inv = item:getInv()
					if not IsValid(entity) then return end
					if inv:IsEmpty() then
						entity:SetBodygroup(1, 1)
					else
						entity:SetBodygroup(1, 0)
					end
				end)
			end
			
			entity:SetModel(model)
		    --entity:SetSolid(SOLID_BBOX)
			--entity:SetSolid(SOLID_VPHYSICS)
			entity:PhysicsInit(SOLID_VPHYSICS)
			entity:SetMoveType(MOVETYPE_NONE)
			entity:SetCollisionGroup(COLLISION_GROUP_NONE)

			if IsValid(entity:GetPhysicsObject()) then
				entity:GetPhysicsObject():Sleep()
				entity:GetPhysicsObject():EnableMotion(false)
			end

		    entity.NoDamage = true
			
			if rp.item.loot[type_loot].func then
				rp.item.loot[type_loot].func(entity)
			end
						
			if cback then
				cback(entity)
			end

			if (i1) then 
				SpawnedDynamicLoot[i1] = true;
				//print(i1, SpawnedDynamicLoot[i1])
			end
		--end)
		end
	end, ang)
end

function rp.SpawnLoot()
	if not rp.cfg.SpawnPositionLoot[game.GetMap()] then return end
	for k,v in pairs(rp.cfg.SpawnPositionLoot[game.GetMap()]) do
		SpawnLootEntity(v.basebox or "box_loot", v.model, v.pos, v.ang, v.maxCount, v.type)
	end
end

local NumOfDynamicProps = 0;

function rp.SpawnLootPropDynamic()
	local propDynamicLootModels = rp.cfg.PropDynamicLootModels[game.GetMap()]
	if propDynamicLootModels == nil then return end
	
	local propDynamics = ents.FindByClass("prop_dynamic")
	local propDynamicBackup = table.Copy(propDynamics);
	
	local function proccess(iterator, source)
		local v = propDynamics[iterator]
		if (source) then
			v = source[iterator]
		end
		if not v then return end
		
		local prop_dynamic = propDynamicLootModels[v:GetModel()]
		
		if prop_dynamic ~= nil then
			if (source) then print('re-creating box under id ' .. iterator); end
			NumOfDynamicProps = NumOfDynamicProps + 1;

			local propskin = v:GetSkin()
			SpawnLootEntity(prop_dynamic.basebox or "box_loot", v:GetModel(), v:GetPos(), v:GetAngles(), prop_dynamic.maxCount, prop_dynamic.type, function(ent)
				if (!source) then 
					proccess(iterator + 1)
				end
				if IsValid(ent) then
					ent:SetSkin(propskin)
				end
			end, iterator)
			v:Remove()
		else
			if (source) then return end
			proccess(iterator + 1)
		end
	end

	timer.Remove('tim-spawned-loots-check');
	timer.Create('tim-spawned-loots-check', 600, 0, function()
		//print(#table.GetKeys(SpawnedDynamicLoot), NumOfDynamicProps);
		if (#table.GetKeys(SpawnedDynamicLoot) < NumOfDynamicProps) then
			for i = 1, NumOfDynamicProps do
				if (!SpawnedDynamicLoot[i]) then
					proccess(i, propDynamicBackup);
				end
			end
		else
			print('all boxes successful spawned! :)');
			timer.Remove('tim-spawned-loots-check');
		end
	end);

	proccess(1)
	
	--[[
	for k,v in pairs(ents.FindByClass("prop_dynamic")) do
		local prop_dynamic = propDynamicLootModels[v:GetModel()]
		if prop_dynamic ~= nil then
			SpawnLootEntity(prop_dynamic.basebox or "box_loot", v:GetModel(), v:GetPos(), v:GetAngles(), prop_dynamic.maxCount, prop_dynamic.type)
			v:Remove()
		end
	end
	]]
end

hook.Add("InitPostEntity","rp.SpawnLoot",function()
	--rp._Inventory:Query("SELECT * FROM inventories WHERE _invType = 'box_loot' OR _invType = 'box_combine' OR _invType = 'box_rabel';", function(inventories)
		
		local zero_invs = {}
		
		local function proccess(iterator)
			if not zero_invs[iterator] then 
				rp._Inventory:Query("DELETE FROM items WHERE _invID = 0;", function()
					print('Old zero-invs deleted successfuly!')
					
					timer.Simple(1, function()
						rp.SpawnLootPropDynamic()
						rp.SpawnLoot()
					end)
				end)
				
				return 
			end
			
			--print('Deleting ' .. iterator .. ':', zero_invs[iterator]['_invID'])
			
			rp._Inventory:Query("DELETE FROM inventories WHERE _invID = ? LIMIT 1;", zero_invs[iterator]['_invID'], function()
				rp._Inventory:Query("DELETE FROM items WHERE _invID = ?;", zero_invs[iterator]['_invID'], function()
					proccess(iterator + 1)
				end)
			end)
		end
		
		rp._Inventory:Query("SELECT _invID FROM inventories WHERE _charID = 0 OR _invType = 'npc_loot';", function(invs)
			if invs and #invs > 0 then 
				zero_invs = invs
			end
			
			print('Processing ' .. (#invs) .. ' zero-invs...')
			
			proccess(1)
		end)
		
		--rp._Inventory:Query("DELETE FROM inventories WHERE _charID = 0;") -- OPTIMIZE
		--rp._Inventory:Query("DELETE FROM items WHERE _uniqueID LIKE 'box_%' OR _invID = 0;")
		
		
		--for k,v in pairs(inventories) do
		--	rp._Inventory:Query("DELETE FROM items WHERE _invID = "..v._invID..";")
		--end
		
		--timer.Simple(10,function()
		--	rp.SpawnLootPropDynamic()
		--	rp.SpawnLoot()
		--end)
	--end)

	--rp._Inventory:Query("DELETE FROM inventories WHERE _invType = 'box_shop';")
	--rp._Inventory:Query("SELECT * FROM items WHERE _uniqueID = 'box_shop' AND _invID = 0;", function(items)
		--for k,v in pairs(items) do
		--	rp._Inventory:Query("DELETE FROM items WHERE _invID = "..util.JSONToTable(v._data).id..";")
		--end
		--rp._Inventory:Query("DELETE FROM items WHERE _uniqueID = 'box_shop' AND _invID = 0;")
	--end)
end)

hook.Add("EntityTakeDamage","rp.InventoryItemNoDamage",function(target, dmg)
	if target:GetNWBool("isInvItem") and target.NoDamage then
		return true
	end
end)

local f = math.floor
local format = function(a, b, c)
	return f(a) .." ".. f(b) .." ".. f(c)
end

function rp.AddLootable(mdl, pos, ang, count, type, callback, hide_when_empty)
	callback = callback or function() end
	pos = format(pos.x, pos.y, pos.z)

	rp._Stats:Query("SELECT `Type` FROM `lootables` WHERE `Vector` = '"..pos.."';", function(data)
		if data[1] then
			rp._Stats:Query("UPDATE lootables SET Type = ?, HideWhenEmpty = ? WHERE Vector = '"..pos.."';", type, (hide_when_empty and 1 or 0), function()
				callback(2)
			end)
			return
		end

		ang = format(ang.p, ang.y, ang.r)
		rp._Stats:Query("INSERT INTO lootables(Model, Vector, Angle, Count, Type, HideWhenEmpty) VALUES(?, ?, ?, ?, ?, ?);", mdl, pos, ang, count, type, (hide_when_empty and 1 or 0))
		callback(1)
	end)
end

function rp.RemoveLootable(pos, callback)
	callback = callback or function() end
	pos = format(pos.x, pos.y, pos.z)

	rp._Stats:Query("DELETE FROM lootables WHERE Vector = '"..pos.."';", callback)
end

hook.Add("InitPostEntity", "SpawnLootablesFromSQL", function()
	rp._Stats:Query("CREATE TABLE IF NOT EXISTS `lootables` (`Model` TEXT CHARACTER SET utf8 NOT NULL, `Vector` varchar(32) CHARACTER SET utf8 NOT NULL, `Angle` varchar(32) CHARACTER SET utf8 NOT NULL, `Count` int(4) NOT NULL, `Type` varchar(32) CHARACTER SET utf8 NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;")
	rp._Stats:Query("ALTER TABLE `lootables` ADD COLUMN `HideWhenEmpty` TINYINT(1);")

	rp._Stats:Query("SELECT * FROM `lootables`;", function(data)
		if #data < 1 then return end

		local i = 0
		timer.Create("LootablesLoading", 0, #data, function()
			i = i + 1
			local v = data[i]
			if not v then return end

			local pos = string.Split(v.Vector, " ")
			pos = Vector(pos[1], pos[2], pos[3])

			local ang = string.Split(v.Angle, " ")
			ang = Angle(ang[1], ang[2], ang[3])

			SpawnLootEntity("box_loot", v.Model, pos, ang, v.Count, v.Type, nil, nil, tobool(v.HideWhenEmpty))
		end)
	end)
end)