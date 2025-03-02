PIS = {}

local function Load()

	local loader = Nexus:Loader()
	loader:SetName("Ping system")
	loader:SetColor(Color(48, 100, 255))
	loader:SetAcronym("PIS")
	loader:RegisterAcronym()
	local load_dir = "rp_base/gamemode/main/interact_menu/ping_system"
	loader:SetLoadDirectory(load_dir)
	loader:Load("core", "SHARED", true)
	loader:Load("config", "SHARED", true)
	rp.include_sh("ping_system/config/config.lua")
	loader:Load("vgui", "CLIENT", true)
	rp.include_cl("ping_system/vgui/circle_menu_cl.lua")
	loader:Load("ping_rendering", "CLIENT", true)
	loader:Load("misc", "SHARED", true)
	loader:Load("networking", "CLIENT", true, {
		["server_sv.lua"] = true
	})
	loader:Load("networking", "SERVER", true, {
		["client_cl.lua"] = true
	})
	loader:Load("gamemodes", "SHARED", true)

	for i, v in pairs(PIS.Gamemodes) do
		if (v:GetDetectionCondition()()) then
			PIS.Gamemode = v
		end
	end

	if (!PIS.Gamemode) then
		for i, v in pairs(PIS.Gamemodes) do
			if (v:GetID() == "backup") then
				PIS.Gamemode = v
				break
			end
		end
	end

	loader:GetLoadMessage("SHARED", PIS.Gamemode:GetName())

	loader:Register()

--[[
	local folder = "main/interact_menu/ping_system"
	rp.include_dir(folder.."config")
	rp.include_dir(folder.."database")
	rp.include_dir(folder.."vgui")
	rp.include_dir(folder.."ping_rendering")
	rp.include_dir(folder.."misc")
	rp.include_dir(folder.."networking")
	rp.include_dir(folder.."gamemodes")	

	for i, v in pairs(PIS.Gamemodes) do
		if (v:GetDetectionCondition()()) then
			PIS.Gamemode = v
		end
	end

	if (!PIS.Gamemode) then
		for i, v in pairs(PIS.Gamemodes) do
			if (v:GetID() == "backup") then
				PIS.Gamemode = v
				break
			end
		end
	end
]]--
end

if (Nexus) then
	Load()
else
	hook.Add("Nexus.PostLoaded", "PingSystem", Load)
end
