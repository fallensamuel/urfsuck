Nexus = {}

hook.Run("Nexus.PreLoaded")
--[[
if (CLIENT) then
	include("nexus_framework/core/load.lua")
elseif (SERVER) then
	include("nexus_framework/core/load.lua")
	AddCSLuaFile("nexus_framework/core/load.lua")
end

-- This is kinda ironic!
local loader = Nexus:Loader()
loader:SetName("Framework")
loader:SetColor(Color(208, 53, 53))
loader:SetAcronym("Framework")
loader:RegisterAcronym()
loader:SetLoadDirectory("rp_base/gamemode/main/interact_menu/nexus_framework")
loader:Load("core", "SHARED", true, {
	["load.lua"] = true
})
loader:Load("database", "SERVER", true)
loader:Load("vgui", "CLIENT")
loader:Load("vgui/modules", "CLIENT", true)
loader:Load("vgui/components", "CLIENT", true)
loader:Register()
]]--

local folder = "rp_base/gamemode/main/interact_menu/nexus_framework/"

rp.include_sh(folder.."core/load.lua")
rp.include_sh(folder.."core/class.lua")
rp.include_sh(folder.."core/languages.lua")
rp.include_sh(folder.."core/settings.lua")
rp.include_sh(folder.."core/testing.lua")
rp.include_sh(folder.."core/themes.lua")
--rp.include_dir(folder.."core")
local folder2 = "main/interact_menu/nexus_framework/"
rp.include_dir(folder2.."vgui/modules")
rp.include_dir(folder2.."vgui/components")

hook.Run("Nexus.PostLoaded")