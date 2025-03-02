-- "gamemodes\\rp_base\\gamemode\\main\\donations\\load_sh.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal

rp.include_sh("src/sh_init.lua")
rp.include_sh("src/sh_settings.lua")
rp.include_sh("src/cl_init.lua")

rp.include_sv("src/sh_init.lua")
rp.include_sv("src/sv_init.lua")

if rp.cfg.IsFrance then
	rp.include_sv("src/sv_france.lua")
end

rp.include_sv("src/sh_settings.lua")
