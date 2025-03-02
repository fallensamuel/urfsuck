-- "gamemodes\\rp_base\\gamemode\\main\\player\\government\\police\\faction_wanted\\z_crime_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

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
	
	t.ID = table.insert(rp.crimes.Table, t)
	rp.crimes.Map[t.Name] = t
	
	setmetatable(t, rp.meta.crime)
	return t
end
