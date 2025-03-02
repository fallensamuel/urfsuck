function rp.db.convertDataType(value)
	if (type(value) == "string") then
		return "'"..value.."'"
	elseif (type(value) == "table") then
		return "'"..util.TableToJSON(value).."'"
	end

	return value
end

function rp.db.insertTable(value, callback, dbTable)
	local query = "INSERT INTO "..dbTable.." ("
	local keys = {}
	local values = {}

	for k, v in pairs(value) do
		keys[#keys + 1] = k
		values[#keys] = k:find("steamID") and v or rp.db.convertDataType(v)
	end

	query = query..table.concat(keys, ", ")..") VALUES ("..table.concat(values, ", ")..")"
	rp._Inventory:Query(query, callback)
end

function rp.db.updateTable(value, callback, dbTable, condition)
	local query = "UPDATE "..dbTable.." SET "
	local changes = {}

	for k, v in pairs(value) do
		changes[#changes + 1] = k.." = "..(k:find("steamID") and v or rp.db.convertDataType(v))
	end

	query = query..table.concat(changes, ", ")..(condition and " WHERE "..condition or "")
	rp._Inventory:Query(query, callback)
end

hook.Add("Initialize","rp.CreateDataBaseInventory",function()
	print('Trying to create inventory databases...')
	rp._Inventory:Query("CREATE TABLE IF NOT EXISTS `inventories` (`_invID` int(11) unsigned NOT NULL AUTO_INCREMENT,`_charID` bigint(20) unsigned NOT NULL,`_invType` varchar(24) DEFAULT NULL,`_width` int(11) DEFAULT NULL,`_height` int(11) DEFAULT NULL,PRIMARY KEY (`_invID`)) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;")
	rp._Inventory:Query("CREATE TABLE IF NOT EXISTS `items` (`_itemID` int(11) unsigned NOT NULL AUTO_INCREMENT,`_invID` int(11) unsigned NOT NULL,`_uniqueID` varchar(60) NOT NULL,`_data` varchar(500) DEFAULT NULL,`_x` smallint(4) NOT NULL,`_y` smallint(4) NOT NULL,PRIMARY KEY (`_itemID`)) ENGINE=InnoDB AUTO_INCREMENT=190 DEFAULT CHARSET=utf8;")
end)