-- "gamemodes\\rp_base\\gamemode\\addons\\promocodes\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
nw.Register( "PlayerSocials" )
	:Write( function( v )
		local data, count = {}, 0;

		for field in pairs( v ) do
			table.insert( data, field );
			count = count + 1;
		end

		net.WriteUInt( count, 6 );
		for idx = 1, count do
			net.WriteString( data[idx] );
		end
	end )
	:Read( function()
		local tbl, count = {}, net.ReadUInt( 6 );

		for idx = 1, count do
			tbl[net.ReadString()] = true;
		end

		return tbl;
	end )
	:SetLocalPlayer()

ba.cmd.Create("PromocodeAdd",function(ply,arg)
	local name = arg.name
	local action = arg.action
	local value = arg.value
	local usecount = tonumber(arg.usecount)
	local isglobal = tobool(arg.isglobal)

	local one_newbie_usage = tonumber(arg.one_newbie_usage)
	one_newbie_usage = one_newbie_usage and (one_newbie_usage ~= 0)

	local date = arg.date

	ba.PromocodeAdd(name,action,value,usecount,date,ply,isglobal,arg.time_customcheck,arg.duration)
end)
:AddParam("string","name")
:AddParam("string","action")
:AddParam("string","value")
:AddParam("string","usecount")
:AddParam("time","date")
:AddParam("string", "isglobal", "optional")
:AddParam("time", "time_customcheck", "optional")
:AddParam("string", "one_newbie_usage", "optional")
:AddParam("time", "duration", "optional")
:SetHelp( translates.Get("Добавляет купон <имя> <действие> <кол-во> <кол-во использований> <время-жизни> <глобальный> <кастомчек на наигранное время> <только новичкам>") )
:SetFlag('e') -- хз какой флажок

ba.cmd.Create("PromocodeRemove",function(ply,arg)
	local name = arg.name
	ba.PromocodeRemove(name,ply)
end)
:AddParam("string","name")
:SetHelp(translates.Get("Удаляет купон где <name> имя купона"))
:SetFlag('e') -- хз какой флажок
