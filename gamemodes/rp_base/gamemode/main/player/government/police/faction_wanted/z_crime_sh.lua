
if not rp.cfg.NewWanted then return end

rp.crimes = rp.crimes or {
	Table = {},
	Map = {},
}

function rp.police.AddCrime(name)
	if rp.crimes.Map[name] then
		return rp.crimes.Map[name]
	end
	
	local t = { Name = name }
	
	t.ID = table.insert(t, rp.crimes.Table)
	rp.crimes.Map[t.Name] = t
	
	setmetatable(t, rp.meta.crime)
	return t
end
