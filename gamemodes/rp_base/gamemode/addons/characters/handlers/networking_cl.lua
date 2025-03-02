-- "gamemodes\\rp_base\\gamemode\\addons\\characters\\handlers\\networking_cl.lua"
-- Retrieved by https://github.com/lewisclark/glua-steal
----------------------------------------------------------------
rp.CharacterSystem.NetworkHandlers = rp.CharacterSystem.NetworkHandlers or {};

net.Receive( rp.CharacterSystem.NetworkString, function()
    local NetworkHandler = (rp.CharacterSystem.NetworkHandlers or {})[net.ReadUInt(3)];
    if NetworkHandler then NetworkHandler( ply ); end
end );
----------------------------------------------------------------


rp.CharacterSystem.NetworkHandlers[NET_CHARSYSTEM_CHARACTER] = function()
    local cData_Count = net.ReadUInt( 8 );
    if cData_Count > 0 then
        local character = {};

        for cData_idx = 1, cData_Count do
            local cData_Key   = net.ReadString();
            local cData_Value = net.ReadType();

            character[cData_Key] = cData_Value;
        end

        table.insert( rp.CharacterSystem.Characters, character );
        hook.Run( "PlayerCharacterLoaded", character );
    end
end


rp.CharacterSystem.NetworkHandlers[NET_CHARSYSTEM_REQUEST] = function()
    rp.CharacterSystem.OpenMenu();
end


rp.CharacterSystem.NetworkHandlers[NET_CHARSYSTEM_REGISTER] = function()
    local status, errCode = net.ReadBool();
    
    if not status then
        errCode = net.ReadUInt( 3 );
    end

    hook.Run( "PlayerCharacterRegistration", status, errCode );
end


rp.CharacterSystem.NetworkHandlers[NET_CHARSYSTEM_SELECT] = function()
    local id = net.ReadUInt( 3 );

    LocalPlayer().i_CharacterID = id;

    hook.Run( "PlayerCharacterSelected", id );
end


rp.CharacterSystem.NetworkHandlers[NET_CHARSYSTEM_REQNAME] = function()
    local name = net.ReadString();
    hook.Run( "PlayerCharacterRandomName", name );
end