-- "gamemodes\\rp_base\\gamemode\\main\\cosmetics\\appearance\\appearance_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
--[[
local function ShowAppearanceJobMenu()
	local root = vgui.Create( "ui_frame" );
	root:SetSize( ScrW()*0.75, ScrH()*0.75 );
	root:Center();
	root:MakePopup();
	root:SetSkin("SUP");

	root.JobsList = vgui.Create( "rp_jobslist", root );
	root.JobsList:SetPos(50, 50)
	root.JobsList:SetSize(500, 500)
	root.JobsList:SetFaction( FACTION_COMBINES );
end


local function ShowAppearanceMenu()
	local root = vgui.Create( "ui_frame" );
	root:SetSize( ScrW()*0.75, ScrH()*0.75 );
	root:Center();
	root:MakePopup();
	root:SetSkin("SUP");

	root.AppearanceMenu = vgui.Create( "rp_appearancemenu", root );
end


concommand.Add( "AppearanceJobMenu", ShowAppearanceJobMenu );
concommand.Add( "AppearanceMenu", ShowAppearanceMenu );
]]--