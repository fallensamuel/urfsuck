include("sh_init.lua")

timer.Create("CleanBodys", 60, 0, function()
	RunConsoleCommand("r_cleardecals")
	for k, v in ipairs(ents.FindByClass("class C_ClientRagdoll")) do
		v:Remove()
	end
	for k, v in ipairs(ents.FindByClass("class C_PhysPropClientside")) do
		v:Remove()
	end
end)

hook("InitPostEntity", function()
	//Material('logos/sup'):SetTexture('$basetexture',Material('models/debug/debugwhite'):GetTexture('$basetexture'))
	LocalPlayer():ConCommand("stopsound; cl_updaterate 16; cl_cmdrate 16; mem_max_heapsize 2048; datacachesize 512; mem_min_heapsize 512; hud_quickinfo 0; mat_specular 1")
	timer.Simple(10, function()
		for k, v in pairs(rp.cfg.MaterialOverride[game.GetMap()] or {}) do
			timer.Simple(k, function()
				wmat.Create(game.GetMap()..'_override_'..k, {
					URL = v[2],
					W 	= 1000,
					H 	= 1000,
				}, function(material)
					Material(v[1]):SetTexture('$basetexture',material:GetTexture('$basetexture'))
				end)
			end)
		end
	end)
end)


local GUIToggled = false
local mouseX, mouseY = ScrW() / 2, ScrH() / 2
function GM:ShowSpare1()
	if LocalPlayer():IsBanned() then return end
	GUIToggled = not GUIToggled

	if GUIToggled then
		gui.SetMousePos(mouseX, mouseY)
	else
		mouseX, mouseY = gui.MousePos()
	end
	gui.EnableScreenClicker(GUIToggled)
end

local FKeyBinds = {
	["gm_showhelp"] = "ShowHelp",
	["gm_showteam"] = "ShowTeam",
	["gm_showspare1"] = "ShowSpare1",
	["gm_showspare2"] = "ShowSpare2"
}

function GM:PlayerBindPress(ply, bind, pressed)
	if LocalPlayer():IsBanned() then return end
	local bnd = string.match(string.lower(bind), "gm_[a-z]+[12]?")
	if bnd and FKeyBinds[bnd] and GAMEMODE[FKeyBinds[bnd]] then
		GAMEMODE[FKeyBinds[bnd]](GAMEMODE)
	end
	return
end