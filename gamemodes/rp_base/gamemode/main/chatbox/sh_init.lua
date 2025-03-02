-- "gamemodes\\rp_base\\gamemode\\main\\chatbox\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local disabled = false
if disabled then return end

AddCSLuaFile()
CHATBOX = {}
SIMPLE_CHATBOX = {}
CHATBOX.IsNewChatbox = true

if CLIENT then
	CHATBOX.EmoteBackends = { ["urf.im"] = true, ["api.urf.im"] = true };

	local function http_Lookup( url )
		local proto, domain = string.match( url, "(https?)://(.+%.%w+)/?" );
		return proto, domain;
	end

	local function http_ProtectedFetch( url, success, failure, headers, check, timeout )
		local proto, domain = http_Lookup( url );
		url = string.gsub( url, "^" .. proto, "http" );

		timeout = timeout or 15;

		local start = SysTime();
		local nx_domain = next( CHATBOX.EmoteBackends, domain );
		local tuid = "ce-" .. util.MD5( url .. start );

		timer.Create( tuid, timeout, 1, function()
			if not nx_domain then
				if failure then failure( "not passed" ); end
				return
			end

			local nx_url = string.gsub( url, domain, nx_domain );
			http_ProtectedFetch( nx_url, success, failure, headers, check );
		end );

		http.Fetch( url,
			function( ... )
				if (SysTime() - start) > timeout then return end
				timer.Remove( tuid );

				if check then
					if check( ... ) == false then
						if not nx_domain then
							if failure then failure( "not passed" ); end
							return
						end

						local nx_url = string.gsub( url, domain, nx_domain );
						http_ProtectedFetch( nx_url, success, failure, headers, check );
						return
					end
				end

				if success then
					return success( url, ... );
				end
			end,
			function( ... )
				if (SysTime() - start) > timeout then return end
				timer.Remove( tuid );

				if not nx_domain then
					if failure then failure( "not passed" ); end
					return
				end

				local nx_url = string.gsub( url, domain, nx_domain );
				http_ProtectedFetch( nx_url, success, failure, headers, check );
			end,
			headers
		);
	end

	CHATBOX.AllowedChars = {[" "] = true}

	timer.Simple(1, function() -- utf8 долго инклюдиться :(
	    local AllowedChars = {}

	    if not rp.cfg.IsFrance then
	        AllowedChars = {"а", "б", "в", "г", "д", "е", "ё", "ж", "з", "и", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ъ", "ы", "ь", "э", "ю", "я"}
	    end

	    for i = 97, 122 do -- eng
	        table.insert(AllowedChars, string.char(i))
	    end

	    for _, char in pairs(AllowedChars) do
	        CHATBOX.AllowedChars[utf8.upper(char)] = true
	        CHATBOX.AllowedChars[char] = true
	    end
	end)

    local symbols = "!\"#$%&'()*+,-./0123456789:;<=>?@[\\]^_`{|}~—–»«"
    for s in symbols:gmatch(".") do
        CHATBOX.AllowedChars[s] = true
    end

    if rp.cfg.IsFrance then
        for _, char in pairs({"â", "à", "ç", "é", "ê", "ë", "è", "ï", "î", "ô", "û", "ù", "Ù", "À", "Â", "Û", "Ü", "Æ", "Ç", "Ÿ", "É", "€", "È", "Ê", "Ë", "Ï", "Î", "Ô", "Œ"}) do
            CHATBOX.AllowedChars[char] = true
        end
    end

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
	CHATBOX.RegisterEmotesDelay = 0;

	function CHATBOX:RegisterEmotesViaAPI( url, ... )
		local args = { ... };

		timer.Simple( CHATBOX.RegisterEmotesDelay, function()
			if not CHATBOX then return end

			CHATBOX.RegisterEmotesDelay = CHATBOX.RegisterEmotesDelay - 1.5;

			http_ProtectedFetch( url, function( site, body )
				local emotes = util.JSONToTable( body );
				if not emotes then return end

				for k, emote in pairs( emotes ) do
					local emoteurl = site .. emote .. ".png";
					CHATBOX:RegisterEmote( emote, nil, emoteurl, unpack(args) );
				end
			end, nil, nil, function( body )
				local status = util.JSONToTable( body );
				if not status then return false; end
			end );
		end );

		CHATBOX.RegisterEmotesDelay = CHATBOX.RegisterEmotesDelay + 1.5;
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

					if mat:IsError() then
						return
					end

					table.insert(CHATBOX.PreviewEmotes, mat)
				end)
			end
		elseif path then
			mat = Material(path, "smooth noclamp")
		end

		if mat then
			if mat:IsError() then
				return
			end

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
rp.include_cl("src/cl_simple_chatbox.lua")
rp.include_cl("src/cl_colors.lua")

rp.include_sv("src/sv_chatbox.lua")

--if rp.cfg.CHATBOX then
--	for k, v in pairs(rp.cfg.CHATBOX) do
--		CHATBOX[k] = v
--	end
--end