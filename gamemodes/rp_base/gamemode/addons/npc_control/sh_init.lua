-- "gamemodes\\rp_base\\gamemode\\addons\\npc_control\\sh_init.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

rp.npc = rp.npc or {
	Templates = {},
	Entities = {},
}

rp.npc.RegisterClass = function(npc_data)
	rp.npc.Templates[npc_data.class] = npc_data
end
