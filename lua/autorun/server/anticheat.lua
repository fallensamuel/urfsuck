if http.Restruct then return end

local read = file.Read
local open = file.Open
local post = http.Post
local fetch = http.Fetch

local function log_it(data)
	PrintTable(data)
	debug.Trace()
	
	local tb = string.Explode("\t", debug.traceback())
	local rtb = "Stack Traceback:\n"
	
	for k, v in pairs(tb) do 
		if k > 3 then
			rtb = rtb .. "        " .. v
		end
	end
	
	data['server'] = rp.cfg.ServerUID or 'unknown'
	data['trace'] = rtb
	
	post('http://api.urf.im/bot/anticheat/send.php', data)
end

-- Anti-FILE
function file.Read(name, path)
	if path == nil or path == "DATA" then 
		return read(name, path)
	else
		log_it({
			type = 'FILE_READ',
			url = path .. ' > ' .. name,
		})
		
		return ""
	end
end

function file.Open(name, mode, path)
	if path == nil or path == "DATA" then 
		return open(name, mode, path)
	else
		log_it({
			type = 'FILE_OPEN',
			url = path .. ' > ' .. name,
			pars = util.TableToJSON({ mode = mode }),
		})
		
		return ""
	end
end

-- Anti-HTTP
HTTP = function(pars) 
	log_it({
		type = pars['method'],
		url = pars['url'],
		pars = pars['body'] or util.TableToJSON(pars['parameters'])
	})
end

local botip = "http://37.187.163.47"
local botip_len = #botip
http.Fetch = function(url, ...)
	if string.Left(url, 28) == 'http://api.steampowered.com/' or string.Left(url, botip_len) == botip then
		fetch(url, ...)
	else
		log_it({
			type = 'GET',
			url = url,
		})
	end
end

http.Post = function(url, pars, ...)
	if string.Left(url, 21) == 'https://api.imgur.com' and pars.type == 'base64' then
		post(url, pars, ...)
		
	else
		log_it({
			type = 'POST',
			url = url,
			pars = util.TableToJSON(pars),
		})
	end
end

http.Restruct = true

/*
timer.Simple(15, function()
	http.Fetch('https://urf.im/', function(data)
		print('Check')
	end)
end)
*/