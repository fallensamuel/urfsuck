rp.cfg.Limits = {
	['dynamite']	= 0,
	['hoverballs']	= 0,
	['turrets']		= 0,
	['spawners']	= 0,
	['emitters']	= 0,
	['effects']		= 0,
	['buttons']		= 4,
	['ragdolls']	= 0,
	['npcs']		= 0,
	['lamps']		= 0,
	['balloons']	= 4,
	['lights']		= 4,
	['props']		= 1000,
	['vehicles']	= 0,
	['sents']		= 25,
	['keypads']		= 10,
	['signals']		= 3,
	['textscreens']	= 3,
	['sw_tank_v2'] 	= 1,
	['cameras']		= 5
}

rp.cfg.DroppedItemsLimit = 10
rp.cfg.DroppedMoneyLimit = 5

function rp.GetLimit(name)
	return rp.cfg.Limits[name] or 0
end

function rp.SetLimit(name, limit)
	rp.cfg.Limits[name] = limit
end