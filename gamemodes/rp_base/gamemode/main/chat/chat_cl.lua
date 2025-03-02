-- "gamemodes\\rp_base\\gamemode\\main\\chat\\chat_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
include('chat_sh.lua')
local color_white = Color(235, 235, 235)

local readFuncs = {
	[0] = function() return {net.ReadString()} end,
	[1] = function() return {Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))} end,
	[2] = function()
		local pl = net.ReadPlayer()
		if (not IsValid(pl)) then return {Color(150, 150, 150), '(Unknown)', color_white, ': '} end

		local emoji = pl.GetNickEmoji and pl:GetNickEmoji()
		return {team.GetColor(pl:GetJob()), emoji and (':' .. emoji .. ': ' .. pl:Name()) or pl:Name(), color_white, ': '}
	end,
	[3] = function() return {rp.chatcolors[net.ReadUInt(6)]} end
}

local function wasteUInt()
	net.ReadUInt(2)
end

local chatHandlers = {
	[CHAT_LOCAL] = function()
		local numArgs = net.ReadUInt(5)

		if (numArgs == 2) then
			wasteUInt()
			local pl = net.ReadPlayer()
			wasteUInt()
			local text = net.ReadString()

			if IsValid(pl) then
				if (IsValid(CHATBOX)) then
					CHATBOX.DoEmotes = pl:IsVIP()
				end

				local emoji = pl.GetNickEmoji and pl:GetNickEmoji()
				chat.AddText(team.GetColor(pl:Team()), emoji and (':' .. emoji .. ': ' .. pl:Name()) or pl:Name(), color_white, ': ', text)

				hook.Call("ChatRoomMessage", GAMEMODE, CHAT_LOCAL, pl, text)
			end
		else
			-- whisper, yell, me
			wasteUInt()
			local prefixCol = readFuncs[3]()[1]
			wasteUInt()
			local prefix = net.ReadString()
			wasteUInt()
			local pl = net.ReadPlayer()
			wasteUInt()
			local text = net.ReadString()

			if IsValid(pl) then
				if (IsValid(CHATBOX)) then
					CHATBOX.DoEmotes = pl:IsVIP()
				end

				local emoji = pl.GetNickEmoji and pl:GetNickEmoji()
				chat.AddText(prefixCol, prefix, pl:GetJobColor(), emoji and (':' .. emoji .. ': ' .. pl:Name()) or pl:Name(), color_white, ': ', text)

				hook.Call("ChatRoomMessage", GAMEMODE, CHAT_LOCAL, pl, prefix .. text)
			end
		end -- normal
	end,
	[CHAT_PM] = function()
		local numArgs = net.ReadUInt(5)
		wasteUInt()
		local prefixCol = readFuncs[3]()[1]
		wasteUInt()
		local plFrom = net.ReadPlayer()
		wasteUInt()
		local plTo = net.ReadPlayer()
		wasteUInt()
		local msg = net.ReadString()
		if (not IsValid(plFrom) or not IsValid(plTo)) then return end
		local prefix
		local space = " "

		--local plFromEmoji = plFrom.GetNickEmoji and plFrom:GetNickEmoji()
		--local plToEmoji = plTo.GetNickEmoji and plTo:GetNickEmoji()

		--local plFromName = plFromEmoji and (':' .. plFromEmoji .. ': ' .. plFrom:Name()) or plFrom:Name()
		--local plToName = plToEmoji and (':' .. plToEmoji .. ': ' .. plTo:Name()) or plTo:Name()

		local plFromName = plFrom:Name()
		local plToName = plTo:Name()

		if CHATBOX and CHATBOX.IsNewChatbox then
			prefix = ((plTo == LocalPlayer()) and "pm_from " or "pm_to ") --.. plToName
			space = plToName
		else
			prefix = "[PM" .. ((plTo == LocalPlayer()) and "]" or (" > " .. plToName .. "]"))
		end

		if (IsValid(CHATBOX)) then
			CHATBOX.DoEmotes = plFrom:IsVIP()
		end

		chat.AddText(prefixCol, prefix, space, plFrom:GetJobColor(), plFromName, color_white, ': ', msg)
		hook.Call("ChatRoomMessage", GAMEMODE, CHAT_PM, plFrom, plTo, msg)
	end,
	[CHAT_OOC] = function()
		local numArgs = net.ReadUInt(5)
		wasteUInt()
		local prefixCol = readFuncs[3]()[1]
		wasteUInt()
		local prefix = net.ReadString()
		wasteUInt()
		local pl = net.ReadPlayer()
		wasteUInt()
		local text = net.ReadString()

		if IsValid(pl) then
			if (IsValid(CHATBOX)) then
				CHATBOX.DoEmotes = pl:IsVIP()
			end

			local emoji = pl.GetNickEmoji and pl:GetNickEmoji()
			chat.AddText(prefixCol, prefix, pl:GetJobColor(), emoji and (':' .. emoji .. ': ' .. pl:Name()) or pl:Name(), color_white, ': ', text)
			hook.Call("ChatRoomMessage", GAMEMODE, CHAT_OOC, pl, text)
		end
	end,
	[CHAT_CROSSSERVER] = function()
		local numArgs = net.ReadUInt(5)
		wasteUInt()
		local prefixCol = readFuncs[1]()[1]
		wasteUInt()
		local prefix = net.ReadString()
		wasteUInt()
		local plCol = readFuncs[1]()[1]
		wasteUInt()
		local plName = net.ReadString()
		wasteUInt()
		local msgCol = readFuncs[1]()[1]
		wasteUInt()
		local msg = net.ReadString()
		chat.AddText(prefixCol, prefix, plCol, plName, msgCol, msg)

		if (plName == LocalPlayer():Name()) then
			hook.Call("ChatRoomMessage", GAMEMODE, CHAT_CROSSSERVER, LocalPlayer(), msg)
		else
			hook.Call("ChatRoomMessage", GAMEMODE, CHAT_CROSSSERVER, prefix .. plName, msg)
		end
	end,
	[CHAT_GROUP] = function()
		local numArgs = net.ReadUInt(5)
		wasteUInt()
		local prefixCol = readFuncs[1]()[1]
		wasteUInt()
		local prefix = net.ReadString()
		wasteUInt()
		local pl = net.ReadPlayer()
		wasteUInt()
		local msg = net.ReadString()

		if IsValid(pl) then
			if (IsValid(CHATBOX)) then
				CHATBOX.DoEmotes = pl:IsVIP()
			end

			local emoji = pl.GetNickEmoji and pl:GetNickEmoji()
			chat.AddText(prefixCol, prefix, pl:GetJobColor(), emoji and (':' .. emoji .. ': ' .. pl:Name()) or pl:Name(), color_white, ': ', msg)
			hook.Call("ChatRoomMessage", GAMEMODE, CHAT_GROUP, pl, msg)
		end
	end,
	[CHAT_ORG] = function()
		local numArgs = net.ReadUInt(5)
		wasteUInt()
		local prefixCol = readFuncs[1]()[1]
		wasteUInt()
		local prefix = net.ReadString()
		wasteUInt()
		local pl = net.ReadPlayer()
		wasteUInt()
		local msg = net.ReadString()

		if IsValid(pl) then
			if (IsValid(CHATBOX)) then
				CHATBOX.DoEmotes = pl:IsVIP()
			end

			local emoji = pl.GetNickEmoji and pl:GetNickEmoji()
			chat.AddText(prefixCol, prefix, pl:GetJobColor(), emoji and (':' .. emoji .. ': ' .. pl:Name()) or pl:Name(), color_white, ': ', msg)
			hook.Call("ChatRoomMessage", GAMEMODE, CHAT_ORG, pl, msg)
		end
	end,
	[CHAT_RADIO] = function()
		local numArgs = net.ReadUInt(5)
		wasteUInt()
		local prefixCol = readFuncs[3]()[1]
		wasteUInt()
		local prefix = net.ReadString()
		wasteUInt()
		local pl = net.ReadPlayer()
		wasteUInt()
		local msg = net.ReadString()

		if IsValid(pl) then
			if (IsValid(CHATBOX)) then
				CHATBOX.DoEmotes = pl:IsVIP()
			end

			local emoji = pl.GetNickEmoji and pl:GetNickEmoji()
			chat.AddText(prefixCol, prefix, pl:GetJobColor(), emoji and (':' .. emoji .. ': ' .. pl:Name()) or pl:Name(), color_white, ': ', msg)
			hook.Call("ChatRoomMessage", GAMEMODE, CHAT_RADIO, (pl == LocalPlayer() and pl or prefix .. pl:Name()), msg)
		end
	end
}

