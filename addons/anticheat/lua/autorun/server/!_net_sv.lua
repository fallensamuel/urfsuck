local read = file.Read
local open = file.Open

function file.Read(name, path)
	if path == nil or path == "DATA" then 
		return read(name, path)
	else
		return ""
	end
end

function file.Open(name, mode, path)
	if path == nil or path == "DATA" then 
		return open(name, mode, path)
	else
		return ""
	end
end

local date = os.date("%d_%m_%Y", os.time())

file.CreateDir('ac')
file.Append("ac/sc_hack_log_" .. date .. ".txt", '')

local log = ""

local function LogAdd( ... )
	local args, r = { ... }, ""
	for _, v in pairs(args) do
		if type(v) == "player" then r = r .. v:Name() .. "[" .. v:SteamID() .. "]"
		else r = r .. tostring(v) end
	end
	log = log .. os.date("[%d/%m/%Y %H:%M]", os.time()) .. r .. "\n"
	return r
end

timer.Create("_savelog", 5, 0, function()
	file.Append("ac/sc_hack_log_" .. date .. ".txt", log)
	log = ""
end)

LogAdd("Antihack initialize...")

local function Warn(pl, code, ...)
	--pl:EmitSound("rp/alert.ogg")
	local r = LogAdd(pl, desc[code], ...)
	pl:Kick(r)
end

OldNWIncoming = OldNWIncoming or net.Incoming

net.Incoming = function(l, pl)
	//if l > 63990 then
	//	LogAdd(pl, " sent large net packet [", l, "b]. Ignoring it.")
	//	return false
	//end
	OldNWIncoming(l, pl)
end

