
resource.AddWorkshop('577994158') -- gifts
resource.AddWorkshop('572267883') -- santa

resource.AddWorkshop('357731421') -- snegki


require'mysql'

local db = mysql('mysql.urf.im','root', 'jakiro228', 'web', 3306)

local funcs = {
	money = function(ent, data) ent.Action = function(self, ply) RunConsoleCommand('ba', 'tellall', ply:Nick()..' нашёл подарок и получил '..data..'$!') ply:AddMoney(tonumber(data))  end end,
	credits = function(ent, data) ent.Action = function(self, ply) RunConsoleCommand('ba', 'tellall', ply:Nick()..' нашёл подарок и получил '..data..' кредитов!') ply:AddCredits(tonumber(data), "gift")  end end,
	data = function(ent, data) ent.Action = function(self, ply) RunConsoleCommand('ba', 'tellall', ply:Nick()..' нашёл подарок и получил '..data..'!') ba.notify(ply, 'Вам выдадут награду в ручном режиме в течение дня!')  db:Query("INSERT INTO gift_data(steamid, nick, value) VALUES('"..ply:SteamID().."', ?, ?)", ply:Nick(), data) end end
}

concommand.Add("gift_set_action", function(ply, cmd, args)
	if args[1] && funcs[args[1]] && args[2] && ply:HasFlag('x') && ply:GetEyeTrace().Entity.IsGift then
		ba.notify(ply, 'Заебись ты настроил подарок! Он даст '..args[1]..' в объёме '..args[2])
		funcs[args[1]](ply:GetEyeTrace().Entity, args[2])
	else
		ba.notify(ply, 'Ты где-то облажался приятель!')
	end
end)