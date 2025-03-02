-- "gamemodes\\rp_base\\gamemode\\main\\interact_menu\\nexus_framework\\core\\settings.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local framework = Nexus:ClassManager("Framework")
local settings = framework:Class("Settings")

settings:Add("Config", {})
settings:Add("GetEase", function(self)
	return "Default"
end)
settings:Add("Language", function(self)
	return self:Get("Config").Language
end)