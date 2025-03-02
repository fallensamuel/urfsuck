util.AddNetworkString('ba.cmd.recordnet.log')

OldNwIncoming = OldNwIncoming or net.Incoming

local logging	 = false
local logging_to = {}
local nwlog 	 = ''

if not file.IsDir('badmin/net_records', 'DATA') then
	file.CreateDir('badmin/net_records')
else
	local files	= file.Find('badmin/net_records/*.txt', 'DATA', 'dateasc')
	local week 	= 60 * 60 * 24 * 7
	
	for k, v in ipairs(files) do
		if os.time() - file.Time('badmin/net_records/' .. v, 'DATA') > week then
			file.Delete('badmin/net_records/' .. v)
		else break end
	end
end

local function NWLogSave()
	if string.len(nwlog) < 5 then return end
	
	file.Write('badmin/net_records/' .. util.DateStamp() .. '.txt', nwlog) 
	nwlog = ''
end


local function NewNWIncoming(len, client)
	local i = net.ReadHeader()
	local strName = util.NetworkIDToString(i)
	
	if strName and strName ~= 'LerpPing' then 
		net.Start('ba.cmd.recordnet.log')
			net.WriteString(client:SteamID())
			net.WriteString(strName)
			net.WriteUInt(len, 17)
		net.Send(logging_to)
		
		nwlog = nwlog .. client:SteamID() .. ' sent ' .. strName .. ' (' .. len .. 'b)\n'
	end
	
	local func = net.Receivers[strName:lower()]
	if !func then return end
	
	len = len - 16
	func(len, client)
end


function NetRecordEnd()
	if not logging then return end
	
	net.Incoming = OldNwIncoming
	logging		 = false
	
	timer.Remove('ba.recordnet.log')
	ba.notify_staff(ba.Term('NetRecordEnd'))
end

function NetRecordStart(pl)
	if not logging then 
		nwlog 	   = ''
		logging_to = {}
		
		timer.Create('ba.recordnet.log', 1, 120, NWLogSave)
		timer.Simple(120, function()
			NetRecordEnd()
		end)
		
		logging = true
	end
	
	net.Incoming = NewNWIncoming
	
	table.insert(logging_to, pl)
	ba.notify_staff(ba.Term('NetRecordStart'), pl:GetName())
end

