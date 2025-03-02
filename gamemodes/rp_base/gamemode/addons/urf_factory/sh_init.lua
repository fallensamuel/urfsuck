-- "gamemodes\\rp_base\\gamemode\\addons\\urf_factory\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

-- [[ LIB ]] --
rp.factory = rp.factory or {
	Buttons = {},
	Components = {},
	Places = {},
	Storages = {},
}


-- [[ METAS ]] --
rp.include('meta/button_sh.lua')
rp.include('meta/component_sh.lua')
rp.include('meta/place_sh.lua')
rp.include('meta/storage_sh.lua')
