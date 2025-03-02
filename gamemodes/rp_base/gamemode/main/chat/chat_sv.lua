include('chat_sh.lua')
util.AddNetworkString'rp.ChatMessage'
util.AddNetworkString'rp.RunCommand'
util.AddNetworkString'rp.PlayerSay'

local color_green = Color(0, 255, 0)

local typeKeys = {
	['string'] = 0,
	['table'] = 1,
	['player'] = 2,
	['number'] = 3
}

local writeFuncs = {
	['string'] = net.WriteString,
	['table'] = function(col)
		net.WriteUInt(col.r, 8)
		net.WriteUInt(col.g, 8)
		net.WriteUInt(col.b, 8)
	end, -- we assume you're a color.
	['player'] = net.WritePlayer,
	['number'] = function(n)
		net.WriteUInt(n, 6)
	end
}

local function writeChat(tbl)
	net.WriteUInt(#tbl, 5)

	for k, v in ipairs(tbl) do
		local t = type(v):lower()
		net.WriteUInt(typeKeys[t], 2)
		writeFuncs[t](v)
	end
end

function rp.Chat(chatType, filter, ...)
	net.Start('rp.ChatMessage')
	net.WriteUInt(chatType, 4)
	writeChat({...})
	net.Send(filter)
end

function rp.LocalChat(chatType, pl, radius, ...)
	rp.Chat(chatType, table.Filter(ents.FindInSphere(pl:EyePos(), radius), function(v) return v:IsPlayer() end), ...)
	--rp.Chat( chatType, table.Add( {pl}, table.GetKeys(pl.CanHear) ), ... );
end

function rp.GlobalChat(chatType, ...)
	rp.Chat(chatType, player.GetAll(), ...)
end

function rp.groupChat(pl, text)
	for _, p in ipairs(player.GetAll()) do
		if rp.groupChats[pl:GetJob()] and rp.groupChats[pl:GetJob()][p:GetJob()] then
			rp.Chat(CHAT_GROUP, p, color_green, rp.cfg.GroupChatPrefix or '[Group]', pl, text)
		end
	end
end

local function runcommand(pl, cmd, args)
	if rp.data.IsLoaded(pl) then
		if pl:IsPlayer() and pl.NextConCommand and pl.NextConCommand > CurTime() then return end
		pl.NextConCommand = CurTime() + 0.1
		
		local arg_str = table.concat(args, ' ')
		hook.Call('PlayerRunRPCommand', nil, pl, cmd, args, arg_str)
		rp.commands[cmd](pl, arg_str, args)
	end
end

function GM:PlayerSay(pl, text, teamonly, dead)
	text = string.Trim(text)
	if pl:IsBanned() or (text == '') then return '' end
	local args = string.Explode(' ', text)
	local cmd = args[1]:lower()
	table.remove(args, 1)

	if teamonly then
		rp.groupChat(pl, text)

		return ''
	end

	if rp.commands[cmd] then
		runcommand(pl, cmd, args)

		return ''
	end

	local ret = ba.cmd.PlayerSay(pl, text)
	if (ret == '') then return '' end
	rp.LocalChat(CHAT_LOCAL, pl, 250, pl, text)

	return ''
end

local last_uses = {}
net('rp.RunCommand', function(len, pl)
	if last_uses[pl:SteamID()] and last_uses[pl:SteamID()] > CurTime() then
		return rp.Notify(pl, NOTIFY_ERROR, rp.Term('DontUseCommandsSoFast'))
	end
	
	last_uses[pl:SteamID()] = CurTime() + 0.5
	
	local args = {}

	for i = 1, net.ReadUInt(4) do
		args[i] = net.ReadString()
	end

	local cmd = '/' .. args[1]:lower()

	if args[1] and (not pl:IsBanned()) then
		if rp.commands[cmd] then
			table.remove(args, 1)
			runcommand(pl, cmd, args)
		end
	end
end)

net('rp.PlayerSay', function(len, pl)
	local text = string.Trim(net.ReadString())
	
	if utf8.len(text) > 512 then 
		text = utf8.sub(text, 1, 512)
	end
	
	local teamonly = net.ReadBool()

	if pl:IsBanned() or pl:IsChatMuted() or (text == '') then return end

	local args = string.Explode(' ', text)
	local cmd = args[1]:lower()
	table.remove(args, 1)

	if teamonly then
		rp.groupChat(pl, text)
		return
	end

	if rp.commands[cmd] then
		runcommand(pl, cmd, args)
		return
	end

	local ret = ba.cmd.PlayerSay(pl, text)
	if (ret == '') then return end

	rp.LocalChat(CHAT_LOCAL, pl, 250, pl, text)
end)