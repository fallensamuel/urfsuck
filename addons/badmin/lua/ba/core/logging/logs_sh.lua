ba.logs = ba.logs or {
	Stored 			= {},
	Maping 			= {},
	Data 			= {},
	PlayerEvents 	= {},
}

ba.log_mt			= ba.log_mt or {}
ba.log_mt.__index 	= ba.log_mt

local log_mt 		= ba.log_mt
local id_cache 		= {}

if (not file.IsDir('badmin/logs', 'data')) then
	file.CreateDir('badmin/logs')
end

local count = 0
function ba.logs.Create(name)
	local id
	if ba.logs.Stored[name] then
		id = ba.logs.Stored[name].ID
	else
		id = count
		count = count + 1
	end

	local l = setmetatable({
		Name  = name,
		ID 	  = count
	}, ba.log_mt)

	ba.logs.Stored[l.Name] 	= l
	ba.logs.Maping[l.ID] 	= l.Name
	ba.logs.Data[l.Name]	= {}	
	return l
end

ba.logs.Terms 		= ba.logs.Terms 		or {}
ba.logs.TermsMap 	= ba.logs.TermsMap 		or {}
ba.logs.TermsStore 	= ba.logs.TermsStore 	or {}

local c = 0
hook.Add('BadminPlguinsLoaded', 'ba.logs.terms.BadminPlguinsLoaded', function()
	for k, v in SortedPairsByMemberValue(ba.logs.TermsStore, 'Name', false) do
		ba.logs.TermsMap[v.Name] = c 
		ba.logs.Terms[c] = {Message = v.Message, Copy = v.Copy}
		c = c + 1
	end
end)

