-- "gamemodes\\rp_base\\gamemode\\main\\sandbox\\spawnmenu_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--[[---------------------------------------------------------
	If false is returned then the spawn menu is never created.
	This saves load times if your mod doesn't actually use the
	spawn menu for any reason.
-----------------------------------------------------------]]
function GM:SpawnMenuEnabled()
	return true
end

--[[---------------------------------------------------------
  Called when spawnmenu is trying to be opened. 
   Return false to dissallow it.
-----------------------------------------------------------]]
function GM:SpawnMenuOpen()
	return true
end

--[[---------------------------------------------------------
  Called when context menu is trying to be opened. 
   Return false to dissallow it.
-----------------------------------------------------------]]
function GM:ContextMenuOpen()
	return true
end

--[[---------------------------------------------------------
  Backwards compatibility. Do Not Use!!!
-----------------------------------------------------------]]
function GM:GetSpawnmenuTools(name)
	return spawnmenu.GetToolMenu(name)
end

--[[---------------------------------------------------------
  Backwards compatibility. Do Not Use!!!
-----------------------------------------------------------]]
function GM:AddSTOOL(category, itemname, text, command, controls, cpanelfunction)
	self:AddToolmenuOption("Main", category, itemname, text, command, controls, cpanelfunction)
end

--[[---------------------------------------------------------
	Don't hook or override this function. 
	Hook AddToolMenuTabs instead!
-----------------------------------------------------------]]
function GM:AddGamemodeToolMenuTabs()
	-- This is named like this to force it to be the first tab
	spawnmenu.AddToolTab("Main", "#spawnmenu.tools_tab", "icon16/wrench.png")
	spawnmenu.AddToolTab("Utilities", "#spawnmenu.utilities_tab", "icon16/page_white_wrench.png")
end

--[[---------------------------------------------------------
	Add your custom tabs here.
-----------------------------------------------------------]]
function GM:AddToolMenuTabs()
end

-- Hook me!
--[[---------------------------------------------------------
	Add categories to your tabs
-----------------------------------------------------------]]
function GM:AddGamemodeToolMenuCategories()
	spawnmenu.AddToolCategory("Main", "Constraints", "#spawnmenu.tools.constraints")
	spawnmenu.AddToolCategory("Main", "Construction", "#spawnmenu.tools.construction")
	spawnmenu.AddToolCategory("Main", "Render", "#spawnmenu.tools.render")
	spawnmenu.AddToolCategory("Main", "Roleplay", "Roleplay")
	--spawnmenu.AddToolCategory("Main", "VIP+", "VIP+")
	spawnmenu.AddToolCategory("Main", "Staff", "Staff")
end

--[[---------------------------------------------------------
	Add categories to your tabs
-----------------------------------------------------------]]
function GM:AddToolMenuCategories()
end

-- Hook this function to add custom stuff
--[[---------------------------------------------------------
	Add categories to your tabs
-----------------------------------------------------------]]
function GM:PopulatePropMenu()
	-- This function makes the engine load the spawn menu text files.
	-- We call it here so that any gamemodes not using the default 
	-- spawn menu can totally not call it.
	spawnmenu.PopulateFromEngineTextFiles() --changed PopulateFromEngineTextFiles to PopulateFromTextFiles
end

--[[

	All of this model search stuff is due for an update to speed it up
	So don't rely on any of this code still being here.

--]]
local ModelIndex = {}
local ModelIndexTimer = CurTime()

local function BuildModelIndex(dir)
	-- Add models from this folder
	local files = file.Find(dir .. "*", "GAME")

	for k, v in pairs(files) do
		if (v:sub(-4, -1) == ".mdl") then
			-- Filter out some of the un-usable crap
			if (not v:find("_gestures") and not v:find("_anim") and not v:find("_gst") and not v:find("_pst") and not v:find("_shd") and not v:find("_ss") and not v:find("cs_fix") and not v:find("_anm")) then
				table.insert(ModelIndex, (dir .. v):lower())
			end
		elseif (v:sub(-4, -4) ~= '.') then
			--BuildModelIndex( dir..v.."/" )
			-- Stagger the loading so we don't block.
			-- This means that the data is inconsistent at first
			-- but it's better than adding 5 seconds onto loadtime
			-- or pausing for 5 seconds on the first search
			-- or dumping all this to a text file and loading it
			ModelIndexTimer = ModelIndexTimer + 0.02

			timer.Simple(ModelIndexTimer - CurTime(), function()
				BuildModelIndex(dir .. v .. "/")
			end)
		end
	end
end

--[[---------------------------------------------------------
  Called by the toolgun to add a STOOL
-----------------------------------------------------------]]
function GM:DoModelSearch(str)
	local ret = {}

	if (#ModelIndex == 0) then
		ModelIndexTimer = CurTime()
		BuildModelIndex("models/")
	end

	if (str:len() < 3) then
		table.insert(ret, "Enter at least 3 characters")
	else
		str = str:lower()

		for k, v in pairs(ModelIndex) do
			if (v:find(str)) then
				table.insert(ret, v)
			end
		end
	end

	return ret
end