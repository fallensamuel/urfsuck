-- "gamemodes\\rp_base\\gamemode\\main\\menus\\f4menu\\init_jobslist_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
hook.Add( "ConfigLoaded", "rpui.InitializeJobsList", function()
    rp._oldOpenEmployerMenu = rp._oldOpenEmployerMenu or rp.OpenEmployerMenu;

    function rp.OpenEmployerMenu( f, factionSelect, forcedFaction )
        if rpui.EnableUIRedesign or rpui.DebugMode then
            local EmployerMenu = vgui.Create( "DPanel", vgui.GetWorldPanel() );
            EmployerMenu:SetPaintBackground( false );
            EmployerMenu:SetSize( ScrW(), ScrH() );
            EmployerMenu:Center();
            EmployerMenu:MakePopup();

            rpui.EnableFactionGroupsUI = not forcedFaction
				
            EmployerMenu.JobsList = vgui.Create( "rpui.JobsList", EmployerMenu );
            EmployerMenu.JobsList.Dock( EmployerMenu.JobsList, FILL );
            EmployerMenu.JobsList.InvalidateParent( EmployerMenu.JobsList, true );
            EmployerMenu.JobsList.OnCreated = function( self )
                if not forcedFaction then
                    self:SelectFactionGroup( rp.Factions[LocalPlayer():GetFaction()].group or 1, LocalPlayer():GetFaction() );
                else
                    self:SetFaction( f, factionSelect );
                end
            end
			
			return EmployerMenu.JobsList
        else
            rp._oldOpenEmployerMenu( f );
        end
    end
end );
