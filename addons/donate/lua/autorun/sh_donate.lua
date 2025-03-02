local client = {"donate/sh_init.lua", "donate/sh_settings.lua", "donate/cl_init.lua"}
                                                      
if CLIENT then
	for k, v in pairs(client) do
		include(v)
	end
else
	AddCSLuaFile()
	for k, v in pairs(client) do
		AddCSLuaFile(v)
	end

	include("donate/sh_init.lua")
	include("donate/sv_init.lua")
	include("donate/sh_settings.lua")
end

