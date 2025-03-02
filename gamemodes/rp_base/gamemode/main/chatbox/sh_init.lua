local disabled = false
if disabled then return end

AddCSLuaFile()
CHATBOX = {}
CHATBOX.IsNewChatbox = true

if CLIENT then
	CHATBOX.Emoticons = {}

	function CHATBOX:RegisterEmote(id, path, url, w, h, restrict)
		self.Emoticons[id] = {
			path = path,
			url = url,
			w = w or 16,
			h = h or 16,
			restrict = restrict,
		}
	end

	CHATBOX.ChatModeList = {}
	CHATBOX.ChatModeCmd2Index = {}

	function CHATBOX:RegisterEmotesViaAPI(url, ...)
		local args = {...} -- зачем? что-бы передать в каллбэк http.Fetch
		http.Fetch(url, function(json) -- подгрузка эмоутов с api закачка происходит только при начале рендеринга
			local tab = util.JSONToTable(json)
			if not tab then return false end

			for i, emote in pairs(tab) do
				local imgurl = url..emote..".png"
				CHATBOX:RegisterEmote(emote, nil, imgurl, unpack(args))
			end
		end)
	end

	function CHATBOX:AddMode(name, NickKey, col, cmd, pattern, howto, hidden, skipnext, realcmd, msgkey, dontclick, additionalcmds)
		local index = table.insert(self.ChatModeList, {
			["name"] = name,
			["col"] = col,
			["cmd"] = cmd,
			["pattern"] = pattern,
			["howto"] = howto,
			["skipnext"] = skipnext,
			["hidden"] = hidden,
			["realcmd"] = realcmd,
			["msgkey"] = msgkey,
			["dontclick"] = dontclick,
			["additionalcmds"] = additionalcmds,
			["NickKey"] = NickKey
		})

		if cmd or realcmd then
			self.ChatModeCmd2Index[(cmd or realcmd) .. " "] = index
		end
		if additionalcmds then
			if istable(additionalcmds) then
				for i, v in pairs(additionalcmds) do
					self.ChatModeCmd2Index[v .. " "] = index
				end
			else
				self.ChatModeCmd2Index[additionalcmds .. " "] = index
			end
		end

		return index, self.ChatModeList[ index ]
	end

	CHATBOX.PreviewEmotes = {}
	CHATBOX.PreviewEmotes_ToDo = {}
	function CHATBOX:AddPreviewEmote(path)
		table.insert(self.PreviewEmotes_ToDo, path)
	end

	local real_func = function(path)
		local url = path:find("https?://[%w-_%.%?%.:/%+=&]+")
		local mat

		if url then
			mat = CHATBOX.GetDownloadedImage(path)
			if not mat then
				CHATBOX.DownloadImage(path, function(img)
					mat = img
					table.insert(CHATBOX.PreviewEmotes, img)
				end)
			end
		elseif path then
			mat = Material(path, "smooth", "noclamp")
		end

		if mat then
			table.insert(CHATBOX.PreviewEmotes, mat)
		end
	end

	-- HACK
	hook.Add("Think", "CHATBOX.PreviewEmotesThink", function()
		if not CHATBOX.GetDownloadedImage then return end

		local k, path = next(CHATBOX.PreviewEmotes_ToDo)

		if path then
			CHATBOX.PreviewEmotes_ToDo[k] = nil
			real_func(path)
		else
			CHATBOX.AddPreviewEmote = real_func
			hook.Remove("Think", "CHATBOX.PreviewEmotesThink")
		end
	end)
end

rp.include_cl("default_config.lua")
hook.Run("Chatbox.LoadConfig", CHATBOX)

rp.include_sh("src/sh_meta.lua")

rp.include_cl("src/cl_utils.lua")
rp.include_cl("src/cl_markups.lua")
rp.include_cl("src/cl_chatbox.lua")
rp.include_cl("src/cl_colors.lua")

rp.include_sv("src/sv_chatbox.lua")

--if rp.cfg.CHATBOX then
--	for k, v in pairs(rp.cfg.CHATBOX) do
--		CHATBOX[k] = v
--	end
--end