net('rp.ChatMessage', function()
	local chatType = net.ReadUInt(4)

	if (chatHandlers[chatType]) then
		chatHandlers[chatType]()
	else
		local tbl = {}
		local it = 1

		for i = 1, net.ReadUInt(5) do
			local tbl2 = readFuncs[net.ReadUInt(2)]()

			for k, v in ipairs(tbl2) do
				tbl[it] = tbl2[k]
				it = it + 1
			end
		end

		chat.AddText(unpack(tbl))
	end
end)

local last_command
function rp.RunCommand(...)
	if last_command and last_command > CurTime() then
		return rp.Notify(NOTIFY_ERROR, rp.Term('DontUseCommandsSoFast'))
	end

	last_command = CurTime() + 0.5

	local args = {...}
	net.Start('rp.RunCommand')
	net.WriteUInt(#args, 4)

	for i = 1, #args do
		net.WriteString(tostring(args[i]))
	end

	net.SendToServer()
end

function rp.PlayerSay( text, teamonly )
	local len = utf8.len( text );

	if not len then
		text = utf8.force( text );
		len = utf8.len( text );
	end

	if len > CHAT_MAX_CHARACTERS then
		text = utf8.sub( text, 1, CHAT_MAX_CHARACTERS );
	end

	net.Start( "rp.PlayerSay" );
		net.WriteString( text );
		net.WriteBool( teamonly );
	net.SendToServer();
end

local say_team = {
	["chatbox_say"] = false,
	["chatbox_say_team"] = true
};

local function say( ply, cmd, args )
	local message, idx, bytes, total = {}, 0, {}, #args;

	repeat
		idx = idx + 1;

		local arg = args[idx];

		if pcall( utf8.codepoint, arg, 1, -1 ) then
			message[#message + 1] = arg;
			message[#message + 1] = " ";
		else
			bytes[#bytes + 1] = string.byte( arg );

			local char = string.char( unpack(bytes) );

			if pcall( utf8.codepoint, char ) then
				message[#message + 1], bytes = char, {};
			end
		end
	until idx >= total;

	local text = string.Trim( table.concat(message, "") );
	local bTeam = say_team[string.lower(cmd)];

	rp.PlayerSay( text, bTeam );
end

concommand.Add( "chatbox_say", say );
concommand.Add( "chatbox_say_team", say );

--[[
local function CommandBindToTable( bind, output )
	output = output or {};

	for n, b in ipairs( string.Explode(";", bind) ) do
		b = string.Trim( b );

		local alias = input.TranslateAlias( b );
		if alias then
			CommandBindToTable( alias, output );
			continue
		end

		table.insert( output, b );
	end

	return output;
end

local replacements = {
	["say"] = "chatbox_say",
	["say_team"] = "chatbox_say_team"
};

hook.Add( "PlayerBindPress", "rp.Chat::TranslateBinds", function( ply, bind, pressed )
	if not pressed then return end

	for n, b in ipairs( CommandBindToTable(bind) ) do
		local cmd = string.gsub( b, "^%w+", replacements );
		ply:ConCommand( cmd );
	end

	return true
end );
]]--
