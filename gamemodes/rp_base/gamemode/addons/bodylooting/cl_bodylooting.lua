-- "gamemodes\\rp_base\\gamemode\\addons\\bodylooting\\cl_bodylooting.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
if game.IsTestServer then
    concommand.Add( "~bodyloot", function()
        net.Start( "BodyLooting::Start" );
            net.WriteEntity( LocalPlayer():GetEyeTrace().Entity );
        net.SendToServer();
    end );
end

hook.Add( "BodyLooting::PrepareModel", "CustomRender", function( info, ... )
    local cr = rp.cfg.BodyLooting.CustomRender[info];

    if cr then
        return cr( ... );
    end
end );

net.Receive( "BodyLooting::Menu", function()
    if canOpenInteractMenu() and not IsValid( menu_frame ) then
        local target = net.ReadEntity();
        if not IsValid( target ) then return end

        local contents = {
            {
                text = translates.Get( "Поднять" ),
                material = Material( "ping_system/give_heal.png", "smooth noclamp" ),
                func = function()
                    net.Start( "BodyLooting::Menu" );
                        net.WriteBool( true );
                    net.SendToServer();
                end,
            },

            {
                text = translates.Get( "Обыскать" ),
                material = Material( "ping_system/take_item.png", "smooth noclamp" ),
                func = function()
                    net.Start( "BodyLooting::Menu" );
                    net.SendToServer();

                    net.Start( "BodyLooting::Start" );
                        net.WriteEntity( target );
                    net.SendToServer();
                end,
            }
        };

        -- table.Add( contents, PIS.Config.PlayerIteractButtons or {} );

        menu_frame = _NexusPanelsFramework:Call( "Create", "PIS.Radial" );
        menu_frame.KeyCode = KEY_E;
        menu_frame.SelectedPlayer = target;
        menu_frame:SetSize( ScrW(), ScrH() );
        menu_frame:SetPos( 0, 0 );
        menu_frame:SetCustomContents( contents );
    end
end );