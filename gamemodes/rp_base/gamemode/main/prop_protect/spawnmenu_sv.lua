if rp.cfg.DisableQEntities then return end
local Split = string.Split
local Right = string.Right
local Sub = string.sub
local Get = ents.FindByClass

local function spawn_it(Player, Class)
    if Player:HasBlockedInventory() then return false end

    --print(#(Get(Class) or {}), rp.QObjects[Class].worldlimit)
    --print(Player:GetCount(Class), rp.QObjects[Class].limit)
    local obj = rp.QObjects[Class]
    if obj then
        local cur_count = #(Get(Class) or {})

        if obj.Access and not obj.Access(ply, obj) then return false end

        if obj.price then
            if Player:GetMoney() < obj.price then
                rp.Notify(Player, NOTIFY_RED, rp.Term("Vendor_cantpay"))
                return false
            end
        end

        if obj.also_check then
            for k, v in pairs(obj.also_check) do
                --PrintTable(Get(v))
                cur_count = cur_count + #(Get(v) or {})
            end
        end

        if cur_count < obj.worldlimit then
            local Time = (obj.time or 0) - Player:GetCustomPlayTime('QEntities')
            local local_count = Player:GetCount(Class)

            if obj.also_check then
                for k, v in pairs(obj.also_check) do
                    local_count = local_count + Player:GetCount(v)
                end
            end

            if (Time <= 0 and local_count < obj.limit and Player:GetCount('qspawnedents') < rp.cfg.PlayerObjectLimit) then
                if obj.is_item then
                    local item_max = rp.item.list[Class] and rp.item.list[Class].max or 5

                    if item_max <= Player:getInv():getItemCount(Class) + local_count then
                        Player:Notify(0, translates.Get("Вы достигли максимума!"))

                        return false
                    end

                    if obj.price then Player:AddMoney(-obj.price) end
                    rp.item.spawn(Class, Player, function(item, entity)
                        if IsValid(entity) then
                            undo.Create("rp_item")
                            undo.AddEntity(entity)
                            undo.SetPlayer(Player)
                            undo.Finish()
                            Player:AddCount(Class, entity)
                            Player:AddCount('qspawnedents', entity)

                            if IsValid(entity:GetPhysicsObject()) then
                                entity:GetPhysicsObject():EnableMotion(true)
                                entity:GetPhysicsObject():Wake()
                            end

                            if obj.on_spawn then
                                obj.on_spawn(entity, item)
                            end

                            --if rp.cfg.AutoGhostAllEnts and not not rp.item.list[Class].NoFreeze then
                                timer.Simple(0.1, function()
									rp.AutoFreezer.Block(entity, true)
									
									timer.Simple(1, function()
										rp.AutoFreezer.AntiPlayerBlock(entity)
									end)
									
									if not (rp.item.list[Class] and rp.item.list[Class].NoFreeze) and not obj.no_freeze then
										if IsValid(entity:GetPhysicsObject()) then
											entity:GetPhysicsObject():EnableMotion(false)
										end
									end
                                end)
                           -- end
                        end
                    end)

                    return false
                end

                return true
            end
        end

        --if !Player:IsRoot() then
        rp.Notify(Player, NOTIFY_ERROR, rp.Term('SboxXLimit'), (baseclass.Get(Class).PrintName or obj.name or Class))
        --end

        return false
    end
end

function rp.SetQCategoryIcon() end

hook.Add('PlayerSpawnSENT', 'SpawnMenu.SpawnEnt', function(Player, Class) return spawn_it(Player, Class) end) --print(Player, Class, 'SENT')
hook.Add('PlayerSpawnNPC', 'SpawnMenu.SpawnNpc', function(Player, Class) return spawn_it(Player, list.Get("NPC")[Class].Class) end) --print(Player, Class, 'NPC')
hook.Add("PlayerSpawnVehicle", "SpawnMenu.SpawnVehicle", function(ply, _, name)
	return spawn_it(ply, name)
end)

local function spawned_it(Player, Entity)
	local class = (Entity.GetVehicleClass or Entity.GetClass)(Entity)
    local obj = rp.QObjects[class]
    if obj then
        Entity.ItemOwner = Player

        --if obj.price then
        --    Player:AddMoney(-obj.price)
        --end

        if obj.on_spawn then
            obj.on_spawn(Entity)
        end
		
        Player:AddCount(class, Entity)
        Player:AddCount('qspawnedents', Entity)
		
		if not Entity:IsNPC() then
			timer.Simple(0.1, function()
				rp.AutoFreezer.Block(Entity, true)
				
				timer.Simple(1, function()
					rp.AutoFreezer.AntiPlayerBlock(Entity)
				end)
				
				if not (rp.item.list[class] and rp.item.list[class].NoFreeze) and not obj.no_freeze then
					if IsValid(Entity:GetPhysicsObject()) then
						Entity:GetPhysicsObject():EnableMotion(false)
					end
				end
			end)
		end
    end
end

hook.Add('PlayerSpawnedSENT', 'SpawnMenu.SpawnedEnt', spawned_it)
hook.Add('PlayerSpawnedNPC', 'SpawnMenu.SpawnedNpc', spawned_it)
hook.Add("PlayerSpawnedVehicle", "SpawnMenu.SpawnedVehicle", function(ply, ent)
	spawned_it(ply, ent)

	local Class = ent:GetVehicleClass()
	if rp.QObjects[Class] and rp.QObjects[Class].on_spawn then
        rp.QObjects[Class].on_spawn(ent)
    end
end)

hook.Add("CanPlayerEnterVehicle", "QmenuChairs", function(ply, veh)
    --ply:SetAllowWeaponsInVehicle(not (veh.IsQMenuChair or false))
	if veh.IsQMenuChair then
		ply:SetAllowWeaponsInVehicle(false)
		veh._QMenuChairPos = ply:GetPos()
	end
end)

hook.Add("PlayerEnteredVehicle", "QmenuChairs", function(ply, veh)
	if veh.IsQMenuChair and veh._QMenuChairPos then
		veh.QMenuChairPos = veh._QMenuChairPos
		veh._QMenuChairPos = nil
	end
end)

hook.Add("PlayerLeaveVehicle", "QmenuChairs", function(ply, veh)
	if veh.IsQMenuChair and veh.QMenuChairPos then
		ply:SetPos(veh.QMenuChairPos)
		veh.QMenuChairPos = nil
	end
end)


concommand.Add("gm_buyammo", function(ply, cmd, args)
    local type = args[1]
    if type == nil or rp.QAmmo[type] == nil then return end

    local obj = rp.QAmmo[type]

    if obj.Access and not obj.Access(ply, obj) then return end

    if obj.price then
        if ply:GetMoney() < obj.price then
            rp.Notify(ply, NOTIFY_RED, rp.Term("Vendor_cantpay"))
            return
        end

        ply:AddMoney(-obj.price)
    end

    local amount = obj.amout or 30
    ply:GiveAmmo(amount, type, obj.hidepopup)
    rp.Notify(ply, NOTIFY_GREEN, rp.Term("QMenuAmmoBuyed"), amount, rp.FormatMoney(obj.price))
end)