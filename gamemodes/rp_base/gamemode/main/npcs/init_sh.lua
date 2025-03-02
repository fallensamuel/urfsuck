--[[
	Chessnut's NPC System
	Do not re-distribute without author's permission.

	Revision f9eac7b3ccc04d7a7834987aea7bd2f9cb70c8e0a58637a332f20d1b3d2ad790
--]]

cnQuests = cnQuests or {}

hook.Add("InitPostEntity", "LoadNpcsCfgs", function()
	local npcSound
	local fileWay = engine.ActiveGamemode()

	local _, folders = file.Find(fileWay .. '/gamemode/config/npcs/*', "LUA")

	for k, v in ipairs(folders) do
		NPC = {uniqueID = v}
			if (SERVER) then
				include(fileWay .. '/gamemode/config/npcs/'..v.."/sv_init.lua")
				AddCSLuaFile(fileWay .. '/gamemode/config/npcs/'..v.."/cl_init.lua")
			else
				include(fileWay .. '/gamemode/config/npcs/'..v.."/cl_init.lua")
			end
			
			if (SERVER) then
				function NPC:send(client, uniqueID, ...)
					local entity = client.cnQuest

					if (!IsValid(entity) or client:GetPos():Distance(entity:GetPos()) > 128) then
						return
					end

					net.Start("npcDatA")
						net.WriteString(uniqueID)
						net.WriteString(self.uniqueID)
						net.WriteTable({...})
					net.Send(client)
				end

				function NPC:close(client)
					local entity = client.cnQuest

					if (!IsValid(entity) or client:GetPos():Distance(entity:GetPos()) > 128) then
						return
					end

					net.Start("npcClose")
						net.WriteString(self.uniqueID)
					net.Send(client)

					client.cnQuest = nil
				end
			else
				function NPC:addText(text, fromMe, callback)
					local panel = cnPanels.quest

					if (IsValid(panel)) then
						return panel:addText(text, fromMe == true, callback)
					end
				end

				function NPC:addOption(text, callback, condition)
					local panel = cnPanels.quest

					if (IsValid(panel)) then
						local last, button = panel:addOption(text, callback, condition)
						return last, button
					end
				end

				function NPC:Close(q, w)
					if IsValid(cnPanels.quest) then
						cnPanels.quest:Close(q, w)
					end
				end

				function NPC:clear()
					local panel = cnPanels.quest

					if (IsValid(panel)) then
						return panel:clear()
					end				
				end

				function NPC:send(uniqueID, ...)
					net.Start("npcDatA")
						net.WriteString(uniqueID)
						net.WriteString(self.uniqueID)
						net.WriteTable({...})
					net.SendToServer()
				end

				function NPC:addLeave(text, callback)
					local panel = cnPanels.quest

					if (IsValid(panel)) then
						local last, button = panel:addOption(text or "<Leave>", callback, nil, true)
						return last, button
					end
				end

				function NPC:addGoTo(text, id, condition)
					local panel = cnPanels.quest

					if (IsValid(panel)) then
						local last, button = panel:addGoTo(text, id, condition)
						return last, button
					end
				end

				function NPC:addGoToStart(text, condition)
					self:addGoTo(text, 0, condition)
				end

				function NPC:changeModel(model, seq, isMe)
					local mdl = isMe && cnPanels.quest.me.Entity || cnPanels.quest.model.Entity
					local f_seq = seq
					--print(model, seq, isMe)
					if !seq then
						--print(1)
						f_seq = mdl:GetSequenceName(mdl:GetSequence())
					end
					mdl:SetModel(model)
					mdl:ResetSequence(mdl:LookupSequence(f_seq))
				end

				function NPC:changePlayerModel(model, seq)
					return self:changeModel(model, seq, true)
				end

				function NPC:playSound(play)
					if npcSound then
						--print(npcSound:IsPlaying())
						npcSound:Stop()
					else
						--npcSound = CreateSound(cnPanels.quest.entity, play)
						--npcSound:Play()
						--return
					end
					npcSound = CreateSound(LocalPlayer(), play)
					npcSound:ChangeVolume(1)
					npcSound:SetSoundLevel(90)
					npcSound:Play()
				end

				function NPC:openEmployerMenu(text, faction)
					self:addLeave(text, function(self) rp.OpenEmployerMenu(faction) end)
				end

				function NPC:openRelocateMenu(text, point)
					self:addLeave(text, function() rp.OpenRelocateMenu(point) end)
				end

				function NPC:openTeleportMenu(text, point)
					self:addLeave(text, function() rp.OpenTeleportMenu(point) end)
				end

				function NPC:openTeleportMenu(text, point)
					self:addLeave(text, function() rp.OpenTeleportMenu(point) end)
				end

				function NPC:close()
					local panel = cnPanels.quest

					if (IsValid(panel)) then
						panel:Remove()
					end
				end
			end

			cnQuests[v] = NPC
		NPC = nil
	end
end)
