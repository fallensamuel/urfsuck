-- Имитация rcon-а

function httpUrlEncode(text) -- thanks to wiremod
	local ndata = string.gsub(text, "[^%w _~%.%-]", function(str)
		local nstr = string.format("%X", string.byte(str))
		return "%"..((string.len(nstr) == 1) and "0" or "")..nstr
	end)
	return string.gsub(ndata, " ", "+")
end

local function TickSpewCapture(todo, callback)
	local hname = "TickCapture".. SysTime()
	hook.Add("EngineSpew", hname, function(a, msg, c, d, r,g,b)
		hook.Remove("EngineSpew", hname)
		callback(msg)
	end)

	todo()

	timer.Simple(0, function() timer.Simple(0, function() -- ждём 2 тика, если нихера не произошло отсылаем инфу в респонс
		if hook.GetTable()["EngineSpew"][hname] then
			hook.Remove("EngineSpew", hname)
			callback("Нет респонса :(")
		end
	end) end)
end

local function ReplyDiscord(out)
    local url = "http://37.187.163.47:8080/?apikey=H99cF7mCV93kBeqE&method=rconresponse&response=".. httpUrlEncode(out) .."&uid=".. httpUrlEncode(rp.cfg.ServerRealUID or rp.cfg.ServerUID) .."&server=".. httpUrlEncode(game.GetIPAddress():Replace(".", "_"))
    --print(url)
    http.Fetch(url, function(code)
        print("[RconLine] Reply to discord hazbeen sended! Code:", code)
    end, print)
end

local enginespew_loaded = pcall(_G.require, "enginespew")

local function Execute(for_exec)
	if enginespew_loaded then
		TickSpewCapture(function()
			game.ConsoleCommand(for_exec.."\n")
		end, ReplyDiscord)
	else
		game.ConsoleCommand(for_exec.."\n")
	end
end

timer.Create("RconLike", 10, 0, function()
	if rp.cfg.IsTestServer then
		timer.Remove("RconLike")
		return
	end

	local uid = rp.cfg.ServerRealUID or rp.cfg.ServerUID
	rp.syncHours.db:Query("SELECT * FROM `rconlike` WHERE `target_uid` = ?;", uid, function(data)
		if not data then return end

		rp.syncHours.db:Query("DELETE FROM `rconlike` WHERE `target_uid` = ?;", uid, function() end)

		for k, v in pairs(data) do
			print("[RconLike]", uid, v.request_type .. " | " .. v.for_exec )
			if v.request_type == "lua" then
				--print("RconLike Run Lua!")
			--	TickSpewCapture(function()
			--		RunString(v.for_exec)
			--	end, ReplyDiscord)
			elseif v.request_type == "cmd" then
				--print("RconLike Run Cmd!")
				Execute(v.for_exec)
			end
		end
	end)
end)