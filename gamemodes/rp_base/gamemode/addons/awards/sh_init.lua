-- "gamemodes\\rp_base\\gamemode\\addons\\awards\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
rp.awards = rp.awards or {
	Types = {},
	Data = {},
}

function rp.awards.AddType(uid, give_callback, load_callback, remove_callback)
	if rp.awards.Types[uid] then return end
	
	rp.awards.Types[uid] = table.insert(rp.awards.Data, {
		UID = uid,
		callback = give_callback,
		load_callback = load_callback,
		remove_callback = remove_callback,
	})
end

rp.include_sh('rp_base/gamemode/addons/awards/awards.lua')
