-- "gamemodes\\rp_base\\gamemode\\addons\\characters\\main_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
local net_Start, net_SendToServer, net_WriteBool, net_WriteUInt, net_WriteString, net_WriteType = net.Start, net.SendToServer, net.WriteBool, net.WriteUInt, net.WriteString, net.WriteType;
local table_GetKeys, table_remove = table.GetKeys, table.remove;
local ipairs = ipairs;


rp.CharacterSystem.RequestRandomName = function()
    net_Start( rp.CharacterSystem.NetworkString );
        net_WriteUInt( NET_CHARSYSTEM_REQNAME, 3 );
    net_SendToServer();
end


rp.CharacterSystem.SelectCharacter = function( id )
    net_Start( rp.CharacterSystem.NetworkString );
        net_WriteUInt( NET_CHARSYSTEM_SELECT, 3 );
        net_WriteUInt( id, 3 );
    net_SendToServer();
end


rp.CharacterSystem.RegisterCharacter = function( namedata, chardata )
    net_Start( rp.CharacterSystem.NetworkString );
        net_WriteUInt( NET_CHARSYSTEM_REGISTER, 3 );
        net_WriteString( namedata[1] );
        net_WriteString( namedata[2] );

        if chardata then
            net_WriteBool( true );

            local k_cData = table_GetKeys( chardata );
            net_WriteUInt( #k_cData, 8 );

            for _, cData_Key in ipairs( k_cData ) do
                local cData_Value = chardata[cData_Key];

                net_WriteString( cData_Key );
                net_WriteType( cData_Value );
            end
        end
    net_SendToServer();
end


rp.CharacterSystem.DeleteCharacter = function( id )
    table_remove( rp.CharacterSystem.Characters, id );

    net_Start( rp.CharacterSystem.NetworkString );
        net_WriteUInt( NET_CHARSYSTEM_DELETE, 3 );
        net_WriteUInt( id, 3 );
    net_SendToServer();
end


rp.CharacterSystem.RequestMenu = function()
    rp.CharacterSystem.Characters = {};

    net_Start( rp.CharacterSystem.NetworkString );
        net_WriteUInt( NET_CHARSYSTEM_REQUEST, 3 );
    net_SendToServer();
end


rp.CharacterSystem.OpenMenu = function()
    local RootFrame = vgui.Create( "EditablePanel" );
    RootFrame:SetSize( ScrW(), ScrH() );
    RootFrame:Center();
    RootFrame:MakePopup();
    RootFrame:SetAlpha( 0 );
    RootFrame:AlphaTo( 255, 0.25 );
    RootFrame:MoveToFront();

    if IsValid( g_CharacterMenu ) then g_CharacterMenu:Close(); end

    g_CharacterMenu = vgui.Create( "rpui.CharacterSelector", RootFrame );
    g_CharacterMenu:Dock( FILL );
    g_CharacterMenu:InvalidateParent( true );
    g_CharacterMenu:InvalidateLayout( true );
end