function ba.logs.AddTerm(name, message, copy)
	local k = ba.logs.TermsMap[name] or (#ba.logs.TermsStore + 1)
	ba.logs.TermsStore[k] = {
		Name = name,
		Message = message,
		Copy = copy
	}
end

function ba.logs.Term(name)
	return ba.logs.TermsMap[name]
end

function ba.logs.GetTerm(id)
	return ba.logs.Terms[id]
end


function ba.logs.GetTable()
	return ba.logs.Stored
end

function ba.logs.Get(name)
	return ba.logs.Stored[name]
end

function ba.logs.GetByID(id)
	return ba.logs.Get(ba.logs.Maping[id])
end

function ba.logs.Encode(data)
	return util.Compress(pon1.encode(data))
end

function ba.logs.Decode(data)
	return pon1.decode(util.Decompress(data))
end

function ba.logs.GetSaves()
	local files = file.Find('badmin/logs/*.dat', 'DATA', 'datedesc')
	for k, v in ipairs(files) do
		files[k] = string.StripExtension(v)
	end
	return files
end

function ba.logs.OpenSave(name)
	return ba.logs.Decode(file.Read('badmin/logs/' .. name .. '.dat', 'DATA'))
end

function ba.logs.DeleteSave(name)
	file.Delete('badmin/logs/' .. name .. '.dat')
end

function ba.logs.SaveExists(name)
	return file.Exists('badmin/logs/' .. string.Trim(name) .. '.dat', 'DATA')
end

function ba.logs.SaveLog(name, tbl)
	file.Write('badmin/logs/' .. string.Trim(name) .. '.dat', ba.logs.Encode(tbl)) 
end

function log_mt:SetColor(color)
	self.Color = color
	return self
end

function log_mt:Hook(name, callback)
	if (SERVER) then
		hook.Add(name, 'ba.logs.' .. name, function(...)
			callback(self, ...)
		end)
	end
	return self
end

function log_mt:GetName()
	return self.Name
end

function log_mt:GetColor()
	return self.Color
end

function log_mt:GetID()
	return self.ID
end


-- Commands
ba.cmd.Create('Logs', function(pl, args)
	ba.logs.OpenMenu(pl)
end)
:SetFlag('M')
:SetHelp('Shows you the logs')

ba.cmd.Create('PlayerEvents', function(pl, args)
	local steamid = ba.InfoTo32(args.target)
	if not ba.logs.PlayerEvents[steamid] then
		ba.notify_err(pl, ba.Term('NoPlayerEvents'))
		return
	end
	ba.logs.OpenPlayerEvents(pl, steamid)
end)
:AddParam('player_steamid', 'target')
:SetFlag('M')
:SetHelp('Shows you the logs for a specified player')
:AddAlias('pe')

ba.cmd.Create('AltSearch', function(pl, args)
	ba.data.CreateKey(pl, function()
		pl:SendLua([[ba.ui.OpenURL('http://portal.superiorservers.co/adminisration/altsearch.php?steamid=]] .. ba.InfoTo32(args.target) .. [[&authcode=]] .. pl:GetBVar('LastKey') .. [[')]])
	end)
end)
:AddParam('player_steamid', 'target')
:SetFlag('D')
:SetHelp('List\'s all accounds linked to a player by IP')


-- Defualt logs
local term = ba.logs.Term

ba.logs.AddTerm('Connect', '#(#) connected', {
	'Name',
	'SteamID'
})

ba.logs.AddTerm('Disconnect', '#(#) disconnected', {
	'Name',
	'SteamID'
})

ba.logs.Create 'Connections'
	:Hook('PlayerInitialSpawn', function(self, pl)
		self:PlayerLog(pl, term('Connect'), pl:Name(), pl:SteamID())
	end)
	:Hook('PlayerDisconnected', function(self, pl)
		self:PlayerLog(pl, term('Disconnect'), pl:Name(), pl:SteamID())
	end)


local function concatargs(args)
	local str
	for k, v in pairs(args) do
		str =  (str and str .. ', ' .. tostring(v) or tostring(v))
	end
	return str 
end

ba.logs.AddTerm('RunCommand', '#(#) ran # with args: "#"', {
	'Name',
	'SteamID',
	'Command'
})

ba.logs.Create 'Commands'
	:Hook('playerRunCommand', function(self, pl, cmd, args)
		if ba.IsPlayer(pl) then
			self:PlayerLog(pl, term('RunCommand'), pl:Name(), pl:SteamID(), cmd, (args.raw and concatargs(args.raw, ', ') or ''))
		end
	end)

ba.logs.AddTerm('Chat', '#(#) said "#"', {
	'Name',
	'SteamID'
})

ba.logs.AddTerm('VoiceStart', '#(#) started talking', {
	'Name',
	'SteamID'
})

ba.logs.AddTerm('VoiceEnd', '#(#) finished talking', {
	'Name',
	'SteamID'
})

ba.logs.Create 'Chat'
	:Hook('PlayerSay', function(self, pl, text)
		if (text ~= '') and (text[1] ~= '!') and (text[1] ~= '/') then
			self:PlayerLog(pl, term('Chat'), pl:Name(), pl:SteamID(), text)
		end
	end)
	:Hook('PlayerStartVoice', function(self, pl)
		self:PlayerLog(pl, term('VoiceStart'), pl:Name(), pl:SteamID())
	end)
	:Hook('PlayerEndVoice', function(self, pl)
		self:PlayerLog(pl, term('VoiceEnd'), pl:Name(), pl:SteamID())
	end)


ba.logs.AddTerm('SitRequest', '#(#) opened a Staff Request: # (# non-AFK staff)', {
	'Name',
	'SteamID'
})

ba.logs.AddTerm('SitRequestTaken', '#(#) has taken #(#)\'s Staff Request', {
	'Admin Name',
	'Admin SteamID',
	'Name',
	'SteamID'
})

ba.logs.AddTerm('SitRequestClosed', '#(#) has closed #(#)\'s Staff Request', {
	'Admin Name',
	'Admin SteamID',
	'Name',
	'SteamID'
})

ba.logs.Create 'Sit'
	:Hook('PlayerSitRequestOpened', function(self, pl, reason)
		local active = 0
		
		for k, v in ipairs(player.GetAll()) do
			if (v:IsAdmin() and !v:IsAFK()) then
				active = active + 1
			end
		end
		
		self:PlayerLog(pl, term('SitRequest'), pl:Name(), pl:SteamID(), reason, active)
	end)
	:Hook('PlayerSitRequestTaken', function(self, pl, admin)
		self:PlayerLog({pl, admin}, term('SitRequestTaken'), admin:Name(), admin:SteamID(), pl:Name(), pl:SteamID())
	end)
	:Hook('PlayerSitRequestClosed', function(self, pl, admin)
		self:PlayerLog({pl, admin}, term('SitRequestTaken'), admin:Name(), admin:SteamID(), pl:Name(), pl:SteamID())
	end)


ba.logs.AddTerm("InventoryTake", "#(#) подобрал #(#)", {
	"Name",
	"SteamID",
	"Item Name",
	"Item UID"
})

ba.logs.AddTerm("InventoryDrop", "#(#) выбросил #(#)", {
	"Name",
	"SteamID",
	"Item Name",
	"Item UID"
})

ba.logs.AddTerm("InventoryTransfer", "#(#) переместил #(#) из инвентаря # в инвентарь #", {
	"Name",
	"SteamID",
	"Item Name",
	"Item UID",
	"Old Inventory",
	"New Inventory"
})

ba.logs.Create("Inventory")
:Hook("Inventory.OnItemTake", function(self, item)
	local ply = item.player
	if not IsValid(ply) then return end
	self:PlayerLog(ply, term("InventoryTake"), ply:Name(), ply:SteamID(), item:getName(), item.uniqueID or "???")
end)
:Hook("Inventory.OnItemDrop", function(self, item, plr)
	local ply = IsValid(item.player) and item.player or plr
	if not IsValid(ply) then return end
	self:PlayerLog(ply, term("InventoryDrop"), ply:Name(), ply:SteamID(), item:getName(), item.uniqueID or "???")
end)
:Hook("OnItemTransfered", function(self, item, oldinv, newinv)
    local ply = item.player or item:getOwner()
    if not IsValid(ply) then return end
    self:PlayerLog(ply, term("InventoryTransfer"), ply:Name(), ply:SteamID(), item:getName(), item.uniqueID or "???", oldinv:__tostring(), newinv:__tostring())
end)

ba.logs.AddTerm("Term.PlayerSpawnedSWEP", "#(#) заспавнил оружие #(#)", {
	"Name",
	"SteamID",
	"Swep PrintName",
	"Swep Class"
})

ba.logs.AddTerm("Term.PlayerGiveSWEP", "#(#) выдал себе оружие #(#)", {
	"Name",
	"SteamID",
	"Swep PrintName",
	"Swep Class"
})

ba.logs.AddTerm("Term.PlayerSpawnedSENT", "#(#) заспавнил энтити #(#)", {
	"Name",
	"SteamID",
	"Ent PrintName",
	"Ent Class"
})

ba.logs.Create("SpawnMenu")
:Hook("PlayerSpawnedSWEP", function(self, ply, ent)
	self:PlayerLog(ply, term("Term.PlayerSpawnedSWEP"), ply:Name(), ply:SteamID(), ent:GetPrintName(), ent:GetClass())
end)

:Hook("PlayerGiveSWEP", function(self, ply, class, sweptab)
	 self:PlayerLog(ply, term("Term.PlayerGiveSWEP"), ply:Name(), ply:SteamID(), sweptab.PrintName, class)
end)

:Hook("PlayerSpawnedSENT", function(self, ply, ent)
	 self:PlayerLog(ply, term("Term.PlayerSpawnedSENT"), ply:Name(), ply:SteamID(), ent.PrintName, ent:GetClass())
end)

ba.logs.AddTerm("Term.WhiteListLog1", "#(#) выдал профессию `#` для #(#)", {
	"From Name",
	"From SteamID",
	"Job",
	"To Name",
	"To SteamID"
})

ba.logs.AddTerm("Term.WhiteListLog2", "#(#) отнял профессию `#` у #(#)", {
	"From Name",
	"From SteamID",
	"Job",
	"To Name",
	"To SteamID"
})

ba.logs.Create("WhiteList")
:Hook("JobWhiteList.Log", function(self, state, to, team, from)
	local valid = IsValid(from)
	local isent = IsEntity(to)
	
	if valid then
		self:PlayerLog(from, term("Term.WhiteListLog"..(state and "1" or "2")), valid and from:Name() or "N/A", valid and from:SteamID() or "Server", team and team.name or "N/A", isent and to:Name() or "offline", isent and to:SteamID() or to)
	end
end)