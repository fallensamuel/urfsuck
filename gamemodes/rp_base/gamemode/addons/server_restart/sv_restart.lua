util.AddNetworkString("_AntiCrash")

timer.Create("AntiCrash", 5, 0, function()
	net.Start("_AntiCrash")
	net.Broadcast()
end) 

util.AddNetworkString("server_restart")

local function SendRestartBanner(ply, minutes)
	local time = _SERVER_RESTART_TIME
	if not time then return end
	minutes = minutes or math.Round((time - CurTime())/60)

	net.Start("server_restart")
		net.WriteUInt(minutes, 3)
	if ply == true then
		net.Broadcast()
	else
		net.Send(ply)
	end
end

function ReturnSpawnedPrintersToInventory(ply)
	if not ply.SpawnedPrinters then return end
	
	for k, ent in pairs(ply.SpawnedPrinters) do
		if IsValid(ent) then
			--local itemTable = ent:getItemTable()
			--if not itemTable then continue end

			local item = ent.item
			if not item then print("ERR1") continue end

			if not item.entity then
				item.entity = ent
			end

    		if item.noTake then print("ERR2") continue end

    		if ent.TakingItem then print("ERR3") continue end
			if item.CanTake then
				if item.CanTake(item, ply) == false then print("ERR4") continue end 
			end
			ent.TakingItem = true

			local status, result = ply:getInv():add(item.id)
			ply.SpawnedPrinters[k] = nil

			if (!status) then
				ent.TakingItem = nil
				print("ERR5")
				continue
			else
				if (item.data) then
					for k, v in pairs(item.data) do
						item:setData(k, v)
					end
				end

				rp.item.RunGesture(ply, ACT_PICKUP_GROUND)
						
				hook.Run("Inventory.OnItemTake", item)
			end

			SafeRemoveEntity(ent)
			item.entity = nil
		end
	end

	ply.SpawnedPrinters = {}
end

local function ServerRestart()
	_SERVER_RESTART_TIME = CurTime() + 300

	--for k, ply in pairs(player.GetHumans()) do
		SendRestartBanner(true, 5)
	--end

	timer.Create("ServerRestart_3Min", 120, 1, function()
		SendRestartBanner(true, 3)
	end)

	timer.Create("ServerRestart_1Min", 240, 1, function()
		SendRestartBanner(true, 1)
	end)

	timer.Create("ServerRestart_Save", 290, 1, function() -- МБ вывести в ПМЕТА функцию и заюзать в urf reload и urf restart ?
		ba.notify_all( ba.Term("ServerRestartSAVE") )
		for k, ply in pairs(player.GetHumans()) do
			rp.syncHours.Save(ply)
			rp.data.SaveUnlocks(ply)
			ply:SaveJobRecovery()
			ReturnSpawnedPrintersToInventory(ply)
		end
	end)
end

--concommand.Add("~server_restart", function(idk) -- отладочная кмд
--	if IsValid(idk) then return end
--	ServerRestart()
--end)

timer.Create("ServerRestart", 5, 0, function()
	if file.Exists("server.restart", "DATA") then
		file.Delete("server.restart")
		ServerRestart()
	end
end)

hook.Add("PlayerAuthed", "ServerRestartBanner", function(ply)
	ply.SpawnedPrinters = {}
	
	SendRestartBanner(ply)

	if _SERVER_RESTART_TIME and (_SERVER_RESTART_TIME - CurTime()) >= 120 then
		local seconds = _SERVER_RESTART_TIME - CurTime()
		timer.Simple(seconds - 60, function()
			if IsValid(ply) then
				SendRestartBanner(ply, 1)
			end
		end)
	end
end)

hook.Add("Inventory.OnItemDrop", "SavePrintersAfterRestart", function(item, ply, ent)
	if not IsValid(ent) then
		ent = item.entity
		if not IsValid(ent) then return end	
	end

	if string.find(item.uniqueID, "printer") or string.find(item.uniqueID, "print") then
		ply.SpawnedPrinters = ply.SpawnedPrinters or {}
		ent.item = item
		ent.PrintersCahceIndex = table.insert(ply.SpawnedPrinters, ent)
	end
end)

hook.Add("Inventory.OnItemTake", "SavePrintersAfterRestart", function(item)
	if IsValid(item.entity) and item.entity.PrintersCahceIndex and IsValid(item.player) then
		item.player.SpawnedPrinters[ item.entity.PrintersCahceIndex ] = nil
	end
end)

concommand.Add("~server_restart", function(ply)
	if IsValid(ply) then return end
	ServerRestart()
end)