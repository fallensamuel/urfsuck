-- "gamemodes\\rp_base\\gamemode\\main\\npcs\\init_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--[[
	Chessnut's NPC System
	Do not re-distribute without author's permission.

	Revision f9eac7b3ccc04d7a7834987aea7bd2f9cb70c8e0a58637a332f20d1b3d2ad790
--]]

cnPanels = cnPanels or {}

net.Receive("npcOpen", function()
	local index = net.ReadUInt(14)
	local entity = Entity(index)

	if (!IsValid(entity)) then
		return
	end

	local uniqueID = entity:GetQuest()
	
	if (!cnQuests[uniqueID]) then
		return
	end

	cnQuests[uniqueID].Menu = vgui.Create("cnQuest")
	cnQuests[uniqueID].Menu:SetSkin('SUP')

	cnPanels.quest.entity = entity
	cnPanels.quest.questID = uniqueID
	cnPanels.quest:setup(uniqueID)

	if (cnQuests[uniqueID].onStart) then
		cnQuests[uniqueID]:onStart()
	end
end)

net.Receive("npcDatA", function()
	local uniqueID = net.ReadString()
	local questID = net.ReadString()
	local arguments = net.ReadTable()
	local panel = cnPanels.quest

	if (!IsValid(panel) or panel.questID != questID) then
		return
	end

	local data = cnQuests[panel.questID]

	if (data and type(data["on"..uniqueID]) == "function") then
		data["on"..uniqueID](data, unpack(arguments))
	end
end)

net.Receive("npcClose", function()
	local questID = net.ReadString()
	local panel = cnPanels.quest

	if (IsValid(panel) and panel.questID == questID) then
		panel:Remove()
	end
end)
