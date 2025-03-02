--[[
	Chessnut's NPC System
	Do not re-distribute without author's permission.

	Revision f9eac7b3ccc04d7a7834987aea7bd2f9cb70c8e0a58637a332f20d1b3d2ad790
--]]


util.AddNetworkString("npcOpen")
util.AddNetworkString("npcDatA")
util.AddNetworkString("npcClose")

local function saveQuests()
	local data = {}

	for k, v in ipairs(ents.FindByClass("cn_npc")) do
		data[#data + 1] = {v:GetPos(), v:GetAngles(), v:GetQuest()}
	end

	file.CreateDir("cnrp")
	file.CreateDir("cnrp/quests")
	--print(util.TableToJSON(data))
	--print("cnrp/quests/"..game.GetMap()..".txt")
	file.Write("cnrp/quests/"..game.GetMap()..".txt", util.TableToJSON(data))
end

function loadNPCs()

	for k, v in ipairs(rp.cfg.DialogueNPCs[game.GetMap()] or {}) do
		--print(1)
		local data = cnQuests[v[3]]

		if (data) then
			--print(2)
			if (data.gamemode and data.gamemode:lower() != engine.ActiveGamemode():lower()) then
				continue
			end

			local entity = ents.Create("cn_npc")
			entity:SetPos(v[1])
			entity:SetAngles(v[2])
			entity:Spawn()
			if not data.model then
				PrintTable(data)
			end
			entity:SetModel(data.model)
			entity:SetQuest(v[3])
			entity:setAnim()
		end
	end
end

hook.Add("InitPostEntity", "cnLoadNPC", function()
	timer.Simple(0, function() loadNPCs() end)
end)


concommand.Add("cn_createnpc", function(client, command, arguments)
	if (!ba.IsSuperAdmin(client)) then
		return
	end

	local uniqueID = arguments[1] and arguments[1]:lower() or ""
	local data = cnQuests[uniqueID]

	if (!data) then
		return client:ChatPrint("The NPC type you provided does not exist.")
	end

	if (data.gamemode and data.gamemode:lower() != engine.ActiveGamemode():lower()) then
		return client:ChatPrint("That NPC is not available in this gamemode.")
	end

	local position = client:GetEyeTrace().HitPos
	local angles = (position - client:GetPos()):Angle()
	angles.r = 0
	angles.p = 0
	angles.y = angles.y + 180

	local entity = ents.Create("cn_npc")
	entity:SetPos(client:GetEyeTrace().HitPos)
	entity:SetAngles(angles)
	entity:Spawn()
	entity:SetModel(data.model)
	entity:SetQuest(uniqueID)
	entity:setAnim()

	saveQuests()
end)

concommand.Add("cn_removenpc", function(client, command, arguments)
	if (!ba.IsSuperAdmin(client)) then
		return
	end

	local uniqueID = arguments[1] and arguments[1]:lower()

	if (uniqueID) then
		local i = 0

		for k, v in ipairs(ents.FindByClass("cn_npc")) do
			if (v:GetQuest() == uniqueID) then
				v:Remove()
				i = i + 1
			end
		end

		if (i > 0) then
			saveQuests()
		end
	else
		local entity = client:GetEyeTrace().Entity

		if (IsValid(entity) and entity:GetClass() == "cn_npc") then
			entity:Remove()
			saveQuests()
		end
	end
end)

net.Receive("npcClose", function(length, client)
	client.cnQuest = nil
end)

net.Receive("npcDatA", function(length, client)
	if client.IsCooldownAction and client:IsCooldownAction("npcData", 0.5) then return end
	if table.Count(cnQuests) == 0 then return end
	
	local uniqueID = net.ReadString()
	local questID = net.ReadString()
	local args = net.ReadTable()
	local entity = client.cnQuest

	if (IsValid(entity) and client:GetPos():Distance(entity:GetPos()) <= 128 and entity:GetQuest() == questID) then
		local data = cnQuests[entity:GetQuest()]

		if (data and type(data["on"..uniqueID]) == "function") then
			data["on"..uniqueID](data, client, unpack(args))
		end
	end
end)