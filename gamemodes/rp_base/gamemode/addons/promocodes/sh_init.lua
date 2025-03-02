
ba.cmd.Create("PromocodeAdd",function(ply,arg)
	local name = arg.name
	local action = arg.action
	local value = arg.value
	local usecount = tonumber(arg.usecount)
	
	local one_newbie_usage = tonumber(arg.one_newbie_usage)
	one_newbie_usage = one_newbie_usage and (one_newbie_usage ~= 0)
	
	local date = arg.date

	ba.PromocodeAdd(name,action,value,usecount,date,ply,arg.time_customcheck,arg.duration)
end)
:AddParam("string","name")
:AddParam("string","action")
:AddParam("string","value")
:AddParam("string","usecount")
:AddParam("time","date")
:AddParam("time", "time_customcheck", "optional")
:AddParam("string", "one_newbie_usage", "optional")
:AddParam("time", "duration", "optional")
:SetHelp( translates.Get("Добавляет купон <имя> <действие> <кол-во> <кол-во использований> <время-жизни> <кастомчек на наигранное время> <только новичкам>") )
:SetFlag('e') -- хз какой флажок

ba.cmd.Create("PromocodeRemove",function(ply,arg)
	local name = arg.name
	ba.PromocodeRemove(name,ply)
end)
:AddParam("string","name")
:SetHelp(translates.Get("Удаляет купон где <name> имя купона"))
:SetFlag('e') -- хз какой флажок
