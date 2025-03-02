-- "gamemodes\\darkrp\\gamemode\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

--PLAYER = FindMetaTable'Player'
--ENTITY = FindMetaTable'Entity'
--VECTOR = FindMetaTable'Vector'

rp = rp or {
	cfg = {},
	inv = {
		Data = {},
		Wl = {}
	},
	meta = {}
}

rp.include_sv = (SERVER) and include or function() end
rp.include_cl = (SERVER) and AddCSLuaFile or include

rp.include_sh = function(f)
	rp.include_sv(f)
	rp.include_cl(f)
end

local includeDebug = false;
rp.include = function(f)
	if string.find(f, '_sv.lua') then
		if SERVER and includeDebug then print( "[rp.include :: sv] -> " .. f ) end
		rp.include_sv(f)
	elseif string.find(f, '_cl.lua') then
		if SERVER and includeDebug then print( "[rp.include :: cl] -> " .. f ) end
		rp.include_cl(f)
	else
		if SERVER and includeDebug then print( "[rp.include :: sh] -> " .. f ) end
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
		if not rp.cfg.DisableModules[folder] then
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
end

GM.Name = '► URFIM RP - TOП RP Cepвepa'
GM.Author = 'band0'
GM.Website = 'urf.im'
rp.include_sv'db.lua'

rp.include_cl 'libraries/surface.lua'
rp.include_cl 'libraries/draw.lua'

rp.include_sh'config/format.lua'

rp.include_sh'config/cfg.lua'
rp.include_sh'config/info.lua'
rp.include_sh'config/colors.lua'
rp.include_cl'config/fonts.lua'

rp.include_sh'config/heists.lua'
rp.include_sh'config/interactmenu.lua'

DeriveGamemode("rp_base")

rp.include_sh('addons/quest/sh_addmethod.lua')
rp.include_sh('addons/quest/sh_init.lua')
rp.include_sh('addons/quest/sh_entities.lua')
rp.include_cl('addons/quest/cl_vgui.lua')
rp.include_cl('addons/quest/cl_init.lua')
rp.include_sv('addons/quest/sv_init.lua')
rp.include_sv('addons/quest/sv_entities.lua')

rp.include_sv'config/content.lua'
rp.include_sh'config/factions.lua'
rp.include_sh'config/police.lua'
rp.include_sh'config/jobs.lua'

rp.include_cl'config/commands.lua'
rp.include_sh'config/q_menu_objects.lua'

rp.include_dir('config/attributes', false)
-- rp.include_dir('config/attributes/boosts', false)

rp.include_dir('config/emoteactions', false)
rp.include_dir('config/emoteactions/act_power', false)
rp.include_dir('config/emoteactions/act_premium', false)
rp.include_dir('config/emoteactions/act_usual', false)
rp.include_dir("config/emoteactions/act_group", false)
rp.include_dir('config/jobs', false)

rp.include_sh'config/inventory/entities.lua'
rp.include_sh'config/inventory/shipments_vendor.lua'
--rp.include_sh'config/entities.lua'
rp.include_sh'config/cosmetics.lua'
rp.include_sh'config/inventory/items.lua'
rp.include_sh'config/inventory/crafting.lua'
rp.include_sh'config/inventory/loots.lua'
rp.include_sh'config/customization.lua'

--rp.include_sv'config/events.lua'

rp.include_sh'config/upgrades.lua'
rp.include_sh'config/terms.lua'

--rp.include_sv'config/limits.lua'

rp.include_sh'config/capture.lua'
rp.include_sh'config/bonuses.lua'
--rp.include_sh'config/quests.lua'

rp.include_sh'config/supervisors.lua'
rp.include_sh'config/vendors.lua'
rp.include_sh"config/cases.lua"

rp.LoadModules('addons')

rp.include_sh'config/quests.lua'
rp.include_dir'config/quests'

rp.include_sh'config/weapons.lua'
rp.include_sv'config/raid_settings.lua'

rp.include_sh"config/inventory/attachments.lua"

rp.include_sh'config/radiation.lua'
rp.include_cl"config/bubble_hints.lua"
rp.include_sh'config/inventory/artifacts.lua'
rp.include_sh'config/inventory/crafttable.lua'
rp.include_sh'config/pets.lua'
rp.include_sh'config/uppers.lua'
rp.include_sh'config/fortune_wheel.lua'
rp.include_sh'config/randomize_job_npc.lua'

rp.include_dir('config/seasonpass', false)
hook.Call('ConfigLoaded')
