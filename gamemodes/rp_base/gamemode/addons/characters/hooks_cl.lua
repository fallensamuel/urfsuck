-- "gamemodes\\rp_base\\gamemode\\addons\\characters\\hooks_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add( "InitPostEntity", "rp.CharacterSystem::RequestCharacters", function()
    rp.CharacterSystem.RequestMenu();
end );


hook.Add( "PopulateNewF4Tabs", "rp.CharacterSystem.F4Menu", function( F4Menu )
	if LocalPlayer():GetMaxCharacters() > 1 then
		F4Menu:AddTab( translates.Get("Персонажи"), function()
			rp.CharacterSystem.RequestMenu();
			F4Menu:Close();
		end );
    end
end );

hook.Add( "PlayerCharacterSelected", "rp.CharacterMenu.Close", function()
	if not IsValid( g_CharacterMenu ) then return end
	g_CharacterMenu:Close();
end );