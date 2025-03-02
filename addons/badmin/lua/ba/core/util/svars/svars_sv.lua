util.AddNetworkString('ba.svars')
util.AddNetworkString('ba.global_svars')

ba.svar 			= ba.svar 			or {}
ba.svar.stored 		= ba.svar.stored 	or {}
ba.svar.encoded 	= ba.svar.encoded	or '{}'
local db 			= ba.data.GetDB()

local function encodeSvars()
	local tbl = {}
	
	for k, v in pairs(ba.svar.stored) do
		if v.network then
			tbl[k] = v.value
		end
	end
	
	ba.svar.encoded = pon.encode(tbl)
end
hook.Add('bAdmin_Loaded', 'bAdmin_Loaded.svars', encodeSvars)

local function saveSvars()
	for k, v in pairs(ba.svar.stored) do
		if (v.value ~= nil) then
			db:query_ex('REPLACE INTO ba_server_vars(sv_uid, var, data) VALUES("?","?","?");', {v.global and 0 or ba.data.GetUID(), k, v.value}, cback)
		end
	end
	
	encodeSvars()

	net.Start('ba.svars')
		net.WriteString(ba.svar.encoded)
	net.Broadcast()
end

local function loadSvars()
	db:query_ex('SELECT * FROM ba_server_vars WHERE `sv_uid` = "?" || `sv_uid` = "0";', {ba.data.GetUID()}, function(data)
		for k, v in pairs(data) do
			local old_var = ba.svar.stored[name] and ba.svar.stored[name].value

			ba.svar.stored[v.var] 				= ba.svar.stored[v.var] or {}
			ba.svar.stored[v.var].value 		= v.data
			ba.svar.stored[v.var].global 		= (v.sv_uid == '0') or nil
			ba.svar.stored[v.var].global_init 	= true

			if old_var != v.data and ba.svar.stored[v.var].cback then
				ba.svar.stored[v.var].cback(name, old_var, v.data)
			end
		end
		
		saveSvars()
	end)
end
loadSvars()

hook.Add('PlayerEntityCreated', 'svars.PlayerEntityCreated', function(pl)
	net.Start('ba.svars')
		net.WriteString(ba.svar.encoded)
	net.Send(pl)
end)

function ba.svar.Create(name, default, network, callback, global)
	local old_var = ba.svar.stored[name] and ba.svar.stored[name].value
	
	ba.svar.stored[name]			= ba.svar.stored[name]		 	or {}
	ba.svar.stored[name].value 		= old_var 						or default
	ba.svar.stored[name].network 	= ba.svar.stored[name].network 	or network
	ba.svar.stored[name].cback 		= ba.svar.stored[name].cback 	or callback
	ba.svar.stored[name].global 	= ba.svar.stored[name].global 	or global
	
	if ba.svar.stored[name].global_init and old_var then
		ba.svar.stored[name].global_init = nil
		
		if callback then
			callback(name, old_var, old_var)
		end
	end
end

function ba.svar.Set(name, value)
	ba.svar.stored[name]			= ba.svar.stored[name]		 	or {}
	if (ba.svar.stored[name].cback ~= nil) then
		ba.svar.stored[name].cback(name, ba.svar.stored[name].value, value)
	end
	ba.svar.stored[name].value = value
	saveSvars()
end

function ba.svar.Get(name)
	return (ba.svar.stored[name] and ba.svar.stored[name].value or nil)
end


-- Global server vars
if timer.Exists('ba.CheckGlobals') then
	timer.Remove('rp.CheckGlobals')
end

timer.Create('rp.CheckGlobals', 6, 0, function()
	local data = db:query_sync('SELECT * FROM ba_server_vars WHERE `sv_uid` = "0";')
	
	for k, v in pairs(data or {}) do
		if not ba.svar.stored[v.var] or ba.svar.stored[v.var].value ~= v.data then
			ba.svar.stored[v.var] = ba.svar.stored[v.var] or {}
			ba.svar.stored[v.var].global = true
			
			if ba.svar.stored[v.var].cback then
				ba.svar.stored[v.var].cback(v.var, ba.svar.stored[v.var].value, v.data)
			end
			
			ba.svar.stored[v.var].value = v.data
		end
	end
end)

function ba.svar.SetGlobal(name, value)
	ba.svar.stored[name] = ba.svar.stored[name] or {}
	ba.svar.stored[name].global = true
	
	ba.svar.Set(name, value)
end

function ba.svar.GetGlobal(name)
	return (ba.svar.stored[name] and ba.svar.stored[name].global and ba.svar.stored[name].value or nil)
end