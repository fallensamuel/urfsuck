rp = rp or {
	cfg = {},
	inv = {
		Data = {},
		Wl = {}
	},
	meta = {}
}

local includeDebug = false;

--[[
rp.include_sv = function(f)
	if SERVER then
		if includeDebug then print( "[rp.include :: sv] -> " .. f ) end
		include(f);
	end
end

rp.include_cl = function(f)
	if SERVER then
		if includeDebug then print( "[rp.include :: cl] -> " .. f ) end
		AddCSLuaFile(f);
	else
		include(f);
	end
end
]]--

rp.include_sv = (SERVER) and include or function() end
rp.include_cl = (SERVER) and AddCSLuaFile or include

rp.include_sh = function(f)
	rp.include_sv(f)
	rp.include_cl(f)
end

rp.include = function(f)
	if string.find(f, '_sv.lua') then
		-- if SERVER and includeDebug then print( "[rp.include :: sv] -> " .. f ) end
		rp.include_sv(f)
	elseif string.find(f, '_cl.lua') then
		-- if SERVER and includeDebug then print( "[rp.include :: cl] -> " .. f ) end
		rp.include_cl(f)
	else
		-- if SERVER and includeDebug then print( "[rp.include :: sh] -> " .. f ) end
		rp.include_sh(f)
	end
end

rp.include_dir = function(dir, recursive)
	local fol = GM.FolderName .. '/gamemode/' .. dir .. '/'
	local files, folders = file.Find(fol .. '*', 'LUA')

	for _, f in ipairs(files) do
		rp.include(fol .. f)
	end

	if (recursive ~= false) then
		for _, f in ipairs(folders) do
			rp.include_dir(dir .. '/' .. f)
		end
	end
end

function rp.LoadModules(dir)
	local fol = GM.FolderName .. '/gamemode/' .. dir .. '/'

	local files, folders = file.Find(fol .. '*', 'LUA')

	for _, f in ipairs(files) do
		rp.include(fol .. f)
	end

	for _, folder in ipairs(folders) do
		local files, _ = file.Find(fol .. folder .. '/sh_*.lua', 'LUA') -- TODO: FIX

		for _, File in ipairs(files) do
			rp.include_sh(fol .. folder .. '/' .. File)
		end

		local files, _ = file.Find(fol .. folder .. '/sv_*.lua', 'LUA')

		for _, File in ipairs(files) do
			rp.include_sv(fol .. folder .. '/' .. File)
		end

		local files, _ = file.Find(fol .. folder .. '/cl_*.lua', 'LUA') -- TODO: FIX

		for _, File in ipairs(files) do
			rp.include_cl(fol .. folder .. '/' .. File)
		end
	end
end

GM.Name = '► URFIM RP'
GM.Author = 'band0'
GM.Website = 'SuperiorServers.co'
rp.include_sv'db.lua'

rp.include_cl 'util/surface.lua'
rp.include_cl 'util/draw.lua'

rp.include_sh'config/format.lua'

rp.include_sh'config/cfg.lua'
rp.include_sh'config/info.lua'
rp.include_sh'config/colors.lua'
rp.include_cl'config/fonts.lua'

rp.include_sh'config/heists.lua'
rp.include_sh'config/interactmenu.lua'

DeriveGamemode("rp_base")

rp.include_sv'config/content.lua'
rp.include_sh'config/factions.lua'
rp.include_sh'config/jobs.lua'

rp.include_cl'config/commands.lua'
rp.include_sh'config/q_menu_objects.lua'

-- rp.include_dir('config/attributes', false)
-- rp.include_dir('config/attributes/boosts', false)

rp.include_dir('config/actions', false)
rp.include_dir('config/actions/act_power', false)
rp.include_dir('config/actions/act_premium', false)
rp.include_dir('config/actions/act_usual', false)
rp.include_dir('config/jobs', false)
rp.include_dir('config/npcs', false)

rp.include_sh'config/inventory/entities.lua'
rp.include_sh'config/inventory/shipments_vendor.lua'
rp.include_sh'config/inventory/items.lua'
rp.include_sh'config/inventory/crafting.lua'
rp.include_sh'config/inventory/loots.lua'
rp.include_sh'config/cosmetics.lua'

rp.include_sh'config/events.lua'
rp.include_sh'config/upgrades.lua'
rp.include_sh'config/terms.lua'
rp.include_sv'config/limits.lua'
rp.include_sh'config/capture.lua'
rp.include_sh'config/bonuses.lua'
rp.include_sv'config/foodsystem.lua'
rp.include_sh'config/supervisors.lua'

rp.LoadModules('addons')

rp.include_sh'config/weapons.lua'
rp.include_sh'config/vendors.lua'
rp.include_cl"config/bubble_hints.lua"
rp.include_sv"config/raid_settings.lua"
rp.include_sh'config/confiscation.lua'

rp.include_sh'config/inventory/crafttable.lua'

hook.Call('ConfigLoaded')